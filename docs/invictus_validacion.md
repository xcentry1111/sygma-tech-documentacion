# Validación OTP originación (`validar_otp`)

## Resumen
Valida el OTP de originación y **decide** el crédito: listas restrictivas, lista negra/blanca, elegibilidad, Experian, Truora KYC. Es el corazón de originación.

Mapa: [Flujo Invictus](invictus_flujo.md).

## Objetivo
Pasar de `PENDIENTE` a `APROBADO_PENDIENTE_FIRMA`, `EN_VERIFICACION` o `RECHAZADO` (u otros terminales).

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/validar_otp`
- **Controller**: `Api::InvictusController#validar_otp`
- **Ambientes**:
  - **Testing**: `https://testing-sygma.com/api/validar_otp`
  - **Producción**: `POR DEFINIR`

## Autenticación
JWT Bearer. `@user` se usa en `prc_crediintegral` si se crea `Persona` rotativo.

## Headers
- **Authorization**: `Bearer <token>`
- **Accept**: `application/json`
- **Content-Type**: `application/json`

## Request

| Campo | Tipo | Requerido | Descripción |
|------|------|-----------|-------------|
| otp | string | sí | Código recibido. |
| guid | string | sí | Guid del formulario. |

No enviar documento: TESEO lo saca del `Formulario`.

### Ejemplo
```json
{
  "otp": "462019",
  "guid": "959ed262dc803739a937"
}
```

## Proceso interno (orden real)

1. Si estado terminal (`APROBADO`, `APROBADO_PENDIENTE_FIRMA`, `RECHAZADO`, `CANCELADO`, …) → respuesta corta (a veces 200 “ya aprobado”, a veces 422).
2. `InvictusOtpValidacionLimite`: máx `total_intentos_otp` (default 3). Fallos en `Formularioevaluacion`.
3. Compara OTP (seguro). Mensaje “incorrecto o expirado” **sin** validar `otp_expiracion_minutos_invictus`.
4. `decision_lista_restrictiva_invictus` → `ListasrestrictivasController.consultar_externa`.
5. Lista **negra** → `RECHAZADO` + notificación.
6. Lista **blanca** → `APROBADO_PENDIENTE_FIRMA` (+ `Persona` y SPs si no es digital).
7. Elegibilidad otra vez.
8. Experian: cache 30 días / `InvictusExperianSimulacion` / `ExperianService#consultar_preselecta_invictus`.
9. Rama: `APROBADO` → firma; `RECHAZADO`; `EN_VERIFICACION` → `InvictusTruoraService.iniciar_verificacion`; sin decisión → reset `PENDIENTE` + OTP nuevo (`experian_status: REINTENTAR`).

Oracle si crea Persona rotativo: `ProcesoJob` `prc_teseo_demografico`, `prc_crediintegral(..., 'CREAROBLCUOTAMANEJO', user_id)`.

## Qué información procesa
OTP, formulario, listas, Experian (score/decisión), flags `opc_*` para notificar, datos demográficos para `Persona`.

## Responses — regla: mirar `experian_status` y `status`, no solo HTTP

### 200 — Aprobado (firma)
`status: "success"`, `experian_status: "APROBADO"`, estado `APROBADO_PENDIENTE_FIRMA`.  
**Siguiente:** `POST /api/validacion_firma_digital`.

### 200 — KYC
`experian_status: "EN_VERIFICACION"`.  
**Siguiente:** [Truora KYC](invictus_truora_kyc.md). No firma.

### 200 — Rechazado Experian
A menudo `status: "success"` + `experian_status: "RECHAZADO"`. Crédito no sigue.

### 200 — Listas / REINTENTAR
Frecuente `status: "error"` + `experian_status: RECHAZADO` o `REINTENTAR`.  
REINTENTAR: volver a `validar_otp` más tarde (puede pedir OTP de nuevo).

### 422 — OTP incorrecto / máximo intentos / terminal RECHAZADO
`intentos_restantes` si aplica. Tras 3 fallos: OTP invalidado, bloqueo ~30 min → `notificacion_canal` o `reenviar_otp`.

### 401 / 500
Token / interno.

## Flujo anterior
`notificacion_canal` (o `reenviar_otp`).

## Flujo posterior
Firma, Truora, reintento, o stop.

## Inconsistencias vs docs viejas
- Lista negra **no** responde `status: success` + “OTP válido” como crédito OK: rechaza.
- HTTP 200 + `status: error` es normal en listas.
- `REQUIERE_VERIFICACION` en docs antiguas = en código `EN_VERIFICACION` / `experian_status: EN_VERIFICACION`.

## Changelog
- **2026-08-26**: Alineado a `validar_otp` en código.
