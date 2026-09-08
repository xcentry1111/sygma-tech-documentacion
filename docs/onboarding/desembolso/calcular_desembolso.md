# Cálculo desembolso cupo fijo (Onboarding)

> **Estado:** contrato. Ruta **no** en `routes.rb`. Copia de `POST /api/calcular_desembolso` rama DIGITAL. **No persiste. No exige OTP.** Motor: `PlaneshsimulaCreditoService` (`InvictusDigitalLineaService.calcular_montos`).

Mapa: [Flujo](../flujo.md) · [Desembolso](index.md). Cotización previa (otro momento): [simular](../originacion/simular.md).

## Resumen
Calcula fianza + neto. `valor_total` **igual** al cupo asignado. Plazo 1–6. Rango monto 200000–1000000.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/onboarding/calcular_desembolso`
- **Testing**: `https://testing-sygma.com/api/onboarding/calcular_desembolso`

## Autenticación
JWT Bearer (`/api/onboarding/autenticar`).

## Request

| Campo | Tipo | Requerido |
|------|------|-----------|
| tiposdocumento_id | string | sí |
| identificacion | string | sí |
| guid | string | sí |
| id_linea_credito | integer | sí |
| plazo_meses | integer | sí |
| valor_total | number | sí |
| plaza_empresa | integer | sí |
| valor_cobros | number | no (valida ±1 si viene) |
| valor_a_pagar_cliente | number | no |

```json
{
  "tiposdocumento_id": "1",
  "identificacion": "1034567890",
  "guid": "30cdcb83-9d2c-4918-b015-ca9c481e381e",
  "id_linea_credito": 91000000099,
  "plazo_meses": 1,
  "valor_total": 200000,
  "plaza_empresa": 50
}
```

## Proceso interno
`validar_cupo!`: línea DIGITAL + `valor_total == cupo`. Luego `calcular_montos`. Sin `prc_simulador_crediintegral`.

## Responses

### 200 success
```json
{
  "status": "success",
  "datos": {
    "guid": "30cdcb83-9d2c-4918-b015-ca9c481e381e",
    "mensaje": "Cálculo de desembolso realizado correctamente. Este es un cálculo previo, no se ha ejecutado ningún desembolso.",
    "valor_total": 200000,
    "valor_cobros": 11900,
    "valor_a_pagar_cliente": 188100,
    "plazo_meses": 1,
    "comprobante": {
      "concepto": "Cálculo previo de desembolso",
      "detalles_descuentos": [
        { "concepto": "Fianza Anticipada", "valor": 11900 },
        { "concepto": "IVA Fianza Anticipada", "valor": 1900 }
      ]
    }
  }
}
```

Errores: 400 rango, `credit_not_available` / `monto_fijo` si valor ≠ cupo, 401, 500.

## Flujo anterior
[linea_credito](linea_credito.md).

## Flujo posterior
[proceso_desembolso](proceso_desembolso.md) con los montos de esta respuesta.
