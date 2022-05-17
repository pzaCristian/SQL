DROP DATABASE bank;
CREATE DATABASE bank;
USE bank;

CREATE TABLE cities  (id INT AUTO_INCREMENT, 
		      `name` VARCHAR(50) ,
		      CONSTRAINT pk_cities PRIMARY KEY (id),
		      CONSTRAINT unq_cities UNIQUE (NAME));
			
CREATE TABLE clients (id INT AUTO_INCREMENT,
		       `name` VARCHAR(50),
		       last_name VARCHAR(50),
		       id_city INT,
		       identification_number VARCHAR(50),
		       CONSTRAINT pk_clients PRIMARY KEY (id),
		       CONSTRAINT unq_id_number UNIQUE (identification_number),
		       CONSTRAINT fk_clientes_cities FOREIGN KEY (id_city) REFERENCES cities(id));

CREATE TABLE accounts  (id INT AUTO_INCREMENT, 
			account_number VARCHAR(50),
			id_client INT,
			CONSTRAINT pk_accounts PRIMARY KEY (id),
		        CONSTRAINT unq_account_number UNIQUE (account_number),
		        CONSTRAINT fk_account_clients FOREIGN KEY (id_client) REFERENCES clients(id));

CREATE TABLE deposits  (id INT AUTO_INCREMENT, 
			id_account INT,
			`date` TIMESTAMP,
			amount FLOAT,
			CONSTRAINT pk_deposits PRIMARY KEY (id),
		        CONSTRAINT fk_deposits_account FOREIGN KEY (id_account) REFERENCES accounts(id));


CREATE TABLE extractions (id INT AUTO_INCREMENT, 
			id_account INT,
			`date` DATETIME,
			amount FLOAT,
			CONSTRAINT pk_extractions PRIMARY KEY (id),
		        CONSTRAINT fk_extractions_account FOREIGN KEY (id_account) REFERENCES accounts(id));




INSERT INTO cities (NAME) VALUES ('Mar del Plata'),('Buenos Aires'),('Parana');

INSERT INTO clients (NAME, last_name, id_city, identification_number) VALUES ('Pablo','Fino',1,'1'),('Veronica','Tomich',2,'2');

INSERT INTO accounts(account_number,id_client) VALUES ('1',1),('2',1),('3',2);

INSERT INTO deposits(id_account,DATE,amount) VALUES (2,NOW(),400),(2,NOW(),20),(2,NOW(),21);
INSERT INTO deposits(id_account,DATE,amount) VALUES (1,NOW(),410),(1,NOW(),320),(1,NOW(),241);
INSERT INTO extractions(id_account,DATE,amount) VALUES (2,NOW(),150), (2,NOW(),120);

INSERT INTO deposits(id_account,DATE,amount) VALUES (3,'2020-10-10 09:25:00',400);
INSERT INTO extractions(id_account,DATE,amount) VALUES (3,'2020-10-10 09:25:00',400);


/*0 - Union */

/* 1 union basico */


SELECT * FROM deposits 
UNION 
SELECT * FROM extractions


/* UNION ALL*/

SELECT id_account, DATE, amount FROM deposits WHERE id_account = 3
UNION  
SELECT id_account, DATE, amount FROM extractions WHERE id_account = 3



/*Query para sacar los movimientos de una cuenta */


SELECT 'Depósito', id_account , DATE, amount FROM deposits WHERE id_account = 3
UNION  
SELECT 'Extracción', id_account, DATE, amount  FROM extractions WHERE id_account = 3



/*1 Subqueries en el where*/

SELECT  
	* 
FROM
	deposits 
WHERE
	id_account IN (1,2,3)
	
SELECT  
	* 
FROM
	deposits 
WHERE
	id_account = (SELECT id FROM accounts WHERE account_number = '2') /**Solo un registro*/


/*devolver las cuetas que tengan algun deposito*/


SELECT * FROM accounts WHERE EXISTS (SELECT * FROM deposits WHERE deposits.id_account = accounts.id)


/*2 Subqueries en el SELECT */

SELECT 
	a.id,
	a.account_number,
	c.name,
	c.last_name,
	(SELECT SUM(amount) FROM deposits d WHERE d.id_account = a.id) AS depositos,
	(SELECT SUM(amount) FROM extractions e WHERE e.id_account = a.id) AS extracciones
FROM clients c INNER JOIN accounts a ON c.id = a.id_client


/* 3 Obtener el listado de movimientos de una cuenta en particular*/


SELECT 'Deposito' AS tipo_movimiento, d.id , d.date, d.amount  FROM deposits d WHERE d.id_account = 2 
UNION 
SELECT 'Extracción' AS tipo_movimiento, e.id , e.date, e.amount   FROM extractions e WHERE e.id_account = 2
ORDER BY tipo_movimiento, DATE DESC


/* 4. SALDO */


/*FORMA 1 :  EN EL SELECT*/

SELECT 
	a.id,
	a.account_number,
	c.name,
	c.last_name,
	(SELECT IFNULL(SUM(amount),0) FROM deposits d WHERE d.id_account = a.id) AS total_deposits,
	(SELECT IFNULL(SUM(amount),0) FROM extractions e WHERE e.id_account = a.id) AS total_extractions	,
	(SELECT IFNULL(SUM(amount),0) FROM deposits d WHERE d.id_account = a.id) - (SELECT IFNULL(SUM(amount),0) FROM extractions e WHERE e.id_account = a.id) AS balance
FROM clients c INNER JOIN accounts a ON c.id = a.id_client


/*FORMA 2 : FROM y SELECT */

SELECT balance.id, balance.account_number, balance.name, balance.last_name, (balance.total_deposits  - balance.total_extractions) AS balance FROM (
SELECT 
	a.id,
	a.account_number,
	c.name,
	c.last_name,
	(SELECT IFNULL(SUM(amount),0) FROM deposits d WHERE d.id_account = a.id) AS total_deposits,
	(SELECT IFNULL(SUM(amount),0)  FROM extractions e WHERE e.id_account = a.id) AS total_extractions	
FROM clients c INNER JOIN accounts a ON c.id = a.id_client) balance




/*FORMA 3 : FROM  */



SELECT 
	c.name, c.last_name,a.id, a.account_number, SUM(IFNULL(m.amount,0)) AS balance 
FROM 
	accounts a LEFT OUTER JOIN (
					SELECT d.id_account, 
					       SUM(d.amount)  AS amount 
					       FROM deposits d   GROUP BY d.id_account
					UNION ALL
					SELECT 
						e.id_account, 
						SUM(e.amount) * -1 AS amount  
						FROM extractions e  GROUP BY e.id_account
	) m ON a.id = m.id_account
	INNER JOIN clients c ON a.id_client = c.id
GROUP BY c.name, c.last_name, a.id, a.account_number
 

 










/**STORED PROCEDURE*//


/**1 Stored procedure simple sin parametros para hacer un select */

DELIMITER $$
CREATE PROCEDURE p_get_accounts() 
BEGIN
	SELECT * FROM accounts;
END;
$$

CALL p_get_accounts();


/**2 stored procedure en select pero con parametros */

DROP PROCEDURE IF EXISTS p_get_movements;
DELIMITER $$
CREATE PROCEDURE p_get_movements(IN pIdAccount INT ) 
BEGIN
	SELECT 'Deposito' AS tipo_movimiento, d.id , d.date, d.amount  FROM deposits d WHERE d.id_account = pIdAccount 
	UNION 
	SELECT 'Extracción' AS tipo_movimiento, e.id , e.date, e.amount   FROM extractions e WHERE e.id_account =  pIdAccount
	ORDER BY tipo_movimiento, DATE DESC;
END;
$$


CALL p_get_movements (2)



/** 3 Stored procedure para insertar datos */

USE bank;
DROP PROCEDURE IF EXISTS p_insert_client;
DELIMITER $$
CREATE PROCEDURE p_insert_client(IN pName VARCHAR(50), IN pLastName VARCHAR(50), pIdCity INT, pIdentificationNumber VARCHAR(50)) 
BEGIN
	INSERT INTO clients(NAME,last_name, id_city, identification_number) VALUES
	(pName, pLastName, pIdCity, pIdentificationNumber);
END;
$$


CALL p_insert_client('Pablo','Pino', 1, '12345');


/**4  Insertar datos y devolver el id **/

DROP PROCEDURE IF EXISTS p_insert_client_2;
DELIMITER $$
CREATE PROCEDURE p_insert_client_2(IN pName VARCHAR(50), IN pLastName VARCHAR(50), pIdCity INT, pIdentificationNumber VARCHAR(50),OUT pId  INT) 
BEGIN
	INSERT INTO clients(NAME,last_name, id_city, identification_number) VALUES
	(pName, pLastName, pIdCity, pIdentificationNumber);
	SET pId = LAST_INSERT_ID();

END;
$$

CALL p_insert_client_2('Fablo','Pino', 1, '12345', @out);
SELECT @out



/**5 VALIDACIONES Y VARIABLES */

DROP PROCEDURE IF EXISTS p_insert_client_3;
DELIMITER $$
CREATE PROCEDURE p_insert_client_3(IN pName VARCHAR(50), IN pLastName VARCHAR(50), pCityName VARCHAR(50), pIdentificationNumber VARCHAR(50),OUT pId  INT) 
BEGIN
	DECLARE vIdCity INT DEFAULT 0 ;
	SELECT id INTO vIdCity FROM cities WHERE NAME = pCityName;
	IF (vIdCity<>0) THEN
			INSERT INTO clients(NAME,last_name, id_city, identification_number) VALUES (pName, pLastName, vIdCity, pIdentificationNumber);
			SET pId = LAST_INSERT_ID();
	ELSE
				SIGNAL SQLSTATE '45000' SET  MESSAGE_TEXT = 'City does not exists please provide a valid city';
	END IF;
END;
$$

CALL p_insert_client_3('Fablo','Pino', 'Mar del Flata', '12345', @out);

SELECT @out
SELECT * FROM clients



/* 6 stored procedures llamados entre ellos*/

DROP PROCEDURE IF EXISTS p_insert_account;
DELIMITER $$
CREATE PROCEDURE p_insert_account( pAccountNumber INT, pIdClient INT, OUT pId INT)
BEGIN
	INSERT INTO accounts(account_number,id_client) VALUES (pAccountNumber, pIdClient);
	SET pId = LAST_INSERT_ID();

END;
$$


DROP PROCEDURE insert_client_default_account;
DELIMITER $$
CREATE PROCEDURE insert_client_default_account(IN pName VARCHAR(50), IN pLastName VARCHAR(50), pCityName VARCHAR(50), pIdentificationNumber VARCHAR(50), pAccountNumber VARCHAR(50), OUT pIdClient INT, OUT pIdAccount INT)
BEGIN
	DECLARE vIdClient INT DEFAULT 0;
	DECLARE vIdAccount INT DEFAULT 0;

	CALL p_insert_client_3(pName, pLastName, pCityName, pIdentificationNumber ,vIdClient);
	CALL p_insert_account(pAccountNumber,vIdClient,vIdAccount);
	
	SET pIdClient = vIdClient;
	SET pIdAccount = vIdAccount;

END;
$$

CALL insert_client_default_account('Luis','Perez', 'Buenos Aires', '46464', '46464646',@id_client, @id_account);

SELECT * FROM clients WHERE id = @id_client

SELECT * FROM accounts WHERE id = @id_account


#1.	Crear un procedimiento que permita visualizar a las cervezas que tienen graduacion alcoholica mayor al que se indica por parámetro.

DROP PROCEDURE IF EXISTS eje1; 
DELIMITER //
CREATE PROCEDURE ejemplo1 (IN grado INT)
BEGIN
	SELECT * 
    FROM cervezas  
    WHERE GradoAlcohol > grado;
END//

#llamado al procedimiento ejemplo1
CALL ejemplo1 (0);

#2.	Crear un procedimiento que inserte una cerveza y una graduación alcoholica pasadas por parametro
DROP PROCEDURE IF EXISTS eje2; 
DELIMITER //
CREATE PROCEDURE eje21 (IN nombre varchar(30), IN grado float)
BEGIN
	INSERT cervezas (NombreCerveza, GradoAlcohol ) 
    VALUES (nombre, grado);
END//

select *
from cervezas;

CALL eje21 ('Ejemplo', 8);

#3.	Crear un procedimiento que inserte una cerveza y una graduación alcoholica pasadas por parametro y retorne el id del último insertado
DROP PROCEDURE IF EXISTS insertarCerveza; 
DELIMITER //
create procedure insertarCerveza(IN nombre varchar(30), IN grado float, OUT idLast int)
Begin
insert into cervezas (NombreCerveza, GradoAlcohol ) VALUES (nombre, grado);
set idLast = last_insert_ID();
END//

Call insertarCerveza('IPAKISTAN', 12, @retorno);
Select @retorno;

select *
from cervezas
where IdCerveza=@retorno;


drop procedure if exists sp_ResultadoPartido;
DELIMITER $$
create PROCEDURE sp_ResultadoPartido(
	pNombreEquipoLocal varchar(50),
    pNombreEquipoVisitante varchar(50),
    OUT pPuntosLocal int,
    OUT pPuntosVisi int)
BEGIN
	/* Declaramos las variables*/
	declare vIdEquipoLocal int default null;
    declare vIdEquipoVisi int default null;    
    declare vIdPartido int default null;
    /*Obtenemos los valores para hacer la super query*/
    select id_equipo into vIdEquipoLocal from equipos where nombre_equipo = pNombreEquipoLocal;
    select id_equipo into vIdEquipoVisi from equipos where nombre_equipo = pNombreEquipoVisitante;
    select id_partido into vIdPartido from partidos where id_equipo_local = vIdEquipoLocal and id_equipo_visitante = vIdEquipoVisi;
    
    
    if (vIdEquipoLocal is null) then
		SIGNAL sqlstate '11111' SET MESSAGE_TEXT = 'No existe el equipo local', MYSQL_ERRNO = 9999; 
    end if;
    
    if (vIdEquipoVisi is null) then
		SIGNAL sqlstate '11111' SET MESSAGE_TEXT = 'No existe el equipo visitante', MYSQL_ERRNO = 9999; 
    end if;

    if (vIdPartido is null) then
		SIGNAL sqlstate '11111' SET MESSAGE_TEXT = 'No hay partido entre estos dos equipos', MYSQL_ERRNO = 9999; 
    end if;    
    
    /*Hacemos la query con los valores*/
	select 
		(select 
			sum(jxp.puntos) 
		from 
			jugadores_x_partido jxp 
			inner join jugadores j on jxp.id_jugador = j.id_jugador
		where jxp.id_partido = p.id_partido  and j.id_equipo = el.id_equipo),
		(select 
			sum(jxp.puntos) 
		from 
			jugadores_x_partido jxp 
			inner join jugadores j on jxp.id_jugador = j.id_jugador
		where jxp.id_partido = p.id_partido  and j.id_equipo = ev.id_equipo)
        into pPuntosLocal,pPuntosVisi
	from 
		partidos p 
		inner join equipos el on el.id_equipo = p.id_equipo_local
		inner join equipos ev on ev.id_equipo = p.id_equipo_visitante
	where 
		p.id_partido = vIdPartido ;
end
$$

CALL sp_ResultadoPartido ('River','Independiente',@ptosLocal,@ptosVisi);
select @ptosLocal,@ptosVisi from dual;


select * from jugadores 

DELIMITER $$
CREATE PROCEDURE sp_InsertarJugador(
	pNombreEquipo varchar(50),
    pNombre varchar(50),
    pApellido varchar(50),
    pDni varchar(12))
BEGIN
		DECLARE pIdEquipo int default 0;
        
        select id_equipo into pIdEquipo
        from equipos where nombre_equipo = pNombreEquipo;

        if (pIdEquipo <>0) then
				insert into jugadores(id_equipo,nombre,apellido,dni)
                values (pIdEquipo,pNombre,pApellido,pDni);
        else 
			SIGNAL sqlstate '11111' SET MESSAGE_TEXT = 'No existe el equipo', MYSQL_ERRNO = 1232;
        end if;

END;
$$