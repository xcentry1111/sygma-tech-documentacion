# Servicio para consultar por id de Recaudo


**Descripción:** Este servicio recibe dos parámetros para consultar a un deudor por el id de un recaudo, incluyendo la información del credito y recaudo.

**Tipo de Servicio:** POST

## **URL de Integración**

- **Prueba:** `http://testing-sygma.com/api/consultar`
- **Producción:** `POR_DEFINIR/api/consultar`

## **Headers**

El proceso requiere los siguientes encabezados en la solicitud:

- **Accept:** `application/json` (Obligatorio)
- **Content-Type:** `application/json` (Obligatorio)
- **Authorization:** `Bearer ${token}` (Obligatorio)

## **Consideraciones**
- El parámetro **servicio** debe establecerse por defecto en **CONSULTA_RECAUDO**, ya que este valor permite al sistema identificar que se trata de una consulta por id de recaudo.
- El parametro **dato** corresponde al ````Id Recaudo Teseo```` del deudor que se desea consultar.
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
  "servicio": "CONSULTA_RECAUDO", 
  "dato": "27438761" 
}
  
``````

### **Respuesta no valida**
``````json
{
  "status": false,
  "message": "Id del recaudo no válido",
  "code": 400
}
``````



### **Ejemplo Respuesta Succes**

``````json
{
  "persona": {
    "persona_id": "5642511",
    "identificacion": "1001762523",
    "nombre": "PRUEBA",
    "obligaciones": [
      {
        "personasobligacion_id": "6677424",
        "nro_obligacion": "2021112",
        "fecha_matricula": "02-12-2021",
        "portafoliossucursal_id": "15507",
        "sucursal": "CONTADURIA",
        "portafoliosvehiculo_id": "575",
        "vehiculo": "TECNOLOGICO DE ANTIOQUIA",
        "cliente": "12320",
        "originador": "CORPORACIÓN GILBERTO E",
        "saldo_capital": "0",
        "saldo_total": "0",
        "recaudos": [
          {
            "planesrecaudo_id": "27438761",
            "personasobligacion_id": "6677424",
            "fecha_recaudo": "24-01-2022",
            "tipo_pago": "EFECTIVO",
            "estado": "",
            "tipo_afecta": "AJUSTE CUOTA",
            "user_id": "10456",
            "valor": "28398",
            "observaciones": " - APLICACION TANQUE - FECHA MOVIMIENTO: 2022-01-24 - OBS-OPCIONAL1: Migrado *"
          }
        ]
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