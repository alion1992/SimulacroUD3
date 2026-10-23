-- Crear el esquema
CREATE SCHEMA IF NOT EXISTS simulacro;


-- Tabla: clientes
CREATE TABLE simulacro.clientes (
    id_cliente INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(150) NOT NULL,
    email VARCHAR(150),
    telefono VARCHAR(15),
    direccion VARCHAR(200),
    ciudad VARCHAR(100),
    fecha_alta DATE NOT NULL DEFAULT CURRENT_DATE
);


-- Tabla: tipos_documento
CREATE TABLE simulacro.tipos_documento (
    id_tipo_documento INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL UNIQUE,
    descripcion VARCHAR(150)
);


-- Tabla: documentacion
CREATE TABLE simulacro.documentacion (
    id_documentacion INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_cliente INTEGER NOT NULL
        REFERENCES simulacro.clientes(id_cliente),
    id_tipo_documento INTEGER NOT NULL
        REFERENCES simulacro.tipos_documento(id_tipo_documento),
    numero_documento VARCHAR(30) NOT NULL UNIQUE,
    fecha_emision DATE,
    fecha_caducidad DATE
);


-- Tabla: suministros
CREATE TABLE simulacro.suministros (
    id_suministro INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL UNIQUE,
    descripcion VARCHAR(200)
);


-- Tabla: contratos
CREATE TABLE simulacro.contratos (
    id_contrato INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_cliente INTEGER NOT NULL
        REFERENCES simulacro.clientes(id_cliente),
    id_suministro INTEGER NOT NULL
        REFERENCES simulacro.suministros(id_suministro),
    fecha_inicio DATE NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    UNIQUE (id_cliente, id_suministro)
);


-- Tabla: consumos
CREATE TABLE simulacro.consumos (
    id_consumo INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_contrato INTEGER NOT NULL
        REFERENCES simulacro.contratos(id_contrato),
    anio INTEGER NOT NULL CHECK (anio BETWEEN 2024 AND 2026),
    mes INTEGER NOT NULL CHECK (mes BETWEEN 1 AND 12),
    importe NUMERIC(10,2) NOT NULL CHECK (importe >= 0),
    UNIQUE (id_contrato, anio, mes)
);