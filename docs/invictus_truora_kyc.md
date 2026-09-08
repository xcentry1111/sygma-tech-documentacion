# Truora KYC (cierre de originación Invictus)

## Resumen
No es un servicio del catálogo Swagger Invictus. Es el **cierre asíncrono** cuando `validar_otp` deja el `Formulario` en `EN_VERIFICACION`. Truora verifica identidad; el webhook en TESEO actualiza el estado.

Sin este paso **no hay firma digital**.

## Endpoint (interno / proveedor)

- **Método**: `POST` (webhook Truora)
- **Ruta en TESEO**: `truora/webhook_invictus` (`TruoraController`)
- **No lleva** el JWT de `/api/login`. Autenticación propia del webhook Truora.

El cliente Invictus **no llama** este endpoint. Completa el flujo KYC (SMS/email/WhatsApp de Truora) y espera.

## Objetivo
Pasar de `EN_VERIFICACION` a `APROBADO_PENDIENTE_FIRMA` (éxito) o `RECHAZADO` (fraude / cruce / tope de intentos).

## Cuándo ocurre
Después de `POST /api/validar_otp` con `experian_status: EN_VERIFICACION`, o si `ori_invictus` retoma un formulario ya en KYC (HTTP 202).

TESEO llama `InvictusTruoraService.iniciar_verificacion` (alta o reenvío). El resultado entra por `InvictusTruoraService.procesar_resultado_webhook`.

## Qué procesa
- Resultado KYC Truora.
- `Formulario` portafolio 10053 tipo INVICTUS.
- Puede notificar al cliente (`InvictusNotificacionService`).

## Respuestas / efectos (no JSON hacia Invictus)

| Resultado Truora | `estado_invictus` | Qué hace Invictus después |
|------------------|-------------------|---------------------------|
| succeeded | `APROBADO_PENDIENTE_FIRMA` | `POST /api/validacion_firma_digital` |
| fraude / cruce / 3 intentos | `RECHAZADO` | No continuar. Cooldown (fraude/otros 30 días; intentos KYC 1 día en `create`) |
| fallo técnico reintentable | sigue `EN_VERIFICACION` | Completar KYC; no firma |

## Flujo anterior
`POST /api/validar_otp` (o retoma `ori_invictus` 202).

## Flujo posterior
`POST /api/validacion_firma_digital`.

## Relación con firma
`validacion_firma_digital` **no llama Truora**. Si el formulario sigue `EN_VERIFICACION` responde `pending_identity` + `guid` (`transaction_id_teseo`).

## Notas
- Documentado aquí porque cierra originación y desbloquea firma. Sin él el mapa Invictus queda incompleto.
- Fuente: `app/services/invictus_truora_service.rb`, `app/controllers/truora_controller.rb`.
