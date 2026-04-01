# Importación de datos de originación (Invictus)

## Resumen
Recibe y valida información proveniente de Invictus para crear/registrar un usuario y retornar una respuesta de registro en **TESEO**.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/ori_invictus`
- **Ambientes**:
  - **Pruebas**: `https://testing-sygma.com/api/ori_invictus`
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

La solicitud debe enviarse en formato `raw` JSON con los campos dentro de la clave `datos`.

### 🔸 Campos Obligatorios

Los siguientes campos son **requeridos** para procesar correctamente la solicitud:

- `tiposdocumento_id`
- `identificacion`
- `fecha_expedicion`
- `codigo_expedicion`
- `primer_nombre`
- `segundo_nombre`
- `primer_apellido`
- `segundo_apellido`
- `fecha_nacimiento`
- `email`
- `celular`
- `nombre_red`
- `oficina`
- `nombre_oficina`
- `usuario_transaccion`
- `nombre_usuario_transaccion`

---

### 🔸 Valores Permitidos

#### `tiposdocumento_id` (Tipo de Documento)

| ID  | Descripción                |
|-----|----------------------------|
| 1   | Cédula de ciudadanía (CC)  |
| 2   | Cédula de extranjería (CE) |
| 3   | NIT                        |
| 8   | Pasaporte (PA)             |
| 181 | Permiso Especial (PEP)     |

---

## 📦 Ejemplo de Body

```json
{
  "datos": {
    "tiposdocumento_id": "1",
    "identificacion": "88282828",
    "fecha_expedicion": "1984-07-12",
    "codigo_expedicion": "27001",
    "primer_nombre": "MATURANA",
    "segundo_nombre": "MARTINEZ",
    "primer_apellido": "MARIO",
    "segundo_apellido": "MARIO",
    "fecha_nacimiento": "1988-05-15",
    "email": "PRUEBA@GMAIL.COM",
    "celular": "3016795090",
    "nombre_red": "PRUEBA DEL SERVICIO",
    "oficina": "OFICINA NRO 1",
    "nombre_oficina": "OFICINA NRO 1 - LAURELES",
    "usuario_transaccion": "ANDRES FELIPE PRUEBA",
    "nombre_usuario_transaccion": "ANDRES FELIPE PRUEBA"
  }
}

```
----
### Validaciones

| Regla | Condición | HTTP | `status` | `message` |
|---|---|---:|---|---|
| 1. Crédito existente y datos coinciden | Existe crédito y **correo/celular** coinciden | 200 | success | "Datos coinciden. Continúa el flujo." |
| 2. Conflicto de identidad | Correo o celular ya existen pero con **otra cédula** | 409 | blocked | "El {correo\|celular} ya está registrado para otra identificación." |
| 3. Rechazo reciente (<30 días) | Última solicitud **rechazada** hace <30 días | 423 | blocked | "Te faltan {dias_restantes} día(s) para volver a solicitar." |
| 4. Aprobada pendiente de firma | Existe solicitud **aprobada** sin firma | 409 | action_required | "Tienes una solicitud aprobada. Completa el proceso de firma." |
| 5. KYC pendiente | Estado requiere **verificación de identidad** | 202 | action_required | "Requiere verificación de identidad." |



#### ✅ Respuesta Exitosa

```json
{
  "status": "success",
  "datos": {
    "guid": "2yu2yg33i3iuy3i",
    "mensaje": "Registro exitoso - Se ha enviado un correo electornico y mensaje de texto al usuario para su validación"
  }
}

```

#### ❗ Conflicto de identidad

```json
{
  "status": "error",
  "errors": [
    "El correo ya está registrado para otra identificación."
  ]
}
```


#### ❗ Rechazo reciente (<30 días)

```json

{
  "status": "error",
  "errors": [
    "Te faltan 12 día(s) para volver a realizar la solicitud"
  ]
}
```


#### ❗ Ejemplo de Error por Campo Faltante

```json
{
  "status": "error",
  "errors": [
    "El campo identificacion es obligatorio"
  ]
}
```

#### ❗ Ejemplo de Error por Token Ausente o Inválido

```json
{
  "status": "error",
  "mensaje": "Token de autorización inválido o ausente"
}
```

#### ✅ Aprobada pendiente de firma

```json
{
  "status": "success",
  "datos": {
    "mensaje": "Tienes una solicitud aprobada. Completa el proceso de firma."
  }
}

```

#### ✅ KYC pendiente

```json
{
  "status": "success",
  "datos": {
    "mensaje": "Requiere verificación de identidad. Se te acaba de enviar un mensaje a los diferentes canales SMS - EMAIL y WHATSAPP"
  }
}

```
