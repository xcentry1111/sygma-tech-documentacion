# OTP desembolso (Onboarding)

> **Estado:** contrato. Ruta **no** en `routes.rb`. Copia de `POST /api/validacion_otp_desembolso`. **No** retorna líneas.

Mapa: [Flujo](../flujo.md) · [Desembolso](index.md).

## Resumen
Valida OTP de desembolso. OTP queda `VALIDADO`. Líneas: [seleccionar_linea_credito](linea_credito.md).

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/onboarding/validacion_otp_desembolso`
- **Testing**: `https://testing-sygma.com/api/onboarding/validacion_otp_desembolso`

## Autenticación
JWT Bearer (`/api/onboarding/autenticar`).

## Request

| Campo | Tipo | Requerido |
|------|------|-----------|
| tiposdocumento_id | string | sí |
| identificacion | string | sí |
| codigo_otp | string | sí |
| guid | string | sí |

```json
{
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "codigo_otp": "202023",
  "guid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
}
```

## Proceso interno
TTL default **3 min**. Intentos `total_intentos_otp_desembolso` (3) → `BLOQUEADO`. Compara código. OK → `VALIDADO`. No lista líneas. No desembolsar.

## Responses (HTTP 200)

| `status` | Acción |
|----------|--------|
| `success` | [linea_credito](linea_credito.md) |
| `invalid` | Reintento |
| `expired` / `blocked` | Reiniciar desde crédito vigente o [reenvio](reenvio_otp_desembolso.md) |
| `already_validated` / `already_disbursed` | No revalidar |

```json
{
  "status": "success",
  "datos": {
    "guid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "mensaje": "Codigo OTP validado correctamente. Credito autorizado para desembolso."
  }
}
```

## Flujo anterior
[crédito vigente](credito_vigente.md).

## Flujo posterior
[seleccionar_linea_credito](linea_credito.md).
