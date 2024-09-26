-- Insertar datos en la tabla alumno
INSERT INTO alumno (nombre, apellidos, email, telefono, nif) VALUES
('Gonzalo', 'Cáceres', 'gonza.cac@example.com', '123456789', '12345678A'),
('Fernando', 'Beneytez', 'fernando@example.com', '987654321', '87654321B'),
('Luis', 'Martínez', 'luis.martinez@example.com', '456789123', '23456789C'),
('Paola', 'León', 'pao.leon@example.com', '321654987', '34567890D'),
('Pablo', 'Aguinaga', 'pablo.agi@example.com', '654321789', '45678901E');

-- Insertar datos en la tabla bootcamp
INSERT INTO bootcamp (nombre, descripcion, duracion, precio) VALUES
('Bootcamp de Desarrollo Web', 'Aprende a crear aplicaciones web desde cero.', 12, 3000.00),
('Bootcamp de Data Science', 'Conviértete en un experto en análisis de datos.', 16, 4000.00),
('Bootcamp de Ciberseguridad', 'Protege sistemas y redes de amenazas.', 10, 3500.00),
('Bootcamp de Inteligencia Artificial', 'Aprende a crear tus propios modelos de IA.', 16, 4500.00);

-- Insertar datos en la tabla modulo
INSERT INTO modulo (nombre, descripcion, duracion) VALUES
('HTML y CSS', 'Fundamentos del diseño web con HTML y CSS.', 2),
('JavaScript Básico', 'Introducción a la programación con JavaScript.', 3),
('Python para Data Science', 'Aprende Python aplicado a la ciencia de datos.', 4),
('Seguridad Informática', 'Conceptos básicos de seguridad en informática.', 3),
('SQL Avanzado, ETL y Datawarehouse', 'Diseño, manipulación y construcción de bases de datos relacionales.', 4),
('Despliegue de algoritmos', 'Llevar modelos de Machine Learning desde el desarrollo hasta la producción.', 3),
('Prompt Engineering Avanzado', 'Diseñar prompts que mejoren la interacción con IA.', 2);

-- Insertar datos en la tabla profesor
INSERT INTO profesor (nombre, apellidos, email, especialidad) VALUES
('Pedro', 'Sánchez', 'pedro.sanchez@example.com', 'Desarrollo Web'),
('Raquel', 'Orallo', 'raquel.o@example.com', 'Python'),
('Alejandro', 'López', 'alejo.lopez@example.com', 'SQL_DWH'),
('Elena', 'Molina', 'elena.molina@example.com', 'Seguridad Digital'),
('Ana', 'García', 'ana.gar@example.com', 'Prompt Engineer');

-- Insertar datos en la tabla inscripcion
INSERT INTO inscripcion (id_alumno, id_bootcamp, fecha_inscripcion) VALUES
(1, 4, CURRENT_DATE),
(2, 2, CURRENT_DATE),
(3, 1, CURRENT_DATE),
(4, 2, CURRENT_DATE),
(5, 4, CURRENT_DATE);

-- Insertar datos en la tabla bootcamp_modulo
INSERT INTO bootcamp_modulo (id_bootcamp, id_modulo, orden) VALUES
(1, 1, 1),
(1, 2, 2),
(2, 3, 1),
(3, 4, 1),
(4, 5, 1);

-- Insertar datos en la tabla modulo_profesor
INSERT INTO modulo_profesor (id_modulo, id_profesor) VALUES
(1, 1), -- HTML y CSS - Pedro Sánchez
(3, 2), -- Python para Data Science - Raquel Orallo
(4, 4), -- Seguridad Informática - Elena Molina
(5, 3), -- SQL Avanzado, ETL y Datawarehouse - Alejandro López
(7, 5); -- Prompt Engineering Avanzado - Ana García

