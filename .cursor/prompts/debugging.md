# Prompt: Debugging

Usar ante bugs, errores o comportamiento inesperado.

## Instrucciones

1. Reproducir / clarificar el síntoma (error, input, entorno).
2. Seguir el flujo: entrypoint → controller/service → model/job → side effects.
3. Revisar logs Docker del servicio afectado si aplica.
4. Buscar cambios recientes en Git relacionados.
5. Formular hipótesis ordenadas por probabilidad.
6. Proponer el fix mínimo; esperar aprobación si toca lógica de negocio crítica.

## Formato

- Síntoma
- Flujo involucrado
- Hipótesis
- Evidencia
- Fix propuesto
- Cómo verificar
