select * from gd_esquema.Maestra

/* PROVINCIA */
insert into SWIFTIES.Provincia (prov_nombre)
(select distinct Alumno_Provincia
from gd_esquema.Maestra
where Alumno_Provincia is not null
union
select distinct Profesor_Provincia
from gd_esquema.Maestra
where Profesor_Provincia is not null
union 
select distinct Sede_Localidad -- Preguntar, estan las localidades aca
from gd_esquema.Maestra
where Sede_Localidad is not null)

/* LOCALIDAD */
insert into SWIFTIES.Localidad (loca_nombre, loca_provincia)
(select distinct Alumno_Localidad, prov_codigo
from gd_esquema.Maestra join SWIFTIES.Provincia on prov_nombre = Alumno_Provincia
where Alumno_Localidad is not null
union
select distinct Profesor_Localidad, prov_codigo
from gd_esquema.Maestra join SWIFTIES.Provincia on prov_nombre = Profesor_Provincia
where Profesor_Localidad is not null
union
select distinct Sede_Provincia, prov_codigo
from gd_esquema.Maestra join SWIFTIES.Provincia on prov_nombre = Sede_Localidad
where Sede_Provincia is not null)

--select * from SWIFTIES.Localidad


/* PROFESOR */
insert into SWIFTIES.Profesor (prof_nombre, prof_dni, prof_apellido, prof_localidad, prof_fecha_nacimiento, prof_mail, prof_direccion, prof_telefono)
select distinct Profesor_nombre,
	Profesor_Dni,
	Profesor_Apellido,
	loca_codigo,
	Profesor_FechaNacimiento,
	Profesor_Mail,
	Profesor_Direccion,
	Profesor_Telefono
from gd_esquema.Maestra
join SWIFTIES.Provincia on Profesor_Provincia = prov_nombre
join SWIFTIES.Localidad on loca_nombre = Profesor_Localidad and prov_codigo = loca_provincia
where Profesor_nombre is not null 

--select * from SWIFTIES.Profesor

/* ALUMNO */
insert into SWIFTIES.Alumno (alum_legajo, alum_nombre, alum_dni, alum_apellido, alum_fecha_nacimiento, alum_mail, alum_direccion, alum_telefono, alum_localida)
select distinct Alumno_Legajo,
	Alumno_Nombre,
	Alumno_Dni,
	Alumno_Apellido,
	Alumno_Mail,
	Alumno_FechaNacimiento,
	Alumno_Direccion,
	Alumno_Telefono,
	loca_codigo
from gd_esquema.Maestra
join SWIFTIES.Provincia on prov_nombre = Alumno_Provincia
join SWIFTIES.Localidad on loca_nombre = Alumno_Localidad and loca_provincia = prov_codigo
where Alumno_Legajo is not null 

--select * from SWIFTIES.Alumno
-- 14980 filas afectadas)
/* INSTITUCION */

insert into SWIFTIES.Institucion (inst_nombre, inst_razon_social, inst_cuit)
select distinct Institucion_Nombre,
	Institucion_RazonSocial,
	Institucion_Cuit
from gd_esquema.Maestra
where Institucion_Cuit is not null


/* SEDE */
insert into SWIFTIES.Sede (sede_nombre, sede_direccion, sede_telefono, sede_localidad, sede_mail, sede_institucion)
select distinct Sede_Nombre,
	Sede_Direccion,
	Sede_Telefono,
	loca_codigo,
	Sede_Mail,
	inst_id
from gd_esquema.Maestra
join SWIFTIES.Localidad on loca_nombre = Sede_Localidad
join SWIFTIES.Institucion on Institucion_Cuit = inst_cuit
where Sede_Nombre is not null


/* CURSO */
insert into SWIFTIES.Curso (curs_codigo, curs_sede, curs_profesor, curs_nombre, curs_descripcion, curs_categoria, curs_duracion, curs_turno, curs_fecha_inicio, curs_precio_mensual)
select distinct m.Curso_Codigo,
	s.sede_id,
	prof_id,
	m.Curso_Nombre,
	m.Curso_Descripcion,
	m.Curso_Categoria,
	m.Curso_DuracionMeses,
	m.Curso_Turno,
	m.Curso_FechaInicio,
	m.Curso_PrecioMensual
from gd_esquema.Maestra m
join SWIFTIES.Sede s on s.sede_Nombre = m.Sede_Nombre
join SWIFTIES.Profesor on Profesor_Dni+Profesor_nombre+Profesor_Apellido=prof_dni+prof_nombre+prof_apellido

--select * from SWIFTIES.Curso

/* ENCUESTA */
insert into SWIFTIES.Encuesta (encu_fecha_registro, encu_curso, encu_observaciones)
select distinct Encuesta_FechaRegistro,
	curs_Codigo,
	Encuesta_Observacion
from gd_esquema.Maestra
join SWIFTIES.Curso on curs_codigo = Curso_Codigo
where Encuesta_FechaRegistro is not null and Encuesta_Observacion is not null

select * from SWIFTIES.Encuesta

/* PREGUNTA_ENCUESTA */
insert into SWIFTIES.Pregunta_Encuesta (preg_encuesta, preg_pregunta)
(select distinct encu_id,
	Encuesta_Pregunta1
from gd_esquema.Maestra
join SWIFTIES.Encuesta on encu_fecha_registro = Encuesta_FechaRegistro and encu_observaciones = Encuesta_Observacion
union
select distinct encu_id,
	Encuesta_Pregunta2
from gd_esquema.Maestra
join SWIFTIES.Encuesta on encu_fecha_registro = Encuesta_FechaRegistro and encu_observaciones = Encuesta_Observacion
union
select distinct encu_id,
	Encuesta_Pregunta3
from gd_esquema.Maestra
join SWIFTIES.Encuesta on encu_fecha_registro = Encuesta_FechaRegistro and encu_observaciones = Encuesta_Observacion
union
select distinct encu_id,
	Encuesta_Pregunta4
from gd_esquema.Maestra
join SWIFTIES.Encuesta on encu_fecha_registro = Encuesta_FechaRegistro and encu_observaciones = Encuesta_Observacion)

/* RESPUESTA_ENCUESTA*/
insert into SWIFTIES.Respuesta_Encuesta (resp_pregunta, resp_nota)
(select distinct preg_id,
	Encuesta_Nota1
from gd_esquema.Maestra
join SWIFTIES.Pregunta_Encuesta on preg_pregunta = Encuesta_Pregunta1
union
select distinct preg_id,
	Encuesta_Nota2
from gd_esquema.Maestra
join SWIFTIES.Pregunta_Encuesta on preg_pregunta = Encuesta_Pregunta2
union
select distinct preg_id,
	Encuesta_Nota3
from gd_esquema.Maestra
join SWIFTIES.Pregunta_Encuesta on preg_pregunta = Encuesta_Pregunta3
union
select distinct preg_id,
	Encuesta_Nota4
from gd_esquema.Maestra
join SWIFTIES.Pregunta_Encuesta on preg_pregunta = Encuesta_Pregunta4)

-- TODO desde aca
/* DIA */
insert into SWIFTIES.Dia (dia_detalle)
select distinct curso_dia 
from gd_esquema.Maestra
where curso_dia is not null


/* DIA_X_CURSO */
insert into SWIFTIES.Dia_x_Curso (dxcu_curso)
select distinct Curso_Codigo,
	d.dia_id
from gd_esquema.Maestra
join SWIFTIES.Dia d on d.dia_detalle = dia_detalle


/* FACTURA */
insert into SWIFTIES.Factura (fact_codigo, fact_fecha_emision, fact_fecha_emision, fact_alumno, fact_importe)
select distinct Factura_codigo,
	Factura_fechaEmision,
	Factura_FechaVencimiento,
	Alumno_Legajo,
	Factura_ImporteTotal
from gd_esquema.Maestra
where Factura_codigo is not null


/* DETALLE_FACTURA */
insert into SWIFTIES.Detalle_Factura (deta_curso, deta_factura, deta_importe, deta_periodo_anio, deta_periodo_mes)
select distinct Curso_Codigo,
	Factura_codigo,
	Detalle_Factura_Importe,
	Periodo_Anio,
	Periodo_Mes
from gd_esquema.Maestra
where Factura_codigo is not null and Curso_Codigo is not null


/* PAGO */
Insert into SWIFTIES.Pago (pago_factura, pago_fecha, pago_importe, pago_medio_de_pago)
select distinct Factura_numero,
	Pago_Fecha,
	Pago_Importe,
	Pago_MedioPago
from gd_esquema.Maestra
where Factura_numero is not null and Pago_Fecha is not null


/* FINAL */
insert into SWIFTIES.Final (fina_descripcion, fina_fecha, fina_hora, fina_curso)
select Examen_final_Descripcion,
	Examen_Final_Fecha,
	Examen_Final_Hora, 
	Curso_Codigo
from gd_esquema.Maestra


/* EVALUACION_FINAL */
insert into SWIFTIES.Evaluacion_Final (evaf_alumno, evaf_final, evaf_nota, evaf_asistencia, evaf_profesor)
select Alumno_Legajo,
	s.final_id, 
	Evaluacion_Final_Nota, 
	Evaluacion_Final_Presente, 
	prof_id 
from gd_esquema.Maestra 
join SWIFTIES.Final s
on Examen_final_Descripcion + Examen_final_hora + Examen_final_fecha = s.Examen_final_Descripcion + s.Examen_Final_Fecha + s.Examen_Final_Hora


/* INSCRIPCION_FINAL */
insert into SWIFTIES.Inscripcion_Final (insf_fecha_inscripcion, insf_alumno, insf_final)
select inscripcion_final_Nro,
	Inscripcion_Final_Fecha, 
	alumno_legajo,
	s.final_id
from gd_esquema.Maestra join SWIFTIES.Final s
on Examen_final_Descripcion + Examen_final_hora + Examen_final_fecha = s.Examen_final_Descripcion + s.Examen_Final_Fecha + s.Examen_Final_Hora


/* TRABAJO PRACTICO */
insert into SWIFTIES.Trabajo_Practico (trab_legajo_alum, trab_curso, trab_nota, trab_fecha)
select Alumno_Legajo,
	Curso_Codigo,
	Trabajo_Practico_Nota,
	Trabajo_Practico_FechaEvaluacion
from gd_esquema.Maestra
where Alumno_Legajo is not null and Curso_Codigo is not null


/* MODULO */
Insert into SWIFTIES.Modulo (modu_nombre, modu_descripcion)
select Modulo_Nombre, Modulo_Descripcion
from gd_esquema.Maestra
where Modulo_Nombre is not null


/* MODULO X CURSO */
Insert into SWIFTIES.Modulo_x_Curso (mxcu_modulo, mxcu_curso)
select Modulo_Nombre, Curso_Codigo
from gd_esquema.Maestra
where Modulo_Nombre is not null and Curso_Codigo is not null


/* EVALUACION PARCIAL */
Insert into SWIFTIES.Evaluacion_Parcial (eval_fecha_evaluacion, eval_presente, eval_nota, eval_alumno, eval_modulo, eval_instancia)
select distinct Evaluacion_Curso_fechaEvaluacion,
	Evaluacion_Curso_Presente,
	Evaluacion_Curso_Nota,
	Alumno_Legajo,
	modu_id,
	Evaluacion_Curso_Instancia
from gd_esquema.Maestra
join SWIFTIES.Modulo on modu_nombre + modu_descripcion = Modulo_Descripcion + Modulo_Nombre



















