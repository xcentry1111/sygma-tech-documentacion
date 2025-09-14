# Servicio para reversar un recaudo (Pago)


**Descripción:** Este servicio recibe varios parametros cuya finalidad es reversar un recaudo de una obligación (Pago)

**Tipo de Servicio:** POST

## **URL de Integración**

- **Prueba:** `http://testing-sygma.com/api/reversar_recaudo`
- **Producción:** `POR_DEFINIR/api/reversar_recaudo`

## **Headers**

El proceso requiere los siguientes encabezados en la solicitud:

- **Accept:** `application/json` (Obligatorio)
- **Content-Type:** `application/json` (Obligatorio)
- **Authorization:** `Bearer ${token}` (Obligatorio)

## **Consideraciones**
- El parámetro **tipo_servicio** debe establecerse por defecto en **REVERSAR_RECAUDO**, ya que este valor permite al sistema identificar que se trata de una inserción de recaudo.
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
  "tipo_servicio": "REVERSAR_RECAUDO", // OBLIGATORIO
  "recaudo_id": "27832828", // OBLIGATORIO
  "observacion": "SE REVERSA POR MOTIVOS DE PRUEBAS" // OBLIGATORIO - SE DEBE DE JUSTIFICAR PORQUE SE DESEA REVERSAR
}
  
``````

### **Ejemplo Respuesta Succes**

``````json
{
  "status": true,
  "guid": "e87d6aad89f02df1a6f6",
  "estado_aplicacion": "APLICADO",
  "message": "Registro reversado con éxito!!!",
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

### **Respuestas no validas - Recaudo no Existe**
``````json
{
  "status": false,
  "message": "Id del recaudo no valido",
  "code": 400
}
``````
