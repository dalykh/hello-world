-- public_schema.sql

-- Table pour stocker les informations sur les tenants (entreprises clientes)
CREATE TABLE public.tenants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    company_name VARCHAR(255) NOT NULL,
    schema_name VARCHAR(63) NOT NULL UNIQUE, -- Nom du schéma dédié au tenant (ex: tenant_abc)
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    stripe_customer_id VARCHAR(255) UNIQUE,
    stripe_subscription_id VARCHAR(255) UNIQUE,
    subscription_status VARCHAR(50)
);

CREATE INDEX idx_tenants_schema_name ON public.tenants(schema_name);
