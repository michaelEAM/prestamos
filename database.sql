-- Base de datos para Control de Préstamos
-- Ejecutar esto en phpMyAdmin o MySQL

CREATE DATABASE IF NOT EXISTS prestamos CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE prestamos;

-- Tabla de préstamos
CREATE TABLE IF NOT EXISTS prestamos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    cedula VARCHAR(20) NOT NULL,
    fecha_prestamo DATE NOT NULL,
    monto DECIMAL(12,2) NOT NULL,
    cuotas INT NOT NULL,
    valor_cuota DECIMAL(12,2) NOT NULL,
    motivo VARCHAR(255) NOT NULL,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla de abonos/pagos
CREATE TABLE IF NOT EXISTS abonos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    prestamo_id INT NOT NULL,
    fecha_abono DATE NOT NULL,
    cantidad_cuotas INT NOT NULL,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (prestamo_id) REFERENCES prestamos(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

