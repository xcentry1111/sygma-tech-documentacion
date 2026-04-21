# Seleccionar Lineas de Credito (Invictus)

## Resumen
Calcula descuentos/cobros y el valor final a pagar al cliente. Recibe la línea de crédito seleccionada, plazo y valor deseado, y retorna el desglose completo de montos aplicables.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/lineas_credito`
- **Ambientes**:
  - **Pruebas (QA)**: `https://testing-sygma.com/api/lineas_credito`
  - **Producción**: `POR DEFINIR`

## Autenticación
- **Tipo**: `Bearer token`
- **Header**: `Authorization: Bearer <token>`
- **Obtención del token**: `POST https://testing-sygma.com/api/login`

## Headers
- **Authorization**: `Bearer <token>` (obligatorio)
- **Accept**: `application/json` (obligatorio)
- **Content-Type**: `application/json` (obligatorio)

## Request
Ver sección **Request** (tabla de campos + ejemplo).

## Responses
Ver sección **Response** (incluye `success` con líneas de crédito y errores).

## Notas / Flujo

### Flujo del proceso

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
   - success → Habilita Sección 2 con líneas de crédito para selección
   - error → Muestra modal de error y regresa a inicio
```

### Flujo funcional previo: Seleccionar línea de crédito, valor y plazo

Este flujo corresponde a la etapa donde Invictus presenta líneas disponibles y permite escoger **una sola línea** antes del cálculo.

**Reglas funcionales clave (mockup PDF):**

1. **Carga de líneas de crédito tras OTP válido**
   - Invictus muestra en Sección 2 los datos devueltos por TESEO:
     - Nombre cliente
     - Línea de crédito
     - Total cupo
     - Total utilizado
     - Total disponible
     - Plazo máximo
   - Ningún campo retornado por servicio es editable.

2. **Campos de captura obligatorios por línea seleccionada**
   - `[Ingrese Plazo]` y `[Confirme Plazo]` obligatorios.
   - `[Ingrese Valor]` y `[Confirme Valor]` obligatorios, salvo reglas de monto fijo.
   - Todos numéricos, sin valores negativos.

3. **Selección única de línea**
   - Campo `[Seleccionar]` tipo checkbox.
   - Solo permite **una** línea a la vez.
   - No hay selección por defecto al cargar.
   - Si cambia de línea, se limpia información diligenciada de la línea anterior.

4. **Regla de crédito de monto fijo**
   - Si línea trae marca `Crédito de monto fijo = S`:
     - Invictus asigna `Total Disponible` en `[Ingrese Valor]` y `[Confirme Valor]`.
     - Esos campos quedan no editables.
     - Solo se diligencia plazo y confirmación de plazo.

5. **Validaciones de plazo y valor**
   - `[Ingrese Plazo]` debe ser `<= Plazo Máximo`.
   - `[Confirme Plazo]` debe coincidir con `[Ingrese Plazo]`.
   - `[Ingrese Valor]` y `[Confirme Valor]` deben coincidir.
   - Si no cumple, resalta campo en rojo y bloquea avance.

6. **Habilitación de botón `[Calcular Desembolso]`**
   - Inicia inhabilitado.
   - Se habilita solo cuando:
     - hay una línea seleccionada, y
     - todos campos obligatorios de esa línea están completos y válidos.

7. **Confirmación antes del cálculo**
   - Al presionar `[Calcular Desembolso]`, Invictus muestra resumen de transacción.
   - Si asesor confirma (`[Aceptar]`), consume servicio de cálculo.
   - Si cancela (`[Cancelar]`), sale sin guardar y regresa a inicio.
   - Después de confirmar, no se permiten cambios en secciones previas.

---

## Información Técnica

### Tipo de Servicio

**Método HTTP:** `POST`

---

### URL de Integración

| Ambiente | URL                                            |
|----------|------------------------------------------------|
| **Pruebas (QA)** | `https://testing-sygma.com/api/lineas_credito` |
| **Producción** | `POR DEFINIR`                                  |

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
| `linea_credito` | string | - | ✅ | Identificador de la línea de crédito seleccionada |
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
| `linea_credito` | Sección 2: Datos Crédito → Línea seleccionada (checkbox)             | Al seleccionar línea |
| `plazo_meses` | Sección 2: Datos Crédito → Campo [Confirme Plazo]                    | Al confirmar plazo |
| `valor_desembolso` | Sección 2: Datos Crédito → Campo [Confirme Valor]                    | Al confirmar valor |

#### Ejemplo de Request

```json
{
  "id_linea_credito": 27375, 
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "guid": "b2c3d4e5-f6g7-8901-bcde-fg2345678901",
  "linea_credito": "linea_digital_001",
  "plazo_meses": 4,
  "valor_desembolso": 500000
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
    "guid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "mensaje": "Código OTP validado correctamente. Crédito autorizado para desembolso.",
    "nombre_cliente": "Juan Pérez",
    "fecha_validacion": "2025-10-10 14:30:45",
    "puede_desembolsar": true,
    "lineas_credito": [
      {
        "id_linea_credito": 27373,
        "linea_credito": "Línea 1",
        "valor_cupo": 50000,
        "total_entregado": 50000,
        "total_disponible": 50000,
        "plazo_meses": 12,
        "monto_fijo": "NO"
      },
      {
        "id_linea_credito": 27375,
        "linea_credito": "Línea 2",
        "valor_cupo": 50000,
        "total_entregado": 50000,
        "total_disponible": 50000,
        "plazo_meses": 2,
        "monto_fijo": "SI"
      }
    ]
  }
}
```

#### Descripción de Campos de Respuesta

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `status` | string | Indicador del resultado: `"success"` |
| `datos` | object | Objeto con líneas de crédito disponibles para selección |
| `datos.guid` | string | Identificador único de la transacción (mismo del request) |
| `datos.mensaje` | string | Mensaje de confirmación de OTP válido |
| `datos.nombre_cliente` | string | Nombre completo del cliente (confirmación) |
| `datos.fecha_validacion` | string | Timestamp de validación OTP (formato: YYYY-MM-DD HH:MM:SS) |
| `datos.puede_desembolsar` | boolean | Indica autorización para continuar (`true`) |
| `datos.lineas_credito` | array | Array de líneas de crédito disponibles |
| `datos.lineas_credito[].id_linea_credito` | integer | ID de línea de crédito |
| `datos.lineas_credito[].linea_credito` | string | Nombre de línea de crédito |
| `datos.lineas_credito[].valor_cupo` | number | Cupo total de línea |
| `datos.lineas_credito[].total_entregado` | number | Valor ya entregado |
| `datos.lineas_credito[].total_disponible` | number | Valor disponible para desembolso |
| `datos.lineas_credito[].plazo_meses` | integer | Plazo máximo disponible |
| `datos.lineas_credito[].monto_fijo` | string | Marca de crédito de monto fijo (`SI`/`NO`) |

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
    "El campo id_linea_credito es obligatorio.",
    "El campo plazo_meses es obligatorio."
  ]
}
```

---

## Tabla Resumen de Respuestas

| # | Condición | HTTP Code | status | Mensaje | Comportamiento Invictus | Reinicia Proceso |
|---|-----------|-----------|--------|---------|------------------------|------------------|
| 1 | OTP validado y líneas disponibles | 200 | `success` | "Código OTP validado correctamente. Crédito autorizado para desembolso." | Habilita Sección 2 con líneas | No |
| 2 | Token inválido/ausente | 401 | `error` | "Token de autorización inválido o ausente." | Modal rojo, regresa a inicio | **SÍ** |
| 3 | Transacción no encontrada | 404 | `error` | "Transacción no encontrada o inválida." | Modal naranja, regresa a inicio | **SÍ** |
| 4 | Campos faltantes | 400 | `error` | Lista de campos obligatorios | - | - |

---

## Ejemplos Completos

### ✅ Ejemplo 1: OTP Validado y Líneas Disponibles

**Request:**
```json
POST /api/lineas_credito
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "guid": "b2c3d4e5-f6g7-8901-bcde-fg2345678901",
  "linea_credito": "linea_digital_001",
  "id_linea_credito": 27375,
  "plazo_meses": 4,
  "valor_desembolso": 500000
}
```

**Response:**
```json
HTTP/1.1 200 OK
Content-Type: application/json

{
  "status": "success",
  "datos": {
    "guid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "mensaje": "Código OTP validado correctamente. Crédito autorizado para desembolso.",
    "nombre_cliente": "Juan Pérez",
    "fecha_validacion": "2025-10-10 14:30:45",
    "puede_desembolsar": true,
    "lineas_credito": [
      {
        "id_linea_credito": 27373,
        "linea_credito": "Línea 1",
        "valor_cupo": 50000,
        "total_entregado": 50000,
        "total_disponible": 50000,
        "plazo_meses": 12,
        "monto_fijo": "NO"
      },
      {
        "id_linea_credito": 27375,
        "linea_credito": "Línea 2",
        "valor_cupo": 50000,
        "total_entregado": 50000,
        "total_disponible": 50000,
        "plazo_meses": 2,
        "monto_fijo": "SI"
      }
    ]
  }
}
```

**Acción en Invictus:**
1. Muestra mensaje de validación OTP exitosa.
2. Habilita **Sección 2: Datos Crédito**.
3. Carga tabla de líneas retornadas en `datos.lineas_credito`.
4. Permite selección de una sola línea para continuar flujo.

---

### 🔐 Ejemplo 2: Error de Autenticación

**Request:**
```json
POST /api/lineas_credito
Authorization: Bearer token_invalido_expirado
Content-Type: application/json

{
  "id_linea_credito": 27375,
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "guid": "b2c3d4e5-f6g7-8901-bcde-fg2345678901",
  "linea_credito": "linea_digital_001",
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
POST /api/lineas_credito
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "id_linea_credito": 27375,
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "guid": "guid-invalido-12345",
  "linea_credito": "linea_digital_001",
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

