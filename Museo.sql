create database museo;
use museo;

create table Guias ( 
	id_guia int auto_increment,
	nombre varchar(50) not NULL,
	apellido varchar(50) not null,
	dni varchar(15)not null,
	constraint pk_guias primary key (id_guia),
	constraint unq_guias unique (dni)
    );

create table Tipo_visitas(
	id_tipo_visita int auto_increment primary key, 
	descripcion varchar(50) not null unique
    );
                        
create table Localidades(
	id_localidad int auto_increment,
    nombre_localidad varchar(50),
    constraint pk_localidad primary key (id_localidad)
    );
						
create table Escuelas(
	id_escuela int auto_increment,
    id_localidad int,
	nombre_escuela varchar(50) not null unique,
	domicilio varchar(50) not null,
    constraint pk_escuela primary key (id_escuela),
    constraint fk_localidad foreign key (id_localidad) references Localidades(id_localidad) on delete cascade);

create table Telefonos(
	telefono varchar(50) not null,
	id_escuela int ,
	constraint pk_telefonos primary key (telefono, id_escuela),
	constraint fk_telefonos_escuela foreign key (id_escuela) references escuelas(id_escuela) on delete cascade  );
                       
create table Reservas(
	id_reserva int auto_increment primary key,
	id_escuela int,
	fecha_reserva date,
	constraint fk_escuelas_reserva foreign key (id_escuela) references Escuelas(id_escuela) on delete no action );
					 
create table Visitas (
	id_tipo_visita int,
	id_reserva int,
	cant_alumnos smallint,
	cant_alumnos_reales smallint,
	fecha_visita date,
	colaboracion float,
	grado varchar(5),
	constraint pk_visitas primary key (id_tipo_visita, id_reserva),
	constraint fk_visitas_tipo_visita foreign key (id_tipo_visita) references Tipo_visitas(id_tipo_visita),
	constraint fk_visitas_reserva foreign key  (id_reserva) references Reservas(id_reserva),
	constraint chk_cant_alumnos check (cant_alumnos_reales <= cant_alumnos));
                        
create table Visitas_x_Guias(
	id_tipo_visita int,
	id_reserva int,
	id_guia int,
	responsable boolean,
	constraint pk_visitas primary key (id_tipo_visita, id_reserva,id_guia),
	constraint fk_visitas_guias foreign key (id_guia) references Guias(id_guia),
	constraint fk_visitas_x_guias_tipo_visita foreign key (id_tipo_visita) references Tipo_visitas(id_tipo_visita),
	constraint fk_visitas_x_guias_reserva foreign key  (id_reserva) references Reservas(id_reserva));
                                

insert into Tipo_visitas(descripcion) values ('Animales Salvajes'),('Robots asesinos');
insert into Guias(nombre, apellido, dni) values ('Vero','Tomich', '41145661'),('Jose','Velez', '123455123'),('Abel','Acuña','32165487'),('Cristian', 'Perez', '38441551');

insert into Localidades(nombre_localidad) values ('Mar del Plata'),('Balcarce'),('Pinamar'),('Madariaga');
insert into Escuelas (id_localidad,nombre_escuela, domicilio) values (1,'Escuela 1', 'Calle 1'),(3,'Escuela 2', 'Calle 2'),(1,'Escuela 3', 'Calle 3'),(2,'Escuela 4', 'Calle 4');

insert into Escuelas (id_localidad,nombre_escuela, domicilio) value (1,'AlmagroD', 'Calle 55');


insert into Telefonos (id_escuela, telefono) values (1,'telefono1'),(1,'telefono2'),(2,'telefono3'),(3,'telefono4');					  
				
insert into Reservas (id_escuela, fecha_reserva) values (1,'2021-01-01'),(1,'2021-12-01'),(2,'2019-05-01'),(3,'2016-05-01');

insert into Reservas (id_escuela, fecha_reserva) values (5,'2022-01-03');

insert into Visitas (id_tipo_visita, id_reserva, cant_alumnos, cant_alumnos_reales, fecha_visita, colaboracion, grado)
values (1,2,15,15,'2022-01-03',55.50,'6to'),(2,3,30,25,'2021-01-01',55.50,'4to'),(2,1,22,20,'2021-12-01',55.50,'5to');

insert into Visitas_x_Guias(id_tipo_visita, id_reserva, id_guia, responsable)
values (1,2,1,true),(2,3,2,false),(2,1,1,false);


# ------------------------ GUIA N° 4 : Consulta y combinación de tablas. -----------------------------------

/* 1. Listar nombre y telefonos de cada las escuelas*/
select 
		escuelas.nombre_escuela, 
		telefonos.telefono 
from Escuelas 
inner join telefonos on escuelas.id_escuela = telefonos.id_escuela;

/* 2. Listar Nombre y cantidad de Reservas realizadas para cada Escuela durante el presente año.*/
select 
	e.nombre_escuela, count(r.id_escuela) as cantidad
from  Escuelas e
inner join Reservas r on e.id_escuela = r.id_escuela
where year(r.fecha_reserva) = year(now())
group by e.nombre_escuela;

/* 3. Listar Nombre y cantidad de Reservas realizadas para cada Escuela durante el presente año, 
en caso  de no haber realizado Reservas, mostrar numero cero. */
select 
		e.nombre_escuela, 
		count(r.id_escuela) as cantidad
from Escuelas e
left join Reservas r on e.id_escuela = r.id_escuela
where	year(r.fecha_reserva) = year(now()) 
group by e.nombre_escuela;

/* 4. Listar el nombre de los Guias que participaron en las Visitas, pero no como Responsables.*/
select 	g.nombre, 
		g.apellido 
from Guias g
inner join Visitas_x_Guias vxg on vxg.id_guia = g.id_guia
where  vxg.responsable = false;
    
/* 5. Listar el nombre de los Guias que no participaron en ninguna Visita. */

insert into Guias(nombre, apellido, dni) values ('Cristian', 'Perez', '384415512');

select 	g.nombre, 
		g.apellido 
from Guias g
left join Visitas_x_Guias vxg on g.id_guia = vxg.id_guia
where vxg.id_guia is NULL;
    
/* 6. Listar para cada Visita, el nombre de Escuela, el nombre del Guía responsable, la cantidad de
alumnos que concurrieron y la fecha en que se llevó a cabo.*/
SELECT 
		e.nombre_escuela as 'Nombre Escuela',
        g.nombre as 'Guia Responsable',
        v.cant_alumnos_reales as 'Cant de Alumnos',
        v.fecha_visita as 'Fecha'

FROM Visitas v

INNER JOIN  Reservas r  ON  v.id_reserva = r.id_reserva 
INNER JOIN  Escuelas e ON  r.id_escuela = e.id_escuela
INNER JOIN Tipo_visitas tv ON v.id_tipo_visita = tv.id_tipo_visita
INNER JOIN  Visitas_x_Guias vxg ON  v.id_reserva = vxg.id_reserva
INNER JOIN  Guias g ON vxg.id_guia = g.id_guia

WHERE vxg.responsable = true;

/* 7. Listar el nombre de cada Escuela y su localidad. También deben aparecer las Localidades que no
tienen Escuelas, indicando ‘Sin Escuelas’. Algunas Escuelas no tienen cargada la Localidad, debe
indicar ‘Sin Localidad’. */
SELECT 
		ifnull(e.nombre_escuela,'Sin Escuela') as 'Escuela',
        ifnull(l.nombre_localidad, 'Sin Localidad') as 'Localidad'
FROM Escuelas e
LEFT OUTER JOIN Localidades l ON e.id_localidad = l.id_localidad 

UNION 

SELECT 
		ifnull(e.nombre_escuela,'Sin Escuela') as 'Escuela',
        ifnull(l.nombre_localidad, 'Sin Localidad') as 'Localidad'
FROM Escuelas e
RIGHT OUTER JOIN Localidades l ON e.id_localidad = l.id_localidad ;



/* 8. Listar el nombre de los Directores  y el de los Guías, juntos, ordenados alfabéticamente. */




/* 9. Listar el nombre de los Directores de las escuelas de Mar del Plata,  y el de todos los Guías, juntos,
ordenados alfabéticamente. */



/* 10. Listar para las Escuelas que tienen Reservas, el nombre y la Localidad, teniendo en cuenta que
algunas Escuelas no tienen Localidad. */
SELECT 
		e.nombre_escuela as 'Escuela',
		ifnull(l.nombre_localidad, 'Sin Localidad') as 'Localidad'
FROM Escuelas e
INNER JOIN Reservas r ON e.id_escuela = r.id_escuela
LEFT JOIN Localidades l ON e.id_localidad = l.id_localidad ;


# ------------------------ GUIA N° 6 :Funciones de agregado -----------------------------------

select *FROM escuelas;
/* 1. Listar la cantidad de Reservas realizadas para cada Escuela, ordenar el resultado por identificador
de Escuela El formato de fecha debe ser dd.mm.yyyy. */
SELECT	e.nombre_escuela as 'Escuela', e.id_escuela, date_format(fecha_reserva, "%d.%m.%Y") as 'Fecha Reserva'
FROM Escuelas e 
INNER JOIN Reservas r 
ON e.id_escuela = r.id_escuela;
 
/* 2. Listar la cantidad de Reservas realizadas para cada Escuela, en cada mes. */
SELECT 
	e.nombre_escuela as 'Escuela', count(r.id_escuela) as 'Cant de Reservas', month (r.fecha_reserva) as 'Mes'
FROM Escuelas e
INNER JOIN Reservas r 
ON e.id_escuela = r.id_escuela
GROUP BY  month(r.fecha_reserva) , e.nombre_escuela
ORDER BY month(r.fecha_reserva) asc ;

select * from Reservas ;

/* 3. Listar las escuelas que empiecen con A y terminan con D. */
SELECT 	e.nombre_escuela as 'Escuela'
FROM  Escuelas e
WHERE e.nombre_escuela LIKE 'A%D';

/* 4. Suponiendo que los Guías sean cargados en la base de datos con el siguiente formato “Nombre
Apellido”, realizar una consulta que separe en columnas Nombre y Apellido. */
SELECT 
		g.nombre_apellido as 'Nombre',
        g.nombre_apellido as 'Apellido'
FROM Guias g
WHERE 'Nombre' BETWEEN '' and ' '   AND 'Apellido' BETWEEN ' ' and '';

# no funciona x q no cargo en la base de datos nnombre y apellido juntos. Principio de normalizacion

/* 5. Listar las escuelas que tengan más de 5 reservas en el último mes. */

SELECT 
		e.nombre_escuela as 'Escuelas',
        count(r.id_escuela) as 'Cant Reservas'
FROM  Escuelas e

INNER JOIN Reservas r ON e.id_escuela = r.id_escuela

WHERE month(r.fecha_reserva) = month(now());



/* 6. Listas las escuelas que hayan hecho guias para más de 500 alumnos en la historia. */



/* 7. Listar las escuelas y la cantidad de palabras que contiene su nombre (tomando como separador el
espacio ‘ ‘). */









# ------------------------ GUIA N° 7 : Funciones de Agregado. -----------------------------------


/* 1. Listar la cantidad de Reservas realizadas para cada Escuela, ordenar el resultado por identificador
de Escuela.*/



/* 2. Listar la cantidad de Reservas realizadas para cada Escuela, en cada mes. */



/* 3. Listar para cada Reserva, la cantidad total de Alumnos para los que se reservó y la cantidad total de
Alumnos que concurrieron en realidad. */



/* 4. Listar para cada Escuela, la primera y la última fecha de Reserva, ordenar el resultado por
identificador de Escuela en forma descendente.  */



/* 5. Listar para cada Guía, la cantidad de reservas en las que participó */



/* 6. Listar para cada Guía, la cantidad de reservas de día completo en las que participó */



/* 7. Listar para cada Guía, la cantidad de reservas de día completo en las que participó, cuando haya
superado las 5 (cinco) participaciones.   */



/* 8. Listar el Guía que haya participado en mayor cantidad de reservas */



/* 9. Listar las Escuelas que hayan hecho reservasen el mes de agosto de 2012. Tener en cuenta que
las Escuelas pueden realizar más de una reserva mensual. */ 



use Museo;

# ------------------------ GUIA N° 8 : Sub - Consultas. -----------------------------------

/* 1. Listar Código y Nombre de cada Escuela, y obtener la cantidad de Reservas realizadas con una subconsulta.*/
SELECT  e.id_escuela 'Codigo Escuela',
		e.nombre_escuela 'Nombre Escuela',
		(
			SELECT count(*)
        
			FROM Reservas r 
            
            WHERE r.id_escuela = e.id_escuela  
                
		) as 'Cantidad Reservas' 

FROM Escuelas e
group by e.id_escuela, e.nombre_escuela;

select * from reservas;
/* 2. Listar Código y Nombre de cada Escuela, y obtener la cantidad de Reservas realizadas durante el
 presente año, con una subconsuta. En caso de no haber realizado Reservas, mostrar el número
 cero. */

SELECT  e.id_escuela 'Codigo Escuela',
		e.nombre_escuela 'Nombre Escuela',
		(
			SELECT count(r.id_reserva)
        
			FROM Reservas r 
            
			WHERE (r.id_escuela = e.id_escuela) AND (year(r.fecha_reserva) = year(now()))  
                
		) as 'Cantidad Reservas' 

FROM Escuelas e
group by e.id_escuela, e.nombre_escuela;

/* 3. Para cada Tipo de Visita, listar el nombre y obtener con una subconsulta como tabla derivada la
cantidad de Reservas realizadas.*/

SELECT 	tp.descripcion 'Tipo Visita',
		count(CantidadReservas.reserva) as 'Cantidad Reservas' 
FROM (	
		SELECT 	r.id_reserva as reserva

		FROM Reservas r 
        
        INNER JOIN Visitas v ON r.id_reserva = v.id_reserva

        ) as CantidadReservas
        
INNER JOIN Visitas v ON reserva = v.id_reserva

INNER JOIN Tipo_visitas tp ON tp.id_tipo_visita = v.id_tipo_visita

GROUP BY (tp.descripcion);

select * from visitas_x_guias;
select * from reservas;
select * from tipo_visitas;
select * from visitas;
SELECT TipoVisita, Cantidad
FROM TipoVisitas TV
INNER JOIN (SELECT IdTipoVisita, count(*) as Cantidad
	FROM Visitas GROUP BY IdTipoVisita) Cant ON TV.IdTipoVisita = Cant.IdTipoVisita;

/* 4. Para cada Guía, listar el nombre y obtener con una subconsulta como tabla derivada la cantidad de
Visitas en las que participó como Responsable. En caso de no haber participado en ninguna,
mostrar el número cero. */


SELECT g.nombre, ifnull(Cantidad, 0) as Cantidad
FROM Guias G 
LEFT JOIN (SELECT Id_Guia, count(*) as 'Cantidad'
	FROM Visitas_x_Guias VG WHERE Responsable = 1 GROUP BY Id_Guia) Cantidades ON G.Id_Guia = Cantidades.Id_Guia;



/* 5. Para cada Escuela, mostrar el nombre y la cantidad de Reservas realizadas el último año que
visitaron el Museo. Resolver con subconsulta correlacionada.*/

SELECT Escuela, count(*) as 'Cantidad' 
FROM Escuelas E 
INNER JOIN Reservas R ON E.IdEscuela = R.IdEscuela WHERE YEAR(Fecha) = (SELECT MAX(YEAR(Fecha)) 
	FROM Reservas WHERE IdEscuela = E.IdEscuela)
GROUP BY Escuela;



/* 6. Listar el nombre de las Escuelas que realizaron Reservas. Resolver con Exists.*/

SELECT Escuela 
FROM Escuelas E WHERE EXISTS ( SELECT IdEscuela 
	FROM Reservas R WHERE R.IdEscuela = E.IdEscuela);


/* 7. Listar el nombre de las Escuelas que realizaron Reservas. Resolver con IN.*/

SELECT Escuela 
FROM Escuelas E
WHERE IdEscuela IN ( SELECT IdEscuela 
	FROM Reservas R WHERE R.IdEscuela = E.IdEscuela);



/**
<< TP 8 - Subconsultas >>
**/

# 1 - Listar Codigo y Nombre de cada Escuela, y obtener la cantidad de Reservas realizadas con una subconsulta.

SELECT E.IdEscuela, Escuela, (SELECT count(*) 
	FROM Reservas R WHERE R.idEscuela = E.IdEscuela) as 'Cantidad de Reservas'
FROM Escuelas E;


/* 2 -  Listar Codigo y Nombre de cada Escuela, y obtener la cantidad de Reservas realizadas durante el
presente año, con una subconsuta. En caso de no haber realizado Reservas, mostrar el numero cero.*/

SELECT E.IdEscuela, Escuela, (SELECT IFNULL(count(*),0)
FROM Reservas R WHERE E.idEscuela = R.IdEscuela AND YEAR (Fecha) = YEAR (now())) as 'Cantidad de Reservas'
FROM Escuelas E;

/* Para cada Tipo de Visita, listar el nombre y obtener con una subconsulta como tabla derivada la
cantidad de Reservas realizadas.*/

SELECT TipoVisita, Cantidad
FROM TipoVisitas TV
INNER JOIN (SELECT IdTipoVisita, count(*) as Cantidad
	FROM Visitas GROUP BY IdTipoVisita) Cant ON TV.IdTipoVisita = Cant.IdTipoVisita;

/* Para cada Gu�a, listar el nombre y obtener con una subconsulta como tabla derivada la cantidad de
Visitas en las que particip� como Responsable. En caso de no haber participado en ninguna,
mostrar el n�mero cero.*/

SELECT Guia, isnull (Cantidad, 0) as Cantidad
FROM Guias G 
LEFT JOIN (SELECT IdGuia, count(*) as 'Cantidad'
	FROM VisitasGuias VG WHERE Responsable = 1 GROUP BY IdGuia) Cantidades ON G.IdGuia = Cantidades.IdGuia;

 /*Para cada Escuela, mostrar el nombre y la cantidad de Reservas realizadas el �ltimo a�o que
visitaron el Museo. Resolver con subconsulta correlacionada.*/

SELECT Escuela, count(*) as 'Cantidad' 
FROM Escuelas E 
INNER JOIN Reservas R ON E.IdEscuela = R.IdEscuela WHERE YEAR(Fecha) = (SELECT MAX(YEAR(Fecha)) 
	FROM Reservas WHERE IdEscuela = E.IdEscuela)
GROUP BY Escuela;

/*Listar el nombre de las Escuelas que realizaron Reservas. Resolver con Exists.*/

SELECT Escuela 
FROM Escuelas E WHERE EXISTS ( SELECT IdEscuela 
	FROM Reservas R WHERE R.IdEscuela = E.IdEscuela);

-- Listar el nombre de las Escuelas que realizaron Reservas. Resolver con IN.

SELECT Escuela 
FROM Escuelas E
WHERE IdEscuela IN ( SELECT IdEscuela 
	FROM Reservas R WHERE R.IdEscuela = E.IdEscuela);





