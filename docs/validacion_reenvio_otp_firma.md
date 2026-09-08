# Reenvío OTP firma (`reenvio_otp_firma`)

## Resumen
Nuevo OTP de firma **sobre el mismo `guid`**. Resetea `intentos_fallidos`. Límites: máx 3 reenvíos, 60 s mínimo, cooldown 30 min (`InvictusOtpReenvioLimite`).

Mapa: [Flujo Invictus](invictus_flujo.md).

## Objetivo
Reponer código de firma si no llegó o expiró.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/reenvio_otp_firma`
- **Controller**: `Api::InvictusFirmaController#reenvio_otp_firma`
- **Ambientes**:
  - **Testing**: `https://testing-sygma.com/api/reenvio_otp_firma`
  - **Producción**: `POR DEFINIR`

## Autenticación
JWT Bearer.

## Request

| Campo | Tipo | Requerido | Descripción |
|------|------|-----------|-------------|
| guid | string | sí | Guid OTP de firma. |
| identificacion | string | sí | Debe coincidir con `formulario.identificacion`. |

Comentarios viejos sobre datostecfinanzas **no aplican**: valida `Formulario` ligado al OTP.

### Ejemplo
```json
{
  "guid": "a1b2c3d4-uuid",
  "identificacion": "88282828"
}
```

## Proceso interno
1. OTP por guid + identidad.
2. Si ya `VALIDADO` → no reenvía.
3. Límites reenvío + espera mínima.
4. Nuevo código, mismos `opc_*`, `estado: PENDIENTE`, `reenvios_realizados + 1`.

## Responses
`status` es **string** (`success` / `error`). HTTP 200 en negocio; 400 params; 500 update.

**Siguiente si OK:** `validacion_otp_firma` con el mismo guid y código nuevo.

## Flujo anterior
`validacion_firma_digital`.

## Flujo posterior
`validacion_otp_firma`.

## Changelog
- **2026-08-26**: Alineado a código. Mismo GUID (no rota guid).
