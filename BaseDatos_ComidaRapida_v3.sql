-- ============================================================
-- BASE DE DATOS: comida_rapida
-- Versión corregida para Spring Boot + Hibernate (snake_case)
-- ============================================================

DROP DATABASE IF EXISTS comida_rapida;
CREATE DATABASE comida_rapida CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE comida_rapida;

SET FOREIGN_KEY_CHECKS = 0;

-- ------------------------------------------------------------
-- TABLA: usuario
-- ------------------------------------------------------------
CREATE TABLE usuario (
    nombre_usuario  VARCHAR(100) NOT NULL,
    direccion       VARCHAR(200),
    telefono        VARCHAR(20),
    id              INT AUTO_INCREMENT UNIQUE,
    password        VARCHAR(255) NOT NULL DEFAULT '',
    rol             VARCHAR(50)  NOT NULL DEFAULT 'ROLE_USER',
    PRIMARY KEY (nombre_usuario)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- TABLA: salsas
-- ------------------------------------------------------------
CREATE TABLE salsas (
    id_salsa    INT AUTO_INCREMENT PRIMARY KEY,
    mayonesa    BOOLEAN DEFAULT FALSE,
    ketchup     BOOLEAN DEFAULT FALSE,
    tratara     BOOLEAN DEFAULT FALSE,
    pina        BOOLEAN DEFAULT FALSE,
    bbq         BOOLEAN DEFAULT FALSE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- TABLA: adicionales
-- ------------------------------------------------------------
CREATE TABLE adicionales (
    id_adicional        INT AUTO_INCREMENT PRIMARY KEY,
    queso               BOOLEAN DEFAULT FALSE,
    chorizo             BOOLEAN DEFAULT FALSE,
    tocineta            BOOLEAN DEFAULT FALSE,
    papas_francesas     BOOLEAN DEFAULT FALSE
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- TABLA: hamburguesa
-- ------------------------------------------------------------
CREATE TABLE hamburguesa (
    id_hamburguesa  INT AUTO_INCREMENT PRIMARY KEY,
    lechuga         BOOLEAN DEFAULT TRUE,
    tomate          BOOLEAN DEFAULT TRUE,
    pan             BOOLEAN DEFAULT TRUE,
    carne           BOOLEAN DEFAULT TRUE,
    id_salsa        INT,
    id_adicional    INT,
    CONSTRAINT fk_hamb_salsa  FOREIGN KEY (id_salsa)     REFERENCES salsas(id_salsa),
    CONSTRAINT fk_hamb_adic   FOREIGN KEY (id_adicional) REFERENCES adicionales(id_adicional)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- TABLA: perro_caliente
-- ------------------------------------------------------------
CREATE TABLE perro_caliente (
    id_perro        INT AUTO_INCREMENT PRIMARY KEY,
    salchicha       BOOLEAN DEFAULT TRUE,
    pan_perro       BOOLEAN DEFAULT TRUE,
    id_salsa        INT,
    id_adicional    INT,
    CONSTRAINT fk_perro_salsa FOREIGN KEY (id_salsa)     REFERENCES salsas(id_salsa),
    CONSTRAINT fk_perro_adic  FOREIGN KEY (id_adicional) REFERENCES adicionales(id_adicional)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- TABLA: salchipapa
-- ------------------------------------------------------------
CREATE TABLE salchipapa (
    id_salchipapa   INT AUTO_INCREMENT PRIMARY KEY,
    tamano          ENUM('Pequeno', 'Mediano', 'Grande') DEFAULT 'Mediano',
    id_salsa        INT,
    id_adicional    INT,
    CONSTRAINT fk_salchi_salsa FOREIGN KEY (id_salsa)     REFERENCES salsas(id_salsa),
    CONSTRAINT fk_salchi_adic  FOREIGN KEY (id_adicional) REFERENCES adicionales(id_adicional)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- TABLA: menu
-- ------------------------------------------------------------
CREATE TABLE menu (
    id_seleccion    INT AUTO_INCREMENT PRIMARY KEY,
    id_hamburguesa  INT,
    id_perro        INT,
    id_salchipapa   INT,
    CONSTRAINT fk_menu_hamb   FOREIGN KEY (id_hamburguesa) REFERENCES hamburguesa(id_hamburguesa),
    CONSTRAINT fk_menu_perro  FOREIGN KEY (id_perro)       REFERENCES perro_caliente(id_perro),
    CONSTRAINT fk_menu_salchi FOREIGN KEY (id_salchipapa)  REFERENCES salchipapa(id_salchipapa)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- TABLA: pedidos
-- ------------------------------------------------------------
CREATE TABLE pedidos (
    id_pedido       INT AUTO_INCREMENT PRIMARY KEY,
    descripcion     VARCHAR(300),
    fecha           DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado          ENUM('Pendiente', 'Confirmado', 'Cancelado') DEFAULT 'Pendiente',
    id_seleccion    INT,
    nombre_usuario  VARCHAR(100),
    CONSTRAINT fk_ped_menu     FOREIGN KEY (id_seleccion)  REFERENCES menu(id_seleccion),
    CONSTRAINT fk_ped_usuario  FOREIGN KEY (nombre_usuario) REFERENCES usuario(nombre_usuario)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- TABLA: facturacion
-- ------------------------------------------------------------
CREATE TABLE facturacion (
    id_factura      INT AUTO_INCREMENT PRIMARY KEY,
    sub_total       DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    descuento       DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    total           DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    nombre_usuario  VARCHAR(100),
    id_pedido       INT,
    CONSTRAINT fk_fact_usuario FOREIGN KEY (nombre_usuario) REFERENCES usuario(nombre_usuario),
    CONSTRAINT fk_fact_pedido  FOREIGN KEY (id_pedido)      REFERENCES pedidos(id_pedido)
) ENGINE=InnoDB;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- DATOS DE PRUEBA
-- ============================================================

INSERT INTO usuario (nombre_usuario, direccion, telefono) VALUES
('Valery Ramos', 'Calle 10 #5-20, Bucaramanga',   '3001234567'),
('Danna Rivero', 'Carrera 15 #8-45, Bucaramanga', '3109876543'),
('Carlos Perez', 'Av. Los Estudiantes #3-10',      '3201112233');

INSERT INTO salsas (mayonesa, ketchup, tratara, pina, bbq) VALUES
(TRUE,  TRUE,  FALSE, FALSE, FALSE),
(TRUE,  FALSE, TRUE,  FALSE, FALSE),
(FALSE, TRUE,  FALSE, FALSE, TRUE),
(TRUE,  TRUE,  FALSE, TRUE,  FALSE);

INSERT INTO adicionales (queso, chorizo, tocineta, papas_francesas) VALUES
(TRUE,  FALSE, TRUE,  FALSE),
(FALSE, TRUE,  FALSE, TRUE),
(TRUE,  TRUE,  FALSE, FALSE),
(FALSE, FALSE, FALSE, TRUE);

INSERT INTO hamburguesa (lechuga, tomate, pan, carne, id_salsa, id_adicional) VALUES
(TRUE,  TRUE,  TRUE, TRUE, 1, 1),
(FALSE, TRUE,  TRUE, TRUE, 2, 2),
(TRUE,  FALSE, TRUE, TRUE, 3, 3);

INSERT INTO perro_caliente (salchicha, pan_perro, id_salsa, id_adicional) VALUES
(TRUE, TRUE, 1, 2),
(TRUE, TRUE, 4, 4);

INSERT INTO salchipapa (tamano, id_salsa, id_adicional) VALUES
('Grande',  2, 1),
('Mediano', 1, 3),
('Pequeno', 3, 4);

INSERT INTO menu (id_hamburguesa, id_perro, id_salchipapa) VALUES
(1, NULL, NULL),
(2, NULL, NULL),
(NULL, 1, NULL),
(NULL, NULL, 1),
(NULL, NULL, 2);

INSERT INTO pedidos (descripcion, estado, id_seleccion, nombre_usuario) VALUES
('Hamburguesa con lechuga, tomate y tocineta', 'Confirmado', 1, 'Valery Ramos'),
('Hamburguesa sin lechuga con chorizo',        'Pendiente',  2, 'Danna Rivero'),
('Perro caliente con mayonesa y ketchup',      'Confirmado', 3, 'Valery Ramos'),
('Salchipapa grande con mayo y queso',         'Confirmado', 4, 'Carlos Perez'),
('Salchipapa mediana',                         'Pendiente',  5, 'Danna Rivero');

INSERT INTO facturacion (sub_total, descuento, total, nombre_usuario, id_pedido) VALUES
(15000.00, 0.00,    15000.00, 'Valery Ramos', 1),
(14000.00, 500.00,  13500.00, 'Danna Rivero', 2),
(10000.00, 0.00,    10000.00, 'Valery Ramos', 3),
(12000.00, 0.00,    12000.00, 'Carlos Perez', 4),
(8000.00,  1000.00, 7000.00,  'Danna Rivero', 5);

-- ============================================================
-- CONSULTA DE VERIFICACIÓN
-- ============================================================
SELECT
    p.id_pedido,
    p.nombre_usuario,
    p.descripcion,
    p.estado,
    p.fecha,
    f.sub_total,
    f.descuento,
    f.total
FROM pedidos p
JOIN facturacion f ON f.id_pedido = p.id_pedido;
