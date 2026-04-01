# Estándar de documentación de APIs (Sygma)

Este estándar define una estructura única para documentar endpoints/servicios. La intención es que **todas** las APIs tengan el mismo orden de secciones, el mismo nivel de detalle y convenciones consistentes.

## Estructura obligatoria (por archivo)

1. **Título** (H1)
2. **Resumen**
3. **Endpoint**
4. **Autenticación**
5. **Headers**
6. **Request**
7. **Responses**
8. **Errores comunes**
9. **Notas / Consideraciones**
10. **Changelog** (opcional, pero recomendado)

## Convenciones

- **Títulos**: usar `#` para el título principal y `##` para secciones.
- **Nombres**: consistentes y explícitos: “Request”, “Responses”, “Errores comunes”.
- **JSON**: ejemplos siempre en bloque ` ```json ` (sin comentarios inline `//` dentro del JSON; si necesitas aclaración, ponerla en texto o en tabla).
- **Ambientes**: si hay URLs distintas, documentar `testing` y `producción`.
- **Tipos**: cuando se conozcan, documentar tipo de dato (`string`, `number`, `boolean`, `object`, `array`) y formato (`date`, `date-time`).
- **Obligatoriedad**: expresar como **Requerido: sí/no** y si aplica: **Condicional** (depende de X).
- **Códigos HTTP**: documentar el HTTP status esperado (200/201/400/401/403/404/422/500) y el cuerpo.

## Plantilla (copiar/pegar)

```markdown
# <Nombre del servicio / endpoint>

## Resumen
<Qué hace, en 1-3 líneas.>

## Endpoint
- **Método**: `POST|GET|PUT|PATCH|DELETE`
- **Ruta**: `/api/...`
- **Ambientes**:
  - **Testing**: `<url-base>`
  - **Producción**: `<url-base>`

## Autenticación
- **Tipo**: `Bearer token`
- **Header**: `Authorization: Bearer <token>`

## Headers
- **Accept**: `application/json`
- **Content-Type**: `application/json`

## Request

### Body (JSON)

#### Campos
| Campo | Tipo | Requerido | Descripción |
|------|------|-----------|-------------|
| tipo_servicio | string | sí | Identificador funcional del servicio. |

#### Ejemplo
```json
{
  "tipo_servicio": "..."
}
```

## Responses

### 200 OK (Success)
```json
{
  "status": "success"
}
```

## Errores comunes

### 400 Bad Request
```json
{
  "status": "error",
  "message": "..."
}
```

### 401 Unauthorized (Token inválido/expirado)
```json
{
  "status": false,
  "message": "Token Inválido",
  "details": "...",
  "code": 400
}
```

## Notas / Consideraciones
- <Reglas de negocio, defaults, validaciones clave.>

## Changelog
- **YYYY-MM-DD**: <cambio>
```

