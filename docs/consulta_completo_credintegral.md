# Servicio de Consulta por Identificación y Obligaciones (Detallado)

**Descripción:**  
Este servicio permite consultar la información de un deudor y sus obligaciones, enviando su número de identificación y tipo de documento.

**Tipo de Servicio:** `POST`

---

## URL de Integración

- **Ambiente de pruebas:** `http://testing-sygma.com/api/consultar_api`
- **Producción:** `POR_DEFINIR/api/consultar_api`

---

## Headers

Los siguientes encabezados son obligatorios en la solicitud:

- `Accept`: `application/json`
- `Content-Type`: `application/json`
- `Authorization`: `Bearer ${token}`

---

## Consideraciones

- El parámetro `servicio` debe enviarse con el valor fijo: `CONSULTA_COMPLETO`.
- El parámetro `dato` corresponde al **número de identificación** del deudor.
- El parámetro `tipo_documento` también es obligatorio y debe tener uno de los siguientes valores:
  - `CC` (Cédula de ciudadanía)
  - `CE` (Cédula de extranjería)
  - `TI` (Tarjeta de identidad)
- Si no se envía alguno de estos parámetros obligatorios, el sistema responderá con un error.

---

## Cuerpo de la Solicitud (raw)

**Ejemplo de solicitud JSON:**

```json
{
  "servicio": "CONSULTA_COMPLETO",
  "dato": "37195302",
  "tipo_documento": "CC"
}
```

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
    "nombre": "PRUEBA",
    "telefono": "",
    "obligaciones": [
      {
        "personasobligacion_id": "8864800",
        "nro_obligacion": "204202004788",
        "idcredito": "11632563",
        "fecha_matricula": "27-11-2020",
        "portafoliossucursal_id": "17146",
        "sucursal": "CUCUTA AGENCIA ATALAYA",
        "portafoliosvehiculo_id": "627",
        "vehiculo": "API",
        "cliente": "12940",
        "originador": "PRUEBA ORIGINADOR",
        "saldo_capital": "264863",
        "pago_minimo": "28283",
        "dias_mora": "20",
        "saldo_total": "271044",
        "plan_pagos": [
          {
            "personasobligacion_id": "8864800",
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
            "personasobligacion_id": "8864800",
            "fecha_recaudo": "20-01-2025",
            "tipo_pago": "EFECTIVO",
            "estado": "",
            "tipo_afecta": "AJUSTE CUOTA",
            "usuario": "WS_USUARIO_CONSULTA",
            "valor": "210000",
            "sucursal": "",
            "codigo_transaccion": "",
            "observaciones": "PAGO REALIZADO POR CAJATRANSTERCEROS DESDE FUNDACION DELAMUJER - APLICACION TANQUE - FECHA MOVIMIENTO: 2025-01-20 - OBS-OPCIONAL1: CONSIGNACION *",
            "anulado_por": "",
            "obs_anulacion": ""
          },
          {
            "planesrecaudo_id": "76299147",
            "personasobligacion_id": "8864800",
            "fecha_recaudo": "16-12-2024",
            "tipo_pago": "EFECTIVO",
            "estado": "",
            "tipo_afecta": "AJUSTE CUOTA",
            "usuario": "WS_USUARIO_CONSULTA",
            "valor": "210000",
            "sucursal": "",
            "codigo_transaccion": "",
            "observaciones": "PAGO REALIZADO POR CAJATRANSTERCEROS DESDE FUNDACION DELAMUJER - APLICACION TANQUE - FECHA MOVIMIENTO: 2024-12-16 - OBS-OPCIONAL1: CONSIGNACION *",
            "anulado_por": "",
            "obs_anulacion": ""
          },
          {
            "planesrecaudo_id": "76136590",
            "personasobligacion_id": "8864800",
            "fecha_recaudo": "15-11-2024",
            "tipo_pago": "EFECTIVO",
            "estado": "",
            "tipo_afecta": "AJUSTE CUOTA",
            "usuario": "WS_USUARIO_CONSULTA",
            "valor": "210000",
            "sucursal": "",
            "codigo_transaccion": "",
            "observaciones": "PAGO REALIZADO POR CAJATRANSTERCEROS DESDE FUNDACION DELAMUJER - APLICACION TANQUE - FECHA MOVIMIENTO: 2024-11-15 - OBS-OPCIONAL1: CONSIGNACION *",
            "anulado_por": "",
            "obs_anulacion": ""
          },
          {
            "planesrecaudo_id": "76005785",
            "personasobligacion_id": "8864800",
            "fecha_recaudo": "15-10-2024",
            "tipo_pago": "EFECTIVO",
            "estado": "",
            "tipo_afecta": "AJUSTE CUOTA",
            "usuario": "WS_USUARIO_CONSULTA",
            "valor": "210000",
            "sucursal": "",
            "codigo_transaccion": "",
            "observaciones": "PAGO REALIZADO POR LA PLATAFORMA TESEO DESDE FUNDACION DELAMUJER - APLICACION TANQUE - FECHA MOVIMIENTO: 2024-10-15 - OBS-OPCIONAL1: CONSIGNACION *",
            "anulado_por": "",
            "obs_anulacion": ""
          },
          {
            "planesrecaudo_id": "73272730",
            "personasobligacion_id": "8864800",
            "fecha_recaudo": "29-06-2023",
            "tipo_pago": "EFECTIVO",
            "estado": "",
            "tipo_afecta": "AJUSTE CUOTA",
            "usuario": "ADMINISTRADOR SISTEMA",
            "valor": "276000",
            "sucursal": "",
            "codigo_transaccion": "",
            "observaciones": "MIGRACION DE INFORMACION - API",
            "anulado_por": "",
            "obs_anulacion": ""
          },
          {
            "planesrecaudo_id": "73272729",
            "personasobligacion_id": "8864800",
            "fecha_recaudo": "01-03-2021",
            "tipo_pago": "EFECTIVO",
            "estado": "",
            "tipo_afecta": "AJUSTE CUOTA",
            "usuario": "ADMINISTRADOR SISTEMA",
            "valor": "60064",
            "sucursal": "",
            "codigo_transaccion": "",
            "observaciones": "MIGRACION DE INFORMACION - API",
            "anulado_por": "",
            "obs_anulacion": ""
          },
          {
            "planesrecaudo_id": "73272728",
            "personasobligacion_id": "8864800",
            "fecha_recaudo": "15-01-2021",
            "tipo_pago": "EFECTIVO",
            "estado": "",
            "tipo_afecta": "AJUSTE CUOTA",
            "usuario": "ADMINISTRADOR SISTEMA",
            "valor": "60064",
            "sucursal": "",
            "codigo_transaccion": "",
            "observaciones": "MIGRACION DE INFORMACION - API",
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