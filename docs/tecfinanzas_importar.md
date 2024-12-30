# SERVICIO IMPORTAR DATOS

**Descripción:** Este servicio permite recibir los 224 parametros para el proceso de creacion de los datos demograficos
y información financiera dentro de TESEO.

**Tipo de Servicio:** POST

## URL de Integración

- **Prueba:** `http://testing-sygma.com/api/tecfinanzas/importar_datos`
- **Producción:** `POR_DEFINIR/api/tecfinanzas/importar_datos`

## Headers

El proceso requiere los siguientes encabezados en la solicitud:

- **Accept:** `application/json` (Obligatorio)
- **Content-Type:** `application/json` (Obligatorio)
- **Authorization:** `Bearer ${token}` (Obligatorio)

## Cuerpo de la Solicitud (raw)

La información debe enviarse en formato JSON. **Ejemplo:**

### Campos Obligatorios

- Son obligatorios para que el proceso responda correctamente

- nro_documento
- no_pagare
- fecha_desemb
- tipo_libranza
- segmento_libranza
- nit_originador
- nit_pagaduria
- nit_fideicomisos
- valor_desembolso
- plazo_inicial_credito
- tasa_interes
- valor_aval
- tipo_entidad
- primer_apellido
- primer_nombre
- tipo_doc

`````json
{
  "datostecfinanza": {
    "nro_documento": "103662551",
    "dir_residencia": "123 Main St",
    "correo": "andres1@gmail.com",
    "dir_familiar": "456 Elm St",
    "dir_correspondencia": "789 Maple Ave",
    "dir_empresa_labora": "101 Pine Rd",
    "email_labora": "work@example.com",
    "dir_ref_fam1": "123 Oak St",
    "dir_ref_per1": "789 Cedar St",
    "cuenta_ext1": "000111222",
    "cuenta_ext2": "333444555",
    "no_pagare": "PG123456",
    "nro_solicitud": "CR1234567890",
    "poliza": "POL123456",
    "fecha_expedicion_doc": "1980-01-01",
    "fecha_nacimiento": "1980-01-01",
    "fecha_ingreso": "2022-01-01",
    "fecha_ultima": "2024-01-01",
    "fecha_ini_cargo": "2022-01-01",
    "fecha_fin_cargo": "2024-01-01",
    "fecha_desemb": "2024-01-01",
    "fecha_ing_poliza": "2024-01-01",
    "clase_poliza": "Clase A",
    "tipo_cliente": "Tipo 1",
    "codigo_dane_exp_doc": 12345,
    "codigo_dane_nacim": 67890,
    "codigo_ciiu_cliente": 1234,
    "antig_actividad": 5,
    "codigo_dane_resid": 54321,
    "tel_fijo_resi": "1234567890",
    "tel_cel": "0987654321",
    "codigo_dane_dir_fam": 11223,
    "codigo_dane_dir_corr": 44556,
    "codigo_dane_dir_emp": 77889,
    "tel_fijo_ofi": "1112233445",
    "ext_ofi_lab": "123",
    "nro_renov_contrato": "RENOV123",
    "nro_personas": 4,
    "menores_18": 2,
    "codigo_dane_ref_fam1": 33445,
    "tel_ref_fam1": "5566778899",
    "codigo_dane_ref_per1": 88990,
    "tel_ref_per1": "1122334455",
    "nro_cuenta": 123456,
    "valor_ingreso_salario": 3000000,
    "valor_ingreso_comisiones": 500000,
    "valor_ingreso_honorarios": 1000000,
    "valor_ingresos_arrend": 200000,
    "valor_rendimientos": 150000,
    "otros_ingresos": 100000,
    "valor_total_ingresos": 6000000,
    "valor_deducciones_ley": 500000,
    "valor_otras_deducciones": 200000,
    "valor_arrend_cliente": 300000,
    "valor_cuota_credito": 1000000,
    "valor_gastos_tarjeta": 50000,
    "valor_gastos_familiares": 200000,
    "valor_gastos_sost": 50000,
    "valor_pago_otros_creditos": 150000,
    "otros_egresos": 100000,
    "valor_total_egresos": 2000000,
    "valor_activos_corrientes": 5000000,
    "valor_activos_fijos": 2000000,
    "valor_otros_activos": 1000000,
    "total_activos": 8000000,
    "valor_pasivos_financieros": 3000000,
    "valor_pasivos_corrientes": 1000000,
    "valor_otros_pasivos": 500000,
    "total_pasivos": 4500000,
    "patrimonio": 3500000,
    "monto_solicitado": 1000000,
    "monto_cuenta_ext1": 500000,
    "monto_cuenta_ext2": 200000,
    "puntaje_acierta": 800,
    "barrio_resi": "Centro",
    "estrato_resi": 4,
    "tipo_vivienda": "2",
    "nombre_empresa": "Tech Solutions",
    "punto_venta": "Sucursal A",
    "tipo_contrato": "4",
    "tipo_empresa": "S.A.",
    "cargo_actual": "Gerente",
    "cargo_politico": "Ninguno",
    "nombre_ref_fam1": "Referencia1",
    "parentesco_ref_fam1": "Hermano",
    "nombre_ref_per1": "Referencia3",
    "nombre_banco_cuenta": "60",
    "tipo_cuenta": "1",
    "desc_otros_activos": "N/A",
    "desc_otros_pasivos": "N/A",
    "otros_activos_pasivos": "N/A",
    "nombre_banco_ext1": "Banco XYZ",
    "tipo_producto_ext1": "Cuenta",
    "moneda_ext1": "USD",
    "ciudad_banco_ext1": "Nueva York",
    "pais_banco_ext1": "EE.UU.",
    "nombre_banco_ext2": "Banco DEF",
    "tipo_producto_ext2": "Ahorros",
    "moneda_ext2": "USD",
    "ciudad_banco_ext2": "Los Ángeles",
    "pais_banco_ext2": "EE.UU.",
    "calificacion_cliente": "Excelente",
    "tipo_cliente_datacredito": "Regular",
    "tipo_libranza": "COMPRA CARTERA",
    "razon_social_originador": "Originador S.A.",
    "razon_social_pagaduria": "Pagaduría S.A.",
    "segmento_libranza": "Segmento A",
    "razon_social_fideicomisos": "Fideicomisos S.A.",
    "fondeador": "Fondeador A",
    "oficina_asociado": "Oficina 1",
    "tipo_aval": "Aval A",
    "benef_grat1": "Beneficio 1",
    "benef_grat2": "Beneficio 2",
    "p_patrimonial": 7937316.00,
    "nro_cuentas_embargadas": 1,
    "nro_cuentas_canceladas": 2,
    "nro_obligaciones_mora": 3,
    "nro_obligaciones_mora_coop": 1,
    "nro_carteras_castigadas": 0,
    "nro_carteras_dudoso": 2,
    "nro_obligaciones_reestructuradas": 1,
    "nro_obligaciones_calificadas_C": 0,
    "nro_obligaciones_calificadas_D": 1,
    "nro_obligaciones_calificadas_E": 0,
    "nro_moras_30_dias": 2,
    "nro_moras_60_dias": 1,
    "nro_moras_sup_60_dias": 0,
    "nro_entidades_consulta": 3,
    "quanto_minimo": 1000000,
    "quanto_maximo": 5000000,
    "quanto_medio": 3000000,
    "sum_cuotas_creditos": 2000000,
    "sum_saldos_tdc": 1500000,
    "sum_cupos_tdc": 1000000,
    "nro_embargos_pago": 1,
    "nro_procesos_civiles": 0,
    "nit_custodia": 123456,
    "nit_originador": 900690783,
    "nit_pagaduria": 8181818,
    "nit_fideicomisos": 1001,
    "codigo_fideicomiso": 990011,
    "valor_desembolso": 5000000,
    "plazo_inicial_credito": 24,
    "tasa_interes": 5.25,
    "valor_aval": 1000000,
    "periodicidad": 12,
    "porcentaje_reserva": 2.00,
    "prima_segvida": 300000,
    "no_doc_benef_grat1": 12345,
    "porc_benef_grat1": 0.10,
    "no_doc_benef_grat2": 67890,
    "porc_benef_grat2": 0.15,
    "tipo_entidad": "Entidad A",
    "cliente_declara": "Sí",
    "desempena_cargo": "No",
    "manejo_recursos": "Sí",
    "representa_organizacion": "No",
    "cliente_es_pep": "No",
    "vinculo_con_pep": "N/A",
    "reconocimiento_publico": "Sí",
    "posee_cuenta": "Sí",
    "realiza_operaciones": "Sí",
    "importaciones": "No",
    "credito_documentario": "Sí",
    "giros_directos": "No",
    "negociacion_divisas": "Sí",
    "leasing_importacion": "No",
    "giros_financiados": "Sí",
    "exportaciones": "No",
    "inversiones": "Sí",
    "venta_bienes": "No",
    "honorarios_comisiones": "Sí",
    "ingresos_actividad": "Sí",
    "prestamo_bancario": "No",
    "rifas": "No",
    "pension": "Sí",
    "herencia": "No",
    "liq_prestaciones": "Sí",
    "liq_sucesiones": "No",
    "otros": "N/A",
    "cuentas_moneda_ext": "Sí",
    "permanencia_eeuu": "No",
    "tarjeta_verde": "No",
    "ingresos_fdap": "No",
    "ingreso_bruto_venta": "Sí",
    "ciudadano_eeuu": "No",
    "obligado_tributar": "Sí",
    "coincidencia_listas": "No",
    "procesos_cooperativa": "No",
    "extraprima": "No",
    "primer_apellido": "Apellido1",
    "segundo_apellido": "Apellido2",
    "primer_nombre": "Nombre1",
    "segundo_nombre": "Nombre2",
    "tipo_doc": "CC",
    "pais_nacimiento": "Colombia",
    "nacionalidad": "Colombiana",
    "genero": "1",
    "estado_civil": "1",
    "nivel_estudios": "Universitario",
    "grupo_etnico": "Ninguno",
    "profesion": "1",
    "ocupacion": "Desarrollador",
    "clase_cliente": "VIP",
    "cuotas_credito": 0.00,
    "cuota_cupo_tdcusado": 0.00,
    "cuota_cupo_tdcconting": 0.00,
    "cuota_cupo_rotausado": 0.00,
    "cuota_cupo_rotaconting": 0.00,
    "gastos_familiares_pensionado": 0.00,
    "gastos_familiares_activo": 0.00,
    "tasa_usura_ultimos_meses": 0.00,
    "gastos_financieros": 0.00,
    "porcent_endeudamiento": 0.00,
    "dias_int_ant": 0.00,
    "int_anticipado": 2844734.00,
    "gto_plataforma": 2844734.00,
    "valor_prestamo_sin_c": 0.00,
    "valor_prestamo_sin_r": 0.00,
    "valor_prestamo_sin_cc": 0.00,
    "total_oblm_sf": 0.00,
    "total_oblm_mayor_7": 0.00,
    "total_obl_castigadas_mayor_15": 0.00,
    "total_oblm_mayor_90": 0.00,
    "total_deuda_sf": 0.00,
    "total_deuda_sc": 0.00,
    "total_deuda_sr": 0.00,
    "valor_cuota_total": 0.00,
    "email_ref_fam1": "work@example.com",
    "email_ref_pers1": "work@example.com",
    "fecha_solicitud": "1980-01-01",
    "barrio_empresa": "Las lomitas",
    "det_otros_ingr": "ingresos de sygma-tech",
    "origen_fondos": "Por pago de nomina",
    "ingresos_brutos": 10000000.00,
    "estado_credito": "PAGADO",
    "departamento_residencia": "Antioquia",
    "departamento_empresa": "Antioquia",
    "cuota_corriente": 200000.00
  }
}

`````

### Respuesta Success

``````json
{
  "status": "success",
  "data": {
    "id": 3,
    "nro_documento": "103662551",
    "dir_residencia": "123 Main St",
    "correo": "andres1@gmail.com",
    "dir_familiar": "456 Elm St",
    "dir_correspondencia": "789 Maple Ave",
    "dir_empresa_labora": "101 Pine Rd",
    "email_labora": "work@example.com",
    "dir_ref_fam1": "123 Oak St",
    "dir_ref_per1": "789 Cedar St",
    "cuenta_ext1": "000111222",
    "cuenta_ext2": "333444555",
    "no_pagare": "PG123456",
    "nro_solicitud": "CR1234567890",
    "poliza": "POL123456",
    "fecha_expedicion_doc": "1980-01-01",
    "fecha_nacimiento": "1980-01-01",
    "fecha_ingreso": "2022-01-01",
    "fecha_ultima": "2024-01-01",
    "fecha_ini_cargo": "2022-01-01",
    "fecha_fin_cargo": "2024-01-01",
    "fecha_desemb": "2024-01-01",
    "fecha_ing_poliza": "2024-01-01",
    "clase_poliza": "Clase A",
    "tipo_cliente": "Tipo 1",
    "codigo_dane_exp_doc": 12345,
    "codigo_dane_nacim": 67890,
    "codigo_ciiu_cliente": 1234,
    "antig_actividad": 5,
    "codigo_dane_resid": 54321,
    "tel_fijo_resi": "1234567890",
    "tel_cel": "0987654321",
    "codigo_dane_dir_fam": 11223,
    "codigo_dane_dir_corr": 44556,
    "codigo_dane_dir_emp": 77889,
    "tel_fijo_ofi": "1112233445",
    "ext_ofi_lab": "123",
    "nro_renov_contrato": "RENOV123",
    "nro_personas": 4,
    "menores_18": 2,
    "codigo_dane_ref_fam1": 33445,
    "tel_ref_fam1": "5566778899",
    "codigo_dane_ref_per1": 88990,
    "tel_ref_per1": "1122334455",
    "nro_cuenta": 123456,
    "valor_ingreso_salario": 3000000,
    "valor_ingreso_comisiones": 500000,
    "valor_ingreso_honorarios": 1000000,
    "valor_ingresos_arrend": 200000,
    "valor_rendimientos": 150000,
    "otros_ingresos": 100000,
    "valor_total_ingresos": 6000000,
    "valor_deducciones_ley": 500000,
    "valor_otras_deducciones": 200000,
    "valor_arrend_cliente": 300000,
    "valor_cuota_credito": 1000000,
    "valor_gastos_tarjeta": 50000,
    "valor_gastos_familiares": 200000,
    "valor_gastos_sost": 50000,
    "valor_pago_otros_creditos": 150000,
    "otros_egresos": 100000,
    "valor_total_egresos": 2000000,
    "valor_activos_corrientes": 5000000,
    "valor_activos_fijos": 2000000,
    "valor_otros_activos": 1000000,
    "total_activos": 8000000,
    "valor_pasivos_financieros": 3000000,
    "valor_pasivos_corrientes": 1000000,
    "valor_otros_pasivos": 500000,
    "total_pasivos": 4500000,
    "patrimonio": 3500000,
    "monto_solicitado": 1000000,
    "monto_cuenta_ext1": 500000,
    "monto_cuenta_ext2": 200000,
    "puntaje_acierta": 800,
    "barrio_resi": "Centro",
    "estrato_resi": 4,
    "tipo_vivienda": "2",
    "nombre_empresa": "Tech Solutions",
    "punto_venta": "Sucursal A",
    "tipo_contrato": "4",
    "tipo_empresa": "S.A.",
    "cargo_actual": "Gerente",
    "cargo_politico": "Ninguno",
    "nombre_ref_fam1": "Referencia1",
    "parentesco_ref_fam1": "Hermano",
    "nombre_ref_per1": "Referencia3",
    "nombre_banco_cuenta": "60",
    "tipo_cuenta": "1",
    "desc_otros_activos": "N/A",
    "desc_otros_pasivos": "N/A",
    "otros_activos_pasivos": "N/A",
    "nombre_banco_ext1": "Banco XYZ",
    "tipo_producto_ext1": "Cuenta",
    "moneda_ext1": "USD",
    "ciudad_banco_ext1": "Nueva York",
    "pais_banco_ext1": "EE.UU.",
    "nombre_banco_ext2": "Banco DEF",
    "tipo_producto_ext2": "Ahorros",
    "moneda_ext2": "USD",
    "ciudad_banco_ext2": "Los Ángeles",
    "pais_banco_ext2": "EE.UU.",
    "calificacion_cliente": "Excelente",
    "tipo_cliente_datacredito": "Regular",
    "tipo_libranza": "COMPRA CARTERA",
    "razon_social_originador": "Originador S.A.",
    "razon_social_pagaduria": "Pagaduría S.A.",
    "segmento_libranza": "Segmento A",
    "razon_social_fideicomisos": "Fideicomisos S.A.",
    "fondeador": "Fondeador A",
    "oficina_asociado": "Oficina 1",
    "tipo_aval": "Aval A",
    "benef_grat1": "Beneficio 1",
    "benef_grat2": "Beneficio 2",
    "p_patrimonial": 7937316.00,
    "nro_cuentas_embargadas": 1,
    "nro_cuentas_canceladas": 2,
    "nro_obligaciones_mora": 3,
    "nro_obligaciones_mora_coop": 1,
    "nro_carteras_castigadas": 0,
    "nro_carteras_dudoso": 2,
    "nro_obligaciones_reestructuradas": 1,
    "nro_obligaciones_calificadas_C": 0,
    "nro_obligaciones_calificadas_D": 1,
    "nro_obligaciones_calificadas_E": 0,
    "nro_moras_30_dias": 2,
    "nro_moras_60_dias": 1,
    "nro_moras_sup_60_dias": 0,
    "nro_entidades_consulta": 3,
    "quanto_minimo": 1000000,
    "quanto_maximo": 5000000,
    "quanto_medio": 3000000,
    "sum_cuotas_creditos": 2000000,
    "sum_saldos_tdc": 1500000,
    "sum_cupos_tdc": 1000000,
    "nro_embargos_pago": 1,
    "nro_procesos_civiles": 0,
    "nit_custodia": 123456,
    "nit_originador": 900690783,
    "nit_pagaduria": 8181818,
    "nit_fideicomisos": 1001,
    "codigo_fideicomiso": 990011,
    "valor_desembolso": 5000000,
    "plazo_inicial_credito": 24,
    "tasa_interes": 5.25,
    "valor_aval": 1000000,
    "periodicidad": 12,
    "porcentaje_reserva": 2.00,
    "prima_segvida": 300000,
    "no_doc_benef_grat1": 12345,
    "porc_benef_grat1": 0.10,
    "no_doc_benef_grat2": 67890,
    "porc_benef_grat2": 0.15,
    "tipo_entidad": "Entidad A",
    "cliente_declara": "Sí",
    "desempena_cargo": "No",
    "manejo_recursos": "Sí",
    "representa_organizacion": "No",
    "cliente_es_pep": "No",
    "vinculo_con_pep": "N/A",
    "reconocimiento_publico": "Sí",
    "posee_cuenta": "Sí",
    "realiza_operaciones": "Sí",
    "importaciones": "No",
    "credito_documentario": "Sí",
    "giros_directos": "No",
    "negociacion_divisas": "Sí",
    "leasing_importacion": "No",
    "giros_financiados": "Sí",
    "exportaciones": "No",
    "inversiones": "Sí",
    "venta_bienes": "No",
    "honorarios_comisiones": "Sí",
    "ingresos_actividad": "Sí",
    "prestamo_bancario": "No",
    "rifas": "No",
    "pension": "Sí",
    "herencia": "No",
    "liq_prestaciones": "Sí",
    "liq_sucesiones": "No",
    "otros": "N/A",
    "cuentas_moneda_ext": "Sí",
    "permanencia_eeuu": "No",
    "tarjeta_verde": "No",
    "ingresos_fdap": "No",
    "ingreso_bruto_venta": "Sí",
    "ciudadano_eeuu": "No",
    "obligado_tributar": "Sí",
    "coincidencia_listas": "No",
    "procesos_cooperativa": "No",
    "extraprima": "No",
    "primer_apellido": "Apellido1",
    "segundo_apellido": "Apellido2",
    "primer_nombre": "Nombre1",
    "segundo_nombre": "Nombre2",
    "tipo_doc": "CC",
    "pais_nacimiento": "Colombia",
    "nacionalidad": "Colombiana",
    "genero": "1",
    "estado_civil": "1",
    "nivel_estudios": "Universitario",
    "grupo_etnico": "Ninguno",
    "profesion": "1",
    "ocupacion": "Desarrollador",
    "clase_cliente": "VIP",
    "cuotas_credito": 0.00,
    "cuota_cupo_tdcusado": 0.00,
    "cuota_cupo_tdcconting": 0.00,
    "cuota_cupo_rotausado": 0.00,
    "cuota_cupo_rotaconting": 0.00,
    "gastos_familiares_pensionado": 0.00,
    "gastos_familiares_activo": 0.00,
    "tasa_usura_ultimos_meses": 0.00,
    "gastos_financieros": 0.00,
    "porcent_endeudamiento": 0.00,
    "dias_int_ant": 0.00,
    "int_anticipado": 2844734.00,
    "gto_plataforma": 2844734.00,
    "valor_prestamo_sin_c": 0.00,
    "valor_prestamo_sin_r": 0.00,
    "valor_prestamo_sin_cc": 0.00,
    "total_oblm_sf": 0.00,
    "total_oblm_mayor_7": 0.00,
    "total_obl_castigadas_mayor_15": 0.00,
    "total_oblm_mayor_90": 0.00,
    "total_deuda_sf": 0.00,
    "total_deuda_sc": 0.00,
    "total_deuda_sr": 0.00,
    "valor_cuota_total": 0.00,
    "email_ref_fam1": "work@example.com",
    "email_ref_pers1": "work@example.com",
    "fecha_solicitud": "1980-01-01",
    "barrio_empresa": "Las lomitas",
    "det_otros_ingr": "ingresos de sygma-tech",
    "origen_fondos": "Por pago de nomina",
    "ingresos_brutos": 10000000.00,
    "estado_credito": "PAGADO",
    "departamento_residencia": "Antioquia",
    "departamento_empresa": "Antioquia",
    "cuota_corriente": 200000.00,
    "created_at": "2024-08-16T17:32:11.761Z",
    "updated_at": "2024-08-16T17:32:11.761Z"
  }
}
``````

### Respuesta Token Invalido

``````json
{
  "status": false,
  "message": "Token Inválido",
  "details": "Signature has expired",
  "code": 400
}
``````

### Respuesta Campos Requeridos

``````json
{
  "status": "error",
  "errors": [
    "Nro documento no puede estar en blanco"
  ]
}
``````

## Descripción de los campos

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