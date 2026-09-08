# Autenticar Onboarding

## Resumen
Emite JWT (1 hora) para el catálogo Onboarding. Devuelve `user_id`, `username` y `portafolio_id` del usuario. Mismo comando `AuthenticateUser` que `POST /api/login`, **otro envelope**.

Mapa: [Flujo Onboarding](../flujo.md). Carpeta: [Originación](index.md). Equivalente Invictus: [Token TESEO](../../tecfinanzas_token.md).

## Objetivo
Identificar al consumidor API y su portafolio. Sin este paso no hay `simular` ni `informacion_basica`.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/onboarding/autenticar`
- **Controller**: `Api::OnboardingController#autenticar`
- **Ambientes**:
  - **Testing**: `https://testing-sygma.com/api/onboarding/autenticar`
  - **Producción**: `POR DEFINIR`

## Autenticación
No aplica. Este endpoint entrega el token. **No** enviar `Authorization`.

## Headers
- **Accept**: `application/json`
- **Content-Type**: `application/json`

## Request

### Body (JSON)

#### Campos
| Campo | Tipo | Requerido | Descripción |
|------|------|-----------|-------------|
| username | string | sí | Usuario TESEO (`User.find_for_authentication`). |
| password | string | sí | Contraseña Devise. |

#### Ejemplo
```json
{
  "username": "usuario.api",
  "password": "********"
}
```

## Proceso interno (orden real)

1. Si `username` o `password` en blanco → 422.
2. `User.find_for_authentication(username:)`.
3. `AuthenticateUser.call(username, password)` → JWT o `nil`.
4. Si no hay token → 401 (mismo mensaje para usuario inexistente y password mala).
5. Si hay token pero no hay `User` → 401 (defensa; no debería ocurrir).
6. `Onboarding::ConfiguracionPortafolio` con `user.portafolio_id` (mensaje OK parametrizable).
7. Responde token + metadatos. `expires_at` = ahora + 1 hora (formato `%Y-%m-%d %H:%M:%S`).

No escribe `Formulario`. No lee rangos de simulación.

## Servicios / componentes

- `AuthenticateUser` (mismo secreto `secret_key_base` que `/api/login`)
- `User`
- `Onboarding::ConfiguracionPortafolio` (mensaje `onboarding_msg_auth_ok` / `_error` / `_params`)

## Responses

### 200 OK
```json
{
  "status": "success",
  "datos": {
    "auth_token": "eyJhbGciOiJIUzI1NiJ9...",
    "token_type": "Bearer",
    "expires_at": "2026-09-08 16:37:00",
    "user_id": 12,
    "username": "usuario.api",
    "portafolio_id": 10053,
    "mensaje": "Autenticación exitosa."
  },
  "errors": []
}
```

**Siguiente:** header `Authorization: Bearer <auth_token>` en `simular` y/o `informacion_basica`.

Payload JWT: `{ user_id, exp }`. El `portafolio_id` **no** va en el JWT; se lee del `User` en cada request.

## Errores comunes

### 422 Unprocessable Entity (falta username o password)
```json
{
  "status": "error",
  "datos": {},
  "errors": ["username y password son requeridos"]
}
```

### 401 Unauthorized (credenciales)
```json
{
  "status": "error",
  "datos": {},
  "errors": ["Credenciales no validas"]
}
```

### 500 Internal Server Error
```json
{
  "status": "error",
  "datos": {},
  "errors": ["Error interno"]
}
```

## Flujo anterior
Ninguno.

## Flujo posterior
- `POST /api/onboarding/simular` (cotizar)
- `POST /api/onboarding/informacion_basica` (registrar)

## Notas / Consideraciones
- Texto de error/éxito puede cambiar si existen filas `parametros` `onboarding_msg_auth_*` del portafolio del usuario. Sin fila: defaults de `ConfiguracionPortafolio::MSG`.
- No usar este login para documentar Invictus. Invictus documenta `/api/login` (`status: true/false`, token en raíz).
- Token de Onboarding es un JWT TESEO válido. El contrato de producto es consumir solo `/api/onboarding/*`.

## Changelog
- **2026-09-08**: Alineado a `Api::OnboardingController#autenticar`.
