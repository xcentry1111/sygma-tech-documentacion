# Servicio para consultar por identificación + Obligaciones


**Descripción:** Este servicio recibe dos parámetros para consultar a un deudor por su identificación y devuelve la información básica del deudor y del crédito.

**Tipo de Servicio:** POST

## **URL de Integración**

- **Prueba:** `https://testing-sygma.com/api/consultar`
- **Producción:** `POR_DEFINIR/api/consultar`

## **Headers**  

El proceso requiere los siguientes encabezados en la solicitud:

- **Accept:** `application/json` (Obligatorio)
- **Content-Type:** `application/json` (Obligatorio)
- **Authorization:** `Bearer ${token}` (Obligatorio)

## **Consideraciones**
- El parámetro **servicio** debe establecerse por defecto en **CONSULTA_BASICO**, ya que este valor permite al sistema identificar que se trata de una consulta por identificación.
- El parametro **dato** corresponde al ````Número de Identificación```` del deudor que se desea consultar.
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
  "servicio": "CONSULTA_BASICO", 
  "dato": "37195302" 
}
  
``````

### **Respuesta Identificación no valida**
``````json
{
  "status": true,
  "message": "No se encontro informacion sobre este registro - 37195302111",
  "code": 200
}
``````



### **Ejemplo Respuesta Succes**

``````json
{
  "persona": {
    "persona_id": "9755361",
    "identificacion": "37195302",
    "nombre": "PRUEBA",
    "telefono": "",
    "obl_nro_total": "1",
    "obl_pago_minimo": "210000",
    "obl_pago_total": "271045",
    "obligaciones": [
      {
        "personasobligacion_id": "8864800",
        "nro_obligacion": "204202004788",
        "idcredito": "11632563",
        "pago_minimo": "210000",
        "dias_mora": "20",
        "pago_total": "271045"
      }
    ]
  }
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
  "status": false,
  "message": "El parámetro :dato es requerido",
  "code": 400
}
``````