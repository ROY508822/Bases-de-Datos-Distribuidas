CREATE DATABASE BDCOV19_DATAGRIP;

USE BDCOV19_DATAGRIP;

CREATE TABLE Estado (
    ID_Estado INT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Poblacion INT
);

CREATE TABLE Indicador (
    ID_Indicador INT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Descripcion VARCHAR(50) NOT NULL
);

CREATE TABLE Municipio (
    ID_Municipio INT PRIMARY KEY,
    Nombre VARCHAR(50),
    Poblacion INT,
    ID_Estado INT NOT NULL,
    FOREIGN KEY (ID_Estado) REFERENCES Estado(ID_Estado)
);

CREATE TABLE MunicipioIndicador (
    ID_MunicipioIndicador INT PRIMARY KEY,
    Fecha DATE NOT NULL,
    Valor DECIMAL(10,2) NOT NULL,
    ID_Municipio INT NOT NULL,
    ID_Indicador INT NOT NULL,
    FOREIGN KEY (ID_Municipio) REFERENCES Municipio(ID_Municipio),
    FOREIGN KEY (ID_Indicador) REFERENCES Indicador(ID_Indicador)
);

-- =========================
-- ESTADO
-- =========================
INSERT INTO Estado VALUES
(1, 'Jalisco', 8348151),
(2, 'CDMX', 9209944),
(3, 'Nuevo León', 5784442),
(4, 'Puebla', 6583278);

-- =========================
-- INDICADOR
-- =========================
INSERT INTO Indicador VALUES
(1, 'Casos Confirmados', 'Total de casos'),
(2, 'Defunciones', 'Total de muertes'),
(3, 'Recuperados', 'Total de recuperados');

-- =========================
-- MUNICIPIO
-- =========================
INSERT INTO Municipio VALUES
(1, 'Guadalajara', 1495182, 1),
(2, 'Zapopan', 1476491, 1),
(3, 'Monterrey', 1142994, 3),
(4, 'Puebla', 1576259, 4),
(5, 'Coyoacán', 620416, 2);

-- =========================
-- MUNICIPIO_INDICADOR
-- =========================
INSERT INTO MunicipioIndicador VALUES
-- Guadalajara
(1,  '2025-01-01', 1200, 1, 1),
(2,  '2025-01-01', 35,   1, 2),
(3,  '2025-01-01', 800,  1, 3),
(4,  '2025-02-01', 1400, 1, 1),
(5,  '2025-02-01', 40,   1, 2),
(6,  '2025-02-01', 1000, 1, 3),

-- Zapopan
(7,  '2025-01-01', 900,  2, 1),
(8,  '2025-01-01', 20,   2, 2),
(9,  '2025-01-01', 700,  2, 3),
(10, '2025-02-01', 1100, 2, 1),
(11, '2025-02-01', 25,   2, 2),
(12, '2025-02-01', 850,  2, 3),

-- Monterrey
(13, '2025-01-01', 1000, 3, 1),
(14, '2025-01-01', 30,   3, 2),
(15, '2025-01-01', 750,  3, 3),
(16, '2025-02-01', 1300, 3, 1),
(17, '2025-02-01', 45,   3, 2),
(18, '2025-02-01', 900,  3, 3),

-- Puebla
(19, '2025-01-01', 950,  4, 1),
(20, '2025-01-01', 28,   4, 2),
(21, '2025-01-01', 720,  4, 3),
(22, '2025-02-01', 1200, 4, 1),
(23, '2025-02-01', 38,   4, 2),
(24, '2025-02-01', 880,  4, 3),

-- Coyoacán
(25, '2025-01-01', 700,  5, 1),
(26, '2025-01-01', 18,   5, 2),
(27, '2025-01-01', 600,  5, 3),
(28, '2025-02-01', 900,  5, 1),
(29, '2025-02-01', 22,   5, 2),
(30, '2025-02-01', 750,  5, 3);
