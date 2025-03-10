# Descripción del Servicio

## **Introducción**
Este servicio genera un archivo JSON con la información básica de un deudor registrado en la plataforma **TESEO**. La consulta se puede realizar utilizando diversos parámetros, como el número de obligación y la identificación.
## **Funcionamiento**
- Recibe una solicitud con datos en formato JSON.
- Valida que todos los campos obligatorios estén presentes.
- Valida que tenga permisos al consumo del servicio.
- Procesa la información según la configuración establecida.
- Devuelve el plan de pagos generado en respuesta.

## **Validaciones**
Para garantizar la integridad y coherencia de los datos, el servicio realiza diversas validaciones antes de procesar la solicitud. Si algún dato es inválido o falta información requerida, se generará un mensaje de error con la descripción del problema.

## **Formato de Entrada**
Los datos deben enviarse en formato JSON, siguiendo la estructura establecida.

- **Ejemplo de solicitud Consulta Persona (ALAFECHA_BASICO):** 
```json
{
  "persona": {
    "persona_id": "9755361",
    "identificacion": "37195302",
    "nombre": "AYDE TAMARA MARIN",
    "telefono": "",
    "obl_nro_total": "1",
    "obl_pago_minimo": "210000",
    "obl_pago_total": "271045",
    "obligaciones": [
      {
        "personasobligacion_id": "8864845",
        "nro_obligacion": "204202004756",
        "idcredito": "11632563",
        "pago_minimo": "210000",
        "pago_total": "271045"
      }
    ]
  }
}
```

- **Ejemplo de solicitud Consulta Persona (ALAFECHA_COMPLETO):**
```json
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
```

- **Ejemplo de solicitud Consulta por ID Obligación (ALAFECHA_OBLIGACION):**
```json
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
```
