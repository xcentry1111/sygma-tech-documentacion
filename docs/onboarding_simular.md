# Simular Onboarding

## Resumen
Calcula crédito de cupo fijo (cuota, fianzas, desembolso, plan de pagos). **No persiste.** Misma matemática que la vista `/simulador` y que el cálculo digital Invictus: `PlaneshsimulaCreditoService` + tabla `planeshsimula`.

Mapa: [Flujo Onboarding](onboarding_flujo.md). En Invictus el cálculo API equivalente es [Cálculo desembolso](invictus-calculo-desembolso.md), pero **después** de originación/firma. Aquí ocurre **antes** de registrar al cliente.

## Objetivo
Mostrar al usuario términos (cuota, desembolso neto, plan) con los rangos del portafolio del JWT.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/onboarding/simular`
- **Controller**: `Api::OnboardingController#simular`
- **Ambientes**:
  - **Testing**: `https://testing-sygma.com/api/onboarding/simular`
  - **Producción**: `POR DEFINIR`

## Autenticación
- **Tipo**: JWT Bearer (`POST /api/onboarding/autenticar`)
- **Header**: `Authorization: Bearer <token>`
- **401** (`ApiJwtAuthenticatable`, envelope distinto):

```json
{
  "status": "error",
  "mensaje": "Token de autorización inválido o ausente"
}
```

Token expirado: `"mensaje": "Token Expirado"`. JWT malformado: `"mensaje": "Token Inválido"` (+ `details`).

## Headers
- **Authorization**: `Bearer <token>` (obligatorio)
- **Accept**: `application/json`
- **Content-Type**: `application/json`

## Request

`monto` y `plazo` pueden ir en raíz o dentro de `datos`. `cuota` es alias de `plazo` (compatibilidad con el simulador web).

#### Campos
| Campo | Tipo | Requerido | Descripción |
|------|------|-----------|-------------|
| monto | integer | sí* | Valor a simular. También `datos.monto`. |
| plazo | integer | sí* | Número de cuotas. También `datos.plazo`. |
| cuota | integer | no | Alias de `plazo`. También `datos.cuota`. |

\*Si falta o es ≤ 0 → 422.

#### Ejemplo
```json
{
  "monto": 200000,
  "plazo": 1
}
```

Alias:

```json
{
  "monto": 200000,
  "cuota": 1
}
```

## Proceso interno (orden real)

1. JWT → `@user.portafolio_id`. Si `portafolio_id` ≤ 0 → 422 (portafolio no configurado).
2. Lee `monto` / `plazo` (aliases).
3. `Onboarding::SimulacionService`:
   - `monto` y `plazo` > 0.
   - Rango: `onboarding_sim_monto_min/max`, `plazo_min/max`.
   - Step: `(monto - min) % onboarding_sim_monto_step == 0` (si step > 0).
4. `PlaneshsimulaCreditoService.calcular` — fila `planeshsimula` con `nro_cuota = '-1'` + sumas de cuotas reales.
5. Si no hay plan → 404.
6. `PlaneshsimulaCreditoService.plan_pagos` — cuotas con `nro_cuota != '-1'`.
7. Condiciones informativas: tasa EA, % fianza, % IVA, firma electrónica, estudio crédito (IDs de `parametros` configurables).
8. `fianza_anticipada` en respuesta = base + IVA (el service suma). `fianza_anticipada_base` e `iva_fianza` van aparte.

No crea ni actualiza `Formulario`. No exige que exista información básica previa.

## Servicios / componentes

- `Onboarding::ConfiguracionPortafolio`
- `Onboarding::SimulacionService`
- `PlaneshsimulaCreditoService`
- Tabla `planeshsimula`
- `Parametro` ids 54 (tasa), 60 (firma), 10940 (estudio) — configurables; fianza/IVA del plan usan params 11900 y 57 **dentro** de `PlaneshsimulaCreditoService` (globales, no del CSV Onboarding)

## Responses

### 200 OK
```json
{
  "status": "success",
  "datos": {
    "monto": 200000,
    "plazo": 1,
    "tasa_ea": 0.0,
    "valor_cuota": 180000,
    "fianza_anticipada": 11900,
    "fianza_anticipada_base": 10000,
    "iva_fianza": 1900,
    "desembolso": 188100,
    "intereses": 5000,
    "fianza_regular": 2000,
    "seguro": 800,
    "firma_electronica": 0.0,
    "estudio_credito": 0.0,
    "condiciones": {
      "tasa_ea": 0.0,
      "tarifa_fianza_pct": 5.0,
      "iva_fianza_pct": 19.0,
      "firma_electronica": 0.0,
      "estudio_credito": 0.0,
      "monto_min": 200000,
      "monto_max": 1000000,
      "monto_step": 10000,
      "plazo_min": 1,
      "plazo_max": 6
    },
    "plan_pagos": [
      {
        "nro_cuota": "1",
        "fecha_vence": "2026-10-01",
        "inicial": 200000,
        "capital": 170000,
        "interes": 5000,
        "seguro": 800,
        "finanza": 1000,
        "iva_fianza": 190,
        "plataforma": 0,
        "cuota": 180000,
        "final": 30000
      }
    ],
    "mensaje": "Simulación calculada correctamente."
  },
  "errors": []
}
```

Valores numéricos de cuota/desembolso dependen de `planeshsimula` en el ambiente. El ejemplo replica la forma del código + tests (`valor_cuota`, `desembolso`, `fianza_anticipada` = base + IVA).

**Siguiente:** mostrar términos. Luego `POST /api/onboarding/informacion_basica`. Este endpoint **no** desembolsar.

## Errores comunes

### 422 — params o rango
```json
{
  "status": "error",
  "datos": {},
  "errors": ["monto y plazo son requeridos"]
}
```

Fuera de rango (defaults 200000–1000000, plazo 1–6, step 10000):

```json
{
  "status": "error",
  "datos": {},
  "errors": ["El monto o el plazo están fuera del rango permitido."]
}
```

Portafolio del usuario en 0 / nil:

```json
{
  "status": "error",
  "datos": {},
  "errors": ["El portafolio del usuario no está configurado para onboarding."]
}
```

### 404 — sin fila en `planeshsimula`
```json
{
  "status": "error",
  "datos": {},
  "errors": ["Sin plan de simulación para el monto y plazo indicados."]
}
```

Combo típico válido en cupo fijo: `200000` / `1`. Si 404, el monto/plazo no existe en la tabla aunque pase el rango.

### 401
Ver sección Autenticación (`mensaje`, no `errors`).

### 500
```json
{
  "status": "error",
  "datos": {},
  "errors": ["Error interno"]
}
```

## Flujo anterior
`POST /api/onboarding/autenticar`.

## Flujo posterior
`POST /api/onboarding/informacion_basica` (opcional respecto a este cálculo: el body de información básica **no** lleva monto/plazo hoy).

## Notas / Consideraciones
- No es `proceso_desembolso`. No marca obligaciones. No genera OTP.
- `tasa_ea` / `firma_electronica` / `estudio_credito` salen de `Parametro.find_by(id:)` según ids configurados. Si el id no existe → `0.0`.
- Rangos y mensajes se sobreescriben con `parametros` del `portafolio_id` del JWT.

## Changelog
- **2026-09-08**: Alineado a `Onboarding::SimulacionService` y tests de `Api::OnboardingSimularTest`.
