
# 📘 Manual de Integración API: Validación de Crédito Vigente para Desembolso

## Descripción del Servicio

Este servicio permite validar si una persona cuenta con un crédito aprobado. Verifica el estado del crédito, su vigencia (máximo 1 mes desde la aprobación).

---

## Tipo de Servicio

**Método HTTP:** `POST`

---

## URL de Integración

| Ambiente | URL |
|----------|-----|
| **Pruebas** | `https://testing-sygma.com/api/validacion_credito_vigente` |
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
  "identificacion": "88282828"
}
```

---

## Flujo de Validación del Servicio

El servicio ejecuta las siguientes validaciones en orden:

### 1. Búsqueda de Crédito Aprobado

Se consulta en el sistema si existe un crédito aprobado asociado al tipo de documento e identificación proporcionados.

#### ❌ Si NO existe crédito aprobado

**Respuesta:**
```json
{
  "status": "no_credit",
  "mensaje": "No se encontró un crédito aprobado para esta identificación."
}
```

### 2. Validación de Vigencia del Crédito

Si existe un crédito aprobado, se verifica que no haya superado el plazo de vigencia de **1 mes (30 días)** desde su aprobación.

#### ⏰ Si el crédito está vencido (>30 días)

El crédito pasa automáticamente a estado **"vencido"** y no puede ser utilizado.

**Acciones automáticas:**
- Actualización del estado del crédito a "vencido"
- Registro de la fecha de vencimiento

**Respuesta:**
```json
{
  "status": "expired",
  "mensaje": "El crédito aprobado ha vencido. El plazo de 1 mes para el retiro ha expirado, puedes volver a solicitar un credito.",
  "dias_transcurridos": 56
}
```

### 3. Crédito Vigente y Disponible

Si el crédito está dentro del plazo de vigencia (<30 días) y no ha sido desembolsado.

**Respuesta Success:**
```json
{
  "status": "success",
  "datos": {
     "guid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
     "codigo_otp": 202023,
     "canales_envio": ["SMS", "Email", "WhatsApp"],
     "mensaje": "Crédito validado con exito!!!."
  }
}
```

### 4. Crédito Ya Desembolsado

Si el crédito ya fue retirado/desembolsado previamente.

**Respuesta:**
```json
{
  "status": "already_disbursed",
  "mensaje": "Este crédito ya fue desembolsado anteriormente.",
  "fecha_desembolso": "2025-09-25"
}
```

---

## Tabla de Validaciones y Respuestas

| # | Condición | HTTP | status | message | Acciones |
|---|-----------|------|--------|---------|----------|
| 1 | No existe crédito aprobado | 200 | `no_credit` | "No se encontró un crédito aprobado para esta identificación." | Ninguna |
| 2 | Crédito vencido (>30 días) | 200 | `expired` | "El crédito aprobado ha vencido. El plazo de 1 mes para el retiro ha expirado." | Actualización de estado a "vencido" |
| 3 | Crédito vigente y disponible | 200 | `success` | "Crédito vigente y disponible para retiro en punto Gana." | Retorna información del crédito |
| 4 | Crédito ya desembolsado | 200 | `already_disbursed` | "Este crédito ya fue desembolsado anteriormente." | Ninguna |
| 5 | Error en campos requeridos | 400 | `error` | "El campo {campo} es obligatorio." | Ninguna |
| 6 | Token inválido o ausente | 401 | `error` | "Token de autorización inválido o ausente." | Ninguna |

---

## Ejemplos de Respuestas

### ✅ Respuesta Exitosa - Crédito Vigente

```json
{
  "status": "success",
  "datos": {
     "guid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
     "codigo_otp": 202023,
     "canales_envio": ["SMS", "Email", "WhatsApp"],
     "mensaje": "Crédito validado con exito!!!."
  }
}
```

### ❌ Sin Crédito Aprobado

```json
{
  "status": "no_credit",
  "mensaje": "No se encontró un crédito aprobado para esta identificación."
}
```

### ⏰ Crédito Vencido

```json
{
  "status": "expired",
  "mensaje": "El crédito aprobado ha vencido. El plazo de 1 mes para el retiro ha expirado, puedes volver a solicitar un credito.",
  "dias_transcurridos": 56
}
```

### 🔒 Crédito Ya Desembolsado

```json
{
  "status": "already_disbursed",
  "mensaje": "Este crédito ya fue desembolsado anteriormente.",
  "fecha_desembolso": "2025-09-25"
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
## Notas Importantes

- El mensaje SMS informativo al cliente se envía al momento de la aprobación del crédito, indicando que debe acercarse a un punto Gana
- Este servicio NO envía notificaciones, solo valida el estado
- La vigencia de 30 días es parametrizable en la configuración del sistema
- Para créditos vencidos, el cliente debe realizar una nueva solicitud
