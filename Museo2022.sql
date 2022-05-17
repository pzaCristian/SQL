/*_________________________________________________________________________
-------------------- GUIA 3 MUSEO - VISITAS DE COLEGIOS--------------------
_________________________________________________________________________*/
create database museo2022;
use museo2022;
    
create table Provincia (
	id_Provincia int primary key,
    nombre varchar (35) unique
    );

create table Ciudad (
	id_Ciudad int,
    nombre varchar (35),
    poblacion int,
    id_provincia int,
    constraint primary key (id_Ciudad),
    foreign key (id_provincia) references Provincia (id_Provincia)
    );
    
update Ciudad set id_Ciudad = 7600 where id_Ciudad =1;
update Ciudad set id_Ciudad = 7500 where id_Ciudad =2;
select * from Ciudad;
alter table Ciudad add constraint chkidCiudad check (id_Ciudad >=1000 and id_Ciudad <=9999);
insert into Ciudad values (7800, "Dolores", 160000, 1);


    create table Escuela (
	id_Escuela int auto_increment primary key,
    nombre varchar (30) not null,
    calle varchar (20) not null,
    altura int not null,
    id_ciudad int,
    foreign key (id_ciudad) references Ciudad (id_Ciudad)
    );
    
    /*SI no hubiera agregado la relacion de la entidad Escuela con Ciudad..*/
    alter table Escuela add id_ciudad int;
    alter table Escuela add constraint foreign key (id_ciudad) references Ciudad (id_Ciudad);
    
    /*Actualizamos valores*/
    update Escuela set id_ciudad= 7600 where id_ciudad =1;
    
    select * from Escuela;
    INSERT INTO `museo2022`.`Escuela` (`id_Escuela`, `nombre`, `calle`, `altura`) VALUES ('4', 'Estella Maris', 'Don Bosco', '5432');
INSERT INTO `museo2022`.`Escuela` (`id_Escuela`, `nombre`, `calle`, `altura`) VALUES ('5', 'Sarmiento', 'Faustino S', '32');

    select * from Ciudad;
INSERT INTO `museo2022`.`Ciudad` (`id_Ciudad`, `nombre`, `poblacion`, `id_provincia`) VALUES ('7900', 'La Pampita', '5000', '2');
    
    delete from Ciudad where id_Ciudad = 3;
    
    create table Telefono (
		id_telefono int auto_increment,
        prefijo int not null, 
        numero varchar (12) not null,
        id_Escuela int,
        constraint primary key (id_telefono),
        constraint foreign key (id_Escuela) references Escuela (id_Escuela)
	);
    
    create table Reserva (
		id_Reserva int not null auto_increment primary key,
        fecha date,
        hora date, 
        cantidadAlumnos int,
        grado int,
        id_Escuela int,
        constraint foreign key (id_Escuela) references Escuela (id_Escuela)
	);
    
    create table tipoDevisita (
		idTipoVista int not null auto_increment primary key,
        descripcion varchar (20),
        arancel int
	);
    
    create table visita (
		id_Visita int primary key auto_increment,
        grado int,
        colaboracion int,
        alumnosReales int, 
        alumnosAnotados int,
        id_Reserva int, 
        id_tipoVisita int,
        foreign key (id_Reserva) references Reserva (id_Reserva),
        foreign key (id_tipoVisita) references tipoDevisita (idTipoVista)
   );
   
   alter table visita add constraint alumnos check (alumnosReales <= alumnosAnotados);
   alter table visita add constraint soloValor check (alumnosReales = Case when alumnosReales is null then alumnosAnotados else alumnosReales END); 
   create table Guia (
		id_Guia int primary key not null, 
		nombre varchar (30)
    );
    
    create table guiaXvisita (
		id_guiaXvisita int primary key,
        id_visita int,
        id_guia int,
        foreign key (id_visita) references visita (id_Visita),
        foreign key (id_guia) references Guia (id_Guia)
        );

describe guiaXvisita;
alter table guiaXvisita add resposable boolean;
insert into provincia (id_Provincia, nombre) values (1, "Buenos Aires"), (2,"La Pampa"), (3,"Mendoza");
select * from guiaxvisita; 
select * from provincia;

insert into ciudad (id_Ciudad, nombre, poblacion, id_provincia) values (1, "Mar del plata", 200000, 1), (2, "Miramar", 15000,1), (3, "Mendocita", 190000,3);

select * from ciudad;

INSERT INTO `museo2022`.`escuela` (`id_Escuela`, `nombre`, `calle`, `altura`, `id_ciudad`) VALUES ('1', 'Escuela 16', 'Olazabal', '1023', '7600');
INSERT INTO `museo2022`.`escuela` (`id_Escuela`, `nombre`, `calle`, `altura`, `id_ciudad`) VALUES ('2', 'Escuela 20', 'San Martin', '3024', '7600');
INSERT INTO `museo2022`.`escuela` (`id_Escuela`, `nombre`, `calle`, `altura`, `id_ciudad`) VALUES ('3', 'Escuela Hualein', 'Tres Arroyos', '1040', '7600');

select * from escuela;

INSERT INTO `museo2022`.`telefono` (`id_telefono`, `prefijo`, `numero`, `id_Escuela`) VALUES ('1', '223', '4651126', '1');
INSERT INTO `museo2022`.`telefono` (`id_telefono`, `prefijo`, `numero`, `id_Escuela`) VALUES ('2', '223', '4655919', '2');
INSERT INTO `museo2022`.`telefono` (`id_telefono`, `prefijo`, `numero`, `id_Escuela`) VALUES ('3', '223', '4510970', '2');
INSERT INTO `museo2022`.`telefono` (`id_telefono`, `prefijo`, `numero`, `id_Escuela`) VALUES ('4', '223', '4916874', '3');

select * from telefono;

INSERT INTO `museo2022`.`reserva` (`id_Reserva`, `fecha`, `hora`, `cantidadAlumnos`, `grado`, `id_Escuela`) VALUES ('1', '2022-01-04', '12', '20', '6', '1');
INSERT INTO `museo2022`.`reserva` (`id_Reserva`, `fecha`, `hora`, `cantidadAlumnos`, `grado`, `id_Escuela`) VALUES ('2', '2022-01-05', '15', '10', '4', '1');
INSERT INTO `museo2022`.`reserva` (`id_Reserva`, `fecha`, `hora`, `cantidadAlumnos`, `grado`, `id_Escuela`) VALUES ('3', '2022-01-31', '08', '25', '5', '2');
INSERT INTO `museo2022`.`reserva` (`id_Reserva`, `fecha`, `hora`, `cantidadAlumnos`, `grado`, `id_Escuela`) VALUES ('4', '2022-04-23', '18:30', '35', '3', '1');

select * from reserva;

select * from guia;
insert into guia (id_Guia, nombre) values (1, "Juan Perez"),(2, "Josefa Alvez"),(3, "Martin Toro"),(4, "Ana Rodriguez");
insert into guia (id_Guia, nombre) values (5,"Graciela Diaz"), (6,"Luciano Lopez");

select * from tipodevisita;
insert into tipodevisita (idTipoVista, descripcion, arancel)  values (1,'Animales Salvajes',150),(2,'Animales Prehistoricos', 160),
(3,'Animales Acuaticos', 100),(4,'Animales Aereos', 170),(5,'Animales Terrestres', 90);

select * from visita;
INSERT INTO `museo2022`.`visita` (`id_Visita`, `grado`, `colaboracion`, `alumnosReales`, `alumnosAnotados`, `id_Reserva`, `id_tipoVisita`) VALUES ('1', '6', '4000', '15', '20', '1', '2');
INSERT INTO `museo2022`.`visita` (`id_Visita`, `grado`, `colaboracion`, `alumnosReales`, `alumnosAnotados`, `id_Reserva`, `id_tipoVisita`) VALUES ('2', '3', '5600', '25', '35', '4', '4');


select * from guiaxvisita;
INSERT INTO `museo2022`.`guiaxvisita` (`id_guiaXvisita`, `id_visita`, `id_guia`, `resposable`) VALUES ('1', '1', '1', 'false');
INSERT INTO `museo2022`.`guiaxvisita` (`id_guiaXvisita`, `id_visita`, `id_guia`, `resposable`) VALUES ('2', '1', '2', 'true');
INSERT INTO `museo2022`.`guiaxvisita` (`id_guiaXvisita`, `id_visita`, `id_guia`, `resposable`) VALUES ('3', '1', '3', 'false');
INSERT INTO `museo2022`.`guiaxvisita` (`id_guiaXvisita`, `id_visita`, `id_guia`, `resposable`) VALUES ('4', '2', '2', 'false');
INSERT INTO `museo2022`.`guiaxvisita` (`id_guiaXvisita`, `id_visita`, `id_guia`, `resposable`) VALUES ('5', '2', '4', 'true');
INSERT INTO `museo2022`.`guiaxvisita` (`id_guiaXvisita`, `id_visita`, `id_guia`, `resposable`) VALUES ('6', '2', '3', 'false');

UPDATE `museo2022`.`guiaxvisita` SET `resposable` = '1' WHERE (`id_guiaXvisita` = '2');
UPDATE `museo2022`.`guiaxvisita` SET `resposable` = '1' WHERE (`id_guiaXvisita` = '5');



/*_________________________________________________________________________
-------------------- GUIA 4 MUSEO - VISITAS DE COLEGIOS--------------------
-------------------- Consultas y combinaciones de tablas-------------------
_________________________________________________________________________*/
/*(A) - Listar nombre y teléfonos de cada escuela*/
select e.nombre, f.numero as "Numero de Telefono"
from Escuela e
inner join telefono f
on e.id_Escuela = f.id_Escuela
group by e.nombre, f.numero;

/*(B) - Listar Nombre y cantidad de Reservas realizadas para cada Escuela durante el presente año.*/
select e.nombre, count(r.id_Reserva) as "Cantidad de Reserva"
from Escuela e
inner join reserva r
on e.id_Escuela = r.id_Escuela
where year (r.fecha) = year (now())
group by e.nombre;

/*(C) - Listar Nombre y cantidad de Reservas realizadas para cada Escuela durante el presente año, en caso
de no haber realizado Reservas, mostrar el número cero.*/
select e.nombre, count(r.id_reserva)
from  Escuela e
left join  Reserva r
on e.id_Escuela = r.id_Escuela
where year (r.fecha) = year(now())
group by e.nombre;

/*(D) -Listar el nombre de los Guías que participaron en las Visitas, pero no como Responsable.*/
select g.nombre
from guia g
inner join guiaXvisita gxv
on g.id_Guia = gxv.id_guia
where gxv.resposable = false
group by g.nombre;

/*(E) -Listar el nombre de los Guías que no participaron de ninguna Visita..*/
select g.nombre
from guia g
left join guiaxvisita gxv
on g.id_Guia = gxv.id_guia
where gxv.id_guia is null;

/*(Extra) -Listar el nombre de los guias que participaron en las visitas y cada tipo de visita que hicieron.*/
Select g.nombre, t.descripcion
from guia g
inner join guiaxvisita gxv
on g.id_Guia = gxv.id_guia
inner join visita v 
on gxv.id_visita = v.id_visita
inner join tipodevisita t
on v.id_tipoVisita = t.idTipoVista;

/*(E) -Listar para cada Visita, el nombre de Escuela, el nombre del Guía responsable, la cantidad de
alumnos que concurrieron y la fecha en que se llevó a cabo.*/
select v.id_Visita, e.nombre, g.nombre, v.alumnosReales, r.fecha
from visita v
inner join reserva r
on v.id_Reserva = r.id_Reserva
inner join escuela e
on r.id_Escuela = e.id_Escuela
inner join guiaxvisita gxv
on v.id_Visita = gxv.id_visita
inner join guia g
on gxv.id_guia = g.id_Guia
where gxv.resposable = true
group by v.id_Visita, e.nombre, g.nombre, v.alumnosReales, r.fecha;

/*(F) -Listar el nombre de cada Escuela y su localidad. También deben aparecer las Localidades que no
tienen Escuelas, indicando ‘Sin Escuelas’. Algunas Escuelas no tienen cargada la Localidad, debe
indicar ‘Sin Localidad’*/
select ifnull(e.nombre,"Sin Escuelas") As "Escuela" , ifnull(c.nombre, 'Sin Localidad') as "Localidad"
from escuela e
right join ciudad c
on e.id_ciudad = c.id_Ciudad
group by e.nombre, c.nombre;