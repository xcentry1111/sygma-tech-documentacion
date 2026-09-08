# Validación de firma digital (`validacion_firma_digital`)

## Resumen
Comprueba si hay solicitud para firmar (`APROBADO_PENDIENTE_FIRMA`) y dispara OTP de firma (email/SMS/WhatsApp según `opc_*`). No consulta Truora ni listas en este paso.

Mapa: [Flujo Invictus](invictus_flujo.md).

## Objetivo
Iniciar el ciclo de firma y devolver `guid` de `Validacionesotp`.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/validacion_firma_digital`
- **Controller**: `Api::InvictusFirmaController#validacion_firma`
- **Ambientes**:
  - **Testing**: `https://testing-sygma.com/api/validacion_firma_digital`
  - **Producción**: `POR DEFINIR`

## Autenticación
JWT Bearer. 401: `{ "status": false, "message": "...", "code": 400 }` (**formato distinto** al 401 de originación).

## Headers
- **Authorization**: `Bearer <token>`
- **Accept**: `application/json`
- **Content-Type**: `application/json`

## Request

| Campo | Tipo | Requerido | Descripción |
|------|------|-----------|-------------|
| tiposdocumento_id | string | sí | Tipo de documento. |
| identificacion | string | sí | Número. |

### Ejemplo
```json
{
  "tiposdocumento_id": "1",
  "identificacion": "88282828"
}
```

## Proceso interno
1. `Formulario` INVICTUS 10053 más reciente por doc+ident.
2. `Persona` mismo portafolio (cupo migrado si no hay form).
3. Gate por `estado_invictus` (tabla abajo).
4. Si `APROBADO_PENDIENTE_FIRMA`: genera OTP + UUID, envía canales `opc_*` (`InvictusNotificacionService`). Fallo de proveedor **no** aborta.
5. Crea `Validacionesotp` `PENDIENTE`. Audita.

## Responses (casi todas HTTP 200; mirar `status`)

| `status` | Significado | Siguiente |
|----------|-------------|-----------|
| `success` | OTP enviado + `datos.guid` | `validacion_otp_firma` |
| `already_signed` | Ya `APROBADO` | Desembolso |
| `not_required` | Cupo migrado, sin ciclo firma Invictus | Desembolso |
| `no_credit` | Sin crédito / mal estado | Originación o revisar cédula |
| `expired` | `CANCELADO` | Nueva originación |
| `pending_identity` | `EN_VERIFICACION` | [Truora KYC](invictus_truora_kyc.md) |

### 400
Faltan params: `status: "error"`, `errors[]`.

### 500
Excepción.

## Flujo anterior
`validar_otp` APROBADO, o webhook Truora succeeded, o lista blanca.

## Flujo posterior
`POST /api/validacion_otp_firma` (o `reenvio_otp_firma`).

## Notas
- Docs PDF **no** se generan aquí. Rotativo: en OTP firma. Digital: en desembolso.
- Título histórico “listas restrictivas” es **incorrecto**: listas corren en `validar_otp`.

## Changelog
- **2026-08-26**: Alineado a `validacion_firma`.
