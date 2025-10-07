# 📘 Manual de Integración API: **Reenvío de Código OTP**

## 📄 Descripción del Servicio

Este servicio permite **reenviar el código OTP ** a un usuario que ya cuenta con una transacción activa. Se debe autenticar usando un token válido y proporcionar el ID de la transacción.

Cada transacción cuenta con un maximo de 3 reenvios de ser asi, el sistema mostrara su mensaje de error y tendra que volver a iniciar el proceso.

---

## 🚀 Tipo de Servicio

`POST`

---

## 🔗 URL de Integración

- **Ambiente de Pruebas:** `https://testing-sygma.com/api/reenviar_otp`  
- **Producción:** `POR DEFINIR`

---

## 📉 Headers Requeridos

| Nombre        | Valor                | Requerido |
|---------------|----------------------|-----------|
| Authorization | Bearer `{token}`     | ✅         |
| Accept        | application/json     | ✅         |
| Content-Type  | application/json     | ✅         |

> 🔐 **Nota:** El token se obtiene desde el módulo de autenticación (ver pestaña **Token**) usando las credenciales asignadas por la entidad.

---

## 🔢 Cuerpo de la Solicitud (JSON)

Debe enviarse un objeto JSON con el identificador de la transacción.

### 🔸 Campos Obligatorios

- `transaccion_id`: ID único de la transacción al cual se debe asociar el reenvío del OTP.

---

## 📦 Ejemplo de Body

```json
{
  "transaccion_id": "2yu2yg33i3iuy3i"
}
```

#### ✅ Respuesta Exitosa

```json
{
  "status": "success",
  "mensaje": "OTP reenviado exitosamente al canal registrado"
}

```

#### ❗ Ejemplo de Error

```json
{
  "status": "error",
  "mensaje": "Transacción no encontrada o no válida para reenvío"
}

```

#### ❗  Error de Autenticación

```json
{
  "status": "error",
  "mensaje": "Token de autorización inválido o ausente"
}
```

#### ❗ Limite de envio (Solo se permite enviar maximo 3 veces el servicio)

```json
{
  "status": "error",
  "mensaje": "Límite de envío alcanzado."
}
```

