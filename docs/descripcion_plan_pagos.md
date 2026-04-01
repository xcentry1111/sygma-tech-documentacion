# Generar plan de pagos

## Resumen
Genera un plan de pagos de crédito a partir de un request JSON, calculándolo según la parametrización definida para cada cliente.

## Endpoint
- **Método**: `POST`
- **Ruta**: `POR_DEFINIR`
- **Ambientes**:
  - **Prueba**: `POR_DEFINIR`
  - **Producción**: `POR_DEFINIR`

## Autenticación
- **Tipo**: `Bearer token`
- **Header**: `Authorization: Bearer <token>`

## Headers
- **Accept**: `application/json`
- **Content-Type**: `application/json`

## Request

### Validaciones
- Valida que todos los campos obligatorios estén presentes.
- Si algún dato es inválido o falta información requerida, se retorna un error con la descripción del problema.

### Body (JSON)

#### Campos
| Campo | Tipo | Requerido | Descripción |
|------|------|-----------|-------------|
| tipo_servicio | string | sí | Debe enviarse `API_PLAN_PAGOS`. |
| valor | string | sí | Valor base del cálculo. |
| fecha | string | sí | Fecha del cálculo (formato según integración). |
| tasa | string | sí | Tasa para el cálculo. |
| plazo | number | sí | Plazo del crédito. |

#### Ejemplo
```json
{
  "tipo_servicio": "API_PLAN_PAGOS",
  "valor": "3000000",
  "fecha": "2025-02-06",
  "tasa": "20.04",
  "plazo": 10
}
```

## Responses
`POR_DEFINIR`

## Errores comunes
`POR_DEFINIR`
