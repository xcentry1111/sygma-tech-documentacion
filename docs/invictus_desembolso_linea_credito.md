# 📘 Manual de Integración API: Cálculo de Desembolso

## Descripción del Servicio

Este servicio permite calcular los descuentos, cobros y el valor final a pagar al cliente para un desembolso de crédito. El servicio recibe la información de la línea de crédito seleccionada, el plazo y el valor deseado por el cliente, y retorna el desglose completo de los montos aplicables, incluyendo todos los descuentos que TESEO aplicará al desembolso.

---

## Flujo del Proceso

### Contexto General

Este servicio es el **cuarto paso** del flujo de desembolso, ejecutándose después de que el usuario confirma la selección de línea, plazo y valor en el modal de confirmación:

```
Servicio 1: Validación de Crédito Vigente
     ↓
Servicio 2: Validación de OTP
     ↓ (retorna success + líneas de crédito)
Sección 2: Datos Crédito (Selección UI)
     ↓ (usuario selecciona línea, plazo, valor)
     ↓ (presiona [Calcular Desembolso])
Modal de Confirmación
     ↓ (usuario selecciona [Aceptar])
Servicio 4: Cálculo de Desembolso (este documento) ← ESTAMOS AQUÍ
     ↓ (calcula descuentos y valor final)
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
4. Usuario selecciona [Aceptar]
   ↓
5. Sistema consume este servicio (TESEO)
   ↓
6. Servicio ejecuta cálculo de descuentos
   ↓
7. Respuesta según resultado:
   - exitosa → Habilita Sección 3 con valores calculados
   - error → Muestra modal de error y regresa a inicio
```

---

## Información Técnica

### Tipo de Servicio

**Método HTTP:** `POST`

---

### URL de Integración

| Ambiente | URL |
|----------|-----|
| **Pruebas (QA)** | `https://testing-sygma.com/api/calculo_desembolso` |
| **Producción** | `POR DEFINIR` |

---

### Headers Requeridos

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

### Cuerpo de la Solicitud

La solicitud debe enviarse en formato **raw JSON** con los siguientes campos:

#### Campos Obligatorios

| Campo | Tipo | Longitud | Requerido | Descripción |
|-------|------|----------|-----------|-------------|
| `tiposdocumento_id` | string | - | ✅ | ID del tipo de documento según catálogo |
| `identificacion` | string | variable | ✅ | Número de identificación del usuario |
| `guid` | string | UUID | ✅ | UUID de la transacción del proceso actual |
| `linea_credito_id` | string | - | ✅ | Identificador de la línea de crédito seleccionada |
| `plazo_meses` | integer | - | ✅ | Plazo en meses seleccionado por el cliente |
| `valor_desembolso` | number | - | ✅ | Valor del desembolso solicitado |

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
| `linea_credito_id` | Sección 2: Datos Crédito → Línea seleccionada (checkbox) | Al seleccionar línea |
| `plazo_meses` | Sección 2: Datos Crédito → Campo [Confirme Plazo] | Al confirmar plazo |
| `valor_desembolso` | Sección 2: Datos Crédito → Campo [Confirme Valor] | Al confirmar valor |

#### Ejemplo de Request

```json
{
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "guid": "b2c3d4e5-f6g7-8901-bcde-fg2345678901",
  "linea_credito_id": "linea_digital_001",
  "plazo_meses": 4,
  "valor_desembolso": 500000
}
```

---

## Response

### Estructura de Respuesta Exitosa

**Código HTTP:** `200 OK`

**Status:** `"exitosa"`

```json
{
  "status": "exitosa",
  "datos": {
    "guid": "b2c3d4e5-f6g7-8901-bcde-fg2345678901",
    "mensaje": "Cálculo de desembolso realizado exitosamente.",
    "nombre_cliente": "Fernando Osorio",
    "linea_credito": "Línea Digital",
    "plazo_meses": 4,
    "valor_total": 500000,
    "valor_cobros": 12050,
    "valor_a_pagar_cliente": 487950,
    "plaza_empresa": 50,
    "detalles_descuentos": [
      {
        "concepto": "IVA",
        "valor": 8000,
        "descripcion": "Impuesto al Valor Agregado sobre comisiones"
      },
      {
        "concepto": "Seguro",
        "valor": 4000,
        "descripcion": "Seguro de vida y desempleo"
      },
      {
        "concepto": "Comisión",
        "valor": 50,
        "descripcion": "Comisión administrativa"
      }
    ],
    "fecha_calculo": "2025-10-10 15:45:30"
  }
}
```

#### Descripción de Campos de Respuesta

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `status` | string | Indicador del resultado: `"exitosa"` |
| `datos` | object | Objeto con toda la información calculada |
| `datos.guid` | string | Identificador único de la transacción (mismo del request) |
| `datos.mensaje` | string | Mensaje de confirmación del cálculo |
| `datos.nombre_cliente` | string | Nombre completo del cliente (confirmación) |
| `datos.linea_credito` | string | Nombre de la línea de crédito seleccionada |
| `datos.plazo_meses` | integer | Plazo en meses (confirmación) |
| `datos.valor_total` | number | Valor total solicitado por el cliente |
| `datos.valor_cobros` | number | Suma de todos los descuentos/cobros aplicados |
| `datos.valor_a_pagar_cliente` | number | **Monto final que recibirá el cliente físicamente** |
| `datos.plaza_empresa` | number | Código de la plaza/empresa donde se realiza el desembolso |
| `datos.detalles_descuentos` | array | Array con el desglose de cada cobro/descuento |
| `datos.detalles_descuentos[].concepto` | string | Nombre del cobro (IVA, Seguro, Comisión, etc.) |
| `datos.detalles_descuentos[].valor` | number | Monto del cobro individual |
| `datos.detalles_descuentos[].descripcion` | string | Descripción detallada del cobro |
| `datos.fecha_calculo` | string | Timestamp del cálculo (formato: YYYY-MM-DD HH:MM:SS) |

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
- Mostrar mensaje modal rojo: **"Token de autorización inválido o ausente"**
- Botón **[CERRAR]** para cerrar el modal
- **Cerrar modal → REGRESA a la pantalla principal de Invictus**
- Usuario debe **reiniciar la transacción de desembolso**
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
- Mostrar mensaje modal naranja: **"Transacción no encontrada o inválida"**
- Botón **[CERRAR]** para cerrar el modal
- **Cerrar modal → REGRESA a la pantalla principal de Invictus**
- Usuario debe **reiniciar la transacción de desembolso**

---

### Error 3: Campos Requeridos Faltantes

**Código HTTP:** `400 Bad Request`

**Response:**
```json
{
  "status": "error",
  "errors": [
    "El campo linea_credito_id es obligatorio.",
    "El campo plazo_meses es obligatorio."
  ]
}
```

---

## Tabla Resumen de Respuestas

| # | Condición | HTTP Code | status | Mensaje | Comportamiento Invictus | Reinicia Proceso |
|---|-----------|-----------|--------|---------|------------------------|------------------|
| 1 | Cálculo exitoso | 200 | `exitosa` | "Cálculo de desembolso realizado exitosamente." | Habilita Sección 3 con valores | No |
| 2 | Token inválido/ausente | 401 | `error` | "Token de autorización inválido o ausente." | Modal rojo, regresa a inicio | **SÍ** |
| 3 | Transacción no encontrada | 404 | `error` | "Transacción no encontrada o inválida." | Modal naranja, regresa a inicio | **SÍ** |
| 4 | Campos faltantes | 400 | `error` | Lista de campos obligatorios | - | - |

---

## Ejemplos Completos

### ✅ Ejemplo 1: Cálculo Exitoso

**Request:**
```json
POST /api/calculo_desembolso
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "guid": "b2c3d4e5-f6g7-8901-bcde-fg2345678901",
  "linea_credito_id": "linea_digital_001",
  "plazo_meses": 4,
  "valor_desembolso": 500000
}
```

**Response:**
```json
HTTP/1.1 200 OK
Content-Type: application/json

{
  "status": "exitosa",
  "datos": {
    "guid": "b2c3d4e5-f6g7-8901-bcde-fg2345678901",
    "mensaje": "Cálculo de desembolso realizado exitosamente.",
    "nombre_cliente": "Fernando Osorio",
    "linea_credito": "Línea Digital",
    "plazo_meses": 4,
    "valor_total": 500000,
    "valor_cobros": 12050,
    "valor_a_pagar_cliente": 487950,
    "plaza_empresa": 50,
    "detalles_descuentos": [
      {
        "concepto": "IVA",
        "valor": 8000,
        "descripcion": "Impuesto al Valor Agregado sobre comisiones"
      },
      {
        "concepto": "Seguro",
        "valor": 4000,
        "descripcion": "Seguro de vida y desempleo"
      },
      {
        "concepto": "Comisión",
        "valor": 50,
        "descripcion": "Comisión administrativa"
      }
    ],
    "fecha_calculo": "2025-10-10 15:45:30"
  }
}
```

**Acción en Invictus:**
1. Habilita **Sección 3: Realizar Desembolso**
2. Muestra valores calculados en los campos:
   - Valor Total: **$500,000**
   - Valor Cobros: **$12,050**
   - Plaza Empresa: **50**
   - **Valor a Pagar al Cliente: $487,950** ← **DESTACADO (monto a entregar físicamente)**
3. Muestra tabla de desglose de descuentos:
   ```
   IVA         $8,000    Impuesto al Valor Agregado
   Seguro      $4,000    Seguro de vida y desempleo
   Comisión    $50       Comisión administrativa
   ```
4. **BLOQUEA** Sección 1 y Sección 2 (no editables)
5. Usuario NO debe entregar dinero todavía (espera completar Sección 3)

---

### 🔐 Ejemplo 2: Error de Autenticación

**Request:**
```json
POST /api/calculo_desembolso
Authorization: Bearer token_invalido_expirado
Content-Type: application/json

{
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "guid": "b2c3d4e5-f6g7-8901-bcde-fg2345678901",
  "linea_credito_id": "linea_digital_001",
  "plazo_meses": 4,
  "valor_desembolso": 500000
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
- Modal **ROJO** con texto: **"Token de autorización inválido o ausente"**
- Botón **[CERRAR]**
- Al cerrar → **REGRESA a pantalla principal de Invictus**
- **Proceso de desembolso se REINICIA desde el principio**

---

### ❌ Ejemplo 3: Transacción No Encontrada

**Request:**
```json
POST /api/calculo_desembolso
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json

{
  "tiposdocumento_id": "1",
  "identificacion": "88282828",
  "guid": "guid-invalido-12345",
  "linea_credito_id": "linea_digital_001",
  "plazo_meses": 4,
  "valor_desembolso": 500000
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
- Modal **NARANJA** con texto: **"Transacción no encontrada o inválida"**
- Botón **[CERRAR]**
- Al cerrar → **REGRESA a pantalla principal de Invictus**
- **Proceso de desembolso se REINICIA desde el principio**

---

## Integración en Invictus

### Captura de Datos para el Request

**Flujo de captura:**

```javascript
// 1. Capturar datos de Sección 1 (guardados en estado)
const tiposdocumento_id = seccion1.tipoDocumento;
const identificacion = seccion1.numeroIdentificacion;

// 2. Obtener GUID del proceso actual (del último servicio OTP)
const guid = procesoOTP.guid; // Del servicio 2 o 3

// 3. Capturar datos de Sección 2 (línea seleccionada)
const lineaSeleccionada = seccion2.lineas.find(linea => linea.seleccionada);
const linea_credito_id = lineaSeleccionada.id;
const plazo_meses = lineaSeleccionada.confirme_plazo;
const valor_desembolso = lineaSeleccionada.confirme_valor;

// 4. Construir request
const requestData = {
  tiposdocumento_id,
  identificacion,
  guid,
  linea_credito_id,
  plazo_meses,
  valor_desembolso
};
```

### Consumo del Servicio

**Momento exacto de consumo:**
- Usuario presiona [Calcular Desembolso]
- Sistema muestra Modal de Confirmación
- Usuario presiona [Aceptar] ← **AQUÍ se consume el servicio**

```javascript
async function calcularDesembolso() {
  try {
    const response = await fetch('https://testing-sygma.com/api/calculo_desembolso', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(requestData)
    });

    const data = await response.json();

    if (response.status === 200 && data.status === 'exitosa') {
      // Éxito: Habilitar Sección 3
      habilitarSeccion3(data.datos);
      bloquearSecciones1y2();
    } else if (response.status === 401) {
      // Error de autenticación
      mostrarModalError('rojo', data.mensaje);
      regresarAInicio();
    } else if (response.status === 404) {
      // Transacción no encontrada
      mostrarModalError('naranja', data.mensaje);
      regresarAInicio();
    }
  } catch (error) {
    console.error('Error al calcular desembolso:', error);
    mostrarModalError('rojo', 'Error al comunicarse con el servidor');
  }
}
```

### Procesamiento de la Respuesta Exitosa

```javascript
function habilitarSeccion3(datos) {
  // 1. Poblar campos de Sección 3
  document.getElementById('valor_total').value = formatearMoneda(datos.valor_total);
  document.getElementById('valor_cobros').value = formatearMoneda(datos.valor_cobros);
  document.getElementById('plaza_empresa').value = datos.plaza_empresa;
  document.getElementById('valor_a_pagar_cliente').value = formatearMoneda(datos.valor_a_pagar_cliente);

  // 2. Mostrar desglose de descuentos
  const tablaDescuentos = document.getElementById('tabla_descuentos');
  datos.detalles_descuentos.forEach(descuento => {
    const fila = `
      <tr>
        <td>${descuento.concepto}</td>
        <td>${formatearMoneda(descuento.valor)}</td>
        <td>${descuento.descripcion}</td>
      </tr>
    `;
    tablaDescuentos.innerHTML += fila;
  });

  // 3. Hacer visible Sección 3
  document.getElementById('seccion_3').style.display = 'block';

  // 4. Habilitar botones de Sección 3
  document.getElementById('btn_pagar').disabled = false;
}

function bloquearSecciones1y2() {
  // Deshabilitar todos los inputs de Sección 1 y 2
  document.querySelectorAll('#seccion_1 input, #seccion_2 input').forEach(input => {
    input.disabled = true;
    input.style.backgroundColor = '#f0f0f0';
  });

  // Ocultar botón Calcular Desembolso
  document.getElementById('btn_calcular_desembolso').style.display = 'none';
}
```

---

## Notas Importantes

### 📋 Reglas Críticas

1. ✅ **Captura de datos:** Los valores se obtienen de los campos **confirmados** ([Confirme Plazo], [Confirme Valor])
2. ✅ **GUID actual:** Se usa el GUID retornado por el último servicio OTP (Servicio 2 o 3)
3. ✅ **Bloqueo post-cálculo:** Una vez exitoso, Secciones 1 y 2 quedan **bloqueadas** (no editables)
4. ✅ **Valor destacado:** El campo `valor_a_pagar_cliente` es el **más importante** (monto físico a entregar)
5. ✅ **Sin entrega todavía:** El asesor **NO debe entregar dinero** en este punto (espera Sección 3)

### 🔒 Restricciones de Modificación

**Después de response exitosa:**
- ❌ NO modificar Sección 1: Datos Cliente
- ❌ NO modificar Sección 2: Datos Crédito
- ❌ NO cambiar línea seleccionada
- ❌ NO cambiar plazo ni valor
- ✅ Para hacer cambios → Usuario debe **cancelar transacción completa** y **reiniciar proceso**

### ⚙️ Ambiente de Pruebas

**Configuración:**
- Base URL: `https://testing-sygma.com/api`
- Endpoint Login: `/login`
- Endpoint Cálculo: `/calculo_desembolso`
- Usuario: `ws_invictus`
- Password: `g3z0OmJP7?@(*`

---

## Flujo Completo de Desembolso

```
Servicio 1: Validación de Crédito Vigente
     ↓
Servicio 2: Validación de OTP
     ↓ (retorna líneas de crédito)
Sección 2: Datos Crédito (UI)
     ↓ (selección de línea, plazo, valor)
Servicio 4: Cálculo de Desembolso (este documento)
     ↓ (calcula descuentos y valor final)
Sección 3: Realizar Desembolso
     ↓ (confirmación y entrega física)
Servicio 5: Ejecución de Desembolso
     ↓
Completado
```

