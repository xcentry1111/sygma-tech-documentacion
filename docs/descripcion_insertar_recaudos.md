# Descripción del Servicio

## **Introducción**
La finalidad de este servicio es registrar un recaudo asociado a una obligación a través de la API expuesta, siguiendo una estructura definida.

## **Funcionamiento**
- Recibe una solicitud con datos en formato JSON.
- Valida que todos los campos obligatorios estén presentes.
- Valida que tenga permisos al consumo del servicio.
- Procesa la información según la configuración establecida.
- Devuelve el plan de pagos generado en respuesta.

## **Validaciones**
Para garantizar la integridad y coherencia de los datos, el servicio realiza diversas validaciones antes de procesar la solicitud. Si algún dato es inválido o falta información requerida, se generará un mensaje de error con la descripción del problema.

## **Formato de Entrada**
Los datos deben enviarse en formato JSON, siguiendo la estructura establecida.

- **Ejemplo de solicitud** 
```json
{
  "tipo_servicio": "INSERTAR_RECAUDO", // OBLIGATORIO
  "personasobligacion_id": "193833", // OBLIGATORIO
  "fecha": "02-07-2024", // DD-MM-YYYY - OBLIGATORIO - FORMATO
  "valor": "10000", // OBLIGATORIO
  "sucursal": "TENJO", // Sede desde donde se envia el servicio
  "codigo_transaccion": "2763637388",
  "usuario": "USUARIO DE LA TRANSACCION",
  "observacion": "PAGO REALIZADO POR LA PLATAFORMA TESEO"
}
```