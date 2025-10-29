# 📘 Manual de Integración API: **Reenvío de Código OTP**

## 📄 Descripción del Servicio

Este servicio permite reenviar el código OTP a los canales de comunicación previamente seleccionados por el usuario (SMS, Email, WhatsApp) cuando el código ha expirado, se han agotado los intentos o el usuario no ha recibido el mensaje original. El servicio genera un nuevo código OTP con vigencia renovada.

---

## 🚀 Tipo de Servicio

`POST`

---

## 🔗 URL de Integración
 
- **Ambiente de Pruebas:** `https://testing-sygma.com/api/reenvio_otp_firma`  
- **Producción:** `POR DEFINIR`

---

## 📉 Headers Requeridos

| Nombre        | Valor                | Requerido |
|---------------|----------------------|-----------|
| Authorization | Bearer `{token}`     | ✅         |
| Accept        | application/json     | ✅         |
| Content-Type  | application/json     | ✅         |

!!! info "Nota sobre autenticación"
    El token se obtiene a través del módulo de autenticación, usando el usuario y contraseña asignados por la entidad.

---

## 🔢 Cuerpo de la Solicitud (JSON)

La solicitud debe enviarse en formato `raw` JSON con los siguientes campos:

### 🔸 Campos Obligatorios

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `guid` | string (UUID) | ID único de la transacción generada en el servicio de validación de firma digital |
| `identificacion` | string | Número de identificación del usuario |

---


## 📦 Ejemplo de Body
```json
{
  "guid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "identificacion": "88282828"
}
```

### 🔄 Flujo de Validación del Servicio
- El servicio ejecuta las siguientes validaciones en orden:
### 1️⃣ Validación de Campos Obligatorios
- Se verifica que los campos guid e identificacion estén presentes en la solicitud.

---

### 2️⃣ Validación de Transacción Existente
- Se verifica que:

- El guid exista en el sistema
- La identificacion corresponda con el usuario asociado al guid
- La transacción no esté en estado completado (OTP ya validado correctamente)

### 3️⃣ Validación de Límite de Reenvíos
- Se verifica el número de veces que se ha solicitado el reenvío del OTP para esta transacción.
- !!! "Límite de Reenvíos"
- Máximo permitido: 5 reenvíos por transacción
- Tiempo mínimo entre reenvíos: 60 segundos

### 🚫 Si se excede el límite de reenvíos:

```json
{
  "status": "error",
  "mensaje": "Has excedido el número máximo de reenvíos permitidos. Por favor, contacta a soporte.",
  "reenvios_maximos": 5,
  "reenvios_realizados": 5
}
```

### 4️⃣ Validación de Tiempo entre Reenvíos
- Se verifica que hayan transcurrido al menos 60 segundos desde el último reenvío.
- ⏱️ Si no ha pasado el tiempo mínimo:

- Respuesta:

```json
{
  "status": "error",
  "mensaje": "Debes esperar {segundos_restantes} segundos antes de solicitar un nuevo código.",
  "tiempo_espera_minimo": "60 segundos",
  "segundos_restantes": 42
}
```

### 5️⃣ Generación y Envío de Nuevo OTP
- Si todas las validaciones son exitosas:

- Acciones automáticas:

1. Se invalida el código OTP anterior
2. Se genera un nuevo código OTP de 6 dígitos
3. Se reinician los intentos de validación (3 intentos disponibles)
4. Se actualiza la vigencia del código (3 minutos)
5. Se envía el nuevo código a los canales registrados del usuario:

- SMS
- Email
- WhatsApp (si fue seleccionado)


- Se registra el reenvío en la auditoría del sistema

```json
{
  "status": "success",
  "datos": {
    "guid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "mensaje": "Código OTP reenviado exitosamente a los canales registrados.",
    "canales_envio": ["SMS", "Email", "WhatsApp"],
    "vigencia_otp": "3 minutos",
    "intentos_disponibles": 3,
    "reenvios_restantes": 3
  }
}
```

--- 


### 📤 Ejemplos de Respuestas

### ✅ Reenvío Exitoso

```json
{
  "status": "success",
  "datos": {
    "guid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "mensaje": "Código OTP reenviado exitosamente a los canales registrados.",
    "canales_envio": ["SMS", "Email", "WhatsApp"],
    "vigencia_otp": "5 minutos",
    "intentos_disponibles": 3,
    "reenvios_restantes": 3,
    "timestamp": "2025-10-07T14:25:30Z"
  }
}
```
---

### ❗ Campo Faltante

```json
{
  "status": "error",
  "errors": [
    "El campo guid es obligatorio.",
    "El campo identificacion es obligatorio."
  ]
}
```
---
### 🔍 Transacción No Encontrada

```json
{
  "status": "error",
  "mensaje": "Transacción no encontrada o inválida.",
  "guid": "invalid-uuid-12345"
}
```
---

### 🚫 Identificación No Coincide

```json
{
  "status": "error",
  "mensaje": "La identificación no corresponde a esta transacción.",
  "guid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
}
```
---
### ✔️ Transacción Ya Completada

```json
{
  "status": "error",
  "mensaje": "Esta transacción ya ha sido completada exitosamente. No es necesario un nuevo código.",
  "fecha_completado": "2025-10-07T13:45:20Z"
}
```
---
### ⏱️ Tiempo de Espera No Cumplido

```json
{
  "status": "error",
  "mensaje": "Debes esperar 42 segundos antes de solicitar un nuevo código.",
  "tiempo_espera_minimo": "60 segundos",
  "segundos_restantes": 42,
  "ultimo_envio": "2025-10-07T14:24:30Z"
}
```
---
### 🚨 Límite de Reenvíos Excedido

```json
{
  "status": "error",
  "mensaje": "Has excedido el número máximo de reenvíos permitidos. Por favor, contacta a soporte.",
  "reenvios_maximos": 5,
  "reenvios_realizados": 5,
  "contacto_soporte": "soporte@teseo-sygma.com"
}
```
---

### ❗ Error de Autenticación

```json
{
  "status": "error",
  "mensaje": "Token de autorización inválido o ausente."
}
```

