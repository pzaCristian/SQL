CREATE DATABASE torneo_basket;
USE torneo_basket;

drop database torneo_basket;

CREATE TABLE Equipos(
	
    id_equipo INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nombre_equipo VARCHAR(50),
    
    CONSTRAINT pk_id_equipo PRIMARY KEY (id_equipo)
);

CREATE TABLE Partidos(
	
    id_partido INT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_equipo_local INT UNSIGNED NOT NULL,
    id_equipo_visitante INT UNSIGNED NOT NULL,
    fecha datetime,
        
    CONSTRAINT pk_id_partido PRIMARY KEY (id_partido),
    CONSTRAINT fk_id_equipo_local FOREIGN KEY (id_equipo_local) REFERENCES Equipos(id_equipo),
    CONSTRAINT fk_id_equipo_visitante FOREIGN KEY (id_equipo_visitante) REFERENCES Equipos(id_equipo),
	CONSTRAINT chk_id_equipo CHECK (id_equipo_local <> id_equipo_visitante)
    
);

CREATE TABLE Jugadores(

	id_jugador INT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_equipo INT UNSIGNED NOT NULL,
    nombre_jugador VARCHAR(50),
    apellido_jugador VARCHAR(50),
    
    CONSTRAINT pk_id_jugador PRIMARY KEY (id_jugador),
    CONSTRAINT fk_id_equipo FOREIGN KEY (id_equipo) references Equipos(id_equipo)
);


CREATE TABLE Jugadores_x_equipo_x_partido(

	id_jugador INT UNSIGNED NOT NULL,
    id_partido INT UNSIGNED NOT NULL,
    puntos INT UNSIGNED NOT NULL,
    rebotes INT UNSIGNED NOT NULL,
    asistencias INT UNSIGNED NOT NULL,
    minutos INT UNSIGNED NOT NULL,
    faltas INT UNSIGNED NOT NULL,
    
    CONSTRAINT pk_id_jugador_x_partido PRIMARY KEY (id_jugador,id_partido),
    CONSTRAINT fk_id_partido FOREIGN KEY (id_partido) REFERENCES Partidos(id_partido),
    CONSTRAINT fk_id_jugador FOREIGN KEY (id_jugador) REFERENCES Jugadores(id_jugador)
);

#--------- Equipos ------------

INSERT INTO Equipos(nombre_equipo) VALUES ('River'), ('Boca'), ('Atletico Tucuman'), ('San Lorenzo'), ('Racing'), ('Patronato'), ('Atletica Patronato');

Select * from Equipos;

#--------- Jugadores ------------
INSERT INTO Jugadores (id_equipo, nombre_jugador, apellido_jugador) VALUES(1, 'Pablo', 'Fino'), (1, 'Matias', 'Tassara'),(1, 'Fausto', 'Moya'), (1, 'Lisandro', 'Canueto'),
(1, 'Mariela', 'Cagnoli'), (2, 'Veronica', 'Tomich'),(2, 'Ana', 'Nibio'), (2, 'Karina', 'Felice'), (2, 'Antonela', 'Bertarini'),(3, 'Demi','Lovato'), (3, 'Selena', 'Gomez'), 
(3, 'Taylor', 'Switz'),(3, 'Megan', 'Merkle'), (3, 'Principe', 'Harry'),(4, 'Principe', 'Francescoli'), (4, 'Juampy', 'Sorin'),(4, 'Marcelo', 'Gallardo'), (4, 'Javier', 'Saviola'), 
(4, 'Pablo', 'Aimar'),(4, 'Burrito', 'Ortega'),(6, 'Juan', 'Perez');

SELECT * FROM Jugadores;

# ------------ Partidos ---------------

INSERT INTO Partidos (id_equipo_local, id_equipo_visitante, fecha)VALUES (1, 2, '2018-11-01'), (3, 4, '2018-11-02'),(1, 3, '2018-11-03'), (2, 4, '2018-11-04'),(1, 4, '2018-11-05'), (2, 3, '2018-11-06');
select *from Partidos;


# ----------- Jugadores_x_equipo_x_partido ----------------

INSERT INTO Jugadores_x_equipo_x_partido(id_jugador, id_partido, puntos, rebotes, asistencias,minutos, faltas) VALUES(1,1,3,5,20,56,2), (2,1,6,7,12,90,4),(3,1,4,7,15,90,7),(4,3,8,4,3,45,1), (5,5,8,6,15,90,0),
(6,4,5,9,15,80,4), (7,6,6,7,8,25,2), (8,4,4,6,6,90,8), (9,6,7,8,9,41,6), (10,2,6,6,6,90,16),(11,2,7,9,5,53,8), (12,2,5,6,2,82,6), (13,2,5,6,5,15,6), (14,2,8,5,6,40,13);
INSERT INTO Jugadores_x_equipo_x_partido(id_jugador, id_partido, puntos, rebotes, asistencias,minutos, faltas) VALUES(1,3,8,9,9,90,9), (2,3,8,7,15,46,9),(3,3,6,7,15,90,7),(4,1,2,9,9,90,8), (5,3,6,8,56,85,12),
(6,6,8,8,5,15,1), (7,4,8,17,4,90,5), (8,6,5,9,5,45,6), (9,4,5,6,9,90,3);

Select *from Jugadores_x_equipo_x_partido;



#   clase = 30/10/2019    

# 3) Generar​ ​una​ ​consulta​ ​que​ ​nos​ ​devuelva​ ​el​ ​resultado​ ​de​ ​un​ ​partido.
# 	1_ Quien jugo cada partido
# 	2_ cuantos puntos hiso cada equipo, en cada partido


SELECT 	el.nombre_equipo,
		el.id_equipo,
        ev.nombre_equipo,
        ev.id_equipo,
        p.id_partido,
        
        (SELECT SUM(jxp.puntos)
			FROM jugadores_x_equipo_x_partido jxp
			INNER JOIN Jugadores j
			ON jxp.id_jugador = j.id_jugador
			WHERE  	j.id_equipo = el.id_equipo AND jxp.id_partido = p.id_equipo) as 'Puntos Local',
		
        (SELECT SUM(jxp.puntos)
			FROM Jugadores_x_equipo_x_partido jxp
			INNER JOIN Jugadores j
			ON jxp.id_jugador = j.id_jugador
			WHERE  	j.id_equipo = ev.id_equipo AND jxp.id_partido = p.id_partido) as 'Puntos Visitante'
            
FROM Partidos p

INNER JOIN Equipos el 
ON p.id_equipo_local = e.id_equipo

INNER JOIN Equipos ev    
ON p.id_equipo_visitante = e.id_equipo;




SELECT SUM(jxp.puntos)
FROM jugadores_x_equipo_x_partido jxp
INNER JOIN Jugadores j
ON jxp.id_jugador = j.id_jugador

WHERE  	j.id_equipo = 1 AND jxp.id_partido = 1;



# Clase 06/11/2019

SELECT MAX(promedio)
FROM (
		SELECT 
				id_jugador,
				avg(puntos) as promedio
		FROM  
				Jugadores_x_equipo_x_partido
				
		GROUP BY id_jugadores);
        
	
SELECT 	
		j.nombre_jugador,
		(SELECT MAX(promedio)
		FROM (
				SELECT 
						id_jugador,
						avg(puntos) as promedio
				FROM  
						jugadores_x_equipo_x_partido
				GROUP BY id_jugadores )) as promedio
FROM 
	jugadores_x_equipo_x_partido jxp
	INNER JOIN jugadores j 
	ON jxp.id_jugador = j.id_jugador
HAVING 
	AVG(puntos) = 1;




# ------------------------ GUIA Integradora : SubConsulta  -----------------------------------



/* 1. Generar​​ una​​ consulta ​​para ​​conocer ​​los ​​jugadores ​​y ​​cuantos​​ puntos​​,​ ​rebotes, asistencias ​​y ​​faltas ​​hicieron ​​de ​​promedio.
​​Listar ​​los ​​mejores ​​5​​ y ​​los ​​peores ​​5 ​​en ​​base a​​un ​​coeficiente​​ ( promedio*1​​ +​​ rebotes*0.5​​ + ​​asistencias*0.5 ​​+ ​​(faltas​​*​​-1) )​​.
Identificar​​ cada​​ grupo ​​diciendo​​ si​​ está​​ entre​​ los ​​mejores ​​5​​ o​​ los​​ peores​​ 5. */
/*
SELECT 
		j.apellido_jugador,
        j.nombre_jugador ,
		sum(jxp.puntos) 
FROM Jugadores j
INNER JOIN Jugadores_x_equipo_x_partido jxp ON j.id_jugador = jxp.id_jugador
GROUP BY j.nombre_jugador
ORDER BY sum(jxp.puntos) desc limit 5


UNION ALL

SELECT 
		j.apellido_jugador,
        j.nombre_jugador ,
		sum(jxp.puntos) 
FROM Jugadores j
INNER JOIN Jugadores_x_equipo_x_partido jxp ON j.id_jugador = jxp.id_jugador
GROUP BY (j.nombre_jugador)
ORDER BY sum(jxp.puntos) asc LIMIT 5;

*/



/* 2. Generar ​​la ​​consulta ​​del ​​punto​ ​1 ​​pero ​​tomando ​​en ​​cuenta ​​los ​​puntos. */




/* 3. Generar ​​una ​​consulta​​ que​​ nos​​ devuelva​​ el​​ resultado​​ de​​ un​​ partido. */



/* 4. Generar​​ una​​ consulta​​ que​​ nos​​ permita​​ visualizar​​ la​​ tabla​​ de​​ posiciones​​ del​​ torneo */ 



/* 5. Generar​​ una​​ consulta​​ que​​ nos​​ permita​​ conocer​​ los​​ jugadores​​ con​​ mejor​​ promedio​​ de puntos​​, es​​ decir :
​​Si​​ hay​​ dos​​ jugadores​​ que​​ hicieron​​ 30​​ puntos​​ por​​ partido​​ listarlos​​ a ambos. */



/* 6. Generar ​​una​​ consulta​​ que​​ nos​​ permita​​ conocer​​ los​​ jugadores​​ que​​ hicieron​​ más puntos​​ en​​ un​​ partido​​ y​​ en​​ qué​​ partido​​ lo​​ hicieron​​ 
(Poner ​​Equipo​​ Local​​ y ​​Equipo Visitante).  */




/* 7. Listar​​ los​​ equipos​​ y​​ en​​ el​​ mismo​​ registro​​ listar​​ cual​​ es​​ el​​ jugador​​ con​​ el​​ mayor promedio​​ de ​​puntos. */

SELECT 

		e.nombre_equipo as 'Equipo',
        concat(goleador.apellido," ", goleador.nombre) as 'Jugador' ,
        MAX(goleador.promedio_puntos) 

FROM (

		SELECT  
				j.id_jugador as id_jugador,
				j.apellido_jugador as apellido,
				j.nombre_jugador as nombre,
				SUM(puntos) as promedio_puntos

		FROM Jugadores j

		INNER JOIN Jugadores_x_equipo_x_partido jxp ON j.id_jugador = jxp.id_jugador

		GROUP BY (j.apellido_jugador)

		 ) as goleador
        
INNER JOIN Equipos e ON e.id_equipo = goleador.id_jugador;




# GOLEADOR
select  
	j.id_jugador, 
	j.nombre_jugador,
    j.apellido_jugador,
    avg(jxp.puntos) as promedio
from 
	Jugadores j 
    inner join  Jugadores_x_Equipo_x_partido jxp on j.id_jugador = jxp.id_jugador
group by j.id_jugador, j.nombre_jugador,j.apellido_jugador
having
	avg(jxp.puntos) = (
		select max(a.promedio) from
			(select  
				j.id_jugador, 
				j.nombre_jugador,
				j.apellido_jugador,
				avg(jxp.puntos) as promedio
			from 
				Jugadores j 
				inner join  Jugadores_x_Equipo_x_partido jxp on j.id_jugador = jxp.id_jugador
			group by j.id_jugador, j.nombre_jugador,j.apellido_jugador) a
    );


# GOLEADOR X EQUIPO

select
	goleador.id_equipo ,
	goleador.nombre_equipo,
	j.nombre_jugador,
	j.apellido_jugador
from
	Jugadores j
inner join (
	select
		e.id as id_equipo,
		e.nombre as nombre_equipo,
		(
		select
			a.id_jugador
		from
			(
			select
				j.id as id_jugador,
				sum(puntos)
			from
				Jugadores j
			inner join Jugadores_x_equipo_x_partido jxp on
				j.id = jxp.id_jugador
			where
				j.id_equipo = e.id
			group by
				id_jugador
			order by
				sum(puntos)
			limit 1) a) as id_jugador
	from
		equipos e) as goleador on
	j.id = goleador.id_jugador



/* 8. Listar​​ los​ ​equipos​​ en​​ el​​ mismo​​ registro​​ listar​​ cual​​ es​​ el​​ jugador​​ que​​ hizo​​ más​​ puntos en​​ un ​​partido, ​​cuantos​​ puntos​​ y​​ en​​ qué​​ partido​​ lo​​ hizo. */


