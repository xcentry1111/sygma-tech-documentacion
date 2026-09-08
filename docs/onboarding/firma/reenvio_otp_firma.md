# Reenvío OTP firma (Onboarding)

> **Estado:** contrato. Ruta **no** en `routes.rb`. Copia de `POST /api/reenvio_otp_firma`. **Mismo guid** (no rota).

Mapa: [Flujo](../flujo.md) · [Firma](index.md).

## Resumen
Nuevo código de firma sobre el mismo `guid`. Reset `intentos_fallidos`. Máx 3 reenvíos, 60 s, cooldown 30 min.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/onboarding/reenvio_otp_firma`
- **Testing**: `https://testing-sygma.com/api/onboarding/reenvio_otp_firma`

## Autenticación
JWT Bearer (`/api/onboarding/autenticar`).

## Request

| Campo | Tipo | Requerido |
|------|------|-----------|
| guid | string | sí |
| identificacion | string | sí |

```json
{
  "guid": "a1b2c3d4-uuid",
  "identificacion": "88282828"
}
```

`identificacion` debe coincidir con el `Formulario` Onboarding ligado al OTP.

## Proceso interno
1. OTP + identidad. Si ya `VALIDADO` → no reenvía.
2. Límites `InvictusOtpReenvioLimite`.
3. Nuevo código, mismos `opc_*`, mismo guid, `PENDIENTE`.

## Responses
`status` string `success` / `error`. HTTP 200 negocio.

**Siguiente OK:** [otp_firma](otp_firma.md) con **mismo** guid y código nuevo.

## Flujo anterior
[validacion_firma_digital](validacion_firma_digital.md).

## Flujo posterior
[otp_firma](otp_firma.md).
