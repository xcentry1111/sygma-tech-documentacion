# Validación OTP firma (`validacion_otp_firma`)

## Resumen
Confirma el OTP de firma. Si es correcto, el `Formulario` pasa a `APROBADO`. En rotativo genera PDFs (14222, 14202, 14203) y notifica. Digital **omite** PDFs aquí.

Mapa: [Flujo Invictus](invictus_flujo.md).

## Objetivo
Cerrar firma legal/operativa y habilitar desembolso.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/validacion_otp_firma`
- **Controller**: `Api::InvictusFirmaController#validacion_otp_firma`
- **Ambientes**:
  - **Testing**: `https://testing-sygma.com/api/validacion_otp_firma`
  - **Producción**: `POR DEFINIR`

## Autenticación
JWT Bearer (401 con `status: false`).

## Headers
- **Authorization**: `Bearer <token>`
- **Content-Type**: `application/json`

## Request

| Campo | Tipo | Requerido | Descripción |
|------|------|-----------|-------------|
| guid | string | sí | Guid de `Validacionesotp` (no el de originación). |
| codigo_otp | string | sí | Código. |
| tiempo_vigencia | number | sí | **Exigido en params pero ignorado** para expirar. Se usa el persistido (default 5 min). |

### Ejemplo
```json
{
  "guid": "a1b2c3d4-uuid",
  "codigo_otp": "123456",
  "tiempo_vigencia": 5
}
```

## Proceso interno
1. `Validacionesotp.find_by(guid)`.
2. `EXPIRADO` / `BLOQUEADO` / `VALIDADO` → error business HTTP 200, `status: false`.
3. Solo `PENDIENTE` sigue. Otro estado → 404.
4. Expiración: ancla `updated_at` si hubo reenvíos, si no `created_at`.
5. Fallos: `intentos_fallidos`; al llegar a `total_intentos_otp` (3) → `BLOQUEADO`.
6. OK → OTP `VALIDADO`; `formulario.estado_invictus = APROBADO`.
7. Docs si `InvictusExperianSimulacion.generar_documentos_en_firma?` (`!digital?`).
8. Notificación post-firma (no bloqueante).

## Responses

`status` es **boolean** (no `"success"`).

### 200 — Firma OK
```json
{
  "status": true,
  "mensaje": "...",
  "guid": "...",
  "nombre_cliente": "...",
  "celular": "...",
  "email": "..."
}
```
**Siguiente:** `POST /api/validacion_credito_vigente`.

### 200 — OTP malo / expirado / bloqueado / ya validado
`status: false`. Puede traer `intentos_restantes`. Reintentar o `reenvio_otp_firma`.

### 400
Faltan campos.

### 404
Guid inexistente o OTP no `PENDIENTE`.

### 500
Formulario nil u otra excepción.

## Flujo anterior
`validacion_firma_digital` (o reenvío).

## Flujo posterior
Desembolso.

## Changelog
- **2026-08-26**: Alineado a código. `tiempo_vigencia` del body no gobierna TTL.
