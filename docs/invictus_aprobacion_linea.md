# Aprobación de línea (`validar_linea_credito`) — NO EXISTE

## Resumen
Esta página documentaba `POST /api/validar_linea_credito` con body `linea_credito_id` + `estado: APROBADO|DESISTE`.

**En el código TESEO esa ruta y ese contrato no existen.** No hay `invictus_aprobacion_linea` ni `validar_linea_credito` en `config/routes.rb`.

Mapa real: [Flujo Invictus](invictus_flujo.md).

## Qué usar en su lugar

La selección de línea es **desembolso**, no originación:

- **Endpoint real**: `POST /api/seleccionar_linea_credito`
- **Documentación**: [Seleccionar líneas de crédito](invictus_desembolso_linea_credito.md)
- **Controller**: `Api::InvictusDesembolsoController#seleccionar_linea_credito`
- **Precondición**: OTP de desembolso en estado `VALIDADO`
- El cliente elige `id_linea_credito` del array `lineas_credito` y lo envía a `calcular_desembolso` / `proceso_desembolso`

No hay estados `APROBADO` / `DESISTE` de línea en TESEO Invictus. No hay contenedor de 30 días por “DESISTE” de línea en este código.

## Endpoint (histórico, inválido)
- **Método**: `POST`
- **Ruta**: `/api/validar_linea_credito` — **no implementado**

## Inconsistencia
Nav antigua colocaba este archivo bajo **Originación Invictus**. La operación real ocurre **después de firma y OTP de desembolso**.

## Changelog
- **2026-08-26**: Marcado como documentación obsoleta vs código.
