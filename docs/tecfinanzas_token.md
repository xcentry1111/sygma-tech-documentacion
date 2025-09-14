# Generación de token

**Descripción:** Este servicio genera un token utilizando un usuario y contraseña, lo cual permite acceder y consumir los servicios proporcionados por el software **TESEO**. El token tiene una validez de 1 hora; después de ese tiempo, se debe solicitar un nuevo token para continuar accediendo a los recursos.

**Tipo de Servicio:** POST

## **URL de Integración**

- **Prueba:** `http://testing-sygma.com/api/login`
- **Producción:** `POR_DEFINIR/api/login`

## **Headers**

El proceso requiere los siguientes encabezados en la solicitud:

- **Accept:** `application/json` (Obligatorio)
- **Content-Type:** `application/json` (Obligatorio)

## **Cuerpo de la Solicitud (raw)**

La información debe enviarse en formato JSON. **Ejemplo:**

`````json
{
  "username": "",  // USUARIO QUE SE VA A CONECTAR
  "password": "" // CONTRASEÑA DEL USUARIO QUE SE VA A CONECTAR
}

`````

### **Respuesta Success**

``````json
{
  "status": true,
  "auth_token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjozMzg1MywiZXhwIjoxNzIzODMzMDg3fQ.WlNDobuExhSO_jNWOui-HNFhVXPyGLvUs7hIuSY1f5Y",
  "token_type": "Bearer",
  "expires_at": "2024-08-16 18:31:27",
  "message": "Generado con Exito",
  "code": 200
}
``````

### **Respuesta Credenciales no Validas**

``````json
{
  "status": false,
  "message": "Credenciales no validas",
  "code": 400
}
``````

### **Respuesta Parametros no enviados**

``````json
{
  "status": false,
  "message": "username y password son requeridos",
  "code": 422
}
``````