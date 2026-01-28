# 📘 Manual de Integración API: Reenvío de Código OTP para Desembolso

## Descripción del Servicio

Este servicio permite reenviar un nuevo código OTP al cliente cuando el código anterior ha expirado, se han agotado los intentos de validación, o el cliente no ha recibido el código inicial. El servicio controla el límite de reenvíos permitidos, valida el tiempo entre solicitudes y gestiona la invalidación de códigos anteriores, generando un nuevo código completamente independiente.

---

## Flujo del Proceso

### Contexto General

Este servicio es **opcional** en el flujo de desembolso y se activa solo cuando es necesario reenviar el código OTP:

```
Servicio 1: Validación de Crédito Vigente
     ↓ (retorna success + guid + codigo_otp)
Pantalla de Autenticación Cliente (Invictus)
     ↓ 
Temporizador llega a 0:00 o Cliente no recibe código
     ↓
Se habilita opción "Reenviar código OTP"
     ↓
Servicio 3: Reenvío de OTP (este documento) ← ESTAMOS AQUÍ
     ↓ (retorna success + nuevo guid + nuevo codigo_otp)
Pantalla de Autenticación Cliente (actualizada)
     ↓ (cliente ingresa nuevo código OTP)
Servicio 2: Validación de OTP
     ↓
Continúa flujo normal
```

### Secuencia del Flujo

```
1. Usuario se encuentra en "Pantalla de Autenticación Cliente"
   - Temporizador llega a 0:00 (código expirado)
   - O cliente indica que no recibió el código
   ↓
2. Se habilita opción "Reenviar código OTP"
   - Botón o enlace: "Reenviar código OTP"
   - Estado: HABILITADO (solo cuando temporizador = 0:00)
   ↓
3. Usuario selecciona "Reenviar código OTP"
   ↓
4. Sistema consume Servicio de Reenvío OTP (TESEO)
   ↓
5. Servicio ejecuta validaciones en orden:
   
   a) Validación de Autenticación
      ↓ Token inválido? → SÍ: retorna "error" (401)
   
   b) Validación de Campos Requeridos
      ↓ Campos vacíos? → SÍ: retorna "error" (400)
   
   c) Validación de Crédito Vigente
      ↓ Sin crédito vigente? → SÍ: retorna "no_credit"
   
   d) Validación de Límite de Reenvíos
      ↓ Límite excedido (>5)? → SÍ: retorna "resend_limit_exceeded"
   
   e) Validación de Transacción Completada
      ↓ OTP ya validado exitosamente? → SÍ: retorna "already_validated"
   
   f) Validación de Transacción No Encontrada
      ↓ GUID no existe? → SÍ: retorna "error" (404)
   
   g) Generación y Envío de Nuevo OTP
      ↓ Todo OK → Invalida OTP anterior, genera nuevo código
      ↓ Envía nuevo OTP → retorna "success" + nuevo guid
   ↓
6. Comportamiento de Invictus según respuesta:
   
   - success → Modal azul con instrucciones y nuevo temporizador
               Muestra medios de envío (ofuscados)
               Habilita casillas OTP (limpias)
               Reinicia temporizador (3:00 minutos)
               Permanece en pantalla de autenticación
   
   - resend_limit_exceeded → Modal naranja: "Has excedido el número máximo (5)..."
                              Cierra modal, REGRESA a pantalla principal
                              Proceso se REINICIA desde cero
   
   - already_validated → Modal rojo: "Esta transacción ya ha sido completada..."
                         Cierra modal, REGRESA a pantalla principal
                         No requiere nuevo código
   
   - error (transacción) → Modal rojo: "Transacción no encontrada o inválida"
                           Cierra modal, permanece en pantalla OTP
   
   - error (autenticación) → Modal rojo: "Token de autorización inválido..."
                             Cierra modal, permanece en pantalla OTP
   
   - no_credit → Modal con mensaje de crédito no vigente
                 Cierra modal, REGRESA a pantalla principal
```

---

## Información Técnica

### Tipo de Servicio

**Método HTTP:** `POST`

---

### URL de Integración

| Ambiente | URL |
|----------|-----|
| **Pruebas (QA)** | `https://testing-sygma.com/api/reenvio_otp_desembolso` |
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
| `guid` | string | UUID | ✅ | UUID de la transacción del OTP anterior |

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
  "guid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
}
```

---

## Validaciones del Servicio

El servicio ejecuta las siguientes validaciones en orden secuencial:

### Nivel 1: Validación de Autenticación

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
- Mostrar mensaje modal rojo: **"Token de autorización inválido o ausente"**
- Botón **[CERRAR]** para cerrar el modal
- Dejar al usuario en la **pantalla para ingresar el OTP** (no reinicia proceso)
- **Nota:** Este token corresponde a la autenticación del sistema Invictus con el sistema TESEO

---

### Nivel 2: Validación de Campos Requeridos

**Reglas:**
- Todos los campos son obligatorios: `tiposdocumento_id`, `identificacion`, `guid`
- Campos deben ser tipo string
- No se permiten valores vacíos o nulos
- `guid` debe ser un UUID válido

**Respuesta en caso de error:**
```json
{
  "status": "error",
  "errors": [
    "El campo identificacion es obligatorio.",
    "El campo guid es obligatorio."
  ]
}
```

**Código HTTP:** `400 Bad Request`

---

### Nivel 3: Validación de Crédito Aprobado Vigente

**Proceso:**
1. Se verifica que el cliente tenga un crédito aprobado
2. Se valida que el crédito esté vigente (dentro del plazo de 30 días desde aprobación)
3. Se verifica que el crédito no haya sido desembolsado

**Resultado: No Hay Crédito Vigente**

El cliente no tiene un crédito aprobado, el crédito ha vencido, o ya fue desembolsado.

**Respuesta:**
```json
{
  "status": "no_credit",
  "mensaje": "No se encontró un crédito vigente para esta identificación.",
  "razon": "El crédito ha vencido o ya fue desembolsado"
}
```

**Código HTTP:** `200 OK`

**Comportamiento en Invictus:**
- Mostrar mensaje modal con la información del servicio
- Botón **[CERRAR]** para cerrar el modal
- **Cerrar modal → REGRESA a la pantalla principal de Invictus**
- **El proceso de desembolso se REINICIA desde cero**

**Campos de respuesta:**
- `status`: Indicador del resultado (`no_credit`)
- `mensaje`: Descripción para el usuario final
- `razon`: Motivo específico (opcional)

---

### Nivel 4: Validación de Límite de Reenvíos

**Reglas de negocio:**
- Límite máximo de reenvíos: **5 reenvíos** por transacción (parametrizable)
- El límite se cuenta por cada proceso de desembolso completo
- **La cantidad de reenvíos es administrada por TESEO**
- Al alcanzar el límite, se debe reiniciar el proceso completo

**Resultado: Límite de Reenvíos Excedido**

El usuario ha superado el número máximo de reenvíos permitidos para esta transacción.

**Respuesta:**
```json
{
  "status": "resend_limit_exceeded",
  "mensaje": "Has excedido el número máximo (5) de re envíos permitidos, Comunícate con Credintegral",
  "reenvios_realizados": 5,
  "reenvios_permitidos": 5
}
```

**Código HTTP:** `200 OK`

**Comportamiento en Invictus:**
- Mostrar mensaje modal naranja con texto:
  ```
  "Has excedido el número máximo (5) de re envíos permitidos,
  Comunícate con Credintegral"
  ```
- Botón **[CERRAR]** para cerrar el modal
- **Cerrar modal → REGRESA a la pantalla principal de Invictus**
- **El proceso de desembolso se debe REINICIAR desde el principio**
- Cliente debe contactar con Credintegral para resolver el problema

**Campos de respuesta:**
- `status`: Indicador del resultado (`resend_limit_exceeded`)
- `mensaje`: Descripción para el usuario final
- `reenvios_realizados`: Número de reenvíos que ha realizado
- `reenvios_permitidos`: Número máximo configurado

**Nota importante:** Este mensaje se da cuando se excede el límite de reenvíos permitidos. La cantidad de reenvíos es administrada por TESEO.

---

### Nivel 5: Validación de Transacción Completada

**Proceso:**
1. Se verifica el estado de la transacción asociada al `guid`
2. Se valida si el OTP ya fue validado exitosamente previamente

**Resultado: Transacción Ya Completada Exitosamente**

La transacción ya fue validada correctamente y no es necesario reenviar el código.

**Respuesta:**
```json
{
  "status": "already_validated",
  "mensaje": "Esta transacción ya ha sido completada exitosamente. No es necesario un nuevo código.",
  "fecha_validacion": "2025-10-10 14:30:00"
}
```

**Código HTTP:** `200 OK`

**Comportamiento en Invictus:**
- Mostrar mensaje modal rojo con texto:
  ```
  "Esta transacción ya ha sido completada exitosamente.
  No es necesario un nuevo código."
  ```
- Botón **[CERRAR]** para cerrar el modal
- **Cerrar modal → REGRESA a la pantalla principal de Invictus**
- No requiere reiniciar proceso, la transacción ya está completa

**Campos de respuesta:**
- `status`: Indicador del resultado (`already_validated`)
- `mensaje`: Descripción para el usuario final
- `fecha_validacion`: Timestamp de cuando se validó el OTP exitosamente

**Nota importante:** Esto se da cuando se envía el mismo OTP dos o más veces y TESEO ya lo validó correctamente.

---

### Nivel 6: Validación de Transacción Existente

**Proceso:**
1. Se verifica que el `guid` proporcionado exista en el sistema TESEO
2. Se valida que el `guid` corresponda al `tiposdocumento_id` e `identificacion` enviados

**Resultado: Transacción No Encontrada o No Corresponde**

La transacción con el `guid` proporcionado no existe o no coincide con la identificación del cliente.

**Respuesta:**
```json
{
  "status": "error",
  "mensaje": "Transacción no encontrada o inválida."
}
```

**Código HTTP:** `404 Not Found`

**Comportamiento en Invictus:**
- Mostrar mensaje modal rojo: **"Transacción no encontrada o inválida"**
- Botón **[CERRAR]** para cerrar el modal
- Dejar al usuario en la **pantalla para ingresar el OTP** (no reinicia proceso)

---

### Nivel 7: Generación y Envío de Nuevo OTP ✅

**Condiciones cumplidas:**
- ✅ Token de autenticación válido
- ✅ Todos los campos requeridos presentes
- ✅ Cliente tiene crédito vigente
- ✅ Límite de reenvíos NO excedido (<5 reenvíos)
- ✅ Transacción NO ha sido completada exitosamente
- ✅ Transacción (GUID) existe y corresponde a la identificación

**Acciones automáticas del sistema:**

1. **Invalidación de códigos anteriores:**
    - Se invalidan **todos los códigos OTP anteriores** de esta identificación
    - Solo el código más reciente será válido
    - Los intentos fallidos de códigos anteriores NO afectan el nuevo código

2. **Generación de nuevo código:**
    - Se genera un nuevo código OTP de 6 dígitos (numérico o alfanumérico)
    - Se genera un **nuevo GUID** (UUID v4) diferente al anterior
    - Se establece nueva vigencia: 3 minutos desde este momento
    - Se reinicia el contador de intentos a 0 (3 intentos disponibles)

3. **Envío del código:**
    - Se envía el nuevo código a los canales configurados del cliente:
        * SMS
        * Correo electrónico (Email)
        * WhatsApp (si está configurado)
    - Se registra el envío con timestamp completo

4. **Incremento del contador de reenvíos:**
    - Se incrementa el contador de reenvíos para esta transacción
    - Se almacena para validación futura del límite

**Respuesta exitosa:**
```json
{
  "status": "success",
  "datos": {
    "guid": "b2c3d4e5-f6g7-8901-bcde-fg2345678901",
    "mensaje": "Nuevo código OTP enviado exitosamente a los canales registrados.",
    "codigo_otp": 456789,
    "canales_envio": {
      "whatsapp": "314 *** ** 96",
      "sms": "314 *** ** 96",
      "email": "ars****th@gmail.com"
    },
    "vigencia_otp": "3 minutos",
    "intentos_disponibles": 3,
    "fecha_envio": "2025-10-10 14:35:20",
    "reenvios_realizados": 1,
    "reenvios_restantes": 4
  }
}
```

**Código HTTP:** `200 OK`

**Comportamiento en Invictus:**

1. **Mostrar mensaje modal azul** con instrucciones:
   ```
   "Ingrese el código OTP de verificación suministrado por el cliente para la
   autenticación y envío de documentos de crédito"
   
   Medios de envío:
   WhatsApp 314 *** ** 96
   SMS 314 *** ** 96
   Email ars****th@gmail.com
   ```
    - Mostrar información de los canales de envío (ofuscada)
    - Botón **[CERRAR]** para cerrar el modal

2. **Cerrar modal → Permanece en la pantalla para ingresar el OTP**

3. **Actualizar pantalla de autenticación:**
    - **Limpiar las 6 casillas** del código OTP (en blanco)
    - **Reiniciar temporizador** a 3:00 minutos (cuenta regresiva)
    - **Inhabilitar nuevamente** la opción "Reenviar código OTP"
    - La opción se volverá a habilitar cuando el temporizador llegue a 0:00

4. **Validaciones de casillas:**
    - Es **obligatorio** que el asesor ingrese información en **todas las casillas del OTP**
    - En caso contrario, no debe permitir realizar la confirmación
    - Debe resaltar en **ROJO** la casilla que falta por información
    - **Nota:** Esta pantalla debe obedecer a lo descrito en **HUE 002 Consultar cliente para validar Crédito, criterio de aceptación 7**

5. **Usuario puede continuar:**
    - Ingresar el nuevo código OTP en las 6 casillas
    - Presionar [Confirmar] para validar (consume Servicio 2: Validación OTP)

**Campos de respuesta:**
- `status`: Indicador del resultado (`success`)
- `datos.guid`: **Nuevo** identificador único de transacción (diferente al anterior)
- `datos.mensaje`: Mensaje de confirmación para el usuario
- `datos.codigo_otp`: Nuevo código OTP generado (para propósitos de prueba/desarrollo)
- `datos.canales_envio`: Objeto con canales disponibles (**información ofuscada por TESEO**)
    - `whatsapp`: Número ofuscado de WhatsApp
    - `sms`: Número ofuscado de SMS
    - `email`: Email ofuscado
- `datos.vigencia_otp`: Tiempo de validez del nuevo código (formato legible)
- `datos.intentos_disponibles`: Número de intentos disponibles (reiniciado a 3)
- `datos.fecha_envio`: Timestamp del envío (formato: YYYY-MM-DD HH:MM:SS)
- `datos.reenvios_realizados`: Cantidad de reenvíos realizados hasta el momento
- `datos.reenvios_restantes`: Reenvíos que aún pueden realizarse

**Nota importante:** El `guid` generado en el reenvío es **diferente** al original y debe ser almacenado por Invictus para usar en la validación posterior del OTP.

---

## Response - Tabla Resumen de Respuestas

| # | Condición | HTTP Code | status | Mensaje UI Invictus | Color Modal | Comportamiento | Reinicia Proceso |
|---|-----------|-----------|--------|---------------------|-------------|----------------|------------------|
| 1 | Token inválido/ausente | 401 | `error` | "Token de autorización inválido..." | Rojo | Permanece en OTP | No |
| 2 | Campos requeridos faltantes | 400 | `error` | - | - | - | No |
| 3 | Sin crédito vigente | 200 | `no_credit` | "No se encontró un crédito vigente..." | - | Regresa a inicio | **SÍ** |
| 4 | Límite de reenvíos excedido (>5) | 200 | `resend_limit_exceeded` | "Has excedido el número máximo (5)..." | Naranja | Regresa a inicio | **SÍ** |
| 5 | Transacción ya completada | 200 | `already_validated` | "Esta transacción ya ha sido completada..." | Rojo | Regresa a inicio | No |
| 6 | Transacción no encontrada | 404 | `error` | "Transacción no encontrada o inválida" | Rojo | Permanece en OTP | No |
| 7 | Reenvío exitoso | 200 | `success` | Instrucciones + medios de envío | Azul | Permanece en OTP | No |

---

## Ejemplos de Respuestas Completas

### ✅ Caso 1: Reenvío Exitoso - Nuevo OTP Enviado

**Request:**
```json
POST /api/reenvio_otp_desembolso
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
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
    "guid": "b2c3d4e5-f6g7-8901-bcde-fg2345678901",
    "mensaje": "Nuevo código OTP enviado exitosamente a los canales registrados.",
    "codigo_otp": 456789,
    "canales_envio": {
      "whatsapp": "314 *** ** 96",
      "sms": "314 *** ** 96",
      "email": "ars****th@gmail.com"
    },
    "vigencia_otp": "3 minutos",
    "intentos_disponibles": 3,
    "fecha_envio": "2025-10-10 14:35:20",
    "reenvios_realizados": 1,
    "reenvios_restantes": 4
  }
}
```

**Acción en Invictus:**
- Modal azul con instrucciones y medios de envío
- Cerrar modal
- Limpiar las 6 casillas OTP
- Reiniciar temporizador a 3:00
- Inhabilitar opción "Reenviar código OTP"
- Usuario puede ingresar nuevo código

---

### 🚫 Caso 2: Límite de Reenvíos Excedido

**Request:**
```json
POST /api/reenvio_otp_desembolso
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "guid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
}
```

**Response:**
```json
HTTP/1.1 200 OK
Content-Type: application/json

{
  "status": "resend_limit_exceeded",
  "mensaje": "Has excedido el número máximo (5) de re envíos permitidos, Comunícate con Credintegral",
  "reenvios_realizados": 5,
  "reenvios_permitidos": 5
}
```

**Acción en Invictus:**
- Modal naranja: **"Has excedido el número máximo (5) de re envíos permitidos, Comunícate con Credintegral"**
- Botón [CERRAR]
- Cerrar modal → **REGRESA a pantalla principal de Invictus**
- **Proceso de desembolso se REINICIA desde el principio**
- Cliente debe contactar con Credintegral

---

### ⚠️ Caso 3: Transacción Ya Completada

**Request:**
```json
POST /api/reenvio_otp_desembolso
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "guid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
}
```

**Response:**
```json
HTTP/1.1 200 OK
Content-Type: application/json

{
  "status": "already_validated",
  "mensaje": "Esta transacción ya ha sido completada exitosamente. No es necesario un nuevo código.",
  "fecha_validacion": "2025-10-10 14:30:00"
}
```

**Acción en Invictus:**
- Modal rojo: **"Esta transacción ya ha sido completada exitosamente. No es necesario un nuevo código."**
- Botón [CERRAR]
- Cerrar modal → **REGRESA a pantalla principal de Invictus**
- Esto se da cuando se envía el mismo OTP dos o más veces y TESEO ya lo validó correctamente

---

### ❌ Caso 4: Transacción No Encontrada

**Request:**
```json
POST /api/reenvio_otp_desembolso
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "guid": "guid-invalido-12345"
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

**Acción en Invictus:**
- Modal rojo: **"Transacción no encontrada o inválida"**
- Botón [CERRAR]
- Cerrar modal → Permanece en pantalla de ingreso OTP

---

### 🔐 Caso 5: Error de Autenticación (Token Inválido)

**Request:**
```json
POST /api/reenvio_otp_desembolso
Authorization: Bearer token_invalido_o_expirado
Content-Type: application/json

{
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
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
- Modal rojo: **"Token de autorización inválido o ausente"**
- Botón [CERRAR]
- Cerrar modal → Permanece en pantalla de ingreso OTP
- **Nota:** Este token corresponde a la autenticación del sistema Invictus con TESEO

---

### ⚠️ Caso 6: Sin Crédito Vigente

**Request:**
```json
POST /api/reenvio_otp_desembolso
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "guid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
}
```

**Response:**
```json
HTTP/1.1 200 OK
Content-Type: application/json

{
  "status": "no_credit",
  "mensaje": "No se encontró un crédito vigente para esta identificación.",
  "razon": "El crédito ha vencido o ya fue desembolsado"
}
```

**Acción en Invictus:**
- Modal con mensaje del servicio
- Botón [CERRAR]
- Cerrar modal → **REGRESA a pantalla principal de Invictus**
- **Proceso se REINICIA desde cero**

---

### 🚫 Caso 7: Error de Validación - Campos Faltantes

**Request:**
```json
POST /api/reenvio_otp_desembolso
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "tiposdocumento_id": "1"
}
```

**Response:**
```json
HTTP/1.1 400 Bad Request
Content-Type: application/json

{
  "status": "error",
  "errors": [
    "El campo identificacion es obligatorio.",
    "El campo guid es obligatorio."
  ]
}
```

---

## Integración en Invictus

### Opción "Reenviar código OTP"

**Estado inicial:**
- **INHABILITADA** cuando se muestra por primera vez la pantalla de autenticación
- Se muestra como botón o enlace en la pantalla de autenticación

**Habilitación:**
- Se **HABILITA** automáticamente cuando el temporizador llega a **0:00**
- Indicador visual de que el código ha expirado

**Al seleccionar:**
1. Sistema consume este servicio (Reenvío OTP)
2. Espera respuesta del servicio

**Comportamiento según respuesta:**

#### a) Response: `success`
1. Mostrar modal azul con:
    - Título: "Autenticación Cliente"
    - Mensaje: "Ingrese el código OTP de verificación suministrado por el cliente para la autenticación y envío de documentos de crédito"
    - Medios de envío (ofuscados):
        * WhatsApp 314 *** ** 96
        * SMS 314 *** ** 96
        * Email ars****th@gmail.com
    - Mensaje: "El tiempo de vigencia del OTP es de 3:00 minutos"
    - Botón [CERRAR]

2. Al cerrar modal:
    - Permanece en pantalla de autenticación
    - **Limpia las 6 casillas OTP** (en blanco)
    - **Reinicia temporizador a 3:00** minutos
    - **Inhabilita opción "Reenviar código OTP"** nuevamente

3. Validaciones de casillas:
    - Es **obligatorio** ingresar información en **todas las casillas**
    - Si alguna está vacía al intentar [Confirmar]:
        * Resalta en **ROJO** las casillas faltantes
        * No permite habilitar [Confirmar]
    - **Nota:** Debe obedecer HUE 002, criterio 7

#### b) Response: `resend_limit_exceeded`
1. Modal naranja: "Has excedido el número máximo (5) de re envíos permitidos, Comunícate con Credintegral"
2. [CERRAR]
3. Cierra modal → **Regresa a pantalla principal de Invictus**
4. **Proceso completo se REINICIA**

#### c) Response: `already_validated`
1. Modal rojo: "Esta transacción ya ha sido completada exitosamente. No es necesario un nuevo código."
2. [CERRAR]
3. Cierra modal → **Regresa a pantalla principal de Invictus**
4. Transacción ya está completa

#### d) Response: `error` (transacción)
1. Modal rojo: "Transacción no encontrada o inválida"
2. [CERRAR]
3. Permanece en pantalla OTP

#### e) Response: `error` (autenticación)
1. Modal rojo: "Token de autorización inválido o ausente"
2. [CERRAR]
3. Permanece en pantalla OTP

#### f) Response: `no_credit`
1. Modal con mensaje de crédito no vigente
2. [CERRAR]
3. Cierra modal → **Regresa a pantalla principal de Invictus**
4. **Proceso se REINICIA**

---

## Consideraciones de Seguridad

### Control de Reenvíos

- **Límite máximo de reenvíos:** 5 reenvíos por transacción (parametrizable)
- **Propósito:** Evitar spam, ataques de denegación de servicio y fraude
- **Administración:** La cantidad de reenvíos es administrada por TESEO
- **Contador:** Se incrementa con cada reenvío exitoso

### Invalidación de Códigos

- Al generar un nuevo OTP, **todos los códigos anteriores** se invalidan automáticamente
- Solo el código **más reciente** es válido para su validación
- Los intentos fallidos de códigos anteriores **no afectan** el nuevo código
- El contador de intentos se **reinicia a 0** (3 intentos disponibles)

### Nuevo Código OTP

- **Vigencia:** 3 minutos desde su generación (parametrizable)
- **Longitud:** 6 dígitos (numérico o alfanumérico según configuración)
- **Intentos:** 3 intentos máximo (se reinicia el contador)
- **Unicidad:** Cada reenvío genera un código completamente **nuevo y único**

### Nuevo GUID

- **Generación:** Se genera un **nuevo GUID** (UUID v4) diferente al anterior
- **Importancia:** Invictus debe **almacenar el nuevo GUID** para usarlo en:
    - Validación posterior del OTP (Servicio 2)
    - Futuros reenvíos si son necesarios
- El GUID anterior queda invalidado

### Límites Recomendados

Aunque el sistema valida el límite principal, se recomienda:

| Límite | Valor Sugerido | Descripción |
|--------|----------------|-------------|
| **Reenvíos por transacción** | 5 | Máximo por proceso de desembolso |
| **Bloqueo temporal** | 1 hora | Después de exceder límite |
| **Alertas de seguridad** | Automáticas | Notificar patrones sospechosos |

### Registro de Auditoría

Cada reenvío debe registrar:
- **Timestamp:** Fecha y hora exacta del reenvío
- **Nuevo GUID:** UUID generado para este código
- **Identificación del cliente:** Para trazabilidad
- **IP de origen:** Dirección IP desde donde se realizó la petición
- **Canal de envío:** SMS, Email, WhatsApp
- **Estado del envío:** Exitoso o fallido por canal
- **Contador de reenvíos:** Número actual de reenvíos realizados

---

## Parámetros Configurables

Los siguientes valores pueden configurarse en el sistema TESEO:

| Parámetro | Valor por Defecto | Descripción |
|-----------|-------------------|-------------|
| **Reenvíos máximos permitidos** | 5 | Límite por transacción de desembolso |
| **Vigencia del nuevo OTP** | 3 minutos | Tiempo de validez del código |
| **Intentos de validación** | 3 intentos | Número máximo por código OTP |
| **Longitud del código** | 6 dígitos | Cantidad de caracteres del OTP |
| **Tipo de código** | Numérico | Numérico o Alfanumérico |

---

## Notas Importantes

### 📋 Reglas de Negocio

- ✅ El `guid` generado en el reenvío es **diferente** al original
- ✅ Cada reenvío invalida **todos los códigos anteriores** de esa identificación
- ✅ El contador de intentos se **reinicia a cero** (3 intentos disponibles) con cada nuevo código
- ✅ Los canales de envío (SMS, Email, WhatsApp) son los mismos configurados inicialmente para el cliente
- ✅ Si hay fallas en el envío a algún canal, se registra pero **no se bloquea el proceso**
- ✅ El punto Gana (Invictus) debe **almacenar el nuevo GUID** para la validación posterior
- ✅ **La cantidad de reenvíos es administrada por TESEO** (no por Invictus)
- ✅ Al exceder el límite de reenvíos, el cliente debe **comunicarse con Credintegral**

### 🔄 Flujo Completo con Reenvío

```
Servicio 1: Validación de Crédito Vigente
     ↓ (retorna guid_1 + codigo_otp_1)
Pantalla de Autenticación Cliente
     ↓
Temporizador llega a 0:00 (código expirado)
     ↓
Se habilita "Reenviar código OTP"
     ↓
Servicio 3: Reenvío de OTP (este documento)
     ↓ (retorna guid_2 + codigo_otp_2 - NUEVO Y DIFERENTE)
Pantalla de Autenticación Cliente (actualizada)
     ↓ (temporizador reiniciado, casillas limpias)
Cliente ingresa nuevo código OTP
     ↓
Servicio 2: Validación de OTP (usa guid_2)
     ↓ (valida codigo_otp_2)
Sección 2: Datos Crédito
     ↓
Desembolso Final
```

### ⚙️ Configuración del Ambiente

**Ambiente de Pruebas (QA):**
- Base URL: `https://testing-sygma.com/api`
- Endpoint Login: `/login`
- Endpoint Reenvío OTP: `/reenvio_otp_desembolso`
- Usuario: `ws_invictus`
- Password: `g3z0OmJP7?@(*`

### 🎨 Especificaciones de UI para Mensajes Modales

| Status Response | Color Modal | Título/Mensaje | Botón | Acción al Cerrar | Reinicia |
|-----------------|-------------|----------------|-------|------------------|----------|
| `success` | Azul | Instrucciones + medios envío | [CERRAR] | Permanece en OTP | No |
| `resend_limit_exceeded` | Naranja | "Has excedido el número máximo (5)..." | [CERRAR] | Regresa a inicio | **SÍ** |
| `already_validated` | Rojo | "Esta transacción ya ha sido completada..." | [CERRAR] | Regresa a inicio | No |
| `error` (transacción) | Rojo | "Transacción no encontrada..." | [CERRAR] | Permanece en OTP | No |
| `error` (autenticación) | Rojo | "Token de autorización inválido..." | [CERRAR] | Permanece en OTP | No |
| `no_credit` | - | "No se encontró un crédito vigente..." | [CERRAR] | Regresa a inicio | **SÍ** |

### 🔒 Seguridad Adicional

- Todos los endpoints requieren autenticación via Bearer Token
- Los tokens tienen tiempo de expiración
- Se recomienda implementar retry logic para renovación de token
- Los datos sensibles no deben ser almacenados en logs
- El código OTP nunca debe ser almacenado en texto plano
- Todos los reenvíos deben quedar registrados para auditoría
- Implementar alertas automáticas ante patrones sospechosos de reenvíos
- Monitorear intentos de exceder límite de reenvíos

### 📊 Monitoreo y Logs

Se recomienda registrar:
- Timestamp de cada petición de reenvío
- Identificación del usuario consultado (encriptada)
- GUID anterior y nuevo GUID generado
- Status de respuesta
- Número de reenvío (1, 2, 3, etc.)
- Canales de envío utilizados
- Estado del envío por cada canal (exitoso/fallido)
- Tiempo de respuesta del servicio
- Errores y excepciones
- Patrones de reenvíos consecutivos (alerta de seguridad)
