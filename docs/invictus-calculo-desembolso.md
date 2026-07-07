# Cálculo de Desembolso (Invictus)

## Resumen
Calcula los montos del desembolso (fianza anticipada, IVA y valor neto a entregar al cliente) **sin ejecutar ninguna transacción real**. No requiere OTP, no crea obligaciones, no modifica ningún registro. Es el **Servicio 4** del flujo y debe consumirse antes de mostrar la Sección 3: Realizar Desembolso, para que el asesor y el cliente visualicen exactamente cuánto recibirá.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/calcular_desembolso`
- **Ambientes**:
  - **Pruebas (QA)**: `https://testing-sygma.com/api/calcular_desembolso`
  - **Producción**: `POR DEFINIR`

## Autenticación
- **Tipo**: `Bearer token`
- **Header**: `Authorization: Bearer <token>`
- **Obtención del token**: `POST https://testing-sygma.com/api/login`

## Headers
- **Authorization**: `Bearer <token>` (obligatorio)
- **Accept**: `application/json` (obligatorio)
- **Content-Type**: `application/json` (obligatorio)

---

## Notas / Flujo

### Contexto General

Este servicio es el **cuarto paso** del flujo de desembolso, ejecutándose después de que el usuario selecciona la línea de crédito, confirma el plazo y el valor:

```
Servicio 1: Validación de Crédito Vigente
     ↓
Servicio 2: Validación de OTP
     ↓ (retorna success + líneas de crédito)
Sección 2: Datos Crédito (Selección UI)
     ↓ (usuario selecciona línea, plazo, valor)
Servicio 4: Cálculo de Desembolso (este documento) ← ESTAMOS AQUÍ
     ↓ (calcula descuentos y valor final)
Sección 3: Realizar Desembolso (muestra valores calculados)
     ↓ (usuario presiona [Pagar])
Servicio 5: Ejecución de Desembolso Final
```

### Propósito del Servicio

- Calcular la **fianza anticipada** (valor_cobros) y el **valor neto** (valor_a_pagar_cliente) usando el simulador interno de TESEO (PRC).
- Validar que el monto y plazo solicitados estén dentro de los rangos permitidos.
- Validar que el cupo de la línea de crédito sea suficiente para el valor solicitado.
- **No registra nada**. Puede llamarse múltiples veces con diferentes valores/plazos sin efectos secundarios.

### Secuencia del Flujo

```
1. Usuario se encuentra en Sección 2: Datos Crédito
   - Seleccionó línea de crédito (checkbox)
   - Ingresó o confirmó el plazo en meses
   - Ingresó el valor total a solicitar
   - Presiona [Calcular]
   ↓
2. Sistema consume este servicio (TESEO)
   ↓
3. Servicio ejecuta validaciones y cálculo:

   a) Validación de Autenticación
      ↓ Token inválido? → SÍ: retorna "error" (401)

   b) Validación de Campos Requeridos
      ↓ Campos vacíos o inválidos? → SÍ: retorna "error" (400)

   c) Validación de Rangos (monto y plazo)
      ↓ Fuera de rango? → SÍ: retorna "error" (400)

   d) Validación de Cupo en Línea de Crédito
      ↓ Línea no disponible? → SÍ: retorna "error"
      ↓ Monto supera cupo? → SÍ: retorna "credit_not_available"

   e) Cálculo vía PRC (simulador TESEO)
      ↓ Error en simulador? → SÍ: retorna "error" (500)

   f) Validación de Coherencia de Montos
      ↓ valor_total ≠ valor_cobros + valor_a_pagar_cliente? → SÍ: retorna "error" (400)

   g) Retorna "success" con desglose completo
   ↓
4. Comportamiento según respuesta:

   - success → Habilita Sección 3: Realizar Desembolso
               Muestra valor_cobros y valor_a_pagar_cliente
               Habilita botón [Pagar]

   - error (autenticación) → Modal rojo, permanece en Sección 2

   - error (validación) → Muestra errores, permanece en Sección 2

   - credit_not_available → Modal naranja, el usuario ajusta el valor
```

---

## Información Técnica

### Tipo de Servicio

**Método HTTP:** `POST`

---

### URL de Integración

| Ambiente | URL |
|----------|-----|
| **Pruebas (QA)** | `https://testing-sygma.com/api/calcular_desembolso` |
| **Producción** | `POR DEFINIR` |

---

### Headers Requeridos

| Nombre | Valor | Requerido | Descripción |
|--------|-------|-----------|-------------|
| `Authorization` | `Bearer {token}` | ✅ | Token de autenticación JWT |
| `Accept` | `application/json` | ✅ | Formato de respuesta esperado |
| `Content-Type` | `application/json` | ✅ | Formato del cuerpo de la petición |

---

## Request

### Cuerpo de la Solicitud

La solicitud debe enviarse en formato **raw JSON** con los siguientes campos:

#### Campos Obligatorios

| Campo | Tipo | Requerido | Descripción |
|-------|------|-----------|-------------|
| `tiposdocumento_id` | string | ✅ | ID del tipo de documento según catálogo |
| `identificacion` | string | ✅ | Número de identificación del cliente |
| `guid` | string (UUID) | ✅ | UUID retornado por Servicio 2 (Validación OTP) o Servicio 3 (Reenvío OTP) |
| `id_linea_credito` | integer | ✅ | Identificador de la línea de crédito seleccionada |
| `plazo_meses` | integer | ✅ | Plazo en meses (debe ser mayor a cero, dentro de rangos permitidos) |
| `valor_total` | number | ✅ | Valor total del desembolso solicitado (debe ser mayor a cero, dentro de rangos) |
| `plaza_empresa` | integer | ✅ | Código de la plaza/empresa donde se realiza la transacción |

#### Campos Opcionales

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `valor_cobros` | number | Si se envía, TESEO valida que coincida con el cálculo (tolerancia ±1 peso) |
| `valor_a_pagar_cliente` | number | Si se envía, TESEO valida que coincida con el cálculo (tolerancia ±1 peso) |

#### Catálogo de Tipos de Documento

| `tiposdocumento_id` | Descripción | Código |
|---------------------|-------------|--------|
| `1` | Cédula de ciudadanía | CC |
| `2` | Cédula de extranjería | CE |
| `3` | NIT | NIT |
| `8` | Pasaporte | PA |
| `181` | Permiso Especial | PEP |

#### Rangos Permitidos (Configurados en TESEO)

| Parámetro | Valor mínimo | Valor máximo |
|-----------|-------------|-------------|
| `valor_total` | $200,000 | $3,500,000 |
| `plazo_meses` | 1 mes | 12 meses |

> Los rangos pueden variar según la configuración de parámetros en TESEO.

#### Origen de los Datos en Invictus

| Campo | Origen en Invictus | Momento de Captura |
|-------|-------------------|-------------------|
| `tiposdocumento_id` | Sección 1: Datos Cliente → "Tipo de Identificación" | Al inicio del proceso |
| `identificacion` | Sección 1: Datos Cliente → "Número de Identificación" | Al inicio del proceso |
| `guid` | Retornado por Servicio 2 (Validación OTP) o Servicio 3 (Reenvío OTP) | Durante validación OTP |
| `id_linea_credito` | Sección 2: Datos Crédito → Línea seleccionada (checkbox) | Al seleccionar línea |
| `plazo_meses` | Sección 2: Datos Crédito → Campo [Confirme Plazo] | Al confirmar plazo |
| `valor_total` | Sección 2: Datos Crédito → Campo de valor ingresado | Al ingresar el valor |
| `plaza_empresa` | Configuración interna de Invictus por punto de venta | Fijo por sesión |

#### Ejemplo de Request

```json
{
  "tiposdocumento_id": "1",
  "identificacion": "1034567890",
  "guid": "30cdcb83-9d2c-4918-b015-ca9c481e381e",
  "id_linea_credito": "1743840501964083",
  "plazo_meses": 2,
  "valor_total": 200000,
  "plaza_empresa": 50
}
```

---

## Response

### Estructura de Respuesta Exitosa

**Código HTTP:** `200 OK`

**Status:** `"success"`

```json
{
  "status": "success",
  "datos": {
    "guid": "30cdcb83-9d2c-4918-b015-ca9c481e381e",
    "mensaje": "Cálculo de desembolso realizado correctamente. Este es un cálculo previo, no se ha ejecutado ningún desembolso.",
    "nombre_cliente": "SANTIAGO DAVID JIMENEZ PINTO",
    "identificacion": "1034567890",
    "linea_credito": "Línea Credintegral",
    "valor_total": 200000.0,
    "valor_cobros": 4284,
    "valor_a_pagar_cliente": 195716,
    "plazo_meses": 2,
    "plaza_empresa": 50,
    "fecha_desembolso": "2026-07-07 13:27:00",
    "comprobante": {
      "fecha_hora": "2026-07-07 13:27:00",
      "concepto": "Cálculo previo de desembolso",
      "detalles_descuentos": [
        {
          "concepto": "Fianza Anticipada",
          "valor": 3600
        },
        {
          "concepto": "IVA Fianza Anticipada",
          "valor": 684
        }
      ]
    }
  }
}
```

#### Descripción de Campos de Respuesta

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `status` | string | Indicador del resultado: `"success"` |
| `datos` | object | Objeto con el desglose completo del cálculo |
| `datos.guid` | string | El mismo UUID enviado en el request (identificador del proceso) |
| `datos.mensaje` | string | Confirmación de que es un cálculo previo, no un desembolso real |
| `datos.nombre_cliente` | string | Nombre completo del cliente según TESEO |
| `datos.identificacion` | string | Número de identificación del cliente |
| `datos.linea_credito` | string | Nombre de la línea de crédito seleccionada |
| `datos.valor_total` | number | Valor total solicitado por el cliente |
| `datos.valor_cobros` | number | **Suma de todos los descuentos aplicados (fianza + IVA)** |
| `datos.valor_a_pagar_cliente` | number | **Monto neto a entregar físicamente al cliente** |
| `datos.plazo_meses` | integer | Plazo en meses confirmado |
| `datos.plaza_empresa` | integer | Código de la plaza/empresa |
| `datos.fecha_desembolso` | string | Timestamp del cálculo (formato: YYYY-MM-DD HH:MM:SS) |
| `datos.comprobante` | object | Desglose del cálculo de cobros |
| `datos.comprobante.fecha_hora` | string | Fecha y hora del cálculo |
| `datos.comprobante.concepto` | string | `"Cálculo previo de desembolso"` |
| `datos.comprobante.detalles_descuentos` | array | Desglose ítem por ítem de los cobros aplicados |
| `datos.comprobante.detalles_descuentos[].concepto` | string | Nombre del cobro (ej: "Fianza Anticipada", "IVA Fianza Anticipada") |
| `datos.comprobante.detalles_descuentos[].valor` | number | Valor en pesos del cobro |

> **Nota:** A diferencia del Servicio 5 (`proceso_desembolso`), esta respuesta **no incluye** `numero_desembolso` ni `numero_comprobante` ya que no se ejecuta ninguna transacción real. Tampoco incluye `instrucciones_invictus` ya que no hay acciones internas a ejecutar.

---

## Validaciones del Servicio

El servicio ejecuta las siguientes validaciones en orden secuencial:

### Nivel 1: Validación de Autenticación

**Reglas:**
- Token debe estar presente en el header `Authorization`
- Formato válido: `Bearer {token}`
- Token debe estar vigente (no expirado)
- Token debe corresponder a un usuario autorizado en TESEO

**Respuesta en caso de error:**
```json
{
  "status": "error",
  "mensaje": "Token de autorización inválido o ausente."
}
```
**Código HTTP:** `401 Unauthorized`

---

### Nivel 2: Validación de Campos Requeridos

**Reglas:**
- Todos los campos obligatorios deben estar presentes y no vacíos
- `valor_total` debe ser mayor a cero
- `plazo_meses` debe ser mayor a cero

**Respuesta en caso de error:**
```json
{
  "status": "error",
  "errors": [
    "El campo plazo_meses es obligatorio.",
    "El campo valor_total debe ser mayor a cero."
  ]
}
```
**Código HTTP:** `400 Bad Request`

---

### Nivel 3: Validación de Rangos de Monto y Plazo

**Reglas:**
- `valor_total` debe estar dentro del rango mínimo-máximo configurado en TESEO
- `plazo_meses` debe estar dentro del rango mínimo-máximo configurado en TESEO

**Respuesta en caso de error:**
```json
{
  "status": "error",
  "mensaje": "El valor_total no puede ser menor a $200000."
}
```
**Código HTTP:** `400 Bad Request`

---

### Nivel 4: Validación de Cupo en Línea de Crédito

**Proceso:**
1. Se consulta `fnc_json_credintegral` con el `id_linea_credito` para verificar disponibilidad
2. Se valida que la línea de crédito exista y esté activa para el cliente
3. Se verifica que el `valor_total` no supere el `total_disponible` de la línea

**Resultado 4.1: Línea no encontrada**
```json
{
  "status": "error",
  "mensaje": "La línea de crédito seleccionada no está disponible."
}
```
**Código HTTP:** `200 OK`

**Resultado 4.2: Monto supera cupo disponible**
```json
{
  "status": "credit_not_available",
  "mensaje": "El monto solicitado supera el cupo disponible.",
  "razon": "sin_cupo",
  "detalles": "Cupo disponible: 150000, solicitado: 200000."
}
```
**Código HTTP:** `200 OK`

**Comportamiento en Invictus:**
- Modal naranja informando cupo insuficiente
- El asesor puede ajustar el `valor_total` a un monto menor e intentar nuevamente

---

### Nivel 5: Cálculo vía Simulador PRC

**Proceso:**
1. TESEO invoca el procedimiento `prc_simulador_crediintegral` con el monto y plazo
2. Se obtiene `valor_cobros` (fianza anticipada + IVA) y `valor_a_pagar_cliente` (neto)
3. Se genera el desglose detallado de cobros

**Respuesta en caso de error del simulador:**
```json
{
  "status": "error",
  "mensaje": "No fue posible calcular los montos del desembolso.",
  "errores": ["No se obtuvieron datos del simulador."]
}
```
**Código HTTP:** `500 Internal Server Error`

---

### Nivel 6: Validación de Montos Enviados (Opcional)

Si Invictus envía `valor_cobros` y/o `valor_a_pagar_cliente` en el request, TESEO los compara contra el cálculo del simulador con una tolerancia de ±1 peso.

**Respuesta si no coinciden:**
```json
{
  "status": "error",
  "mensaje": "Los montos enviados no coinciden con el cálculo de fianza anticipada.",
  "errores": ["valor_cobros esperado: 4284, recibido: 5000"]
}
```
**Código HTTP:** `400 Bad Request`

---

### Nivel 7: Validación de Coherencia de Montos

**Regla:** `valor_total = valor_cobros + valor_a_pagar_cliente` (tolerancia ±1 peso)

**Respuesta en caso de incoherencia:**
```json
{
  "status": "error",
  "mensaje": "Los montos calculados no son coherentes con el valor_total.",
  "errores": ["El valor_total no coincide con valor_a_pagar_cliente + valor_cobros"]
}
```
**Código HTTP:** `400 Bad Request`

---

## Respuestas de Error

### Error 1: Token de Autenticación Inválido

**Código HTTP:** `401 Unauthorized`
```json
{
  "status": "error",
  "mensaje": "Token de autorización inválido o ausente."
}
```

---

### Error 2: Campos Requeridos Faltantes

**Código HTTP:** `400 Bad Request`
```json
{
  "status": "error",
  "errors": [
    "El campo guid es obligatorio.",
    "El campo valor_total es obligatorio."
  ]
}
```

---

### Error 3: Rango de Monto o Plazo Inválido

**Código HTTP:** `400 Bad Request`
```json
{
  "status": "error",
  "mensaje": "El valor_total no puede ser mayor a $3500000."
}
```

---

### Error 4: Cupo Insuficiente en la Línea

**Código HTTP:** `200 OK`
```json
{
  "status": "credit_not_available",
  "mensaje": "El monto solicitado supera el cupo disponible.",
  "razon": "sin_cupo",
  "detalles": "Cupo disponible: 150000, solicitado: 200000."
}
```

---

### Error 5: Línea de Crédito No Disponible

**Código HTTP:** `200 OK`
```json
{
  "status": "error",
  "mensaje": "La línea de crédito seleccionada no está disponible."
}
```

---

### Error 6: Error Interno en Simulador

**Código HTTP:** `500 Internal Server Error`
```json
{
  "status": "error",
  "mensaje": "No fue posible calcular los montos del desembolso.",
  "errores": ["No se obtuvieron datos del simulador."]
}
```

---

### Error 7: Montos Incoherentes

**Código HTTP:** `400 Bad Request`
```json
{
  "status": "error",
  "mensaje": "Los montos calculados no son coherentes con el valor_total.",
  "errores": ["El valor_total no coincide con valor_a_pagar_cliente + valor_cobros"]
}
```

---

### Error 8: Error Interno General

**Código HTTP:** `500 Internal Server Error`
```json
{
  "status": "error",
  "mensaje": "Error interno en cálculo de desembolso."
}
```

---

## Tabla Resumen de Respuestas

| # | Condición | HTTP Code | status | Comportamiento Invictus |
|---|-----------|-----------|--------|------------------------|
| 1 | Cálculo exitoso | 200 | `success` | Habilita Sección 3, muestra desglose de cobros |
| 2 | Token inválido/ausente | 401 | `error` | Modal rojo, permanece en Sección 2 |
| 3 | Campos faltantes o inválidos | 400 | `error` | Muestra errores en Sección 2 |
| 4 | Rango de monto/plazo inválido | 400 | `error` | Muestra error, el asesor corrige el valor |
| 5 | Cupo insuficiente | 200 | `credit_not_available` | Modal naranja, asesor ajusta el monto |
| 6 | Línea no disponible | 200 | `error` | Modal naranja, volver a Sección 2 |
| 7 | Error en simulador | 500 | `error` | Modal rojo, intentar nuevamente |
| 8 | Montos incoherentes | 400 | `error` | Modal rojo, revisar valores |

---

## Ejemplos Completos

### ✅ Ejemplo 1: Cálculo Exitoso

**Request:**
```json
POST /api/calcular_desembolso
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "tiposdocumento_id": "1",
  "identificacion": "1034567890",
  "guid": "30cdcb83-9d2c-4918-b015-ca9c481e381e",
  "id_linea_credito": "1743840501964083",
  "plazo_meses": 2,
  "valor_total": 200000,
  "plaza_empresa": 50
}
```

**Response:**
```json
HTTP/1.1 200 OK
Content-Type: application/json

{
  "status": "success",
  "datos": {
    "guid": "30cdcb83-9d2c-4918-b015-ca9c481e381e",
    "mensaje": "Cálculo de desembolso realizado correctamente. Este es un cálculo previo, no se ha ejecutado ningún desembolso.",
    "nombre_cliente": "SANTIAGO DAVID JIMENEZ PINTO",
    "identificacion": "1034567890",
    "linea_credito": "Línea Credintegral",
    "valor_total": 200000.0,
    "valor_cobros": 4284,
    "valor_a_pagar_cliente": 195716,
    "plazo_meses": 2,
    "plaza_empresa": 50,
    "fecha_desembolso": "2026-07-07 13:27:00",
    "comprobante": {
      "fecha_hora": "2026-07-07 13:27:00",
      "concepto": "Cálculo previo de desembolso",
      "detalles_descuentos": [
        { "concepto": "Fianza Anticipada", "valor": 3600 },
        { "concepto": "IVA Fianza Anticipada", "valor": 684 }
      ]
    }
  }
}
```

**Acción en Invictus:**
1. Poblar la Sección 3: Realizar Desembolso con los valores retornados
2. Destacar visualmente el campo **Valor a Pagar al Cliente: $195,716**
3. Habilitar el botón **[Pagar]**
4. Guardar `valor_cobros` y `valor_a_pagar_cliente` para enviarlos en el Servicio 5

---

### 🔴 Ejemplo 2: Token Inválido

**Response:**
```json
HTTP/1.1 401 Unauthorized

{
  "status": "error",
  "mensaje": "Token de autorización inválido o ausente."
}
```
**Acción en Invictus:** Modal rojo. Permanece en Sección 2.

---

### 🟠 Ejemplo 3: Monto Fuera de Rango

**Request:** `"valor_total": 50000` (menor al mínimo de $200,000)

**Response:**
```json
HTTP/1.1 400 Bad Request

{
  "status": "error",
  "mensaje": "El valor_total no puede ser menor a $200000."
}
```
**Acción en Invictus:** Mostrar error inline en el campo de valor. El asesor corrige y recalcula.

---

### 🟠 Ejemplo 4: Cupo Insuficiente

**Request:** `"valor_total": 500000` con cupo disponible de $150,000

**Response:**
```json
HTTP/1.1 200 OK

{
  "status": "credit_not_available",
  "mensaje": "El monto solicitado supera el cupo disponible.",
  "razon": "sin_cupo",
  "detalles": "Cupo disponible: 150000, solicitado: 500000."
}
```
**Acción en Invictus:** Modal naranja informando el cupo disponible. El asesor puede ajustar el valor a un monto menor.

---