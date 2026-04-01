# Validación de crédito vigente para desembolso (Invictus)

## Resumen
Valida si una persona cuenta con un crédito **aprobado y vigente** para realizar el desembolso en puntos autorizados (Gana). Verifica estado y vigencia (máximo 1 mes desde aprobación), valida condiciones del cliente/cupo y genera el OTP requerido para el flujo de desembolso.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/validacion_credito_vigente`
- **Ambientes**:
  - **Pruebas (QA)**: `https://testing-sygma.com/api/validacion_credito_vigente`
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
Ver secciones de validaciones/ejemplos (incluye `success`, `no_credit`, `pending_signatures`, `credit_blocked`, `expired`, `already_disbursed` y errores).

## Notas / Flujo

### Flujo del proceso

### Contexto General
Este servicio forma parte del flujo de **"Desembolso de Créditos Credintegral"** en Invictus y se ejecuta cuando el vendedor (Seller) ingresa a la opción:

```
Invictus → Bancos → Desembolso de créditos Credintegral
```

### Secuencia del Flujo

```
1. Vendedor ingresa datos del cliente en la sección "1. Datos cliente"
   - Selecciona Tipo de Identificación (lista desplegable)
   - Ingresa Número de Identificación
   ↓
2. Vendedor presiona botón [Buscar]
   - Invictus valida campos obligatorios (Front-end)
   ↓
3. Sistema consume servicio de Validación de Crédito Vigente (TESEO)
   ↓
4. Servicio ejecuta validaciones en orden secuencial:
   
   a) Validación de Autenticación
      ↓ Token inválido/vencido? → SÍ: retorna "error" (401)
   
   b) Validación de Campos Requeridos
      ↓ Campos vacíos/inválidos? → SÍ: retorna "error" (400)
   
   c) Búsqueda de Cliente/Cupo
      ↓ Cliente no existe? → SÍ: retorna "no_credit"
      ↓ Cupo cancelado? → SÍ: retorna "no_credit"
      ↓ Cupo expirado (sin uso 6 meses)? → SÍ: retorna "no_credit"
      ↓ Cliente fallecido? → SÍ: retorna "no_credit"
   
   d) Validación de Firmas de Documentos
      ↓ Documentos pendientes de firma? → SÍ: retorna "pending_signatures"
   
   e) Validación de Estado de Mora
      ↓ Cupo en mora temporal? → SÍ: retorna "credit_blocked"
      ↓ Cupo en mora definitivo? → SÍ: retorna "credit_blocked"
   
   f) Validación de Vigencia del Crédito
      ↓ Crédito vencido (>30 días)? → SÍ: actualiza a "vencido" y retorna "expired"
   
   g) Validación de Estado de Desembolso
      ↓ Crédito ya desembolsado? → SÍ: retorna "already_disbursed"
   
   h) Crédito Vigente y Disponible
      ↓ Todas las validaciones OK → Genera OTP y retorna "success"
   ↓
5. Si status = "success":
   - Sistema muestra pantalla de Autenticación Cliente
   - Muestra medios de envío de OTP (WhatsApp, SMS, Email) ofuscados
   - Presenta 6 casillas para ingreso de código OTP
   - Muestra indicador de tiempo de vigencia (parametrizable, mín. 1 minuto)
   - Habilita opción de reenvío (inhabilitada por defecto)
   - Botones: [Limpiar], [Cancelar], [Confirmar]
```

---

## Información Técnica

### Tipo de Servicio

**Método HTTP:** `POST`

---

### URL de Integración

| Ambiente | URL |
|----------|-----|
| **Pruebas (QA)** | `https://testing-sygma.com/api/validacion_credito_vigente` |
| **Producción** | `POR DEFINIR` |

---

### Headers Requeridos

| Nombre | Valor | Requerido | Descripción |
|--------|-------|-----------|-------------|
| `Authorization` | `Bearer {token}` | ✅ | Token de autenticación JWT |
| `Accept` | `application/json` | ✅ | Formato de respuesta esperado |
| `Content-Type` | `application/json` | ✅ | Formato del cuerpo de la petición |

#### 🔐 Obtención del Token

 
---

## Request

### Cuerpo de la Solicitud

La solicitud debe enviarse en formato **raw JSON** con los siguientes campos:

#### Campos Obligatorios

| Campo | Tipo | Longitud | Requerido | Descripción |
|-------|------|----------|-----------|-------------|
| `tiposdocumento_id` | string | - | ✅ | ID del tipo de documento según catálogo |
| `identificacion` | string | variable | ✅ | Número de identificación del usuario |

#### Catálogo de Tipos de Documento

| `tiposdocumento_id` | Descripción | Código |
|---------------------|-------------|--------|
| `1` | Cédula de ciudadanía | CC |
| `2` | Cédula de extranjería | CE |
| `3` | NIT | NIT |
| `8` | Pasaporte | PA |
| `181` | Permiso Especial | PEP |

**Nota importante:** El campo en Invictus debe mostrar la **descripción** del tipo de documento, pero enviar el **ID** correspondiente en la integración con TESEO.

#### Ejemplo de Request

```json
{
  "tiposdocumento_id": "1",
  "identificacion": "88282828"
}
```

---

## Validaciones del Servicio

El servicio ejecuta las siguientes validaciones en orden secuencial:

### Nivel 1: Validación de Front-end (Invictus)

**Reglas (antes de consumir el servicio):**
- Si el botón [Buscar] es presionado sin información válida en uno o ambos campos obligatorios
- Invictus debe resaltar en **color rojo** el nombre del campo con información faltante, incompleta o inválida
- **NO debe permitir continuar** hasta que la información sea corregida
- **En este punto NO se debe consumir ningún servicio de TESEO**

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
- Mostrar mensaje modal: **"Token de autorización Inválido o asusnete"** (fondo rojo)
- El mensaje debe poder cerrarse con X
- Dejar al usuario en la pantalla de la opción **sin borrar** información seleccionada o ingresada
- **Nota:** Este token corresponde a la autenticación del sistema Invictus con el sistema TESEO

---

### Nivel 3: Validación de Campos Requeridos

**Reglas:**
- Campo `tiposdocumento_id` es obligatorio
- Campo `identificacion` es obligatorio
- Ambos campos deben ser tipo string
- No se permiten valores vacíos o nulos

**Respuesta en caso de error:**
```json
{
  "status": "error",
  "errors": [
    "El campo {nombre_campo} es obligatorio."
  ]
}
```

**Código HTTP:** `400 Bad Request`

---

### Nivel 4: Búsqueda y Validación de Cliente/Cupo

**Proceso:**
1. Se consulta en el sistema TESEO si existe un cliente registrado
2. Búsqueda por: `tiposdocumento_id` + `identificacion`
3. Se valida el estado del cupo asociado

**Resultado: Cliente No Cuenta con Cupo Registrado**

Este status se aplica cuando el cliente presenta cualquiera de las siguientes situaciones:

#### 4.1 Cliente No Existe
El sistema no encontró ningún cliente con la identificación proporcionada.

#### 4.2 Cupo Cancelado
El cupo del cliente fue cancelado por políticas internas.

#### 4.3 Cupo Expirado
Cliente sin uso del cupo en los últimos **6 meses** y que no tenga deuda activa.

#### 4.4 Cliente Fallecido
El cliente está registrado como fallecido en el sistema.

**Respuesta unificada para todos los casos anteriores:**
```json
{
  "status": "no_credit",
  "mensaje": "No se encontró un crédito aprobado para esta identificación."
}
```

**Código HTTP:** `200 OK`

**Comportamiento en Invictus:**
- Mostrar mensaje modal: **"Cliente no cuenta con un cupo registrado"** (fondo naranja/amarillo)
- El mensaje debe poder cerrarse con X
- Dejar al usuario en la pantalla de la opción **sin borrar** información seleccionada o ingresada

**Acciones del sistema:**
- Ninguna acción adicional
- El usuario debe solicitar un nuevo crédito

---

### Nivel 5: Validación de Firmas de Documentos

**Si el cliente existe y tiene cupo activo**, se verifica que haya completado el proceso de firmas.

**Resultado: Documentos Pendientes de Firma**

El cliente tiene documentos pendientes de firma que deben completarse antes del desembolso.

**Respuesta:**
```json
{
  "status": "pending_signatures",
  "mensaje": "El cliente debe completar el proceso de firmas de documentos antes de realizar el desembolso.",
  "link_firmas": "/proceso-firmas"
}
```

**Código HTTP:** `200 OK`

**Comportamiento en Invictus:**
- Mostrar mensaje modal: **"Diríjase al Proceso de Firmas para realizar el desembolso"** (fondo verde/turquesa)
- El mensaje debe mostrar un **link clicable** para llevar al usuario al proceso de firmas en Invictus
- El mensaje debe poder cerrarse con X
- **El sistema NO debe continuar con la transacción de desembolso**
- Dejar al usuario en la pantalla de la opción **sin borrar** información seleccionada o ingresada

**Campos de respuesta:**
- `status`: Indicador del resultado (`pending_signatures`)
- `mensaje`: Descripción para el usuario final
- `link_firmas`: Ruta o URL al proceso de firmas en Invictus

---

### Nivel 6: Validación de Estado de Mora

**Si el cliente tiene documentos firmados**, se verifica que no tenga bloqueos por mora.

**Resultado: Cupo Bloqueado por Mora**

El cupo se encuentra bloqueado por situación de mora y no puede ser utilizado.

**Tipos de bloqueo:**
- **Bloqueo - Mora – Temporal:** Bloqueo reversible por pago
- **Bloqueo - Mora – Definitivo:** Bloqueo permanente

**Respuesta:**
```json
{
  "status": "credit_blocked",
  "mensaje": "No puede utilizar el cupo. El cliente se encuentra en Mora.",
  "tipo_bloqueo": "mora_temporal"
}
```

**Código HTTP:** `200 OK`

**Comportamiento en Invictus:**
- Mostrar mensaje modal: **"No puede utilizar el cupo El cliente se encuentra en Mora"** (fondo verde oscuro)
- El mensaje debe poder cerrarse con X
- **NO debe permitir continuar con la transacción de desembolso**
- Dejar al usuario en la pantalla de la opción **sin borrar** información seleccionada o ingresada

**Campos de respuesta:**
- `status`: Indicador del resultado (`credit_blocked`)
- `mensaje`: Descripción para el usuario final
- `tipo_bloqueo`: Tipo de bloqueo aplicado (`mora_temporal` | `mora_definitivo`)

---

### Nivel 7: Validación de Vigencia del Crédito

**Si el cliente no tiene bloqueos**, se verifica que el crédito no haya superado el plazo de vigencia.

**Regla de negocio:**
- Vigencia máxima: **30 días naturales** desde la fecha de aprobación
- Fórmula: `días_transcurridos = fecha_actual - fecha_aprobacion`
- Si `días_transcurridos > 30` → Crédito vencido

**Resultado: Crédito Vencido (>30 días)**

El crédito superó el plazo máximo permitido para realizar el desembolso.

**Acciones automáticas del sistema:**
1. Actualiza el estado del crédito a `"vencido"` en base de datos
2. Registra la fecha de vencimiento
3. El crédito ya no puede ser utilizado

**Respuesta:**
```json
{
  "status": "expired",
  "mensaje": "El crédito aprobado ha vencido. El plazo de 1 mes para el retiro ha expirado, puedes volver a solicitar un credito.",
  "dias_transcurridos": 56
}
```

**Código HTTP:** `200 OK`

**Campos de respuesta:**
- `status`: Indicador del resultado (`expired`)
- `mensaje`: Descripción para el usuario final
- `dias_transcurridos`: Número de días desde la aprobación (informativo)

---

### Nivel 8: Validación de Estado de Desembolso

**Si el crédito está vigente**, se verifica que no haya sido desembolsado previamente.

**Resultado: Crédito Ya Desembolsado**

El crédito ya fue retirado anteriormente y no puede ser utilizado nuevamente.

**Respuesta:**
```json
{
  "status": "already_disbursed",
  "mensaje": "Este crédito ya fue desembolsado anteriormente.",
  "fecha_desembolso": "2025-09-25"
}
```

**Código HTTP:** `200 OK`

**Campos de respuesta:**
- `status`: Indicador del resultado (`already_disbursed`)
- `mensaje`: Descripción para el usuario final
- `fecha_desembolso`: Fecha en que se realizó el desembolso previo (formato: YYYY-MM-DD)

---

### Nivel 9: Crédito Vigente y Disponible ✅

**Condiciones cumplidas:**
- ✅ Existe crédito aprobado
- ✅ Cliente existe y tiene cupo activo
- ✅ Documentos firmados
- ✅ Sin bloqueos por mora
- ✅ Crédito está vigente (menos de 30 días desde aprobación)
- ✅ Crédito NO ha sido desembolsado

**Acciones del sistema:**
1. Genera código OTP único (6 dígitos, numérico o alfanumérico)
2. Almacena el GUID de la transacción (UUID v4)
3. Prepara información de canales de envío (ofuscada)
4. Habilita el proceso de autenticación OTP

**Respuesta exitosa:**
```json
{
  "status": "success",
  "datos": {
     "guid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
     "codigo_otp": 202023,
     "canales_envio": {
        "whatsapp": "314 *** ** 96",
        "sms": "314 *** ** 96",
        "email": "ars****th@gmail.com"
     },
    "informacion_personal": {
      "whatsapp": "3146795096",
      "sms": "3146795096",
      "email": "arsenalth@gmail.com"
    },
     "mensaje": "Crédito validado con exito!!!."
  }
}
```

**Código HTTP:** `200 OK`

**Campos de respuesta:**
- `status`: Indicador del resultado (`success`)
- `datos.guid`: Identificador único de la transacción (UUID v4)
- `datos.codigo_otp`: Código para validación (6 dígitos, numérico o alfanumérico)
- `datos.canales_envio`: Objeto con canales disponibles (**información ofuscada por TESEO**)
    - `whatsapp`: Número ofuscado de WhatsApp
    - `sms`: Número ofuscado de SMS
    - `email`: Email ofuscado
- `datos.mensaje`: Mensaje de confirmación

**Comportamiento en Invictus - Pantalla de Autenticación Cliente:**

Invictus debe mostrar una **ventana modal** con la siguiente información:

**1. Título de la ventana (parametrizable):**
```
"Ingrese el código OTP de verificación suministrado por el cliente 
para la autenticación y envío de documentos de crédito"
```

**2. Medios de envío:**
Mostrar la información ofuscada que responde el servicio:
- WhatsApp 314 *** ** 96
- SMS 314 *** ** 96
- Email ars****th@gmail.com

**3. Casillas para ingresar código OTP:**
- **6 casillas individuales** (parametrizable en longitud máxima)
- Código puede ser **totalmente numérico o alfanumérico**
- Debe permitir escribirse y editarse en cualquier momento antes de seleccionar cualquier opción
- Cada casilla debe aceptar un solo carácter

**4. Opción de reenvío del código OTP:**
- Botón o enlace: **"Reenviar código OTP"**
- **Inhabilitado por defecto** al abrir la pantalla
- Se habilita después de que expire el temporizador

**5. Indicador de tiempo de vigencia del OTP:**
- Temporizador de cuenta regresiva
- Tiempo **parametrizable** en Invictus
- **Tiempo mínimo:** 1 minuto (60 segundos)
- Ejemplo: "El tiempo de vigencia del OTP es de 3:00 minutos"
- Al llegar a 0:00, habilita la opción de reenvío

**6. Botones de acción:**

**[Limpiar]:**
- Limpia la información ingresada o seleccionada en **todos los campos** de la pantalla
- Permanece en la pantalla de autenticación
- No consume servicios

**[Cancelar]:**
- Botón seleccionable en cualquier momento
- Cancela el envío del OTP
- Vuelve a la pantalla anterior (Datos Cliente)
- **No consume ningún servicio**
- **No borra información** de la solicitud en curso
- Permite volver a iniciar la autenticación por OTP

**[Confirmar]:**
- Al seleccionarlo, consume el servicio de **Validación OTP** (siguiente servicio en el flujo)
- **Inhabilitado** si no hay información en todas las casillas OTP
- Se habilita solo cuando las 6 casillas estén completas

---

## Response - Tabla Resumen de Respuestas

| # | Condición | HTTP Code | status | Mensaje UI Invictus | Acciones Sistema |
|---|-----------|-----------|--------|---------------------|------------------|
| 1 | Validación Front-end fallida | - | - | Resalta campos en rojo | No consume servicio |
| 2 | Token ausente o inválido | 401 | `error` | Modal rojo: "Token inválido o ausente" | Ninguna |
| 3 | Campos requeridos faltantes | 400 | `error` | - | Ninguna |
| 4 | Cliente no existe / Cupo inactivo | 200 | `no_credit` | Modal naranja: "Cliente no cuenta con cupo" | Ninguna |
| 5 | Documentos pendientes de firma | 200 | `pending_signatures` | Modal verde: Link a proceso firmas | Bloquea desembolso |
| 6 | Cupo bloqueado por mora | 200 | `credit_blocked` | Modal verde oscuro: "Cliente en Mora" | Bloquea desembolso |
| 7 | Crédito vencido (>30 días) | 200 | `expired` | - | Actualiza estado a "vencido" |
| 8 | Crédito ya desembolsado | 200 | `already_disbursed` | - | Ninguna |
| 9 | Crédito vigente y disponible | 200 | `success` | Modal autenticación OTP | Habilita siguiente paso |

---

## Ejemplos de Respuestas Completas

### ✅ Caso 1: Validación Exitosa - Crédito Vigente (CUPO ACTIVO)

**Request:**
```json
POST /api/validacion_credito_vigente
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "tiposdocumento_id": "1",
  "identificacion": "88282828"
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
     "codigo_otp": 202023,
     "canales_envio": {
        "whatsapp": "314 *** ** 96",
        "sms": "314 *** ** 96",
        "email": "ars****th@gmail.com"
     },
    "informacion_personal": {
        "whatsapp": "3146795096",
        "sms": "3146795096",
        "email": "arsenalth@gmail.com"
    },
     "mensaje": "Crédito validado con exito!!!."
  }
}
```

**Acción en Invictus:**
- Mostrar ventana modal de "Autenticación Cliente"
- Desplegar casillas para ingreso de OTP
- Mostrar temporizador de vigencia
- Botones: [Limpiar], [Cancelar], [Confirmar (inhabilitado)]

---

### ❌ Caso 2: Cliente Sin Cupo Registrado

**Request:**
```json
POST /api/validacion_credito_vigente
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "tiposdocumento_id": "1",
  "identificacion": "12345678"
}
```

**Response:**
```json
HTTP/1.1 200 OK
Content-Type: application/json

{
  "status": "no_credit",
  "mensaje": "No se encontró un crédito aprobado para esta identificación."
}
```

**Acción en Invictus:**
- Mostrar modal naranja: **"Cliente no cuenta con un cupo registrado"**
- Botón X para cerrar
- Mantener información en pantalla

---

### 🔐 Caso 3: Token de Autenticación Inválido

**Request:**
```json
POST /api/validacion_credito_vigente
Authorization: Bearer token_invalido_o_expirado
Content-Type: application/json

{
  "tiposdocumento_id": "1",
  "identificacion": "88282828"
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
- Mostrar modal rojo: **"Token de autorización Inválido o asusnete"**
- Botón X para cerrar
- Mantener información en pantalla

---

### 📝 Caso 4: Documentos Pendientes de Firma

**Request:**
```json
POST /api/validacion_credito_vigente
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "tiposdocumento_id": "1",
  "identificacion": "55667788"
}
```

**Response:**
```json
HTTP/1.1 200 OK
Content-Type: application/json

{
  "status": "pending_signatures",
  "mensaje": "El cliente debe completar el proceso de firmas de documentos antes de realizar el desembolso.",
  "link_firmas": "/proceso-firmas"
}
```

**Acción en Invictus:**
- Mostrar modal verde/turquesa: **"Diríjase al Proceso de Firmas para realizar el desembolso"**
- Incluir link clicable al proceso de firmas
- Botón X para cerrar
- Bloquear continuación del desembolso

---

### ⚠️ Caso 5: Cupo Bloqueado por Mora

**Request:**
```json
POST /api/validacion_credito_vigente
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "tiposdocumento_id": "1",
  "identificacion": "99887766"
}
```

**Response:**
```json
HTTP/1.1 200 OK
Content-Type: application/json

{
  "status": "credit_blocked",
  "mensaje": "No puede utilizar el cupo. El cliente se encuentra en Mora.",
  "tipo_bloqueo": "mora_temporal"
}
```

**Acción en Invictus:**
- Mostrar modal verde oscuro: **"No puede utilizar el cupo El cliente se encuentra en Mora"**
- Botón X para cerrar
- Bloquear continuación del desembolso
- Mantener información en pantalla

---

### ⏰ Caso 6: Crédito Vencido

**Request:**
```json
POST /api/validacion_credito_vigente
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "tiposdocumento_id": "1",
  "identificacion": "33445566"
}
```

**Response:**
```json
HTTP/1.1 200 OK
Content-Type: application/json

{
  "status": "expired",
  "mensaje": "El crédito aprobado ha vencido. El plazo de 1 mes para el retiro ha expirado, puedes volver a solicitar un credito.",
  "dias_transcurridos": 56
}
```

---

### 🔄 Caso 7: Crédito Ya Desembolsado

**Request:**
```json
POST /api/validacion_credito_vigente
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "tiposdocumento_id": "1",
  "identificacion": "55443322"
}
```

**Response:**
```json
HTTP/1.1 200 OK
Content-Type: application/json

{
  "status": "already_disbursed",
  "mensaje": "Este crédito ya fue desembolsado anteriormente.",
  "fecha_desembolso": "2025-09-25"
}
```

---

### 🚫 Caso 8: Error de Validación - Campo Faltante

**Request:**
```json
POST /api/validacion_credito_vigente
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
    "El campo identificacion es obligatorio."
  ]
}
```

---

## Integración en Invictus

### Pantalla: Desembolso de Créditos Credintegral

La pantalla está dividida en 3 secciones:

#### Sección 1: Datos Cliente

**Campos:**

1. **Tipo de Identificación** (obligatorio)
    - Tipo: Lista desplegable (dropdown)
    - Valores disponibles:
        - Cédula de ciudadanía (CC)
        - Cédula de extranjería (CE)
        - NIT
        - Pasaporte (PA)
        - Permiso Especial (PEP)
    - El campo debe **mostrar la descripción**, pero **enviar el ID** en la integración
    - Ejemplo: Usuario ve "Cédula de ciudadanía (CC)", pero se envía `"1"`

2. **Número de Identificación** (obligatorio)
    - Tipo: Campo numérico
    - Validación: Solo números

**Botones:**

- **[Limpiar]**: Limpia la información de los campos ingresados o seleccionados
- **[Buscar]**: Consume el servicio de TESEO con los datos ingresados (este servicio)

**Nota importante:** La validación correcta del cliente es **prerrequisito** para la selección de una línea de crédito para desembolso.

#### Sección 2: Datos Crédito

Se muestra solo si el servicio retorna `status: "success"`:
- Línea de crédito
- Valor cupo
- Total entregado
- Total disponible
- Plazo (meses)
- Ingresos plazo
- Confirme plazo
- Ingresos valor
- Confirme valor
- Botón "Selección"

#### Sección 3: Realizar Desembolso

Se habilita solo después de validación exitosa y autenticación OTP:
- Valor Total
- Valor Cobros
- Plaza Empresa
- Valor a Pagar al Cliente

**Botones de acción:**
- **Cancelar**: Cancela la transacción y retorna a pantalla inicial (sin guardar)
- **Limpiar**: Limpia todos los campos de las 3 secciones
- **Pagar**: Se habilita solo después de validar OTP, ejecuta el desembolso (inhabilitado por defecto)

---

## Notas Importantes

### 📋 Reglas de Negocio

- ✅ El mensaje SMS informativo al cliente se envía al momento de la **aprobación del crédito**, indicando que debe acercarse a un punto Gana
- ✅ **Este servicio NO envía notificaciones**, solo valida el estado del crédito
- ✅ La vigencia de 30 días es **parametrizable** en la configuración del sistema
- ✅ Para créditos vencidos, el cliente debe realizar una **nueva solicitud completa**
- ✅ El código OTP generado será utilizado en el siguiente servicio de la cadena
- ✅ Invictus debe soportar códigos OTP **totalmente numéricos o alfanuméricos**
- ✅ La longitud de las casillas OTP debe ser **parametrizable** (por defecto 6 dígitos)
- ✅ El tiempo del temporizador de OTP debe ser **parametrizable** con mínimo de 1 minuto

### 🔄 Flujo Completo de Desembolso

```
Servicio 1: Validación de Crédito Vigente (este documento)
     ↓ (retorna guid + codigo_otp + canales_envio si success)
Pantalla de Autenticación Cliente (en Invictus)
     ↓ (usuario ingresa código OTP)
Servicio 2: Validación de OTP
     ↓ (confirma OTP ingresado por el cliente)
[Opcional] Servicio 3: Servicio de Reenvío de OTP
     ↓ (si el temporizador expira)
Desembolso Final
```

### ⚙️ Configuración del Ambiente

**Ambiente de Pruebas (QA):**
- Base URL: `https://testing-sygma.com/api`
- Endpoint Login: `/login`
- Endpoint Validación: `/validacion_credito_vigente`
- Usuario: `ws_invictus`
- Password: `g3z0OmJP7?@(*`

### 🎨 Especificaciones de UI para Mensajes Modales

| Status Response | Color Modal | Título/Mensaje | Icono | Acciones |
|-----------------|-------------|----------------|-------|----------|
| `error` (401) | Rojo | "Token de autorización Inválido o asusnete" | ⚠️ | Cerrar (X) |
| `no_credit` | Naranja/Amarillo | "Cliente no cuenta con un cupo registrado" | ℹ️ | Cerrar (X) |
| `pending_signatures` | Verde/Turquesa | "Diríjase al Proceso de Firmas..." | 📝 | Link + Cerrar |
| `credit_blocked` | Verde Oscuro | "No puede utilizar el cupo..." | 🔒 | Cerrar (X) |
| `success` | Azul | "Autenticación Cliente" | ✓ | Formulario OTP |

### 🔒 Seguridad

- Todos los endpoints requieren autenticación via Bearer Token
- Los tokens tienen tiempo de expiración
- Se recomienda implementar retry logic para renovación de token
- Los datos sensibles no deben ser almacenados en logs
- La información de canales de envío (teléfono, email) debe llegar **ofuscada desde TESEO**
- Invictus solo debe mostrar la información ofuscada, no debe intentar des-ofuscarla

### 📊 Monitoreo y Logs

Se recomienda registrar:
- Timestamp de cada petición
- Identificación del usuario consultado (encriptada)
- Status de respuesta
- Tiempo de respuesta del servicio
- Errores y excepciones
- Intentos fallidos de autenticación

---

## Glosario

| Término | Definición |
|---------|------------|
| **TESEO** | Sistema backend que gestiona los créditos de Credintegral |
| **Invictus** | Sistema frontend utilizado por vendedores (Sellers) en puntos Gana |
| **OTP** | One-Time Password - Código de un solo uso para validación |
| **GUID** | Globally Unique Identifier - Identificador único de transacción |
| **Seller** | Vendedor autorizado en punto Gana para realizar desembolsos |
| **Desembolso** | Entrega física del dinero del crédito al cliente |
| **Cupo** | Monto de crédito aprobado para el cliente |
| **Mora** | Estado de atraso en el pago de obligaciones crediticias |
| **Ofuscación** | Técnica de ocultar parcialmente información sensible (ej: 314 *** ** 96) |
| **Parametrizable** | Valor configurable en el sistema sin necesidad de cambiar código |
