# Reenviar OTP originación (`reenviar_otp`)

## Resumen
Genera un OTP nuevo y lo envía por los canales ya guardados (`opc_sms` / `opc_email` / `opc_whatsapp`). Tope default 3 reenvíos, mínimo ~60 s entre envíos, cooldown 30 min.

Mapa: [Flujo Invictus](invictus_flujo.md).

## Objetivo
Reponer el código si no llegó, expiró para el usuario, o falló `validar_otp`.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/reenviar_otp`
- **Controller**: `Api::InvictusController#reenviar_otp`
- **Ambientes**:
  - **Testing**: `https://testing-sygma.com/api/reenviar_otp`
  - **Producción**: `POR DEFINIR`

## Autenticación
JWT Bearer.

## Headers
- **Authorization**: `Bearer <token>`
- **Accept**: `application/json`
- **Content-Type**: `application/json`

## Request

| Campo | Tipo | Requerido | Descripción |
|------|------|-----------|-------------|
| guid | string | sí | Mismo guid de originación. |

### Ejemplo
```json
{
  "guid": "959ed262dc803739a937"
}
```

## Proceso interno
1. Formulario por guid. Debe tener canales `opc_*`.
2. Parámetros 10053: `max_reenvios_otp_invictus` (3), `tiempo_minimo_reenvio_otp_segundos` (60), `cooldown_reenvio_otp_minutos` (30).
3. `InvictusOtpReenvioLimite.decidir` usando `updated_at` como ancla (no `fecha_otp`).
4. Nuevo OTP → mismos canales → `reenvios_otp++`, limpia `otp_bloqueado_hasta`.

`otp_expiracion_minutos_invictus` se lee en config de originación pero **este endpoint no expira el código por tiempo**.

## Responses

### 200 — Reenviado
Incluye `reenvios_restantes`. En el último permitido puede venir `cooldown_minutos`. **Siguiente:** `validar_otp` con el código **nuevo**.

### 422
Cooldown agotado, espera mínima, sin canales, fallo de envío.

### 404
guid inexistente.

## Flujo anterior
`notificacion_canal` exitoso (canales persistidos).

## Flujo posterior
`POST /api/validar_otp`.

## Changelog
- **2026-08-26**: Alineado a `reenviar_otp` en código.
