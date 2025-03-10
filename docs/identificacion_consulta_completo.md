# Servicio para consultar por identificación + Obligaciones (Detallado)


**Descripción:** Este servicio recibe dos parámetros para consultar a un deudor por su identificación y devuelve un JSON con toda su información y obligaciones.

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
- El parámetro **servicio** debe establecerse por defecto en **ALAFECHA_COMPLETO**, ya que este valor permite al sistema identificar que se trata de una consulta por identificación.
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
  "servicio": "ALAFECHA_COMPLETO", 
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



### **Ejemplo Respuesta Succes segun parametrización del cliente**

``````json
{
  "persona": {
    "persona_id": "9755361",
    "identificacion": "37195302",
    "nombre": "AYDE TAMARA MARIN",
    "telefono": "",
    "obligaciones": [
      {
        "personasobligacion_id": "8864845",
        "nro_obligacion": "204202004756",
        "idcredito": "11632563",
        "fecha_matricula": "27-11-2020",
        "portafoliossucursal_id": "17146",
        "sucursal": "CUCUTA AGENCIA ATALAYA",
        "portafoliosvehiculo_id": "627",
        "vehiculo": "ALAFECHA",
        "cliente": "12940",
        "originador": "FDLM",
        "saldo_capital": "264863",
        "saldo_total": "271044",
        "plan_pagos": [
          {
            "personasobligacion_id": "8864845",
            "nro_cuota": "1",
            "fecha_vence": "14-07-2021",
            "capital": "264863.21",
            "corriente": "0",
            "comisiones": "0",
            "ivacomisiones": "0",
            "seguro": "0",
            "mora": "6181.48",
            "valor_pagar": "264863.21"
          }
        ],
        "recaudos": [
          {
            "planesrecaudo_id": "76428062",
            "personasobligacion_id": "8864845",
            "fecha_recaudo": "20-01-2025",
            "tipo_pago": "EFECTIVO",
            "estado": "",
            "tipo_afecta": "AJUSTE CUOTA",
            "usuario": "WS_ALAFECHA",
            "valor": "210000",
            "sucursal": "",
            "codigo_transaccion": "",
            "observaciones": "PAGO REALIZADO POR CAJATRANSTERCEROS DESDE FUNDACION DELAMUJER - APLICACION TANQUE - FECHA MOVIMIENTO: 2025-01-20 - OBS-OPCIONAL1: CONSIGNACION *",
            "anulado_por": "",
            "obs_anulacion": ""
          },
          {
            "planesrecaudo_id": "76299147",
            "personasobligacion_id": "8864845",
            "fecha_recaudo": "16-12-2024",
            "tipo_pago": "EFECTIVO",
            "estado": "",
            "tipo_afecta": "AJUSTE CUOTA",
            "usuario": "WS_ALAFECHA",
            "valor": "210000",
            "sucursal": "",
            "codigo_transaccion": "",
            "observaciones": "PAGO REALIZADO POR CAJATRANSTERCEROS DESDE FUNDACION DELAMUJER - APLICACION TANQUE - FECHA MOVIMIENTO: 2024-12-16 - OBS-OPCIONAL1: CONSIGNACION *",
            "anulado_por": "",
            "obs_anulacion": ""
          },
          {
            "planesrecaudo_id": "76136590",
            "personasobligacion_id": "8864845",
            "fecha_recaudo": "15-11-2024",
            "tipo_pago": "EFECTIVO",
            "estado": "",
            "tipo_afecta": "AJUSTE CUOTA",
            "usuario": "WS_ALAFECHA",
            "valor": "210000",
            "sucursal": "",
            "codigo_transaccion": "",
            "observaciones": "PAGO REALIZADO POR CAJATRANSTERCEROS DESDE FUNDACION DELAMUJER - APLICACION TANQUE - FECHA MOVIMIENTO: 2024-11-15 - OBS-OPCIONAL1: CONSIGNACION *",
            "anulado_por": "",
            "obs_anulacion": ""
          },
          {
            "planesrecaudo_id": "76005785",
            "personasobligacion_id": "8864845",
            "fecha_recaudo": "15-10-2024",
            "tipo_pago": "EFECTIVO",
            "estado": "",
            "tipo_afecta": "AJUSTE CUOTA",
            "usuario": "WS_ALAFECHA",
            "valor": "210000",
            "sucursal": "",
            "codigo_transaccion": "",
            "observaciones": "PAGO REALIZADO POR LA PLATAFORMA TESEO DESDE FUNDACION DELAMUJER - APLICACION TANQUE - FECHA MOVIMIENTO: 2024-10-15 - OBS-OPCIONAL1: CONSIGNACION *",
            "anulado_por": "",
            "obs_anulacion": ""
          },
          {
            "planesrecaudo_id": "73272730",
            "personasobligacion_id": "8864845",
            "fecha_recaudo": "29-06-2023",
            "tipo_pago": "EFECTIVO",
            "estado": "",
            "tipo_afecta": "AJUSTE CUOTA",
            "usuario": "ADMINISTRADOR SISTEMA",
            "valor": "276000",
            "sucursal": "",
            "codigo_transaccion": "",
            "observaciones": "MIGRACION DE INFORMACION - ALAFECHA",
            "anulado_por": "",
            "obs_anulacion": ""
          },
          {
            "planesrecaudo_id": "73272729",
            "personasobligacion_id": "8864845",
            "fecha_recaudo": "01-03-2021",
            "tipo_pago": "EFECTIVO",
            "estado": "",
            "tipo_afecta": "AJUSTE CUOTA",
            "usuario": "ADMINISTRADOR SISTEMA",
            "valor": "60064",
            "sucursal": "",
            "codigo_transaccion": "",
            "observaciones": "MIGRACION DE INFORMACION - ALAFECHA",
            "anulado_por": "",
            "obs_anulacion": ""
          },
          {
            "planesrecaudo_id": "73272728",
            "personasobligacion_id": "8864845",
            "fecha_recaudo": "15-01-2021",
            "tipo_pago": "EFECTIVO",
            "estado": "",
            "tipo_afecta": "AJUSTE CUOTA",
            "usuario": "ADMINISTRADOR SISTEMA",
            "valor": "60064",
            "sucursal": "",
            "codigo_transaccion": "",
            "observaciones": "MIGRACION DE INFORMACION - ALAFECHA",
            "anulado_por": "",
            "obs_anulacion": ""
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