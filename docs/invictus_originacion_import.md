# Originación Invictus (`ori_invictus`)

## Resumen
Crea o retoma una solicitud Invictus en TESEO (`Formulario`, portafolio **10053**, `tipo: INVICTUS`). No envía OTP. Devuelve `guid` (`transaction_id_teseo`) para `notificacion_canal`, o redirige a firma / KYC / desembolso según estado.

Mapa: [Flujo Invictus](invictus_flujo.md).

## Objetivo
Registrar al cliente para originación digital (solo cédula de ciudadanía) y dejar la solicitud lista para OTP, o informar que ya hay cupo, firma pendiente o KYC.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/ori_invictus`
- **Controller**: `Api::InvictusController#create`
- **Ambientes**:
  - **Testing**: `https://testing-sygma.com/api/ori_invictus`
  - **Producción**: `POR DEFINIR`

## Autenticación
- **Tipo**: JWT Bearer (mismo `/api/login`).
- **Header**: `Authorization: Bearer <token>`
- **401**: `{ "status": "error", "mensaje": "Token de autorización inválido o ausente" }`

## Headers
- **Authorization**: `Bearer <token>` (obligatorio)
- **Accept**: `application/json`
- **Content-Type**: `application/json`

## Request

Cuerpo en clave **`datos`**. Campos requeridos: CSV del parámetro `CAMPOS VALIDACION ORIGINACION INVICTUS` **más** `fecha_nacimiento`. Código exige **`tiposdocumento_id = "1"` (CC)**. CE/NIT/PA/PEP **no** aplican en este endpoint.

### Campos (los que el código lee siempre)

| Campo | Tipo | Requerido | Descripción |
|------|------|-----------|-------------|
| datos | object | sí | Wrapper. Sin él → 422. |
| datos.tiposdocumento_id | string | sí | Solo `"1"` (CC). |
| datos.identificacion | string | sí | Cédula. |
| datos.fecha_nacimiento | string | sí | Edad / validaciones. |
| datos.email | string | sí* | *Si está en el CSV de parámetros. |
| datos.celular | string | sí* | Normalizado en TESEO. |
| datos.fecha_expedicion | string | sí* | |
| datos.primer_nombre / segundo_nombre / primer_apellido / segundo_apellido | string | sí* | |
| datos.nombre_red, oficina, nombre_oficina, usuario_transaccion, nombre_usuario_transaccion | string | sí* | Trazabilidad origen. |

\*Obligatoriedad exacta = parámetro `CAMPOS VALIDACION ORIGINACION INVICTUS`. El hash se persiste con `permit!` en `Formulario`.

### Ejemplo
```json
{
  "datos": {
    "tiposdocumento_id": "1",
    "identificacion": "88282828",
    "fecha_expedicion": "1984-07-12",
    "primer_nombre": "MARIO",
    "segundo_nombre": "ANTONIO",
    "primer_apellido": "MATURANA",
    "segundo_apellido": "MARTINEZ",
    "fecha_nacimiento": "1988-05-15",
    "email": "prueba@example.com",
    "celular": "3016795090",
    "nombre_red": "PRUEBA",
    "oficina": "OFICINA NRO 1",
    "nombre_oficina": "OFICINA NRO 1 - LAURELES",
    "usuario_transaccion": "USUARIO API",
    "nombre_usuario_transaccion": "USUARIO API"
  }
}
```

## Proceso interno (orden real)

1. Auditoría inicio (`Formularioevaluacion`).
2. `CredintegralSolicitudElegibilidadService`: mora y líneas digital/rotativo.
3. Si `Persona` con `cupo_disponible > 0` → camino cupo (`CON_CUPO` / conflicto / desembolso).
4. Cancela `CON_CUPO` viejo.
5. Lista restrictiva permanente `estado_lista_restritiva = BLOQUEADO`.
6. Lista negra (`Listascontrol`).
7. `RECHAZADO` reciente: cooldown (`InvictusTruoraService.dias_bloqueo_por_razon`: fraude/otros 30d, intentos KYC 1d).
8. Consistencia email/celular vs solicitudes vivas.
9. Si existe `EN_VERIFICACION` → actualiza contacto + `InvictusTruoraService.iniciar_verificacion` → **HTTP 202**.
10. Si `PENDIENTE` mismo email+celular dentro de `horas_expiracion_solicitud_pendiente` (default 2h) → mismo `guid`, **200**.
11. Cancela `PENDIENTE` expirado.
12. Si `APROBADO_PENDIENTE_FIRMA` → **HTTP 409** con `status: "success"` (ir a firma).
13. Conflicto email/celular con otra solicitud viva → 409.
14. Crea `Formulario` `PENDIENTE`, genera OTP **sin enviarlo**, asigna `guid`.

## Servicios / componentes

- `CredintegralSolicitudElegibilidadService`
- `InvictusTruoraService` (retoma KYC)
- `Listascontrol` / flags lista restrictiva
- Modelo `Formulario`, `Persona`
- Auditoría `Formularioevaluacion`

## Responses

### 200 — Alta o retoma PENDIENTE
```json
{
  "status": "success",
  "datos": {
    "guid": "959ed262dc803739a937",
    "mensaje": "Registro exitoso..."
  }
}
```
**Siguiente:** `POST /api/notificacion_canal` con ese `guid`.

### 202 — KYC pendiente (retoma EN_VERIFICACION)
```json
{
  "status": "success",
  "datos": {
    "guid": "...",
    "mensaje": "Requiere verificación de identidad..."
  }
}
```
**Siguiente:** completar Truora. No firma. Ver [Truora KYC](invictus_truora_kyc.md).

### 409 — Firma pendiente (`status: success`)
Ya `APROBADO_PENDIENTE_FIRMA`. **Siguiente:** `POST /api/validacion_firma_digital`.

### 409 — Cupo / contacto (`status: error`)
Cupo existente, email/celular de otra solicitud viva, o ambas líneas. **Siguiente:** desembolso si hay cupo, o usar datos de la solicitud viva.

### 422
Validación: falta `datos`, no es CC, mora, líneas, campos del CSV.

### 423
Políticas: lista negra / restrictiva `BLOQUEADO` / rechazo vigente. No reintentar originación hasta que aplique la regla.

### 401
Token ausente o inválido.

### 500
`{ "status": "error", "errors": ["Error interno"] }` (puede incluir `debug` en algunos ambientes).

## Flujo anterior
`POST /api/login` → Authorize.

## Flujo posterior
Normal: `notificacion_canal` → `validar_otp` → firma.  
Atajos: firma, KYC, o desembolso según respuesta.

## Errores comunes

### 401 Unauthorized
```json
{
  "status": "error",
  "mensaje": "Token de autorización inválido o ausente"
}
```

## Notas / Consideraciones
- OTP **no** se envía aquí. `notificacion_canal` es obligatorio en camino feliz.
- Docs antiguas listaban CE/NIT/PA/PEP: **incorrecto para este endpoint**.
- HTTP 409 + `status: success` es intencional en código (firma pendiente).

## Changelog
- **2026-08-26**: Alineado al código TESEO (`InvictusController#create`).
