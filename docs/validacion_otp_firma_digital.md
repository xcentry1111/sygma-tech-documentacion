# Validación de OTP (firma digital)

## Resumen
Valida el OTP ingresado por el usuario y verifica su correspondencia con la transacción. Si el OTP es correcto, autoriza el uso del crédito y envía documentación a los canales seleccionados.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/validacion_otp_firma`
- **Ambientes**:
  - **Pruebas**: `https://testing-sygma.com/api/validacion_otp_firma`
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

### Campos Obligatorios

| Campo | Tipo | Descripción                                                                     |
|-------|------|---------------------------------------------------------------------------------|
| `guid` | string (UUID) | ID único de la transacción generada en el servicio de validación de firma digital |
| `codigo_otp` | string | Código OTP de 6 dígitos ingresado por el usuario                                |
| `tiempo_vigencia` | string | Este tiempo de vigencia del otp es parametrizable y es en minutos               |


### Ejemplo de Body

```json
{
  "guid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "codigo_otp": "123456",
  "tiempo_vigencia": "5"
}
```

---

## Flujo de Validación del Servicio

El servicio ejecuta las siguientes validaciones en orden:

### 1. Validación de Transacción

Se verifica que el `guid` exista en el sistema y esté activo.

### 2. Validación de Vigencia del OTP

Se verifica que el código OTP no haya expirado (vigencia de 5 minutos desde su generación).

### 3. Validación del Código OTP

Se compara el código ingresado con el código generado para la transacción.

#### ❌ Si el código OTP es incorrecto

**Acciones del sistema:**

- Se registra el intento fallido
- Se valida el número de intentos (máximo 3)
- Si se superan los 3 intentos, se invalida el OTP y se debe solicitar uno nuevo

**Respuesta a Invictus:**
```json
{
  "status": false,
  "mensaje": "El código ingresado es incorrecto.",
  "intentos_restantes": 2
}
```

#### ✅ Si el código OTP es correcto

**Acciones automáticas del sistema:**

1. Se marca la transacción como completada
2. Se habilita el crédito para uso del cliente
3. Se generan los documentos legales:
   - **Instrumento de Crédito**
   - **Plan de Pagos**
   - **Solicitud de Crédito**
4. Se envían los documentos a los canales seleccionados por el usuario:
   - Email
   - SMS (enlace de descarga)
   - WhatsApp (si fue seleccionado)
5. Se envía notificación al usuario: **"Ya puedes hacer uso de tu crédito"**

**Respuesta a Invictus:**
```json
{
  "status": true,
  "mensaje": "Ya puedes hacer uso de tu crédito",
  "nombre_cliente": "Andres Felipe Pelaez",
  "nombre_cliente": "Andres Felipe Pelaez",
  "celular": "3016795087",
  "email": "prueba@gmail.com"
}
```

---

## Tabla de Validaciones y Respuestas

| # | Condición | HTTP | status | mensaje                                                                 | Acciones |
|---|-----------|------|--------|-------------------------------------------------------------------------|----------|
| 1 | OTP correcto | 200 | `true` | "Ya puedes hacer uso de tu crédito"                                     | Habilitar crédito + Generar y enviar documentos |
| 2 | OTP incorrecto | 200 | `false` | "El código ingresado es incorrecto."                                    | Registrar intento fallido |
| 3 | OTP expirado | 200 | `false` | "El código OTP ha expirado. Solicita uno nuevo."                        | Invalidar OTP |
| 4 | Intentos agotados | 200 | `false` | "Has superado el número máximo de intentos. Solicita un nuevo código. " | Invalidar OTP |
| 5 | Transacción no encontrada | 404 | `false` | "Transacción no encontrada o inválida."                                 | Ninguna |
| 6 | Campos requeridos faltantes | 400 | `false` | "El campo {campo} es obligatorio."                                      | Ninguna |
| 7 | Token inválido o ausente | 401 | `false` | "Token de autorización inválido o ausente."                             | Ninguna |

---

## Ejemplos de Respuestas

### ✅ Validación Exitosa - OTP Correcto

```json
{
  "status": true,
  "mensaje": "Ya puedes hacer uso de tu crédito",
  "guid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "nombre_cliente": "Andres Felipe Pelaez",
  "celular": "3016795087",
  "email": "prueba@gmail.com"
}
```

### ❌ OTP Incorrecto

```json
{
  "status": false,
  "mensaje": "El código ingresado es incorrecto.",
  "intentos_restantes": 2,
  "guid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890"
}
```

### ⏰ OTP Expirado

```json
{
  "status": false,
  "mensaje": "El código OTP ha expirado. Solicita uno nuevo.",
  "tiempo_expiracion": "5 minutos",
  "fecha_generacion": "2025-10-04T14:20:00Z"
}
```

### 🚫 Intentos Agotados

```json
{
  "status": false,
  "mensaje": "Has superado el número máximo de intentos. Solicita un nuevo código.",
  "intentos_maximos": 3,
  "intentos_realizados": 3
}
```

### ❗ Transacción No Encontrada

```json
{
  "status": false,
  "mensaje": "Transacción no encontrada o inválida.",
  "guid": "invalid-uuid"
}
```

### ❗ Error por Campo Faltante

```json
{
  "status": false,
  "errors": [
    "El campo codigo_otp es obligatorio."
  ]
}
```

### ❗ Error de Autenticación

```json
{
  "status": false,
  "mensaje": "Token de autorización inválido o ausente."
}
```

---

## Documentos Generados

El sistema genera automáticamente los siguientes documentos en formato PDF al validar correctamente el OTP:

### 1. Instrumento de Crédito

Documento legal que formaliza las condiciones del crédito otorgado.

**Características:**
- Formato: PDF
- Nomenclatura: `Instrumento_Credito_{identificacion}.pdf`
- Firmado digitalmente por TESEO

### 2. Plan de Pagos

Cronograma detallado de pagos del crédito.

**Características:**
- Formato: PDF
- Nomenclatura: `Plan_Pagos_{identificacion}.pdf`
- Incluye: fechas, montos, intereses y capital

### 3. Solicitud de Crédito

Documento con la información completa de la solicitud aprobada.

**Características:**
- Formato: PDF
- Nomenclatura: `Solicitud_Credito_{identificacion}.pdf`
- Datos completos del solicitante y crédito aprobado

---

## Canales de Envío de Documentos

Los documentos se envían a los canales que el usuario seleccionó previamente en su solicitud inicial:

### Email

- Adjuntos: Los 3 documentos en PDF
- Asunto: "Documentos de tu Crédito Aprobado - TESEO"
- Cuerpo: Mensaje de bienvenida con instrucciones

### SMS

- Contenido: Mensaje con enlace de descarga de documentos
- Texto: "Tu crédito ha sido habilitado. Descarga tus documentos aquí: [URL]"

### WhatsApp

- Tipo: Mensaje con archivos adjuntos
- Contenido: Los 3 documentos PDF + mensaje de confirmación

!!! warning "Confirmación de Envío"
    El sistema debe confirmar el envío exitoso a cada canal y registrar cualquier fallo para reintento posterior.

---

## Consideraciones de Seguridad

### Código OTP

- **Vigencia:** 5 minutos desde su generación
- **Longitud:** 6 dígitos numéricos
- **Intentos máximos:** 3 intentos fallidos
- **Acción post-expiración:** El usuario debe solicitar un nuevo código

### Validación de Transacción

- Cada `guid` debe ser único y no reutilizable
- Una vez validado correctamente, el OTP se invalida automáticamente
- Las transacciones expiradas deben eliminarse del sistema

### Almacenamiento de Documentos

- Los documentos generados deben almacenarse de forma segura
- URLs de descarga con tokens temporales de acceso
- Período de disponibilidad: 30 días desde la generación
- Encriptación en tránsito y reposo

### Registro de Auditoría

Cada validación debe registrar:

- Timestamp de la solicitud
- IP del cliente
- Resultado de la validación
- Número de intentos
- Documentos generados y enviados
- Canales de envío utilizados

---

