-- ============================================================
-- SQL para Supabase (PostgreSQL)
-- Copia y pega esto en el Editor SQL de tu proyecto Supabase
-- ============================================================

-- 1. Crear tabla de préstamos
CREATE TABLE IF NOT EXISTS prestamos (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  nombre TEXT NOT NULL,
  cedula TEXT NOT NULL,
  fecha_prestamo DATE NOT NULL,
  monto NUMERIC(12,2) NOT NULL,
  cuotas INT NOT NULL,
  valor_cuota NUMERIC(12,2) NOT NULL,
  motivo TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Crear tabla de abonos
CREATE TABLE IF NOT EXISTS abonos (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  prestamo_id BIGINT REFERENCES prestamos(id) ON DELETE CASCADE NOT NULL,
  fecha_abono DATE NOT NULL,
  cantidad_cuotas INT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. Habilitar Row Level Security (RLS)
ALTER TABLE prestamos ENABLE ROW LEVEL SECURITY;
ALTER TABLE abonos ENABLE ROW LEVEL SECURITY;

-- 4. Crear políticas de acceso público (para desarrollo/pruebas)
-- ⚠️ En producción deberías usar autenticación de Supabase
CREATE POLICY "Allow all prestamos" ON prestamos
  FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Allow all abonos" ON abonos
  FOR ALL USING (true) WITH CHECK (true);

-- 5. Verificar que las tablas se crearon correctamente
SELECT * FROM prestamos LIMIT 1;
SELECT * FROM abonos LIMIT 1;

