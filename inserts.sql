
-- =====================================================
-- 1. TIPOS DE DOCUMENTO
-- =====================================================

INSERT INTO simulacro.tipos_documento
(nombre, descripcion)
VALUES
('DNI', 'Documento Nacional de Identidad'),
('NIE', 'Número de Identidad de Extranjero'),
('Pasaporte', 'Documento identificativo internacional');


-- =====================================================
-- 2. SUMINISTROS
-- =====================================================

INSERT INTO simulacro.suministros
(nombre, descripcion)
VALUES
('Luz', 'Suministro de energía eléctrica'),
('Gas', 'Suministro de gas natural'),
('Carburante', 'Combustible para calderas');


-- =====================================================
-- 3. CLIENTES
-- =====================================================

INSERT INTO simulacro.clientes
(nombre, apellidos, email, telefono, direccion, ciudad, fecha_alta)
VALUES
('Ana', 'García López', 'ana.garcia@example.com',
 '600100101', 'Calle Mayor 12', 'Puertollano', '2023-05-10'),

('Luis', 'Pérez Sánchez', 'luis.perez@example.com',
 '600100102', 'Avenida de Europa 25', 'Ciudad Real', '2023-08-15'),

('Marta', 'López Martín', 'marta.lopez@example.com',
 '600100103', 'Calle Toledo 8', 'Puertollano', '2024-01-20'),

('Carlos', 'Fernández Ruiz', 'carlos.fernandez@example.com',
 '600100104', 'Calle Ancha 31', 'Almodóvar del Campo', '2024-03-12'),

('Elena', 'Romero Díaz', 'elena.romero@example.com',
 '600100105', 'Avenida Primero de Mayo 17', 'Ciudad Real', '2024-06-01');


-- =====================================================
-- 4. DOCUMENTACION
-- Los números son ficticios para la práctica
-- =====================================================

INSERT INTO simulacro.documentacion
(id_cliente, id_tipo_documento, numero_documento,
 fecha_emision, fecha_caducidad)
VALUES
(1, 1, 'SIM-DNI-0001', '2020-01-10', '2030-01-10'),
(2, 1, 'SIM-DNI-0002', '2021-03-15', '2031-03-15'),
(3, 2, 'SIM-NIE-0003', '2022-06-20', '2027-06-20'),
(4, 1, 'SIM-DNI-0004', '2019-09-01', '2029-09-01'),
(5, 1, 'SIM-DNI-0005', '2023-02-10', '2033-02-10'),
(5, 3, 'SIM-PAS-0005', '2024-01-01', '2030-01-01');


-- =====================================================
-- 5. CONTRATOS
-- =====================================================

INSERT INTO simulacro.contratos
(id_cliente, id_suministro, fecha_inicio, activo)
VALUES
-- Ana: Luz y Gas
(1, 1, '2024-01-01', TRUE),
(1, 2, '2024-01-01', TRUE),

-- Luis: solo Carburante
(2, 3, '2024-02-01', TRUE),

-- Marta: Luz y Gas
(3, 1, '2024-01-01', TRUE),
(3, 2, '2024-03-01', TRUE),

-- Carlos: Luz y Carburante
(4, 1, '2024-04-01', TRUE),
(4, 3, '2024-04-01', TRUE),

-- Elena: Luz, Gas y Carburante
(5, 1, '2024-06-01', TRUE),
(5, 2, '2024-06-01', TRUE),
(5, 3, '2024-06-01', TRUE);


-- =====================================================
-- 6. CONSUMOS MENSUALES DE 2024 A 2026
-- =====================================================

INSERT INTO simulacro.consumos
(id_contrato, anio, mes, importe)
SELECT
    ct.id_contrato,
    EXTRACT(YEAR FROM fechas.fecha)::INTEGER AS anio,
    EXTRACT(MONTH FROM fechas.fecha)::INTEGER AS mes,

    ROUND((
        CASE s.nombre
            WHEN 'Luz' THEN 55.00
            WHEN 'Gas' THEN 35.00
            WHEN 'Carburante' THEN 90.00
        END
        + ct.id_cliente * 4.25
        + EXTRACT(MONTH FROM fechas.fecha) * 1.15
        + (EXTRACT(YEAR FROM fechas.fecha) - 2024) * 3.50
        + CASE
            WHEN s.nombre = 'Gas'
             AND EXTRACT(MONTH FROM fechas.fecha)
                 IN (1, 2, 11, 12)
            THEN 25.00
            ELSE 0.00
          END
    )::NUMERIC, 2) AS importe

FROM simulacro.contratos ct
JOIN simulacro.suministros s
    ON s.id_suministro = ct.id_suministro
CROSS JOIN generate_series(
    DATE '2024-01-01',
    DATE '2026-12-01',
    INTERVAL '1 month'
) AS fechas(fecha);


-- =====================================================
-- 7. COMPROBACIONES
-- =====================================================

SELECT COUNT(*) AS total_clientes
FROM simulacro.clientes;

SELECT COUNT(*) AS total_documentos
FROM simulacro.documentacion;

SELECT COUNT(*) AS total_contratos
FROM simulacro.contratos;

SELECT COUNT(*) AS total_consumos
FROM simulacro.consumos;

SELECT
    anio,
    COUNT(*) AS numero_consumos,
    SUM(importe) AS gasto_total
FROM simulacro.consumos
GROUP BY anio
ORDER BY anio;
