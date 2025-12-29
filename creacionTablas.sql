/*select * from Provincia
select * from gd_esquema.Maestra

alter table Dia_x_Curso 
ADD CONSTRAINT dxcu_id PRIMARY KEY (dxcu_curso, dxcu_dia)*/


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
DROP SCHEMA IF EXISTS SWIFTIES
go

create schema SWIFTIES
go

Create table SWIFTIES.Provincia(
    prov_codigo int not null identity(1,1) PRIMARY KEY,
    prov_nombre nvarchar(255),
);

Create table SWIFTIES.Localidad(
    loca_codigo int not null identity(1,1) PRIMARY KEY,
    loca_nombre nvarchar(255),
    loca_provincia int not null Foreign Key references SWIFTIES.Provincia(prov_codigo)
);

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

Create table SWIFTIES.Institucion (
    inst_id int not null identity(1,1) PRIMARY KEY,
    inst_nombre nvarchar(255),
    inst_razon_social nvarchar(255),
    inst_cuit nvarchar(255)
);

Create table SWIFTIES.Sede (
    sede_id int not null identity(1,1) PRIMARY KEY,
    sede_nombre nvarchar(255),
    sede_direccion nvarchar(255),
    sede_telefono nvarchar(255),
    sede_localidad int not null Foreign Key references SWIFTIES.Localidad(loca_codigo),
    sede_mail nvarchar(255),
    sede_institucion int not null Foreign Key references SWIFTIES.Institucion(inst_id)
);

Create table SWIFTIES.Curso (
    curs_codigo bigInt not null PRIMARY KEY,
    curs_sede int not null Foreign Key references SWIFTIES.Sede(sede_id),
    curs_profesor int not null Foreign Key references SWIFTIES.Profesor(prof_id),
    curs_nombre varchar(255),
    curs_descripcion varchar(255),
    curs_categoria varchar(255),
    curs_duracion BigInt,
    curs_turno varchar(255),
    curs_fecha_inicio DateTime2(6),
    curs_precio_mensual decimal(38,2)
);

Create table SWIFTIES.Encuesta (
    encu_id int not null identity(1,1) PRIMARY KEY,
    encu_fecha_registro DateTime2(6),
    encu_curso bigint Foreign Key references SWIFTIES.Curso(curs_codigo),
    encu_observaciones varchar(255)
);

Create table SWIFTIES.Pregunta_Encuesta (
    preg_id int not null identity(1,1) PRIMARY KEY,
    preg_encuesta int not null Foreign Key references SWIFTIES.Encuesta(encu_id),
    preg_pregunta varchar(255)
);

Create table SWIFTIES.Respuesta_Encuesta (
    resp_id int not null identity(1,1) PRIMARY KEY,
    resp_pregunta int not null Foreign Key references SWIFTIES.Pregunta_Encuesta(preg_id),
    resp_nota bigint
);

Create table SWIFTIES.Dia (
    dia_id int not null identity(1,1) PRIMARY KEY,
    dia_detalle varchar(255)
);

Create table SWIFTIES.Dia_x_Curso (
    dxcu_curso bigint not null Foreign Key references SWIFTIES.Curso(curs_codigo),
    dxcu_dia int not null Foreign Key references SWIFTIES.Dia(dia_id),
    Constraint dxcu_id PRIMARY KEY (dxcu_curso, dxcu_dia),
);

Create table SWIFTIES.Factura (
    fact_codigo bigint not null PRIMARY KEY,
    fact_fecha_emision DateTime2(6),
    fact_fecha_vencimiento DateTime2(6),
    fact_alumno bigint not null Foreign Key references SWIFTIES.Alumno(alum_legajo),
    fact_importe decimal(18,2)
);

Create table SWIFTIES.Detalle_Factura (
    deta_curso bigint not null Foreign Key references SWIFTIES.Curso(curs_codigo),
    deta_factura bigint not null Foreign Key references SWIFTIES.Factura(fact_codigo),
    Constraint deta_id PRIMARY KEY (deta_curso, deta_factura),
    deta_importe decimal(18,2),
    deta_periodo_anio bigint,
    deta_periodo_mes bigint
);

Create table SWIFTIES.Pago (
    pago_id int not null identity(1,1) PRIMARY KEY,
    pago_factura bigint not null Foreign Key references SWIFTIES.Factura(fact_codigo),
    pago_fecha DateTime2(6),
    pago_importe decimal(18,2),
    pago_medio_de_pago varchar(255)
);

Create table SWIFTIES.Final (
    fina_id int not null identity(1,1) PRIMARY KEY,
    fina_descripcion varchar(255),
    fina_fecha DateTime2(6),
    fina_hora varchar(255),
    fina_curso bigint not null Foreign Key references SWIFTIES.Curso(curs_codigo)
);

Create table SWIFTIES.Inscripcion_Final (
    insf_id bigint not null PRIMARY KEY,
    insf_fecha_inscripcion DateTime2(6),
    insf_alumno bigint not null Foreign Key references SWIFTIES.Alumno(alum_legajo),
    insf_final int not null Foreign Key references SWIFTIES.Final(fina_id)
);

Create table SWIFTIES.Trabajo_Practico (
    trab_legajo_alum bigint not null Foreign Key references SWIFTIES.Alumno(alum_legajo),
    trab_curso bigint not null Foreign Key references SWIFTIES.Curso(curs_codigo),
    Constraint trab_id PRIMARY KEY (trab_legajo_alum, trab_curso),
    trab_nota bigint,
    trab_fecha DateTime2(6)
);

Create table SWIFTIES.Evaluacion_Final (
    evaf_alumno bigint not null Foreign Key references SWIFTIES.Alumno(alum_legajo),
    evaf_final int not null Foreign Key references SWIFTIES.Final(fina_id),
    evaf_nota bigint,
    Constraint evaf_id PRIMARY KEY (evaf_alumno, evaf_final),
    evaf_asistencia bit,
    evaf_profesor int not null Foreign Key references SWIFTIES.Profesor(prof_id),
);

Create table SWIFTIES.Inscripcion_Curso (
    insc_codigo bigint not null PRIMARY KEY,
    insc_fecha_inscripcion DateTime2(6),
    insc_curso bigint not null Foreign Key references SWIFTIES.Curso(curs_codigo),
    insc_alumno bigint not null Foreign Key references SWIFTIES.Alumno(alum_legajo),
    insc_estado varchar(255),
    insc_fecha_respuesta DateTime2(6)
);

Create table SWIFTIES.Modulo (
    modu_id int not null identity(1,1) PRIMARY KEY,
    modu_descripcion varchar(255),
    modu_nombre varchar(255)
);

Create table SWIFTIES.Modulo_x_Curso (
    mxcu_modulo int not null Foreign Key references SWIFTIES.Modulo(modu_id),
    mxcu_curso bigint not null Foreign Key references SWIFTIES.Curso(curs_codigo),
    Constraint modu_id PRIMARY KEY (mxcu_curso, mxcu_modulo),
);

Create table SWIFTIES.Evaluacion_Parcial (
    eval_id int not null identity(1,1) PRIMARY KEY,
    eval_fecha_evaluacion DateTime2(6),
    eval_presente bit,
    eval_nota bigint,
    eval_alumno bigint not null Foreign Key references SWIFTIES.Alumno(alum_legajo),
    eval_modulo int not null Foreign Key references SWIFTIES.Modulo(modu_id),
    eval_instancia bigint
);