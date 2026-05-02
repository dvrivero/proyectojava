-- ============================================================
-- SISTEMA DE COMPRAS DE COMIDA RÁPIDA
-- Base de Datos MySQL - Compatible con phpMyAdmin
-- Unidades Tecnológicas de Santander
-- Estudiantes: Valery Ramos Daza | Danna Rivero Blanco
-- ============================================================

CREATE DATABASE IF NOT EXISTS comida_rapida
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_spanish_ci;

USE comida_rapida;

-- ------------------------------------------------------------
-- TABLA: Usuario
-- ------------------------------------------------------------
CREATE TABLE Usuario (
    NombreUsuario   VARCHAR(100) NOT NULL,
    Direccion       VARCHAR(200),
    Telefono        VARCHAR(20),
    id              INT AUTO_INCREMENT UNIQUE,
    PRIMARY KEY (NombreUsuario)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- TABLA: Salsas
-- ------------------------------------------------------------
CREATE TABLE Salsas (
    idSalsa     INT AUTO_INCREMENT PRIMARY KEY,
    Mayonesa    BOOLEAN DEFAULT FALSE,
    Ketchup     BOOLEAN DEFAULT FALSE,
    Tratara     BOOLEAN DEFAULT FALSE,
    Piña        BOOLEAN DEFAULT FALSE,
    BBQ         BOOLEAN DEFAULT FALSE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- TABLA: Adicionales
-- ------------------------------------------------------------
CREATE TABLE Adicionales (
    idAdicional     INT AUTO_INCREMENT PRIMARY KEY,
    Queso           BOOLEAN DEFAULT FALSE,
    Chorizo         BOOLEAN DEFAULT FALSE,
    Tocineta        BOOLEAN DEFAULT FALSE,
    PapasFrancesas  BOOLEAN DEFAULT FALSE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- TABLA: Hamburguesa
-- ------------------------------------------------------------
CREATE TABLE Hamburguesa (
    idHamburguesa   INT AUTO_INCREMENT PRIMARY KEY,
    lechuga         BOOLEAN DEFAULT TRUE,
    tomate          BOOLEAN DEFAULT TRUE,
    pan             BOOLEAN DEFAULT TRUE,
    carne           BOOLEAN DEFAULT TRUE,
    idSalsa         INT,
    idAdicional     INT,
    CONSTRAINT fk_hamb_salsa    FOREIGN KEY (idSalsa)     REFERENCES Salsas(idSalsa),
    CONSTRAINT fk_hamb_adic     FOREIGN KEY (idAdicional) REFERENCES Adicionales(idAdicional)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- TABLA: Perro_Caliente
-- ------------------------------------------------------------
CREATE TABLE Perro_Caliente (
    idPerro         INT AUTO_INCREMENT PRIMARY KEY,
    Salchicha       BOOLEAN DEFAULT TRUE,
    Pan_Perro       BOOLEAN DEFAULT TRUE,
    idSalsa         INT,
    idAdicional     INT,
    CONSTRAINT fk_perro_salsa   FOREIGN KEY (idSalsa)     REFERENCES Salsas(idSalsa),
    CONSTRAINT fk_perro_adic    FOREIGN KEY (idAdicional) REFERENCES Adicionales(idAdicional)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- TABLA: Salchipapa
-- ------------------------------------------------------------
CREATE TABLE Salchipapa (
    idSalchipapa    INT AUTO_INCREMENT PRIMARY KEY,
    Tamaño          ENUM('Pequeño', 'Mediano', 'Grande') DEFAULT 'Mediano',
    idSalsa         INT,
    idAdicional     INT,
    CONSTRAINT fk_salchi_salsa  FOREIGN KEY (idSalsa)     REFERENCES Salsas(idSalsa),
    CONSTRAINT fk_salchi_adic   FOREIGN KEY (idAdicional) REFERENCES Adicionales(idAdicional)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- TABLA: Menu
-- ------------------------------------------------------------
CREATE TABLE Menu (
    IdSeleccion     INT AUTO_INCREMENT PRIMARY KEY,
    idhamburguesa   INT,
    idPerro         INT,
    idSalchipapa    INT,
    CONSTRAINT fk_menu_hamb     FOREIGN KEY (idhamburguesa) REFERENCES Hamburguesa(idHamburguesa),
    CONSTRAINT fk_menu_perro    FOREIGN KEY (idPerro)       REFERENCES Perro_Caliente(idPerro),
    CONSTRAINT fk_menu_salchi   FOREIGN KEY (idSalchipapa)  REFERENCES Salchipapa(idSalchipapa)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- TABLA: Pedidos
-- ------------------------------------------------------------
CREATE TABLE Pedidos (
    idPedido        INT AUTO_INCREMENT PRIMARY KEY,
    Descripcion     VARCHAR(300),
    Fecha           DATETIME DEFAULT CURRENT_TIMESTAMP,
    Estado          ENUM('Pendiente', 'Confirmado', 'Cancelado') DEFAULT 'Pendiente',
    idSeleccion     INT,
    NombreUsuario   VARCHAR(100),
    CONSTRAINT fk_ped_menu      FOREIGN KEY (idSeleccion)   REFERENCES Menu(IdSeleccion),
    CONSTRAINT fk_ped_usuario   FOREIGN KEY (NombreUsuario) REFERENCES Usuario(NombreUsuario)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- TABLA: Facturacion
-- ------------------------------------------------------------
CREATE TABLE Facturacion (
    idFactura       INT AUTO_INCREMENT PRIMARY KEY,
    SubTotal        DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    Descuento       DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    Total           DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    NombreUsuario   VARCHAR(100),
    IdPedido        INT,
    CONSTRAINT fk_fact_usuario  FOREIGN KEY (NombreUsuario) REFERENCES Usuario(NombreUsuario),
    CONSTRAINT fk_fact_pedido   FOREIGN KEY (IdPedido)      REFERENCES Pedidos(idPedido)
) ENGINE=InnoDB;

-- ============================================================
-- DATOS DE PRUEBA
-- ============================================================

INSERT INTO Usuario (NombreUsuario, Direccion, Telefono) VALUES
('Valery Ramos',  'Calle 10 #5-20, Bucaramanga', '3001234567'),
('Danna Rivero',  'Carrera 15 #8-45, Bucaramanga', '3109876543'),
('Carlos Perez',  'Av. Los Estudiantes #3-10', '3201112233');

INSERT INTO Salsas (Mayonesa, Ketchup, Tratara, Piña, BBQ) VALUES
(TRUE,  TRUE,  FALSE, FALSE, FALSE),
(TRUE,  FALSE, TRUE,  FALSE, FALSE),
(FALSE, TRUE,  FALSE, FALSE, TRUE),
(TRUE,  TRUE,  FALSE, TRUE,  FALSE);

INSERT INTO Adicionales (Queso, Chorizo, Tocineta, PapasFrancesas) VALUES
(TRUE,  FALSE, TRUE,  FALSE),
(FALSE, TRUE,  FALSE, TRUE),
(TRUE,  TRUE,  FALSE, FALSE),
(FALSE, FALSE, FALSE, TRUE);

INSERT INTO Hamburguesa (lechuga, tomate, pan, carne, idSalsa, idAdicional) VALUES
(TRUE,  TRUE,  TRUE, TRUE, 1, 1),
(FALSE, TRUE,  TRUE, TRUE, 2, 2),
(TRUE,  FALSE, TRUE, TRUE, 3, 3);

INSERT INTO Perro_Caliente (Salchicha, Pan_Perro, idSalsa, idAdicional) VALUES
(TRUE, TRUE, 1, 2),
(TRUE, TRUE, 4, 4);

INSERT INTO Salchipapa (Tamaño, idSalsa, idAdicional) VALUES
('Grande',  2, 1),
('Mediano', 1, 3),
('Pequeño', 3, 4);

INSERT INTO Menu (idhamburguesa, idPerro, idSalchipapa) VALUES
(1, NULL, NULL),
(2, NULL, NULL),
(NULL, 1, NULL),
(NULL, NULL, 1),
(NULL, NULL, 2);

INSERT INTO Pedidos (Descripcion, Estado, idSeleccion, NombreUsuario) VALUES
('Hamburguesa con lechuga, tomate y tocineta',  'Confirmado', 1, 'Valery Ramos'),
('Hamburguesa sin lechuga con chorizo',         'Pendiente',  2, 'Danna Rivero'),
('Perro caliente con mayonesa y ketchup',       'Confirmado', 3, 'Valery Ramos'),
('Salchipapa grande con mayo y queso',          'Confirmado', 4, 'Carlos Perez'),
('Salchipapa mediana',                          'Pendiente',  5, 'Danna Rivero');

INSERT INTO Facturacion (SubTotal, Descuento, Total, NombreUsuario, IdPedido) VALUES
(15000.00, 0.00,    15000.00, 'Valery Ramos', 1),
(14000.00, 500.00,  13500.00, 'Danna Rivero', 2),
(10000.00, 0.00,    10000.00, 'Valery Ramos', 3),
(12000.00, 0.00,    12000.00, 'Carlos Perez', 4),
(8000.00,  1000.00, 7000.00,  'Danna Rivero', 5);

-- ============================================================
-- CONSULTA DE VERIFICACIÓN
-- ============================================================

SELECT 
    p.idPedido,
    p.NombreUsuario,
    p.Descripcion,
    p.Estado,
    p.Fecha,
    f.SubTotal,
    f.Descuento,
    f.Total
FROM Pedidos p
JOIN Facturacion f ON f.IdPedido = p.idPedido;
