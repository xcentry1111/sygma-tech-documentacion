# INTEGRACIÓN

### Tipo de Servicio

**Tipo:** POST

### URL de Integración

- **Prueba**  http://testing-sygma.com/ws_consulta
- **Producción:** https://sygma-tech.com.co/ws_consulta

### Headers

- El proceso requiere en la cabecera los siguientes datos.
    - **Accept-Type:** application/json (Datos Obligatorios)
    - **Portafolio:** 10031 (Datos Obligatorios)
    - **username:** (Se envia por medio de correo electronico)
    - **password:** (Se envia por medio de correo electronico)

### Body (raw)

- Para el envio de la información debe ser tipo JSON.
  **Ejemplo**

`````json
{
  "data": {
    "identificacion": "39526796"
  }
}
`````

### Documentos de Prueba

`````html
1193029667, 1140907250, 1007218621, 79962253, 26430836, 
1127606400, 51788258, 5884877, 78036389, 1068589463, 
31198035, 80012453, 39526796, 1003715670, 1016061064, 
1118305490, 13165624, 1007633666, 1120748852, 21587653, 43043364
`````

### Resultado

- Servicio que permite retornar los datos de las obligaciones de un cliente.

``````json
{
  "status": 200,
  "msg": "Successful registration",
  "data": [
    {
      "fecha_generacion": "2023-03-28 10:17:04 -0500",
      "obligacion_colte": "",
      "propietario": "DFS",
      "casa_cobro": "3_AYS",
      "identificacion": "39526796",
      "nombre_completo": "MARIA FABIOLA MUÑOZ ",
      "nro_obligacion": "13258477",
      "fecha_desembolso": "2021-11-13",
      "clinica": "PLAZA IMPERIAL",
      "originador": "NEGOZIA",
      "valor_desembolsado": "2956800.0",
      "tasa_corriente": "25.91",
      "dias_mora": "439",
      "plazo_inicial": "12",
      "estado_obligacion": "EN MORA",
      "cuotas_mora": "11",
      "fallecido": "",
      "pago_minimo": "3120097.05",
      "saldo_total": "3120097.05",
      "saldo_capital": "0.0",
      "fch_ult_pago": "2021-12-29",
      "total_recaudo": "290400.0",
      "total_recaudo_mes": "0.0",
      "trama": "09. > 360",
      "cel1": "3006443103",
      "cel2": "3017549691"
    }
  ]
}
``````
