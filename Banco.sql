#DROP DATABASE union_20191018;
CREATE DATABASE banco2022;
USE banco2022;

CREATE TABLE Cuentas(
	id_cuenta int auto_increment,
    numero_cuenta int,
    razon_social varchar(50),
    
    CONSTRAINT pk_id_cuenta PRIMARY KEY(id_cuenta)
);

CREATE TABLE Depositos(
	id_deposito int auto_increment,
    id_cuenta int,
    fecha date,
    monto int,
    
    CONSTRAINT pk_id_deposito PRIMARY KEY (id_deposito),
    CONSTRAINT fk_id_cuenta FOREIGN KEY(id_cuenta) REFERENCES Cuentas(id_cuenta)
);

CREATE TABLE Extracciones(
	id_extraccion int auto_increment,
    id_cuenta int,
    fecha date,
    monto int,
    
    CONSTRAINT pk_id_extraccion PRIMARY KEY (id_extraccion),
    CONSTRAINT fk_id_cuenta_ FOREIGN KEY(id_cuenta) REFERENCES Cuentas(id_cuenta)
);


# Cuentas
INSERT INTO Cuentas (numero_cuenta, razon_social)
VALUES (123,'HANK SCORPIO'),(456,'ABEL ACUÑA'),(789,'TOMY AMOR ETTI'),(741,'RAMA CHALLENGER'),(852,'SANTI ESCRIBAS');
INSERT INTO Cuentas (numero_cuenta, razon_social)
VALUE (963,'PABLO FINO');

#Depositos
INSERT INTO Depositos(id_cuenta, fecha, monto)
VALUES (1,'2018-01-02',2000),(1,'2018-02-03',5000),(1,'2018-03-04',7500);

INSERT INTO Depositos(id_cuenta, fecha, monto)
VALUES (2,'2018-03-04',2500),(2,'2018-04-05',7500),(2,'2018-05-06',3500);

INSERT INTO Depositos(id_cuenta, fecha, monto)
VALUE (3,'2018-06-07',2500),(3,'2018-07-08',1500),(3,'2018-08-09',4500);

INSERT INTO Depositos(id_cuenta, fecha, monto)
VALUES (4,'2018-09-10',4500),(4,'2018-10-11',5000);

INSERT INTO Depositos(id_cuenta, fecha, monto)
VALUES (5,'2018-11-12',3000),(5,'2018-12-13',4500);

# Extracciones
INSERT INTO Extracciones(id_cuenta, fecha, monto)
VALUES (1,'2018-01-12',1500),(1,'2018-02-13',2500),(1,'2018-03-14',3200);

INSERT INTO Extracciones(id_cuenta, fecha, monto)
VALUES (2,'2018-03-14',1750),(2,'2018-04-15',2500),(2,'2018-05-16',1250);

INSERT INTO Extracciones(id_cuenta, fecha, monto)
VALUES (3,'2018-06-17',1250),(3,'2018-07-18',1500),(3,'2018-08-19',2500);

INSERT INTO Extracciones(id_cuenta, fecha, monto)
VALUES (4,'2018-09-21',2000),(4,'2018-10-22',4500);

INSERT INTO Extracciones(id_cuenta, fecha, monto)
VALUES (5,'2018-11-20',3500),(5,'2018-12-31',1500);

# Consultas (Query)

# consulta en clase
SELECT 	'Extracciones' as 'Tipo',
		c.numero_cuenta ,
		e.fecha ,
        e.monto 

FROM Extracciones e
INNER JOIN Cuentas c 
ON c.id_cuenta = e.id_cuenta
WHERE c.numero_cuenta = 123 

UNION 

SELECT 'Depositos' as 'Tipo',	
		c.numero_cuenta ,
		d.fecha ,
        d.monto 

FROM Depositos d
INNER JOIN Cuentas c 
ON c.id_cuenta = d.id_cuenta
WHERE c.numero_cuenta = 123;

# Saldo de cada cuenta y sino (cero) ; NO MUESTRA CUENTA CON SALDO = 0.
SELECT
		a.id_cuenta as 'Id Cuenta', 
		c.numero_cuenta as 'Numero Cuenta' ,
		c.razon_social as 'Razon Social', 
		SUM(ifnull(a.monto,0)) as 'Saldo'
FROM (
	SELECT
		id_cuenta,
		monto
	FROM
		Depositos 
	UNION ALL
	SELECT
		id_cuenta,
		monto*-1
		
	FROM
		Extracciones) a INNER JOIN Cuentas c ON a.id_cuenta = c.id_cuenta
        
GROUP BY a.id_cuenta;

# Saldo de cada cuenta y sino (cero) Clase : 23/10/2019 ; MUESTRA CUENTA CON SALDO=0.
SELECT	c.numero_cuenta as 'Numero Cuenta' ,
		c.razon_social as 'Razon Social', 
		ifnull(sum(movimientos.monto),0) as 'Saldo'
        
FROM Cuentas c

LEFT OUTER JOIN(
                    SELECT
						id_cuenta,
						monto
					FROM
						Depositos 
                        
					UNION ALL
					SELECT
						id_cuenta,
						(monto*-1)
                        
					FROM
						Extracciones) movimientos
                        
ON c.id_cuenta = movimientos.id_cuenta
        
GROUP BY c.numero_cuenta, c.razon_social;

# clase 23/10/2019 - subConsultas
/*
SELECT  m.razon,
		m.numero_cuenta,
        (m.total_dep ,
		m.total_ext) as Saldo
        
FROM (
		SELECT 
				c.razon_social,
                c.numero_cuenta,
                
                (	SELECT 
							ifnull(sum(monto),0)
					FROM Extracciones e
					
					WHERE e.id_cuenta = c.id_cuenta
					) as total_ext ,
                
                (	SELECT 
							ifnull(sum(monto),0)
					FROM Depositos d
					
					WHERE d.id_cuenta = c.id_cuenta
					) as total_dep
          FROM  Cuentas c
                
			) mov;
            



	SELECT 
				c.razon_social,
                c.numero_cuenta,
                
                (	SELECT 
							ifnull(sum(monto),0)
					FROM Extracciones e
					
					WHERE e.id_cuenta = c.id_cuenta
					) as total_ext ,
                
                (	SELECT 
							ifnull(sum(monto),0)
					FROM Depositos d
					
					WHERE d.id_cuenta = c.id_cuenta
					) as total_dep
          FROM  Cuentas c;

*/
# 1 
SELECT * 

FROM Depositos 

WHERE Fecha = (SELECT MAX(fecha) FROM Depositos);

#2 

SELECT *

FROM Cuentas

WHERE 

id_cuenta IN(
				SELECT id_cuenta 
                FROM Depositos 
                UNION
                SELECT id_cuenta
                FROM Extracciones
                );
                
                
# 3 - Todas las cuentas que tengan depositos

SELECT *

FROM Cuentas c
WHERE EXISTS(
				SELECT *
                FROM Depositos d
                WHERE d.id_cuenta = c.id_cuenta
			);

select 'Depositos' as 'Tipo de movimiento',monto from depositos
union    
select 'Extracciones',monto from extracciones;

select 'Depositos' as 'Tipo de movimiento',monto from depositos
union all    
select 'Extracciones',monto from extracciones;

select 'Depositos' as 'Tipo de movimiento',numeroDeposito as 'Numero Movimiento',fecha,monto from depositos
union all   
select 'Extracciones',numeroExtraccion,fecha,monto from extracciones;





 /* Ejercicios
-Listar los primeros 3 depositos y las primeras 3 extracciones
-Listar el total depositado y el total de extracciones
-Listar el promedio de Depositos y de Extracciones
-Listar el Balance de Transferencias (Depositos - Extracciones)*/







# 1 parcial

DROP PROCEDURE add_cuenta_and_depositos

DELIMITER $$
CREATE PROCEDURE  add_cuenta_and_depositos ( pNumeroCuenta int, pRazonSocial varchar(50) , pFecha date, pMonto int, out pIdCuenta int)
BEGIN

		INSERT INTO Cuentas (numero_cuenta , razon_social)
        VALUE ( pNumeroCuenta,  pRazonSocial);
        
        set pIdCuenta = last_insert_id();
        
        INSERT INTO Depositos (id_cuenta,fecha, monto)
        VALUE (pIdCuenta, pFecha, pMonto);
	
END;
$$
DELIMITER ;

select * from Cuentas;

call union_20191018.add_cuenta_and_depositos (777,'Maria DB', '2019-11-13', 1500, @pidCuenta);

select @pidCuenta;


# 2do ejerc parcial

# cuenta , depositos

SELECT	c.numero_cuenta as 'Numero Cuenta',
		c.razon_social as 'Cuenta' ,
        ifnull(sum(d.monto),0) as 'Monto Total' 
        
FROM Cuentas c

LEFT OUTER JOIN Depositos d ON d.id_cuenta = c.id_cuenta

GROUP BY (c.numero_cuenta);



SELECT
		c.numero_cuenta,
        c.razon_social,
        ifnull(monto,0) as 'Saldo'

FROM Cuentas c

INNER JOIN (
			
            SELECT 
					id_cuenta ,
					sum(monto) as monto
			FROM Depositos d
            
            UNION ALL
            
            SELECT 
					id_cuenta ,
					sum(monto*-1) as monto
			FROM Extracciones 
) movimiento 

ON id_cuenta = c.id_cuenta

GROUP BY (c.numero_cuenta);






SELECT 
		c.razon_social as 'Cuenta',
        ifnull(p.promedio,0) as 'Promedio'
FROM
		(
        SELECT 	
				d.id_cuenta as id_cuenta,
				AVG(d.monto) as promedio

		FROM Depositos d 
        
        INNER JOIN Cuentas c ON d.id_cuenta = c.id_cuenta
        
        GROUP BY (d.id_cuenta)
        
        ) as p
	
INNER JOIN Cuentas c ON p.id_cuenta = c.id_cuenta

GROUP BY(c.razon_social)

ORDER BY p.promedio desc ;



	
