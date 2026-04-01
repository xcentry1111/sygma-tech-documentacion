# Validación de firma digital y listas restrictivas

## Resumen
Valida si una persona está en proceso de firma digital. El flujo incluye validaciones de estado del crédito, vigencia de aprobación y envío de OTP para continuar con el proceso de firma.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/validacion_firma_digital`
- **Ambientes**:
  - **Pruebas**: `https://testing-sygma.com/api/validacion_firma_digital`
  - **Producción**: `POR DEFINIR`

## Autenticación
- **Tipo**: `Bearer token`
- **Header**: `Authorization: Bearer <token>`

## Headers
- **Authorization**: `Bearer <token>` (obligatorio)
- **Accept**: `application/json` (obligatorio)
- **Content-Type**: `application/json` (obligatorio)

## Request

### Body (JSON)

#### Campos
| Campo | Tipo | Requerido | Descripción |
|------|------|-----------|-------------|
| tiposdocumento_id | string | sí | ID del tipo de documento. |
| identificacion | string | sí | Número de identificación del usuario. |

#### Valores permitidos para `tiposdocumento_id`
| ID | Descripción |
|----|-------------|
| `1` | Cédula de ciudadanía (CC) |
| `2` | Cédula de extranjería (CE) |
| `3` | NIT |
| `8` | Pasaporte (PA) |
| `181` | Permiso Especial (PEP) |

#### Ejemplo
```json
{
  "tiposdocumento_id": "1",
  "identificacion": "88282828"
}
```

## Responses
Ver sección **Flujo de validación** (incluye `success`, `blocked`, `expired`, `no_credit` y errores).

## Notas / Flujo

### Flujo de validación del servicio

El servicio ejecuta las siguientes validaciones en orden:

### 1. Consulta Interna: Proceso de Firma Digital

Se verifica si la persona está actualmente en proceso de firma digital dentro del sistema, en caso de que no este se retorna la respuesta  que el usuario actualmente no cuenta con una solicitud de credito disponible.

```json
    {
      "status": "blocked",
      "mensaje": "No hay crédito disponible para firma."
    }
```


### 2. Validación de Crédito Aprobado

Si el usuario **NO** está en lista restrictiva, el sistema verifica si tiene un crédito aprobado.

#### ✅ Si tiene crédito aprobado

Se valida la vigencia de la aprobación:

##### Crédito aprobado hace más de 30 días

- Se retorna la respuesta a invictus de la siguiente manera.

**Respuesta:**
```json
{
  "status": "expired",
  "mensaje": "Tu crédito aprobado ha caducado. Puedes realizar una nueva solicitud de crédito."
}
```

##### Crédito aprobado dentro del plazo (< 30 días)

**Acciones automáticas:**

- Se genera un código OTP de 6 dígitos (Puede ser parametrico, pueden ser  alfanumerico, numerico, y pueden ser menos caracteres o mas)
- Se debe enviar a todos los canales:
    - SMS
    - Correo electrónico
    - WhatsApp (si fue seleccionado)

**Respuesta Success:**
```json
{
  "status": "success",
  "datos": {
    "guid": "uuid-generado",
    "mensaje": "Código OTP enviado exitosamente a los canales registrados: ",
    "canales_envio": ["SMS", "Email", "WhatsApp"],
    "sms": "3016795098",
    "email": "prueba@prueba.com",
    "whatsapp": "3016795098",
    "vigencia_otp": "5 minutos"
  }
}
```

#### ❌ Si NO tiene crédito aprobado

**Respuesta:**
```json
{
  "status": "no_credit",
  "mensaje": "No tienes un crédito aprobado disponible para firma."
}
```

---

## Tabla de Validaciones y Respuestas

| # | Condición | HTTP | status | message | Acciones |
|---|-----------|------|--------|---------|----------|
| 1 | Usuario en lista restrictiva | 403 | `blocked` | "No hay crédito disponible. Usuario en lista restrictiva." | Envío de SMS + Email informativo |
| 2 | Crédito aprobado caducado (>30 días) | 200 | `expired` | "Tu crédito aprobado ha caducado. Puedes realizar una nueva solicitud." | Ninguna |
| 3 | Crédito aprobado vigente (<30 días) | 200 | `success` | "Código OTP enviado exitosamente a los canales registrados." | Generación y envío de OTP |
| 4 | Sin crédito aprobado | 200 | `no_credit` | "No tienes un crédito aprobado disponible para firma." | Ninguna |
| 5 | Error en campos requeridos | 400 | `error` | "El campo {campo} es obligatorio." | Ninguna |
| 6 | Token inválido o ausente | 401 | `error` | "Token de autorización inválido o ausente." | Ninguna |

---

## Ejemplos de Respuestas

### ✅ Respuesta Exitosa - OTP Enviado

```json
{
  "status": "success",
  "datos": {
    "guid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "mensaje": "Código OTP enviado exitosamente a los canales registrados.",
    "canales_envio": ["SMS", "Email", "WhatsApp"],
    "sms": "3016795098",
    "email": "prueba@prueba.com",
    "whatsapp": "3016795098",
    "vigencia_otp": "5 minutos"
  }
}
```

### 🚫 Usuario en Lista Restrictiva

```json
{
  "status": "blocked",
  "mensaje": "No hay crédito disponible. Usuario en lista restrictiva.",
  "notificacion_enviada": true
}
```

### ⏰ Crédito Caducado

```json
{
  "status": "expired",
  "mensaje": "Tu crédito aprobado ha caducado. Puedes realizar una nueva solicitud de crédito.",
  "dias_transcurridos": 45
}
```

### ❌ Sin Crédito Aprobado

```json
{
  "status": "no_credit",
  "mensaje": "No tienes un crédito aprobado disponible para firma."
}
```

### ❗ Error por Campo Faltante

```json
{
  "status": "error",
  "errors": [
    "El campo identificacion es obligatorio."
  ]
}
```

### ❗ Error de Autenticación

```json
{
  "status": "error",
  "mensaje": "Token de autorización inválido o ausente."
}
```

---

## Consideraciones de Seguridad

### Código OTP

- **Vigencia:** 5 minutos
- **Longitud:** 6 dígitos numéricos
- **Intentos:** Se invalida después de 3 intentos fallidos

### Consulta de Listas Restrictivas

- Se realiza en tiempo real con el operador configurado
- **Timeout máximo:** 30 segundos
- En caso de error del operador, se debe notificar y registrar para revisión manual

### Almacenamiento de Transacciones

- Todas las consultas y respuestas deben quedar registradas con `guid` único
- Incluir timestamp, usuario, resultado de validaciones y acciones ejecutadas
