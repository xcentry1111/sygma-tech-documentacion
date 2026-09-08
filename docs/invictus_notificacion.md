# Notificación OTP originación (`notificacion_canal`)

## Resumen
Envía el OTP de originación por SMS, email y/o WhatsApp. El OTP ya existe en el `Formulario` (generado en `ori_invictus`). Al menos un canal debe ir en `1`.

Mapa: [Flujo Invictus](invictus_flujo.md).

## Objetivo
Entregar el código al cliente para `validar_otp`.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/notificacion_canal`
- **Controller**: `Api::InvictusController#notificacion_canal`
- **Ambientes**:
  - **Testing**: `https://testing-sygma.com/api/notificacion_canal`
  - **Producción**: `POR DEFINIR`

## Autenticación
JWT Bearer (`Authorization: Bearer <token>`). 401 igual que el resto Invictus.

## Headers
- **Authorization**: `Bearer <token>`
- **Accept**: `application/json`
- **Content-Type**: `application/json`

## Request

### Campos
| Campo | Tipo | Requerido | Descripción |
|------|------|-----------|-------------|
| guid | string | sí | `transaction_id_teseo` de `ori_invictus`. |
| sms | integer | condicional | `1` envía, `0` no. |
| email | integer | condicional | `1` / `0`. |
| whatsapp | integer | condicional | `1` / `0`. |

Al menos un canal = `1`. El código hace `params.require(:guid)`; los canales no son `require` pero sin ninguno → 422.

### Ejemplo
```json
{
  "guid": "959ed262dc803739a937",
  "sms": 1,
  "email": 1,
  "whatsapp": 0
}
```

## Proceso interno
1. Busca `Formulario` por guid + 10053 + INVICTUS.
2. Si `notificacion_enviada` ya es 1: aplica `InvictusOtpReenvioLimite` (cooldown 30 min / reset de ronda) o error “ya enviadas”.
3. Persiste `opc_sms` / `opc_email` / `opc_whatsapp`.
4. Envía: SMS `WssmsController`, email Sygmail OTP Credintegral, WhatsApp `WswolboxsController` conector `6718`.
5. Si ≥1 canal OK: `notificacion_enviada = 1`, `reenvios_otp = max(actual, 1)`.

**No valida** `estado_invictus` (puede ejecutarse con formulario no `PENDIENTE`).

## Servicios que consume
`InvictusOtpReenvioLimite`, SMS, Sygmail, Wolbox WhatsApp, `Formulario`.

## Responses

### 200 — Enviado
```json
{
  "status": "success",
  "mensaje": "Notificaciones Envidados con Exito.",
  "canales_enviados": ["sms", "email"],
  "guid": "959ed262dc803739a937"
}
```
Typo **Envidados** está en el código. **Siguiente:** `POST /api/validar_otp`.

### 422 — Ya enviada / sin canal / cooldown / todos los canales fallaron
Usar `POST /api/reenviar_otp` si el OTP ya salió y sigue en ventana. Si cooldown: esperar N minutos y volver a `notificacion_canal`.

### 404
`guid` no existe.

### 401 / 500
Token / error interno.

## Flujo anterior
`POST /api/ori_invictus` con `guid` (camino `PENDIENTE`).

## Flujo posterior
`validar_otp`. Si no llegó el código: `reenviar_otp`.

## Notas
- El primer envío cuenta como reenvío #1 (`reenvios_otp`).
- Tras 30 min de la última sesión, puede abrir ronda nueva (`reset_ronda_otp_notificacion!`).

## Changelog
- **2026-08-26**: Alineado a `notificacion_canal` en código.
