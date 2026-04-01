# Consultar recaudo por ID

## Resumen
Consulta un deudor por el **ID de un recaudo**, incluyendo información del crédito y del recaudo.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/consultar`
- **Ambientes**:
  - **Prueba**: `https://testing-sygma.com/api/consultar`
  - **Producción**: `POR_DEFINIR/api/consultar`

## Autenticación
- **Tipo**: `Bearer token`
- **Header**: `Authorization: Bearer <token>`

## Headers
- **Accept**: `application/json` (obligatorio)
- **Content-Type**: `application/json` (obligatorio)
- **Authorization**: `Bearer <token>` (obligatorio)

## Request

### Notas de negocio
- El parámetro **servicio** debe enviarse en **`CONSULTA_RECAUDO`**.
- El parámetro **dato** corresponde al **Id Recaudo TESEO** del deudor que se desea consultar.

### Body (JSON)

#### Campos
| Campo | Tipo | Requerido | Descripción |
|------|------|-----------|-------------|
| servicio | string | sí | Debe enviarse `CONSULTA_RECAUDO`. |
| dato | string | sí | Id recaudo TESEO. |

#### Ejemplo
```json
{
  "servicio": "CONSULTA_RECAUDO",
  "dato": "27438761"
}
```

## Responses

### 200 OK (Success)
```json
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
```

## Errores comunes

### 400/403 (No cuenta con permisos)
```json
{
  "status": false,
  "message": "No cuenta con los permisos para consumir el servicio",
  "code": 400
}
```

### Recaudo no válido
```json
{
  "status": false,
  "message": "Id del recaudo no válido",
  "code": 400
}
```

### Token inválido

```json
{
  "status": false,
  "message": "Token Inválido",
  "details": "Signature has expired",
  "code": 400
}
```

### Campo requerido no enviado

```json
{
  "status": false,
  "message": "El parámetro :dato es requerido",
  "code": 400
}
```