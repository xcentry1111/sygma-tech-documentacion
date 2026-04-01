# Reversar recaudo (pago)

## Resumen
Reversa un recaudo (pago) asociado a una obligaci?n.

## Endpoint
- **M?todo**: `POST`
- **Ruta**: `/api/reversar_recaudo`
- **Ambientes**:
  - **Prueba**: `https://testing-sygma.com/api/reversar_recaudo`
  - **Producci?n**: `POR_DEFINIR/api/reversar_recaudo`

## Autenticaci?n
- **Tipo**: `Bearer token`
- **Header**: `Authorization: Bearer <token>`

## Headers
- **Accept**: `application/json` (obligatorio)
- **Content-Type**: `application/json` (obligatorio)
- **Authorization**: `Bearer <token>` (obligatorio)

## Request

### Notas de negocio
- El par?metro **tipo_servicio** debe enviarse en **`REVERSAR_RECAUDO`**.

### Body (JSON)

#### Campos
| Campo | Tipo | Requerido | Descripci?n |
|------|------|-----------|-------------|
| tipo_servicio | string | s? | Debe enviarse `REVERSAR_RECAUDO`. |
| recaudo_id | string | s? | Identificador del recaudo a reversar. |
| observacion | string | s? | Justificaci?n del reverso. |

#### Ejemplo
```json
{
  "tipo_servicio": "REVERSAR_RECAUDO",
  "recaudo_id": "27832828",
  "observacion": "SE REVERSA POR MOTIVOS DE PRUEBAS"
}
```

## Responses

### 200 OK (Success)
```json
{
  "status": true,
  "guid": "e87d6aad89f02df1a6f6",
  "estado_aplicacion": "APLICADO",
  "message": "Registro reversado con ?xito!!!",
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

### Token inv?lido
```json
{
  "status": false,
  "message": "Token Inv?lido",
  "details": "Signature has expired",
  "code": 400
}
```

### Campos requeridos
```json
{
  "error": "Falta el par?metro",
  "message": "Los siguientes par?metros son requeridos: tipo_servicio",
  "code": 400
}
```

### Recaudo no existe / no v?lido
```json
{
  "status": false,
  "message": "Id del recaudo no valido",
  "code": 400
}
```
