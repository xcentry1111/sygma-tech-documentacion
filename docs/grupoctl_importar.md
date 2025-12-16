# Servicio para importar datos

**Descripción:** Este servicio permite recibir parametros para el proceso de creacion de los datos demograficos
y información financiera dentro de TESEO.

**Tipo de Servicio:** POST

## **URL de Integración**

- **Prueba:** `https://testing-sygma.com/api/originador`
- **Producción:** `POR_DEFINIR/api/originador`

## **Headers**

El proceso requiere los siguientes encabezados en la solicitud:

- **Accept:** `application/json` (Obligatorio)
- **Content-Type:** `application/json` (Obligatorio)
- **Authorization:** `Bearer ${token}` (Obligatorio)

## **Cuerpo de la Solicitud (raw)**

La información debe enviarse en formato JSON. **Ejemplo:**

### **Campos Obligatorios**

- Para que la solicitud sea procesada correctamente por el motor de crédito y desembolso, **es obligatorio** enviar los siguientes campos con información válida y completa:

| Campo                        | Descripción                                      | Ejemplo / Formato                     |
|-----------------------------|--------------------------------------------------|---------------------------------------|
| `valor_desembolso`          | Valor total a desembolsar                        | `25000000`                            |
| `plazo_inicial_credito`     | Plazo del crédito en meses                       | `36`                                  |
| `primer_nombre`             | Primer nombre del solicitante                    | `JUAN`                                |
| `primer_apellido`           | Primer apellido del solicitante                  | `PÉREZ`                               |
| `nro_documento`             | Número de documento de identidad                 | `1037654321`                          |
| `tipo_cuenta`               | Tipo de cuenta bancaria (AHORROS / CORRIENTE)    | `AHORROS`                             |
| `nombre_banco_cuenta`       | Nombre del banco destino                         | `BANCOLOMBIA`                         |
| `tel_cel`                   | Celular del solicitante                          | `3001234567`                          |
| `nro_cuenta`                | Número de cuenta bancaria                        | `1234567890`                          |
| `correo`                    | Correo electrónico del solicitante              | `juan.perez@dominio.com`              |
| `fecha_expedicion_doc`      | Fecha de expedición del documento (AAAA-MM-DD)   | `2015-06-20`                          |
| `fecha_nacimiento`          | Fecha de nacimiento del solicitante (AAAA-MM-DD) | `1985-03-15`                          |
| `codigo_dane_nacim`         | Código DANE del municipio de nacimiento         | `05001` (Medellín)                    |
| `codigo_dane_resid`         | Código DANE del municipio de residencia actual  | `05001` (Medellín)                    |
| `id_simulacion`         | ID del simulador consolidado en TESEO  | `117`                     |

**Importante**

- Todos los campos son **obligatorios** en esta etapa.
- Si falta alguno o tiene formato incorrecto, el proceso se detendrá y se generará un error de validación.
- Los códigos DANE deben corresponder a municipios válidos según el estándar DIVIPOLA del DANE.**
- **detalle_comodin** - Debe contener los números de pagarés anteriores separados por |
- **estado_cavca** - Solo acepta: PARCIAL, INICIAL o FINAL (en mayúsculas)



`````json
 {
  "datostecfinanza": {
    "nro_documento": "26708493",
    "dir_residencia": "CALLE  35 # 15 -42 ",
    "correo": "cesar371542@gmail.com",
    "dir_correspondencia": "CALLE  35 # 15 -42 ",
    "no_pagare": "6515",
    "poliza": "083005225665",
    "fecha_expedicion_doc": "1964-09-07",
    "fecha_nacimiento": "1940-08-08",
    "fecha_ultima": "2025-11-11",
    "fecha_desemb": "2025-11-18",
    "fecha_ing_poliza": "2025-11-18",
    "clase_poliza": "1",
    "tipo_cliente": "N",
    "codigo_dane_exp_doc": "47189",
    "codigo_dane_nacim": "47980",
    "codigo_ciiu_cliente": "0020",
    "codigo_dane_resid": "47001",
    "tel_fijo_resi": "3002496128",
    "tel_cel": "3002496128",
    "nro_personas": "0",
    "tel_ref_per1": "3162717102",
    "valor_ingreso_salario": "2194010",
    "otros_ingresos": "0",
    "valor_total_ingresos": "2194010",
    "valor_deducciones_ley": "219401",
    "valor_otras_deducciones": "781875",
    "otros_egresos": "0",
    "valor_total_egresos": "0",
    "valor_otros_activos": "350000000",
    "total_activos": "350000000",
    "valor_otros_pasivos": "0",
    "total_pasivos": "0",
    "patrimonio": "350000000",
    "monto_solicitado": "7180636",
    "tasa_usura_ultimos_meses": "1.862403",
    "nit_custodia": "900011545",
    "nit_originador": "901693496",
    "nit_pagaduria": "860066736",
    "nit_fideicomisos": "900978303",
    "codigo_fideicomiso": "112768",
    "valor_desembolso": "7180634",
    "plazo_inicial_credito": "60",
    "tasa_interes": "1.780000",
    "valor_aval": "502644",
    "no_doc_benef_grat1": "7631479",
    "porc_benef_grat1": "100",
    "tipo_entidad": "PUBLICA",
    "manejo_recursos": "2",
    "cliente_es_pep": "2",
    "vinculo_con_pep": "2",
    "primer_apellido": "BROCHERO",
    "segundo_apellido": "SANDOVAL",
    "primer_nombre": "MARIA",
    "segundo_nombre": "LUISA",
    "tipo_doc": "1",
    "genero": "2",
    "estado_civil": "1",
    "nivel_estudios": "5",
    "ocupacion": "2",
    "clase_cliente": "VEJEZ",
    "barrio_resi": "MARIA  EUGENCIA ",
    "estrato_resi": "3",
    "tipo_vivienda": "4",
    "punto_venta": "CIENAGA",
    "tipo_contrato": "10",
    "nombre_ref_per1": "MAR\u00cdA  AMARILES  SIERRA ",
    "nombre_banco_cuenta": "10",
    "tipo_cuenta": "2",
    "desc_otros_activos": "0",
    "desc_otros_pasivos": "0",
    "tipo_libranza": "LIBRE INVERSI\u00d3N",
    "razon_social_originador": "PATRIMONIO AUTONOMO CTL",
    "razon_social_pagaduria": "FOPEP",
    "segmento_libranza": "4",
    "destino_credito": "11581",
    "razon_social_fideicomisos": "FIDUCOOMEVA",
    "benef_grat1": "CESAR AUGUSTO RAMIREZ BROCHERO",
    "int_anticipado": "73243",
    "gto_plataforma": "0",
    "corretaje": "359031",
    "nro_solicitud": "1630",
    "fecha_solicitud": "2025-11-11",
    "det_otros_ingr": "0",
    "departamento_residencia": "47",
    "cuota_corriente": "197973",
    "valor_cuota_total": "233876",
    "origen_fondos": "PENSION",
    "ingresos_brutos": "2194010",
    "dias_int_ant": "17",
    "id_transaccion": "20251119213624006515001630",
    "parentesco1": "HIJO",
    "id_simulacion": "117",
    "detalle_comodin": "626|7736|621",
    "estado_cavca": "PARCIAL"
  }
}

`````

### **Respuesta Success**

``````json
{
  "status": "success",
  "data": {
    "id": 3,
    "nro_documento": "26708493",
    "dir_residencia": "CALLE  35 # 15 -42 ",
    "correo": "cesar371542@gmail.com",
    "dir_correspondencia": "CALLE  35 # 15 -42 ",
    "no_pagare": "6515",
    "poliza": "083005225665",
    "fecha_expedicion_doc": "1964-09-07",
    "fecha_nacimiento": "1940-08-08",
    "fecha_ultima": "2025-11-11",
    "fecha_desemb": "2025-11-18",
    "fecha_ing_poliza": "2025-11-18",
    "clase_poliza": "1",
    "tipo_cliente": "N",
    "codigo_dane_exp_doc": "47189",
    "codigo_dane_nacim": "47980",
    "codigo_ciiu_cliente": "0020",
    "codigo_dane_resid": "47001",
    "tel_fijo_resi": "3002496128",
    "tel_cel": "3002496128",
    "nro_personas": "0",
    "tel_ref_per1": "3162717102",
    "valor_ingreso_salario": "2194010",
    "otros_ingresos": "0",
    "valor_total_ingresos": "2194010",
    "valor_deducciones_ley": "219401",
    "valor_otras_deducciones": "781875",
    "otros_egresos": "0",
    "valor_total_egresos": "0",
    "valor_otros_activos": "350000000",
    "total_activos": "350000000",
    "valor_otros_pasivos": "0",
    "total_pasivos": "0",
    "patrimonio": "350000000",
    "monto_solicitado": "7180636",
    "tasa_usura_ultimos_meses": "1.862403",
    "nit_custodia": "900011545",
    "nit_originador": "901693496",
    "nit_pagaduria": "860066736",
    "nit_fideicomisos": "900978303",
    "codigo_fideicomiso": "112768",
    "valor_desembolso": "7180634",
    "plazo_inicial_credito": "60",
    "tasa_interes": "1.780000",
    "valor_aval": "502644",
    "no_doc_benef_grat1": "7631479",
    "porc_benef_grat1": "100",
    "tipo_entidad": "PUBLICA",
    "manejo_recursos": "2",
    "cliente_es_pep": "2",
    "vinculo_con_pep": "2",
    "primer_apellido": "BROCHERO",
    "segundo_apellido": "SANDOVAL",
    "primer_nombre": "MARIA",
    "segundo_nombre": "LUISA",
    "tipo_doc": "1",
    "genero": "2",
    "estado_civil": "1",
    "nivel_estudios": "5",
    "ocupacion": "2",
    "clase_cliente": "VEJEZ",
    "barrio_resi": "MARIA  EUGENCIA ",
    "estrato_resi": "3",
    "tipo_vivienda": "4",
    "punto_venta": "CIENAGA",
    "tipo_contrato": "10",
    "nombre_ref_per1": "MAR\u00cdA  AMARILES  SIERRA ",
    "nombre_banco_cuenta": "10",
    "tipo_cuenta": "2",
    "desc_otros_activos": "0",
    "desc_otros_pasivos": "0",
    "tipo_libranza": "LIBRE INVERSI\u00d3N",
    "razon_social_originador": "PATRIMONIO AUTONOMO CTL",
    "razon_social_pagaduria": "FOPEP",
    "segmento_libranza": "4",
    "destino_credito": "11581",
    "razon_social_fideicomisos": "FIDUCOOMEVA",
    "benef_grat1": "CESAR AUGUSTO RAMIREZ BROCHERO",
    "int_anticipado": "73243",
    "gto_plataforma": "0",
    "corretaje": "359031",
    "nro_solicitud": "1630",
    "fecha_solicitud": "2025-11-11",
    "det_otros_ingr": "0",
    "departamento_residencia": "47",
    "cuota_corriente": "197973",
    "valor_cuota_total": "233876",
    "origen_fondos": "PENSION",
    "ingresos_brutos": "2194010",
    "dias_int_ant": "17",
    "id_transaccion": "20251119213624006515001630",
    "parentesco1": "HIJO",
    "id_simulacion": "117",
    "detalle_comodin": "626|7736|621",
    "estado_cavca": "PARCIAL",
    "created_at": "2024-08-16T17:32:11.761Z",
    "updated_at": "2024-08-16T17:32:11.761Z"
  }
}
``````

### **Respuesta Token Invalido**

``````json
{
  "status": false,
  "message": "Token Inválido",
  "details": "Signature has expired",
  "code": 400
}
``````

### **Respuestas por Campos Requeridos**

Durante el procesamiento de la solicitud, el sistema puede devolver respuestas en caso de que falten campos obligatorios o existan errores en la información enviada.

#### **Ejemplo de Respuesta para Campos Requeridos**

``````json
{
  "status": "error",
  "errors": [
    "Nro documento no puede estar en blanco"
  ]
}
``````

## **Descripción de los campos**

| DESCRIPCIÓN                                                                                                                                                                                                    | CAMPO                            | TIPO CAMPO | COMPONENTE             |
|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------|------------|------------------------|
| Número Documento                                                                                                                                                                                               | nro_documento                    | VARCHAR2   | DEMOGRÁFICOS           |
| Dirección Residencia                                                                                                                                                                                           | dir_residencia                   | VARCHAR2   | DEMOGRÁFICOS           |
| Dirección de correo electrónico                                                                                                                                                                                | correo                           | VARCHAR2   | DEMOGRÁFICOS           |
| Dirección familiar                                                                                                                                                                                             | dir_familiar                     | VARCHAR2   | DEMOGRÁFICOS           |
| Dirección Correspondencia                                                                                                                                                                                      | dir_correspondencia              | VARCHAR2   | DEMOGRÁFICOS           |
| Dirección de la Empresa donde Labora                                                                                                                                                                           | dir_empresa_labora               | VARCHAR2   | DEMOGRÁFICOS           |
| E-mail laboral                                                                                                                                                                                                 | email_labora                     | VARCHAR2   | DEMOGRÁFICOS           |
| Dirección Referencia Familiar 1                                                                                                                                                                                | dir_ref_fam1                     | VARCHAR2   | DEMOGRÁFICOS           |
| Dirección Referencia Personal 1                                                                                                                                                                                | dir_ref_per1                     | VARCHAR2   | DEMOGRÁFICOS           |
| Número de cuenta en moneda extranjera1                                                                                                                                                                         | cuenta_ext1                      | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Número de cuenta en moneda extranjera2                                                                                                                                                                         | cuenta_ext2                      | VARCHAR2   | INFORMACIÓN FINANCIERA |
| No. Pagaré = Número Crédito                                                                                                                                                                                    | no_pagare                        | VARCHAR2   | INFORMACIÓN CRÉDITO    |
| Número de Solicitud del Crédito                                                                                                                                                                                | nro_solicitud                    | VARCHAR2   | INFORMACIÓN CRÉDITO    |
| Número Póliza Cobertura Actual (para libranza privada viene vacío)                                                                                                                                             | poliza                           | VARCHAR2   | SEGURO                 |
| Fecha Expedición Documento                                                                                                                                                                                     | fecha_expedicion_doc             | DATE       | DEMOGRÁFICOS           |
| Fecha Nacimiento                                                                                                                                                                                               | fecha_nacimiento                 | DATE       | DEMOGRÁFICOS           |
| Fecha de ingreso a la empresa                                                                                                                                                                                  | fecha_ingreso                    | DATE       | DEMOGRÁFICOS           |
| Fecha Última Actualización DATACRÉDITO - EXPIRIAN                                                                                                                                                              | fecha_ultima                     | DATE       | DEMOGRÁFICOS           |
| Fecha Inicio Cargo Político                                                                                                                                                                                    | fecha_ini_cargo                  | DATE       | DEMOGRÁFICOS           |
| Fecha Fin Cargo Político                                                                                                                                                                                       | fecha_fin_cargo                  | DATE       | DEMOGRÁFICOS           |
| Fecha desembolso (DD/MM/AAAA)                                                                                                                                                                                  | fecha_desemb                     | DATE       | INFORMACIÓN CRÉDITO    |
| Fecha ingreso póliza (DEBE COINCIDIR CON FECHA DESEMBOLSO)                                                                                                                                                     | fecha_ing_poliza                 | DATE       | SEGURO                 |
| Clase de póliza de vida: SIMPRE HACER REFERENCIA A "INDIVIDUAL"                                                                                                                                                | clase_poliza                     | VARCHAR2   | SEGURO                 |
| Tipo de Cliente (ALUDE A PERSONA NATURAL o PERSONA JURÍDICA) EN ESTE PROYECTO SIEMPRE PERSONA NATURAL                                                                                                          | tipo_cliente                     | VARCHAR2   | DEMOGRÁFICOS           |
| Código DANE Ciudad Expedición Documento                                                                                                                                                                        | codigo_dane_exp_doc              | NUMBER     | DEMOGRÁFICOS           |
| Código DANE Ciudad Nacimiento                                                                                                                                                                                  | codigo_dane_nacim                | NUMBER     | DEMOGRÁFICOS           |
| Código CIIU Registra Cliente (SIEMPRE SERÁ: "020" PENSIONADO o "010" EMPLEADO                                                                                                                                  | codigo_ciiu_cliente              | NUMBER     | DEMOGRÁFICOS           |
| Antigüedad Actividad Económica en meses (ES UN CÁLCULO EN FECHA INGRESO - FECHA RADICACIÓN)                                                                                                                    | antig_actividad                  | NUMBER     | DEMOGRÁFICOS           |
| Código DANE Ciudad Residencia                                                                                                                                                                                  | codigo_dane_resid                | NUMBER     | DEMOGRÁFICOS           |
| Teléfono Fijo Residencia                                                                                                                                                                                       | tel_fijo_resi                    | VARCHAR2   | DEMOGRÁFICOS           |
| Teléfono celular                                                                                                                                                                                               | tel_cel                          | VARCHAR2   | DEMOGRÁFICOS           |
| Código DANE Ciudad Dirección Familiar                                                                                                                                                                          | codigo_dane_dir_fam              | NUMBER     | DEMOGRÁFICOS           |
| Código DANE Ciudad Correspondencia                                                                                                                                                                             | codigo_dane_dir_corr             | NUMBER     | DEMOGRÁFICOS           |
| Código DANE Ciudad Dirección Empresa donde labora                                                                                                                                                              | codigo_dane_dir_emp              | NUMBER     | DEMOGRÁFICOS           |
| Teléfono Fijo Oficina donde labora                                                                                                                                                                             | tel_fijo_ofi                     | VARCHAR2   | DEMOGRÁFICOS           |
| Extensión Oficina donde Labora                                                                                                                                                                                 | ext_ofi_lab                      | VARCHAR2   | DEMOGRÁFICOS           |
| Número Renovaciones Contrato Término Fijo (normalmente vendrá vacío)                                                                                                                                           | nro_renov_contrato               | VARCHAR2   | DEMOGRÁFICOS           |
| No. de personas a cargo                                                                                                                                                                                        | nro_personas                     | NUMBER     | DEMOGRÁFICOS           |
| Personas a cargo menores de 18 años                                                                                                                                                                            | menores_18                       | NUMBER     | DEMOGRÁFICOS           |
| Código DANE Ciudad Dirección Referencia Familiar 1                                                                                                                                                             | codigo_dane_ref_fam1             | NUMBER     | DEMOGRÁFICOS           |
| Teléfono Referencia Familiar 1                                                                                                                                                                                 | tel_ref_fam1                     | VARCHAR2   | DEMOGRÁFICOS           |
| Código DANE Ciudad Dirección Referencia Personal 1                                                                                                                                                             | codigo_dane_ref_per1             | NUMBER     | DEMOGRÁFICOS           |
| Teléfono Referencia Personal 1                                                                                                                                                                                 | tel_ref_per1                     | VARCHAR2   | DEMOGRÁFICOS           |
| Número Cuenta Bancaria                                                                                                                                                                                         | nro_cuenta                       | NUMBER     | INFORMACIÓN FINANCIERA |
| Valor Ingreso / Salario FIJO Mensual                                                                                                                                                                           | valor_ingreso_salario            | NUMBER     | INFORMACIÓN FINANCIERA |
| Valor Ingreso por Comisiones Mensual                                                                                                                                                                           | valor_ingreso_comisiones         | NUMBER     | INFORMACIÓN FINANCIERA |
| Valor Ingresos por Honorarios Mensual                                                                                                                                                                          | valor_ingreso_honorarios         | NUMBER     | INFORMACIÓN FINANCIERA |
| Valor Ingresos por Arrendamientos Mensual                                                                                                                                                                      | valor_ingresos_arrend            | NUMBER     | INFORMACIÓN FINANCIERA |
| Valor Rendimientos Financieros Mensuales                                                                                                                                                                       | valor_rendimientos               | NUMBER     | INFORMACIÓN FINANCIERA |
| Otros ingresos Mensuales                                                                                                                                                                                       | otros_ingresos                   | NUMBER     | INFORMACIÓN FINANCIERA |
| Valor Total Ingresos Mes                                                                                                                                                                                       | valor_total_ingresos             | NUMBER     | INFORMACIÓN FINANCIERA |
| Valor Deducciones de ley mes                                                                                                                                                                                   | valor_deducciones_ley            | NUMBER     | INFORMACIÓN FINANCIERA |
| Valor Otras deducciones nómina mes                                                                                                                                                                             | valor_otras_deducciones          | NUMBER     | INFORMACIÓN FINANCIERA |
| Valor Arrendamiento cliente mes                                                                                                                                                                                | valor_arrend_cliente             | NUMBER     | INFORMACIÓN FINANCIERA |
| Valor Cuota Crédito de vivienda cliente mes                                                                                                                                                                    | valor_cuota_credito              | NUMBER     | INFORMACIÓN FINANCIERA |
| Valor Gastos por Tarjeta Crédito cliente mes                                                                                                                                                                   | valor_gastos_tarjeta             | NUMBER     | INFORMACIÓN FINANCIERA |
| Valor Gastos Familiares cliente mes                                                                                                                                                                            | valor_gastos_familiares          | NUMBER     | INFORMACIÓN FINANCIERA |
| Valor Gastos de sostenimiento cliente mes                                                                                                                                                                      | valor_gastos_sost                | NUMBER     | INFORMACIÓN FINANCIERA |
| Valor Pago Otros Créditos cliente mes                                                                                                                                                                          | valor_pago_otros_creditos        | NUMBER     | INFORMACIÓN FINANCIERA |
| Otros egresos cliente mes                                                                                                                                                                                      | otros_egresos                    | NUMBER     | INFORMACIÓN FINANCIERA |
| Valor Total egresos cliente mes                                                                                                                                                                                | valor_total_egresos              | NUMBER     | INFORMACIÓN FINANCIERA |
| Valor Activos Corrientes                                                                                                                                                                                       | valor_activos_corrientes         | NUMBER     | INFORMACIÓN FINANCIERA |
| Valor Activos Fijos                                                                                                                                                                                            | valor_activos_fijos              | NUMBER     | INFORMACIÓN FINANCIERA |
| Valor Otros Activos                                                                                                                                                                                            | valor_otros_activos              | NUMBER     | INFORMACIÓN FINANCIERA |
| Total activos                                                                                                                                                                                                  | total_activos                    | NUMBER     | INFORMACIÓN FINANCIERA |
| Valor Pasivos Financieros (deudas financieras)                                                                                                                                                                 | valor_pasivos_financieros        | NUMBER     | INFORMACIÓN FINANCIERA |
| Valor Pasivos Corrientes                                                                                                                                                                                       | valor_pasivos_corrientes         | NUMBER     | INFORMACIÓN FINANCIERA |
| Valor Otros Pasivos                                                                                                                                                                                            | valor_otros_pasivos              | NUMBER     | INFORMACIÓN FINANCIERA |
| Total pasivos                                                                                                                                                                                                  | total_pasivos                    | NUMBER     | INFORMACIÓN FINANCIERA |
| Patrimonio                                                                                                                                                                                                     | patrimonio                       | NUMBER     | INFORMACIÓN FINANCIERA |
| Monto Crédito Solicitado (antes estaba como Cupo Solicitado)                                                                                                                                                   | monto_solicitado                 | NUMBER     | INFORMACIÓN FINANCIERA |
| Monto cuenta en moneda extranjera1                                                                                                                                                                             | monto_cuenta_ext1                | NUMBER     | INFORMACIÓN FINANCIERA |
| Monto cuenta en moneda extranjera2                                                                                                                                                                             | monto_cuenta_ext2                | NUMBER     | INFORMACIÓN FINANCIERA |
| Puntaje Acierta Deudor                                                                                                                                                                                         | puntaje_acierta                  | NUMBER     | INFORMACIÓN FINANCIERA |
| Barrio Residencia                                                                                                                                                                                              | barrio_resi                      | VARCHAR2   | DEMOGRÁFICOS           |
| Estrato Residencia                                                                                                                                                                                             | estrato_resi                     | VARCHAR2   | DEMOGRÁFICOS           |
| Tipo de vivienda Residencia                                                                                                                                                                                    | tipo_vivienda                    | VARCHAR2   | DEMOGRÁFICOS           |
| Nombre empresa donde labora                                                                                                                                                                                    | nombre_empresa                   | VARCHAR2   | DEMOGRÁFICOS           |
| Punto de Venta donde labora (POR DEFECTIVO VIENE "PRINCIPAL")                                                                                                                                                  | punto_venta                      | VARCHAR2   | DEMOGRÁFICOS           |
| Tipo de contrato                                                                                                                                                                                               | tipo_contrato                    | VARCHAR2   | DEMOGRÁFICOS           |
| Tipo de empresa ("PÚBLICA", "PRIVADA", "MIXTA")                                                                                                                                                                | tipo_empresa                     | VARCHAR2   | DEMOGRÁFICOS           |
| Cargo Actual en la empresa                                                                                                                                                                                     | cargo_actual                     | VARCHAR2   | DEMOGRÁFICOS           |
| ¿Cuál Cargo Politico Desempeña?                                                                                                                                                                                | cargo_politico                   | VARCHAR2   | DEMOGRÁFICOS           |
| Nombre Referencia Familiar 1                                                                                                                                                                                   | nombre_ref_fam1                  | VARCHAR2   | DEMOGRÁFICOS           |
| Parentesco Referencia Familiar 1                                                                                                                                                                               | parentesco_ref_fam1              | VARCHAR2   | DEMOGRÁFICOS           |
| Nombre Referencia Personal 1                                                                                                                                                                                   | nombre_ref_per1                  | VARCHAR2   | DEMOGRÁFICOS           |
| Nombre Banco Cuenta Bancaria                                                                                                                                                                                   | nombre_banco_cuenta              | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Tipo de Cuenta Bancaria                                                                                                                                                                                        | tipo_cuenta                      | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Descripción Otros Activos                                                                                                                                                                                      | desc_otros_activos               | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Descripción Otros Pasivos                                                                                                                                                                                      | desc_otros_pasivos               | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Otros                                                                                                                                                                                                          | otros_activos_pasivos            | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Nombre del banco donde tiene cuenta en moneda extranjera1                                                                                                                                                      | nombre_banco_ext1                | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Tipo producto en moneda extranjera1                                                                                                                                                                            | tipo_producto_ext1               | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Moneda extranjera1                                                                                                                                                                                             | moneda_ext1                      | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Ciudad del banco donde tiene cuenta en moneda extranjera1                                                                                                                                                      | ciudad_banco_ext1                | VARCHAR2   | INFORMACIÓN FINANCIERA |
| País donde posee cuenta en moneda extranjera1                                                                                                                                                                  | pais_banco_ext1                  | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Nombre del banco donde tiene cuenta en moneda extranjera2                                                                                                                                                      | nombre_banco_ext2                | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Tipo producto en moneda extranjera2                                                                                                                                                                            | tipo_producto_ext2               | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Moneda extranjera2                                                                                                                                                                                             | moneda_ext2                      | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Ciudad del banco donde tiene cuenta en moneda extranjera2                                                                                                                                                      | ciudad_banco_ext2                | VARCHAR2   | INFORMACIÓN FINANCIERA |
| País donde posee cuenta en moneda extranjera2                                                                                                                                                                  | pais_banco_ext2                  | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Calificación del Cliente (MEJOR CALIFICACIÓN EN DATACRÉDITO)                                                                                                                                                   | calificacion_cliente             | VARCHAR2   | INFORMACIÓN CENTRALES  |
| Tipo Cliente Datacredito                                                                                                                                                                                       | tipo_cliente_datacredito         | VARCHAR2   | INFORMACIÓN CENTRALES  |
| Tipo de libranza (LINEA DE LIBRANZA : "COMPRA DE CARTERA", "LIBRE INVERSIÓN", ETC)                                                                                                                             | tipo_libranza                    | VARCHAR2   | INFORMACIÓN CRÉDITO    |
| Razón Social Originador (EN PRINCIPIO "VANTAGE")                                                                                                                                                               | razon_social_originador          | VARCHAR2   | INFORMACIÓN CRÉDITO    |
| Razón Social Pagaduria                                                                                                                                                                                         | razon_social_pagaduria           | VARCHAR2   | INFORMACIÓN CRÉDITO    |
| Segmento Libranza ("PENSIONADO", "DOCENTE", ETC)                                                                                                                                                               | segmento_libranza                | VARCHAR2   | INFORMACIÓN CRÉDITO    |
| Razón Social Fideicomisos                                                                                                                                                                                      | razon_social_fideicomisos        | VARCHAR2   | INFORMACIÓN CRÉDITO    |
| Fondeador (VIENE VACIO PORQUE AUN NO SE HA VENDIDO)                                                                                                                                                            | fondeador                        | VARCHAR2   | INFORMACIÓN CRÉDITO    |
| Oficina Asociado (ALUDE A LA OFICINA DONDE SE RADICÓ CRÉDITO)                                                                                                                                                  | oficina_asociado                 | VARCHAR2   | INFORMACIÓN CRÉDITO    |
| Tipo de AVAL (EN LIBRANZA PRIVADA DEBE VENIR "NORMALIZATE", LIBRANZA PÚBLICA "FIGARANTIAS")                                                                                                                    | tipo_aval                        | VARCHAR2   | SEGURO                 |
| Beneficiario gratuito 1                                                                                                                                                                                        | benef_grat1                      | VARCHAR2   | SEGURO                 |
| Beneficiario gratuito 2                                                                                                                                                                                        | benef_grat2                      | VARCHAR2   | SEGURO                 |
| Protección Patrimial o Seguro Crédito                                                                                                                                                                          | p_patrimonial                    | NUMBER     | SEGURO                 |
| No. de cuentas embargadas                                                                                                                                                                                      | nro_cuentas_embargadas           | NUMBER     | INFORMACIÓN CENTRALES  |
| No. de cuentas canceladas por mal manejo                                                                                                                                                                       | nro_cuentas_canceladas           | NUMBER     | INFORMACIÓN CENTRALES  |
| No. de obligaciones en mora                                                                                                                                                                                    | nro_obligaciones_mora            | NUMBER     | INFORMACIÓN CENTRALES  |
| No. de obligaciones en mora (Sector cooperativo)                                                                                                                                                               | nro_obligaciones_mora_coop       | NUMBER     | INFORMACIÓN CENTRALES  |
| No. de carteras castigadas (Sector financiero o cooperativo)                                                                                                                                                   | nro_carteras_castigadas          | NUMBER     | INFORMACIÓN CENTRALES  |
| No. de carteras en dudoso recaudo                                                                                                                                                                              | nro_carteras_dudoso              | NUMBER     | INFORMACIÓN CENTRALES  |
| No. de obligaciones reestructuradas                                                                                                                                                                            | nro_obligaciones_reestructuradas | NUMBER     | INFORMACIÓN CENTRALES  |
| No. de obligaciones calificadas en "C" (Sector financiero)                                                                                                                                                     | nro_obligaciones_calificadas_C   | NUMBER     | INFORMACIÓN CENTRALES  |
| No. de obligaciones calificadas en "D" (Sector financiero)                                                                                                                                                     | nro_obligaciones_calificadas_D   | NUMBER     | INFORMACIÓN CENTRALES  |
| No. de obligaciones calificadas en "E" (Sector financiero)                                                                                                                                                     | nro_obligaciones_calificadas_E   | NUMBER     | INFORMACIÓN CENTRALES  |
| Número moras de 30 días en los últimos 12 meses                                                                                                                                                                | nro_moras_30_dias                | NUMBER     | INFORMACIÓN CENTRALES  |
| Número moras de 60 días en los últimos 12 meses                                                                                                                                                                | nro_moras_60_dias                | NUMBER     | INFORMACIÓN CENTRALES  |
| Número moras superiores a 60 días en los últimos 12 meses                                                                                                                                                      | nro_moras_sup_60_dias            | NUMBER     | INFORMACIÓN CENTRALES  |
| No. entidades (financieras y cooperativas) que consultan últimos 6 meses                                                                                                                                       | nro_entidades_consulta           | NUMBER     | INFORMACIÓN CENTRALES  |
| Quanto mínimo ($)                                                                                                                                                                                              | quanto_minimo                    | NUMBER     | INFORMACIÓN CENTRALES  |
| Quanto máximo ($)                                                                                                                                                                                              | quanto_maximo                    | NUMBER     | INFORMACIÓN CENTRALES  |
| Quanto medio ($)                                                                                                                                                                                               | quanto_medio                     | NUMBER     | INFORMACIÓN CENTRALES  |
| ∑ Cuotas créditos de consumo (sin incluir TDC, CBR ni CAV) Centrales de Riesgo                                                                                                                                 | sum_cuotas_creditos              | NUMBER     | INFORMACIÓN CENTRALES  |
| ∑ Saldos TDC y CBR Centrales de Riesgo                                                                                                                                                                         | sum_saldos_tdc                   | NUMBER     | INFORMACIÓN CENTRALES  |
| ∑ Cupos TDC y CBR Centrales de Riesgo                                                                                                                                                                          | sum_cupos_tdc                    | NUMBER     | INFORMACIÓN CENTRALES  |
| No. de embargos en desprendible de pago                                                                                                                                                                        | nro_embargos_pago                | NUMBER     | INFORMACIÓN CENTRALES  |
| N° de procesos civiles en contra en curso                                                                                                                                                                      | nro_procesos_civiles             | NUMBER     | INFORMACIÓN CENTRALES  |
| NIT Custodia Pagaré (normalmente vacío por el momento)                                                                                                                                                         | nit_custodia                     | NUMBER     | INFORMACIÓN CRÉDITO    |
| NIT Originador (NIT VANTAGE 900690783)                                                                                                                                                                         | nit_originador                   | NUMBER     | INFORMACIÓN CRÉDITO    |
| NIT Pagaduría (NIT DE LA PAGADURIA ASOCIADA AL DEUDOR)                                                                                                                                                         | nit_pagaduria                    | NUMBER     | INFORMACIÓN CRÉDITO    |
| NIT Fideicomisos (NIT MASTER TRUST - NIT PA VANTAGE)                                                                                                                                                           | nit_fideicomisos                 | NUMBER     | INFORMACIÓN CRÉDITO    |
| Código Fideicomiso                                                                                                                                                                                             | codigo_fideicomiso               | NUMBER     | INFORMACIÓN CRÉDITO    |
| Valor Desembolsado                                                                                                                                                                                             | valor_desembolso                 | NUMBER     | INFORMACIÓN CRÉDITO    |
| Plazo inicial crédito (meses)                                                                                                                                                                                  | plazo_inicial_credito            | NUMBER     | INFORMACIÓN CRÉDITO    |
| Tasa Interés Colocación nominal mes vencido                                                                                                                                                                    | tasa_interes                     | NUMBER     | INFORMACIÓN CRÉDITO    |
| Valor AVAL - FIANZA                                                                                                                                                                                            | valor_aval                       | NUMBER     | SEGURO                 |
| Períodicidad (VENDRÁ CÓDIGO "2" QUE ALUDE A PAGO MENSUAL)                                                                                                                                                      | periodicidad                     | NUMBER     | SEGURO                 |
| Porcentaje de reserva (ANTERIORMENTE ERA 9% … NUEVA POLÍTICA)                                                                                                                                                  | porcentaje_reserva               | NUMBER     | SEGURO                 |
| Prima Mensual Seguro Vida                                                                                                                                                                                      | prima_segvida                    | NUMBER     | SEGURO                 |
| No de documento beneficiario gratuito 1                                                                                                                                                                        | no_doc_benef_grat1               | NUMBER     | SEGURO                 |
| % Beneficiario gratuito 1                                                                                                                                                                                      | porc_benef_grat1                 | NUMBER     | SEGURO                 |
| No de documento beneficiario gratuito 2                                                                                                                                                                        | no_doc_benef_grat2               | NUMBER     | SEGURO                 |
| % Beneficiario gratuito 2                                                                                                                                                                                      | porc_benef_grat2                 | NUMBER     | SEGURO                 |
| Tipo Entidad Pagaduría (DETALLAR SI ES "PÚBLICA" o "PRIVADA")                                                                                                                                                  | tipo_entidad                     | VARCHAR2   | INFORMACIÓN CRÉDITO    |
| Cliente Declara Renta                                                                                                                                                                                          | cliente_declara                  | VARCHAR2   | DEMOGRÁFICOS           |
| ¿Actualmente Desempeña un cargo político?                                                                                                                                                                      | desempena_cargo                  | VARCHAR2   | DEMOGRÁFICOS           |
| Manejo de recursos públicos                                                                                                                                                                                    | manejo_recursos                  | VARCHAR2   | DEMOGRÁFICOS           |
| ¿Representa legalmente alguna organización internacional (ONG/OIG)?                                                                                                                                            | representa_organizacion          | VARCHAR2   | DEMOGRÁFICOS           |
| Cliente es PEP                                                                                                                                                                                                 | cliente_es_pep                   | VARCHAR2   | DEMOGRÁFICOS           |
| ¿Tiene algún vinculo con un PEP?                                                                                                                                                                               | vinculo_con_pep                  | VARCHAR2   | DEMOGRÁFICOS           |
| Reconocimiento público                                                                                                                                                                                         | reconocimiento_publico           | VARCHAR2   | DEMOGRÁFICOS           |
| Posee Cuenta Bancaria                                                                                                                                                                                          | posee_cuenta                     | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Realiza operaciones en moneda extranjera                                                                                                                                                                       | realiza_operaciones              | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Importaciones**                                                                                                                                                                                                | importaciones                    | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Crédito documentario**                                                                                                                                                                                         | credito_documentario             | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Giros directos**                                                                                                                                                                                               | giros_directos                   | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Negociación de divisas**                                                                                                                                                                                       | negociacion_divisas              | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Leasing de importación**                                                                                                                                                                                       | leasing_importacion              | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Giros financiados**                                                                                                                                                                                            | giros_financiados                | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Exportaciones**                                                                                                                                                                                                | exportaciones                    | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Inversiones**                                                                                                                                                                                                  | inversiones                      | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Venta de bienes*                                                                                                                                                                                               | venta_bienes                     | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Honorarios y comisiones*                                                                                                                                                                                       | honorarios_comisiones            | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Ingresos por actividad*                                                                                                                                                                                        | ingresos_actividad               | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Préstamo bancario*                                                                                                                                                                                             | prestamo_bancario                | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Rifas*                                                                                                                                                                                                         | rifas                            | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Pensión*                                                                                                                                                                                                       | pension                          | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Herencia*                                                                                                                                                                                                      | herencia                         | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Liquidación de prestaciones*                                                                                                                                                                                   | liq_prestaciones                 | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Liquidación de sucesiones*                                                                                                                                                                                     | liq_sucesiones                   | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Otros*                                                                                                                                                                                                         | otros                            | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Tiene cuentas en moneda extranjera                                                                                                                                                                             | cuentas_moneda_ext               | VARCHAR2   | INFORMACIÓN FINANCIERA |
| He permanecido 31 días o más durante el año en curso o 183 días durante un periodo de 3 años, que incluye el año en curso y los dos años inmediatamente anteriores dentro del territorio de los Estados Unidos | permanencia_eeuu                 | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Soy poseedor de la tarjeta verde(Green Card) de los Estados Unidos de Norteamérica (Tarjeta de residencia)                                                                                                     | tarjeta_verde                    | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Recibo sumas de dinero fijas u ocasionales(FDAP) que provienen de fuentes dentro de los Estados Unidos de Norteamérica                                                                                         | ingresos_fdap                    | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Recibo ingreso bruto procedente de la venta u otra disposición de cualquier propiedad que pueda producir rentas intereses o dividendos cuya fuente se encuentre dentro de los estados unidos de Norteamérica   | ingreso_bruto_venta              | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Soy ciudadano de los Estados Unidos residente en Colombia                                                                                                                                                      | ciudadano_eeuu                   | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Estoy obligado a tributar en Estados Unidos                                                                                                                                                                    | obligado_tributar                | VARCHAR2   | INFORMACIÓN FINANCIERA |
| ¿Coincidencia en listas de control? (No, Listas)                                                                                                                                                               | coincidencia_listas              | VARCHAR2   | INFORMACIÓN CENTRALES  |
| Procesos en contra en curso con Cooperativa o Demanda por Alimentos (Sí/No)                                                                                                                                    | procesos_cooperativa             | VARCHAR2   | INFORMACIÓN CENTRALES  |
| Extraprima                                                                                                                                                                                                     | extraprima                       | VARCHAR2   | SEGURO                 |
| Primer apellido                                                                                                                                                                                                | primer_apellido                  | VARCHAR2   | DEMOGRÁFICOS           |
| Segundo apellido                                                                                                                                                                                               | segundo_apellido                 | VARCHAR2   | DEMOGRÁFICOS           |
| Primer nombre                                                                                                                                                                                                  | primer_nombre                    | VARCHAR2   | DEMOGRÁFICOS           |
| Segundo nombre                                                                                                                                                                                                 | segundo_nombre                   | VARCHAR2   | DEMOGRÁFICOS           |
| Tipo de documento                                                                                                                                                                                              | tipo_doc                         | VARCHAR2   | DEMOGRÁFICOS           |
| País Nacimiento                                                                                                                                                                                                | pais_nacimiento                  | VARCHAR2   | DEMOGRÁFICOS           |
| Nacionalidad                                                                                                                                                                                                   | nacionalidad                     | VARCHAR2   | DEMOGRÁFICOS           |
| Género                                                                                                                                                                                                         | genero                           | VARCHAR2   | DEMOGRÁFICOS           |
| Estado Civil                                                                                                                                                                                                   | estado_civil                     | VARCHAR2   | DEMOGRÁFICOS           |
| Nivel de Estudios                                                                                                                                                                                              | nivel_estudios                   | VARCHAR2   | DEMOGRÁFICOS           |
| Grupo étnico                                                                                                                                                                                                   | grupo_etnico                     | VARCHAR2   | DEMOGRÁFICOS           |
| Profesión                                                                                                                                                                                                      | profesion                        | VARCHAR2   | DEMOGRÁFICOS           |
| Ocupación                                                                                                                                                                                                      | ocupacion                        | VARCHAR2   | DEMOGRÁFICOS           |
| Clase de Cliente (1.)                                                                                                                                                                                          | clase_cliente                    | VARCHAR2   | DEMOGRÁFICOS           |
| Cuotas Crédito (ALUDE SUMATORIO TODAS CUOTAS CONSUMO DIFERENTES A TDC Y CR Y SECTOR DELCOS)                                                                                                                    | cuotas_credito                   | NUMBER     | INFORMACIÓN CENTRALES  |
| Cuota Cupo TDC UTILIZADO (ALUDE A SUMATORIA CUPOS UTILIZADOS DE TODAS TARJETAS CRÉDITO * TASA PONDERADA * PLAZO)                                                                                               | cuota_cupo_tdcusado              | NUMBER     | INFORMACIÓN CENTRALES  |
| Cuota Cupo TDC CONTINGENTE (ALUDE A SUMATORIA CUPOS UTILIZADOS DE TODAS TARJETAS CRÉDITO * 33% * TASA PONDERADA 3 MESES * PLAZO)                                                                               | cuota_cupo_tdcconting            | NUMBER     | INFORMACIÓN CENTRALES  |
| Cuota Cupo ROTA USADO (SUMATORIA LOS CUPOS UTILIZADOS ROTATIVO * TASA PONDERADA 3 MESES * PLAZO 48 MESES)                                                                                                      | cuota_cupo_rotausado             | NUMBER     | INFORMACIÓN CENTRALES  |
| Cuota Cupo ROTA CONTINGENTE (SUMATORIA TODAS CUPOS ROTATIVO * 33% * TASA PONDERADA 3 MESES * PLAZO 48 MESES)                                                                                                   | cuota_cupo_rotaconting           | NUMBER     | INFORMACIÓN CENTRALES  |
| Gastos Familiares Pensionados (ESTIMADO 10% DEL INGRESO)                                                                                                                                                       | gastos_familiares_pensionado     | NUMBER     | INFORMACIÓN FINANCIERA |
| Gastos Familiares Activos (CÁLCULO INGRESO SOBRE TABLA ENTREGADA POR VANTAGE)                                                                                                                                  | gastos_familiares_activo         | NUMBER     | INFORMACIÓN FINANCIERA |
| Tasa Usura Promedio Últimos 3 meses                                                                                                                                                                            | tasa_usura_ultimos_meses         | NUMBER     | INFORMACIÓN FINANCIERA |
| Gastos Financieros (CORRESPONDEN A SUMATORIA CUOTAS CREDITOS + CUOTAS TDC + CUOTAS ROTATIVOS)                                                                                                                  | gastos_financieros               | NUMBER     | INFORMACIÓN FINANCIERA |
| % Endeudamiento (CÁLCULO GASTOS FINANCIEROS + GASTOS FAMILIARES + CUOTA NUEVO CREDITO) / INGRESOS CAPACIDAD CREDITO                                                                                            | porcent_endeudamiento            | NUMBER     | INFORMACIÓN FINANCIERA |
| Días Intereses Anticipados                                                                                                                                                                                     | dias_int_ant                     | NUMBER     | INFORMACIÓN CRÉDITO    |
| Intereses Anticipados Cobrados                                                                                                                                                                                 | int_anticipado                   | NUMBER     | INFORMACIÓN CRÉDITO    |
| Gasto por Plataforma                                                                                                                                                                                           | gto_plataforma                   | NUMBER     | INFORMACIÓN CRÉDITO    |
| Valor préstamos diferentes a Coomeva (Financiero)                                                                                                                                                              | valor_prestamo_sin_c             | NUMBER     | INFORMACIÓN CENTRALES  |
| Valor préstamos diferentes a Coomeva (Real)                                                                                                                                                                    | valor_prestamo_sin_r             | NUMBER     | INFORMACIÓN CENTRALES  |
| Valor préstamos diferentes a Coomeva (Cooperativa)                                                                                                                                                             | valor_prestamo_sin_cc            | NUMBER     | INFORMACIÓN CENTRALES  |
| No obligaciones en mora Sector Financiero                                                                                                                                                                      | total_oblm_sf                    | NUMBER     | INFORMACIÓN CENTRALES  |
| No obligaciones en mora > saldo cartera a 7 millones Sector Financiero                                                                                                                                         | total_oblm_mayor_7               | NUMBER     | INFORMACIÓN CENTRALES  |
| No obligaciones castigadas > saldo cartera a 15 millones Sector Financiero                                                                                                                                     | total_obl_castigadas_mayor_15    | NUMBER     | INFORMACIÓN CENTRALES  |
| No Moras =>90 días Todos los sectores                                                                                                                                                                          | total_oblm_mayor_90              | NUMBER     | INFORMACIÓN CENTRALES  |
| Total Endeudamiento Sector Financiero Sumatoria de los saldos                                                                                                                                                  | total_deuda_sf                   | NUMBER     | INFORMACIÓN CENTRALES  |
| Total Endeudamiento Sector Cooperativo Sumatoria de los saldos                                                                                                                                                 | total_deuda_sc                   | NUMBER     | INFORMACIÓN CENTRALES  |
| Total Endeudamiento Sector Real Sumatoria de los saldos                                                                                                                                                        | total_deuda_sr                   | NUMBER     | INFORMACIÓN CENTRALES  |
| Valor de la cuota total que debe pagar deudor (incluye seguros y avales)                                                                                                                                       | valor_cuota_total                | NUMBER     | INFORMACIÓN CRÉDITO    |
| Correo electrónico referencia familiar 1                                                                                                                                                                       | email_ref_fam1                   | NUMBER     | DEMOGRÁFICOS           |
| Correo electrónico referencia personal 1                                                                                                                                                                       | email_ref_pers1                  | NUMBER     | DEMOGRÁFICOS           |
| Fecha de la solicitud del crédito de libranza                                                                                                                                                                  | fecha_solicitud                  | DATE       | INFORMACIÓN CRÉDITO    |
| Es el barrio donde está ubicada la empresa                                                                                                                                                                     | barrio_empresa                   | VARCHAR2   | DEMOGRÁFICOS           |
| Detalle, otros ingresos                                                                                                                                                                                        | det_otros_ingr                   | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Origen de Fondos                                                                                                                                                                                               | origen_fondos                    | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Ingresos Brutos                                                                                                                                                                                                | ingresos_brutos                  | NUMBER     | INFORMACIÓN FINANCIERA |
| Estado Actual del Crédito: NECESITAMOS EL DETALLE DE LOS ESTADOS                                                                                                                                               | estado_credito                   | VARCHAR2   | INFORMACIÓN FINANCIERA |
| Departamento donde está ubicada la residencia del deudor                                                                                                                                                       | departamento_residencia          | VARCHAR2   | DEMOGRÁFICOS           |
| Departamento donde está ubicada la empresa del deudor                                                                                                                                                          | departamento_empresa             | VARCHAR2   | DEMOGRÁFICOS           |
| Valor Cuota Corrientes: la cuota financiera del crédito (intereses corrientes + amortización)                                                                                                                  | cuota_corriente                  | NUMBER     | INFORMACIÓN FINANCIERA |



### **Diccionario de Datos**

Este diccionario proporciona los valores posibles para varios campos en la solicitud. Los IDs se utilizan en los campos correspondientes, y las descripciones ayudan a entender qué representa cada ID.

### **Tipo de Documento**

| ID  | Descripción                     |
|-----|---------------------------------|
| 1   | CÉDULA DE CIUDADANÍA            |
| 2   | CÉDULA DE EXTRANJERÍA           |
| 5   | TARJETA DE IDENTIDAD            |
| 161 | PERMISO POR PROTECCIÓN TEMPORAL |
| 162 | PERSONAS EXPUESTAS POLÍTICAMENTE |

### **Estado Civil**

| ID | Descripción     |
|----|-----------------|
| 1  | SOLTERO(A)      |
| 2  | CASADO(A)       |
| 3  | DIVORCIADO(A)   |
| 4  | VIUDO(A)        |
| 5  | UNIÓN LIBRE     |

### **Género**

| ID | Descripción |
|----|-------------|
| 1  | MASCULINO   |
| 2  | FEMENINO    |

### **Nivel de Estudios**

| ID | Descripción    |
|----|----------------|
| 1  | PRIMARIA       |
| 2  | BACHILLERATO   |
| 3  | UNIVERSITARIA  |
| 4  | OTROS          |
| 5  | TECNÓLOGO      |
| 6  | POSTGRADO      |
| 7  | NINGUNO        |

### **Ocupación**

| ID | Descripción         |
|----|---------------------|
| 1  | Empleado            |
| 2  | PENSIONADO          |
| 3  | Rentista de capital |
| 4  | Estudiante          |
| 5  | Ama de casa         |
| 6  | Desempleado         |
| 7  | Independiente       |

### **Tipo de Vivienda**

| ID | Descripción |
|----|-------------|
| 1  | Arrendada   |
| 2  | Familiar    |
| 4  | Propia      |

### **Tipo de Cuenta Bancaria**

| ID | Descripción |
|----|-------------|
| 1  | CORRIENTE   |
| 2  | AHORROS     |

### **Clase de Póliza**

| ID | Descripción |
|----|-------------|
| 1  | INDIVIDUAL  |

### **Reconocimiento Público**

| ID | Descripción |
|----|-------------|
| 1  | SI          |
| 2  | NO          |

### **Cliente PEP**

| ID | Descripción |
|----|-------------|
| 1  | SI          |
| 2  | NO          |

### **Tipo de Empresa**

| ID | Descripción |
|----|-------------|
| 1  | PÚBLICA     |
| 2  | PRIVADA     |
| 3  | MIXTA       |

### **Tipo de Libranza**

| ID | Descripción           |
|----|-----------------------|
| 1  | LIBRE INVERSIÓN       |
| 2  | COMPRA DE CARTERA     |
| 3  | EDUCACIÓN             |
| 4  | DESEMBOLSOS PARCIALES |
| 5  | REFINANCIACIÓN        |
| 6  | REESTRUCTURACIÓN      |

### **Segmento Libranza**

| ID | Descripción        |
|----|--------------------|
| 1  | DOCENTES           |
| 2  | ENTES DE CONTROL   |
| 3  | FUERZAS MILITARES  |
| 4  | PENSIONADOS        |
| 5  | PRIVADO            |

### **Tipo de Contrato**

| ID | Descripción            |
|----|------------------------|
| 1  | TÉRMINO FIJO           |
| 2  | INDEFINIDO             |
| 3  | CARRERA ADMINISTRATIVA |
| 4  | PROVISIONAL            |
| 5  | CONTRATISTA            |
| 6  | TEMPORAL               |
| 9  | ACTIVO                 |
| 10 | PENSIONADOS            |
| 11 | OBRA LABOR             |
| 12 | PLANTA                 |
| 13 | EN PROPIEDAD           |

### **Grupo Étnico**

| ID | Descripción                                               |
|----|-----------------------------------------------------------|
| 1  | INDÍGENA                                                  |
| 2  | GITANO (A) O RROM                                         |
| 3  | RAIZAL DEL ARCHIPIÉLAGO DE SAN ANDRÉS, PROVIDENCIA Y SANTA CATALINA |
| 4  | PALENQUERO (A) DE SAN BASILIO                              |
| 5  | NEGRO (A), MULATO (A), AFRODESCENDIENTE, AFROCOLOMBIANO    |
| 6  | NINGÚN GRUPO ÉTNICO                                       |
| 7  | SIN INFORMACIÓN                                           |

### **Parentesco Familiar**

| ID | Descripción           |
|----|-----------------------|
| 2  | PADRE                 |
| 3  | MADRE                 |
| 4  | HIJO                  |
| 5  | CÓNYUGE               |
| 6  | SOBRINO(A)            |
| 7  | HERMANO(A)            |
| 8  | NIETO(A)              |
| 9  | PRIMO(A)              |
| 10 | ABUELO(A)             |
| 11 | COMPAÑERO(A)          |
| 12 | CÓNYUGE SOLIDARIO(A)  |
| 13 | CUÑADO(A)             |
| 14 | ENTIDAD JURÍDICA      |
| 15 | HIJA                  |
| 16 | HERMANASTRO(A)        |
| 17 | HIJASTRO(A)           |
| 18 | MADRASTRA             |
| 19 | NUERA                 |
| 20 | OTRO                  |
| 21 | PADRASTRO             |
| 22 | PRIMO(A)              |
| 23 | SUEGRO(A)             |
| 24 | TÍO(A)                |
| 25 | YERNO                 |

### **Bancos (nombre_banco_cuenta)**

| ID | Descripción                                       |
|----|---------------------------------------------------|
| 1  | BANCO AV VILLAS                                   |
| 2  | BANCO BBVA                                        |
| 3  | BANCO CAJA SOCIAL                                 |
| 4  | BANCO DE BOGOTÁ                                   |
| 5  | BANCO DE CRÉDITO                                  |
| 6  | BANCO DE OCCIDENTE                                |
| 7  | BANCO GNB SUDAMERIS                               |
| 8  | BANCO POPULAR                                     |
| 9  | BANCO ITAU CORPBANCA                              |
| 10 | BANCOLOMBIA                                       |
| 11 | SCOTIABANK COLPATRIA                              |
| 12 | BANCO DAVIVIENDA                                  |
| 13 | BANCOOMEVA                                        |
| 14 | FINANCIERA JURISCOOP                              |
| 15 | BANCO AGRARIO                                     |
| 16 | BANCO PICHINCHA                                   |
| 17 | BANCO FALABELLA                                   |
| 18 | BANCAMIA                                          |
| 19 | BANCO MUNDO MUJER                                 |
| 20 | BANCO CREDIFINANCIERA                             |
| 21 | BANCO SANTANDER DE NEGOCIOS COLOMBIA S.A.         |
| 22 | BANCO SERFINANZA                                  |
| 23 | CITIBANK-COLOMBIA                                 |
| 24 | BANCO                                             |
| 25 | BANCO COOPERATIVO COOPCENTRAL                     |
| 26 | BANCO DE LA MICROEMPRESA DE COLOMBIA MIBANCO      |
| 27 | BANCO J.P. MORGAN COLOMBIA                        |
| 28 | LULO BANK                                         |
| 29 | BANCO BTG PACTUAL COLOMBIA                        |
| 30 | BANCO UNION                                       |
| 31 | CORPORACIÓN FINANCIERA COLOMBIANA CORFICOLOMBIANA |
| 32 | BNP PARIBAS COLOMBIA CORPORACIÓN FINANCIERA       |
| 33 | IRIS CF - COMPAÑÍA DE FINANCIAMIENTO              |
| 34 | CREDIFAMILIA COMPAÑÍA DE FINANCIAMIENTO           |
| 35 | RAPPIPAY COMPAÑÍA DE FINANCIAMIENTO               |
| 36 | NEQUI                                             |
| 37 | NU                                                |

### **NIT Originador / Fideicomiso / Sucursal**

| NIT   | Descripción |
|-------|-------------|
| 1212  | CTL         |

### **Municipios (Códigos DANE)**

Los códigos DANE corresponden al estándar DIVIPOLA del DANE.  
Se utilizan en campos como: `codigo_dane_nacim`, `codigo_dane_resid`, `codigo_dane_exp_doc`, etc.

> **Nota:** La lista completa contiene más de 1100 municipios. Puedes consultar la fuente oficial en:  
> [https://www.datos.gov.co/widgets/gdxc-w37w](https://www.datos.gov.co/widgets/gdxc-w37w)

Ejemplos:

| ID    | Municipio / Departamento                  | Código DANE |
|-------|-------------------------------------------|-------------|
| 05001 | ANTIOQUIA - MEDELLÍN                      | 05001       |
| 11001 | AMAZONAS - LETICIA                        | 91001       |
| 76001 | VALLE DEL CAUCA - CALI                    | 76001       |
| 11000 | VICHADA - PUERTO CARREÑO                  | 99001       |