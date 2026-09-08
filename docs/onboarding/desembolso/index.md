# Desembolso Onboarding (cupo fijo)

Mapa: [Flujo completo](../flujo.md). Fuente: `Api::InvictusDesembolsoController` + `InvictusDigitalLineaService`.

Solo línea `RIS CUPO FIJO` (`monto_fijo: SI`). `valor_total` = cupo asignado exacto. Cálculo: `PlaneshsimulaCreditoService`. Pipeline: `Datostecfinanza` + PRC. Irreversible.

## Orden

```
validacion_credito_vigente → validacion_otp_desembolso → seleccionar_linea_credito
              ↘ reenvio_otp_desembolso ↗
→ calcular_desembolso (opcional) → proceso_desembolso
```

| API | Ruta | Código |
|-----|------|--------|
| [Crédito vigente](credito_vigente.md) | `POST /api/onboarding/validacion_credito_vigente` | No |
| [OTP desembolso](otp_desembolso.md) | `POST /api/onboarding/validacion_otp_desembolso` | No |
| [Reenvío OTP desembolso](reenvio_otp_desembolso.md) | `POST /api/onboarding/reenvio_otp_desembolso` | No |
| [Línea](linea_credito.md) | `POST /api/onboarding/seleccionar_linea_credito` | No |
| [Cálculo](calcular_desembolso.md) | `POST /api/onboarding/calcular_desembolso` | No |
| [Proceso](proceso_desembolso.md) | `POST /api/onboarding/proceso_desembolso` | No |

Anterior: [Firma](../firma/index.md). Cotización previa (no es este paso): [simular](../originacion/simular.md).
