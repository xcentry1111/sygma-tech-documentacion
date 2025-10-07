# Servicio para consultar municipios por descripción

**Descripción:** Este servicio permite consultar municipios filtrando por una parte de la descripción. El resultado contiene el ID, descripción y el código DANE del municipio encontrado.

**Tipo de Servicio:** POST

---

## **URL de Integración**

- **Prueba:** `https://testing-sygma.com/api/consulta_municipios`
- **Producción:** `POR_DEFINIR/api/consulta_municipios`

---

## **Headers**

La solicitud debe incluir los siguientes encabezados obligatorios:

- **Accept:** `application/json`
- **Content-Type:** `application/json`
- **Authorization:** `Bearer ${token}`

---

## **Consideraciones**

- El parámetro **descripcion** es obligatorio y corresponde al texto que se desea buscar dentro del campo de descripción del municipio.

Si el parámetro `descripcion` no se envía, el servicio responderá con un error.

---

## **Cuerpo de la Solicitud (raw)**

``````json
{
  "descripcion": "neiva"
}
``````



### **Ejemplo Respuesta Succes**

``````json

  {
    "id": 10593,
    "descripcion": "HUILA - NEIVA | COLOMBIA",
    "codigo_dane": 41001
  }

``````

### **Ejemplo Respuesta Succes**

``````json
{
  "status": false,
  "message": "El parámetro :descripcion es requerido",
  "code": 400
}
``````


### **Respuesta Token Invalido**

``````json
{
  "status": false,
  "message": "Token Inválido",
  "details": "Signature has expired",
  "code": 400
}
``````
