# Seleccionar línea cupo fijo (Onboarding)

> **Estado:** contrato. Ruta **no** en `routes.rb`. Copia de `POST /api/seleccionar_linea_credito` **solo DIGITAL**. Sin `fnc_json_credintegral` rotativo.

Mapa: [Flujo](../flujo.md) · [Desembolso](index.md).

## Resumen
OTP debe estar `VALIDADO`. Devuelve una línea `RIS CUPO FIJO` (`monto_fijo: SI`). `id_linea_credito` = `91000000000 + form.id`.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/onboarding/seleccionar_linea_credito`
- **Testing**: `https://testing-sygma.com/api/onboarding/seleccionar_linea_credito`

## Autenticación
JWT Bearer (`/api/onboarding/autenticar`).

## Request

| Campo | Tipo | Requerido |
|------|------|-----------|
| guid | string | sí |
| tiposdocumento_id | string | sí |
| identificacion | string | sí |

```json
{
  "guid": "19da7351-7c07-4a28-8d1c-5cdc5ddbbbe4",
  "tiposdocumento_id": "1",
  "identificacion": "1001532242"
}
```

## Proceso interno
1. `Validacionesotp` guid + ident. Estado `VALIDADO` o `otp_not_validated`.
2. `InvictusDigitalLineaService.construir_linea` sobre `Formulario` Onboarding.
3. No fusionar rotativo.

## Responses

### 200 success
```json
{
  "status": "success",
  "datos": {
    "guid": "19da7351-7c07-4a28-8d1c-5cdc5ddbbbe4",
    "nombre_cliente": "ANA MARIA PEREZ GOMEZ",
    "identificacion": "1001532242",
    "puede_desembolsar": true,
    "lineas_credito": [
      {
        "id_linea_credito": 91000000099,
        "linea_credito": "RIS CUPO FIJO",
        "valor_cupo": 200000.0,
        "total_entregado": 0.0,
        "total_disponible": 200000.0,
        "plazo_meses": 6,
        "monto_fijo": "SI",
        "tipo_linea": "DIGITAL"
      }
    ]
  }
}
```

UI: `monto_fijo = SI` → valor = `total_disponible`, no editable. Plazo 1–6.

Otros: `otp_not_validated`, `no_credit`, 404, 400, 401.

## Flujo anterior
[otp_desembolso](otp_desembolso.md).

## Flujo posterior
[calcular_desembolso](calcular_desembolso.md) y/o [proceso_desembolso](proceso_desembolso.md) con ese `id_linea_credito`.
