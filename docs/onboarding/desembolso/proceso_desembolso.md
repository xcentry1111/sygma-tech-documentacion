# Proceso desembolso cupo fijo (Onboarding)

> **Estado:** contrato. Ruta **no** en `routes.rb`. Copia de `POST /api/proceso_desembolso` DIGITAL. **Irreversible.**

Mapa: [Flujo](../flujo.md) · [Desembolso](index.md). Invictus: [proceso_desembolso](../../invictus_desmebolso.md).

## Resumen
Ejecuta desembolso TESEO: OTP `DESEMBOLSADO` **antes** de persistir (anti doble clic). Formulario → `DESEMBOLSADO`. Pipeline: `InvictusDigitalLineaService.desembolsar!` → `Datostecfinanza` + `prc_tecfinanzas` + `prc_procesocrediintegral` + `prc_obligacion`. **Sin** rotativo / `CREAROBLCUOTAMANEJO`. TESEO **no** mueve caja; JSON trae `instrucciones_invictus` para el cliente.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/onboarding/proceso_desembolso`
- **Testing**: `https://testing-sygma.com/api/onboarding/proceso_desembolso`

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
| valor_cobros | number | sí |
| valor_a_pagar_cliente | number | sí |
| plaza_empresa | integer | sí |

```json
{
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "guid": "b2c3d4e5-f6g7-8901-bcde-fg2345678901",
  "id_linea_credito": 91000000099,
  "plazo_meses": 1,
  "valor_total": 200000,
  "valor_cobros": 11900,
  "valor_a_pagar_cliente": 188100,
  "plaza_empresa": 50
}
```

`valor_total` = cupo asignado. Coherencia: `valor_total ≈ valor_cobros + valor_a_pagar_cliente` (±1).

## Proceso interno
1. OTP `VALIDADO` o `otp_not_validated`.
2. `validar_cupo!` + montos vs cálculo.
3. Marca OTP `DESEMBOLSADO`.
4. `desembolsar!` Datostecfinanza CREATE + PRC.
5. Formulario `DESEMBOLSADO`. Docs DIGITAL aquí (no en firma).

No reenviar si `success` o `already_disbursed`.

## Responses

### 200 success
```json
{
  "status": "success",
  "datos": {
    "guid": "b2c3d4e5-f6g7-8901-bcde-fg2345678901",
    "mensaje": "Transacción exitosa. Desembolso realizado correctamente.",
    "linea_credito": "RIS CUPO FIJO",
    "valor_total": 200000,
    "valor_cobros": 11900,
    "valor_a_pagar_cliente": 188100,
    "plazo_meses": 1,
    "instrucciones_invictus": {
      "replicar_siga": true,
      "afectar_caja": true,
      "afectar_cartera": true,
      "imprimir_colilla": true,
      "afectar_contabilidad": true
    }
  }
}
```

Otros: `already_disbursed`, `otp_not_validated`, `credit_not_available`, 400 montos, 401, 404.

## Flujo anterior
[calcular_desembolso](calcular_desembolso.md) (recomendado) + OTP validado.

## Flujo posterior
Ninguno. Fin. Entregar `valor_a_pagar_cliente` al cliente. Ejecutar flags de `instrucciones_invictus`.
