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
- id_transaccion
- dias_int_ant
- poliza
- nro_personas


`````json
 {
  "datostecfinanza": {
    "nro_documento": "129905111 ",
    "dir_residencia": "CRA 50 60 16",
    "correo": "edgarortizortiz1967@gmail.com",
    "dir_familiar": "CRA 50 60 16",
    "dir_correspondencia": "CRA 50 60 16",
    "dir_empresa_labora": "BUITRERA KM 7",
    "email_labora": "edgarortizortiz1967@gmail.com",
    "dir_ref_fam1": "CALLE 72K # 27B -27",
    "dir_ref_per1": "CALLE 67 # 1E - 24",
    "cuenta_ext1": "",
    "cuenta_ext2": "",
    "no_pagare": "710",
    "poliza": "8600",
    "fecha_expedicion_doc": "1985-09-30",
    "fecha_nacimiento": "1967-07-16",
    "fecha_ingreso": "Aug 30 2005 12:00AM",
    "fecha_ultima": "2024-11-20T15:49:49",
    "fecha_ini_cargo": "",
    "fecha_fin_cargo": "",
    "fecha_desemb": "2025-01-02",
    "fecha_ing_poliza": "2025-01-02",
    "clase_poliza": "1",
    "tipo_cliente": "N",
    "codigo_dane_exp_doc": "52001",
    "codigo_dane_nacim": "25019",
    "codigo_ciiu_cliente": "10",
    "antig_actividad": "233",
    "codigo_dane_resid": "76001",
    "tel_fijo_resi": "3172127830",
    "tel_cel": "3172127830",
    "codigo_dane_dir_fam": "76001",
    "codigo_dane_dir_corr": "76001",
    "codigo_dane_dir_emp": "76001",
    "tel_fijo_ofi": "",
    "ext_ofi_lab": "",
    "nro_renov_contrato": "",
    "nro_personas": "1",
    "menores_18": "0",
    "codigo_dane_ref_fam1": "76001",
    "tel_ref_fam1": "3155821348",
    "codigo_dane_ref_per1": "76001",
    "tel_ref_per1": "3156035917",
    "nro_cuenta": "giro pin",
    "valor_ingreso_salario": "4258393",
    "valor_ingreso_comisiones": "0",
    "valor_ingreso_honorarios": "0",
    "valor_ingresos_arrend": "0",
    "valor_rendimientos": "0",
    "otros_ingresos": "0",
    "valor_total_ingresos": "4258393.00",
    "valor_deducciones_ley": "366176",
    "valor_otras_deducciones": "0",
    "valor_arrend_cliente": "0",
    "valor_cuota_credito": "0",
    "valor_gastos_tarjeta": "0",
    "valor_gastos_familiares": "1500000",
    "valor_gastos_sost": "0",
    "valor_pago_otros_creditos": "0",
    "otros_egresos": "0",
    "valor_total_egresos": "1866176",
    "valor_activos_corrientes": "0",
    "valor_activos_fijos": "250000000",
    "valor_otros_activos": "0",
    "total_activos": "250000000",
    "valor_pasivos_financieros": "5000000",
    "valor_pasivos_corrientes": "0",
    "valor_otros_pasivos": "0",
    "total_pasivos": "5000000",
    "patrimonio": "245000000",
    "monto_solicitado": "14334900",
    "monto_cuenta_ext1": "0",
    "monto_cuenta_ext2": "0",
    "puntaje_acierta": "0",
    "nro_cuentas_embargadas": "1",
    "nro_cuentas_canceladas": "0",
    "nro_obligaciones_mora": "1",
    "nro_obligaciones_mora_coop": "0",
    "nro_carteras_castigadas": "0",
    "nro_carteras_dudoso": "0",
    "nro_obligaciones_reestructuradas": "1",
    "nro_obligaciones_calificadas_c": "0",
    "nro_obligaciones_calificadas_d": "0",
    "nro_obligaciones_calificadas_e": "0",
    "nro_moras_30_dias": "0",
    "nro_moras_60_dias": "0",
    "nro_moras_sup_60_dias": "11",
    "nro_entidades_consulta": "0",
    "quanto_minimo": "0",
    "quanto_maximo": "0",
    "quanto_medio": "0",
    "sum_cuotas_creditos": "200000",
    "sum_saldos_tdc": "47110000",
    "sum_cupos_tdc": "50000000",
    "cuota_cupo_tdcconting": "0",
    "cuota_cupo_rotausado": "1571631.4565566",
    "cuota_cupo_rotaconting": "31816.2793487163",
    "gastos_familiares_pensionado": "0",
    "gastos_familiares_activo": "1150487.29166667",
    "gastos_financieros": "1803447.73590531",
    "porcent_endeudamiento": "0.731873366174438",
    "tasa_usura_ultimos_meses": "2.071825",
    "nro_embargos_pago": "0",
    "nro_procesos_civiles": "0",
    "nit_custodia": "900690783",
    "nit_originador": "900690783",
    "nit_pagaduria": "8903990113",
    "nit_fideicomisos": "9016191431",
    "codigo_fideicomiso": "",
    "valor_desembolso": "14334900.00",
    "plazo_inicial_credito": "53",
    "tasa_interes": "1.600000",
    "valor_aval": "0.00",
    "periodicidad": "2",
    "porcentaje_reserva": "83.2",
    "prima_segvida": "10909.00",
    "no_doc_benef_grat1": "1141542334",
    "porc_benef_grat1": "100",
    "no_doc_benef_grat2": "",
    "porc_benef_grat2": "0",
    "no_doc_benef_grat3": "",
    "porc_benef_grat3": "0",
    "tipo_entidad": "LIBRANZA PUBLICA",
    "cliente_declara": "SI",
    "desempena_cargo": "2",
    "manejo_recursos": "2",
    "representa_organizacion": "",
    "cliente_es_pep": "2",
    "vinculo_con_pep": "NO",
    "reconocimiento_publico": "2",
    "posee_cuenta": "NO",
    "realiza_operaciones": "NO",
    "importaciones": "NO",
    "credito_documentario": "NO",
    "giros_directos": "NO",
    "negociacion_divisas": "NO",
    "leasing_importacion": "NO",
    "giros_financiados": "NO",
    "exportaciones": "NO",
    "inversiones": "NO",
    "venta_bienes": "NO",
    "honorarios_comisiones": "NO",
    "ingresos_actividad": "NO",
    "prestamo_bancario": "NO",
    "rifas": "NO",
    "pension": "NO",
    "herencia": "NO",
    "liq_prestaciones": "NO",
    "liq_sucesiones": "NO",
    "otros": "NO",
    "cuentas_moneda_ext": "NO",
    "permanencia_eeuu": "NO",
    "tarjeta_verde": "NO",
    "ingresos_fdap": "NO",
    "ingreso_bruto_venta": "NO",
    "ciudadano_eeuu": "NO",
    "obligado_tributar": "NO",
    "coincidencia_listas": "NO",
    "procesos_cooperativa": "NO",
    "extraprima": "NO",
    "primer_apellido": "ORTIZ",
    "segundo_apellido": "ORTIZ",
    "primer_nombre": "EDGAR",
    "segundo_nombre": "ARTURO",
    "tipo_doc": "1",
    "pais_nacimiento": "COLOMBIA",
    "nacionalidad": "COLOMBIANA",
    "genero": "1",
    "estado_civil": "4",
    "nivel_estudios": "3",
    "grupo_etnico": "6",
    "profesion": "DOCENTE",
    "ocupacion": "1",
    "clase_cliente": "",
    "barrio_resi": "BRISAS DEL LIMONAR",
    "estrato_resi": "3",
    "tipo_vivienda": "4",
    "nombre_empresa": "SECRETARIA DE EDUCACION DE CALI",
    "punto_venta": "PRINCIPAL",
    "tipo_contrato": "13",
    "tipo_empresa": "1",
    "cargo_actual": "DOCENTE",
    "cargo_politico": "",
    "nombre_ref_fam1": "HENRY ORTIZ CIRDOBA",
    "parentesco_ref_fam1": "22",
    "nombre_ref_per1": "FABIAN BETANCOURT",
    "nombre_banco_cuenta": "BANCOLOMBIA",
    "tipo_cuenta": "1",
    "desc_otros_activos": "0",
    "desc_otros_pasivos": "0",
    "otros_activos_pasivos": "0",
    "nombre_banco_ext1": "",
    "tipo_producto_ext1": "",
    "moneda_ext1": "",
    "ciudad_banco_ext1": "",
    "pais_banco_ext1": "",
    "nombre_banco_ext2": "",
    "tipo_producto_ext2": "",
    "moneda_ext2": "",
    "ciudad_banco_ext2": "",
    "pais_banco_ext2": "",
    "calificacion_cliente": "0",
    "tipo_cliente_datacredito": "1",
    "tipo_libranza": "2",
    "razon_social_originador": "VANTAGE THE FINANCE PRACTICE SAS",
    "razon_social_pagaduria": "SECRETARIA DE EDUCACION DE CALI",
    "segmento_libranza": "1",
    "razon_social_fideicomisos": "FIDEICOMISO MASTER TRUST - VANTAGE/ONEST",
    "fondeador": "",
    "oficina_asociado": "CALI",
    "tipo_aval": "3",
    "benef_grat1": " Joshué Ortiz Robles",
    "benef_grat2": "",
    "benef_grat3": "",
    "int_anticipado": "462387.00",
    "p_patrimonial": "1290141.00",
    "gto_plataforma": "0.00",
    "corretaje": "716745.00",
    "seguro_incorporacion": "0.00",
    "estudio_credito": "477639.00",
    "gmf": "57340.00",
    "descuento_giro": "24000.00",
    "valor_prestamo_sin_c": "1457000",
    "valor_prestamo_sin_r": "200000",
    "valor_prestamo_sin_cc": "0",
    "total_oblm_sf": "0",
    "total_oblm_mayor_7": "0",
    "total_obl_castigadas_mayor_15": "0",
    "total_oblm_mayor_90": "1",
    "total_deuda_sf": "47110000",
    "total_deuda_sc": "0",
    "total_deuda_sr": "2318000",
    "nro_solicitud": "2736                ",
    "fecha_solicitud": "2024-11-20",
    "barrio_empresa": "BUITRERA",
    "email_ref_fam1": "hortiz@hotmail.com",
    "email_ref_pers1": "fabi25@gmail.com",
    "det_otros_ingr": "arriendos",
    "departamento_residencia": "76",
    "departamento_empresa": "76",
    "cuota_corriente": "403200.00",
    "valor_cuota_total": "414109.00",
    "origen_fondos": "SALARIO",
    "ingresos_brutos": "4601949.16666667",
    "estado_credito": "Desembolsado",
    "cambio_condiciones": "NO",
    "dias_int_ant": "60",
    "codigo_region": "",
    "id_transaccion": "156711",
    "parentesco1": "hijo",
    "parentesco2": "",
    "parentesco3": ""
  }
}

`````

### **Respuesta Success**

``````json
{
  "status": "success",
  "data": {
    "id": 3,
    "nro_documento": "129905111 ",
    "dir_residencia": "CRA 50 60 16",
    "correo": "edgarortizortiz1967@gmail.com",
    "dir_familiar": "CRA 50 60 16",
    "dir_correspondencia": "CRA 50 60 16",
    "dir_empresa_labora": "BUITRERA KM 7",
    "email_labora": "edgarortizortiz1967@gmail.com",
    "dir_ref_fam1": "CALLE 72K # 27B -27",
    "dir_ref_per1": "CALLE 67 # 1E - 24",
    "cuenta_ext1": "",
    "cuenta_ext2": "",
    "no_pagare": "710",
    "poliza": "8600",
    "fecha_expedicion_doc": "1985-09-30",
    "fecha_nacimiento": "1967-07-16",
    "fecha_ingreso": "Aug 30 2005 12:00AM",
    "fecha_ultima": "2024-11-20T15:49:49",
    "fecha_ini_cargo": "",
    "fecha_fin_cargo": "",
    "fecha_desemb": "2025-01-02",
    "fecha_ing_poliza": "2025-01-02",
    "clase_poliza": "1",
    "tipo_cliente": "N",
    "codigo_dane_exp_doc": "52001",
    "codigo_dane_nacim": "25019",
    "codigo_ciiu_cliente": "10",
    "antig_actividad": "233",
    "codigo_dane_resid": "76001",
    "tel_fijo_resi": "3172127830",
    "tel_cel": "3172127830",
    "codigo_dane_dir_fam": "76001",
    "codigo_dane_dir_corr": "76001",
    "codigo_dane_dir_emp": "76001",
    "tel_fijo_ofi": "",
    "ext_ofi_lab": "",
    "nro_renov_contrato": "",
    "nro_personas": "1",
    "menores_18": "0",
    "codigo_dane_ref_fam1": "76001",
    "tel_ref_fam1": "3155821348",
    "codigo_dane_ref_per1": "76001",
    "tel_ref_per1": "3156035917",
    "nro_cuenta": "giro pin",
    "valor_ingreso_salario": "4258393",
    "valor_ingreso_comisiones": "0",
    "valor_ingreso_honorarios": "0",
    "valor_ingresos_arrend": "0",
    "valor_rendimientos": "0",
    "otros_ingresos": "0",
    "valor_total_ingresos": "4258393.00",
    "valor_deducciones_ley": "366176",
    "valor_otras_deducciones": "0",
    "valor_arrend_cliente": "0",
    "valor_cuota_credito": "0",
    "valor_gastos_tarjeta": "0",
    "valor_gastos_familiares": "1500000",
    "valor_gastos_sost": "0",
    "valor_pago_otros_creditos": "0",
    "otros_egresos": "0",
    "valor_total_egresos": "1866176",
    "valor_activos_corrientes": "0",
    "valor_activos_fijos": "250000000",
    "valor_otros_activos": "0",
    "total_activos": "250000000",
    "valor_pasivos_financieros": "5000000",
    "valor_pasivos_corrientes": "0",
    "valor_otros_pasivos": "0",
    "total_pasivos": "5000000",
    "patrimonio": "245000000",
    "monto_solicitado": "14334900",
    "monto_cuenta_ext1": "0",
    "monto_cuenta_ext2": "0",
    "puntaje_acierta": "0",
    "nro_cuentas_embargadas": "1",
    "nro_cuentas_canceladas": "0",
    "nro_obligaciones_mora": "1",
    "nro_obligaciones_mora_coop": "0",
    "nro_carteras_castigadas": "0",
    "nro_carteras_dudoso": "0",
    "nro_obligaciones_reestructuradas": "1",
    "nro_obligaciones_calificadas_c": "0",
    "nro_obligaciones_calificadas_d": "0",
    "nro_obligaciones_calificadas_e": "0",
    "nro_moras_30_dias": "0",
    "nro_moras_60_dias": "0",
    "nro_moras_sup_60_dias": "11",
    "nro_entidades_consulta": "0",
    "quanto_minimo": "0",
    "quanto_maximo": "0",
    "quanto_medio": "0",
    "sum_cuotas_creditos": "200000",
    "sum_saldos_tdc": "47110000",
    "sum_cupos_tdc": "50000000",
    "cuota_cupo_tdcconting": "0",
    "cuota_cupo_rotausado": "1571631.4565566",
    "cuota_cupo_rotaconting": "31816.2793487163",
    "gastos_familiares_pensionado": "0",
    "gastos_familiares_activo": "1150487.29166667",
    "gastos_financieros": "1803447.73590531",
    "porcent_endeudamiento": "0.731873366174438",
    "tasa_usura_ultimos_meses": "2.071825",
    "nro_embargos_pago": "0",
    "nro_procesos_civiles": "0",
    "nit_custodia": "900690783",
    "nit_originador": "900690783",
    "nit_pagaduria": "8903990113",
    "nit_fideicomisos": "9016191431",
    "codigo_fideicomiso": "",
    "valor_desembolso": "14334900.00",
    "plazo_inicial_credito": "53",
    "tasa_interes": "1.600000",
    "valor_aval": "0.00",
    "periodicidad": "2",
    "porcentaje_reserva": "83.2",
    "prima_segvida": "10909.00",
    "no_doc_benef_grat1": "1141542334",
    "porc_benef_grat1": "100",
    "no_doc_benef_grat2": "",
    "porc_benef_grat2": "0",
    "no_doc_benef_grat3": "",
    "porc_benef_grat3": "0",
    "tipo_entidad": "LIBRANZA PUBLICA",
    "cliente_declara": "SI",
    "desempena_cargo": "2",
    "manejo_recursos": "2",
    "representa_organizacion": "",
    "cliente_es_pep": "2",
    "vinculo_con_pep": "NO",
    "reconocimiento_publico": "2",
    "posee_cuenta": "NO",
    "realiza_operaciones": "NO",
    "importaciones": "NO",
    "credito_documentario": "NO",
    "giros_directos": "NO",
    "negociacion_divisas": "NO",
    "leasing_importacion": "NO",
    "giros_financiados": "NO",
    "exportaciones": "NO",
    "inversiones": "NO",
    "venta_bienes": "NO",
    "honorarios_comisiones": "NO",
    "ingresos_actividad": "NO",
    "prestamo_bancario": "NO",
    "rifas": "NO",
    "pension": "NO",
    "herencia": "NO",
    "liq_prestaciones": "NO",
    "liq_sucesiones": "NO",
    "otros": "NO",
    "cuentas_moneda_ext": "NO",
    "permanencia_eeuu": "NO",
    "tarjeta_verde": "NO",
    "ingresos_fdap": "NO",
    "ingreso_bruto_venta": "NO",
    "ciudadano_eeuu": "NO",
    "obligado_tributar": "NO",
    "coincidencia_listas": "NO",
    "procesos_cooperativa": "NO",
    "extraprima": "NO",
    "primer_apellido": "ORTIZ",
    "segundo_apellido": "ORTIZ",
    "primer_nombre": "EDGAR",
    "segundo_nombre": "ARTURO",
    "tipo_doc": "1",
    "pais_nacimiento": "COLOMBIA",
    "nacionalidad": "COLOMBIANA",
    "genero": "1",
    "estado_civil": "4",
    "nivel_estudios": "3",
    "grupo_etnico": "6",
    "profesion": "DOCENTE",
    "ocupacion": "1",
    "clase_cliente": "",
    "barrio_resi": "BRISAS DEL LIMONAR",
    "estrato_resi": "3",
    "tipo_vivienda": "4",
    "nombre_empresa": "SECRETARIA DE EDUCACION DE CALI",
    "punto_venta": "PRINCIPAL",
    "tipo_contrato": "13",
    "tipo_empresa": "1",
    "cargo_actual": "DOCENTE",
    "cargo_politico": "",
    "nombre_ref_fam1": "HENRY ORTIZ CIRDOBA",
    "parentesco_ref_fam1": "22",
    "nombre_ref_per1": "FABIAN BETANCOURT",
    "nombre_banco_cuenta": "BANCOLOMBIA",
    "tipo_cuenta": "1",
    "desc_otros_activos": "0",
    "desc_otros_pasivos": "0",
    "otros_activos_pasivos": "0",
    "nombre_banco_ext1": "",
    "tipo_producto_ext1": "",
    "moneda_ext1": "",
    "ciudad_banco_ext1": "",
    "pais_banco_ext1": "",
    "nombre_banco_ext2": "",
    "tipo_producto_ext2": "",
    "moneda_ext2": "",
    "ciudad_banco_ext2": "",
    "pais_banco_ext2": "",
    "calificacion_cliente": "0",
    "tipo_cliente_datacredito": "1",
    "tipo_libranza": "2",
    "razon_social_originador": "VANTAGE THE FINANCE PRACTICE SAS",
    "razon_social_pagaduria": "SECRETARIA DE EDUCACION DE CALI",
    "segmento_libranza": "1",
    "razon_social_fideicomisos": "FIDEICOMISO MASTER TRUST - VANTAGE/ONEST",
    "fondeador": "",
    "oficina_asociado": "CALI",
    "tipo_aval": "3",
    "benef_grat1": " Joshué Ortiz Robles",
    "benef_grat2": "",
    "benef_grat3": "",
    "int_anticipado": "462387.00",
    "p_patrimonial": "1290141.00",
    "gto_plataforma": "0.00",
    "corretaje": "716745.00",
    "seguro_incorporacion": "0.00",
    "estudio_credito": "477639.00",
    "gmf": "57340.00",
    "descuento_giro": "24000.00",
    "valor_prestamo_sin_c": "1457000",
    "valor_prestamo_sin_r": "200000",
    "valor_prestamo_sin_cc": "0",
    "total_oblm_sf": "0",
    "total_oblm_mayor_7": "0",
    "total_obl_castigadas_mayor_15": "0",
    "total_oblm_mayor_90": "1",
    "total_deuda_sf": "47110000",
    "total_deuda_sc": "0",
    "total_deuda_sr": "2318000",
    "nro_solicitud": "2736                ",
    "fecha_solicitud": "2024-11-20",
    "barrio_empresa": "BUITRERA",
    "email_ref_fam1": "hortiz@hotmail.com",
    "email_ref_pers1": "fabi25@gmail.com",
    "det_otros_ingr": "arriendos",
    "departamento_residencia": "76",
    "departamento_empresa": "76",
    "cuota_corriente": "403200.00",
    "valor_cuota_total": "414109.00",
    "origen_fondos": "SALARIO",
    "ingresos_brutos": "4601949.16666667",
    "estado_credito": "Desembolsado",
    "cambio_condiciones": "NO",
    "dias_int_ant": "60",
    "codigo_region": "",
    "id_transaccion": "156711",
    "parentesco1": "hijo",
    "parentesco2": "",
    "parentesco3": "",
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