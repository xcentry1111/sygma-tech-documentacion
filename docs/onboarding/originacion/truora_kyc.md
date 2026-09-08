# Truora KYC (Onboarding)

> **Estado:** contrato. Webhook **no** existe aún. Copia de `truora/webhook_invictus` para `Formulario` Onboarding. Cliente **no** llama este endpoint.

Mapa: [Flujo](../flujo.md) · [Originación](index.md). Invictus: [Truora KYC](../../invictus_truora_kyc.md).

## Resumen
Cierre asíncrono cuando `validar_otp` deja `EN_VERIFICACION`. Sin este paso **no hay firma**.

## Endpoint
- **Método**: `POST`
- **Ruta**: `truora/webhook_onboarding`
- Auth propia Truora. **Sin** JWT Onboarding.

## Cuándo
Tras [validar_otp](validar_otp.md) con `experian_status: EN_VERIFICACION`. TESEO inicia `InvictusTruoraService` (filtrar tipo Onboarding). Resultado entra por webhook.

## Efectos

| Resultado Truora | Estado | Siguiente |
|------------------|--------|-----------|
| succeeded | `APROBADO_PENDIENTE_FIRMA` | [Firma](../firma/validacion_firma_digital.md) |
| fraude / cruce / 3 intentos | `RECHAZADO` | Stop. Cooldown |
| fallo técnico | sigue `EN_VERIFICACION` | Completar KYC |

## Flujo anterior
[validar_otp](validar_otp.md).

## Flujo posterior
[validacion_firma_digital](../firma/validacion_firma_digital.md). Firma **no** llama Truora; si sigue `EN_VERIFICACION` responde `pending_identity`.
