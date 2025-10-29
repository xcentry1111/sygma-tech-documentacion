# Servicio para generar plan de pagos


**Descripción:** Este servicio permite recibir  parametros para el proceso de la generación del plan de pagos segun la parametrización del cliente.

**Tipo de Servicio:** POST

## **URL de Integración**

- **Prueba:** `https://testing-sygma.com/api/procesamiento`
- **Producción:** `POR_DEFINIR/api/procesamiento`

## **Headers**

El proceso requiere los siguientes encabezados en la solicitud:

- **Accept:** `application/json` (Obligatorio)
- **Content-Type:** `application/json` (Obligatorio)
- **Authorization:** `Bearer ${token}` (Obligatorio)

## **Consideraciones**
- El parámetro **tipo_servicio** debe establecerse por defecto en **API_PLAN_PAGOS**, ya que este valor permite al sistema identificar que se trata de una generación de plan de pagos.
- Si este parámetro no es proporcionado, el sistema responderá con el siguiente error:

`````json
{
    "error": "Parametro requerido",
    "message": "No se han definido parámetros requeridos tipo_servicio",
    "code": 400
}
`````

## **Cuerpo de la Solicitud (raw)** 

La información debe enviarse en formato JSON. **Ejemplo:**

### **Campos Obligatorios**

``````json
{
  "tipo_servicio": "API_PLAN_PAGOS",
  "valor": "1821340",
  "fecha": "2024-11-21",
  "tasa": "27.13",
  "plazo": 3,
  "cuota_maxima": 100000
}
  
``````

### **Ejemplo Respuesta Succes segun parametrización del cliente**

``````json
{
  "plan_pagos": [
    {
      "nro_cuota": 1,
      "fecha_vence": "2024-11-21",
      "cuota": "619433.0",
      "abono_capital": "619432.19",
      "interes_corriente": "0.0",
      "saldo_final": "1201907.81"
    },
    {
      "nro_cuota": 2,
      "fecha_vence": "2024-12-21",
      "cuota": "619433.0",
      "abono_capital": "595147.64",
      "interes_corriente": "24284.55",
      "saldo_final": "606760.17"
    },
    {
      "nro_cuota": 3,
      "fecha_vence": "2025-01-21",
      "cuota": "619433.0",
      "abono_capital": "606760.17",
      "interes_corriente": "12672.19",
      "saldo_final": "0.0"
    }
  ]
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
  "status": "error",
  "errors": [
    "valor no puede estar en blanco"
  ]
}
``````