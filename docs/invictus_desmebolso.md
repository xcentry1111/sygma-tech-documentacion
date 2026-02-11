# 📘 Manual de Integración API: Ejecución de Desembolso Final

## Descripción del Servicio

Este servicio permite ejecutar el desembolso final del crédito al cliente después de haber validado la identidad mediante OTP y calculado los descuentos aplicables. El servicio registra la transacción en TESEO, genera los movimientos contables, actualiza el estado del crédito a "desembolsado" y retorna la confirmación para que Invictus proceda con la entrega física del dinero al cliente.

---

## Flujo del Proceso

### Contexto General

Este servicio es el **quinto y último paso** del flujo de desembolso, ejecutándose después de que el usuario confirma el desembolso presionando el botón [Pagar]:

```
Servicio 1: Validación de Crédito Vigente
     ↓
Servicio 2: Validación de OTP
     ↓ (retorna success + líneas de crédito)
Sección 2: Datos Crédito (Selección UI)
     ↓ (usuario selecciona línea, plazo, valor)
Servicio 4: Cálculo de Desembolso
     ↓ (calcula descuentos y valor final)
Sección 3: Realizar Desembolso (muestra valores calculados)
     ↓ (usuario presiona [Pagar])
Servicio 5: Ejecución de Desembolso Final (este documento) ← ESTAMOS AQUÍ
     ↓ (ejecuta y registra el desembolso)
Entrega física de dinero al cliente
```

### Secuencia del Flujo

```
1. Usuario se encuentra en Sección 3: Realizar Desembolso
   - Visualiza información calculada:
     * Valor Total
     * Valor Cobros
     * Plazo (Meses)
     * Valor a Pagar al Cliente
   - Botones habilitados: [Cancelar], [Limpiar], [Pagar]
   ↓
2. Usuario presiona [Pagar]
   - Confirmación implícita de que está listo para ejecutar
   ↓
3. Sistema consume este servicio (TESEO)
   ↓
4. Servicio ejecuta validaciones y registro:
   
   a) Validación de Autenticación
      ↓ Token inválido? → SÍ: retorna "error" (401)
   
   b) Validación de Campos Requeridos
      ↓ Campos vacíos? → SÍ: retorna "error" (400)
   
   c) Validación de Transacción Existente
      ↓ GUID no existe? → SÍ: retorna "error" (404)
   
   d) Validación de Crédito Disponible
      ↓ Crédito ya desembolsado? → SÍ: retorna "already_disbursed"
      ↓ Crédito no vigente? → SÍ: retorna "credit_not_available"
   
   e) Validación de OTP Previamente Confirmado
      ↓ OTP no validado? → SÍ: retorna "otp_not_validated"
   
   f) Ejecución del Desembolso
      ↓ Registra en TESEO
      ↓ Actualiza estado a "desembolsado"
      ↓ Genera movimientos contables
      ↓ Retorna "success" + comprobante
   ↓
5. Comportamiento según respuesta:
   
   - success → Modal verde: "Su transacción fue Exitosa..."
               Muestra valor a entregar al cliente
               Cierra modal → Regresa a pantalla inicial de Invictus
               Invictus ejecuta acciones internas:
               1. Replica en SIGA y contabilidad
               2. Afecta caja y cartera de la fuerza de ventas
               3. Registra en Base de datos de Invictus
               4. Imprime colilla de transacción
               5. Afecta la contabilidad en Invictus
   
   - error (autenticación) → Modal rojo: "Token de autorización inválido..."
                             Cierra modal, permanece en Sección 3
                             NO guarda ni registra transacción
   
   - error (transacción) → Modal naranja: "Transacción no encontrada..."
                           Cierra modal, permanece en Sección 3
                           NO guarda ni registra transacción
   
   - already_disbursed → Modal naranja: "Este crédito ya fue desembolsado..."
                         Cierra modal, regresa a pantalla inicial
                         Proceso se REINICIA
   
   - credit_not_available → Modal naranja: "El crédito no está disponible..."
                            Cierra modal, regresa a pantalla inicial
                            Proceso se REINICIA
   
   - otp_not_validated → Modal naranja: "Debe validar el OTP..."
                         Cierra modal, permanece en Sección 3
                         Usuario debe completar validación OTP
```

---

## Información Técnica

### Tipo de Servicio

**Método HTTP:** `POST`

---

### URL de Integración

| Ambiente | URL                                                |
|----------|----------------------------------------------------|
| **Pruebas (QA)** | `https://testing-sygma.com/api/proceso_desembolso` |
| **Producción** | `POR DEFINIR`                                      |

---

### Headers Requeridos

| Nombre | Valor | Requerido | Descripción |
|--------|-------|-----------|-------------|
| `Authorization` | `Bearer {token}` | ✅ | Token de autenticación JWT |
| `Accept` | `application/json` | ✅ | Formato de respuesta esperado |
| `Content-Type` | `application/json` | ✅ | Formato del cuerpo de la petición |

#### 🔐 Obtención del Token

!!! "Obtención del Token"
El token se obtiene a través del módulo de autenticación, usando el usuario y contraseña asignados por la entidad.

**Endpoint de autenticación:**
```
POST https://testing-sygma.com/api/login
```

---

## Request

### Cuerpo de la Solicitud

La solicitud debe enviarse en formato **raw JSON** con los siguientes campos:

#### Campos Obligatorios

| Campo | Tipo | Longitud | Requerido | Descripción |
|-------|------|----------|-----------|-------------|
| `tiposdocumento_id` | string | - | ✅ | ID del tipo de documento según catálogo |
| `identificacion` | string | variable | ✅ | Número de identificación del usuario |
| `guid` | string | UUID | ✅ | UUID de la transacción del proceso actual |
| `id_linea_credito` | integer | - | ✅ | Identificador de la línea de crédito seleccionada |
| `plazo_meses` | integer | - | ✅ | Plazo en meses seleccionado por el cliente |
| `valor_total` | number | - | ✅ | Valor total del desembolso solicitado |
| `valor_cobros` | number | - | ✅ | Suma de todos los descuentos/cobros aplicados |
| `valor_a_pagar_cliente` | number | - | ✅ | Monto final a entregar físicamente al cliente |
| `plaza_empresa` | integer | - | ✅ | Código de la plaza/empresa donde se realiza |

#### Catálogo de Tipos de Documento

| `tiposdocumento_id` | Descripción | Código |
|---------------------|-------------|--------|
| `1` | Cédula de ciudadanía | CC |
| `2` | Cédula de extranjería | CE |
| `3` | NIT | NIT |
| `8` | Pasaporte | PA |
| `181` | Permiso Especial | PEP |

#### Origen de los Datos (Captura en Invictus)

| Campo | Origen en Invictus | Momento de Captura |
|-------|-------------------|-------------------|
| `tiposdocumento_id` | Sección 1: Datos Cliente → Campo "Tipo de Identificación" | Al inicio del proceso |
| `identificacion` | Sección 1: Datos Cliente → Campo "Número de Identificación" | Al inicio del proceso |
| `guid` | Retornado por Servicio 2 (Validación OTP) o Servicio 3 (Reenvío OTP) | Durante validación OTP |
| `id_linea_credito` | Sección 2: Datos Crédito → Línea seleccionada (checkbox) | Al seleccionar línea |
| `plazo_meses` | Sección 2: Datos Crédito → Campo [Confirme Plazo] | Al confirmar plazo |
| `valor_total` | Retornado por Servicio 4 (Cálculo Desembolso) | Después de calcular |
| `valor_cobros` | Retornado por Servicio 4 (Cálculo Desembolso) | Después de calcular |
| `valor_a_pagar_cliente` | Retornado por Servicio 4 (Cálculo Desembolso) | Después de calcular |
| `plaza_empresa` | Retornado por Servicio 4 (Cálculo Desembolso) | Después de calcular |

#### Ejemplo de Request

```json
{
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "guid": "b2c3d4e5-f6g7-8901-bcde-fg2345678901",
  "id_linea_credito": 27375,
  "plazo_meses": 4,
  "valor_total": 500000,
  "valor_cobros": 12050,
  "valor_a_pagar_cliente": 487950,
  "plaza_empresa": 50
}
```

---

## Response

### Estructura de Respuesta Exitosa

**Código HTTP:** `200 OK`

**Status:** `"success"`

```json
{
  "status": "success",
  "datos": {
    "guid": "b2c3d4e5-f6g7-8901-bcde-fg2345678901",
    "mensaje": "Transacción exitosa. Desembolso realizado correctamente.",
    "numero_desembolso": "DES-2025-00012345",
    "nombre_cliente": "Fernando Osorio",
    "identificacion": "88282828",
    "linea_credito": "Línea Digital",
    "valor_total": 500000,
    "valor_cobros": 12050,
    "valor_a_pagar_cliente": 487950,
    "plazo_meses": 4,
    "plaza_empresa": 50,
    "fecha_desembolso": "2025-02-11 14:35:22",
    "comprobante": {
      "numero_comprobante": "COMP-2025-00012345",
      "fecha_hora": "2025-02-11 14:35:22",
      "concepto": "Desembolso de crédito",
      "detalles_descuentos": [
        {
          "concepto": "IVA",
          "valor": 8000
        },
        {
          "concepto": "Seguro",
          "valor": 4000
        },
        {
          "concepto": "Comisión",
          "valor": 50
        }
      ]
    },
    "instrucciones_invictus": {
      "replicar_siga": true,
      "afectar_caja": true,
      "afectar_cartera": true,
      "imprimir_colilla": true,
      "afectar_contabilidad": true
    }
  }
}
```

#### Descripción de Campos de Respuesta

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `status` | string | Indicador del resultado: `"success"` |
| `datos` | object | Objeto con toda la información del desembolso |
| `datos.guid` | string | Identificador único de la transacción (mismo del request) |
| `datos.mensaje` | string | Mensaje de confirmación del desembolso exitoso |
| `datos.numero_desembolso` | string | Número único del desembolso generado por TESEO |
| `datos.nombre_cliente` | string | Nombre completo del cliente (confirmaciónón) |
| `datos.identificacion` | string | Número de identificación del cliente |
| `datos.linea_credito` | string | Nombre de la línea de crédito seleccionada |
| `datos.valor_total` | number | Valor total solicitado por el cliente |
| `datos.valor_cobros` | number | Suma de todos los descuentos/cobros aplicados |
| `datos.valor_a_pagar_cliente` | number | **Monto final a entregar físicamente al cliente** |
| `datos.plazo_meses` | integer | Plazo en meses del crédito |
| `datos.plaza_empresa` | integer | Código de la plaza/empresa donde se realizó |
| `datos.fecha_desembolso` | string | Timestamp del desembolso (formato: YYYY-MM-DD HH:MM:SS) |
| `datos.comprobante` | object | Información del comprobante generado |
| `datos.comprobante.numero_comprobante` | string | Número único del comprobante |
| `datos.comprobante.fecha_hora` | string | Fecha y hora del comprobante |
| `datos.comprobante.concepto` | string | Concepto del movimiento |
| `datos.comprobante.detalles_descuentos` | array | Array con el desglose de descuentos |
| `datos.instrucciones_invictus` | object | Flags que indican acciones que Invictus debe ejecutar |
| `datos.instrucciones_invictus.replicar_siga` | boolean | Indica si debe replicar en SIGA y contabilidad |
| `datos.instrucciones_invictus.afectar_caja` | boolean | Indica si debe afectar la caja de la fuerza de ventas |
| `datos.instrucciones_invictus.afectar_cartera` | boolean | Indica si debe afectar la cartera de la fuerza de ventas |
| `datos.instrucciones_invictus.imprimir_colilla` | boolean | Indica si debe imprimir colilla de transacción |
| `datos.instrucciones_invictus.afectar_contabilidad` | boolean | Indica si debe afectar la contabilidad en Invictus |

---

## Validaciones del Servicio

El servicio ejecuta las siguientes validaciones en orden secuencial:

### Nivel 1: Validación de Autenticación

**Reglas:**
- Token debe estar presente en el header `Authorization`
- Token debe tener formato válido: `Bearer {token}`
- Token debe estar vigente (no expirado)
- Token debe corresponder a un usuario autorizado

**Resultado: Token Inválido o Vencido**

**Respuesta:**
```json
{
  "status": "error",
  "mensaje": "Token de autorización inválido o ausente."
}
```

**Código HTTP:** `401 Unauthorized`

**Comportamiento en Invictus:**
- Mostrar mensaje modal **ROJO**: **"Token de autorización inválido o ausente"**
- Botón **[CERRAR]** para cerrar el modal
- **Cerrar modal → Permanece en Sección 3: Realizar Desembolso**
- **NO guarda información ni registra la transacción**
- **Nota:** Este token corresponde a la autenticación del sistema Invictus con TESEO

---

### Nivel 2: Validación de Campos Requeridos

**Reglas:**
- Todos los campos del request son obligatorios
- Campos deben tener el tipo de dato correcto
- No se permiten valores vacíos o nulos
- `guid` debe ser un UUID válido
- Valores numéricos deben ser mayores a cero

**Respuesta en caso de error:**
```json
{
  "status": "error",
  "errors": [
    "El campo guid es obligatorio.",
    "El campo valor_total es obligatorio.",
    "El campo valor_a_pagar_cliente debe ser mayor a cero."
  ]
}
```

**Código HTTP:** `400 Bad Request`

---

### Nivel 3: Validación de Transacción Existente

**Proceso:**
1. Se verifica que el `guid` proporcionado exista en el sistema TESEO
2. Se valida que corresponda a una transacción de desembolso válida
3. Se verifica que la transacción pertenezca al cliente identificado

**Resultado: Transacción No Encontrada o Inválida**

El GUID proporcionado no existe en el sistema o no corresponde a la identificación del cliente.

**Respuesta:**
```json
{
  "status": "error",
  "mensaje": "Transacción no encontrada o inválida."
}
```

**Código HTTP:** `404 Not Found`

**Comportamiento en Invictus:**
- Mostrar mensaje modal **NARANJA**: **"Transacción no encontrada o inválida"**
- Botón **[CERRAR]** para cerrar el modal
- **Cerrar modal → Permanece en Sección 3: Realizar Desembolso**
- **NO guarda información ni registra la transacción**

---

### Nivel 4: Validación de OTP Previamente Confirmado

**Proceso:**
1. Se verifica que el OTP asociado al `guid` haya sido validado exitosamente
2. Se confirma que la validación OTP esté vigente (no haya expirado la sesión)
3. Se valida que no haya transcurrido más tiempo del permitido desde la validación OTP

**Resultado: OTP No Validado o Sesión Expirada**

El OTP no fue validado previamente o la sesión de validación ha expirado.

**Respuesta:**
```json
{
  "status": "otp_not_validated",
  "mensaje": "Debe validar el código OTP antes de ejecutar el desembolso.",
  "tiempo_desde_validacion": null
}
```

**Código HTTP:** `200 OK`

**Comportamiento en Invictus:**
- Mostrar mensaje modal **NARANJA**: **"Debe validar el código OTP antes de ejecutar el desembolso"**
- Botón **[CERRAR]** para cerrar el modal
- **Cerrar modal → Permanece en Sección 3: Realizar Desembolso**
- Usuario debe regresar a validar el OTP

---

### Nivel 5: Validación de Crédito Disponible

**Proceso:**
1. Se verifica el estado actual del crédito en TESEO
2. Se valida que el crédito no haya sido desembolsado previamente
3. Se confirma que el crédito sigue vigente (dentro de los 30 días)
4. Se valida que el cupo esté activo y sin bloqueos

**Resultado 5.1: Crédito Ya Desembolsado**

El crédito ya fue desembolsado en una transacción anterior.

**Respuesta:**
```json
{
  "status": "already_disbursed",
  "mensaje": "Este crédito ya fue desembolsado anteriormente.",
  "fecha_desembolso_anterior": "2025-02-10 10:15:30",
  "numero_desembolso_anterior": "DES-2025-00012340"
}
```

**Código HTTP:** `200 OK`

**Comportamiento en Invictus:**
- Mostrar mensaje modal **NARANJA**: **"Este crédito ya fue desembolsado anteriormente el 2025-02-10"**
- Botón **[CERRAR]** para cerrar el modal
- **Cerrar modal → REGRESA a pantalla principal de Invictus**
- **Proceso completo se REINICIA**

---

**Resultado 5.2: Crédito No Disponible**

El crédito no está disponible por diferentes razones (vencido, bloqueado, cancelado).

**Respuesta:**
```json
{
  "status": "credit_not_available",
  "mensaje": "El crédito no está disponible para desembolso.",
  "razon": "credito_vencido",
  "detalles": "El crédito ha superado el plazo de 30 días desde su aprobación."
}
```

**Código HTTP:** `200 OK`

**Comportamiento en Invictus:**
- Mostrar mensaje modal **NARANJA**: **"El crédito no está disponible para desembolso. [detalles]"**
- Botón **[CERRAR]** para cerrar el modal
- **Cerrar modal → REGRESA a pantalla principal de Invictus**
- **Proceso completo se REINICIA**

**Posibles valores de `razon`:**
- `credito_vencido`: Crédito superó los 30 días desde aprobación
- `cupo_bloqueado`: Cupo bloqueado por mora u otras razones
- `cupo_cancelado`: Cupo fue cancelado
- `cliente_fallecido`: Cliente registrado como fallecido
- `sin_cupo`: Cliente no cuenta con cupo activo

---

### Nivel 6: Validación de Coherencia de Montos

**Proceso:**
1. Se valida que `valor_total = valor_a_pagar_cliente + valor_cobros`
2. Se verifica que los montos coincidan con el cálculo previo del Servicio 4
3. Se confirma que no haya manipulación de valores

**Resultado: Montos Incoherentes**

Los valores enviados no son coherentes o no coinciden con el cálculo previo.

**Respuesta:**
```json
{
  "status": "error",
  "mensaje": "Los montos enviados no son coherentes o no coinciden con el cálculo previo.",
  "errores": [
    "El valor_total no coincide con la suma de valor_a_pagar_cliente + valor_cobros",
    "Los valores no coinciden con el cálculo registrado"
  ]
}
```

**Código HTTP:** `400 Bad Request`

---

## Respuestas de Error

### Error 1: Token de Autenticación Inválido

**Código HTTP:** `401 Unauthorized`

**Response:**
```json
{
  "status": "error",
  "mensaje": "Token de autorización inválido o ausente."
}
```

**Comportamiento en Invictus:**
- Mostrar mensaje modal **ROJO**: **"Token de autorización inválido o ausente"**
- Botón **[CERRAR]** para cerrar el modal
- **Cerrar modal → Permanece en Sección 3: Realizar Desembolso**
- **NO guarda información ni registra la transacción**
- **Nota:** Este token corresponde a la autenticación del sistema Invictus con TESEO

---

### Error 2: Transacción No Encontrada

**Código HTTP:** `404 Not Found`

**Response:**
```json
{
  "status": "error",
  "mensaje": "Transacción no encontrada o inválida."
}
```

**Comportamiento en Invictus:**
- Mostrar mensaje modal **NARANJA**: **"Transacción no encontrada o inválida"**
- Botón **[CERRAR]** para cerrar el modal
- **Cerrar modal → Permanece en Sección 3: Realizar Desembolso**
- **NO guarda información ni registra la transacción**

---

### Error 3: Campos Requeridos Faltantes

**Código HTTP:** `400 Bad Request`

**Response:**
```json
{
  "status": "error",
  "errors": [
    "El campo guid es obligatorio.",
    "El campo valor_total es obligatorio."
  ]
}
```

---

### Error 4: Crédito Ya Desembolsado

**Código HTTP:** `200 OK`

**Response:**
```json
{
  "status": "already_disbursed",
  "mensaje": "Este crédito ya fue desembolsado anteriormente.",
  "fecha_desembolso_anterior": "2025-02-10 10:15:30",
  "numero_desembolso_anterior": "DES-2025-00012340"
}
```

**Comportamiento en Invictus:**
- Mostrar mensaje modal **NARANJA**: **"Este crédito ya fue desembolsado anteriormente el 2025-02-10"**
- Botón **[CERRAR]** para cerrar el modal
- **Cerrar modal → REGRESA a pantalla principal de Invictus**
- **Proceso completo se REINICIA**

---

### Error 5: OTP No Validado

**Código HTTP:** `200 OK`

**Response:**
```json
{
  "status": "otp_not_validated",
  "mensaje": "Debe validar el código OTP antes de ejecutar el desembolso.",
  "tiempo_desde_validacion": null
}
```

**Comportamiento en Invictus:**
- Mostrar mensaje modal **NARANJA**: **"Debe validar el código OTP antes de ejecutar el desembolso"**
- Botón **[CERRAR]** para cerrar el modal
- **Cerrar modal → Permanece en Sección 3: Realizar Desembolso**
- Usuario debe completar validación OTP

---

### Error 6: Crédito No Disponible

**Código HTTP:** `200 OK`

**Response:**
```json
{
  "status": "credit_not_available",
  "mensaje": "El crédito no está disponible para desembolso.",
  "razon": "credito_vencido",
  "detalles": "El crédito ha superado el plazo de 30 días desde su aprobación."
}
```

**Comportamiento en Invictus:**
- Mostrar mensaje modal **NARANJA**: **"El crédito no está disponible para desembolso. [detalles]"**
- Botón **[CERRAR]** para cerrar el modal
- **Cerrar modal → REGRESA a pantalla principal de Invictus**
- **Proceso completo se REINICIA**

---

## Tabla Resumen de Respuestas

| # | Condición | HTTP Code | status | Mensaje | Comportamiento Invictus | Reinicia Proceso |
|---|-----------|-----------|--------|---------|------------------------|------------------|
| 1 | Desembolso exitoso | 200 | `success` | "Transacción exitosa..." | Modal verde, ejecuta acciones internas, regresa a inicio | No |
| 2 | Token inválido/ausente | 401 | `error` | "Token de autorización inválido o ausente." | Modal rojo, permanece en Sección 3 | No |
| 3 | Transacción no encontrada | 404 | `error` | "Transacción no encontrada o inválida." | Modal naranja, permanece en Sección 3 | No |
| 4 | Campos faltantes | 400 | `error` | Lista de campos obligatorios | - | No |
| 5 | Crédito ya desembolsado | 200 | `already_disbursed` | "Este crédito ya fue desembolsado..." | Modal naranja, regresa a inicio | **SÍ** |
| 6 | OTP no validado | 200 | `otp_not_validated` | "Debe validar el código OTP..." | Modal naranja, permanece en Sección 3 | No |
| 7 | Crédito no disponible | 200 | `credit_not_available` | "El crédito no está disponible..." | Modal naranja, regresa a inicio | **SÍ** |
| 8 | Montos incoherentes | 400 | `error` | "Los montos enviados no son coherentes..." | - | No |

---

## Ejemplos Completos

### ✅ Ejemplo 1: Desembolso Exitoso

**Request:**
```json
POST /api/proceso_desembolso
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "guid": "b2c3d4e5-f6g7-8901-bcde-fg2345678901",
  "id_linea_credito": 27375,
  "plazo_meses": 4,
  "valor_total": 500000,
  "valor_cobros": 12050,
  "valor_a_pagar_cliente": 487950,
  "plaza_empresa": 50
}
```

**Response:**
```json
HTTP/1.1 200 OK
Content-Type: application/json

{
  "status": "success",
  "datos": {
    "guid": "b2c3d4e5-f6g7-8901-bcde-fg2345678901",
    "mensaje": "Transacción exitosa. Desembolso realizado correctamente.",
    "numero_desembolso": "DES-2025-00012345",
    "nombre_cliente": "Fernando Osorio",
    "identificacion": "88282828",
    "linea_credito": "Línea Digital",
    "valor_total": 500000,
    "valor_cobros": 12050,
    "valor_a_pagar_cliente": 487950,
    "plazo_meses": 4,
    "plaza_empresa": 50,
    "fecha_desembolso": "2025-02-11 14:35:22",
    "comprobante": {
      "numero_comprobante": "COMP-2025-00012345",
      "fecha_hora": "2025-02-11 14:35:22",
      "concepto": "Desembolso de crédito",
      "detalles_descuentos": [
        {
          "concepto": "IVA",
          "valor": 8000
        },
        {
          "concepto": "Seguro",
          "valor": 4000
        },
        {
          "concepto": "Comisión",
          "valor": 50
        }
      ]
    },
    "instrucciones_invictus": {
      "replicar_siga": true,
      "afectar_caja": true,
      "afectar_cartera": true,
      "imprimir_colilla": true,
      "afectar_contabilidad": true
    }
  }
}
```

**Acción en Invictus:**

1. **Mostrar Modal Verde:**
    - Mensaje: **"Su transacción fue Exitosa debe entregar $487,950 al cliente."**
    - Botón **[X]** o **[CERRAR]**

2. **Al cerrar modal:**
    - **REGRESA a pantalla principal de Invictus**

3. **Invictus debe ejecutar (según HUE 006):**
    - ✅ Replicar en SIGA y contabilidad
    - ✅ Afectar la caja de la fuerza de ventas (descontar $487,950)
    - ✅ Afectar la cartera de la fuerza de ventas
    - ✅ Registrarse en Base de datos de Invictus
    - ✅ Imprimir colilla de transacción con:
        * Número de desembolso
        * Número de comprobante
        * Cliente y documento
        * Línea de crédito
        * Valor total, cobros, y valor entregado
        * Desglose de descuentos
        * Fecha y hora
    - ✅ Afectar la contabilidad en Invictus

4. **Entrega física:**
    - El asesor debe entregar **$487,950** en efectivo al cliente
    - Cliente firma la colilla impresa como constancia de recibo

---

### 🔴 Ejemplo 2: Error de Autenticación

**Request:**
```json
POST /api/proceso_desembolso
Authorization: Bearer token_invalido_expirado
Content-Type: application/json

{
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "guid": "b2c3d4e5-f6g7-8901-bcde-fg2345678901",
  "id_linea_credito": 27375,
  "plazo_meses": 4,
  "valor_total": 500000,
  "valor_cobros": 12050,
  "valor_a_pagar_cliente": 487950,
  "plaza_empresa": 50
}
```

**Response:**
```json
HTTP/1.1 401 Unauthorized
Content-Type: application/json

{
  "status": "error",
  "mensaje": "Token de autorización inválido o ausente."
}
```

**Acción en Invictus:**
- Modal **ROJO** (Mockup 07) con texto: **"Token de autorización inválido o ausente"**
- Botón **[CERRAR]**
- Al cerrar → **PERMANECE en Sección 3: Realizar Desembolso**
- **NO guarda información ni registra la transacción**

---

### 🟠 Ejemplo 3: Transacción No Encontrada

**Request:**
```json
POST /api/proceso_desembolso
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "guid": "guid-invalido-no-existe",
  "id_linea_credito": 27375,
  "plazo_meses": 4,
  "valor_total": 500000,
  "valor_cobros": 12050,
  "valor_a_pagar_cliente": 487950,
  "plaza_empresa": 50
}
```

**Response:**
```json
HTTP/1.1 404 Not Found
Content-Type: application/json

{
  "status": "error",
  "mensaje": "Transacción no encontrada o inválida."
}
```

**Acción en Invictus:**
- Modal **NARANJA** (Mockup 05) con texto: **"Transacción no encontrada o inválida"**
- Botón **[CERRAR]**
- Al cerrar → **PERMANECE en Sección 3: Realizar Desembolso**
- **NO guarda información ni registra la transacción**

---

### ⚠️ Ejemplo 4: Crédito Ya Desembolsado

**Request:**
```json
POST /api/proceso_desembolso
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "guid": "b2c3d4e5-f6g7-8901-bcde-fg2345678901",
  "id_linea_credito": 27375,
  "plazo_meses": 4,
  "valor_total": 500000,
  "valor_cobros": 12050,
  "valor_a_pagar_cliente": 487950,
  "plaza_empresa": 50
}
```

**Response:**
```json
HTTP/1.1 200 OK
Content-Type: application/json

{
  "status": "already_disbursed",
  "mensaje": "Este crédito ya fue desembolsado anteriormente.",
  "fecha_desembolso_anterior": "2025-02-10 10:15:30",
  "numero_desembolso_anterior": "DES-2025-00012340"
}
```

**Acción en Invictus:**
- Modal **NARANJA** con texto: **"Este crédito ya fue desembolsado anteriormente el 2025-02-10"**
- Botón **[CERRAR]**
- Al cerrar → **REGRESA a pantalla principal de Invictus**
- **Proceso completo se REINICIA desde el inicio**

---

### 🔐 Ejemplo 5: OTP No Validado

**Request:**
```json
POST /api/proceso_desembolso
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "guid": "b2c3d4e5-f6g7-8901-bcde-fg2345678901",
  "id_linea_credito": 27375,
  "plazo_meses": 4,
  "valor_total": 500000,
  "valor_cobros": 12050,
  "valor_a_pagar_cliente": 487950,
  "plaza_empresa": 50
}
```

**Response:**
```json
HTTP/1.1 200 OK
Content-Type: application/json

{
  "status": "otp_not_validated",
  "mensaje": "Debe validar el código OTP antes de ejecutar el desembolso.",
  "tiempo_desde_validacion": null
}
```

**Acción en Invictus:**
- Modal **NARANJA** con texto: **"Debe validar el código OTP antes de ejecutar el desembolso"**
- Botón **[CERRAR]**
- Al cerrar → **PERMANECE en Sección 3: Realizar Desembolso**
- Usuario debe regresar y completar la validación OTP

---

### ❌ Ejemplo 6: Crédito No Disponible (Vencido)

**Request:**
```json
POST /api/proceso_desembolso
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "guid": "b2c3d4e5-f6g7-8901-bcde-fg2345678901",
  "id_linea_credito": 27375,
  "plazo_meses": 4,
  "valor_total": 500000,
  "valor_cobros": 12050,
  "valor_a_pagar_cliente": 487950,
  "plaza_empresa": 50
}
```

**Response:**
```json
HTTP/1.1 200 OK
Content-Type: application/json

{
  "status": "credit_not_available",
  "mensaje": "El crédito no está disponible para desembolso.",
  "razon": "credito_vencido",
  "detalles": "El crédito ha superado el plazo de 30 días desde su aprobación."
}
```

**Acción en Invictus:**
- Modal **NARANJA** con texto: **"El crédito no está disponible para desembolso. El crédito ha superado el plazo de 30 días desde su aprobación."**
- Botón **[CERRAR]**
- Al cerrar → **REGRESA a pantalla principal de Invictus**
- **Proceso completo se REINICIA desde el inicio**

---

## Integración en Invictus

### Sección 3: Realizar Desembolso

Esta sección se habilita después de ejecutar exitosamente el **Servicio 4: Cálculo de Desembolso**.

**Campos Mostrados (Solo Lectura):**

| Campo | Descripción | Ejemplo |
|-------|-------------|---------|
| **Valor Total** | Valor total del crédito solicitado | $500,000 |
| **Valor Cobros** | Suma de todos los descuentos aplicados | $12,050 |
| **Plazo (Meses)** | Plazo seleccionado del crédito | 4 meses |
| **Valor a Pagar al Cliente** | **Monto final a entregar físicamente** | **$487,950** |

**Nota importante:** El campo "Valor a Pagar al Cliente" debe estar **destacado visualmente** (negrilla, tamaño mayor, color diferente) ya que es el monto exacto que el asesor debe entregar en efectivo.

**Botones Habilitados:**

1. **[Cancelar]**
    - **Acción:** Cancela la transacción completa
    - **Comportamiento:** Lleva a la fuerza de ventas a la pantalla inicial de Invictus
    - **Resultado:** NO guarda información, NO registra transacción
    - **Confirmación:** Se recomienda mostrar confirmación antes de cancelar

2. **[Limpiar]**
    - **Acción:** Limpia la información de todas las secciones
    - **Comportamiento:** Limpia campos de Sección 1, 2 y 3
    - **Resultado:** Permanece en la opción de desembolso
    - **Confirmación:** Se recomienda mostrar confirmación antes de limpiar

3. **[Pagar]**
    - **Acción:** Ejecuta el desembolso final
    - **Comportamiento:** Consume este servicio (Ejecución de Desembolso)
    - **Estado:** HABILITADO solo si todos los pasos anteriores fueron exitosos
    - **Confirmación:** Se recomienda mostrar confirmación antes de ejecutar

---

### Flujo de Interacción con Botón [Pagar]

```
1. Usuario presiona [Pagar]
   ↓
2. [OPCIONAL] Sistema muestra confirmación:
   "¿Está seguro de ejecutar el desembolso de $487,950?"
   [Cancelar] [Confirmar]
   ↓
3. Usuario confirma
   ↓
4. Sistema muestra indicador de carga
   "Procesando desembolso..."
   ↓
5. Invictus consume servicio de Ejecución de Desembolso
   ↓
6. Según respuesta:
   
   a) success → Modal verde con valor a entregar
                Ejecuta acciones internas (SIGA, caja, contabilidad, impresión)
                Regresa a pantalla inicial
   
   b) error (401) → Modal rojo de autenticación
                    Permanece en Sección 3
   
   c) error (404) → Modal naranja de transacción
                    Permanece en Sección 3
   
   d) already_disbursed → Modal naranja
                          Regresa a pantalla inicial
   
   e) credit_not_available → Modal naranja
                             Regresa a pantalla inicial
   
   f) otp_not_validated → Modal naranja
                          Permanece en Sección 3
```

---

### Acciones Internas de Invictus (Después de Respuesta Exitosa)

Según la HUE 006, cuando la respuesta es `success`, Invictus debe ejecutar automáticamente:

#### 1. Replicar en SIGA y Contabilidad
- Enviar la transacción al sistema SIGA
- Registrar los movimientos contables correspondientes
- Asegurar sincronización entre sistemas

#### 2. Afectar la Caja de la Fuerza de Ventas
- **Descontar del efectivo disponible:** `valor_a_pagar_cliente` ($487,950)
- Actualizar el saldo de caja del punto de venta
- Registrar el movimiento de egreso de efectivo
- Fecha y hora del movimiento

#### 3. Afectar la Cartera de la Fuerza de Ventas
- Registrar el desembolso en la cartera del vendedor
- Actualizar estadísticas y métricas del vendedor
- Registrar la operación crediticia

#### 4. Imprimir Colilla de Transacción

**Información que debe contener la colilla:**
