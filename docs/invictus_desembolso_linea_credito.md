# Seleccionar Líneas de Crédito - Desembolso Invictus

## Resumen
Retorna las líneas de crédito disponibles para la persona, validando que el OTP haya sido previamente validado. La información se obtiene desde la función Oracle `fnc_json_credintegral('INVICTUS', identificacion, tiposdocumento_id)`.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/seleccionar_linea_credito`
- **Ambientes**:
    - **Pruebas (QA)**: `https://testing-sygma.com/api/seleccionar_linea_credito`
    - **Producción**: `POR DEFINIR`

## Autenticación
- **Tipo**: `Bearer token`
- **Header**: `Authorization: Bearer <token>`
- **Obtención del token**: `POST https://testing-sygma.com/api/login`

## Headers

| Nombre | Valor | Requerido | Descripción |
|--------|-------|-----------|-------------|
| `Authorization` | `Bearer {token}` | ✅ | Token de autenticación JWT |
| `Accept` | `application/json` | ✅ | Formato de respuesta esperado |
| `Content-Type` | `application/json` | ✅ | Formato del cuerpo de la petición |

---

## Flujo del Proceso

```
Servicio 1: POST /api/validacion_credito_vigente
     ↓ (retorna guid + codigo_otp si success)
Servicio 2: POST /api/validacion_otp_desembolso
     ↓ (retorna success con guid validado)
Servicio 3 (opcional): POST /api/reenvio_otp_desembolso
     ↓
Servicio 4: POST /api/seleccionar_linea_credito  ← ESTAMOS AQUÍ
     ↓ (retorna nombre_cliente, identificacion, lineas_credito)
Sección 2: Datos Crédito en Invictus
     ↓ (usuario selecciona línea, ingresa plazo y valor)
Servicio 5: POST /api/proceso_desembolso
```

---

## Fuente de Datos

La información de líneas de crédito se obtiene ejecutando:

```sql
SELECT fnc_json_credintegral('INVICTUS', :identificacion, :tiposdocumento_id) FROM dual;
```

Esta función retorna las obligaciones rotativas activas de la persona
(`partiposproducto_id IN (11881, 11882, 11880)` con `obl_saldototaldeuda > 0`),
enriquecidas con los campos de cupo desde la tabla `personas`.

---

## Request

### Campos Obligatorios

| Campo | Tipo | Requerido | Descripción |
|-------|------|-----------|-------------|
| `guid` | string (UUID) | ✅ | UUID de la transacción generado en `validacion_credito_vigente` |
| `tiposdocumento_id` | string | ✅ | ID del tipo de documento según catálogo |
| `identificacion` | string | ✅ | Número de identificación del cliente |

### Catálogo de Tipos de Documento

| `tiposdocumento_id` | Descripción |
|---------------------|-------------|
| `1` | Cédula de ciudadanía (CC) |
| `2` | Cédula de extranjería (CE) |
| `3` | NIT |
| `8` | Pasaporte |
| `181` | Permiso Especial (PEP) |

### Ejemplo de Request

```json
{
  "guid": "19da7351-7c07-4a28-8d1c-5cdc5ddbbbe4",
  "tiposdocumento_id": "1",
  "identificacion": "1001532242"
}
```

---

## Validaciones del Servicio

El servicio ejecuta las siguientes validaciones en orden:

### Nivel 1: Autenticación
- Token JWT válido y vigente en header `Authorization`.
- Respuesta en caso de error: `401 Unauthorized`.

### Nivel 2: Campos Requeridos
- `guid`, `tiposdocumento_id` e `identificacion` son obligatorios.
- Respuesta en caso de error: `400 Bad Request`.

### Nivel 3: Transacción Existente
- El `guid` debe existir en `Validacionesotp`.
- La `identificacion` debe coincidir con la registrada en la transacción.
- Respuesta en caso de error: `404 Not Found`.

### Nivel 4: OTP Validado
- El estado de la transacción debe ser `VALIDADO`.
- Si no está validado, retorna `otp_not_validated`.

### Nivel 5: Consulta de Líneas
- Se ejecuta `fnc_json_credintegral('INVICTUS', identificacion, tiposdocumento_id)`.
- Si no retorna datos, retorna `no_credit`.

---

## Responses

### ✅ Caso 1: Success

**HTTP:** `200 OK`

```json
{
  "status": "success",
  "datos": {
    "guid": "19da7351-7c07-4a28-8d1c-5cdc5ddbbbe4",
    "nombre_cliente": "YURANY MERCADO ARRIETA",
    "identificacion": "1001532242",
    "fecha_validacion": "2026-05-06 11:07:48",
    "puede_desembolsar": true,
    "lineas_credito": [
      {
        "id_linea_credito": 5943520472602252,
        "linea_credito": "RIS ROTATIVO",
        "valor_cupo": 685000.0,
        "total_entregado": 5414.0,
        "total_disponible": 679586.0,
        "plazo_meses": 12,
        "monto_fijo": "NO"
      }
    ]
  }
}
```

### ❌ Caso 2: OTP No Validado

**HTTP:** `200 OK`

```json
{
  "status": "otp_not_validated",
  "mensaje": "Debe validar el código OTP antes de consultar las líneas de crédito."
}
```

### ❌ Caso 3: Sin Crédito

**HTTP:** `200 OK`

```json
{
  "status": "no_credit",
  "mensaje": "No se encontró información de crédito para esta identificación."
}
```

### ❌ Caso 4: Transacción No Encontrada

**HTTP:** `404 Not Found`

```json
{
  "status": "error",
  "mensaje": "Transacción no encontrada o inválida."
}
```

### ❌ Caso 5: Campos Faltantes

**HTTP:** `400 Bad Request`

```json
{
  "status": "error",
  "errors": [
    "El campo guid es obligatorio.",
    "El campo identificacion es obligatorio."
  ]
}
```

### ❌ Caso 6: Token Inválido

**HTTP:** `401 Unauthorized`

```json
{
  "status": "error",
  "mensaje": "Token de autorización inválido o ausente."
}
```

---

## Descripción de Campos de Respuesta

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `status` | string | Resultado: `success`, `otp_not_validated`, `no_credit`, `error` |
| `datos.guid` | string | UUID de la transacción (mismo del request) |
| `datos.nombre_cliente` | string | Nombre completo del cliente desde `personas.nombre_completo` |
| `datos.identificacion` | string | Número de identificación desde `personas.identificacion` |
| `datos.fecha_validacion` | string | Timestamp de consulta (formato: `YYYY-MM-DD HH:MM:SS`) |
| `datos.puede_desembolsar` | boolean | Siempre `true` cuando `status: success` |
| `datos.lineas_credito` | array | Líneas de crédito disponibles |
| `lineas_credito[].id_linea_credito` | integer | `codclavecic` de la persona (código CIC) |
| `lineas_credito[].linea_credito` | string | Nombre del cliente desde `clientes.nombre` |
| `lineas_credito[].valor_cupo` | number | `personas.cupo_aprobado` |
| `lineas_credito[].total_entregado` | number | `personas.cupo_deuda` |
| `lineas_credito[].total_disponible` | number | `personas.cupo_disponible` |
| `lineas_credito[].plazo_meses` | integer | `12` fijo para rotativo |
| `lineas_credito[].monto_fijo` | string | `"NO"` para rotativo |

---

## Reglas Funcionales en Invictus (Sección 2: Datos Crédito)

1. **Carga de líneas** — Invictus muestra los datos retornados. Ningún campo es editable.

2. **Selección única** — Solo se puede seleccionar una línea a la vez. Si cambia de línea, se limpian los campos de la anterior.

3. **Campos de captura obligatorios**
    - `[Ingrese Plazo]` y `[Confirme Plazo]` — numéricos, `<= plazo_meses`.
    - `[Ingrese Valor]` y `[Confirme Valor]` — numéricos, `<= total_disponible`.

4. **Regla monto fijo** — Si `monto_fijo = "SI"`, Invictus asigna `total_disponible` en valor y lo deja no editable.

5. **Habilitación de `[Calcular Desembolso]`** — Solo cuando hay línea seleccionada y todos los campos son válidos.

6. **Confirmación** — Al presionar `[Calcular Desembolso]`, Invictus muestra modal de resumen. Si confirma, consume `proceso_desembolso`. Si cancela, regresa sin guardar.

---

## Tabla Resumen de Respuestas

| Condición | HTTP | status | Comportamiento en Invictus |
|-----------|------|--------|---------------------------|
| Todo correcto | 200 | `success` | Habilita Sección 2 con líneas |
| OTP no validado | 200 | `otp_not_validated` | Modal naranja, permanece en OTP |
| Sin crédito | 200 | `no_credit` | Modal naranja, regresa a inicio |
| GUID no encontrado | 404 | `error` | Modal naranja, permanece en OTP |
| Campos faltantes | 400 | `error` | Modal naranja, permanece en OTP |
| Token inválido | 401 | `error` | Modal naranja, permanece en OTP |

---

## Ejemplo cURL

```bash
curl --location 'https://testing-sygma.com/api/seleccionar_linea_credito' \
--header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...' \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' \
--data '{
  "guid": "19da7351-7c07-4a28-8d1c-5cdc5ddbbbe4",
  "tiposdocumento_id": "1",
  "identificacion": "1001532242"
}'
```

---

## Configuración del Ambiente de Pruebas

| Parámetro | Valor |
|-----------|-------|
| Base URL | `https://testing-sygma.com/api` |
| Endpoint Login | `/login` |
| Endpoint Líneas | `/seleccionar_linea_credito` |
| Usuario | `ws_invictus` |
| Password | `g3z0OmJP7?@(*` |
