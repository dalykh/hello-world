-- tenant_template_schema.sql
-- Replace {{schema_name}} with actual schema name before execution.

CREATE TABLE {{schema_name}}.users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cognito_user_id VARCHAR(255) NOT NULL UNIQUE,
    tenant_id UUID NOT NULL REFERENCES public.tenants(id) ON DELETE CASCADE,
    email VARCHAR(255) NOT NULL UNIQUE,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    role VARCHAR(50) NOT NULL, -- 'driver', 'manager'
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    driver_license_number VARCHAR(100),
    phone_number VARCHAR(50)
);
CREATE INDEX idx_users_cognito_id ON {{schema_name}}.users(cognito_user_id);
CREATE INDEX idx_users_tenant_id ON {{schema_name}}.users(tenant_id);

CREATE TABLE {{schema_name}}.vehicles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES public.tenants(id) ON DELETE CASCADE,
    make VARCHAR(100),
    model VARCHAR(100),
    license_plate VARCHAR(50) UNIQUE,
    year INT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_vehicles_tenant_id ON {{schema_name}}.vehicles(tenant_id);

CREATE TABLE {{schema_name}}.rides (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES {{schema_name}}.users(id),
    vehicle_id UUID REFERENCES {{schema_name}}.vehicles(id),
    tenant_id UUID NOT NULL REFERENCES public.tenants(id) ON DELETE CASCADE,
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ NOT NULL,
    start_address TEXT,
    end_address TEXT,
    client_name VARCHAR(255),
    amount NUMERIC(10, 2) NOT NULL,
    payment_method VARCHAR(50),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    local_id VARCHAR(255) UNIQUE,
    synced_at TIMESTAMPTZ
);
CREATE INDEX idx_rides_user_id ON {{schema_name}}.rides(user_id);
CREATE INDEX idx_rides_tenant_id ON {{schema_name}}.rides(tenant_id);
CREATE INDEX idx_rides_start_time ON {{schema_name}}.rides(start_time);

CREATE TABLE {{schema_name}}.expenses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES {{schema_name}}.users(id),
    ride_id UUID REFERENCES {{schema_name}}.rides(id),
    tenant_id UUID NOT NULL REFERENCES public.tenants(id) ON DELETE CASCADE,
    expense_date DATE NOT NULL,
    type VARCHAR(100) NOT NULL,
    amount NUMERIC(10, 2) NOT NULL,
    vat_amount NUMERIC(10, 2) DEFAULT 0.00,
    photo_url VARCHAR(1024),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    local_id VARCHAR(255) UNIQUE,
    synced_at TIMESTAMPTZ
);
CREATE INDEX idx_expenses_user_id ON {{schema_name}}.expenses(user_id);
CREATE INDEX idx_expenses_tenant_id ON {{schema_name}}.expenses(tenant_id);
CREATE INDEX idx_expenses_expense_date ON {{schema_name}}.expenses(expense_date);

CREATE OR REPLACE FUNCTION {{schema_name}}.trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_timestamp_users BEFORE UPDATE ON {{schema_name}}.users FOR EACH ROW EXECUTE PROCEDURE {{schema_name}}.trigger_set_timestamp();
CREATE TRIGGER set_timestamp_vehicles BEFORE UPDATE ON {{schema_name}}.vehicles FOR EACH ROW EXECUTE PROCEDURE {{schema_name}}.trigger_set_timestamp();
CREATE TRIGGER set_timestamp_rides BEFORE UPDATE ON {{schema_name}}.rides FOR EACH ROW EXECUTE PROCEDURE {{schema_name}}.trigger_set_timestamp();
CREATE TRIGGER set_timestamp_expenses BEFORE UPDATE ON {{schema_name}}.expenses FOR EACH ROW EXECUTE PROCEDURE {{schema_name}}.trigger_set_timestamp();
