# Descripción del Servicio

## **Introducción**
La finalidad de este servicio es reversar un recaudo asociado a una obligación a través de la API expuesta, siguiendo una estructura definida.

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
  "tipo_servicio": "REVERSAR_RECAUDO", // OBLIGATORIO
  "recaudo_id": "2783288828", // OBLIGATORIO
  "observacion": "SE REVERSA POR MOTIVOS DE PRUEBAS" // OBLIGATORIO - SE DEBE DE JUSTIFICAR PORQUE SE DESEA REVERSAR
}
```