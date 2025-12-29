--- ELIMINAR TABLAS DE HECHOS ---
DROP TABLE IF EXISTS SWIFTIES.BI_hecho_facturacion;
DROP TABLE IF EXISTS SWIFTIES.BI_hecho_pago;
DROP TABLE IF EXISTS SWIFTIES.BI_hecho_final;
DROP TABLE IF EXISTS SWIFTIES.BI_final_rendido;
DROP TABLE IF EXISTS SWIFTIES.BI_hecho_cursada;
DROP TABLE IF EXISTS SWIFTIES.BI_hecho_inscripcion_curso;
DROP TABLE IF EXISTS SWIFTIES.BI_hecho_encuesta;

--- ELIMINAR TABLAS DE DIMENSIONES ---
DROP TABLE IF EXISTS SWIFTIES.BI_dim_medio_pago;
DROP TABLE IF EXISTS SWIFTIES.BI_dim_rango_etario_profesor;
DROP TABLE IF EXISTS SWIFTIES.BI_dim_rango_etario_alumno;
DROP TABLE IF EXISTS SWIFTIES.BI_dim_tiempo;
DROP TABLE IF EXISTS SWIFTIES.BI_dim_sede;
DROP TABLE IF EXISTS SWIFTIES.BI_dim_turno;
DROP TABLE IF EXISTS SWIFTIES.BI_dim_categoria;
DROP TABLE IF EXISTS SWIFTIES.BI_dim_bloques_satisfaccion

--- ELIMINAR PROCEDIMIENTOS DE MIGRACION ---
DROP PROCEDURE IF EXISTS SWIFTIES.BI_Migracion_Categoria
DROP PROCEDURE IF EXISTS SWIFTIES.BI_Migracion_Turno
DROP PROCEDURE IF EXISTS SWIFTIES.BI_Migracion_Tiempo
DROP PROCEDURE IF EXISTS SWIFTIES.BI_Migracion_Sede
DROP PROCEDURE IF EXISTS SWIFTIES.BI_Migracion_Rango_Alumno
DROP PROCEDURE IF EXISTS SWIFTIES.BI_Migracion_Rango_Profesor
DROP PROCEDURE IF EXISTS SWIFTIES.BI_Migracion_Bloques_Satisfaccion
DROP PROCEDURE IF EXISTS SWIFTIES.BI_Migracion_Medio_Pago
DROP PROCEDURE IF EXISTS SWIFTIES.BI_Migracion_Hecho_Inscripcion_curso
DROP PROCEDURE IF EXISTS SWIFTIES.BI_Migracion_hecho_cursada
DROP PROCEDURE IF EXISTS SWIFTIES.BI_Migracion_Hecho_Final_Rendido
DROP PROCEDURE IF EXISTS SWIFTIES.BI_Migracion_Hecho_Final
DROP PROCEDURE IF EXISTS SWIFTIES.BI_Migracion_hecho_pago
DROP PROCEDURE IF EXISTS SWIFTIES.BI_Migracion_hecho_facturacion
DROP PROCEDURE IF EXISTS SWIFTIES.BI_Migracion_hecho_encuesta
DROP PROCEDURE IF EXISTS SWIFTIES.BI_Migracion_Completa

--- ELIMINAR VISTAS ---
DROP VIEW IF EXISTS SWIFTIES.BI_cate_turn_mas_solicitados
DROP VIEW IF EXISTS SWIFTIES.BI_tasa_rechazo_inscripciones
DROP VIEW IF EXISTS SWIFTIES.BI_tiempo_finalizacion_curso
DROP VIEW IF EXISTS SWIFTIES.BI_desempenio_cursada_por_sede
DROP VIEW IF EXISTS SWIFTIES.BI_nota_promedio_finales
DROP VIEW IF EXISTS SWIFTIES.BI_tasa_ausentismo_finales
DROP VIEW IF EXISTS SWIFTIES.BI_desvio_de_pagos
DROP VIEW IF EXISTS SWIFTIES.BI_tasa_morosidad
DROP VIEW IF EXISTS SWIFTIES.BI_ingreso_por_categoria
DROP VIEW IF EXISTS SWIFTIES.BI_indice_santisfaccion

---------------------------------------
-- CREACION DE TABLAS DE DIMENSIONES --
---------------------------------------
-- Creacion de tabla dim_categoria
CREATE TABLE SWIFTIES.BI_dim_categoria (
    cate_id int not null identity(1,1) PRIMARY KEY,
    cate_detalle varchar(255)
)

-- Creacion de tabla dim_turno
CREATE TABLE SWIFTIES.BI_dim_turno (
    turn_id int not null identity(1,1) PRIMARY KEY,
    turn_detalle varchar(255)
)

-- Creacion de tabla dim_sede
CREATE TABLE SWIFTIES.BI_dim_sede (
    bsede_id int not null identity(1,1) PRIMARY KEY,
    bsede_nombre nvarchar(255),
    bsede_direccion nvarchar(255),
    bsede_telefono nvarchar(255),
    bsede_localidad nvarchar(255),
    bsede_provincia nvarchar(255),
    bsede_mail nvarchar(255),
    bsede_institucion nvarchar(255)
)

-- Creacion de tabla dim_tiempo
CREATE TABLE SWIFTIES.BI_dim_tiempo (
    tiem_id int not null identity(1,1) PRIMARY KEY,
    tiem_anio int,
    tiem_semestre int,
    tiem_mes Int
)

-- Creacion de tabla dim_rango_etario_alumno
CREATE TABLE SWIFTIES.BI_dim_rango_etario_alumno (
    ralu_id int not null identity(1,1) PRIMARY KEY,
    ralu_minimo int,
    ralu_maximo int
)

-- Creacion de tabla dim_rango_etario_profesor
CREATE TABLE SWIFTIES.BI_dim_rango_etario_profesor (
    rapr_id int not null identity(1,1) PRIMARY KEY,
    rapr_minimo int,
    rapr_maximo int
)

-- Creacion de tabla dim_medio_pago
CREATE TABLE SWIFTIES.BI_dim_medio_pago (
    medi_id int not null identity(1,1) PRIMARY KEY,
    medi_detalle nvarchar(255) not null
)

-- Creacion de tabla dim_bloques_satisfaccion
CREATE TABLE SWIFTIES.BI_dim_bloques_satisfaccion (
    sati_id int not null identity(1,1) PRIMARY KEY,
    sati_detalle nvarchar(255),
    sati_minimo int not null,
    sati_maximo int not null,
)

----------------------------------
-- CREACION DE TABLAS DE HECHOS --
----------------------------------

-- Creacion de tabla hecho_inscripcion_curso
CREATE TABLE SWIFTIES.BI_hecho_inscripcion_curso (
    binc_id int not null identity(1,1) PRIMARY KEY,
    binc_tiempo int not null Foreign Key references SWIFTIES.BI_dim_tiempo(tiem_id),
    binc_categoria int not null Foreign Key references SWIFTIES.BI_dim_categoria(cate_id),
    binc_sede int not null Foreign Key references SWIFTIES.BI_dim_sede(Bsede_id),
    binc_turno int not null Foreign Key references SWIFTIES.BI_dim_turno(turn_id),
    binc_rechazados int,
    binc_cantidad_total int
)

-- Creacion de tabla hecho_cursada
CREATE TABLE SWIFTIES.BI_hecho_cursada (
    bcur_id int not null identity(1,1) PRIMARY KEY,
    bcur_tiempo int not null Foreign Key references SWIFTIES.BI_dim_tiempo(tiem_id),
    bcur_sede int not null Foreign Key references SWIFTIES.BI_dim_sede(Bsede_id),
    bcur_categoria int not null Foreign Key references SWIFTIES.BI_dim_categoria(cate_id),
    bcur_aprobada bit, 
    bcur_duracion int
)

-- Creacion de tabla final_rendido
CREATE TABLE SWIFTIES.BI_final_rendido (
    bfire_id int not null identity(1,1) PRIMARY KEY,
    bfire_rango_etario_alumno int not null Foreign Key references SWIFTIES.BI_dim_rango_etario_alumno(ralu_id),
    bfire_categoria int not null Foreign Key references SWIFTIES.BI_dim_categoria(cate_id),
    bfire_tiempo int,
    bfire_suma_notas decimal(5,2),
    bfire_cantidad int
)

-- Creacion de tabla hecho_final
CREATE TABLE SWIFTIES.BI_hecho_final (
    bfin_id int not null identity(1,1) PRIMARY KEY,
    bfin_tiempo int not null Foreign Key references SWIFTIES.BI_dim_tiempo(tiem_id),
    bfin_sede int not null Foreign Key references SWIFTIES.BI_dim_sede(Bsede_id),
    bfin_inscriptos int,
    bfin_ausentes int -- Porcentaje de ausentismo que hubo en ese final
)

-- Creacion de tabla hecho_pago
CREATE TABLE SWIFTIES.BI_hecho_pago (
    bpago_id int not null identity(1,1) PRIMARY KEY,
    bpago_tiempo int not null Foreign Key references SWIFTIES.BI_dim_tiempo(tiem_id),
    bpago_sede int not null Foreign Key references SWIFTIES.BI_dim_sede(Bsede_id),
    bpago_categoria int not null Foreign Key references SWIFTIES.BI_dim_categoria(cate_id),
    bpago_turno int not null Foreign Key references SWIFTIES.BI_dim_turno(turn_id),
    bpago_cant_fuera_termino int,
    bpago_importe_total decimal(18,2),
    bpago_medio_de_pago varchar(255),
    bpago_cantidad int
)

-- Creacion de tabla hecho_facturacion
CREATE TABLE SWIFTIES.BI_hecho_facturacion (
    bfact_id int not null identity(1,1) PRIMARY KEY,
    bfact_tiempo int not null Foreign Key references SWIFTIES.BI_dim_tiempo(tiem_id),
    bfact_sede int not null Foreign Key references SWIFTIES.BI_dim_sede(Bsede_id),
    bfact_turno int not null Foreign Key references SWIFTIES.BI_dim_turno(turn_id),
    bfact_categoria int not null Foreign Key references SWIFTIES.BI_dim_categoria(cate_id),
    bfact_importe_total decimal(18,2),
    bfact_monto_adeudado_total decimal(18,2)
)
go

-- Creacion de tabla hecho_encuesta
CREATE TABLE SWIFTIES.BI_hecho_encuesta (
    benc_id int not null identity(1,1) PRIMARY KEY,
    benc_sede int not null Foreign Key references SWIFTIES.BI_dim_sede(Bsede_id),
    benc_rango_etario_profesor int not null Foreign Key references SWIFTIES.BI_dim_rango_etario_profesor(rapr_id),
    benc_tiempo int not null Foreign Key references SWIFTIES.BI_dim_tiempo(tiem_id),
    benc_satisfaccion int not null Foreign Key references SWIFTIES.BI_dim_bloques_satisfaccion(sati_id),
    benc_total_respuestas int
)
go

-------------------------------------------
-- CREACION DE PROCEDURES DE DIMENSIONES --
-------------------------------------------
-- Migracion Dimension Categoria
create procedure SWIFTIES.BI_Migracion_Categoria
as
begin
    set nocount on;
    insert into SWIFTIES.BI_dim_categoria (cate_detalle)
         (select curs_categoria
            from SWIFTIES.Curso
            group by curs_categoria)
end
go

-- Migracion Dimension Turno
create procedure SWIFTIES.BI_Migracion_Turno
as
begin
    set nocount on;
    insert into SWIFTIES.BI_dim_turno (turn_detalle)
         (select curs_turno
            from SWIFTIES.Curso
            group by curs_turno)
end
go

-- Migracion Dimension Tiempo
create procedure SWIFTIES.BI_Migracion_Tiempo
as
begin
    set nocount on;

    
    insert into SWIFTIES.BI_dim_tiempo (tiem_mes, tiem_semestre, tiem_anio)
         (select -- Tiempo Cursos
            MONTH(curs_fecha_inicio),
            case
                when MONTH(curs_fecha_inicio) < 7
                then 1
                else 2
                end,
            year(curs_fecha_inicio)
            from SWIFTIES.Curso
            group by MONTH(curs_fecha_inicio), year(curs_fecha_inicio))
        union
        (select  -- Tiempo Facturas (emision)
            MONTH(fact_fecha_emision),
            case
                when MONTH(fact_fecha_emision) < 7
                then 1
                else 2
            end,
            year(fact_fecha_emision)
            from SWIFTIES.Factura
            group by MONTH(fact_fecha_emision), year(fact_fecha_emision) )
        union
        (select  -- Tiempo Pagos
            MONTH(pago_fecha),
            case
                when MONTH(pago_fecha) < 7
                then 1
                else 2
            end,
            year(pago_fecha)
            from SWIFTIES.Pago
            group by MONTH(pago_fecha), year(pago_fecha) )
        union
        (select  -- Tiempo Inscripciones (inscripcion)
            MONTH(insc_fecha_inscripcion),
            case
                when MONTH(insc_fecha_inscripcion) < 7
                then 1
                else 2
            end,
            year(insc_fecha_inscripcion)
            from SWIFTIES.Inscripcion_Curso
            group by MONTH(insc_fecha_inscripcion), year(insc_fecha_inscripcion) )
        union
        (select  -- Tiempo Inscripciones (aceptacion)
            MONTH(insc_fecha_respuesta),
            case
                when MONTH(insc_fecha_respuesta) < 7
                then 1
                else 2
            end,
            year(insc_fecha_respuesta)
            from SWIFTIES.Inscripcion_Curso
            group by MONTH(insc_fecha_respuesta), year(insc_fecha_respuesta) )
        union 

        (select -- Tiempo finales 
            month(fina_fecha),
            case 
                when month(fina_fecha) < 7
                then 1
                else 2
            end,
            year(fina_fecha)
         from SWIFTIES.Final
         group by month(fina_fecha), year(fina_fecha))

end
go

-- Migracion Dimension Sede
create procedure SWIFTIES.BI_Migracion_Sede
as
begin
    set nocount on;
    insert into SWIFTIES.BI_dim_sede (bsede_nombre, bsede_direccion, bsede_telefono, bsede_localidad, bsede_provincia, 
                                    bsede_mail,bsede_institucion)
         (select sede_nombre, 
                sede_direccion, 
                sede_telefono, 
                loca_nombre,
                prov_nombre,
                sede_mail,
                inst_nombre
            from SWIFTIES.Sede
            join SWIFTIES.Institucion on inst_id = sede_institucion
            join SWIFTIES.Localidad on sede_localidad = loca_codigo
            join SWIFTIES.Provincia on loca_provincia = prov_codigo)
end
go

-- Migracion Dimension Rango Etario Alumno
create procedure SWIFTIES.BI_Migracion_Rango_Alumno
as
begin
    set nocount on;
    insert into SWIFTIES.BI_dim_rango_etario_alumno (ralu_minimo, ralu_maximo)
    values (0, 24)

    insert into SWIFTIES.BI_dim_rango_etario_alumno (ralu_minimo, ralu_maximo)
    values (25, 34)

    insert into SWIFTIES.BI_dim_rango_etario_alumno (ralu_minimo, ralu_maximo)
    values (35, 49)

    insert into SWIFTIES.BI_dim_rango_etario_alumno (ralu_minimo, ralu_maximo)
    values (50, 100)
end
go

-- Migracion Dimension Rango Etario Alumno
create procedure SWIFTIES.BI_Migracion_Rango_Profesor
as
begin
    set nocount on;

    insert into SWIFTIES.BI_dim_rango_etario_profesor (rapr_minimo, rapr_maximo)
    values (25, 34)

    insert into SWIFTIES.BI_dim_rango_etario_profesor (rapr_minimo, rapr_maximo)
    values (35, 49)

    insert into SWIFTIES.BI_dim_rango_etario_profesor (rapr_minimo, rapr_maximo)
    values (50, 100)
end
go

-- Migracion Dimension Medio Pago
create procedure SWIFTIES.BI_Migracion_Medio_Pago
as
begin
    set nocount on;
    insert into SWIFTIES.BI_dim_medio_pago (medi_detalle)
         (select pago_medio_de_pago
            from SWIFTIES.Pago
            group by pago_medio_de_pago)
end
go

-- Migracion Dimension Bloque Satisfaccion
create procedure SWIFTIES.BI_Migracion_Bloques_Satisfaccion
as
begin
    set nocount on;
    insert into SWIFTIES.BI_dim_bloques_satisfaccion(sati_detalle, sati_minimo, sati_maximo)
    values('Satisfechos', 7, 10)
    insert into SWIFTIES.BI_dim_bloques_satisfaccion(sati_detalle, sati_minimo, sati_maximo)
    values('Neutrales', 5, 6)
    insert into SWIFTIES.BI_dim_bloques_satisfaccion(sati_detalle, sati_minimo, sati_maximo)
    values('Insatisfechos', 1, 4)
end
go

--------------------------------------
-- CREACION DE PROCEDURES DE HECHOS --
--------------------------------------
-- Migracion Hecho inscripcion curso 
create or alter procedure SWIFTIES.BI_Migracion_Hecho_Inscripcion_curso
as
begin 
    set nocount on; 
    insert into SWIFTIES.BI_hecho_inscripcion_curso(
        binc_tiempo,
        binc_categoria,
        binc_sede,
        binc_turno,
        binc_rechazados,
        binc_cantidad_total)
    select 
        tiem_id,
        cate_id,
        bsede_id,
        turn_id,
        sum(case 
                when insc_estado = 'Rechazada' then 1
                when insc_estado = 'Confirmada' then 0
                else 0
            end),
        count(*)
    from swifties.Inscripcion_Curso 
    join SWIFTIES.Curso on insc_curso = curs_codigo
    join swifties.BI_dim_turno on curs_turno = turn_detalle
    join SWIFTIES.BI_dim_categoria on curs_categoria = cate_detalle
    join SWIFTIES.BI_dim_tiempo on tiem_anio = year(insc_fecha_inscripcion) and tiem_mes = month(insc_fecha_inscripcion)
    join SWIFTIES.Sede on curs_sede = sede_id
    join SWIFTIES.BI_dim_sede on sede_nombre = bsede_nombre  
    group by tiem_id, bsede_id, cate_id, turn_id
end 
go

-- Migracion Hecho Cursada
create or alter procedure SWIFTIES.BI_Migracion_hecho_cursada
as
begin
    set nocount on; 
    insert into swifties.BI_hecho_cursada(
        bcur_tiempo,
        bcur_sede,
        bcur_categoria,
        bcur_aprobada,
        bcur_duracion)
    select 
        tiem_id,
        bsede_id,
        cate_id,
        case 
            when min(isnull(eval_nota,0)) < 4 or max(isnull(trab_nota,0)) < 4
            then 0
            else 1
        end,
        case 
            when evaf_nota is not null
            then DATEDIFF(DAY, curs_fecha_inicio, fina_fecha) 
            else null
        end     
    from curso 
    join swifties.Inscripcion_Curso on curs_codigo = insc_curso and insc_estado = 'Confirmada'
    join swifties.Alumno on insc_alumno = alum_legajo
    join swifties.BI_dim_tiempo on tiem_anio = year(curs_fecha_inicio) and month(curs_fecha_inicio) = tiem_mes
    join swifties.Sede on sede_id = curs_sede
    join swifties.BI_dim_sede on sede_nombre = bsede_nombre -- ver si agregar localidad o algo mas por si hay sedes distintas con mismo nombre
    join swifties.BI_dim_categoria on cate_detalle = curs_categoria

    left join swifties.Evaluacion_Final on evaf_alumno = alum_legajo
                                    and evaf_final+evaf_alumno in (select evaf_final+evaf_alumno 
                                                                    from SWIFTIES.Final
                                                                    join swifties.Evaluacion_Final on evaf_final = fina_id 
                                                                    where fina_curso = curs_codigo and evaf_nota >= 4) -- solo el final que aprobo
    left join swifties.final on evaf_final = fina_id
    left join swifties.Evaluacion_Parcial e1 on e1.eval_curso = curs_codigo 
                                    and e1.eval_alumno = alum_legajo 
                                    and e1.eval_nota = (select max(e2.eval_nota) from Evaluacion_Parcial e2
                                                        where e2.eval_curso = curs_codigo 
                                                                and e2.eval_alumno = alum_legajo
                                                                and e2.eval_modulo = e1.eval_modulo) -- me aseguro que me quedo con el parcial con mayor nota para ese modulo

    left join SWIFTIES.Trabajo_Practico on trab_legajo_alum = alum_legajo and trab_curso = curs_codigo
    group by insc_codigo, tiem_id, bsede_id, cate_id, curs_fecha_inicio, evaf_nota, fina_fecha
end
go

-- Migracion final rendido
go
create or alter procedure SWIFTIES.BI_Migracion_Hecho_Final_Rendido
as
begin
    set nocount on; 
    insert into swifties.BI_final_rendido(
        bfire_rango_etario_alumno,
        bfire_categoria,
        bfire_suma_notas,
        bfire_tiempo,
        bfire_cantidad)
    select  
        ralu_id,
        cate_id,
        sum(CAST(evaf_nota AS DECIMAL (5,2))),
        tiem_id,
        count(*)
    from SWIFTIES.curso 
    join BI_dim_categoria on cate_detalle = curs_categoria
    join SWIFTIES.final on curs_codigo = fina_curso
    join SWIFTIES.Evaluacion_Final on evaf_final = fina_id and evaf_asistencia = 1   
    join SWIFTIES.Alumno on alum_legajo = evaf_alumno
    join BI_dim_tiempo on tiem_anio = year(fina_fecha) and tiem_mes = month(fina_fecha)
    join BI_dim_rango_etario_alumno on ralu_minimo <= datediff(year, alum_fecha_nacimiento, fina_fecha) and ralu_maximo >=  datediff(year, alum_fecha_nacimiento, fina_fecha)
    group by ralu_id, cate_id, tiem_id
end
go

-- Migracion hecho final
create or alter procedure SWIFTIES.BI_Migracion_Hecho_Final
as
begin 
    set nocount on;
    insert into SWIFTIES.BI_hecho_final(
        bfin_tiempo,
        bfin_sede,
        bfin_inscriptos,
        bfin_ausentes)
    select
        tiem_id,
        bsede_id,
        count(*),
        sum(case 
                when evaf_asistencia = 1 then 0
                else 1
            end)
    from curso
    join sede on curs_sede = sede_id
    join BI_dim_sede on sede_nombre = bsede_nombre  -- podemos matchear con sede_id TODO
    join Final on fina_curso = curs_codigo   
    join BI_dim_tiempo on tiem_anio = YEAR(fina_fecha) AND tiem_mes = MONTH(fina_fecha)
    join Evaluacion_Final on evaf_final = fina_id 
    group by tiem_id, bsede_id, fina_id -- Cada fila va a ser porcentaje ausente por final por sede por semestre
end
go 

-- Migracion hecho pago 
create or alter procedure SWIFTIES.BI_Migracion_hecho_pago
as
begin
    set nocount on;
    insert into SWIFTIES.BI_hecho_pago(
        bpago_tiempo,
        bpago_sede,
        bpago_turno,
        bpago_categoria,
        bpago_cant_fuera_termino,
        bpago_importe_total,
        bpago_medio_de_pago,
        bpago_cantidad)
    select
        tiem_id,
        bsede_id,
        turn_id,
        cate_id,
        sum(case 
                when pago_fecha > fact_fecha_vencimiento
                then 1
                else 0
            end),
        sum(pago_importe),
        medi_id,
        count(*)
    from swifties.Factura 
    join swifties.Pago on pago_factura = fact_codigo
    join BI_dim_tiempo on tiem_anio = YEAR(pago_fecha) AND tiem_mes = MONTH(pago_fecha)
    join BI_dim_medio_pago on pago_medio_de_pago = medi_detalle
    join Detalle_Factura on deta_factura = fact_codigo
    join curso on deta_curso = curs_codigo
    join sede on curs_sede = sede_id
    join BI_dim_sede on bsede_nombre = sede_nombre 
    join BI_dim_turno on curs_turno = turn_detalle
    join BI_dim_categoria on curs_categoria = cate_detalle
    group by tiem_id, bsede_id, turn_id, cate_id, medi_id
end
go

-- Migracion Hecho Facturacion
create or alter procedure SWIFTIES.BI_Migracion_hecho_facturacion
as
begin
    set nocount on;
    insert into SWIFTIES.BI_hecho_facturacion(
        bfact_tiempo,
        bfact_sede,
        bfact_turno,
        bfact_categoria,
        bfact_importe_total,
        bfact_monto_adeudado_total)
    select
        tiem_id,
        bsede_id,
        turn_id,
        cate_id,
        sum(fact_importe),
        sum(case 
                when pago_importe is not null
                then 0
                else fact_importe
            end)
    from swifties.Factura 
    join SWIFTIES.Detalle_Factura on deta_factura = fact_codigo
    join SWIFTIES.Curso on deta_curso = curs_codigo
    join SWIFTIES.Sede on curs_sede = sede_id
    join BI_dim_sede on sede_id = bsede_id
    join BI_dim_categoria on curs_categoria = cate_detalle
    join BI_dim_turno on turn_detalle = curs_turno
    join BI_dim_tiempo on tiem_anio = year(fact_fecha_emision) and tiem_mes = month(fact_fecha_emision)
    left join SWIFTIES.Pago on fact_codigo = pago_factura
    group by tiem_id, bsede_id, turn_id, cate_id
end
go

-- Migracion Hecho Encuesta
create or alter procedure SWIFTIES.BI_Migracion_hecho_encuesta
as
begin
    set nocount on;
    insert into SWIFTIES.BI_hecho_encuesta(
        benc_sede,
        benc_rango_etario_profesor,
        benc_tiempo,
        benc_satisfaccion,
        benc_total_respuestas
        )
    select
        bsede_id,
        rapr_id,
        tiem_id,
        sati_id,
        count(*)
    from SWIFTIES.Encuesta
    join SWIFTIES.Curso on encu_curso = curs_codigo
    join SWIFTIES.Pregunta_Encuesta on preg_encuesta = encu_id
    join SWIFTIES.Respuesta_Encuesta on resp_pregunta = preg_id
    join SWIFTIES.Sede on curs_sede = sede_id
    join SWIFTIES.BI_dim_sede on sede_nombre = bsede_nombre
    join SWIFTIES.Profesor on curs_profesor = prof_id
    join SWIFTIES.BI_dim_rango_etario_profesor on rapr_minimo <= datediff(year, prof_fecha_nacimiento, encu_fecha_registro) 
                                                and rapr_maximo >= datediff(year, prof_fecha_nacimiento, encu_fecha_registro)
    join SWIFTIES.BI_dim_tiempo on tiem_anio = year(encu_fecha_registro) and tiem_mes = month(encu_fecha_registro)
    join SWIFTIES.BI_dim_bloques_satisfaccion on resp_nota between sati_minimo and sati_maximo
    group by rapr_id, bsede_id, tiem_id, sati_id
end
go

-- Migracion Completa del Modelo BI
create procedure SWIFTIES.BI_Migracion_Completa
as
begin
    set nocount on;
    EXEC SWIFTIES.BI_Migracion_Categoria
    EXEC SWIFTIES.BI_Migracion_Turno
    EXEC SWIFTIES.BI_Migracion_Tiempo
    EXEC SWIFTIES.BI_Migracion_Sede
    EXEC SWIFTIES.BI_Migracion_Rango_Alumno
    EXEC SWIFTIES.BI_Migracion_Rango_Profesor
    EXEC SWIFTIES.BI_Migracion_Medio_Pago
    EXEC SWIFTIES.BI_Migracion_Bloques_Satisfaccion
    EXEC SWIFTIES.BI_Migracion_Hecho_Inscripcion_curso
    EXEC SWIFTIES.BI_Migracion_hecho_cursada
    EXEC SWIFTIES.BI_Migracion_Hecho_Final_Rendido
    EXEC SWIFTIES.BI_Migracion_Hecho_Final
    EXEC SWIFTIES.BI_Migracion_hecho_pago
    EXEC SWIFTIES.BI_Migracion_hecho_facturacion
    EXEC SWIFTIES.BI_Migracion_hecho_encuesta
end
go

exec SWIFTIES.BI_Migracion_Completa 
go

/*
--------------------------------------
-- CREACION DE VISTAS DEL ENUNCIADO --
--------------------------------------
*/
-- 1. Categoria y turno mas solicitados 
CREATE VIEW SWIFTIES.BI_cate_turn_mas_solicitados as
select 
    t.tiem_anio as anio, 
    s.bsede_nombre as sede, 
    cate_detalle as categoria, 
    turn_detalle as turno,
    sum(i.binc_cantidad_total) as cantidadInscriptos
from SWIFTIES.BI_hecho_inscripcion_curso i
join SWIFTIES.BI_dim_sede s on i.binc_sede = s.bsede_id
join SWIFTIES.BI_dim_tiempo t on i.binc_tiempo = t.tiem_id
join SWIFTIES.BI_dim_turno on turn_id = binc_turno
join SWIFTIES.BI_dim_categoria on cate_id = binc_categoria
where cast(i.binc_categoria as varchar(2))+cast(i.binc_turno as varchar(2)) in 
                        (select top 3 cast(binc_categoria as varchar(2))+cast(binc_turno as varchar(2))
                            from SWIFTIES.BI_hecho_inscripcion_curso 
                            join SWIFTIES.BI_dim_sede on binc_sede = bsede_id
                            join SWIFTIES.BI_dim_tiempo on binc_tiempo = tiem_id
                            where t.tiem_anio = tiem_anio and bsede_nombre = s.bsede_nombre
                            group by binc_categoria, binc_turno
                            order by sum(binc_cantidad_total) desc)
group by t.tiem_anio, s.bsede_nombre, cate_detalle, turn_detalle, s.bsede_id, cate_id, turn_id
go

-- 2. Tasa de rechazo de inscripciones 
CREATE VIEW SWIFTIES.BI_tasa_rechazo_inscripciones as 
select 
    cast(sum(binc_rechazados) as decimal(5, 2)) / sum(binc_cantidad_total) * 100 as porcentajeRechazo,
    bsede_nombre as sede,
    tiem_mes as mes
from SWIFTIES.BI_hecho_inscripcion_curso
join SWIFTIES.BI_dim_sede on binc_sede = bsede_id
join SWIFTIES.BI_dim_tiempo on binc_tiempo = tiem_id
group by bsede_id, bsede_nombre, tiem_mes
go


-- 3. Comparacion de desempeno de cursada por sede
CREATE VIEW SWIFTIES.BI_desempenio_cursada_por_sede as
select 
    t.tiem_anio as anio, 
    s.bsede_nombre as sede, 
    (sum(cast (bcur_aprobada as decimal (5,2)))) / count(*)  * 100 as porcentajeAprobados 
from SWIFTIES.BI_hecho_cursada 
join SWIFTIES.BI_dim_tiempo t on bcur_tiempo = t.tiem_id
join SWIFTIES.BI_dim_sede s on bcur_sede = s.bsede_id
group by t.tiem_anio, s.bsede_nombre
go

-- 4. Tiempo promedio de finalizacion de curso
CREATE VIEW SWIFTIES.BI_tiempo_finalizacion_curso as
select 
    cate_detalle as categoria, 
    tiem_anio as anio,
    avg(bcur_duracion) as duracionPromedioDias
from SWIFTIES.BI_hecho_cursada
join SWIFTIES.BI_dim_tiempo on bcur_tiempo = tiem_id
join SWIFTIES.BI_dim_categoria on bcur_categoria = cate_id
group by cate_detalle, tiem_anio
go

-- 5. Nota promedio de finales segun rango etario
CREATE VIEW SWIFTIES.BI_nota_promedio_finales as
select 
    '(' + CAST(ralu_minimo AS VARCHAR(50)) + ',' + CAST(ralu_maximo AS VARCHAR(50)) + ')' as rangoEtario, 
    cate_detalle as categoria, 
    tiem_semestre as semestre,
    sum(bfire_suma_notas) / sum(CAST(bfire_cantidad AS DECIMAL (5,2))) as notaPromedio
from SWIFTIES.BI_final_rendido 
join SWIFTIES.BI_dim_categoria on bfire_categoria = cate_id
join SWIFTIES.BI_dim_rango_etario_alumno on bfire_rango_etario_alumno = ralu_id
join SWIFTIES.BI_dim_tiempo on bfire_tiempo = tiem_id
group by ralu_minimo, ralu_maximo, cate_detalle, tiem_semestre
go

-- 6. Tasa de ausentismo a finales
CREATE VIEW SWIFTIES.BI_tasa_ausentismo_finales as
select 
    tiem_semestre as semestre, 
    bsede_nombre as sede, 
    (cast(sum(bfin_ausentes) as decimal (5,2)) / sum(bfin_inscriptos)) * 100 as '% Ausentes'
from SWIFTIES.BI_hecho_final 
join SWIFTIES.BI_dim_tiempo on bfin_tiempo = tiem_id
join SWIFTIES.BI_dim_sede  on bfin_sede = bsede_id
group by tiem_semestre, bsede_nombre
go

-- 7. Desvio de pagos
CREATE VIEW SWIFTIES.BI_desvio_de_pagos as
select 
    tiem_semestre as semestre, 
    sum(CAST(bpago_cant_fuera_termino AS DECIMAL (5,2))) / sum(bpago_cantidad) * 100 as '% Pagos Fuera De Termino'
from SWIFTIES.BI_hecho_pago
join SWIFTIES.BI_dim_tiempo on tiem_id = bpago_tiempo
group by tiem_semestre
go


-- 8. Tasa de morosidad financiera mensual
CREATE VIEW SWIFTIES.BI_tasa_morosidad as
select 
    tiem_mes as mes, 
    sum(bfact_monto_adeudado_total) / sum(bfact_importe_total) * 100 as 'Tasa de Morosidad'
from SWIFTIES.BI_hecho_facturacion
join SWIFTIES.BI_dim_tiempo on tiem_id = bfact_tiempo
group by tiem_mes
go


-- 9. Ingreso por categoria de cursos
CREATE VIEW SWIFTIES.BI_ingreso_por_categoria as
select 
    cate_detalle as categoria, 
    tiem_anio as anio, 
    bsede_nombre as sede,
    sum(bpago_importe_total) as importeTotal
from SWIFTIES.BI_hecho_pago
join SWIFTIES.BI_dim_sede s on s.bsede_id = bpago_sede
join SWIFTIES.BI_dim_tiempo t on t.tiem_id = bpago_tiempo
join SWIFTIES.BI_dim_categoria on bpago_categoria = cate_id
where bpago_categoria in
    (select top 3 bpago_categoria
    from SWIFTIES.BI_hecho_pago
    join SWIFTIES.BI_dim_sede on bsede_id = bpago_sede
    join SWIFTIES.BI_dim_tiempo on tiem_id = bpago_tiempo
    where tiem_anio = t.tiem_anio and bsede_nombre = s.bsede_nombre
    group by bpago_categoria
    order by sum(bpago_importe_total) desc)
group by tiem_anio, bsede_nombre, cate_detalle
go

-- 10. Indice de satisfaccion
CREATE VIEW SWIFTIES.BI_indice_santisfaccion as
select 
    '(' + CAST(rapr_minimo AS VARCHAR(50)) + ',' + CAST(rapr_maximo AS VARCHAR(50)) + ')' as rangoEtario, 
    bsede_nombre as sede, 
    tiem_anio as anio, 
    ((sum(case 
            when sati_detalle = 'Satisfechos'
            then benc_total_respuestas
            else 0
          end) / sum(CAST(benc_total_respuestas as Decimal(5,2))) * 100.0) -- porcentaje satisfechos
    - 
    (sum(case 
            when sati_detalle = 'Insatisfechos'
            then benc_total_respuestas
            else 0
          end) / sum(CAST(benc_total_respuestas as Decimal(5,2))) * 100.0) -- porcentaje insatisfechos
     + 100.0) / 2.000000 as satisfaccion
from SWIFTIES.BI_hecho_encuesta
join SWIFTIES.BI_dim_tiempo on benc_tiempo = tiem_id
join SWIFTIES.BI_dim_rango_etario_profesor on benc_rango_etario_profesor = rapr_id
join SWIFTIES.BI_dim_sede on benc_sede = bsede_id
join SWIFTIES.BI_dim_bloques_satisfaccion on sati_id = benc_satisfaccion
group by rapr_minimo, rapr_maximo, bsede_nombre, tiem_anio
go

