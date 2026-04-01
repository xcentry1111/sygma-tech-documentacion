# Insertar recaudo (pago)

## Resumen
Inserta/aplica un recaudo a una obligación.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/insertar_recaudo`
- **Ambientes**:
  - **Prueba**: `https://testing-sygma.com/api/insertar_recaudo`
  - **Producción**: `POR_DEFINIR/api/insertar_recaudo`

## Autenticación
- **Tipo**: `Bearer token`
- **Header**: `Authorization: Bearer <token>`

## Headers
- **Accept**: `application/json` (obligatorio)
- **Content-Type**: `application/json` (obligatorio)
- **Authorization**: `Bearer <token>` (obligatorio)

## Request

### Notas de negocio
- El parámetro **tipo_servicio** debe enviarse en **`INSERTAR_RECAUDO`** para indicar que se trata de una inserción de recaudo.

### Body (JSON)

#### Campos
| Campo | Tipo | Requerido | Descripción |
|------|------|-----------|-------------|
| tipo_servicio | string | sí | Debe enviarse `INSERTAR_RECAUDO`. |
| personasobligacion_id | string | sí | Identificador de la obligación/persona-obligación. |
| fecha | string | sí | Formato `DD-MM-YYYY`. |
| valor | string | sí | Valor del recaudo (debe ser > 0). |
| sucursal | string | no | Sede desde donde se envía el servicio. |
| codigo_transaccion | string | no | Identificador de la transacción del originador. |
| usuario | string | no | Usuario asociado a la transacción. |
| observacion | string | no | Observación del recaudo. |

#### Ejemplo
```json
{
  "tipo_servicio": "INSERTAR_RECAUDO",
  "personasobligacion_id": "1938373",
  "fecha": "02-07-2024",
  "valor": "10000",
  "sucursal": "TENJO",
  "codigo_transaccion": "2763637388",
  "usuario": "USUARIO DE LA TRANSACCION",
  "observacion": "PAGO REALIZADO POR LA PLATAFORMA TESEO"
}
```

## Responses

### 200 OK (Success)
```json
{
  "status": true,
  "guid": "bf5304c04eb5ef007a0a",
  "estado_recaudo": "APLICADO",
  "message": "Registro creado con éxito!!!",
  "code": 200
}
```

## Errores comunes

### 400/403 (No cuenta con permisos)
```json
{
  "status": false,
  "message": "No cuenta con los permisos para consumir el servicio",
  "code": 400
}
```

### Token inválido
```json
{
  "status": false,
  "message": "Token Inválido",
  "details": "Signature has expired",
  "code": 400
}
```

### Campos requeridos
```json
{
  "error": "Falta el parámetro",
  "message": "Los siguientes parámetros son requeridos: tipo_servicio",
  "code": 400
}
```

### Validación de valor
```json
{
  "status": false,
  "message": "El valor debe ser superior a 0",
  "code": 400
}
```

### Validación de obligación
```json
{
  "status": false,
  "message": "Id de la obligación no valida",
  "code": 400
}
```

### Validación de fecha
```json
{
  "status": false,
  "message": "La fecha no puede superar el dia actual",
  "code": 400
}
```
