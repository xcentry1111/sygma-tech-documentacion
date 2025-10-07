# 📘 Servicio para **Simulación de Plan de Pagos**

**Descripción:**  
Este servicio permite generar la simulación de un plan de pagos a partir de un valor determinado, devolviendo todas las combinaciones posibles de cuotas y sus respectivas condiciones.

**Tipo de Servicio:** `POST`

---

## 🛰️ URL de Integración

- **Prueba:** `https://testing-sygma.com/api/datos_simulador`
- **Producción:** `POR_DEFINIR/api/datos_simulador`

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
  "servicio": "SIMULADOR_NEGOCIA"
}
```
### ✅ Respuesta Exitosa - Ejemplo

````json
[
  {
    "valor": 100000.00,
    "plazo": 1,
    "nro_cuota": 1,
    "fecha_vence": "2025-05-23",
    "inicial": 100000.00,
    "cuota": 186026.90,
    "capital": 100000.00,
    "interes": 1918.90,
    "seguro": 300.00,
    "finanza": 3200.00,
    "iva_fianza": 608.00,
    "plataforma": 80000.00,
    "final": 0.00
  },
  {
    "valor": 100000.00,
    "plazo": 2,
    "nro_cuota": 1,
    "fecha_vence": "2025-05-23",
    "inicial": 100000.00,
    "cuota": 94615.00,
    "capital": 48588.10,
    "interes": 1918.90,
    "seguro": 300.00,
    "finanza": 3200.00,
    "iva_fianza": 608.00,
    "plataforma": 40000.00,
    "final": 51411.90
  }
]

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

#### ⚠️ Campo servicio requerido

````json
{
  "status": false,
  "message": "El parámetro :servicio es requerido",
  "code": 400
}
````

#### 🧠 Consideraciones

- Este servicio no requiere parámetros adicionales, solo el tipo de servicio.

- La respuesta siempre es un arreglo de objetos, cada uno representando una opción de plan de pago.

- Todos los cálculos (cuota, interés, seguro, etc.) son generados automáticamente por el sistema.