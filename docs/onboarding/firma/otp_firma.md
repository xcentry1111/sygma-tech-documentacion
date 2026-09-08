# OTP firma (Onboarding)

> **Estado:** contrato. Ruta **no** en `routes.rb`. Copia de `POST /api/validacion_otp_firma`. DIGITAL: omite PDFs 14222/14202/14203 (van en desembolso).

Mapa: [Flujo](../flujo.md) · [Firma](index.md).

## Resumen
Confirma OTP de firma. Formulario → `APROBADO`. Habilita desembolso.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/onboarding/validacion_otp_firma`
- **Testing**: `https://testing-sygma.com/api/onboarding/validacion_otp_firma`

## Autenticación
JWT Bearer (`/api/onboarding/autenticar`).

## Request

| Campo | Tipo | Requerido | Descripción |
|------|------|-----------|-------------|
| guid | string | sí | Guid de `Validacionesotp` (**no** el de originación). |
| codigo_otp | string | sí | Código. |
| tiempo_vigencia | number | sí | Exigido; expiración usa valor persistido (default 5 min). |

```json
{
  "guid": "a1b2c3d4-uuid",
  "codigo_otp": "123456",
  "tiempo_vigencia": 5
}
```

## Proceso interno
1. `Validacionesotp` por guid. Solo `PENDIENTE`.
2. Expiración / intentos (`total_intentos_otp` = 3) → `BLOQUEADO`.
3. OK → OTP `VALIDADO`; `estado = APROBADO`.
4. Cupo fijo: **no** genera PDFs rotativo.

`status` respuesta = **boolean** (`true`/`false`), igual Invictus.

## Responses

### 200 firma OK
```json
{
  "status": true,
  "mensaje": "Firma validada.",
  "guid": "a1b2c3d4-uuid",
  "nombre_cliente": "ANA PEREZ",
  "celular": "3001234567",
  "email": "ana.perez@example.com"
}
```
**Siguiente:** [crédito vigente](../desembolso/credito_vigente.md).

### 200 OTP malo / expirado / bloqueado
`status: false`. Reintento o [reenvio_otp_firma](reenvio_otp_firma.md).

## Flujo anterior
[validacion_firma_digital](validacion_firma_digital.md).

## Flujo posterior
[Desembolso](../desembolso/index.md).
