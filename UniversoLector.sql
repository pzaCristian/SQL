create database UniversoLector;
use UniversoLector;
#Alter table es para modificar algun campo. Add agregar columna. 
#ALTER TABLE peliculas
#ADD modify rating DECIMAL(3,1) NOT NULL;
# modify para modificar una columna, drop  para borrar una columna.
#Foreign key para clave foranea
#drop table if exist Autor

/* - - - - - Universo Lector Parte 2 - - - - -*/
create table if not exists Editorial(
	id_editorial int not null auto_increment primary key,
    razon_social varchar(100),
    telefono varchar(100)
);

create table if not exists Autor(
	id_autor int not null auto_increment primary key,
    nombre varchar(100) not null,
    apellido varchar(100) not null
);

create table if not exists Libro(
	id_libro int not null auto_increment primary key,
    ISBN varchar(13),
    titulo varchar(200),
    anio_escritura varchar(4),
    anio_edicion varchar(4),
    codigo_autor int not null,
	codigo_editorial int not null,
    foreign key (codigo_autor) references Autor (id_autor),
    foreign key (codigo_editorial) references Editorial (id_editorial)
);

create table Socio(
	id_socio int auto_increment primary key,
    dni int,
    nombre varchar(100),
    apellido varchar(100),
    direccion varchar(200),
    localidad varchar(100)
);

create table telefono_x_socio(
	id_telefono int auto_increment primary key,
	numero_telefono varchar(100),
    id_socio int not null,
    foreign key (id_socio) references Socio (id_socio)
);

create table Prestamo(
	id_prestamo int auto_increment primary key,
    fecha date,
    fecha_devolucion date,
    fecha_tope date,
    id_socio int not null,
    foreign key (id_socio) references Socio (id_socio)
);

create table Volumen(
	id_volumen int auto_increment primary key,
    deteriorado tinyint,
    id_libro int not null,
    foreign key (id_libro) references Libro (id_libro)
);

create table Prestamo_X_Volumen(
	id_prestamo_x_volumen int not null primary key,
    id_volumen int not null,
    id_prestamo int not null,
    foreign key (id_volumen) references Volumen (id_volumen),
    foreign key (id_prestamo) references Prestamo (id_prestamo)
);


select*from Volumen;

insert into Editorial (id_editorial,razon_social,telefono) values (default,"Salamandra","123455423"),
(default,"Kapeluz","123455423");

insert into Autor (id_autor,nombre,apellido) values (default,"J.K.","Rowling"),
(default,"Rodrigo","Soto");

insert into Autor (id_autor,nombre, apellido) values (default,"R.R.","Martin"),
(default,"Jorge Luis","Borges"),
(default,"Julio","Cortazar"),
(default,"J.R.R.","Tolkien");

select * from Autor;

insert into Libro (id_libro,ISBN,titulo,anio_escritura,anio_edicion,codigo_autor,codigo_editorial) values (default,"1231234","Que la fuerza los acompañe","2020","2021",2,1);
insert into Libro (id_libro,ISBN,titulo,anio_escritura,anio_edicion,codigo_autor,codigo_editorial) values (default,"434234223","Libro pepito","2011","2014",1,2),
(default,"333423433","Harry Potter y la piedra filosofal","2011","2014",4,2),
(default,"443546522","Harry Potter y la camara de los secretos","2011","2014",2,1),
(default,"653453432","Harry Potter y el prisionero de Askaban","2011","2014",6,1),
(default,"132343455","Harry Potter y el caliz de fuego","2011","2014",5,2),
(default,"424546334","Harry Potter y la orden del fenix","2011","2014",3,1),
(default,"675646342","Harry Potter y el misterio del principe","2011","2014",4,2),
(default,"764534234","Harry Potter y las reliquias de la muerte","2011","2014",3,2);

select * from libro;

insert into Socio (id_socio, dni, nombre, apellido, direccion, localidad) values (default,39763107,"Franco","Barilatti","11 de septiembre 6465","Mar del plata"),
(default,39850328,"Agustina","Basso","9 de julio 8675","Mar del plata"),
(default,432321,"Guido","Barilatti","11 de septiembre 6465","Mar del plata"),
(default,14066966,"Daniel","Barilatti","11 de septiembre 6465","Mar del plata"),
(default,24380480,"Marcela","Morales","11 de septiembre 6465","Mar del plata"),
(default,43324,"pepe","perez","Buenos Aires 342","Mar del plata");

insert into telefono_x_socio(id_telefono,numero_telefono,id_socio) values(default,"2235623022",1),
(default,"4789820",1),(default,"2235723698",2),(default,"2235623024",4),
(default,"2235656172",3),(default,"2235623015",5);


insert into Volumen (id_volumen,deteriorado,id_libro) values (default,1,1),
(default,0,3),(default,1,4),(default,0,5),(default,1,6),
(default,1,7);


insert into Prestamo(id_prestamo,fecha,fecha_tope,id_socio) values (default,20210930,20211002,2),
(default,20210320,20210323,3),(default,20211223,20211225,5),(default,20211121,20211125,6),
(default,20210122,20210130,1),(default,20210330,20210403,1),(default,20210414,20210422,3),
(default,20210614,20210620,2),(default,20210830,20210903,4),
(default,20211122,20211126,5),(default,20210424,20210430,6);

select * from Prestamo;

insert into Prestamo_X_Volumen(id_prestamo_x_volumen,id_volumen,id_prestamo) 
values (default,4,3), (default,3,1),(default,6,2),(default,1,11),
(default,2,10),(default,5,4);

/* - - - - - Universo Lector Parte 3 - UPDATE Y ELIMINACION - - - -*/

/* - - - - - Universo Lector Parte 4 - CONSULTAS Y QUERIES SIMPLES - - - -*/

# pregunta 1
select*from Autor;

# pregunta 2
select nombre,apellido,direccion
from Socio;

# pregunta 3
select * from Libro;

# pregunta 4
select *
from Libro
where id_libro = 2;

# pregunta 5
select *
from Volumenes
where deteriorado = true;

# pregunta 6
select * 
from Socio
where id_socio > 3;

# pregunta 7
select * 
from Socio
where id_socio = 4;

# pregunta 8
select * 
from Socio
where id_socio > 2 and id_socio < 4;

# pregunta 9
select * 
from Socio
where nombre like "P%";

# pregunta 10
select * 
from Socio
where nombre like "P%" or nombre like "H%";

# pregunta 11
select * 
from Socio
where id_Socio = 2 or nombre like "%S";

# pregunta 12
select * 
from Socio
where id_Socio > 1 and localidad like "MDQ";


/* - - - - - Universo Lector Parte 5 - - - - -*/

# 1. Listar los nombres de los usuarios que tengan prestamos. (pista distinct)
select distinct(s.nombre) 
from Socio s join Prestamo p
on s.id_socio = p.id_socio;

#2. Listar los nombres de los usuarios y la cantidad de prestamos que tienen. 

select s.nombre, s.apellido, count(p.id_prestamo) as "cantidad prestamos"
from Socio s join Prestamo p
on s.id_socio = p.id_socio
group by s.nombre, s.apellido;

/*quiero mostrar el nombre de los socios y la cantidad de prestamos que tiene siempre y cuando sean mayor a 1*/
select s.nombre, count(codigo_socio) as "Cantidad"
from socio s left join prestamo p
on s.id_socio = p.codigo_socio
group by s.nombre
having cantidad >1 ; /*esta clausula se utiliza unicamente para los campos que tengo en el select que son de agrupacion/

#3. Listar los nombres de los usuarios y la cantidad de prestamos que tienen, incluir aquellos usuarios que no tienen ningún préstamo y mostrarlo en 0.

select s.nombre, s.apellido, count(p.id_prestamo) as "cantidad prestamos"
from Socio s left join Prestamo p
on s.id_socio = p.id_socio
group by s.nombre, s.apellido;
/*on s.id_socio = p.id_socio*/

#4. Listar la cantidad de libros por autor. 

select l.titulo, a.nombre, a.apellido
from Libro l join Autor a
on l.codigo_autor = a.id_autor;

/*listar la cantidad de libros con su autor*/
select a.nombre, a.apellido, count(l.id_libro) as "cantidad libros"
from Libro l left join Autor a
on l.codigo_autor = a.id_autor
group by a.nombre, a.apellido;

/*listar la cantidad de libros que escribio cada autor */
select a.nombre, a.apellido , count(codigo_autor)
from autor a left join libro l
on a.id_autor = l.codigo_autor
group by a.nombre, a.apellido;

#5. Listar el top 5 de socios que realizaron mas prestamos.
select s.nombre, s.apellido, count(p.id_prestamo) as "cantidad"
from Socio s join Prestamo p
on s.id_socio = p.id_socio
group by s.nombre, s.apellido
order by cantidad desc;

#6. Listar el socios que realizó mas prestamos.

select s.nombre, s.apellido, count(p.id_prestamo) as "cantidad", max(cantidad)
from Socio s left join Prestamo p
on s.id_socio = p.id_socio
group by s.nombre, s.apellido;

#7 /*Listar la cantidad de usuarios que no han pedido libros hasta el momento*/
select s.nombre, count(p.id_prestamo) as "cantidad"
from Socio s left join Prestamo p
on s.id_socio = p.codigo_socio
group by s.nombre
having cantidad=0;


#8 /*Listar la cantidad de prestamos que se realizaron en el año corriente. */
select count(*), now()/*te trae la fecha hasta este momento*/
from prestamo p 
where year(fecha) =2021;

select count(*)
from prestamo p 
where year (fecha ) = year(now());/*para no estar cambiando de año todo el tiempo*/

#9 /*Listar el libro con más existencias dentro de la biblioteca. */
select l.titulo, count(l.id_libro) as "cantidad"
from libro l join volumen v
on libro.id_libro = v.codigo_libro
group by l.título
order by cantidad
limit 1;

select *, count(v.codigo_libro)
from libro l
join volumen v
on l.id_libro = v.codigo_libro
group by v.codigo_libro;

select l.titulo, count(v.codigo_libro)
from libro l
join volumen v
on l.id_libro = v.codigo_libro
group by v.codigo_libro;

#10 /*Listar los nombre de los libros que tienen mas ejemplares con deterioro. */
select l.titulo, v.deteriorado , count(v.codigo_libro)
from libro l
join volumen v
on l.id_libro = v.codigo_libro
where v.deteriorado= 1
group by l.titulo, v.deteriorado;

#11 /*Listar los 3 libros menos pedidos*/

select *
from prestamo p
join prestamoxvolumen pv
on p.codigo_prestamo = pv.codigo_prestamo
join volumen v
on v.id_volumen = pv.codigo_volumen
right join libro l
on l.id_libro = v.codigo_libro
where isnull(p.id_prestamo )
limit 3;