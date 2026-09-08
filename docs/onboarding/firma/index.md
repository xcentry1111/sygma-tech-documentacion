# Firma Onboarding (cupo fijo)

Mapa: [Flujo completo](../flujo.md). Fuente: `Api::InvictusFirmaController` rama DIGITAL. PDFs de rotativo **no** se generan aquí.

Entrada: `estado = APROBADO_PENDIENTE_FIRMA`. Salida OK: `APROBADO` → [Desembolso](../desembolso/index.md).

## Orden

```
validacion_firma_digital → validacion_otp_firma → desembolso
           ↘ reenvio_otp_firma ↗
```

| API | Ruta | Código |
|-----|------|--------|
| [Validación firma](validacion_firma_digital.md) | `POST /api/onboarding/validacion_firma_digital` | No |
| [OTP firma](otp_firma.md) | `POST /api/onboarding/validacion_otp_firma` | No |
| [Reenvío OTP firma](reenvio_otp_firma.md) | `POST /api/onboarding/reenvio_otp_firma` | No |

Anterior: [Originación](../originacion/index.md).
