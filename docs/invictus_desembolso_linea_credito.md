# 📘 Manual de Integración API: Cálculo de Desembolso

## Descripción del Servicio

Este servicio permite calcular los descuentos, cobros y el valor final a pagar al cliente para un desembolso de crédito. El servicio recibe la información de la línea de crédito seleccionada, el plazo y el valor deseado por el cliente, y retorna el desglose completo de los montos aplicables, incluyendo todos los descuentos que TESEO aplicará al desembolso.

---

## Flujo del Proceso

### Contexto General

Este servicio es el **cuarto paso** del flujo de desembolso, ejecutándose después de que el usuario confirma la selección de línea, plazo y valor en el modal de confirmación:

```
Servicio 1: Validación de Crédito Vigente
     ↓
Servicio 2: Validación de OTP
     ↓ (retorna success + líneas de crédito)
Sección 2: Datos Crédito (Selección UI)
     ↓ (usuario selecciona línea, plazo, valor)
     ↓ (presiona [Calcular Desembolso])
Modal de Confirmación
     ↓ (usuario selecciona [Aceptar])
Servicio 4: Cálculo de Desembolso (este documento) ← ESTAMOS AQUÍ
     ↓ (calcula descuentos y valor final)
Sección 3: Realizar Desembolso
```

### Secuencia del Flujo

```
1. Usuario completa Sección 2: Datos Crédito
   - Ha seleccionado una línea de crédito
   - Ha ingresado y confirmado plazo
   - Ha ingresado y confirmado valor
   - Todos los campos validados correctamente
   ↓
2. Usuario presiona [Calcular Desembolso]
   ↓
3. Sistema muestra Modal de Confirmación
   - Cliente: [Nombre]
   - Línea de Crédito: [Nombre línea]
   - Plazo: [X meses]
   - Valor Total: $[XXX,XXX]
   ↓
4. Usuario selecciona [Aceptar]
   ↓
5. Sistema consume este servicio (TESEO)
   ↓
6. Servicio ejecuta cálculo de descuentos
   ↓
7. Respuesta según resultado:
   - exitosa → Habilita Sección 3 con valores calculados
   - error → Muestra modal de error y regresa a inicio
```

---

## Información Técnica

### Tipo de Servicio

**Método HTTP:** `POST`

---

### URL de Integración

| Ambiente | URL |
|----------|-----|
| **Pruebas (QA)** | `https://testing-sygma.com/api/calculo_desembolso` |
| **Producción** | `POR DEFINIR` |

---

### Headers Requeridos

| Nombre | Valor | Requerido | Descripción |
|--------|-------|-----------|-------------|
| `Authorization` | `Bearer {token}` | ✅ | Token de autenticación JWT |
| `Accept` | `application/json` | ✅ | Formato de respuesta esperado |
| `Content-Type` | `application/json` | ✅ | Formato del cuerpo de la petición |

#### 🔐 Obtención del Token

!!! "Obtención del Token" El token se obtiene a través del módulo de autenticación, usando el usuario y contraseña asignados por la entidad.

**Endpoint de autenticación:**
```
POST https://testing-sygma.com/api/login
```

---

## Request

### Cuerpo de la Solicitud

La solicitud debe enviarse en formato **raw JSON** con los siguientes campos:

#### Campos Obligatorios

| Campo | Tipo | Longitud | Requerido | Descripción |
|-------|------|----------|-----------|-------------|
| `tiposdocumento_id` | string | - | ✅ | ID del tipo de documento según catálogo |
| `identificacion` | string | variable | ✅ | Número de identificación del usuario |
| `guid` | string | UUID | ✅ | UUID de la transacción del proceso actual |
| `linea_credito_id` | string | - | ✅ | Identificador de la línea de crédito seleccionada |
| `plazo_meses` | integer | - | ✅ | Plazo en meses seleccionado por el cliente |
| `valor_desembolso` | number | - | ✅ | Valor del desembolso solicitado |

#### Catálogo de Tipos de Documento

| `tiposdocumento_id` | Descripción | Código |
|---------------------|-------------|--------|
| `1` | Cédula de ciudadanía | CC |
| `2` | Cédula de extranjería | CE |
| `3` | NIT | NIT |
| `8` | Pasaporte | PA |
| `181` | Permiso Especial | PEP |

#### Origen de los Datos (Captura en Invictus)

| Campo | Origen en Invictus                                                   | Momento de Captura |
|-------|----------------------------------------------------------------------|-------------------|
| `id_linea_credito` | Sección 1: Identificador de la linea de credito"                     | Al inicio del proceso |
| `tiposdocumento_id` | Sección 1: Datos Cliente → Campo "Tipo de Identificación"            | Al inicio del proceso |
| `identificacion` | Sección 1: Datos Cliente → Campo "Número de Identificación"          | Al inicio del proceso |
| `guid` | Retornado por Servicio 2 (Validación OTP) o Servicio 3 (Reenvío OTP) | Durante validación OTP |
| `linea_credito_id` | Sección 2: Datos Crédito → Línea seleccionada (checkbox)             | Al seleccionar línea |
| `plazo_meses` | Sección 2: Datos Crédito → Campo [Confirme Plazo]                    | Al confirmar plazo |
| `valor_desembolso` | Sección 2: Datos Crédito → Campo [Confirme Valor]                    | Al confirmar valor |

#### Ejemplo de Request

```json
{
  "id_linea_credito": 27375, 
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "guid": "b2c3d4e5-f6g7-8901-bcde-fg2345678901",
  "linea_credito_id": "linea_digital_001",
  "plazo_meses": 4,
  "valor_desembolso": 500000
}
```

---

## Response

### Estructura de Respuesta Exitosa

**Código HTTP:** `200 OK`

**Status:** `"exitosa"`

```json
{
  "status": "exitosa",
  "datos": {
    "guid": "b2c3d4e5-f6g7-8901-bcde-fg2345678901",
    "mensaje": "Cálculo de desembolso realizado exitosamente.",
    "nombre_cliente": "Fernando Osorio",
    "id_linea_credito": 27375,
    "linea_credito": "Línea Digital",
    "plazo_meses": 4,
    "valor_total": 500000,
    "valor_cobros": 12050,
    "valor_a_pagar_cliente": 487950,
    "plaza_empresa": 50,
    "detalles_descuentos": [
      {
        "concepto": "IVA",
        "valor": 8000,
        "descripcion": "Impuesto al Valor Agregado sobre comisiones"
      },
      {
        "concepto": "Seguro",
        "valor": 4000,
        "descripcion": "Seguro de vida y desempleo"
      },
      {
        "concepto": "Comisión",
        "valor": 50,
        "descripcion": "Comisión administrativa"
      }
    ],
    "fecha_calculo": "2025-10-10 15:45:30"
  }
}
```

#### Descripción de Campos de Respuesta

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `status` | string | Indicador del resultado: `"exitosa"` |
| `datos` | object | Objeto con toda la información calculada |
| `datos.guid` | string | Identificador único de la transacción (mismo del request) |
| `datos.mensaje` | string | Mensaje de confirmación del cálculo |
| `datos.nombre_cliente` | string | Nombre completo del cliente (confirmación) |
| `datos.linea_credito` | string | Nombre de la línea de crédito seleccionada |
| `datos.plazo_meses` | integer | Plazo en meses (confirmación) |
| `datos.valor_total` | number | Valor total solicitado por el cliente |
| `datos.valor_cobros` | number | Suma de todos los descuentos/cobros aplicados |
| `datos.valor_a_pagar_cliente` | number | **Monto final que recibirá el cliente físicamente** |
| `datos.plaza_empresa` | number | Código de la plaza/empresa donde se realiza el desembolso |
| `datos.detalles_descuentos` | array | Array con el desglose de cada cobro/descuento |
| `datos.detalles_descuentos[].concepto` | string | Nombre del cobro (IVA, Seguro, Comisión, etc.) |
| `datos.detalles_descuentos[].valor` | number | Monto del cobro individual |
| `datos.detalles_descuentos[].descripcion` | string | Descripción detallada del cobro |
| `datos.fecha_calculo` | string | Timestamp del cálculo (formato: YYYY-MM-DD HH:MM:SS) |

---

## Respuestas de Error

### Error 1: Token de Autenticación Inválido

**Código HTTP:** `401 Unauthorized`

**Response:**
```json
{
  "status": "error",
  "mensaje": "Token de autorización inválido o ausente."
}
```

**Comportamiento en Invictus:**
- Mostrar mensaje modal rojo: **"Token de autorización inválido o ausente"**
- Botón **[CERRAR]** para cerrar el modal
- **Cerrar modal → REGRESA a la pantalla principal de Invictus**
- Usuario debe **reiniciar la transacción de desembolso**
- **Nota:** Este token corresponde a la autenticación del sistema Invictus con TESEO

---

### Error 2: Transacción No Encontrada

**Código HTTP:** `404 Not Found`

**Response:**
```json
{
  "status": "error",
  "mensaje": "Transacción no encontrada o inválida."
}
```

**Comportamiento en Invictus:**
- Mostrar mensaje modal naranja: **"Transacción no encontrada o inválida"**
- Botón **[CERRAR]** para cerrar el modal
- **Cerrar modal → REGRESA a la pantalla principal de Invictus**
- Usuario debe **reiniciar la transacción de desembolso**

---

### Error 3: Campos Requeridos Faltantes

**Código HTTP:** `400 Bad Request`

**Response:**
```json
{
  "status": "error",
  "errors": [
    "El campo linea_credito_id es obligatorio.",
    "El campo plazo_meses es obligatorio."
  ]
}
```

---

## Tabla Resumen de Respuestas

| # | Condición | HTTP Code | status | Mensaje | Comportamiento Invictus | Reinicia Proceso |
|---|-----------|-----------|--------|---------|------------------------|------------------|
| 1 | Cálculo exitoso | 200 | `exitosa` | "Cálculo de desembolso realizado exitosamente." | Habilita Sección 3 con valores | No |
| 2 | Token inválido/ausente | 401 | `error` | "Token de autorización inválido o ausente." | Modal rojo, regresa a inicio | **SÍ** |
| 3 | Transacción no encontrada | 404 | `error` | "Transacción no encontrada o inválida." | Modal naranja, regresa a inicio | **SÍ** |
| 4 | Campos faltantes | 400 | `error` | Lista de campos obligatorios | - | - |

---

## Ejemplos Completos

### ✅ Ejemplo 1: Cálculo Exitoso

**Request:**
```json
POST /api/calculo_desembolso
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "guid": "b2c3d4e5-f6g7-8901-bcde-fg2345678901",
  "linea_credito_id": "linea_digital_001",
  "plazo_meses": 4,
  "valor_desembolso": 500000
}
```

**Response:**
```json
HTTP/1.1 200 OK
Content-Type: application/json

{
  "status": "exitosa",
  "datos": {
    "guid": "b2c3d4e5-f6g7-8901-bcde-fg2345678901",
    "mensaje": "Cálculo de desembolso realizado exitosamente.",
    "nombre_cliente": "Fernando Osorio",
    "id_linea_credito": 27375,
    "linea_credito": "Línea Digital",
    "plazo_meses": 4,
    "valor_total": 500000,
    "valor_cobros": 12050,
    "valor_a_pagar_cliente": 487950,
    "plaza_empresa": 50,
    "detalles_descuentos": [
      {
        "concepto": "IVA",
        "valor": 8000,
        "descripcion": "Impuesto al Valor Agregado sobre comisiones"
      },
      {
        "concepto": "Seguro",
        "valor": 4000,
        "descripcion": "Seguro de vida y desempleo"
      },
      {
        "concepto": "Comisión",
        "valor": 50,
        "descripcion": "Comisión administrativa"
      }
    ],
    "fecha_calculo": "2025-10-10 15:45:30"
  }
}
```

**Acción en Invictus:**
1. Habilita **Sección 3: Realizar Desembolso**
2. Muestra valores calculados en los campos:
   - Valor Total: **$500,000**
   - Valor Cobros: **$12,050**
   - Plaza Empresa: **50**
   - **Valor a Pagar al Cliente: $487,950** ← **DESTACADO (monto a entregar físicamente)**
3. Muestra tabla de desglose de descuentos:
   ```
   IVA         $8,000    Impuesto al Valor Agregado
   Seguro      $4,000    Seguro de vida y desempleo
   Comisión    $50       Comisión administrativa
   ```
4. **BLOQUEA** Sección 1 y Sección 2 (no editables)
5. Usuario NO debe entregar dinero todavía (espera completar Sección 3)

---

### 🔐 Ejemplo 2: Error de Autenticación

**Request:**
```json
POST /api/calculo_desembolso
Authorization: Bearer token_invalido_expirado
Content-Type: application/json

{
  "id_linea_credito": 27375,
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "guid": "b2c3d4e5-f6g7-8901-bcde-fg2345678901",
  "linea_credito_id": "linea_digital_001",
  "plazo_meses": 4,
  "valor_desembolso": 500000
}
```

**Response:**
```json
HTTP/1.1 401 Unauthorized
Content-Type: application/json

{
  "status": "error",
  "mensaje": "Token de autorización inválido o ausente."
}
```

**Acción en Invictus:**
- Modal **ROJO** con texto: **"Token de autorización inválido o ausente"**
- Botón **[CERRAR]**
- Al cerrar → **REGRESA a pantalla principal de Invictus**
- **Proceso de desembolso se REINICIA desde el principio**

---

### ❌ Ejemplo 3: Transacción No Encontrada

**Request:**
```json
POST /api/calculo_desembolso
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "id_linea_credito": 27375,
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "guid": "guid-invalido-12345",
  "linea_credito_id": "linea_digital_001",
  "plazo_meses": 4,
  "valor_desembolso": 500000
}
```

**Response:**
```json
HTTP/1.1 404 Not Found
Content-Type: application/json

{
  "status": "error",
  "mensaje": "Transacción no encontrada o inválida."
}
```

