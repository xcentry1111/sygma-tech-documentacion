
# 📘 Manual de Integración API: Validación de Código OTP para Desembolso

## Descripción del Servicio

Este servicio permite validar el código OTP (One Time Password) enviado al cliente para confirmar su identidad y autorizar el desembolso del crédito en un punto Gana. El servicio controla el número de intentos permitidos y gestiona el estado de la transacción de firma.

---

## Tipo de Servicio

**Método HTTP:** `POST`

---

## URL de Integración

| Ambiente | URL |
|----------|-----|
| **Pruebas** | `https://testing-sygma.com/api/validacion_otp_desembolso` |
| **Producción** | `POR DEFINIR` |

---

## Headers Requeridos

| Nombre | Valor | Requerido |
|--------|-------|-----------|
| `Authorization` | `Bearer {token}` | ✅ |
| `Accept` | `application/json` | ✅ |
| `Content-Type` | `application/json` | ✅ |

!!! "Obtención del Token"
    El token se obtiene a través del módulo de autenticación, usando el usuario y contraseña asignados por la entidad.

---

## Cuerpo de la Solicitud

La solicitud debe enviarse en formato **raw JSON** con los siguientes campos:

### Campos Obligatorios

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `tiposdocumento_id` | string | ID del tipo de documento |
| `identificacion` | string | Número de identificación del usuario |
| `codigo_otp` | string | Código OTP de 6 dígitos enviado al cliente |
| `guid` | string | UUID de la transacción generado al enviar el OTP |

### Valores Permitidos para `tiposdocumento_id`

| ID | Descripción |
|----|-------------|
| `1` | Cédula de ciudadanía (CC) |
| `2` | Cédula de extranjería (CE) |
| `3` | NIT |
| `8` | Pasaporte (PA) |
| `181` | Permiso Especial (PEP) |

### Ejemplo de Body

```json
{
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "codigo_otp": "123456",
  "guid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
}
```

---

## Flujo de Validación del Servicio

El servicio ejecuta las siguientes validaciones en orden:

### 1. Validación de Transacción Existente

Se verifica que el `guid` proporcionado exista en el sistema y corresponda a la identificación enviada.

#### ❌ Si la transacción NO existe o no coincide

**Respuesta:**
```json
{
  "status": "error",
  "mensaje": "Transacción no encontrada o no corresponde a esta identificación."
}
```

### 2. Validación de Vigencia del OTP

Se verifica que el código OTP no haya expirado. El tiempo de vigencia es de **5 minutos** desde su generación.

#### ⏰ Si el OTP está vencido

**Respuesta:**
```json
{
  "status": "expired",
  "mensaje": "El código OTP ha expirado. Debe solicitar un nuevo código.",
  "tiempo_transcurrido": "3 minutos"
}
```

### 3. Validación de Intentos Fallidos

El sistema permite un **máximo de 3 intentos** para ingresar el código OTP correcto. Este valor es parametrizable.

#### 🚫 Si se superaron los intentos permitidos

**Acciones automáticas:**
- Se bloquea la transacción
- Se invalida el código OTP actual
- Se registra el bloqueo en el sistema

**Respuesta:**
```json
{
  "status": "blocked",
  "mensaje": "Ha superado el número máximo de intentos permitidos (3). Debe solicitar un nuevo código OTP.",
  "intentos_realizados": 3,
  "intentos_permitidos": 3
}
```

### 4. Validación del Código OTP

Se compara el código ingresado con el código generado y almacenado en el sistema.

#### ❌ Si el código es incorrecto

Se incrementa el contador de intentos fallidos y se informa al usuario.

**Respuesta:**
```json
{
  "status": "invalid",
  "mensaje": "El código OTP ingresado es incorrecto.",
  "intentos_realizados": 1,
  "intentos_restantes": 2
}
```

### 5. Validación Exitosa

Si el código OTP es correcto, se autoriza el desembolso del crédito.

**Acciones automáticas:**
- Actualización del estado del crédito a "listo para desembolsar"
- Registro de la validación exitosa con timestamp
- Invalidación del código OTP (ya no puede usarse nuevamente)
- Habilitación del proceso de desembolso

**Respuesta Success:**
```json
{
  "status": "success",
  "datos": {
    "guid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "mensaje": "Código OTP validado correctamente. Crédito autorizado para desembolso.",
    "monto_desembolso": 500000,
    "nombre_cliente": "Juan Pérez",
    "fecha_validacion": "2025-10-10 14:30:45",
    "puede_desembolsar": true
  }
}
```

---

## Tabla de Validaciones y Respuestas

| # | Condición | HTTP | status | message | Acciones |
|---|-----------|------|--------|---------|----------|
| 1 | Transacción no encontrada | 404 | `error` | "Transacción no encontrada o no corresponde a esta identificación." | Ninguna |
| 2 | OTP expirado (>5 minutos) | 200 | `expired` | "El código OTP ha expirado. Debe solicitar un nuevo código." | Ninguna |
| 3 | Intentos superados (>3) | 200 | `blocked` | "Ha superado el número máximo de intentos permitidos (3)." | Bloqueo de transacción |
| 4 | Código OTP incorrecto | 200 | `invalid` | "El código OTP ingresado es incorrecto." | Incremento de contador |
| 5 | Código OTP correcto | 200 | `success` | "Código OTP validado correctamente. Crédito autorizado para desembolso." | Autorización de desembolso |
| 6 | Error en campos requeridos | 400 | `error` | "El campo {campo} es obligatorio." | Ninguna |
| 7 | Token inválido o ausente | 401 | `error` | "Token de autorización inválido o ausente." | Ninguna |

---

## Ejemplos de Respuestas

### ✅ Respuesta Exitosa - OTP Válido

```json
{
  "status": "success",
  "datos": {
    "guid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "mensaje": "Código OTP validado correctamente. Crédito autorizado para desembolso.",
    "monto_desembolso": 500000,
    "nombre_cliente": "Juan Pérez",
    "fecha_validacion": "2025-10-10 14:30:45",
    "puede_desembolsar": true
  }
}
```

### ❌ Código OTP Incorrecto

```json
{
  "status": "invalid",
  "mensaje": "El código OTP ingresado es incorrecto.",
  "intentos_realizados": 1,
  "intentos_restantes": 2
}
```

### 🚫 Intentos Superados

```json
{
  "status": "blocked",
  "mensaje": "Ha superado el número máximo de intentos permitidos (3). Debe solicitar un nuevo código OTP.",
  "intentos_realizados": 3,
  "intentos_permitidos": 3
}
```

### ⏰ OTP Expirado

```json
{
  "status": "expired",
  "mensaje": "El código OTP ha expirado. Debe solicitar un nuevo código.",
  "tiempo_transcurrido": "6 minutos",
  "vigencia_maxima": "3 minutos"
}
```

### ❌ Transacción No Encontrada

```json
{
  "status": "error",
  "mensaje": "Transacción no encontrada o no corresponde a esta identificación."
}
```

### ❗ Error por Campo Faltante

```json
{
  "status": "error",
  "errors": [
    "El campo codigo_otp es obligatorio.",
    "El campo guid es obligatorio."
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

- **Vigencia:** 5 minutos desde su generación
- **Longitud:** 6 dígitos numéricos
- **Intentos permitidos:** 3 intentos máximo (parametrizable)
- **Uso único:** Una vez validado correctamente, el OTP se invalida
- **Bloqueo:** Después de 3 intentos fallidos, se bloquea la transacción

### Control de Intentos

- Se registra cada intento de validación con timestamp
- Los intentos se cuentan por `guid`
- Al superar los intentos, el cliente debe solicitar un nuevo OTP
- El contador de intentos se reinicia al generar un nuevo OTP

### Registro de Auditoría

- Cada validación (exitosa o fallida) queda registrada
- Se almacena: timestamp, IP de origen, resultado, intentos realizados
- Trazabilidad completa para auditorías y seguridad

### Parámetros Configurables

Los siguientes valores pueden configurarse en el sistema:

- **Número máximo de intentos:** Por defecto 3
- **Vigencia del OTP:** Por defecto 5 minutos
- **Longitud del código:** Por defecto 6 dígitos

---

## Flujo de Integración

!!! "Secuencia Completa"
    1. **Servicio anterior:** Validación de crédito vigente (retorna `success`)
    2. **Servicio de envío:** Se genera y envía OTP (retorna `guid`)
    3. **Este servicio:** Validación del OTP ingresado por el cliente
    4. **Si exitoso:** Se habilita el desembolso del crédito
    5. **Proceso de desembolso:** Se ejecuta la transferencia/entrega de fondos

---

## Notas Importantes

- El cliente recibe el OTP a través de los canales configurados (SMS, Email, WhatsApp)
- Si el código expira o se agotan los intentos, debe solicitarse un nuevo OTP
- El `guid` es fundamental para vincular la validación con el OTP correcto
- Después de 3 intentos fallidos, es obligatorio generar un nuevo código
- La validación exitosa autoriza el desembolso pero NO lo ejecuta automáticamente
- El punto Gana debe invocar el servicio de desembolso tras la validación exitosa
