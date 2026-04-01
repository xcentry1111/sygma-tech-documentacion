# Insertar recaudo

## Resumen
Registra un recaudo asociado a una obligación a través de la API.

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
| tipo_servicio | string | sí | Debe enviarse `INSERTAR_RECAUDO`. |
| personasobligacion_id | string | sí | Identificador de la obligación/persona-obligación. |
| fecha | string | sí | Formato `DD-MM-YYYY`. |
| valor | string | sí | Valor del recaudo. |
| sucursal | string | no | Sede desde donde se envía el servicio. |
| codigo_transaccion | string | no | Identificador de la transacción del originador. |
| usuario | string | no | Usuario asociado a la transacción. |
| observacion | string | no | Observación del recaudo. |

#### Ejemplo
```json
{
  "tipo_servicio": "INSERTAR_RECAUDO",
  "personasobligacion_id": "193833",
  "fecha": "02-07-2024",
  "valor": "10000",
  "sucursal": "TENJO",
  "codigo_transaccion": "2763637388",
  "usuario": "USUARIO DE LA TRANSACCION",
  "observacion": "PAGO REALIZADO POR LA PLATAFORMA TESEO"
}
```

## Responses
`POR_DEFINIR`

## Errores comunes
`POR_DEFINIR`