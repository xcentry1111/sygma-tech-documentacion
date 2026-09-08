# Validar OTP originación (Onboarding)

> **Estado:** contrato. Ruta **no** en `routes.rb`. Copia de `POST /api/validar_otp` (listas, Experian, Truora) sobre `Formulario` Onboarding cupo fijo.

Mapa: [Flujo](../flujo.md) · [Originación](index.md).

## Resumen
Valida OTP y **decide** crédito. Pasa a `APROBADO_PENDIENTE_FIRMA`, `EN_VERIFICACION` o `RECHAZADO`.

## Endpoint
- **Método**: `POST`
- **Ruta**: `/api/onboarding/validar_otp`
- **Testing**: `https://testing-sygma.com/api/onboarding/validar_otp`

## Autenticación
JWT Bearer (`/api/onboarding/autenticar`).

## Request

| Campo | Tipo | Requerido |
|------|------|-----------|
| otp | string | sí |
| guid | string | sí |

```json
{
  "otp": "462019",
  "guid": "959ed262dc803739a937"
}
```

## Proceso interno
1. Estado terminal → respuesta corta.
2. `InvictusOtpValidacionLimite` (máx 3).
3. Compara OTP.
4. Listas restrictivas / negra / blanca.
5. Experian (`InvictusExperianSimulacion` / preselecta). Cupo fijo DIGITAL.
6. Rama: aprobado → firma; KYC → Truora; rechazo; `REINTENTAR`.

Cupo fijo: **no** crea `Persona` rotativo ni `CREAROBLCUOTAMANEJO` en este paso.

## Responses — mirar `experian_status`, no solo HTTP

| Caso | Siguiente |
|------|-----------|
| 200 `experian_status: APROBADO` | [Firma](../firma/validacion_firma_digital.md) |
| 200 `EN_VERIFICACION` | [Truora](truora_kyc.md). No firma |
| 200 `RECHAZADO` | Stop |
| 200 `REINTENTAR` | Volver a validar / [reenviar](reenviar_otp.md) |
| 422 OTP malo | Reintento o reenvío |

## Flujo anterior
[notificacion_canal](notificacion.md) o [reenviar_otp](reenviar_otp.md).

## Flujo posterior
[Firma](../firma/index.md) o [Truora](truora_kyc.md).
