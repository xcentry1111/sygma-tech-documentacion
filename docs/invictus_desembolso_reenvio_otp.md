
# 📘 Manual de Integración API: Reenvío de Código OTP para Desembolso

## Descripción del Servicio

Este servicio permite reenviar un nuevo código OTP al cliente cuando el código anterior ha expirado, se han agotado los intentos de validación, o el cliente no ha recibido el código inicial. El servicio controla el tiempo mínimo entre reenvíos y gestiona la invalidación de códigos anteriores.

---

## Tipo de Servicio

**Método HTTP:** `POST`

---

## URL de Integración

| Ambiente | URL |
|----------|-----|
| **Pruebas** | `https://testing-sygma.com/api/reenvio_otp_desembolso` |
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
| `guid` | string | UUID de la transacción original (opcional si es primer reenvío) |

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
  "guid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
}
```

---

## Flujo de Validación del Servicio

El servicio ejecuta las siguientes validaciones en orden:

### 1. Validación de Crédito Aprobado Vigente

Se verifica que el cliente tenga un crédito aprobado y vigente (dentro del plazo de 30 días).

#### ❌ Si NO hay crédito vigente

**Respuesta:**
```json
{
  "status": "no_credit",
  "mensaje": "No se encontró un crédito vigente para esta identificación."
}
```

### 2. Validación de Tiempo Mínimo entre Reenvíos

El sistema valida que haya transcurrido al menos **1 minuto** desde el último envío de OTP. Esta restricción evita spam y abuso del servicio.

#### ⏰ Si NO ha pasado el tiempo mínimo

**Respuesta:**
```json
{
  "status": "wait_required",
  "mensaje": "Debe esperar 1 minuto desde el último envío antes de solicitar un nuevo código.",
  "tiempo_transcurrido": "30 segundos",
  "tiempo_restante": "30 segundos"
}
```

### 3. Validación de Transacción Anterior

Si se proporciona un `guid`, se verifica su existencia y estado.

#### ℹ️ Si la transacción ya fue validada exitosamente

**Respuesta:**
```json
{
  "status": "already_validated",
  "mensaje": "Esta transacción ya fue validada correctamente. No es necesario reenviar el código."
}
```

### 4. Invalidación de Códigos Anteriores

Antes de generar el nuevo OTP, se invalidan todos los códigos OTP anteriores asociados a esta identificación.

**Acciones automáticas:**
- Invalidación de OTP anterior
- Reinicio del contador de intentos
- Generación de nuevo `guid`

### 5. Generación y Envío de Nuevo OTP

Se genera un nuevo código OTP de 6 dígitos y se envía a los canales registrados por el cliente.

**Acciones automáticas:**
- Generación de nuevo código OTP de 6 dígitos
- Generación de nuevo `guid` (UUID)
- Envío del código a los canales seleccionados:
  - SMS
  - Correo electrónico
  - WhatsApp (si fue configurado)
- Registro del envío con timestamp

**Respuesta Success:**
```json
{
  "status": "success",
  "datos": {
    "guid": "b2c3d4e5-f6g7-8901-bcde-fg2345678901",
    "mensaje": "Nuevo código OTP enviado exitosamente a los canales registrados.",
    "canales_envio": ["SMS", "Email", "WhatsApp"],
    "vigencia_otp": "53 minutos",
    "intentos_disponibles": 3,
    "fecha_envio": "2025-10-10 14:35:20"
  }
}
```

---

## Tabla de Validaciones y Respuestas

| # | Condición | HTTP | status | message | Acciones |
|---|-----------|------|--------|---------|----------|
| 1 | No hay crédito vigente | 200 | `no_credit` | "No se encontró un crédito vigente para esta identificación." | Ninguna |
| 2 | Tiempo mínimo no cumplido (<1 min) | 200 | `wait_required` | "Debe esperar 1 minuto desde el último envío." | Ninguna |
| 3 | Transacción ya validada | 200 | `already_validated` | "Esta transacción ya fue validada correctamente." | Ninguna |
| 4 | Reenvío exitoso | 200 | `success` | "Nuevo código OTP enviado exitosamente." | Generación y envío de nuevo OTP |
| 5 | Error en campos requeridos | 400 | `error` | "El campo {campo} es obligatorio." | Ninguna |
| 6 | Token inválido o ausente | 401 | `error` | "Token de autorización inválido o ausente." | Ninguna |
| 7 | Error en envío de mensajes | 500 | `error` | "Error al enviar el código OTP. Intente nuevamente." | Log de error para revisión |

---

## Ejemplos de Respuestas

### ✅ Respuesta Exitosa - Nuevo OTP Enviado

```json
{
  "status": "success",
  "datos": {
    "guid": "b2c3d4e5-f6g7-8901-bcde-fg2345678901",
    "mensaje": "Nuevo código OTP enviado exitosamente a los canales registrados.",
    "canales_envio": ["SMS", "Email", "WhatsApp"],
    "vigencia_otp": "3 minutos",
    "intentos_disponibles": 3,
    "fecha_envio": "2025-10-10 14:35:20"
  }
}
```

### ⏰ Debe Esperar Tiempo Mínimo

```json
{
  "status": "wait_required",
  "mensaje": "Debe esperar 1 minuto desde el último envío antes de solicitar un nuevo código.",
  "tiempo_transcurrido": "30 segundos",
  "tiempo_restante": "30 segundos",
  "proximo_envio_disponible": "2025-10-10 14:36:00"
}
```

### ❌ Sin Crédito Vigente

```json
{
  "status": "no_credit",
  "mensaje": "No se encontró un crédito vigente para esta identificación.",
  "razon": "El crédito ha vencido o ya fue desembolsado"
}
```

### ℹ️ Transacción Ya Validada

```json
{
  "status": "already_validated",
  "mensaje": "Esta transacción ya fue validada correctamente. No es necesario reenviar el código.",
  "fecha_validacion": "2025-10-10 14:30:00"
}
```

### ❗ Error en Envío de Mensajes

```json
{
  "status": "error",
  "mensaje": "Error al enviar el código OTP. Intente nuevamente en unos momentos.",
  "error_tecnico": "SMS gateway timeout"
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

### Control de Reenvíos

- **Tiempo mínimo entre reenvíos:** 1 minuto (60 segundos) - **parametrizable**
- **Propósito:** Evitar spam y ataques de denegación de servicio
- **Cálculo:** Se considera desde el timestamp del último envío exitoso

### Invalidación de Códigos

- Al generar un nuevo OTP, **todos los códigos anteriores** se invalidan automáticamente
- Solo el código más reciente es válido para su validación
- Los intentos fallidos de códigos anteriores no afectan el nuevo código

### Nuevo Código OTP

- **Vigencia:** 5 minutos desde su generación
- **Longitud:** 6 dígitos numéricos
- **Intentos:** 3 intentos máximo (se reinicia el contador)
- **Unicidad:** Cada reenvío genera un código completamente nuevo

### Límites de Reenvío

Aunque el sistema valida el tiempo mínimo, se recomienda implementar límites adicionales:

- **Máximo de reenvíos por hora:** 5 reenvíos (sugerido, parametrizable)
- **Bloqueo temporal:** Después de 10 reenvíos, bloqueo de 1 hora
- **Alertas:** Notificar al equipo de seguridad ante patrones sospechosos

### Registro de Auditoría

- Cada reenvío queda registrado con timestamp y nuevo `guid`
- Se almacena: usuario, IP de origen, canal de envío, estado del envío
- Trazabilidad completa para auditorías y detección de fraude

---

## Parámetros Configurables

Los siguientes valores pueden configurarse en el sistema:

| Parámetro | Valor por Defecto | Descripción |
|-----------|-------------------|-------------|
| Tiempo mínimo entre reenvíos | 60 segundos (1 minuto) | Tiempo de espera obligatorio |
| Vigencia del OTP | 5 minutos | Tiempo de validez del código |
| Intentos de validación | 3 intentos | Número máximo de intentos por OTP |
| Reenvíos máximos por hora | 5 reenvíos | Límite de seguridad |

---

## Flujo de Integración

!!! "Secuencia de Uso"
    1. **Cliente no recibe OTP inicial** o el código expira
    2. **Punto Gana invoca este servicio** para reenviar código
    3. **Sistema valida** tiempo mínimo y estado del crédito
    4. **Se genera nuevo OTP** y se envía a los canales
    5. **Cliente recibe nuevo código** y lo ingresa en el sistema
    6. **Se valida el nuevo OTP** con el servicio de validación

---
```

---

## Notas Importantes

- El `guid` generado en el reenvío es **diferente** al original
- Cada reenvío invalida **todos los códigos anteriores** de esa identificación
- El contador de intentos se **reinicia a cero** con cada nuevo código
- El tiempo de espera de 1 minuto se calcula desde el **último envío exitoso**
- Los canales de envío (SMS, Email, WhatsApp) son los mismos configurados inicialmente
- Si hay fallas en el envío a algún canal, se registra pero no se bloquea el proceso
- Este servicio puede invocarse sin `guid` si es la primera vez
- El punto Gana debe almacenar el nuevo `guid` para la validación posterior
