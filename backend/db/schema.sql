-- backend/db/schema.sql

CREATE TABLE IF NOT EXISTS rfp (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT,
  structured JSONB,
  total_budget NUMERIC,
  delivery_days INTEGER,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE TABLE IF NOT EXISTS rfp_line_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  rfp_id UUID REFERENCES rfp(id) ON DELETE CASCADE,
  item_name TEXT,
  qty INTEGER,
  specs JSONB
);

CREATE TABLE IF NOT EXISTS vendor (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  email TEXT,
  contact TEXT,
  phone TEXT,
  notes TEXT
);

CREATE TABLE IF NOT EXISTS sent_rfp (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  rfp_id UUID REFERENCES rfp(id) ON DELETE CASCADE,
  vendor_id UUID REFERENCES vendor(id) ON DELETE SET NULL,
  sent_at TIMESTAMP WITH TIME ZONE,
  email_message_id TEXT,
  body TEXT
);

CREATE TABLE IF NOT EXISTS proposal (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  rfp_id UUID REFERENCES rfp(id) ON DELETE CASCADE,
  vendor_id UUID REFERENCES vendor(id) ON DELETE SET NULL,
  received_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  raw_body TEXT,
  parsed JSONB,
  score DOUBLE PRECISION,
  notes TEXT
);
