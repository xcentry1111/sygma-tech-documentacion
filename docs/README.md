# Documentación de APIs

## Invictus

El mapa del flujo (originación → firma → desembolso) está en `docs/invictus_flujo.md`.
Cada API de esa cadena debe incluir **flujo anterior/posterior** y **proceso interno**.
No documentar rutas que no existan en TESEO (`config/routes.rb`).

## Onboarding

Mapa: `docs/onboarding/flujo.md`. Subcarpetas:

- Originación: `docs/onboarding/originacion/`
- Firma: `docs/onboarding/firma/`
- Desembolso: `docs/onboarding/desembolso/`

Una API por archivo. OTP/firma/desembolso = contrato (aún no en `routes.rb`). No usar URLs Invictus. Swagger: `/api/docs/onboarding`.

## Cómo documentar un servicio nuevo

- Usa como base el estándar en `docs/API_DOC_STANDARD.md`.
- Mantén **una API por archivo**.
- Completa siempre:
  - **Endpoint** (método, ruta y ambientes)
  - **Autenticación**
  - **Headers**
  - **Request** (tabla de campos + ejemplo)
  - **Responses** (al menos success + 1 error)
  - **Errores comunes**
  - **Notas / Consideraciones** (reglas de negocio)

## Reglas rápidas de formato

- **Ejemplos JSON**: sin comentarios `//` dentro del JSON. Si necesitas aclarar, usa la tabla de campos o texto arriba del ejemplo.
- **Bloques de código**: usar ` ```json ` y cerrar con ` ``` ` (evitar fences con más de 3 backticks).
- **Campos**: si no conoces una ruta/response todavía, deja `POR_DEFINIR` (pero no omitas la sección).

## Archivos estandarizados (ejemplos)

- `docs/grupoctl_actualizar.md`
- `docs/descripcion_insertar_recaudos.md`
- `docs/descripcion_reversar_recaudos.md`
- `docs/descripcion_plan_pagos.md`

