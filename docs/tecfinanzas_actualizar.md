# SERVICIO PARA ACTUALIZAR DATOS


**Descripción:** Este servicio permite recibir los 9 parametros para el proceso de la actualizacion del credito.

**Tipo de Servicio:** POST

## URL de Integración

- **Prueba:** `http://testing-sygma.com/api/tecfinanzas/update_datos`
- **Producción:** `POR_DEFINIR/api/tecfinanzas/update_datos`

## Headers

El proceso requiere los siguientes encabezados en la solicitud:

- **Accept:** `application/json` (Obligatorio)
- **Content-Type:** `application/json` (Obligatorio)
- **Authorization:** `Bearer ${token}` (Obligatorio)

## Cuerpo de la Solicitud (raw)

La información debe enviarse en formato JSON. **Ejemplo:**

### Campos Obligatorios

``````json
{
  "datostecfinanza": {
      "tipo_servicio": "UPDATE", // Tipo de servicio que esta ejecutanto
      "no_pagare": "PG123456", // No. Pagaré
      "nro_credito": "CR1234567890", // Número del Crédito
      "nit_pagaduria": 112233, // NIT Pagaduría
      "fecha_desemb": "2024-01-01", // Fecha desembolso (DD/MM/AAAA)
      "valor_credito": 5000000, // Valor Crédito Aprobado ($)
      "plazo_inicial_credito": 24, // Plazo inicial crédito (meses)
      "tasa_interes": 5.25, // Tasa Interés Colocación Mes V
      "prima_comercial": 300000 // Prima Comercial
  }
}
``````

### Respuesta Success

``````json
{
  "status": "success",
  "data": {
      "Id": 3,
      "tipo_servicio": "UPDATE", // Tipo de servicio que esta ejecutanto
      "no_pagare": "PG123456", // No. Pagaré
      "nro_credito": "CR1234567890", // Número del Crédito
      "nit_pagaduria": 112233, // NIT Pagaduría
      "fecha_desemb": "2024-01-01", // Fecha desembolso (DD/MM/AAAA)
      "valor_credito": 5000000, // Valor Crédito Aprobado ($)
      "plazo_inicial_credito": 24, // Plazo inicial crédito (meses)
      "tasa_interes": 5.25, // Tasa Interés Colocación Mes V
      "prima_comercial": 300000 // Prima Comercial
  }
}
``````

### Respuesta Token Invalido

``````json
{
  "status": false,
  "message": "Token Inválido",
  "details": "Signature has expired",
  "code": 400
}
``````

### Respuesta Campos Requeridos

``````json
{
  "status": "error",
  "errors": [
    "Nro documento no puede estar en blanco"
  ]
}
``````