# Servicios TESEO (visión general)

## Resumen
Este documento describe de forma general el procesamiento de información en formato JSON para integración con **TESEO**, orientado a la creación/actualización de créditos.

## Endpoint
Este documento es **descriptivo** (no corresponde a un solo endpoint). Para endpoints específicos ver:
- `docs/tecfinanzas_importar.md`
- `docs/tecfinanzas_actualizar.md`
- `docs/tecfinanzas_token.md`

## Autenticación
- **Tipo**: `Bearer token`
- **Cómo obtener token**: ver `docs/tecfinanzas_token.md`

## Headers
- **Accept**: `application/json`
- **Content-Type**: `application/json`
- **Authorization**: `Bearer <token>`

## Notas / Flujo

### Funcionamiento
- Recibe datos en formato JSON.
- Valida que todos los campos obligatorios estén presentes.
- Carga la información en **TESEO** para la creación o actualización del crédito.

### Validaciones
Implementa validaciones para garantizar integridad y coherencia de los datos.

### Formato de entrada
Los datos deben enviarse en formato JSON con la siguiente estructura:

```json
 {
  "datostecfinanza": {
    "nro_documento": "129905111 ",
    "dir_residencia": "CRA 50 60 16"
  }
}
```
