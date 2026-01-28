# 📘 Manual de Integración API: Validación de Código OTP para Desembolso

## Descripción del Servicio

Este servicio permite validar el código OTP (One Time Password) ingresado por el cliente para confirmar su identidad y autorizar el desembolso del crédito en un punto Gana. El servicio controla el número de intentos permitidos, gestiona el tiempo de vigencia del código y devuelve información de las líneas de crédito del cliente una vez validado exitosamente.

---

## Flujo del Proceso

### Contexto General

Este servicio es el **segundo paso** del flujo de desembolso, ejecutándose después de la validación exitosa del crédito vigente:

```
Servicio 1: Validación de Crédito Vigente
     ↓ (retorna success + guid + codigo_otp + canales_envio)
Pantalla de Autenticación Cliente (Invictus)
     ↓ (cliente proporciona código OTP)
Servicio 2: Validación de OTP (este documento) ← ESTAMOS AQUÍ
     ↓ (confirma identidad del cliente + devuelve líneas de crédito)
Sección 2: Datos Crédito (se habilita en Invictus)
     ↓
Desembolso Final
```

### Secuencia del Flujo

```
1. Usuario se encuentra en "Pantalla de Autenticación Cliente"
   (ver HUE 002 - Consulta de cliente para validar Crédito)
   - Título parametrizable con instrucciones
   - Medios de envío del OTP (WhatsApp, SMS, Email) ofuscados
   - 6 casillas individuales para ingreso de código OTP
   - Temporizador de vigencia activo (ej: 3:00 minutos)
   - Opción "Reenviar código OTP" (inhabilitada por defecto)
   - Botones: [Limpiar], [Cancelar], [Confirmar (inhabilitado)]
   ↓
2. Cliente proporciona código OTP de 6 dígitos
   ↓
3. Validación Front-end (Invictus)
   - ¿Todas las casillas están completas (6 dígitos)?
   - NO → Resalta casillas vacías en ROJO
   - NO → Botón [Confirmar] permanece INHABILITADO
   - NO → NO se consume ningún servicio de TESEO
   - SÍ → Habilita botón [Confirmar]
   ↓
4. Usuario presiona [Confirmar]
   ↓
5. Sistema consume Servicio de Validación OTP (TESEO)
   ↓
6. Servicio ejecuta validaciones en orden secuencial:
   
   a) Validación de Autenticación
      ↓ Token inválido/vencido? → SÍ: retorna "error" (401)
   
   b) Validación de Campos Requeridos
      ↓ Campos vacíos/inválidos? → SÍ: retorna "error" (400)
   
   c) Validación de Transacción Existente
      ↓ GUID no existe/no coincide? → SÍ: retorna "error" (404)
   
   d) Validación de Vigencia del OTP
      ↓ OTP expirado (>3 min)? → SÍ: retorna "expired"
   
   e) Validación de Intentos Fallidos
      ↓ Intentos superados (>=3)? → SÍ: retorna "blocked"
   
   f) Validación del Código OTP
      ↓ Código incorrecto? → SÍ: incrementa contador, retorna "invalid"
      ↓ Código correcto? → SÍ: invalida OTP, retorna "success" + líneas de crédito
   ↓
7. Comportamiento de Invictus según respuesta:
   
   - success → Modal verde: "Código OTP validado correctamente..."
               Cierra modal, permanece en pantalla
               Habilita Sección 2: Datos Crédito con líneas disponibles
   
   - invalid → Modal naranja: "El código ingresado es incorrecto..."
               Muestra intentos restantes
               Cierra modal, permanece en pantalla OTP para reintentar
   
   - blocked → Modal naranja: "Ha superado el número máximo de intentos..."
               Cierra modal, REGRESA a pantalla principal de Invictus
               Proceso de desembolso se REINICIA desde cero
   
   - expired → Modal naranja: "El código OTP ha expirado..."
               Muestra tiempo transcurrido y vigencia máxima
               Cierra modal, REGRESA a pantalla principal de Invictus
               Proceso de desembolso se REINICIA desde cero
   
   - error (transacción) → Modal naranja: "Transacción no encontrada o inválida"
                           Cierra modal, permanece en pantalla OTP
   
   - error (autenticación) → Modal naranja: "Token de autorización inválido..."
                             Cierra modal, permanece en pantalla OTP
```

---

## Información Técnica

### Tipo de Servicio

**Método HTTP:** `POST`

---

### URL de Integración

| Ambiente | URL |
|----------|-----|
| **Pruebas (QA)** | `https://testing-sygma.com/api/validacion_otp_desembolso` |
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
| `codigo_otp` | string | 6 | ✅ | Código OTP ingresado por el cliente (numérico o alfanumérico) |
| `guid` | string | UUID | ✅ | UUID de la transacción generado en el servicio anterior |

#### Catálogo de Tipos de Documento

| `tiposdocumento_id` | Descripción | Código |
|---------------------|-------------|--------|
| `1` | Cédula de ciudadanía | CC |
| `2` | Cédula de extranjería | CE |
| `3` | NIT | NIT |
| `8` | Pasaporte | PA |
| `181` | Permiso Especial | PEP |

#### Ejemplo de Request

```json
{
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "codigo_otp": "202023",
  "guid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
}
```

---

## Validaciones del Servicio

El servicio ejecuta las siguientes validaciones en orden secuencial:

### Nivel 1: Validación de Front-end (Invictus)

**Reglas (antes de consumir el servicio):**
- Usuario debe completar **todas las 6 casillas** del código OTP
- Si alguna casilla está vacía al intentar presionar [Confirmar]:
    - Invictus resalta en **color ROJO** las casillas faltantes
    - Botón [Confirmar] permanece **INHABILITADO**
    - **NO se consume ningún servicio de TESEO**
    - Usuario debe completar todas las casillas antes de continuar

---

### Nivel 2: Validación de Autenticación

**Reglas:**
- Token debe estar presente en el header `Authorization`
- Token debe tener formato válido: `Bearer {token}`
- Token debe estar vigente (no expirado)
- Token debe corresponder a un usuario autorizado

**Resultado: Token Inválido o Vencido**

**Respuesta:**
```json
{
  "status": "error",
  "mensaje": "Token de autorización inválido o ausente."
}
```

**Código HTTP:** `401 Unauthorized`

**Comportamiento en Invictus:**
- Mostrar mensaje modal naranja: **"Token de autorización inválido o ausente"**
- Botón **[CERRAR]** para cerrar el modal
- Dejar al usuario en la **pantalla para ingresar el OTP** (no reinicia proceso)
- **Nota:** Este token corresponde a la autenticación del sistema Invictus con el sistema TESEO

---

### Nivel 3: Validación de Campos Requeridos

**Reglas:**
- Todos los campos son obligatorios: `tiposdocumento_id`, `identificacion`, `codigo_otp`, `guid`
- Campos deben ser tipo string
- No se permiten valores vacíos o nulos
- `codigo_otp` debe tener exactamente 6 caracteres
- `guid` debe ser un UUID válido

**Respuesta en caso de error:**
```json
{
  "status": "error",
  "errors": [
    "El campo codigo_otp es obligatorio.",
    "El campo guid es obligatorio."
  ]
}
```

**Código HTTP:** `400 Bad Request`

---

### Nivel 4: Validación de Transacción Existente

**Proceso:**
1. Se verifica que el `guid` proporcionado exista en el sistema TESEO
2. Se valida que el `guid` corresponda al `tiposdocumento_id` e `identificacion` enviados
3. Se verifica que la transacción esté en estado válido para recibir OTP

**Resultado: Transacción No Encontrada o No Corresponde**

La transacción con el `guid` proporcionado no existe o no coincide con la identificación del cliente.

**Respuesta:**
```json
{
  "status": "error",
  "mensaje": "Transacción no encontrada o no corresponde a esta identificación."
}
```

**Código HTTP:** `404 Not Found`

**Comportamiento en Invictus:**
- Mostrar mensaje modal naranja: **"Transacción no encontrada o inválida"**
- Botón **[CERRAR]** para cerrar el modal
- Dejar al usuario en la **pantalla para ingresar el OTP** (no reinicia proceso)

---

### Nivel 5: Validación de Vigencia del OTP

**Reglas de negocio:**
- Vigencia máxima: **3 minutos** desde la generación del código
- Fórmula: `tiempo_transcurrido = timestamp_actual - timestamp_generacion`
- Si `tiempo_transcurrido > 3 minutos` → OTP expirado
- El tiempo de vigencia es **parametrizable** en el sistema

**Resultado: OTP Expirado**

El código OTP ha superado el tiempo máximo de vigencia permitido.

**Respuesta:**
```json
{
  "status": "expired",
  "mensaje": "El código OTP ha expirado. Debe solicitar un nuevo código.",
  "tiempo_transcurrido": "6 minutos",
  "vigencia_maxima": "3 minutos"
}
```

**Código HTTP:** `200 OK`

**Comportamiento en Invictus:**
- Mostrar mensaje modal naranja con texto:
  ```
  "El código OTP ha expirado. Debe solicitar un nuevo código
  tiempo_transcurrido: '6 minutos'
  vigencia_maxima: '3 minutos'"
  ```
- Botón **[CERRAR]** para cerrar el modal
- **Cerrar modal → REGRESA a la pantalla principal de Invictus**
- **El proceso de desembolso se debe REINICIAR desde cero**
- Usuario debe iniciar nuevamente desde Sección 1: Datos Cliente

**Campos de respuesta:**
- `status`: Indicador del resultado (`expired`)
- `mensaje`: Descripción para el usuario final
- `tiempo_transcurrido`: Tiempo desde que se generó el OTP (formato legible)
- `vigencia_maxima`: Tiempo máximo permitido (formato legible)

---

### Nivel 6: Validación de Intentos Fallidos

**Reglas de negocio:**
- Número máximo de intentos: **3 intentos** (parametrizable)
- Los intentos se cuentan por `guid` (por transacción)
- Cada intento fallido incrementa el contador en 1
- Al alcanzar el máximo de intentos, la transacción se bloquea automáticamente

**Resultado: Intentos Superados**

El usuario ha agotado los 3 intentos permitidos para ingresar el código OTP correcto.

**Acciones automáticas del sistema:**
1. Bloquea la transacción asociada al `guid`
2. Invalida el código OTP actual (ya no puede ser utilizado)
3. Registra el bloqueo en el sistema con timestamp
4. El cliente debe solicitar un nuevo código OTP y reiniciar el proceso

**Respuesta:**
```json
{
  "status": "blocked",
  "mensaje": "Ha superado el número máximo de intentos permitidos (3). Debe solicitar un nuevo código OTP.",
  "intentos_realizados": 3,
  "intentos_permitidos": 3
}
```

**Código HTTP:** `200 OK`

**Comportamiento en Invictus:**
- Mostrar mensaje modal naranja con texto:
  ```
  "Ha superado el número máximo de intentos permitidos (3). Debe solicitar un nuevo código
  intentos_realizados: '3'
  intentos_permitidos: '3'"
  ```
- Botón **[CERRAR]** para cerrar el modal
- **Cerrar modal → REGRESA a la pantalla principal de Invictus**
- **El proceso de desembolso se debe REINICIAR desde cero**
- Usuario debe iniciar nuevamente desde Sección 1: Datos Cliente

**Campos de respuesta:**
- `status`: Indicador del resultado (`blocked`)
- `mensaje`: Descripción para el usuario final
- `intentos_realizados`: Número de intentos que realizó el usuario
- `intentos_permitidos`: Número máximo de intentos configurado

---

### Nivel 7: Validación del Código OTP

**Proceso:**
1. Se compara el `codigo_otp` ingresado con el código generado y almacenado en el sistema
2. La comparación es **case-sensitive** si el código es alfanumérico
3. Se verifica que el código no haya sido ya utilizado exitosamente

**Resultado: Código OTP Incorrecto**

El código ingresado no coincide con el código generado para esta transacción.

**Acciones del sistema:**
1. Incrementa el contador de intentos fallidos para este `guid`
2. Calcula los intentos restantes
3. No invalida el código (el cliente puede reintentar)
4. Registra el intento fallido con timestamp

**Respuesta:**
```json
{
  "status": "invalid",
  "mensaje": "El código OTP ingresado es incorrecto.",
  "intentos_realizados": 1,
  "intentos_restantes": 2
}
```

**Código HTTP:** `200 OK`

**Comportamiento en Invictus:**
- Mostrar mensaje modal naranja con texto:
  ```
  "El código ingresado es incorrecto
  intentos_restantes: 2"
  ```
- Botón **[CERRAR]** para cerrar el modal
- **Cerrar modal → Dejar al usuario en la pantalla para ingresar el OTP**
- Usuario puede volver a intentar ingresando un nuevo código
- Las casillas OTP se limpian automáticamente para un nuevo intento

**Campos de respuesta:**
- `status`: Indicador del resultado (`invalid`)
- `mensaje`: Descripción para el usuario final
- `intentos_realizados`: Número de intentos que ha realizado hasta el momento
- `intentos_restantes`: Cuántos intentos le quedan antes del bloqueo

---

### Nivel 8: Validación Exitosa ✅

**Condiciones cumplidas:**
- ✅ Token de autenticación válido
- ✅ Todos los campos requeridos presentes
- ✅ Transacción (GUID) existe y corresponde a la identificación
- ✅ Código OTP NO ha expirado (<3 minutos)
- ✅ Intentos NO superados (<3 intentos)
- ✅ Código OTP es CORRECTO

**Acciones automáticas del sistema:**
1. Actualiza el estado del crédito a **"listo para desembolsar"**
2. Registra la validación exitosa con timestamp completo
3. **Invalida el código OTP** (uso único, no puede reutilizarse)
4. Marca la transacción como autenticada
5. Habilita el proceso de desembolso
6. **Retorna información de las líneas de crédito del cliente**

**Respuesta exitosa:**
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
        "linea_credito": "Línea 1",
        "valor_cupo": 50000,
        "total_entregado": 50000,
        "total_disponible": 50000,
        "plazo_meses": 12
      },
      {
        "linea_credito": "Línea 2",
        "valor_cupo": 50000,
        "total_entregado": 50000,
        "total_disponible": 50000,
        "plazo_meses": 2
      }
    ]
  }
}
```

**Código HTTP:** `200 OK`

**Comportamiento en Invictus:**

1. **Mostrar mensaje modal verde** con texto:
   ```
   "Código OTP validado correctamente. Crédito autorizado para desembolso."
   ```
    - Botón **[CERRAR]** para cerrar el modal

2. **Cerrar modal → Permanece en la pantalla para completar el desembolso**

3. **Habilitar Sección 2: Datos Crédito** con la información retornada:
    - Mostrar tabla con las líneas de crédito del cliente
    - Columnas visibles:
        * Línea crédito
        * Valor Cupo
        * Total Entregado
        * Total Disponible
        * Plazo (meses)
        * Ingresos Plazo
        * Confirme Plazo
        * Ingresos Valor
        * Confirme Valor
        * Botón [Selección] por cada línea

4. **Cliente debe seleccionar una línea de crédito** para continuar con el desembolso

**Campos de respuesta:**
- `status`: Indicador del resultado (`success`)
- `datos.guid`: Identificador único de la transacción (mismo UUID)
- `datos.mensaje`: Mensaje de confirmación para el usuario
- `datos.nombre_cliente`: Nombre completo del cliente
- `datos.fecha_validacion`: Timestamp de cuando se validó el OTP (formato: YYYY-MM-DD HH:MM:SS)
- `datos.puede_desembolsar`: Booleano que indica si está autorizado (siempre `true` en success)
- `datos.lineas_credito`: Array con las líneas de crédito disponibles del cliente

**Estructura de cada línea de crédito:**
- `linea_credito`: Identificador de la línea (ej: "Línea 1", "Línea 2")
- `valor_cupo`: Monto total del cupo aprobado
- `total_entregado`: Monto ya entregado al cliente
- `total_disponible`: Monto disponible para desembolsar
- `plazo_meses`: Plazo en meses para el crédito
- `ingresos_plazo`: Información de ingresos relacionada al plazo
- `confirme_plazo`: Campo de confirmación del plazo
- `ingresos_valor`: Valor de ingresos
- `confirme_valor`: Confirmación del valor

**Nota importante:** La respuesta exitosa en este punto **devuelve información de las líneas de crédito del cliente** que deben mostrarse en la Sección 2: Datos Crédito de Invictus.

---

## Response - Tabla Resumen de Respuestas

| # | Condición | HTTP Code | status | Mensaje UI Invictus | Color Modal | Comportamiento | Reinicia Proceso |
|---|-----------|-----------|--------|---------------------|-------------|----------------|------------------|
| 1 | Validación Front-end fallida | - | - | Resalta casillas en rojo | - | No consume servicio | No |
| 2 | Token inválido/ausente | 401 | `error` | "Token de autorización inválido..." | Naranja | Permanece en OTP | No |
| 3 | Campos requeridos faltantes | 400 | `error` | - | - | - | No |
| 4 | Transacción no encontrada | 404 | `error` | "Transacción no encontrada o inválida" | Naranja | Permanece en OTP | No |
| 5 | OTP expirado (>3 min) | 200 | `expired` | "El código OTP ha expirado..." | Naranja | Regresa a inicio | **SÍ** |
| 6 | Intentos superados (>=3) | 200 | `blocked` | "Ha superado el número máximo..." | Naranja | Regresa a inicio | **SÍ** |
| 7 | Código OTP incorrecto | 200 | `invalid` | "El código ingresado es incorrecto" | Naranja | Permanece en OTP | No |
| 8 | Código OTP correcto | 200 | `success` | "Código OTP validado correctamente..." | Verde | Habilita Sección 2 | No |

---

## Ejemplos de Respuestas Completas

### ✅ Caso 1: Validación Exitosa - OTP Válido

**Request:**
```json
POST /api/validacion_otp_desembolso
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "codigo_otp": "202023",
  "guid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
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
        "linea_credito": "Línea 1",
        "valor_cupo": 50000,
        "total_entregado": 50000,
        "total_disponible": 50000,
        "plazo_meses": 12
      },
      {
        "linea_credito": "Línea 2",
        "valor_cupo": 50000,
        "total_entregado": 50000,
        "total_disponible": 50000,
        "plazo_meses": 2
      }
    ]
  }
}
```

**Acción en Invictus:**
- Modal verde: **"Código OTP validado correctamente. Crédito autorizado para desembolso."**
- Cerrar modal
- Habilitar Sección 2: Datos Crédito
- Mostrar tabla con las 2 líneas de crédito disponibles
- Cliente puede seleccionar una línea para continuar

---

### ❌ Caso 2: Código OTP Incorrecto (Primer Intento)

**Request:**
```json
POST /api/validacion_otp_desembolso
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "codigo_otp": "123456",
  "guid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
}
```

**Response:**
```json
HTTP/1.1 200 OK
Content-Type: application/json

{
  "status": "invalid",
  "mensaje": "El código OTP ingresado es incorrecto.",
  "intentos_realizados": 1,
  "intentos_restantes": 2
}
```

**Acción en Invictus:**
- Modal naranja con texto:
  ```
  "El código ingresado es incorrecto
  intentos_restantes: 2"
  ```
- Botón [CERRAR]
- Cerrar modal → Permanece en pantalla de ingreso OTP
- Limpia las 6 casillas OTP para nuevo intento
- Cliente puede volver a intentar

---

### 🚫 Caso 3: Intentos Superados (Tercer Intento Fallido)

**Request:**
```json
POST /api/validacion_otp_desembolso
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "codigo_otp": "999999",
  "guid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
}
```

**Response:**
```json
HTTP/1.1 200 OK
Content-Type: application/json

{
  "status": "blocked",
  "mensaje": "Ha superado el número máximo de intentos permitidos (3). Debe solicitar un nuevo código OTP.",
  "intentos_realizados": 3,
  "intentos_permitidos": 3
}
```

**Acción en Invictus:**
- Modal naranja con texto:
  ```
  "Ha superado el número máximo de intentos permitidos (3). Debe solicitar un nuevo código
  intentos_realizados: '3'
  intentos_permitidos: '3'"
  ```
- Botón [CERRAR]
- Cerrar modal → **REGRESA a pantalla principal de Invictus**
- **Proceso de desembolso se REINICIA completamente**
- Cliente debe iniciar desde Sección 1: Datos Cliente

---

### ⏰ Caso 4: OTP Expirado

**Request:**
```json
POST /api/validacion_otp_desembolso
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "codigo_otp": "202023",
  "guid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
}
```

**Response:**
```json
HTTP/1.1 200 OK
Content-Type: application/json

{
  "status": "expired",
  "mensaje": "El código OTP ha expirado. Debe solicitar un nuevo código.",
  "tiempo_transcurrido": "6 minutos",
  "vigencia_maxima": "3 minutos"
}
```

**Acción en Invictus:**
- Modal naranja con texto:
  ```
  "El código OTP ha expirado. Debe solicitar un nuevo código
  tiempo_transcurrido: '6 minutos'
  vigencia_maxima: '3 minutos'"
  ```
- Botón [CERRAR]
- Cerrar modal → **REGRESA a pantalla principal de Invictus**
- **Proceso de desembolso se REINICIA completamente**
- Cliente debe iniciar desde Sección 1: Datos Cliente

---

### ⚠️ Caso 5: Transacción No Encontrada

**Request:**
```json
POST /api/validacion_otp_desembolso
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "codigo_otp": "202023",
  "guid": "guid-invalido-12345"
}
```

**Response:**
```json
HTTP/1.1 404 Not Found
Content-Type: application/json

{
  "status": "error",
  "mensaje": "Transacción no encontrada o no corresponde a esta identificación."
}
```

**Acción en Invictus:**
- Modal naranja: **"Transacción no encontrada o inválida"**
- Botón [CERRAR]
- Cerrar modal → Permanece en pantalla de ingreso OTP
- No reinicia proceso (puede ser error temporal)

---

### 🔐 Caso 6: Error de Autenticación (Token Inválido)

**Request:**
```json
POST /api/validacion_otp_desembolso
Authorization: Bearer token_invalido_o_expirado
Content-Type: application/json

{
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "codigo_otp": "202023",
  "guid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
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
- Modal naranja: **"Token de autorización inválido o ausente"**
- Botón [CERRAR]
- Cerrar modal → Permanece en pantalla de ingreso OTP
- **Nota:** Este token corresponde a la autenticación del sistema Invictus con TESEO

---

### 🚫 Caso 7: Error de Validación - Campos Faltantes

**Request:**
```json
POST /api/validacion_otp_desembolso
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "tiposdocumento_id": "1",
  "identificacion": "88282828"
}
```

**Response:**
```json
HTTP/1.1 400 Bad Request
Content-Type: application/json

{
  "status": "error",
  "errors": [
    "El campo codigo_otp es obligatorio.",
    "El campo guid es obligatorio."
  ]
}
```

---

## Integración en Invictus

### Pantalla: Autenticación Cliente (Continuación de HUE 002)

**Estado inicial de la pantalla:**
- Título parametrizable con instrucciones para el cliente
- Medios de envío mostrados (WhatsApp, SMS, Email) con información ofuscada
- 6 casillas individuales para código OTP
- Temporizador de vigencia (ej: "3:00 minutos")
- Opción "Reenviar código OTP" (inhabilitada)
- Botones: [Limpiar], [Cancelar], [Confirmar (inhabilitado)]

**Flujo de interacción:**

1. **Cliente ingresa código OTP:**
    - Puede escribir en las 6 casillas
    - Puede editar en cualquier momento
    - Temporizador cuenta regresiva activa

2. **Validación Front-end:**
    - Si alguna casilla está vacía:
        * Resalta casillas vacías en ROJO
        * Botón [Confirmar] permanece INHABILITADO
        * NO consume servicio
    - Si todas las casillas están completas:
        * Habilita botón [Confirmar]

3. **Usuario presiona [Confirmar]:**
    - Consume servicio de Validación OTP
    - Espera respuesta

4. **Comportamiento según respuesta:**

   **a) Response: `success`**
    - Modal verde: "Código OTP validado correctamente. Crédito autorizado para desembolso."
    - [CERRAR]
    - Cierra pantalla de autenticación
    - **Habilita Sección 2: Datos Crédito**
    - Muestra tabla con líneas de crédito del cliente
    - Cliente puede seleccionar línea y continuar

   **b) Response: `invalid`**
    - Modal naranja: "El código ingresado es incorrecto\nintentos_restantes: X"
    - [CERRAR]
    - Permanece en pantalla OTP
    - Limpia las 6 casillas
    - Cliente puede reintentar

   **c) Response: `blocked`**
    - Modal naranja: "Ha superado el número máximo de intentos permitidos (3)..."
    - [CERRAR]
    - **Cierra pantalla de autenticación**
    - **Regresa a pantalla principal de Invictus**
    - **Proceso completo se REINICIA**

   **d) Response: `expired`**
    - Modal naranja: "El código OTP ha expirado. Debe solicitar un nuevo código..."
    - Muestra tiempo transcurrido y vigencia máxima
    - [CERRAR]
    - **Cierra pantalla de autenticación**
    - **Regresa a pantalla principal de Invictus**
    - **Proceso completo se REINICIA**

   **e) Response: `error` (transacción)**
    - Modal naranja: "Transacción no encontrada o inválida"
    - [CERRAR]
    - Permanece en pantalla OTP
    - No limpia casillas

   **f) Response: `error` (autenticación)**
    - Modal naranja: "Token de autorización inválido o ausente"
    - [CERRAR]
    - Permanece en pantalla OTP
    - No limpia casillas

### Sección 2: Datos Crédito (Se habilita tras validación exitosa)

**Tabla de Líneas de Crédito:**

| Línea crédito | Valor Cupo | Total Entregado | Total Disponible | Plazo | Ingresos Plazo | Confirme Plazo | Ingresos Valor | Confirme Valor | Selección |
|---------------|------------|-----------------|------------------|-------|--------------|--------------|--------------|--------------|-----------|
| Línea 1 | $50,000 | $50,000 | $50,000 | 12    | ☐ | ☐ | ☐ | ☐ | ☐ |
| Línea 2 | $50,000 | $50,000 | $50,000 | 4     | ☐ | ☐ | ☐ | ☐ | ☐ |

**Comportamiento:**
- Cliente debe seleccionar **una línea de crédito** usando el checkbox [Selección]
- Solo puede seleccionar una línea a la vez
- Al seleccionar, se habilita continuar al siguiente paso del desembolso

---

## Consideraciones de Seguridad

### Código OTP

- **Vigencia:** 3 minutos desde su generación (parametrizable)
- **Longitud:** 6 dígitos (numérico o alfanumérico según configuración)
- **Intentos permitidos:** 3 intentos máximo (parametrizable)
- **Uso único:** Una vez validado correctamente, el OTP se invalida automáticamente
- **Bloqueo:** Después de 3 intentos fallidos, se bloquea la transacción y se invalida el OTP

### Control de Intentos

- Se registra cada intento de validación con timestamp completo
- Los intentos se cuentan por `guid` (por transacción única)
- Al superar los intentos máximos, el cliente debe:
    1. Solicitar un nuevo código OTP (reiniciando el proceso)
    2. El contador de intentos se reinicia al generar un nuevo OTP
- El GUID anterior queda invalidado y no puede reutilizarse

### Control de Vigencia

- El temporizador en Invictus debe sincronizarse con el backend
- Cuando el temporizador llega a 0:00:
    - Se habilita la opción "Reenviar código OTP"
    - Si el usuario intenta confirmar, recibirá error de expiración
- Es responsabilidad del backend validar la vigencia real del código

### Registro de Auditoría

Cada validación (exitosa o fallida) debe registrar:
- **Timestamp:** Fecha y hora exacta del intento
- **IP de origen:** Dirección IP desde donde se realizó la petición
- **Resultado:** success, invalid, blocked, expired, error
- **Intentos realizados:** Contador actualizado
- **Identificación del cliente:** Para trazabilidad
- **GUID de transacción:** Para asociar todos los eventos

### Parámetros Configurables

Los siguientes valores pueden configurarse en el sistema TESEO:

| Parámetro | Valor por Defecto | Descripción |
|-----------|-------------------|-------------|
| **Número máximo de intentos** | 3 | Intentos permitidos antes del bloqueo |
| **Vigencia del OTP** | 3 minutos | Tiempo de validez del código |
| **Longitud del código** | 6 dígitos | Cantidad de caracteres del OTP |
| **Tipo de código** | Numérico | Numérico o Alfanumérico |

---

## Notas Importantes

### 📋 Reglas de Negocio

- ✅ El cliente recibe el OTP a través de los canales configurados (SMS, Email, WhatsApp) cuando se genera el código
- ✅ **Este servicio NO envía el OTP**, solo valida el código que el cliente ingresa
- ✅ Si el código expira o se agotan los intentos, el **proceso completo se reinicia**
- ✅ El `guid` es fundamental para vincular la validación con el OTP correcto generado
- ✅ Después de 3 intentos fallidos, es **obligatorio** generar un nuevo código reiniciando desde el inicio
- ✅ La validación exitosa autoriza el desembolso pero **NO lo ejecuta automáticamente**
- ✅ **La respuesta exitosa devuelve las líneas de crédito del cliente** para mostrar en Invictus
- ✅ El punto Gana debe permitir al cliente **seleccionar una línea de crédito** antes de proceder

### 🔄 Flujo Completo de Desembolso

```
Servicio 1: Validación de Crédito Vigente
     ↓ (retorna guid + codigo_otp si success)
     
Pantalla de Autenticación Cliente (en Invictus)
     ↓ (usuario ingresa código OTP)
     
Servicio 2: Validación de OTP (este documento)
     ↓ (retorna success + líneas de crédito)
     
Sección 2: Datos Crédito (habilita en Invictus)
     ↓ (cliente selecciona línea de crédito)
     
[Opcional] Servicio 3: Reenvío de OTP
     ↓ (si el temporizador expira antes de confirmar)
     
Sección 3: Realizar Desembolso
     ↓ (confirma montos y ejecuta desembolso)
     
Desembolso Final
```

### ⚙️ Configuración del Ambiente

**Ambiente de Pruebas (QA):**
- Base URL: `https://testing-sygma.com/api`
- Endpoint Login: `/login`
- Endpoint Validación OTP: `/validacion_otp_desembolso`
- Usuario: `ws_invictus`
- Password: `g3z0OmJP7?@(*`

### 🎨 Especificaciones de UI para Mensajes Modales

| Status Response | Color Modal | Título/Mensaje | Icono | Botón | Acción al Cerrar |
|-----------------|-------------|----------------|-------|-------|------------------|
| `success` | Verde | "Código OTP validado correctamente..." | ✓ | [CERRAR] | Habilita Sección 2 |
| `invalid` | Naranja | "El código ingresado es incorrecto..." | ⚠️ | [CERRAR] | Permanece en OTP |
| `blocked` | Naranja | "Ha superado el número máximo..." | 🔒 | [CERRAR] | Regresa a inicio |
| `expired` | Naranja | "El código OTP ha expirado..." | ⏰ | [CERRAR] | Regresa a inicio |
| `error` (transacción) | Naranja | "Transacción no encontrada..." | ❌ | [CERRAR] | Permanece en OTP |
| `error` (autenticación) | Naranja | "Token de autorización inválido..." | 🔐 | [CERRAR] | Permanece en OTP |

### 🔒 Seguridad Adicional

- Todos los endpoints requieren autenticación via Bearer Token
- Los tokens tienen tiempo de expiración
- Se recomienda implementar retry logic para renovación de token
- Los datos sensibles no deben ser almacenados en logs
- El código OTP nunca debe ser almacenado en texto plano
- Todos los intentos de validación deben quedar registrados para auditoría
- Implementar rate limiting para prevenir ataques de fuerza bruta

### 📊 Monitoreo y Logs

Se recomienda registrar:
- Timestamp de cada petición
- Identificación del usuario consultado (encriptada)
- GUID de la transacción
- Status de respuesta
- Número de intento (para códigos incorrectos)
- Tiempo de respuesta del servicio
- Errores y excepciones
- Intentos fallidos consecutivos (alerta de seguridad)

---

## Glosario

| Término | Definición |
|---------|------------|
| **TESEO** | Sistema backend que gestiona los créditos de Credintegral |
| **Invictus** | Sistema frontend utilizado por vendedores (Sellers) en puntos Gana |
| **OTP** | One-Time Password - Código de un solo uso para validación |
| **GUID** | Globally Unique Identifier - Identificador único de transacción (UUID) |
| **Seller** | Vendedor autorizado en punto Gana para realizar desembolsos |
| **Desembolso** | Entrega física del dinero del crédito al cliente |
| **Línea de Crédito** | Producto crediticio específico con condiciones y montos definidos |
| **Parametrizable** | Valor configurable en el sistema sin necesidad de cambiar código |
| **Intento** | Cada vez que el cliente ingresa un código OTP (correcto o incorrecto) |
| **Vigencia** | Tiempo durante el cual el código OTP es válido |
| **Bloqueo** | Estado en que la transacción ya no permite más intentos |

