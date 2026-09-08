# Crédito vigente para desembolso (Onboarding)

> **Estado:** contrato. Ruta **no** en `routes.rb`. Copia de `POST /api/validacion_credito_vigente`. DIGITAL puede seguir **sin Persona**.

Mapa: [Flujo](../flujo.md) · [Desembolso](index.md).

## Resumen
Valida cupo fijo usable (`APROBADO`) y envía OTP de desembolso.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/onboarding/validacion_credito_vigente`
- **Testing**: `https://testing-sygma.com/api/onboarding/validacion_credito_vigente`

## Autenticación
JWT Bearer (`/api/onboarding/autenticar`).

## Request

| Campo | Tipo | Requerido |
|------|------|-----------|
| tiposdocumento_id | string | sí |
| identificacion | string | sí |

```json
{
  "tiposdocumento_id": "1",
  "identificacion": "88282828"
}
```

## Proceso interno
`InvictusDesembolsoElegibilidadService` (mora, DIGITAL, expiración 181 días no migrado). `EN_VERIFICACION` → `pending_identity`. Firma pendiente → `pending_signatures`. Éxito: `Validacionesotp` + envío OTP. Canales ofuscados.

## Responses (HTTP 200; mirar `status`)

| `status` | Siguiente |
|----------|-----------|
| `success` + `datos.guid` | [otp_desembolso](otp_desembolso.md) |
| `pending_signatures` | [Firma](../firma/index.md) |
| `pending_identity` | [Truora](../originacion/truora_kyc.md) |
| `no_credit` / `credit_blocked` / `expired` / `already_disbursed` | Stop o nueva originación |

### 200 success
```json
{
  "status": "success",
  "datos": {
    "guid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "canales_envio": {
      "sms": "300 *** ** 67",
      "email": "ana****@example.com"
    },
    "mensaje": "Crédito validado con exito!!!."
  }
}
```

UI muestra ofuscados. No des-ofuscar.

## Flujo anterior
[OTP firma](../firma/otp_firma.md) → `APROBADO`.

## Flujo posterior
[otp_desembolso](otp_desembolso.md) o [reenvio](reenvio_otp_desembolso.md).
