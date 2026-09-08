# Prompt: Code Review

Usar para revisar un PR, diff o cambio local.

## Instrucciones

1. Revisar el diff completo de la rama (no solo el último commit).
2. Validar: corrección, seguridad, reutilización, impacto en flujos existentes.
3. Buscar duplicación, N+1, callbacks peligrosos, leaks de secretos.
4. Verificar que no haya acceso/ejecución directa a DB desde el agente.
5. Comentar de forma accionable: ubicación → problema → fix.

## Severidad

- Blocker: seguridad, pérdida de datos, rotura de contrato
- Major: bug probable, duplicación grave, impacto no documentado
- Nit: estilo / claridad

## Formato

- Resumen
- Blockers
- Majors
- Nits
- Veredicto: approve / request changes
