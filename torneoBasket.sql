CREATE DATABASE basket;
USE basket;

CREATE TABLE Equipos(
	
    id_equipo INT AUTO_INCREMENT,
    nombre_equipo VARCHAR(50),
    
    CONSTRAINT pk_id_equipo PRIMARY KEY (id_equipo)
);

CREATE TABLE Partidos(
	
    id_partido INT AUTO_INCREMENT,
    id_equipo_local INT,
    id_equipo_visitante INT,
    fecha DATETIME,
        
    CONSTRAINT pk_id_partido PRIMARY KEY (id_partido),
    CONSTRAINT fk_id_equipo_local FOREIGN KEY (id_equipo_local) REFERENCES EQuipos(id_equipo),
    CONSTRAINT fk_id_equipo_visitante FOREIGN KEY (id_equipo_visitante) REFERENCES Equipos(id_equipo)    
);

CREATE TABLE Jugadores(

	id_jugador INT AUTO_INCREMENT,
    id_equipo INT,
    nombre_jugador VARCHAR(50),
    apellido_jugador VARCHAR(50),
    
    CONSTRAINT pk_id_jugador PRIMARY KEY (id_jugador),
    CONSTRAINT fk_id_equipo FOREIGN KEY (id_equipo) references Equipos(id_equipo)
    
);


CREATE TABLE Jugadores_x_equipo_x_partido(

	id_jugador INT,
    id_partido INT,
    puntos INT,equipos
    rebotes INT,
    asistencias INT,
    minutos INT,
    faltas INT,
    
    CONSTRAINT pk_id_jugador_x_partido PRIMARY KEY (id_jugador,id_partido),
    CONSTRAINT fk_id_partido FOREIGN KEY (id_partido) REFERENCES Partidos(id_partido),
    CONSTRAINT fk_id_jugador FOREIGN KEY (id_jugador) REFERENCES Jugadores(id_jugador)
    
);


/* ------------------ Carga de Datos ----------------------- */

# ------------- Equipos --------------
INSERT INTO Equipos(nombre_equipo) VALUES ('River'), ('Boca'), ('Atletico Tucuman'), ('San Lorenzo'), ('Racing'), 
('Patronato'),  ('Atletica Patronato');

SELECT * FROM Equipos;

# ------------- Jugadores --------------
INSERT INTO Jugadores (id_equipo, nombre_jugador, apellido_jugador) VALUES
(1, 'Vero', 'Tomich'), (1, 'Matias', 'Tassara'),(1, 'Fausto', 'Moya'), (1, 'Lisandro', 'Canueto'),
(1, 'Mariela', 'Cagnoli'), (2, 'Juana', 'De arco'),
(2, 'Ana', 'Nibio'), (2, 'Karina', 'Felice'), (2, 'Antonela', 'Bertarini'),
(3, 'Demi','Lovato'), (3, 'Selena', 'Gomez'), (3, 'Taylor', 'Switz'),
(3, 'Megan', 'Merkle'), (3, 'Principe', 'Harry'),
(4, 'Principe', 'Francescoli'), (4, 'Juampy', 'Sorin'),
(4, 'Marcelo', 'Gallardo'), (4, 'Javier', 'Saviola'), (4, 'Pablo', 'Aimar'),
(4, 'Burrito', 'Ortega');

INSERT INTO Jugadores (id_equipo, nombre_jugador, apellido_jugador) VALUES 
(6, 'Juan', 'Perez');

INSERT INTO jugadores (id_equipo, nombre_jugador, apellido_jugador) VALUES
(1, 'Bart', 'Simp'), (1, 'Lisa', 'Simp'),
(1, 'Hom', 'Simp'), (1, 'Flanders', 'Apu'),
(1, 'Garguir', 'Sergio'), (1, 'Marito', 'utn'),
(1, 'Mati', 'Tesou'), (1, 'Seba', 'DeLaF'),(2, 'Veronica', 'Castro'),
(2, 'Enrique', 'Iglesias'), (2, 'Esteban', 'Quito'), (2, 'Machu', 'Pichu'),
(3, 'Demi','Lovato');
INSERT INTO Jugadores (id_equipo, nombre_jugador, apellido_jugador) VALUES
(2, 'Lorena', 'Paola'), (2, 'Pepe', 'Argento'),
(2, 'Pep', 'Guardiola'), (2, 'Pulga', 'Messi'),
(2, 'Florencio', 'Varela'), (2, 'Maria', 'Curi'),
(2, 'Martin', 'Rodriguez');

SELECT * FROM Jugadores;

# ---------- Partidos ----------------
INSERT INTO partidos (id_equipo_local, id_equipo_visitante, fecha)
VALUES (1, 2, '2018-11-01'), (3, 4, '2018-11-02'),
(1, 3, '2018-11-03'), (2, 4, '2018-11-04'),
(1, 4, '2018-11-05'), (2, 3, '2018-11-06'),
(3, 5, '2020-01-23'), (1, 4, '2021-11-10')
;


SELECT * FROM Partidos;

# ------------- Jugadores_x_Equipo_x_Partido --------------

INSERT INTO Jugadores_x_equipo_x_partido(id_jugador, id_partido, puntos, rebotes, asistencias, minutos, faltas) VALUES
(1,1,3,5,20,56,2), (2,1,6,7,12,90,4),(3,1,4,7,15,90,7),(4,3,8,4,3,45,1), (5,5,8,6,15,90,0),
(6,4,5,9,15,80,4), (7,6,6,7,8,25,2), (8,4,4,6,6,90,8), (9,6,7,8,9,41,6), (10,2,6,6,6,90,16),
(11,2,7,9,5,53,8), (12,2,5,6,2,82,6), (13,2,5,6,5,15,6), (14,2,8,5,6,40,13);

INSERT INTO jugadores_x_equipo_x_partido(id_jugador, id_partido, puntos, rebotes, asistencias, minutos, faltas) VALUES
(1,3,8,9,9,90,9), (2,3,8,7,15,46,9),(3,3,6,7,15,90,7),(4,1,2,9,9,90,8), (5,3,6,8,56,85,12),
(6,6,8,8,5,15,1), (7,4,8,17,4,90,5), (8,6,5,9,5,45,6), (9,4,5,6,9,90,3);

SELECT * FROM Jugadores_x_equipo_x_partido;


#---------------------- GUIA 4.1  ---------------------------

/*1) Listar los jugadores y a que equipo pertenecen (nombre, apellido , nombre_equipo). */
SELECT
 j.nombre_jugador, j.apellido_jugador, e.nombre_equipo
FROM jugadores j INNER JOIN equipos e ON j.id_equipo = e.id_equipo;

/*2) Listar los equipos cuyo nombre comience con la letra P.*/
SELECT nombre_equipo FROM equipos WHERE nombre_equipo LIKE 'P%';

/*3) Listar los jugadores que pertenezcan a un equipo que contenga una “Atletico” o
“Atlética” en su nombre (Por ej : Atletico Tucuman o Asociacion Atletica Patronato”.*/
SELECT j.nombre_jugador, j.apellido_jugador, e.nombre_equipo
FROM jugadores j INNER JOIN equipos e ON j.id_equipo = e.id_equipo
WHERE e.nombre_equipo LIKE '%Atletico%' or e.nombre_equipo LIKE '%Atletica%';

/*4) Listar los jugadores y su equipo siempre y cuando el jugador haya jugado al menos
un partido.*/
SELECT j.nombre_jugador,j.apellido_jugador,e.nombre_equipo
FROM jugadores j INNER JOIN equipos e ON e.id_equipo = j.id_equipo
WHERE
J.id_jugador in (select id_jugador from jugadores_x_equipo_x_partido);

/*5) Listar los partidos con su fecha y los nombres de los equipos local y visitante.*/
SELECT e.nombre_equipo as local, p.fecha, e2.nombre_equipo as visitante
From partidos as p
Inner join equipos as e
On p.id_equipo_local = e.id_equipo
Inner join equipos as e2
On p.id_equipo_visitante = e2.id_equipo;

/*6) Listar los equipos y la cantidad de jugadores que tiene .*/
SELECT count(*) as cantidad_jugadores, e.nombre_equipo
FROM jugadores j INNER JOIN equipos e ON j.id_equipo = e.id_equipo
GROUP BY e.nombre_equipo;

/*7) Listar los jugadores y la cantidad de partidos que jugó. */
SELECT j.nombre_jugador, j.apellido, count(*) as cant_partidos
FROM jugadores j INNER JOIN jugadores_x_equipo_x_partido jep ON j.id_jugador =
jep.id_jugador
GROUP BY j.nombre_jugador;

/*8) Elaborar un ranking con los jugadores que más puntos hicieron en el torneo .*/
SELECT j.nombre_jugador, j.apellido, SUM(jep.puntos) as cant_puntos
FROM jugadores j INNER JOIN jugadores_x_equipo_x_partido jep ON j.id_jugador =
jep.id_jugador
GROUP BY j.nombre_jugador
ORDER BY SUM(jep.puntos) DESC;

/*9) Elaborar un ranking con los jugadores que más promedio de puntos tienen en el
torneo. */
SELECT j.nombre_jugador, j.apellido, AVG(jep.puntos) as prom_puntos
FROM jugadores j INNER JOIN jugadores_x_equipo_x_partido jep ON j.id_jugador =
jep.id_jugador
GROUP BY j.nombre_jugador
ORDER BY AVG(jep.puntos) DESC;

/*10) Para cada jugador, mostrar la fecha del primer y último partido que jugo.*/
SELECT j.nombre_jugador, j.apellido, jep.id_partido, MIN(p.fecha) as primera_fecha,
MAX(p.fecha) as ultima_fecha
FROM jugadores_x_equipo_x_partido jep INNER JOIN jugadores j ON jep.id_jugador =
j.id_jugador
INNER JOIN partidos p ON jep.id_partido = p.id_partido
WHERE j.id_jugador = jep.id_jugador
GROUP BY j.nombre_jugador;

/*11)Listar los equipos que tengan registrados mas de 10 jugadores */
SELECT count(j.id_jugador) as cantidad_jugadores, e.nombre_equipo
FROM jugadores j INNER JOIN equipos e ON j.id_equipo = e.id_equipo
WHERE distancia = (select MAX (distancia) from rutas) and j.id_equipo = e.id_equipo
GROUP BY e.nombre_equipo
HAVING count(j.id_jugador) > 10;

/*12) Listar los jugadores que hayan jugado más de 5 partidos y promediado más de 10
puntos por partido. */
SELECT j.nombre_jugador, j.apellido, e.nombre_equipo, count(jep.id_jugador) as cantPartidos,
AVG(jep.puntos) as promedio_puntos
FROM jugadores_x_equipo_x_partido jep INNER JOIN jugadores j ON jep.id_jugador =
j.id_jugador
INNER JOIN equipos e ON j.id_equipo = e.id_equipo
GROUP BY j.id_jugador
HAVING count(jep.id_jugador) >1 AND AVG(jep.puntos) >5;

/*13) Listar los jugadores que en promedio tengan más de 10 puntos , 10 asistencias y 10
rebotes por partido. */
/*INGRESAR MAS INFO PARA HACER EL HAVING CON LA INFO QUE SE PIDE*/
SELECT j.nombre_jugador, j.apellido_jugador, AVG(jep.puntos) as prom_puntos, AVG(jep.asistencias)
as prom_asistencias,
AVG(jep.rebotes) as prom_rebotes
FROM jugadores j INNER JOIN jugadores_x_equipo_x_partido jep ON j.id_jugador =
jep.id_jugador 
GROUP BY j.nombre_jugador
HAVING AVG(jep.puntos)>6 AND AVG(jep.asistencias)>10 AND AVG(jep.rebotes) > 5;

/*14) Dado un equipo y un partido, devolver cuantos puntos hizo cada equipo en cada
uno de los partidos que jugó como local. */
SELECT SUM(jep.puntos) as cant_puntos, e.nombre_equipo FROM Partidos p INNER JOIN jugadores_x_equipo_x_partido jep ON p.id_partido =
jep.id_partido INNER JOIN equipos e
ON p.id_equipo_local = e.id_equipo
GROUP BY e.nombre_equipo;

Select e.nombre_equipo, sum(jxp.puntos)
From equipos e
inner join partidos p
on e.id_equipo = p.id_equipo_local
inner join jugadores_x_equipo_x_partido jxp
on p.id_partido = jxp.id_partido
group by e.nombre_equipo;

/*15) Listar los equipos que hayan jugado como local mas de 3 partidos. */
/*AGREGAR MAS PARTIDOS Y CAMBIAR EL HAVING*/

SELECT e.nombre_equipo, COUNT(p.id_equipo_local) as "Partidos Local"
FROM equipos e INNER JOIN partidos p ON e.id_equipo = p.id_equipo_local
GROUP BY e.nombre_equipo
HAVING COUNT(p.id_equipo_local) > 2;



#---------------------- GUIA Integradora  ---------------------------


/* 1. Generar una consulta para conocer los jugadores y cuantos puntos , rebotes,
asistencias y faltas hicieron de promedio. Listar los mejores 5 y los peores 5 en base
a un coeficiente (promedio*1 + rebotes*0.5 + asistencias*0.5 + (faltas * -1)) .
Identificar cada grupo diciendo si está entre los mejores 5 o los peores 5. */
 
(SELECT 'Mejores' as 'Tipo',
		j.nombre_jugador,
        j.apellido_jugador,
        SUM(jxp.puntos*1 + jxp.rebotes*0.5 + jxp.asistencias*0.5 - jxp.faltas) as 'Coeficiente'
 
FROM Jugadores j 
 
INNER JOIN Jugadores_x_equipo_x_partido jxp ON j.id_jugador = jxp.id_jugador 

GROUP BY j.nombre_jugador

ORDER BY SUM(jxp.puntos*1 + jxp.rebotes*0.5 + jxp.asistencias*0.5 - jxp.faltas) desc limit 5)

UNION 

(SELECT 'Peores' as 'Tipo',
		j.nombre_jugador,
        j.apellido_jugador,
        SUM(jxp.puntos*1 + jxp.rebotes*0.5 + jxp.asistencias*0.5 - jxp.faltas) as 'Coeficiente'
 
FROM Jugadores j 
 
INNER JOIN Jugadores_x_equipo_x_partido jxp ON j.id_jugador = jxp.id_jugador 

GROUP BY j.nombre_jugador

ORDER BY  SUM(jxp.puntos*1 + jxp.rebotes*0.5 + jxp.asistencias*0.5 - jxp.faltas) asc limit 5);


 
/* 2. Generar la consulta del punto 1 pero tomando en cuenta los puntos. */
 
(SELECT 'Mejores' as 'Tipo',
		j.nombre_jugador,
        j.apellido_jugador,
        sum(jxp.puntos) as 'Puntos'
 
FROM Jugadores j 
 
INNER JOIN Jugadores_x_equipo_x_partido jxp ON j.id_jugador = jxp.id_jugador 

GROUP BY j.nombre_jugador,j.apellido_jugador

ORDER BY sum(jxp.puntos) desc limit 5)

UNION 

(SELECT 'Peores' as 'Tipo',
		j.nombre_jugador,
        j.apellido_jugador,
        sum(jxp.puntos) as 'Puntos'
 
FROM Jugadores j 
 
INNER JOIN Jugadores_x_equipo_x_partido jxp ON j.id_jugador = jxp.id_jugador 

GROUP BY j.nombre_jugador

ORDER BY sum(jxp.puntos) asc limit 5);

 
/* 3. Generar una consulta que nos devuelva el resultado de un partido. */

select * from partidos;
select * from jugadores_x_equipo_x_partido;
select * from jugadores;

select e.nombre_equipo, ev.nombre_equipo, sum(jxp.puntos) as "Puntos Local", sum(jxpV.puntos) as "Puntos Visitante"
from   partidos p 

inner join equipos e
on e.id_equipo = p.id_equipo_local

inner join equipos ev
on ev.id_equipo = p.id_equipo_visitante

inner join jugadores_x_equipo_x_partido jxp
on p.id_partido = jxp.id_partido


where p.fecha = '2018-11-01 00:00:00'
group by e.nombre_equipo, ev.nombre_equipo;



    SELECT
			mvp.id_jugador,
			MAX(mvp.puntos)
            
	FROM (
			SELECT 
				j.id_jugador as id_jugador,
				sum(jxp.puntos) as puntos


		FROM Jugadores j

		INNER JOIN Jugadores_x_equipo_x_partido jxp ON j.id_jugador = jxp.id_jugador

		GROUP BY j.id_jugador  
    
    ) as mvp
    
    INNER JOIN Jugadores j ON mvp.id_jugador = j.id_jugador
    GROUP BY (j.id_jugador);
    


SELECT
		j.id_jugador as jugador,
        SUM(jxp.puntos) as puntos

FROM Jugadores j

INNER JOIN Jugadores_x_equipo_x_partido jxp ON jxp.id_jugador = j.id_jugador

GROUP BY (j.id_jugador)


  
/* 4. Generar una consulta que nos permita visualizar la tabla de posiciones del torneo. */
   





   
/* 5. Generar una consulta que nos permita conocer los jugadores con mejor promedio de
puntos es decir: Si hay dos jugadores que hicieron 30 puntos por partido listarlos a
ambos. */
    
 
 
 SELECT 
		concat(j.apellido_jugador," ",j.nombre_jugador) as 'Jugador',
		MAX(mvp.puntos) as puntos
 
 FROM (
 
		 SELECT 
				j.id_jugador as id_jugador,
				
				sum(jxp.puntos) as puntos


		FROM Jugadores j

		INNER JOIN Jugadores_x_equipo_x_partido jxp ON j.id_jugador = jxp.id_jugador

		GROUP BY j.id_jugador  
        ) as mvp
 
INNER JOIN Jugadores j ON mvp.id_jugador = j.id_jugador

GROUP BY j.nombre_jugador

ORDER BY ( MAX(mvp.puntos) ) desc  ;








    
/* 6. Generar una consulta que nos permita conocer los jugadores que hicieron más
puntos en un partido y en qué partido lo hicieron (Poner Equipo Local y Equipo
Visitante). */
     
     
     
     
     
     
     
/* 7. Listar los equipos y en el mismo registro listar cual es el jugador con el mayor
promedio de puntos. */

SELECT 
		e.nombre_equipo as 'Equipos',
		concat(j.apellido_jugador," ",j.nombre_jugador) as 'Jugador',
		MAX(A.puntos) as Puntos
        
FROM (

		SELECT 	j.id_jugador as id_jugador,
				j.id_equipo as id_equipo,
				AVG(jxp.puntos) as puntos
                
		FROM Jugadores j

		INNER JOIN Jugadores_x_equipo_x_partido jxp ON j.id_jugador = jxp.id_jugador
        
		GROUP BY j.id_jugador
        ) as A

INNER JOIN Equipos e ON A.id_equipo = e.id_equipo

INNER JOIN Jugadores j ON a.id_jugador = j.id_jugador

GROUP BY  e.id_equipo 

ORDER BY MAX(A.puntos) ;
      
      
      
/* 8. Listar los equipos en el mismo registro listar cual es el jugador que hizo más puntos
en un partido, cuantos puntos y en qué partido lo hizo. */


SELECT 
		e.nombre_equipo as 'Equipos',
		concat(j.apellido_jugador," ",j.nombre_jugador) as 'Jugador',
		MAX(A.puntos) as Puntos,
        A.fecha as Fecha

FROM (

		SELECT 	j.id_jugador as id_jugador,
				j.id_equipo as id_equipo,
				jxp.puntos as puntos,
                p.fecha as fecha
                
		FROM Jugadores j

		INNER JOIN Jugadores_x_equipo_x_partido jxp ON j.id_jugador = jxp.id_jugador
        
        INNER JOIN Partidos p ON jxp.id_partido = p.id_partido

        ) as A

INNER JOIN Equipos e ON A.id_equipo = e.id_equipo

INNER JOIN Jugadores j ON a.id_jugador = j.id_jugador

GROUP BY  e.id_equipo ;




#-------------------------- GUIA : STORED PROCEDURE ---------------------------


/* 1. Generar un Stored Procedure que permite ingresar un equipo. */


DELIMITER //

CREATE PROCEDURE sp_ingresar_equipo()

BEGIN




END;

//
DELIMITER ;





/* 2. Generar un Stored Procedure que permita agregar un jugador pero se debe pasar el
nombre del equipo y no el Id.  */



/* 3. Generar un Stored Procedure que permita dar de alta un equipo y sus jugadores.
Devolver en un parámetro output el id del equipo. */



/* 4. Generar un Stored Procedure que liste los partidos de un mes y año, pasado por
parametro. */



/* 5. Generar un Stored Procedure que devuelva el resultado de un partido pasando por
parámetro los nombres de los equipos. El resultado debe ser devuelto en dos
variables output */



/* 6. Generar un stored procedure que muestre las estadisticas promedio de los jugadores
de un equipo. */



