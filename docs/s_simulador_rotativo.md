# 📘 Servicio para **Simulador Rotativo - Plan de Pagos Crédito Integral**

**Descripción:**
Este servicio permite simular un crédito integral generando un plan de pagos detallado según el monto solicitado y el número de cuotas deseadas. Retorna un resumen financiero completo y el detalle de cada cuota del plan de pagos.

**Tipo de Servicio:** `POST`

---

## 🛰️ URL de Integración

- **Prueba:** `https://testing-sygma.com/api/simulador_rotativo`
- **Producción:** `POR_DEFINIR/api/simulador_rotativo`

---

## 🧾 Encabezados (Headers)

| Nombre        | Valor                | Requerido |
|---------------|----------------------|-----------|
| Authorization | Bearer `{token}`     | ✅        |
| Accept        | application/json     | ✅        |
| Content-Type  | application/json     | ✅        |

> 🔐 **Nota:** El token se obtiene a través del módulo de autenticación (pestaña **Token**), usando un usuario y contraseña provistos por la entidad.

---

## 📨 Cuerpo de la Solicitud (raw)

```json
{
  "monto": "200000",
  "cuota": 3
}
```

### 📋 Parámetros de Entrada

| Parámetro | Tipo    | Descripción                              | Requerido | Validación                          |
|-----------|---------|------------------------------------------|-----------|-------------------------------------|
| `monto`   | String  | Monto del crédito a solicitar            | ✅        | Entre $200.000 y $3.500.000         |
| `cuota`   | Integer | Número de cuotas/meses del crédito       | ✅        | Entre 1 y 18 meses                  |

---

## ✅ Respuesta Exitosa - Ejemplo

```json
{
    "status": true,
    "secuencia": "5001329",
    "resumen": {
        "secuencia": "5001329",
        "valor_cuota": 107747,
        "fianza_regular": 9949,
        "seguro": 785,
        "vlr_administracion": 29900,
        "tasa_ea": 24.36,
        "total_desembolso": 195716
    },
    "plan_pagos": [
        {
            "nro_cuota": 1,
            "fecha_limite": "2025-12-02",
            "saldo_inicial": 200000,
            "capital": 98266,
            "interes": 2928,
            "seguro": 480,
            "fianza": 5104,
            "iva_fianza": 970,
            "valor_cuota": 107747,
            "saldo_final": 101735
        },
        {
            "nro_cuota": 2,
            "fecha_limite": "2026-01-02",
            "saldo_inicial": 101735,
            "capital": 101735,
            "interes": 1866,
            "seguro": 305,
            "fianza": 3256,
            "iva_fianza": 619,
            "valor_cuota": 107779,
            "saldo_final": 0
        }
    ]
}
```

### 📊 Descripción de Campos - Resumen

| Campo                  | Tipo    | Descripción                                           |
|------------------------|---------|-------------------------------------------------------|
| `secuencia`            | String  | Identificador único de la simulación                  |
| `valor_cuota`          | Integer | Valor de la cuota mensual                             |
| `total_desembolso`     | Integer | Valor neto a desembolsar al cliente                   |
| `tasa_ea`              | Float   | Tasa Efectiva Anual                                   |
| `vlr_cuota`            | Integer | Valor de la cuota (igual a `valor_cuota`)             |
| `vlr_administracion`   | Integer | Valor de administración                               |
| `seguro`               | Integer | Seguro total del crédito                              |
| `fianza_regular`       | Integer | Fianza regular total (comp + IVA)                     |

### 📋 Descripción de Campos - Plan de Pagos

| Campo           | Tipo    | Descripción                                    |
|-----------------|---------|------------------------------------------------|
| `nro_cuota`     | String  | Número de la cuota                             |
| `fecha_limite`  | String  | Fecha límite de pago (formato: YYYY-MM-DD)    |
| `saldo_inicial` | Integer | Saldo de capital al inicio del período         |
| `capital`       | Integer | Abono a capital en esta cuota                  |
| `interes`       | Integer | Interés de esta cuota                          |
| `seguro`        | Integer | Valor del seguro de esta cuota                 |
| `fianza`        | Integer | Fianza de esta cuota                           |
| `iva_fianza`    | Integer | IVA de la fianza                               |
| `valor_cuota`   | Integer | Valor total a pagar en esta cuota              |
| `saldo_final`   | Integer | Saldo de capital al final del período          |

---

## ❌ Errores Comunes

### ⚠️ Token Inválido

```json
{
  "ok": false,
  "message": "Token Inválido",
  "code": 400
}
```

### ⚠️ Parámetro monto requerido

```json
{
  "ok": false,
  "message": "El parámetro :monto es requerido y debe ser un número entero válido",
  "code": 400
}
```

### ⚠️ Parámetro cuota requerido

```json
{
  "ok": false,
  "message": "El parámetro :cuota es requerido y debe ser un número entero válido",
  "code": 400
}
```

### ⚠️ Monto menor al permitido

```json
{
  "ok": false,
  "message": "El monto no puede ser menor a $200.000",
  "code": 400
}
```

### ⚠️ Monto mayor al permitido

```json
{
  "ok": false,
  "message": "El monto no puede ser mayor a $3.500.000",
  "code": 400
}
```

### ⚠️ Plazo menor al permitido

```json
{
  "ok": false,
  "message": "El plazo no puede ser menor a 1 mes",
  "code": 400
}
```

### ⚠️ Plazo mayor al permitido

```json
{
  "ok": false,
  "message": "El plazo no puede ser mayor a 18 meses",
  "code": 400
}
```

### ⚠️ Registro no encontrado

```json
{
  "ok": false,
  "message": "Registro no encontrado",
  "details": "No se encontraron datos del simulador",
  "code": 404
}
```

### ⚠️ Error interno del servidor

```json
{
  "ok": false,
  "message": "Error interno del servidor",
  "details": "Descripción técnica del error",
  "code": 500
}
```
