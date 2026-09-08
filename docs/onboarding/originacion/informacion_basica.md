# Información básica Onboarding

## Resumen
Crea o actualiza un `Formulario` de Onboarding (no Invictus). Campos habilitados/obligatorios salen de `parametros` del `portafolio_id` del JWT. Devuelve `id` y `guid` (`transaction_id_teseo`).

Mapa: [Flujo Onboarding](../flujo.md). Carpeta: [Originación](index.md). Equivalente Invictus recortado: [Originación `ori_invictus`](../../invictus_originacion_import.md). Este endpoint **no** consulta listas, Experian, mora ni genera OTP.

## Objetivo
Registrar datos de identidad y contacto para el flujo Onboarding, reutilizando la tabla `formularios` con otro `tipo`.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/onboarding/informacion_basica`
- **Controller**: `Api::OnboardingController#informacion_basica`
- **Ambientes**:
  - **Testing**: `https://testing-sygma.com/api/onboarding/informacion_basica`
  - **Producción**: `POR DEFINIR`

## Autenticación
- **Tipo**: JWT Bearer (`POST /api/onboarding/autenticar`)
- **Header**: `Authorization: Bearer <token>`
- **401**: `{ "status": "error", "mensaje": "Token de autorización inválido o ausente" }` (ver [Autenticar](autenticar.md))

## Headers
- **Authorization**: `Bearer <token>` (obligatorio)
- **Accept**: `application/json`
- **Content-Type**: `application/json`

## Request

Cuerpo en clave **`datos`**. Sin ella → 422.

Obligatoriedad exacta = CSV `onboarding_campos_obligatorios` del portafolio. La tabla abajo es el **default de código** (si no hay parámetro).

### Campos (defaults)

| Campo | Tipo | Requerido (default) | Descripción |
|------|------|---------------------|-------------|
| datos | object | sí | Wrapper. |
| datos.tiposdocumento_id | string | sí | Tipo documento. |
| datos.identificacion | string | sí | Número. Alias: `numero_identificacion`. |
| datos.fecha_nacimiento | string | sí | Fecha. No futura. |
| datos.fecha_expedicion | string | sí | Fecha. No futura. |
| datos.ciudadexpedicion_id | integer | sí | Alias: `ciudad_expedicion`. |
| datos.primer_nombre | string | sí | Alias: `nombres`. |
| datos.segundo_nombre | string | no | |
| datos.primer_apellido | string | sí | Alias: `apellidos`. |
| datos.segundo_apellido | string | no | |
| datos.celular | string | sí | Mínimo 10 dígitos (se ignoran no-dígitos al validar). |
| datos.telefono | string | no | Celular secundario. Alias: `celular_secundario`. Mismo mínimo 10 si viene. |
| datos.email | string | sí | Regex email. |

Solo se persisten claves listadas en `onboarding_campos_habilitados`. El resto del JSON se ignora.

### Ejemplo
```json
{
  "datos": {
    "tiposdocumento_id": "1",
    "identificacion": "1234567890",
    "fecha_nacimiento": "1990-01-15",
    "fecha_expedicion": "2008-03-20",
    "ciudadexpedicion_id": 1,
    "primer_nombre": "ANA",
    "segundo_nombre": "MARIA",
    "primer_apellido": "PEREZ",
    "segundo_apellido": "GOMEZ",
    "celular": "3001234567",
    "telefono": "3109876543",
    "email": "ana.perez@example.com"
  }
}
```

Con aliases:

```json
{
  "datos": {
    "tiposdocumento_id": "1",
    "numero_identificacion": "1234567890",
    "fecha_nacimiento": "1990-01-15",
    "fecha_expedicion": "2008-03-20",
    "ciudad_expedicion": 1,
    "nombres": "ANA",
    "apellidos": "PEREZ",
    "celular": "3001234567",
    "celular_secundario": "3109876543",
    "email": "ana.perez@example.com"
  }
}
```

## Proceso interno (orden real)

1. JWT → portafolio. Si no configurado → 422.
2. Si falta clave `datos` → 422.
3. Normaliza aliases (`numero_identificacion` → `identificacion`, etc.).
4. Si CSV habilitados vacío → 422.
5. Extrae solo campos habilitados.
6. Faltantes vs CSV obligatorios → 422 con lista entre paréntesis.
7. Formato: email, celular ≥ 10 dígitos, teléfono ≥ 10 si presente, fechas parseables y no futuras.
8. Busca `Formulario` con `portafolio_id` + `tipo` (param `onboarding_formulario_tipo`, default `ONBOARDING`) + `identificacion`. Toma el de `id` más alto.
9. Si no hay: `Formulario.new` y asigna `transaction_id_teseo` = `SecureRandom.hex(10)`.
10. Si hay: actualiza atributos. Si el `guid` estaba vacío, lo genera.
11. Fija `user_id` del JWT y `origen_solicitud: "ONBOARDING API"`.
12. `save(validate: false)` — no corre validadores Credintegral de 10053.
13. Si `save` falla → 422 registro error.

No escribe `estado_invictus`. No llama listas/Experian. No genera OTP.

## Servicios / componentes

- `Onboarding::InformacionBasicaService`
- `Onboarding::ConfiguracionPortafolio`
- Modelo `Formulario`

## Responses

### 200 OK (alta o update)
```json
{
  "status": "success",
  "datos": {
    "id": 99,
    "guid": "guidonb1",
    "tipo": "ONBOARDING",
    "portafolio_id": 10053,
    "identificacion": "1234567890",
    "mensaje": "La información fue registrada correctamente."
  },
  "errors": []
}
```

Si el portafolio tiene `onboarding_formulario_tipo = DIGITAL`, `datos.tipo` será `"DIGITAL"` (caso 10053 en OpenAPI).

**Siguiente hoy:** guardar `guid`. No hay siguiente endpoint Onboarding. No usar este `guid` en APIs Invictus (`notificacion_canal`, firma, desembolso).

## Errores comunes

### 422 — falta `datos`
```json
{
  "status": "error",
  "datos": {},
  "errors": ["Body inválido: falta la clave 'datos'"]
}
```

### 422 — campo obligatorio
```json
{
  "status": "error",
  "datos": {},
  "errors": ["Faltan campos obligatorios. (identificacion, email, ...)"]
}
```

### 422 — formato
Mensajes concatenados con ` | ` si hay varios:

```json
{
  "status": "error",
  "datos": {},
  "errors": ["email inválido"]
}
```

Otros textos de código: `celular debe tener al menos 10 dígitos`, `celular_secundario / telefono debe tener al menos 10 dígitos`, `fecha_nacimiento inválida`, `fecha_nacimiento no puede ser futura` (igual para `fecha_expedicion`).

### 422 — persistencia
```json
{
  "status": "error",
  "datos": {},
  "errors": ["No fue posible registrar la información."]
}
```

### 422 — portafolio
```json
{
  "status": "error",
  "datos": {},
  "errors": ["El portafolio del usuario no está configurado para onboarding."]
}
```

### 401
Ver Autenticación.

### 500
```json
{
  "status": "error",
  "datos": {},
  "errors": ["Error interno"]
}
```

## Flujo anterior
`POST /api/onboarding/autenticar`. Opcional: `POST /api/onboarding/simular` (el registro **no** recibe monto/plazo).

## Flujo posterior
Contrato: [Notificación OTP](notificacion.md) con el `guid`. Hoy esa ruta **no** está en `routes.rb`. No usar `/api/notificacion_canal` de Invictus.

## Notas / Consideraciones
- Update: misma `identificacion` + mismo `tipo` + mismo `portafolio_id` reescribe la fila más reciente. No crea duplicado.
- Aislamiento Invictus: query incluye `tipo`. Una cédula con solicitud `INVICTUS` no se actualiza desde aquí.
- Código **no** fuerza `tiposdocumento_id = "1"` (Invictus sí). Si el CSV lo exige, falta el campo; el valor `"1"` vs otros no se valida aquí.
- Mensaje de éxito parametrizable: `onboarding_msg_registro_ok`.

## Changelog
- **2026-09-08**: Alineado a `Onboarding::InformacionBasicaService` y `Api::OnboardingInformacionBasicaTest`.
