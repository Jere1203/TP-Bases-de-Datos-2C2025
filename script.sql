---------------------------------------
-- ELIMINACION DE OBJETOS EXISTENTES --
---------------------------------------
DROP TABLE IF EXISTS SWIFTIES.Evaluacion_Parcial;
DROP TABLE IF EXISTS SWIFTIES.Modulo_x_Curso;
DROP TABLE IF EXISTS SWIFTIES.Modulo;
DROP TABLE IF EXISTS SWIFTIES.Inscripcion_Curso;
DROP TABLE IF EXISTS SWIFTIES.Evaluacion_Final;
DROP TABLE IF EXISTS SWIFTIES.Trabajo_Practico;
DROP TABLE IF EXISTS SWIFTIES.Inscripcion_Final;
DROP TABLE IF EXISTS SWIFTIES.Final;
DROP TABLE IF EXISTS SWIFTIES.Pago;
DROP TABLE IF EXISTS SWIFTIES.Detalle_Factura;
DROP TABLE IF EXISTS SWIFTIES.Factura;
DROP TABLE IF EXISTS SWIFTIES.Dia_x_Curso;
DROP TABLE IF EXISTS SWIFTIES.dia;
DROP TABLE IF EXISTS SWIFTIES.Respuesta_Encuesta;
DROP TABLE IF EXISTS SWIFTIES.Pregunta_Encuesta;
DROP TABLE IF EXISTS SWIFTIES.Encuesta;
DROP TABLE IF EXISTS SWIFTIES.Curso;
DROP TABLE IF EXISTS SWIFTIES.Sede;
DROP TABLE IF EXISTS SWIFTIES.Institucion;
DROP TABLE IF EXISTS SWIFTIES.Alumno;
DROP TABLE IF EXISTS SWIFTIES.Profesor;
DROP TABLE IF EXISTS SWIFTIES.Localidad;
DROP TABLE IF EXISTS SWIFTIES.Provincia;

DROP PROCEDURE IF EXISTS SWIFTIES.Migracion_Provincia
DROP PROCEDURE IF EXISTS SWIFTIES.Migracion_Localidad
DROP PROCEDURE IF EXISTS SWIFTIES.Migracion_Profesor
DROP PROCEDURE IF EXISTS SWIFTIES.Migracion_Alumno
DROP PROCEDURE IF EXISTS SWIFTIES.Migracion_Institucion
DROP PROCEDURE IF EXISTS SWIFTIES.Migracion_Sede
DROP PROCEDURE IF EXISTS SWIFTIES.Migracion_Curso
DROP PROCEDURE IF EXISTS SWIFTIES.Migracion_Encuesta
DROP PROCEDURE IF EXISTS SWIFTIES.Migracion_Pregunta_Encuesta
DROP PROCEDURE IF EXISTS SWIFTIES.Migracion_Respuesta_Encuesta
DROP PROCEDURE IF EXISTS SWIFTIES.Migracion_Dia
DROP PROCEDURE IF EXISTS SWIFTIES.Migracion_Dia_x_Curso
DROP PROCEDURE IF EXISTS SWIFTIES.Migracion_Factura
DROP PROCEDURE IF EXISTS SWIFTIES.Migracion_Detalle_Factura
DROP PROCEDURE IF EXISTS SWIFTIES.Migracion_Pago
DROP PROCEDURE IF EXISTS SWIFTIES.Migracion_Final
DROP PROCEDURE IF EXISTS SWIFTIES.Migracion_Evaluacion_Final
DROP PROCEDURE IF EXISTS SWIFTIES.Migracion_Inscripcion_Final
DROP PROCEDURE IF EXISTS SWIFTIES.Migracion_Inscripcion_Curso
DROP PROCEDURE IF EXISTS SWIFTIES.Migracion_Trabajo_Practico
DROP PROCEDURE IF EXISTS SWIFTIES.Migracion_Modulo
DROP PROCEDURE IF EXISTS SWIFTIES.Migracion_Modulo_x_Curso
DROP PROCEDURE IF EXISTS SWIFTIES.Migracion_Evaluacion_Parcial
DROP PROCEDURE IF EXISTS SWIFTIES.Migracion
go

DROP SCHEMA IF EXISTS SWIFTIES
go
----------------------------------
-- CREACION DE ESQUEMA Y TABLAS --
----------------------------------
create schema SWIFTIES
go

-- Creacion de tabla provicia
Create table SWIFTIES.Provincia(
    prov_codigo int not null identity(1,1) PRIMARY KEY,
    prov_nombre nvarchar(255),
);

-- Creacion de tabla localidad
Create table SWIFTIES.Localidad(
    loca_codigo int not null identity(1,1) PRIMARY KEY,
    loca_nombre nvarchar(255),
    loca_provincia int not null Foreign Key references SWIFTIES.Provincia(prov_codigo)
);

-- Creacion de tabla profesor
Create table SWIFTIES.Profesor(
    prof_id int not null identity(1,1) PRIMARY KEY,
    prof_nombre nvarchar(255),
    prof_dni nvarchar(255),
    prof_apellido nvarchar(255),
    prof_localidad int not null Foreign Key references SWIFTIES.Localidad(loca_codigo),
    prof_fecha_nacimiento DateTime2(6),
    prof_mail nvarchar(255),
    prof_direccion nvarchar(255),
    prof_telefono nvarchar(255)
);

-- Creacion de tabla alumno
Create table SWIFTIES.Alumno(
    alum_legajo bigint not null PRIMARY KEY,
    alum_nombre varchar(255),
    alum_dni bigint,
    alum_apellido varchar(255),
    alum_mail varchar(255),
    alum_fecha_nacimiento DateTime2,
    alum_direccion varchar(255),
    alum_telefono varchar(255),
    alum_localidad int not null Foreign Key references SWIFTIES.Localidad(loca_codigo)
);

-- Creacion de tabla institucion
Create table SWIFTIES.Institucion (
    inst_id int not null identity(1,1) PRIMARY KEY,
    inst_nombre nvarchar(255),
    inst_razon_social nvarchar(255),
    inst_cuit nvarchar(255)
);

-- Creacion de tabla sede
Create table SWIFTIES.Sede (
    sede_id int not null identity(1,1) PRIMARY KEY,
    sede_nombre nvarchar(255),
    sede_direccion nvarchar(255),
    sede_telefono nvarchar(255),
    sede_localidad int not null Foreign Key references SWIFTIES.Localidad(loca_codigo),
    sede_mail nvarchar(255),
    sede_institucion int not null Foreign Key references SWIFTIES.Institucion(inst_id)
);

-- Creacion de tabla curso
Create table SWIFTIES.Curso (
    curs_codigo bigInt not null PRIMARY KEY,
    curs_sede int Foreign Key references SWIFTIES.Sede(sede_id),
    curs_profesor int not null Foreign Key references SWIFTIES.Profesor(prof_id),
    curs_nombre varchar(255),
    curs_descripcion varchar(255),
    curs_categoria varchar(255),
    curs_duracion BigInt,
    curs_turno varchar(255),
    curs_fecha_inicio DateTime2(6),
    curs_precio_mensual decimal(38,2)
);

-- Creacion de tabla encuesta
Create table SWIFTIES.Encuesta (
    encu_id int not null identity(1,1) PRIMARY KEY,
    encu_fecha_registro DateTime2(6),
    encu_curso bigint Foreign Key references SWIFTIES.Curso(curs_codigo),
    encu_observaciones varchar(255)
);

-- Creacion de tabla pregunta_encuesta
Create table SWIFTIES.Pregunta_Encuesta (
    preg_id int not null identity(1,1) PRIMARY KEY,
    preg_encuesta int not null Foreign Key references SWIFTIES.Encuesta(encu_id),
    preg_pregunta varchar(255)
);

-- Creacion de tabla respuesta_encuesta
Create table SWIFTIES.Respuesta_Encuesta (
    resp_id int not null identity(1,1) PRIMARY KEY,
    resp_pregunta int not null Foreign Key references SWIFTIES.Pregunta_Encuesta(preg_id),
    resp_nota bigint
);

-- Creacion de tabla dia
Create table SWIFTIES.Dia (
    dia_id int not null identity(1,1) PRIMARY KEY,
    dia_detalle varchar(255)
);

-- Creacion de tabla dia_x_curso
Create table SWIFTIES.Dia_x_Curso (
    dxcu_curso bigint not null Foreign Key references SWIFTIES.Curso(curs_codigo),
    dxcu_dia int not null Foreign Key references SWIFTIES.Dia(dia_id),
    Constraint dxcu_id PRIMARY KEY (dxcu_curso, dxcu_dia),
);

-- Creacion de tabla factura
Create table SWIFTIES.Factura (
    fact_codigo bigint not null PRIMARY KEY,
    fact_fecha_emision DateTime2(6),
    fact_fecha_vencimiento DateTime2(6),
    fact_alumno bigint not null Foreign Key references SWIFTIES.Alumno(alum_legajo),
    fact_importe decimal(18,2)
);

-- Creacion de tabla detalle_factura
Create table SWIFTIES.Detalle_Factura (
    deta_curso bigint not null Foreign Key references SWIFTIES.Curso(curs_codigo),
    deta_factura bigint not null Foreign Key references SWIFTIES.Factura(fact_codigo),
    Constraint deta_id PRIMARY KEY (deta_curso, deta_factura),
    deta_importe decimal(18,2),
    deta_periodo_anio bigint,
    deta_periodo_mes bigint
);

-- Creacion de tabla pago
Create table SWIFTIES.Pago (
    pago_id int not null identity(1,1) PRIMARY KEY,
    pago_factura bigint not null Foreign Key references SWIFTIES.Factura(fact_codigo),
    pago_fecha DateTime2(6),
    pago_importe decimal(18,2),
    pago_medio_de_pago varchar(255)
);

-- Creacion de tabla final
Create table SWIFTIES.Final (
    fina_id int not null identity(1,1) PRIMARY KEY,
    fina_descripcion varchar(255),
    fina_fecha DateTime2(6),
    fina_hora varchar(255),
    fina_curso bigint not null Foreign Key references SWIFTIES.Curso(curs_codigo)
);

-- Creacion de tabla inscripcion_final
Create table SWIFTIES.Inscripcion_Final (
    insf_id bigint not null PRIMARY KEY,
    insf_fecha_inscripcion DateTime2(6),
    insf_alumno bigint not null Foreign Key references SWIFTIES.Alumno(alum_legajo),
    insf_final int not null Foreign Key references SWIFTIES.Final(fina_id)
);

-- Creacion de tabla trabajo_practico
Create table SWIFTIES.Trabajo_Practico (
    trab_legajo_alum bigint not null Foreign Key references SWIFTIES.Alumno(alum_legajo),
    trab_curso bigint not null Foreign Key references SWIFTIES.Curso(curs_codigo),
    Constraint trab_id PRIMARY KEY (trab_legajo_alum, trab_curso),
    trab_nota bigint,
    trab_fecha DateTime2(6)
);

-- Creacion de tabla evaluacion_final
Create table SWIFTIES.Evaluacion_Final (
    evaf_alumno bigint not null Foreign Key references SWIFTIES.Alumno(alum_legajo),
    evaf_final int not null Foreign Key references SWIFTIES.Final(fina_id),
    evaf_nota bigint,
    Constraint evaf_id PRIMARY KEY (evaf_alumno, evaf_final),
    evaf_asistencia bit,
    evaf_profesor int not null Foreign Key references SWIFTIES.Profesor(prof_id),
);

-- Creacion de tabla inscripcion_curso
Create table SWIFTIES.Inscripcion_Curso (
    insc_codigo bigint not null PRIMARY KEY,
    insc_fecha_inscripcion DateTime2(6),
    insc_curso bigint not null Foreign Key references SWIFTIES.Curso(curs_codigo),
    insc_alumno bigint not null Foreign Key references SWIFTIES.Alumno(alum_legajo),
    insc_estado varchar(255),
    insc_fecha_respuesta DateTime2(6)
);

-- Creacion de tabla modulo
Create table SWIFTIES.Modulo (
    modu_id int not null identity(1,1) PRIMARY KEY,
    modu_descripcion varchar(255),
    modu_nombre varchar(255)
);

-- Creacion de tabla modulo_x_curso
Create table SWIFTIES.Modulo_x_Curso (
    mxcu_modulo int not null Foreign Key references SWIFTIES.Modulo(modu_id),
    mxcu_curso bigint not null Foreign Key references SWIFTIES.Curso(curs_codigo),
    Constraint modu_id PRIMARY KEY (mxcu_curso, mxcu_modulo),
);

-- Creacion de tabla evaluacion_parcial
Create table SWIFTIES.Evaluacion_Parcial (
    eval_id int not null identity(1,1) PRIMARY KEY,
    eval_fecha_evaluacion DateTime2(6),
    eval_presente bit,
    eval_nota bigint,
    eval_alumno bigint not null Foreign Key references SWIFTIES.Alumno(alum_legajo),
    eval_modulo int not null,
    eval_curso bigint not null,
    eval_instancia bigint,
    FOREIGN KEY (eval_curso, eval_modulo) references SWIFTIES.Modulo_x_Curso(mxcu_curso, mxcu_modulo)
);
go
----------------------------
-- CREACION DE PROCEDURES --
----------------------------

-- Migracion PROVINCIA
create procedure SWIFTIES.Migracion_Provincia
as
begin
    set nocount on;
    insert into SWIFTIES.Provincia (prov_nombre)
        (select distinct Alumno_Provincia
            from gd_esquema.Maestra
            where Alumno_Provincia is not null
        union
        select distinct Profesor_Provincia
            from gd_esquema.Maestra
            where Profesor_Provincia is not null
        union 
        select distinct Sede_Localidad -- datos invertidos en la tabla maestra
            from gd_esquema.Maestra
            where Sede_Localidad is not null)
end
go


-- Migracion LOCALIDAD
create procedure SWIFTIES.Migracion_Localidad
as
begin
    set nocount on;
    insert into SWIFTIES.Localidad (loca_nombre, loca_provincia)
        (select distinct Alumno_Localidad, prov_codigo
            from gd_esquema.Maestra join SWIFTIES.Provincia on prov_nombre = Alumno_Provincia
            where Alumno_Localidad is not null
        union
        select distinct Profesor_Localidad, prov_codigo
            from gd_esquema.Maestra join SWIFTIES.Provincia on prov_nombre = Profesor_Provincia
            where Profesor_Localidad is not null
        union
        select distinct Sede_Provincia, prov_codigo -- datos invertidos en la tabla maestra
            from gd_esquema.Maestra join SWIFTIES.Provincia on prov_nombre = Sede_Localidad
            where Sede_Provincia is not null)
end
go

-- Migracion PROFESOR
create procedure SWIFTIES.Migracion_Profesor
as
begin
    set nocount on;
    insert into SWIFTIES.Profesor (prof_nombre, prof_dni, prof_apellido, prof_localidad, prof_fecha_nacimiento, prof_mail, prof_direccion, prof_telefono)
    select distinct Profesor_Apellido,
        Profesor_Dni,
        Profesor_Nombre,
        loca_codigo,
        Profesor_FechaNacimiento,
        Profesor_Mail,
        Profesor_Direccion,
        Profesor_Telefono
    from gd_esquema.Maestra
    join SWIFTIES.Provincia on Profesor_Provincia = prov_nombre
    join SWIFTIES.Localidad on loca_nombre = Profesor_Localidad and prov_codigo = loca_provincia
    where Profesor_nombre is not null 
end
go


-- Migracion ALUMNO
create procedure SWIFTIES.Migracion_Alumno
as
begin
    set nocount on;
    insert into SWIFTIES.Alumno (alum_legajo, alum_nombre, alum_dni, alum_apellido, alum_mail, alum_fecha_nacimiento, alum_direccion, alum_telefono, alum_localidad)
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
end
go


-- Migracion INSTITUCION
create procedure SWIFTIES.Migracion_Institucion
as
begin
    set nocount on;
    insert into SWIFTIES.Institucion (inst_nombre, inst_razon_social, inst_cuit)
    select distinct Institucion_Nombre,
    	Institucion_RazonSocial,
    	Institucion_Cuit
    from gd_esquema.Maestra
    where Institucion_Cuit is not null
end
go


-- Migracion SEDE
create procedure SWIFTIES.Migracion_Sede
as
begin 
    set nocount on;
    insert into SWIFTIES.Sede (sede_nombre, sede_direccion, sede_telefono, sede_localidad, sede_mail, sede_institucion)
    select distinct Sede_Nombre,
    	Sede_Direccion,
    	Sede_Telefono,
    	loca_codigo,
    	Sede_Mail,
    	inst_id
    from gd_esquema.Maestra
    join SWIFTIES.Provincia on prov_nombre = Sede_localidad
    join SWIFTIES.Localidad on loca_nombre = Sede_Provincia and loca_provincia = prov_codigo
    join SWIFTIES.Institucion on Institucion_Cuit = inst_cuit
    where Sede_Nombre is not null
end
go


-- Migracion CURSO
create procedure SWIFTIES.Migracion_Curso
as
begin
    set nocount on;
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
    left join SWIFTIES.Sede s on s.sede_Nombre = m.Sede_Nombre
    join SWIFTIES.Profesor on Profesor_Dni+Profesor_apellido+Profesor_nombre=prof_dni+prof_nombre+prof_apellido
end
go


-- Migracion ENCUESTA
create procedure SWIFTIES.Migracion_Encuesta
as
begin
    set nocount on;
    insert into SWIFTIES.Encuesta (encu_fecha_registro, encu_curso, encu_observaciones)
    select distinct Encuesta_FechaRegistro,
    	curs_Codigo,
    	Encuesta_Observacion
    from gd_esquema.Maestra
    join SWIFTIES.Curso on curs_codigo = Curso_Codigo
    where Encuesta_FechaRegistro is not null and Encuesta_Observacion is not null
end
go


-- Migracion PREGUNTA_ENCUESTA
create procedure SWIFTIES.Migracion_Pregunta_Encuesta
as
begin
    set nocount on;
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
end
go


-- Migracion RESPUESTA_ENCUESTA
create procedure SWIFTIES.Migracion_Respuesta_Encuesta
as
begin
    set nocount on;
    insert into SWIFTIES.Respuesta_Encuesta (resp_pregunta, resp_nota)
    (select preg_id,
    	Encuesta_Nota1
    from gd_esquema.Maestra
    join SWIFTIES.Pregunta_Encuesta on preg_pregunta = Encuesta_Pregunta1
    join SWIFTIES.Encuesta on preg_encuesta = encu_id
    where encu_curso = Curso_Codigo and encu_observaciones = Encuesta_Observacion and encu_fecha_registro = Encuesta_FechaRegistro
    union all
    select preg_id,
    	Encuesta_Nota2
    from gd_esquema.Maestra
    join SWIFTIES.Pregunta_Encuesta on preg_pregunta = Encuesta_Pregunta2
    join SWIFTIES.Encuesta on preg_encuesta = encu_id
    where encu_curso = Curso_Codigo and encu_observaciones = Encuesta_Observacion and encu_fecha_registro = Encuesta_FechaRegistro
    union all
    select preg_id,
    	Encuesta_Nota3
    from gd_esquema.Maestra
    join SWIFTIES.Pregunta_Encuesta on preg_pregunta = Encuesta_Pregunta3
    join SWIFTIES.Encuesta on preg_encuesta = encu_id
    where encu_curso = Curso_Codigo and encu_observaciones = Encuesta_Observacion and encu_fecha_registro = Encuesta_FechaRegistro
    union all
    select preg_id,
    	Encuesta_Nota4
    from gd_esquema.Maestra
    join SWIFTIES.Pregunta_Encuesta on preg_pregunta = Encuesta_Pregunta4
    join SWIFTIES.Encuesta on preg_encuesta = encu_id
    where encu_curso = Curso_Codigo and encu_observaciones = Encuesta_Observacion and encu_fecha_registro = Encuesta_FechaRegistro)
    end
go


-- Migracion DIA
create procedure SWIFTIES.Migracion_Dia
as 
begin
    set nocount on;
    insert into SWIFTIES.Dia (dia_detalle)
    select distinct Curso_Dia
    from gd_esquema.Maestra
    where Curso_Dia is not null
end
go

-- Migracion DIA_X_CURSO
create procedure SWIFTIES.Migracion_Dia_x_Curso
as
begin
    set nocount on;
    insert into SWIFTIES.Dia_x_Curso (dxcu_curso, dxcu_dia)
    select distinct Curso_Codigo,
    	d.dia_id
    from gd_esquema.Maestra
    join SWIFTIES.Dia d on d.dia_detalle = Curso_Dia
    where Curso_Codigo is not null
end
go

-- Migracion INSCRIPCION_curso
create procedure SWIFTIES.Migracion_Inscripcion_Curso
as
begin
    set nocount on;
    insert into SWIFTIES.Inscripcion_Curso (insc_codigo, insc_fecha_inscripcion, insc_curso, insc_alumno, insc_estado, insc_fecha_respuesta)
    select distinct Inscripcion_Numero,
    Inscripcion_Fecha,
    Curso_Codigo,
    Alumno_Legajo,
    Inscripcion_Estado,
    Inscripcion_FechaRespuesta
    from gd_esquema.Maestra
    where Curso_Codigo is not null and Alumno_Legajo is not null and Inscripcion_Numero is not null
end
go

-- Migracion FACTURA
create procedure SWIFTIES.Migracion_Factura
as
begin
    set nocount on;
    insert into SWIFTIES.Factura (fact_codigo, fact_fecha_emision, fact_fecha_vencimiento, fact_alumno, fact_importe)
    select distinct Factura_Numero,
    	Factura_fechaEmision,
    	Factura_FechaVencimiento,
    	Alumno_Legajo,
    	Factura_Total
    from gd_esquema.Maestra
    where Factura_Numero is not null
end
go


-- Migracion DETALLE_FACTURA
create procedure SWIFTIES.Migracion_Detalle_Factura
as
begin
    set nocount on;
    insert into SWIFTIES.Detalle_Factura (deta_curso, deta_factura, deta_importe, deta_periodo_anio, deta_periodo_mes)
    select distinct Curso_Codigo,
    	Factura_Numero,
    	Detalle_Factura_Importe,
    	Periodo_Anio,
    	Periodo_Mes
    from gd_esquema.Maestra
    where Factura_Numero is not null and Curso_Codigo is not null
end
go


-- Migracion Pago
create procedure SWIFTIES.Migracion_Pago
as
begin
    set nocount on;
    Insert into SWIFTIES.Pago (pago_factura, pago_fecha, pago_importe, pago_medio_de_pago)
    select distinct Factura_numero,
        Pago_Fecha,
        Pago_Importe,
        Pago_MedioPago
    from gd_esquema.Maestra
    where Factura_numero is not null and Pago_Fecha is not null
end
go


-- Migracion FINAL
create procedure SWIFTIES.Migracion_Final
as
begin
    set nocount on;
    insert into SWIFTIES.Final (fina_descripcion, fina_fecha, fina_hora, fina_curso)
    select distinct Examen_final_Descripcion,
    	Examen_Final_Fecha,
    	Examen_Final_Hora, 
    	Curso_Codigo
    from gd_esquema.Maestra
    where Examen_Final_Descripcion is not null and Examen_Final_Fecha is not null and Curso_Codigo is not null
end
go


-- Migracion EVALUACION_FINAL
create procedure SWIFTIES.Migracion_Evaluacion_Final
as
begin
    set nocount on;
    insert into SWIFTIES.Evaluacion_Final (evaf_alumno, evaf_final, evaf_nota, evaf_asistencia, evaf_profesor)
    select distinct Alumno_Legajo,
        s.fina_id, 
        Evaluacion_Final_Nota, 
        Evaluacion_Final_Presente, 
        prof_id 
    from gd_esquema.Maestra 
    join SWIFTIES.Final s
    on Examen_final_Descripcion = s.fina_descripcion and Examen_final_hora = s.fina_hora and Examen_final_fecha = s.fina_fecha
    join SWIFTIES.Profesor on Profesor_Dni = prof_dni and Profesor_Apellido = prof_nombre
    where Alumno_Legajo is not null and Evaluacion_Final_Presente is not null
end 
go



-- Migracion INSCRIPCION_FINAL
create procedure SWIFTIES.Migracion_Inscripcion_Final
as
begin
    set nocount on;
    insert into SWIFTIES.Inscripcion_Final (insf_id, insf_fecha_inscripcion, insf_alumno, insf_final)
    select distinct inscripcion_final_Nro,
    	Inscripcion_Final_Fecha, 
    	alumno_legajo,
    	s.fina_id
    from gd_esquema.Maestra join SWIFTIES.Final s
    on Examen_final_Descripcion = s.fina_descripcion and Examen_final_hora = s.fina_hora and Examen_final_fecha = s.fina_fecha
    where Alumno_Legajo is not null and Inscripcion_Final_Nro is not null
end
go


-- Migracion TRABAJO_PRACTICO
create procedure SWIFTIES.Migracion_Trabajo_Practico
as
begin
    set nocount on;
    insert into SWIFTIES.Trabajo_Practico (trab_legajo_alum, trab_curso, trab_nota, trab_fecha)
    select distinct Alumno_Legajo,
        Curso_Codigo,
        Trabajo_Practico_Nota,
        Trabajo_Practico_FechaEvaluacion
    from gd_esquema.Maestra
    where Alumno_Legajo is not null and Curso_Codigo is not null and Trabajo_Practico_Nota is not null and Trabajo_Practico_FechaEvaluacion is not null
end
go


-- Migracion MODULO
create procedure SWIFTIES.Migracion_Modulo
as
begin
    set nocount on;
    Insert into SWIFTIES.Modulo (modu_nombre, modu_descripcion)
    select distinct Modulo_Nombre, Modulo_Descripcion
    from gd_esquema.Maestra
    where Modulo_Nombre is not null
end
go


-- Migracion MODULO_X_CURSO
create procedure SWIFTIES.Migracion_Modulo_x_Curso
as
begin
    set nocount on;
    Insert into SWIFTIES.Modulo_x_Curso (mxcu_modulo, mxcu_curso)
    select distinct modu_id, Curso_Codigo
    from gd_esquema.Maestra
    join SWIFTIES.Modulo on modu_nombre = Modulo_Nombre
    where Modulo_Nombre is not null and Curso_Codigo is not null
end
go


-- Migracion EVALUACION_PARCIAL
create procedure SWIFTIES.Migracion_Evaluacion_Parcial
as
begin
    set nocount on;
    Insert into SWIFTIES.Evaluacion_Parcial (eval_fecha_evaluacion, eval_presente, eval_nota, eval_alumno, eval_modulo, eval_curso, eval_instancia)
    select distinct Evaluacion_Curso_fechaEvaluacion,
    	Evaluacion_Curso_Presente,
    	Evaluacion_Curso_Nota,
    	Alumno_Legajo,
    	modu_id,
        Curso_Codigo,
    	Evaluacion_Curso_Instancia
    from gd_esquema.Maestra
    join SWIFTIES.Modulo on modu_nombre + modu_descripcion = Modulo_Nombre + Modulo_Descripcion
end
go
-- Migracion COMPLETA
create procedure SWIFTIES.Migracion
as
begin
    set nocount on;
    EXEC SWIFTIES.Migracion_Provincia
    EXEC SWIFTIES.Migracion_Localidad
    EXEC SWIFTIES.Migracion_Profesor
    EXEC SWIFTIES.Migracion_Alumno
    EXEC SWIFTIES.Migracion_Institucion
    EXEC SWIFTIES.Migracion_Sede
    EXEC SWIFTIES.Migracion_Curso
    EXEC SWIFTIES.Migracion_Encuesta
    EXEC SWIFTIES.Migracion_Pregunta_Encuesta
    EXEC SWIFTIES.Migracion_Respuesta_Encuesta
    EXEC SWIFTIES.Migracion_Dia
    EXEC SWIFTIES.Migracion_Dia_x_Curso
    EXEC SWIFTIES.Migracion_Factura
    EXEC SWIFTIES.Migracion_Detalle_Factura
    EXEC SWIFTIES.Migracion_Pago
    EXEC SWIFTIES.Migracion_Final
    EXEC SWIFTIES.Migracion_Evaluacion_Final
    EXEC SWIFTIES.Migracion_Inscripcion_Final
    EXEC SWIFTIES.Migracion_Inscripcion_Curso
    EXEC SWIFTIES.Migracion_Trabajo_Practico
    EXEC SWIFTIES.Migracion_Modulo
    EXEC SWIFTIES.Migracion_Modulo_x_Curso
    EXEC SWIFTIES.Migracion_Evaluacion_Parcial
end
go

---------------
-- EJECUCION --
---------------
exec SWIFTIES.Migracion

