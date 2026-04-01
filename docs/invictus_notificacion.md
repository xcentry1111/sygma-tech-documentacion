# Notificación por canal

## Resumen
Envía notificaciones a los canales seleccionados del cliente usando datos ya registrados (celular/email). Cada canal se activa con `1` (enviar) o `0` (ignorar). Solo se permite enviar una vez; para reintentos se debe usar el servicio de reenvío OTP correspondiente.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/notificacion_canal`
- **Ambientes**:
  - **Pruebas**: `https://testing-sygma.com/api/notificacion_canal`
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

#### Campos obligatorios

Los siguientes campos son **requeridos** para procesar correctamente la notificación:

- `guid`
- `sms`
- `email`
- `whatsapp`
---

## 🔢 Cuerpo de la Solicitud (JSON)

- **Identificación del destinatario** *(uno de)*:
  - `guid`
- **Selección de canales** (enteros 0/1):
  - `sms`, `email`, `whatsapp`  
  > Debe haber **al menos uno** en `1`.

#### 🎛️ Reglas rápidas
- `sms=1` → requiere **celular** registrado.  
- `whatsapp=1` → usa **celular** registrado.  
- `email=1` → requiere **email** registrado.  

---

## 📦 Ejemplo de Body

```json
{
  "guid": "68406a6a2d9aa64766060ee2",
  "sms": 1,
  "email": 1,
  "whatsapp": 0
}
```

### 📊 Tabla de Canales

| Campo      | Tipo | Valores | Usa dato guardado |
|------------|------|---------|-------------------|
| `sms`      | int  | 0 / 1   | `celular`         |
| `email`    | int  | 0 / 1   | `email`           |
| `whatsapp` | int  | 0 / 1   | `celular`         |

### ✅ Respuestas Exitosa

```json
{
  "status": "success",
  "mensaje": "Notificaciones Envidados con Exito.",
  "canales_enviados": ["sms", "email"],
  "guid": "2yu2yg33i3iuy3i"
}
```

#### ❗ Error de validación

```json
{
  "status": "error",
  "errors": [
    "Debes seleccionar almenos un canal SMS , Email o Whatsapp"
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

#### ❗ Ejemplo de Error

```json
{
  "status": "error",
  "mensaje": "Transacción no encontrada o no válida para reenvío"
}
```
