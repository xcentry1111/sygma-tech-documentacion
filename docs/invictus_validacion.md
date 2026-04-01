# Validación de OTP + evaluación Experian (Invictus)

## Resumen
Valida un OTP asociado a una transacción. Si el OTP es válido, el sistema obtiene información del cliente por `guid` y consulta **Experian** para determinar el estado (**APROBADO**, **RECHAZADO**, **REQUIERE_VERIFICACION**, **SOLICITUD_CON_ERROR**, etc.).

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/validar_otp`
- **Ambientes**:
  - **Pruebas**: `https://testing-sygma.com/api/validar_otp`
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

### 🔸 Campos Obligatorios

- `otp`: Código OTP recibido por el cliente.
- `guid`: ID único de la transacción (internamente vinculado al cliente).

> ⚠️ **Nota:** No es necesario enviar el número de documento, ya que el sistema lo obtiene automáticamente con el `guid`.

---

## 📦 Ejemplo de Body

```json
{
  "otp": "462019",
  "guid": "68406a6a2d9aa64766060ee2"
}
```

### Primera Validacion

Consultar Listas Negras y Blancas
Consideraciones: 

1. Listas negras, en caso de estar de inmediato se entrega la respuesta de RECHAZADO.
2. Listas Blancas, en caso de estar de inmediato se marca como aprobado y no hay necesidad de consultar Experiam.
3. Si no esta en ninguna de las listas, sigue el flujo sin problema 

### ❗ Respuesta Exitosa Lista Negra

```js
{
  "status": "success",
  "mensaje": "OTP válido.",
  "experian_status": null,
  "detalle": "Solicitud rechazada."
}

```

### ✅ Respuesta Exitosa Lista Blanca

```js
{
  "status": "success",
  "mensaje": "OTP válido.",
  "experian_status": null,
  "detalle": "El usuario tiene buen perfil crediticio."
}

```

## 🧩 Decisión de **Expiriam** (Estados y Flujos)

El proceso de originación consume una decisión de **Expiriam** y TESEO actúa según el **estado** recibido.  
Estados posibles (valor devuelto en la respuesta exitosa):  
APROBADO · RECHAZADO · REQUIERE_VERIFICACION · SOLICITUD_CON_ERROR

---

### 📊 Tabla de estados

| Estado              | Significado breve                                                     | Acción TESEO                                                                                         |
|---------------------|------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------|
| **APROBADO**        | Cumple todas las políticas de crédito                                 | Enviar SMS/correo al usuario informando aprobación. Dirigir al punto Gana para firma.                |
| **RECHAZADO**       | No cumple políticas                                                    | Registrar rechazo. Bloquear nueva solicitud por **30 días**. A los 30 días sin cambios → **caducado*** |
| **REQUIERE_VERIFICACION** | Cumple políticas, pero Expiriam exige validación de identidad (alerta) | Enviar **OTP** y **enlace de verificación** provisto por Expiriam. Esperar resultado (webhook o polling). |
| **SOLICITUD_CON_ERROR** | Error técnico o inconsistencias en la petición a Expiriam              | Registrar error, NO enviar OTP. Devolver detalle en errors.                                         |

---

### 🔁 Flujo detallado por estado

- **APROBADO**
  - TESEO marca la solicitud como aprobada despues de la respuesta dada.
  - Envía notificaciones (SMS/correo) al usuario informadole que su credito ha sido aprobado.
  - Al ser aprobado el sistema entrega tres parametros adicionales que son **linea_credito**,  **valor_aprobado** y **linea_credito_id**, donde se le informa al usuario cuanto fue el monto aprobado y la linea de credito.
  - El campo **linea_credito_id** es el identificador de la linea de credito se le reporto.

- **RECHAZADO**
  - TESEO guarda el rechazo y bloquea re-solicitud por **30 días**.
  - Si el usuario reintenta antes, responder “debe esperar 30 días”.
  - Transcurridos 30 días sin novedades, la solicitud pasa a **caducado** (interno).

- **EN_VERIFICACION**
  - TESEO envía **OTP** y **link de verificación** (entregado por Expiriam) al celular/correo del usuario.
  - El usuario completa la verificación desde su **celular**.
  - TESEO obtiene el resultado **por webhook** (preferido) o por **consulta periódica** (polling).
  - Resultado final tras verificación:
    - **Aprobado** → notificar aprobación y dirigir a punto Gana.
    - **Rechazado** → aplicar reglas de rechazo (bloqueo 30 días).

- **SOLICITUD_CON_ERROR**
  - TESEO no realiza validaciones de identidad.
  - Devuelve detalles del error en la respuesta y registra logs para soporte.

---

### ✅ Respuesta Exitosa

```js
{
  "status": "success",
  "mensaje": "OTP válido. Evaluación Experian exitosa.",
  "experian_status": "APROBADO",
  "detalle": "El usuario tiene buen perfil crediticio.",
  "linea_credito_id": 100,        
  "linea_credito": "Credito Rotativo",
  "valor_aprobado": 300000, 
  "guid": "68406a6a2d9aa64766060ee2"        
}

```

### ✅ Respuesta En Verificación

```js
{
  "status": "success",
  "mensaje": "OTP válido. Evaluación Experian exitosa.",
  "experian_status": "EN_VERIFICACION",
  "detalle": "Validación de identidad requerida."
}
```

### ❗ Respuesta Rechazado por Experian

```js
{
  "status": "success",
  "mensaje": "OTP válido. Evaluación Experian exitosa.",
  "experian_status": "RECHAZADO",
  "detalle": "Solicitud rechazada. Podrá reintentar en 30 días.."
}
```

#### ❗ Respuesta Solicitud Error

```json
{
  "status": "error",
  "mensaje": "No fue posible obtener la decisión del proveedor."
}
```

#### ❗ Ejemplo de OTP Inválido

```json
{
  "status": "error",
  "mensaje": "OTP incorrecto o expirado"
}
```

#### ❗ Ejemplo de Error por Token Ausente o Inválido

```json
{
  "status": "error",
  "mensaje": "Token de autorización inválido o ausente"
}
```

#### ❗ Ejemplo de OTP Inválido

```json
{
  "status": "error",
  "mensaje": "OTP válido."
}
```
