# 📘 Manual de Integración API: **Notificación por Canal**

## 📄 Descripción del Servicio
Servicio para **enviar notificaciones** al/los canales seleccionados del cliente usando datos **ya registrados** (celular/email).  
Cada canal se activa con **1** (enviar) o **0** (ignorar).  
Ejemplo: `sms=1`, `email=1`, `whatsapp=0` → se envía por **SMS** y **Email**.

**Nota:** Solo se permite enviar una sola vez a los canales seleccionados, en caso de reenviar se debe de consumir el servicio de Reenvio OTP

---

## 🚀 Tipo de Servicio
`POST`

---

## 🔗 URL de Integración
- **Ambiente de Pruebas:** `http://testing-sygma.com/api/notificacion_canal`  
- **Producción:** `POR DEFINIR`

---

## 📉 Headers Requeridos

| Nombre          | Valor            | Requerido |
|-----------------|------------------|-----------|
| Authorization   | Bearer `{token}` | ✅         |
| Accept          | application/json | ✅         |
| Content-Type    | application/json | ✅         |

> 🔐 **Nota:** El token se obtiene a través del módulo de autenticación.

### 🔸 Campos Obligatorios

Los siguientes campos son **requeridos** para procesar correctamente la notificación:

- `transaccion_id`
- `sms`
- `email`
- `whatsapp`
---

## 🔢 Cuerpo de la Solicitud (JSON)

- **Identificación del destinatario** *(uno de)*:
  - `transaccion_id`
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
  "transaccion_id": "68406a6a2d9aa64766060ee2",
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
  "transaccion_id": "2yu2yg33i3iuy3i"
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

