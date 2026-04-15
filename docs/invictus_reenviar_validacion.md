# Reenvío de OTP (originación / validación)

## Resumen
Reenvía el código OTP a un usuario con transacción activa. Requiere token válido y el identificador de la transacción. Cada transacción permite máximo **3** reenvíos; si se excede, se debe reiniciar el proceso.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/reenviar_otp`
- **Ambientes**:
  - **Pruebas**: `https://testing-sygma.com/api/reenviar_otp`
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

Debe enviarse un objeto JSON con el identificador de la transacción.

### 🔸 Campos Obligatorios

- `guid`: ID único de la transacción al cual se debe asociar el reenvío del OTP.

---

## 📦 Ejemplo de Body

```json
{
  "guid": "2yu2yg33i3iuy3i"
}
```

#### ✅ Respuesta Exitosa

```json
{
  "status": "success",
  "mensaje": "OTP reenviado exitosamente.",
  "canales_enviados": [
    "sms",
    "email"
  ],
  "reenvios_restantes": 0,
  "timestamp": "2026-04-15T19:38:57Z"
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

