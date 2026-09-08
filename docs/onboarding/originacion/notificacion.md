# Notificación OTP originación (Onboarding)

> **Estado:** contrato. Ruta **no** está en `config/routes.rb`. Copia funcional de `POST /api/notificacion_canal` (`InvictusController#notificacion_canal`). Cupo fijo. **No** llamar la URL Invictus.

Mapa: [Flujo](../flujo.md) · [Originación](index.md).

## Resumen
Envía OTP de originación (SMS / email / WhatsApp). OTP ya existe en el `Formulario` Onboarding (generado en `informacion_basica` o al crear solicitud). Al menos un canal = `1`.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/onboarding/notificacion_canal`
- **Testing**: `https://testing-sygma.com/api/onboarding/notificacion_canal`
- **Producción**: `POR DEFINIR`

## Autenticación
JWT Bearer de `POST /api/onboarding/autenticar`. 401: `{ "status": "error", "mensaje": "Token de autorización inválido o ausente" }`.

## Headers
`Authorization: Bearer <token>` · `Accept: application/json` · `Content-Type: application/json`

## Request

| Campo | Tipo | Requerido | Descripción |
|------|------|-----------|-------------|
| guid | string | sí | `transaction_id_teseo` de `informacion_basica`. |
| sms | integer | condicional | `1` envía, `0` no. |
| email | integer | condicional | `1` / `0`. |
| whatsapp | integer | condicional | `1` / `0`. |

Al menos un canal = `1`.

```json
{
  "guid": "959ed262dc803739a937",
  "sms": 1,
  "email": 1,
  "whatsapp": 0
}
```

## Proceso interno
1. Busca `Formulario` por `guid` + `portafolio_id` + `tipo` Onboarding (no `INVICTUS`).
2. Si ya envió: límites `InvictusOtpReenvioLimite` o error “ya enviadas”.
3. Persiste `opc_sms` / `opc_email` / `opc_whatsapp`.
4. Envía: SMS `WssmsController`, email Sygmail, WhatsApp Wolbox conector `6718`.
5. Si ≥1 canal OK: `notificacion_enviada = 1`.

## Responses

### 200
```json
{
  "status": "success",
  "mensaje": "Notificaciones Envidados con Exito.",
  "canales_enviados": ["sms", "email"],
  "guid": "959ed262dc803739a937"
}
```
Typo **Envidados** = código Invictus. **Siguiente:** [validar_otp](validar_otp.md).

### 422
Ya enviada / sin canal / cooldown / todos los canales fallaron → [reenviar_otp](reenviar_otp.md).

### 404
`guid` no existe (o es Invictus).

## Flujo anterior
[informacion_basica](informacion_basica.md) con `guid`.

## Flujo posterior
[validar_otp](validar_otp.md). Si no llega: [reenviar_otp](reenviar_otp.md).
