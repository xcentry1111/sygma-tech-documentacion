# Generación de token (login)

## Resumen
Genera un token con usuario y contraseña para consumir los servicios de **TESEO**. El token tiene validez de **1 hora** y debe renovarse al expirar.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/login`
- **Ambientes**:
  - **Prueba**: `https://testing-sygma.com/api/login`
  - **Producción**: `POR_DEFINIR/api/login`

## Autenticación
No aplica (este endpoint entrega el token).

## Headers
- **Accept**: `application/json` (obligatorio)
- **Content-Type**: `application/json` (obligatorio)

## Request

### Body (JSON)

#### Campos
| Campo | Tipo | Requerido | Descripción |
|------|------|-----------|-------------|
| username | string | sí | Usuario asignado para autenticación. |
| password | string | sí | Contraseña del usuario asignado. |

#### Ejemplo
```json
{
  "username": "",
  "password": ""
}
```

## Responses

### 200 OK (Success)
```json
{
  "status": true,
  "auth_token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjozMzg1MywiZXhwIjoxNzIzODMzMDg3fQ.WlNDobuExhSO_jNWOui-HNFhVXPyGLvUs7hIuSY1f5Y",
  "token_type": "Bearer",
  "expires_at": "2024-08-16 18:31:27",
  "message": "Generado con Exito",
  "code": 200
}
```

## Errores comunes

### 400 Bad Request (Credenciales no válidas)
```json
{
  "status": false,
  "message": "Credenciales no validas",
  "code": 400
}
```

### 422 Unprocessable Entity (Parámetros no enviados)
```json
{
  "status": false,
  "message": "username y password son requeridos",
  "code": 422
}
```