-- Script SQL para PostgreSQL

-- Creación de la base de datos
CREATE DATABASE miapp;

-- NOTA: Conectar a 'miapp' antes de ejecutar el resto del script.

-- Creación de la tabla de alumnos
CREATE TABLE IF NOT EXISTS alumnos (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  email VARCHAR(50) NOT NULL
);

-- Inserción inicial de alumnos
INSERT INTO alumnos (nombre, email) VALUES
('Ana López', 'ana@example.com'),
('Luis García', 'luis@example.com'),
('Marta Ruiz', 'marta@example.com');

-- Inserción de alumnos adicionales
INSERT INTO alumnos (nombre, email) VALUES
('Pedro Jiménez', 'pedro.jimenez@example.com'),
('Sofía Torres', 'sofia.torres@example.com'),
('Javier Blanco', 'javier.b@example.com'),
('Elena Sanz', 'elena.sanz@example.com'),
('Carlos Vidal', 'carlosv@example.com'),
('Laura Prieto', 'laura.prieto@example.com'),
('Miguel Ferrer', 'miguel.ferrer@example.com');

