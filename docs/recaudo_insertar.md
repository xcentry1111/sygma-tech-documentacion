# Servicio para aplicar un recaudo (Pago)


**Descripción:** Este servicio recibe varios parametros cuya finalidad es insertar un recaudo a la obligación

**Tipo de Servicio:** POST

## **URL de Integración**

- **Prueba:** `http://testing-sygma.com/api/insertar_recaudo`
- **Producción:** `POR_DEFINIR/api/insertar_recaudo`

## **Headers**

El proceso requiere los siguientes encabezados en la solicitud:

- **Accept:** `application/json` (Obligatorio)
- **Content-Type:** `application/json` (Obligatorio)
- **Authorization:** `Bearer ${token}` (Obligatorio)

## **Consideraciones**
- El parámetro **tipo_servicio** debe establecerse por defecto en **INSERTAR_RECAUDO**, ya que este valor permite al sistema identificar que se trata de una inserción de recaudo.
- Si este parámetro no es proporcionado, el sistema responderá con el siguiente error:

`````json
{
  "status": false,
  "message": "No cuenta con los permisos para consumir el servicio",
  "code": 400
}
`````

## **Cuerpo de la Solicitud (raw)** 

La información debe enviarse en formato JSON. **Ejemplo:**

### **Campos Obligatorios**

``````json
{
  "tipo_servicio": "INSERTAR_RECAUDO", // OBLIGATORIO
  "personasobligacion_id": "1938373", // OBLIGATORIO
  "fecha": "02-07-2024", // DD-MM-YYYY - OBLIGATORIO - FORMATO
  "valor": "10000", // OBLIGATORIO
  "sucursal": "TENJO", // Sede desde donde se envia el servicio
  "codigo_transaccion": "2763637388",
  "usuario": "USUARIO DE LA TRANSACCION",
  "observacion": "PAGO REALIZADO POR LA PLATAFORMA TESEO"
}
  
``````

### **Ejemplo Respuesta Succes**

``````json
{
  "status": true,
  "guid": "bf5304c04eb5ef007a0a",
  "estado_recaudo": "APLICADO",
  "message": "Registro creado con éxito!!!",
  "code": 200
}
``````

### **Respuesta Token Invalido**

``````json
{
  "status": false,
  "message": "Token Inválido",
  "details": "Signature has expired",
  "code": 400
}
``````

### **Respuesta Campos Requeridos**

``````json
{
  "error": "Falta el parámetro",
  "message": "Los siguientes parámetros son requeridos: tipo_servicio",
  "code": 400
}
``````

### **Respuestas no validas - Valor**
``````json
{
  "status": false,
  "message": "El valor debe ser superior a 0",
  "code": 400
}
``````

### **Respuestas no validas - Obligación**
``````json
{
  "status": false,
  "message": "Id de la obligación no valida",
  "code": 400
}
``````

### **Respuestas no validas - Fecha**
``````json
{
  "status": false,
  "message": "La fecha no puede superar el dia actual",
  "code": 400
}
``````
