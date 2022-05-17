# ------------------------ GUIA N° 4 : Consulta y combinación de tablas MUSEO . -----------------------------------
use museo;
/* 1. Listar nombre y telefonos de cada las escuelas*/
select e.nombre_escuela, t.telefono
from escuelas e
inner join telefonos t 
on e.id_escuela = t.id_escuela;

/* 2. Listar Nombre y cantidad de Reservas realizadas para cada Escuela durante el presente año.*/
Select e.nombre_escuela, count(r.id_escuela) as cantidad
from escuelas e
inner join reservas r
on e.id_escuela=r.id_escuela
where year(r.fecha_reserva)=year(now())
group by e.nombre_escuela;

/* 3. Listar Nombre y cantidad de Reservas realizadas para cada Escuela durante el presente año, 
en caso  de no haber realizado Reservas, mostrar numero cero. */
Select e.nombre_escuela, count(r.id_escuela)
from escuelas e
left join reservas r 
on e.id_escuela=r.id_escuela and year(r.fecha_reserva) = year (now())
group by e.nombre_escuela;

/* 4. Listar el nombre de los Guias que participaron en las Visitas, pero no como Responsables.*/
select g.nombre
from guias g
inner join visitas_x_guias vxg
on g.id_guia=vxg.id_guia
where vxg.responsable=false;
    
/* 5. Listar el nombre de los Guias que no participaron en ninguna Visita. */
Select g.nombre
from guias g
left join visitas_x_guias vxg
on g.id_guia = vxg.id_guia
where vxg.id_guia is null;

/*Extra. Listar el nombre de los guias que participaron en las visitas y cada tipo de visitas que hicieron*/
select g.nombre, v.id_tipo_visita
from guias g 
inner join visitas_x_guias vxg on g.id_guia = vxg.id_guia
inner join visitas v on v.id_tipo_visita = vxg.id_tipo_visita;

/* 6. Listar para cada Visita, el nombre de Escuela, el nombre del Guía responsable, la cantidad de
alumnos que concurrieron y la fecha en que se llevó a cabo.*/
select g.nombre, e.nombre_escuela, v.cant_alumnos, v.fecha_visita
from visitas v
inner join visitas_x_guias vxg on v.id_reserva = vxg.id_reserva
inner join guias g on g.id_guia = vxg.id_guia
inner join reservas r on r.id_reserva = v.id_reserva
inner join escuelas e on e.id_escuela = r.id_escuela;

/* 7. Listar el nombre de cada Escuela y su localidad. También deben aparecer las Localidades que no
tienen Escuelas, indicando ‘Sin Escuelas’. Algunas Escuelas no tienen cargada la Localidad, debe
indicar ‘Sin Localidad’. */

/* 8. Listar el nombre de los Directores  y el de los Guías, juntos, ordenados alfabéticamente. */

/* 9. Listar el nombre de los Directores de las escuelas de Mar del Plata,  y el de todos los Guías, juntos,
ordenados alfabéticamente. */

/* 10. Listar para las Escuelas que tienen Reservas, el nombre y la Localidad, teniendo en cuenta que
algunas Escuelas no tienen Localidad. */



# ------------------------ GUIA N° HOSPITAL . -- SUBCONSULTAS -----------------------------------
use hospital;

-- 1. Mostrar el numero de empleado, el apellido y la fecha de alta del empleado mas antiguo de la empresa
select e.id_empleado, e.apellido, e.fecha_alta
from empleado e
where fecha_alta = (Select min(em.fecha_alta) from empleado em);

-- 2. Mostrar el numero de empleado, el apellido y la fecha de alta del empleado mas modernos de la empresa
select e.id_empleado, e.apellido, e.fecha_alta
from empleado e
where fecha_alta = (Select MAX(em.fecha_alta) from empleado em)
limit 1;

-- 3. Mostrar el apellido y el oficio de los empleados con el mismo oficio que Arroyo.
select e.apellido, e.oficio
from empleado e
where oficio = (Select em.oficio
				from empleado em
				where em.apellido like "Arroyo");
                
-- 4. Mostrar apellidos y oficio de los empleados del departamento 2 cuyo trabajo sea el mismo que el de cualquier empleado de ventas.
Select e.apellido, e.oficio
from empleado e
where e.id_departamento=2 AND e.oficio in
					(Select em.oficio
                    from empleado em
                    join departamento d
                    on em.id_departamento=d.id_departamento
                    where d.nombre like "Ventas");
                    
-- 5. Mostrar los empleados que tienen mejor salario que la media de los vendedores, no incluyendo al presidente.
Select * 
from empleado e
where e.salario > (Select avg(em.salario)
					from empleado em
                    where e.oficio <> "Presidente");

-- 6. Mostrar los hospitales que tienen personal (Doctores) de cardiología.
Select * 
from hospital h
where h.id_hospital IN (Select d.id_hospital
						from doctor d
                        where d.especialidad = "Cardiologia");

-- 7. Visualizar el salario anual de los empleados de la plantilla del Hospital Provincial y General. (Realizar con subconsulta)
select e.apellido, (e.salario*12) as "Salario Anual"
from empleado e
join plantilla p
on e.id_empleado= p.id_empleado
where p.id_hospital in (Select id_hospital 
						from hospital
                        where nombre ="Provincial" or nombre="General")
group by e.apellido;

-- 8. Realizar el ejercicio anterior pero sin subconsultas
Select e.apellido, (e.salario*12) as "Salario Anual"
from empleado e 
join plantilla p
on e.id_empleado = p.id_empleado
join hospital h
on p.id_hospital = h.id_hospital 
where h.nombre ="provincial" or h.nombre= "general"
group by e.apellido;
-- 9. Mostrar el apellido de los pacientes que nacieron antes que el Señor Miller.
Select e.apellido
from enfermo e
where e.fecha_nac < (Select p.fecha_nac
					from enfermo p
                    where p.apellido like "%Miller%")
group by e.id_enfermo;
# ------------------------ GUIA N° HOSPITAL . -- -- STORE PROCEDURES -----------------------------------

-- 1 - Sacar todos los empleados que se dieron de alta entre una determinada fecha inicial y fecha final y que pertenecen a un determinado departamento.
-- 2 - Crear procedimiento que nos devuelva salario, oficio y comisión, pasándole el apellido.
-- 3 - Crear un procedimiento para mostrar el salario, oficio, apellido y nombre del departamento de todos los empleados que contengan en su apellido el valor que le pasemos como parámetro.
-- 4 - Crear un procedimiento que recupere el número departamento, el nombre y número de empleados, dándole como valor el nombre del departamento, 
--     si el nombre introducido no es válido, mostraremos un mensaje informativo comunicándolo.

/*SP 1*/
DELIMITER $$
Create procedure mostrarEmpleXFechaDeUnDepto (in fechaIni datetime, fechaFin datetime, id_deptoPed int)
Begin
	select *
	From empleado e
    where e.fecha_alta
    between fechaIni and fechaFin
    And e.id_departamento = id_deptoPed;
end
$$

call mostrarEmpleXFechaDeUnDepto( '1980-12-17 00:00:00','1992-12-17 00:00:00',2);

/*SP 2*/

Delimiter $$
create procedure devolverDatosPorApellido (IN apellidoPas varchar (100))
Begin
	select e.apellido, e.salario, e.oficio, e.comision
    from empleado e
    where e.apellido=apellidoPas;
end
$$

call devolverDatosPorApellido("Sala");
/*SP 3*/
/*SP 4*/
