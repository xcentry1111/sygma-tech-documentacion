# Aprobación de línea de crédito y monto (Invictus)

## Resumen
Registra la decisión del usuario sobre una línea de crédito. Solo permite dos estados: **APROBADO** o **DESISTE**.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/validar_linea_credito`
- **Ambientes**:
  - **Pruebas**: `https://testing-sygma.com/api/validar_linea_credito`
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

### 🔸 Campos Obligatorios

- `linea_credito_id`: El id de la linea de credito define que linea fue seleccionada.
- `estado`: El estado define cual fue la decision que tomo el usuario , solo permite dos opciones **APROBADO** o **DESISTE**.
- `guid`: ID único de la transacción (internamente vinculado al cliente).

> ⚠️ **Nota:** No es necesario enviar el número de documento, ya que el sistema lo obtiene automáticamente con el `guid`.

---

## 📦 Ejemplo de Body

```json
{
  "linea_credito_id": 100,
  "estado": "APROBADO",
  "guid": "68406a6a2d9aa64766060ee2"
}
```

### ❗ Respuesta Exitosa 

```js
{
  "status": "success",
  "mensaje": "Tu linea de credito ha sido APROBADA con Exito!!",
  "guid": "68406a6a2d9aa64766060ee2"        
}

```


### 📊 Tabla de estados

| Estado                    | Significado breve                                                                | Acción TESEO                                                                                                                                                                                                                           |
|---------------------------|----------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **APROBADO**              | Si es APROBADO, el flujo continua normal, porque el usuario aprobo la linea de credito | Retorna estado success                                                                                                                                                                                                                 
| **DESISTE**               | Si es DESISTE, el usuario no APROBO LA LINEA DE CREDITO                          | Se regitra como DESISTE, pero debe quedar en un contenedor durante 30 días, por si el usuario se dirige antes de cumplir los 30 dias, no se debe de consultar ante **EXPIRIAM** y decirle que tiene un credito pendiente de APROBACION |
---

### ❗ Respuesta Rechazado 

```js
{
  "status": "success",
  "mensaje": "Tu linea de credito fue DESISTIDA con Exito!!",
  "guid": "68406a6a2d9aa64766060ee2"
}

```

#### ❗ Respuesta Solicitud Error

```json
{
  "status": "error",
  "mensaje": "No fue posible obtener la decisión del proveedor."
}
```

#### ❗ Ejemplo de Error por Token Ausente o Inválido

```json
{
  "status": "error",
  "mensaje": "Token de autorización inválido o ausente"
}
```


#### ❗ Ejemplo de Error estado o parametro

```json
{
  "status": "error",
  "mensaje": "No enviaste un parametro valido"
}
```

