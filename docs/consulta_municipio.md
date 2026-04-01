# Consultar municipios por descripción

## Resumen
Consulta municipios filtrando por una parte de la descripción. El resultado contiene el **ID**, la **descripción** y el **código DANE**.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/consulta_municipios`
- **Ambientes**:
  - **Prueba**: `https://testing-sygma.com/api/consulta_municipios`
  - **Producción**: `POR_DEFINIR/api/consulta_municipios`

## Autenticación
- **Tipo**: `Bearer token`
- **Header**: `Authorization: Bearer <token>`

## Headers
- **Accept**: `application/json` (obligatorio)
- **Content-Type**: `application/json` (obligatorio)
- **Authorization**: `Bearer <token>` (obligatorio)

## Request

### Notas de negocio
- El parámetro **descripcion** es obligatorio y corresponde al texto a buscar dentro del campo de descripción del municipio.

### Body (JSON)

#### Campos
| Campo | Tipo | Requerido | Descripción |
|------|------|-----------|-------------|
| descripcion | string | sí | Texto a buscar (parcial) dentro de la descripción del municipio. |

#### Ejemplo
```json
{
  "descripcion": "neiva"
}
```

## Responses

### 200 OK (Success)
```json
{
  "id": 10593,
  "descripcion": "HUILA - NEIVA | COLOMBIA",
  "codigo_dane": 41001
}
```

## Errores comunes

### Parámetro requerido no enviado
```json
{
  "status": false,
  "message": "El parámetro :descripcion es requerido",
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
