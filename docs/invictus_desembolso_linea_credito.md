# Seleccionar líneas de crédito (Invictus).

## Resumen
Documenta cómo Invictus presenta y valida la selección de línea, plazo y valor. Esta sección usa la información recibida en la respuesta exitosa de validación OTP.

## Endpoint
- **No aplica endpoint propio en este paso.**
- **Fuente de datos**: respuesta `success` de `POST /api/validacion_otp_desembolso`.

## Autenticación
- **Tipo**: `Bearer token`
- **Header**: `Authorization: Bearer <token>`
- **Obtención del token**: `POST https://testing-sygma.com/api/login`

## Headers
- **Authorization**: `Bearer <token>` (obligatorio)
- **Accept**: `application/json` (obligatorio)
- **Content-Type**: `application/json` (obligatorio)

## Request
No aplica request propio para este paso funcional. Invictus toma los datos del `success` del servicio OTP y habilita la captura de plazo/valor por línea.

## Responses
Ver sección **Response** (estructura de líneas que Invictus debe mostrar).

## Notas / Flujo

### Flujo del proceso

### Contexto General

Este paso ocurre después de validar OTP exitosamente y antes de calcular desembolso.

```
Servicio 1: Validación de Crédito Vigente
     ↓
Servicio 2: Validación de OTP
     ↓ (retorna success + líneas de crédito)
Sección 2: Datos Crédito (este documento)
     ↓ (usuario selecciona línea, plazo, valor)
     ↓ (presiona [Calcular Desembolso])
Servicio de Cálculo de Desembolso
     ↓
Sección 3: Realizar Desembolso
```

### Secuencia del Flujo

```
1. Usuario completa Sección 2: Datos Crédito
   - Ha seleccionado una línea de crédito
   - Ha ingresado y confirmado plazo
   - Ha ingresado y confirmado valor
   - Todos los campos validados correctamente
   ↓
2. Usuario presiona [Calcular Desembolso]
   ↓
3. Sistema muestra Modal de Confirmación
   - Cliente: [Nombre]
   - Línea de Crédito: [Nombre línea]
   - Plazo: [X meses]
   - Valor Total: $[XXX,XXX]
   ↓
4. Usuario selecciona [Calcular Desembolso]
   ↓
5. Invictus consume el servicio de cálculo de desembolso (siguiente documento)
```

### Flujo funcional previo: Seleccionar línea de crédito, valor y plazo

Este flujo corresponde a la etapa donde Invictus presenta líneas disponibles y permite escoger **una sola línea** antes del cálculo.

**Reglas funcionales clave (mockup PDF):**

1. **Carga de líneas de crédito tras OTP válido**
   - Invictus muestra en Sección 2 los datos devueltos por TESEO:
     - Nombre cliente
     - Línea de crédito
     - Total cupo
     - Total utilizado
     - Total disponible
     - Plazo máximo
   - Ningún campo retornado por servicio es editable.

2. **Campos de captura obligatorios por línea seleccionada**
   - `[Ingrese Plazo]` y `[Confirme Plazo]` obligatorios.
   - `[Ingrese Valor]` y `[Confirme Valor]` obligatorios, salvo reglas de monto fijo.
   - Todos numéricos, sin valores negativos.

3. **Selección única de línea**
   - Campo `[Seleccionar]` tipo checkbox.
   - Solo permite **una** línea a la vez.
   - No hay selección por defecto al cargar.
   - Si cambia de línea, se limpia información diligenciada de la línea anterior.

4. **Regla de crédito de monto fijo**
   - Si línea trae marca `Crédito de monto fijo = S`:
     - Invictus asigna `Total Disponible` en `[Ingrese Valor]` y `[Confirme Valor]`.
     - Esos campos quedan no editables.
     - Solo se diligencia plazo y confirmación de plazo.

5. **Validaciones de plazo y valor**
   - `[Ingrese Plazo]` debe ser `<= Plazo Máximo`.
   - `[Confirme Plazo]` debe coincidir con `[Ingrese Plazo]`.
   - `[Ingrese Valor]` y `[Confirme Valor]` deben coincidir.
   - Si no cumple, resalta campo en rojo y bloquea avance.

6. **Habilitación de botón `[Calcular Desembolso]`**
   - Inicia inhabilitado.
   - Se habilita solo cuando:
     - hay una línea seleccionada, y
     - todos campos obligatorios de esa línea están completos y válidos.

7. **Confirmación antes del cálculo**
   - Al presionar `[Calcular Desembolso]`, Invictus muestra resumen de transacción.
   - Si asesor confirma (`[Aceptar]`), consume servicio de cálculo.
   - Si cancela (`[Cancelar]`), sale sin guardar y regresa a inicio.
   - Después de confirmar, no se permiten cambios en secciones previas.

---

## Información Técnica

### Tipo de integración

Este paso no define un endpoint nuevo.  
Consume datos del `success` de `POST /api/validacion_otp_desembolso`.

---

### URL de integración

| Ambiente | URL origen de datos |
|----------|---------------------|
| **Pruebas (QA)** | `https://testing-sygma.com/api/validacion_otp_desembolso` |
| **Producción** | `POR DEFINIR` |

---

### Headers Requeridos

Aplican al servicio origen (`validacion_otp_desembolso`):

| Nombre | Valor | Requerido | Descripción |
|--------|-------|-----------|-------------|
| `Authorization` | `Bearer {token}` | ✅ | Token de autenticación JWT |
| `Accept` | `application/json` | ✅ | Formato de respuesta esperado |
| `Content-Type` | `application/json` | ✅ | Formato del cuerpo de la petición |

#### 🔐 Obtención del Token

!!! "Obtención del Token" El token se obtiene a través del módulo de autenticación, usando el usuario y contraseña asignados por la entidad.

**Endpoint de autenticación:**
```
POST https://testing-sygma.com/api/login
```

---

## Request

### Entrada funcional de esta sección

Este paso no consume endpoint propio.  
Invictus recibe líneas en el `success` de OTP y habilita captura en UI:

- Selección única de `id_linea_credito`
- `Ingrese Plazo` y `Confirme Plazo`
- `Ingrese Valor` y `Confirme Valor` (según regla de `monto_fijo`)

Los datos confirmados aquí se usan en el siguiente servicio: cálculo de desembolso.

---

## Response

### Estructura de Respuesta Exitosa

**Código HTTP:** `200 OK`

**Status:** `"success"`

```json
{
  "status": "success",
  "datos": {
    "guid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "mensaje": "Código OTP validado correctamente. Crédito autorizado para desembolso.",
    "nombre_cliente": "Juan Pérez",
    "fecha_validacion": "2025-10-10 14:30:45",
    "puede_desembolsar": true,
    "lineas_credito": [
      {
        "id_linea_credito": 27373,
        "linea_credito": "Línea 1",
        "valor_cupo": 50000,
        "total_entregado": 50000,
        "total_disponible": 50000,
        "plazo_meses": 12,
        "monto_fijo": "NO"
      },
      {
        "id_linea_credito": 27375,
        "linea_credito": "Línea 2",
        "valor_cupo": 50000,
        "total_entregado": 50000,
        "total_disponible": 50000,
        "plazo_meses": 2,
        "monto_fijo": "SI"
      }
    ]
  }
}
```

#### Descripción de Campos de Respuesta

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `status` | string | Indicador del resultado: `"success"` |
| `datos` | object | Objeto con líneas de crédito disponibles para selección |
| `datos.guid` | string | Identificador único de la transacción (mismo del request) |
| `datos.mensaje` | string | Mensaje de confirmación de OTP válido |
| `datos.nombre_cliente` | string | Nombre completo del cliente (confirmación) |
| `datos.fecha_validacion` | string | Timestamp de validación OTP (formato: YYYY-MM-DD HH:MM:SS) |
| `datos.puede_desembolsar` | boolean | Indica autorización para continuar (`true`) |
| `datos.lineas_credito` | array | Array de líneas de crédito disponibles |
| `datos.lineas_credito[].id_linea_credito` | integer | ID de línea de crédito |
| `datos.lineas_credito[].linea_credito` | string | Nombre de línea de crédito |
| `datos.lineas_credito[].valor_cupo` | number | Cupo total de línea |
| `datos.lineas_credito[].total_entregado` | number | Valor ya entregado |
| `datos.lineas_credito[].total_disponible` | number | Valor disponible para desembolso |
| `datos.lineas_credito[].plazo_meses` | integer | Plazo máximo disponible |
| `datos.lineas_credito[].monto_fijo` | string | Marca de crédito de monto fijo (`SI`/`NO`) |

---

## Tabla resumen funcional

| Evento previo | Fuente | Resultado en Invictus |
|---|---|---|
| OTP válido (`status: success`) | `validacion_otp_desembolso` | Habilita Sección 2 y muestra `lineas_credito` |
| OTP inválido/bloqueado/expirado/error | `validacion_otp_desembolso` | No habilita selección de líneas |

---

## Ejemplo funcional

**Fuente de datos (response OTP success):**
```json
{
  "status": "success",
  "datos": {
    "guid": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "mensaje": "Código OTP validado correctamente. Crédito autorizado para desembolso.",
    "nombre_cliente": "Juan Pérez",
    "fecha_validacion": "2025-10-10 14:30:45",
    "puede_desembolsar": true,
    "lineas_credito": [
      {
        "id_linea_credito": 27373,
        "linea_credito": "Línea 1",
        "valor_cupo": 50000,
        "total_entregado": 50000,
        "total_disponible": 50000,
        "plazo_meses": 12,
        "monto_fijo": "NO"
      }
    ]
  }
}
```

**Acción en Invictus:**
1. Habilita **Sección 2: Datos Crédito**.
2. Carga tabla de líneas retornadas en `datos.lineas_credito`.
3. Permite seleccionar solo una línea.
4. Valida plazo y valor antes de habilitar **[Calcular Desembolso]**.

