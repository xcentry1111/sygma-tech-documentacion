# Originación Onboarding (cupo fijo)

Mapa: [Flujo completo](../flujo.md). Fuente funcional: Invictus originación DIGITAL **sin** Truora KYC. Rutas `/api/onboarding/*`.

## Orden

```
autenticar → simular → informacion_basica → notificacion_canal → validar_otp → firma
                                    ↘ reenviar_otp ↗
```

| API | Ruta | Código |
|-----|------|--------|
| [Autenticar](autenticar.md) | `POST /api/onboarding/autenticar` | Sí |
| [Simular](simular.md) | `POST /api/onboarding/simular` | Sí |
| [Información básica](informacion_basica.md) | `POST /api/onboarding/informacion_basica` | Sí |
| [Notificación OTP](notificacion.md) | `POST /api/onboarding/notificacion_canal` | No |
| [Reenviar OTP](reenviar_otp.md) | `POST /api/onboarding/reenviar_otp` | No |
| [Validar OTP](validar_otp.md) | `POST /api/onboarding/validar_otp` | No |

Siguiente carpeta: [Firma](../firma/index.md).
