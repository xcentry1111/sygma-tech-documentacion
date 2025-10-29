# Descripción del Servicio

## **Introducción**
Este servicio recibe y procesa información en formato JSON para su integración en la plataforma **TESEO**. Su propósito principal es permitir la creación o actualización de créditos de manera eficiente y estructurada.

## **Funcionamiento**
- Recibe datos en formato JSON.
- Valida que todos los campos obligatorios estén presentes.
- Carga la información en **TESEO** para la creación o actualización del crédito.

## **Validaciones**
El servicio implementa validaciones para garantizar la integridad y coherencia de los datos, asegurando que el proceso se realice de manera correcta y sin errores.

## **Formato de Entrada**
Los datos deben enviarse en formato JSON con la siguiente estructura:

```json
 {
  "datostecfinanza": {
    "nro_documento": "129905111 ",
    "dir_residencia": "CRA 50 60 16"
  }
}
```
