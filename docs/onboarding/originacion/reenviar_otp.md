# Reenviar OTP originación (Onboarding)

> **Estado:** contrato. Ruta **no** en `routes.rb`. Copia de `POST /api/reenviar_otp`.

Mapa: [Flujo](../flujo.md) · [Originación](index.md).

## Resumen
OTP nuevo por canales ya guardados (`opc_*`). Tope 3 reenvíos, ~60 s entre envíos, cooldown 30 min.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/onboarding/reenviar_otp`
- **Testing**: `https://testing-sygma.com/api/onboarding/reenviar_otp`

## Autenticación
JWT Bearer (`/api/onboarding/autenticar`).

## Request

| Campo | Tipo | Requerido |
|------|------|-----------|
| guid | string | sí |

```json
{
  "guid": "959ed262dc803739a937"
}
```

## Proceso interno
1. `Formulario` Onboarding por guid. Debe tener `opc_*`.
2. Params: `max_reenvios_otp_invictus` (3), `tiempo_minimo_reenvio_otp_segundos` (60), `cooldown_reenvio_otp_minutos` (30).
3. `InvictusOtpReenvioLimite.decidir`.
4. Nuevo OTP → mismos canales.

## Responses
- **200**: reenviado + `reenvios_restantes`. Siguiente: [validar_otp](validar_otp.md) con código **nuevo**.
- **422**: cooldown, espera mínima, sin canales, fallo envío.
- **404**: guid inexistente.

## Flujo anterior
[notificacion_canal](notificacion.md).

## Flujo posterior
[validar_otp](validar_otp.md).
