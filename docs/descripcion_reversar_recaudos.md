# Reversar recaudo

## Resumen
Reversa un recaudo asociado a una obligación a través de la API.

## Endpoint
- **Método**: `POST`
- **Ruta**: `POR_DEFINIR`
- **Ambientes**:
  - **Prueba**: `POR_DEFINIR`
  - **Producción**: `POR_DEFINIR`

## Autenticación
- **Tipo**: `Bearer token`
- **Header**: `Authorization: Bearer <token>`

## Headers
- **Accept**: `application/json`
- **Content-Type**: `application/json`

## Request

### Validaciones
- Valida que todos los campos obligatorios estén presentes.
- Valida permisos para consumo del servicio.
- Si algún dato es inválido o falta información requerida, se retorna un error con la descripción del problema.

### Body (JSON)

#### Campos
| Campo | Tipo | Requerido | Descripción |
|------|------|-----------|-------------|
| tipo_servicio | string | sí | Debe enviarse `REVERSAR_RECAUDO`. |
| recaudo_id | string | sí | Identificador del recaudo a reversar. |
| observacion | string | sí | Justificación del reverso. |

#### Ejemplo
```json
{
  "tipo_servicio": "REVERSAR_RECAUDO",
  "recaudo_id": "2783288828",
  "observacion": "SE REVERSA POR MOTIVOS DE PRUEBAS"
}
```

## Responses
`POR_DEFINIR`

## Errores comunes
`POR_DEFINIR`