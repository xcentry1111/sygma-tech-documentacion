# API PQRS — Radicación y catálogos (Wsquejas)

## Resumen
Servicios JSON para autenticación JWT, consulta de catálogos del formulario Sistemcobro/JCAP y radicación de PQRS en **TESEO**, aplicables únicamente a usuarios con `portafolio_principal` **10025** (Sistemcobro) o **10050** (JCAP).

La radicación reutiliza `Quejas::RadicacionSistemcobroService` (misma lógica que `QuejasController#create` para contenedores).

## Endpoints

| Servicio | Método | Ruta |
|---|---|---|
| Generación de token | `POST` | `/api/wsquejas/generar_token` |
| Consulta de catálogos | `POST` | `/api/wsquejas/consulta_datos` |
| Radicación PQRS | `POST` | `/api/wsquejas/radicacion_quejas` |

### Ambientes
- **Pruebas**: `https://testing-sygma.com/api/wsquejas/...`
- **Producción**: `POR DEFINIR`

## Autenticación
- **Tipo**: `Bearer token` (JWT, misma firma que `/api/login` vía `AuthenticateUser`)
- **Header**: `Authorization: Bearer <token>`
- **Vigencia**: 1 hora

`generar_token` **no** requiere Authorization. `consulta_datos` y `radicacion_quejas` **sí**.

## Headers
- **Authorization**: `Bearer <token>` (obligatorio excepto `generar_token`)
- **Accept**: `application/json` (obligatorio)
- **Content-Type**: `application/json` (obligatorio; para adjuntos usar `multipart/form-data`)

---

## 1) Generación de token

### Endpoint
- **Método**: `POST`
- **Ruta**: `/api/wsquejas/generar_token`

### 🔸 Campos Obligatorios
- `username`
- `password`

### 📦 Ejemplo de Body

```json
{
  "username": "usuario.api",
  "password": "********"
}
```

#### ✅ Respuesta Exitosa

```json
{
  "status": "success",
  "datos": {
    "auth_token": "eyJhbGciOiJIUzI1NiJ9...",
    "token_type": "Bearer",
    "expires_at": "2026-07-21 12:11:00",
    "mensaje": "Generado con Exito"
  }
}
```

#### ❗ Credenciales inválidas

```json
{
  "status": "error",
  "errors": [
    "Credenciales no validas"
  ]
}
```

#### ❗ Campos faltantes

```json
{
  "status": "error",
  "errors": [
    "username y password son requeridos"
  ]
}
```

---

## 2) Consulta de catálogos (`consulta_datos`)

Devuelve `id` + `descripcion` según el catálogo solicitado y el `portafolio_id` del usuario autenticado (10025 o 10050).

### Endpoint
- **Método**: `POST`
- **Ruta**: `/api/wsquejas/consulta_datos`

### 🔸 Campos Obligatorios
- `dato`

### 🔸 Valores Permitidos de `dato`

| `dato` | Descripción | Filtros adicionales |
|---|---|---|
| `TIPIFICACION` | Tipo requerimiento (PQRS, TUTELA, ...) | — |
| `MOTIVO` | Motivos activos de la tipificación | `portafoliostipificacion_id` **obligatorio** |
| `SUBMOTIVO` | Submotivos activos del motivo | `portafoliostipimotivo_id` **obligatorio** |
| `PORTAFOLIO` | Portafolios PQRS del contenedor | `identificacion` (opcional; filtra por persona) |
| `MUNICIPIO` | Municipios Colombia | `q` (opcional; búsqueda por nombre) |
| `TIPO_DOCUMENTO` | Tipos documento del portafolio | — (`id` = código, ej. `C.C.`) |
| `FORMA_REGISTRO` | Medios de registro del formulario | — |
| `TIPO_REGISTRO` | PETICION, QUEJA, RECLAMO, ... | — |
| `SUCURSAL` | Sucursales JCAP | Solo **10050**. `identificacion` recomendado |

### 📦 Ejemplo de Body — Tipificaciones

```json
{
  "dato": "TIPIFICACION"
}
```

### 📦 Ejemplo de Body — Motivos

```json
{
  "dato": "MOTIVO",
  "filtros": {
    "portafoliostipificacion_id": 14
  }
}
```

### 📦 Ejemplo de Body — Portafolios por identificación

```json
{
  "dato": "PORTAFOLIO",
  "filtros": {
    "identificacion": "88282828"
  }
}
```

#### ✅ Respuesta Exitosa

```json
{
  "status": "success",
  "dato": "TIPIFICACION",
  "portafolio_principal": 10025,
  "total": 2,
  "datos": [
    { "id": 14, "descripcion": "PQRS" },
    { "id": 15, "descripcion": "TUTELA" }
  ]
}
```

#### ❗ Dato no soportado / filtro faltante

```json
{
  "status": "error",
  "errors": [
    "portafoliostipificacion_id es obligatorio para MOTIVO"
  ]
}
```

#### ❗ Token ausente o inválido

```json
{
  "status": "error",
  "mensaje": "Token de autorización inválido o ausente"
}
```

---

## 3) Radicación PQRS (`radicacion_quejas`)

Recibe los mismos campos del formulario `_sistemcobro.html.erb` y ejecuta el flujo de radicación (validaciones de modelo, área, vencimiento, consecutivo, notas, correo, PDF de radicado, asignación documental).

### Endpoint
- **Método**: `POST`
- **Ruta**: `/api/wsquejas/radicacion_quejas`

### 🔸 Campos Obligatorios

Los siguientes campos son **requeridos**:

- `documento`
- `identificacion`
- `nombre`
- `celular`
- `email`
- `tipo_registro`
- `forma_registro`
- `portafoliostipificacion_id`
- `portafoliostipimotivo_id`
- `portafoliostipimosubmotivo_id`
- `portafolio_id`
- `mensaje`
- `portafoliossucursal_id` (**solo** si usuario es 10050)

### 🔸 Campos Opcionales / Condicionales

- `direccion`
- `telefono`
- `municipio_id`
- `dia_vencimiento` / `hora_vencimiento` (obligatorios en UI cuando tipificación **no** es PQRS)
- `quejasimagen` (adjunto multipart; `multipart/form-data`)
- `documento_base64` (**opcional**) — mismo adjunto que `quejasimagen`, en Base64
- `documento_nombre` (opcional; ej. `soporte.pdf`)
- `documento_content_type` (opcional; ej. `application/pdf`)

Alias aceptados: `quejasimagen_base64`, `quejasimagen_nombre`, `quejasimagen_content_type`.

Si llega archivo multipart **y** base64, gana el multipart. Sin ninguno → radica sin adjunto.

#### Formatos de `documento_base64`

1. Raw Base64:
```text
JVBERi0xLjQK...
```

2. Data URI:
```text
data:application/pdf;base64,JVBERi0xLjQK...
```

Se guarda en `Queja#quejasimagen` (Paperclip), igual que el formulario web.

### 🔸 Valores Permitidos

#### `tipo_registro`

| Valor |
|---|
| PETICION |
| QUEJA |
| RECLAMO |
| SOLICITUD |
| SUGERENCIAS |
| FELICITACIONES |
| PROTECCION DATOS PERSONALES |
| TUTELA |
| SIC |
| SIF |

#### `forma_registro`

| Valor |
|---|
| FISICO |
| CORREO ELECTRONICO |
| RADICACION INTERNA |
| PORTAL WEB |

Los IDs de tipificación / motivo / submotivo / portafolio / municipio / sucursal se obtienen de `consulta_datos`.

---

## 📦 Ejemplo de Body

```json
{
  "datos": {
    "documento": "C.C.",
    "identificacion": "88282828",
    "nombre": "MARIO MATURANA MARTINEZ",
    "direccion": "CALLE 1 # 2-3",
    "telefono": "6041234567",
    "celular": "3016795090",
    "email": "PRUEBA@GMAIL.COM",
    "municipio_id": 1,
    "tipo_registro": "PETICION",
    "forma_registro": "PORTAL WEB",
    "portafoliostipificacion_id": 14,
    "portafoliostipimotivo_id": 100,
    "portafoliostipimosubmotivo_id": 200,
    "portafolio_id": 10066,
    "dia_vencimiento": 0,
    "hora_vencimiento": 0,
    "mensaje": "DESCRIPCION DE LA SOLICITUD",
    "documento_nombre": "soporte.pdf",
    "documento_content_type": "application/pdf",
    "documento_base64": "JVBERi0xLjQKJcfsj6IK..."
  }
}
```

También se acepta la clave `queja` (mismo shape) o campos en la raíz del JSON.

Para 10050 incluir:

```json
"portafoliossucursal_id": 10
```

----
### Validaciones

| Regla | Condición | HTTP | `status` | Mensaje |
|---|---|---:|---|---|
| 1. Token ausente/inválido | Sin Bearer o JWT inválido | 401 | error | "Token de autorización inválido o ausente" |
| 2. Token expirado | `exp` vencido | 401 | error | "Token Expirado" |
| 3. Portafolio no permitido | Usuario ≠ 10025/10050 | 403 | error | "Usuario no autorizado..." |
| 4. Campos faltantes | Obligatorios vacíos | 422 | error | "El campo {campo} es obligatorio" |
| 5. Validaciones de modelo | `Queja` inválida (duplicado PQRS abierto, email, etc.) | 422 | error | Mensajes de ActiveRecord |
| 6. Radicación OK | Persistencia + post-procesos | 201 | success | "PQRS Creado con exito." |

#### ✅ Respuesta Exitosa

```json
{
  "status": "success",
  "datos": {
    "id": 123456,
    "consecutivo": "98765",
    "tiquet": "98765",
    "estado": "VIGENTE",
    "portafolio_id": 10066,
    "portafolio_principal": 10025,
    "fecha_limite": "2026-08-11",
    "radicacion_dia_no_habil": false,
    "mensaje": "PQRS Creado con exito."
  }
}
```

#### ❗ Ejemplo de Error por Campo Faltante

```json
{
  "status": "error",
  "errors": [
    "El campo identificacion es obligatorio",
    "El campo mensaje es obligatorio"
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

#### ❗ Ejemplo de Error de validación de negocio

```json
{
  "status": "error",
  "errors": [
    "Identificación con un proceso PQRS abierto — Radicado 99887"
  ]
}
```

---

## Arquitectura (referencia interna)

| Pieza | Rol |
|---|---|
| `Api::WsquejasController` | Entrada HTTP delgada |
| `AuthenticateUser` | Emisión JWT (reuso) |
| `ApiJwtAuthenticatable` | Validación Bearer |
| `Quejas::CatalogoConsultaService` | Catálogos por `dato` |
| `Quejas::DocumentoBase64` | Decode base64 → UploadedFile Paperclip |
| `Quejas::RadicacionSistemcobroService` | Radicación 10025/10050 (UI + API) |
