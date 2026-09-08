# Reenvío OTP desembolso (Onboarding)

> **Estado:** contrato. Ruta **no** en `routes.rb`. Copia de `POST /api/reenvio_otp_desembolso`. Genera **nuevo guid** (distinto a firma).

Mapa: [Flujo](../flujo.md) · [Desembolso](index.md).

## Resumen
Reenvía OTP si expiró, no llegó o se agotaron intentos. Máx **5** reenvíos, 60 s, cooldown 30 min.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/onboarding/reenvio_otp_desembolso`
- **Testing**: `https://testing-sygma.com/api/onboarding/reenvio_otp_desembolso`

## Autenticación
JWT Bearer (`/api/onboarding/autenticar`).

## Request

| Campo | Tipo | Requerido |
|------|------|-----------|
| tiposdocumento_id | string | sí |
| identificacion | string | sí |
| guid | string | sí |

```json
{
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "guid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
}
```

## Proceso interno
1. Elegibilidad otra vez.
2. Si OTP `VALIDADO` → `already_validated`.
3. Nuevo código + **nuevo guid** en el registro OTP.
4. Cliente debe guardar el guid nuevo.

## Responses
- `success` → [otp_desembolso](otp_desembolso.md) con guid **nuevo**.
- `resend_limit_exceeded` → stop.
- `no_credit` / `already_validated` / 404.

## Flujo anterior
[crédito vigente](credito_vigente.md) (pantalla OTP).

## Flujo posterior
[otp_desembolso](otp_desembolso.md).
