# 📘 Servicio para **Simulación Previa de Plan de Pagos**

**Descripción:**  
Este servicio permite generar planes de pago simulados a partir de un valor ingresado. El sistema retorna diferentes opciones de monto máximo y sus respectivos planes de pago.

**Tipo de Servicio:** `POST`

---

## 🛰️ URL de Integración

- **Prueba:** `https://testing-sygma.com/api/simulador_previo`
- **Producción:** `POR_DEFINIR/api/simulador_previo`

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
  "servicio": "CREDINTEGRAL_SIMC",
  "dato": 79000
}
```

📌 **Campo dato:** Corresponde al valor base para el cual se desea generar la simulación. Debe ser un número entero válido y mayor al monto mínimo permitido por el sistema.

### ✅ Respuesta Exitosa - Ejemplo

````json
{
  "simulacion": {
    "id_consulta": "126969",
    "vlrprestamo": [
      {
        "nro_cuotas": "3",
        "monto_maximo": "100000",
        "plan_pagos": [
          {
            "nro_cuota": "1",
            "fecha_vence": "23-05-2025",
            "inicial": "100000",
            "valor_cuota": "64142.67",
            "capital": "31449.1",
            "interes": "1918.9",
            "seguro": "300",
            "fianza": "3200",
            "iva_fianza": "608",
            "plataforma": "26666.67",
            "final": "68550.9"
          },
          ...
        ]
      },
      ...
    ]
  }
}
````

### ❌ Errores Comunes

#### ⚠️ Token Inválido

````json
{
  "status": false,
  "message": "Token Inválido",
  "code": 400
}

````

#### ⚠️ Permisos insuficientes

````json
{
  "status": false,
  "message": "No cuenta con los permisos para consumir el servicio",
  "code": 400
}

````

#### ⚠️ Campo servicio requerido

````json
{
  "status": false,
  "message": "El parámetro :servicio es requerido",
  "code": 400
}

````

#### ⚠️ Campo dato inválido o faltante

````json
{
  "status": false,
  "message": "El parámetro :dato es requerido y debe ser un número entero válido",
  "code": 400
}

````

#### ⚠️ Monto inferior al permitido

````json
{
  "status": false,
  "message": "El monto no puede ser menor a {MONTO_MINIMO}",
  "code": 400
}


````

#### 🧠 Consideraciones

- El campo servicio debe enviarse en mayúsculas tal como se define en el sistema.

- El servicio valida que el usuario tenga permisos (crea = 'S') sobre el objeto correspondiente.

- El sistema consulta configuraciones internas (parámetro mínimo, consecutivo, etc.) y lanza un proceso Job para generar la simulación.

- La respuesta puede incluir múltiples combinaciones de cuotas y montos máximos, con sus respectivos detalles financieros.