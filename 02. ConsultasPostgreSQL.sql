--Listar todos los alumnos:
SELECT * FROM alumno;

--Mostrar los bootcamps ordenados por precio:
SELECT nombre, duracion, precio 
FROM bootcamp 
ORDER BY precio DESC;

--Contar cuántos alumnos hay inscritos en cada bootcamp:
SELECT b.nombre AS bootcamp, COUNT(i.id_alumno) AS num_alumnos
FROM bootcamp b
LEFT JOIN inscripcion i ON b.id_bootcamp = i.id_bootcamp
GROUP BY b.id_bootcamp, b.nombre;

--Listar los módulos y sus profesores:
SELECT m.nombre AS modulo, p.nombre || ' ' || p.apellidos AS profesor
FROM modulo m
JOIN modulo_profesor mp ON m.id_modulo = mp.id_modulo
JOIN profesor p ON mp.id_profesor = p.id_profesor;

--Listar alumnos y sus bootcamps:
SELECT a.nombre || ' ' || a.apellidos AS alumno, b.nombre AS bootcamp
FROM alumno a
JOIN inscripcion i ON a.id_alumno = i.id_alumno
JOIN bootcamp b ON i.id_bootcamp = b.id_bootcamp;

--Calcular el ingreso total por bootcamps:
SELECT b.nombre AS bootcamp, b.precio * COUNT(i.id_alumno) AS ingreso_total
FROM bootcamp b
LEFT JOIN inscripcion i ON b.id_bootcamp = i.id_bootcamp
GROUP BY b.id_bootcamp, b.nombre, b.precio;

