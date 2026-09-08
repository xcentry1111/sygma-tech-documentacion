# Validación firma digital (Onboarding)

> **Estado:** contrato. Ruta **no** en `routes.rb`. Copia de `POST /api/validacion_firma_digital`. Cupo fijo: OTP firma; **sin** PDFs rotativo.

Mapa: [Flujo](../flujo.md) · [Firma](index.md).

## Resumen
Si hay solicitud `APROBADO_PENDIENTE_FIRMA`, dispara OTP de firma. Devuelve `guid` de `Validacionesotp`.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/onboarding/validacion_firma_digital`
- **Testing**: `https://testing-sygma.com/api/onboarding/validacion_firma_digital`

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
1. `Formulario` Onboarding más reciente por doc+ident.
2. Gate por estado.
3. Si `APROBADO_PENDIENTE_FIRMA`: OTP + UUID, envío `opc_*`. Puede reservar `nro_obligacion` DIGITAL (`reservar_firma_digital!`).
4. Crea `Validacionesotp` `PENDIENTE`.

No consulta listas aquí.

## Responses (HTTP 200; mirar `status`)

| `status` | Significado | Siguiente |
|----------|-------------|-----------|
| `success` | OTP + `datos.guid` | [otp_firma](otp_firma.md) |
| `already_signed` | Ya `APROBADO` | [Desembolso](../desembolso/index.md) |
| `no_credit` / `expired` | Sin crédito / `CANCELADO` | Originación |

## Flujo anterior
[validar_otp](../originacion/validar_otp.md) APROBADO.

## Flujo posterior
[validacion_otp_firma](otp_firma.md) o [reenvio_otp_firma](reenvio_otp_firma.md).
