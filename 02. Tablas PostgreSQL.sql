DROP TABLE IF EXISTS alumno;
DROP TABLE IF EXISTS bootcamp;
DROP TABLE IF EXISTS modulo;
DROP TABLE IF EXISTS profesor;
DROP TABLE IF EXISTS inscripcion;
DROP TABLE IF EXISTS bootcamp_Modulo;
DROP TABLE IF EXISTS modulo_Profesor;

-- Crear tabla alumno
CREATE TABLE alumno (
    id_alumno SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    nif VARCHAR(15) UNIQUE NOT NULL
);

-- Crear tabla bootcamp
CREATE TABLE bootcamp (
    id_bootcamp SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    duracion INTEGER,
    precio DECIMAL(10, 2)
);

-- Crear tabla modulo
CREATE TABLE modulo (
    id_modulo SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    duracion INTEGER
);

-- Crear tabla profesor
CREATE TABLE profesor (
    id_profesor SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    especialidad VARCHAR(100)
);

-- Crear tabla intermedia inscripcion
CREATE TABLE inscripcion (
    id_inscripcion SERIAL PRIMARY KEY,
    id_alumno INTEGER REFERENCES alumno(id_alumno),
    id_bootcamp INTEGER REFERENCES bootcamp(id_bootcamp),
    fecha_inscripcion DATE NOT NULL,
    UNIQUE (id_alumno, id_bootcamp)
);

-- Crear tabla intermedia bootcamp_modulo
CREATE TABLE bootcamp_modulo (
    id_bootcamp_modulo SERIAL PRIMARY KEY,
    id_bootcamp INTEGER NOT NULL,
    id_modulo INTEGER NOT NULL,
    orden INTEGER NOT NULL,
    FOREIGN KEY (id_bootcamp) REFERENCES bootcamp(id_bootcamp),
    FOREIGN KEY (id_modulo) REFERENCES modulo(id_modulo),
    UNIQUE (id_bootcamp, id_modulo)
);


-- Crear tabla intermedia modulo_profesor
CREATE TABLE modulo_profesor (
    id_modulo_profesor SERIAL PRIMARY KEY,
    id_modulo INTEGER NOT NULL,
    id_profesor INTEGER NOT NULL,
    FOREIGN KEY (id_modulo) REFERENCES modulo(id_modulo),
    FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor),
    UNIQUE (id_modulo, id_profesor)
);