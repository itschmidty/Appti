-- Users table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT true,
    last_login TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Businesses table
CREATE TABLE businesses (
    business_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Locations table
CREATE TABLE locations (
    location_id SERIAL PRIMARY KEY,
    business_id INTEGER REFERENCES businesses(business_id),
    name VARCHAR(100) NOT NULL,
    address TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Roles table
CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,
    business_id INTEGER REFERENCES businesses(business_id),
    name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (business_id, name)
);

-- Business Users table
CREATE TABLE business_users (
    business_user_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id),
    business_id INTEGER REFERENCES businesses(business_id),
    role_id INTEGER REFERENCES roles(role_id),
    is_primary_owner BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, business_id)
);

-- Team Members table
CREATE TABLE team_members (
    team_member_id SERIAL PRIMARY KEY,
    business_user_id INTEGER UNIQUE REFERENCES business_users(business_user_id),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Services table
CREATE TABLE services (
    service_id SERIAL PRIMARY KEY,
    business_id INTEGER REFERENCES businesses(business_id),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Team Member Services table
CREATE TABLE team_member_services (
    team_member_service_id SERIAL PRIMARY KEY,
    team_member_id INTEGER REFERENCES team_members(team_member_id),
    service_id INTEGER REFERENCES services(service_id),
    duration INTEGER NOT NULL, -- in minutes
    price DECIMAL(10, 2) NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (team_member_id, service_id)
);

-- Team Member Schedules table
CREATE TABLE team_member_schedules (
    schedule_id SERIAL PRIMARY KEY,
    team_member_id INTEGER REFERENCES team_members(team_member_id),
    location_id INTEGER REFERENCES locations(location_id),
    day_of_week INTEGER NOT NULL CHECK (day_of_week BETWEEN 0 AND 6),
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    is_working BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (team_member_id, location_id, day_of_week)
);

-- Customers table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    user_id INTEGER UNIQUE REFERENCES users(user_id),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Appointments table
CREATE TABLE appointments (
    appointment_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    team_member_service_id INTEGER REFERENCES team_member_services(team_member_service_id),
    location_id INTEGER REFERENCES locations(location_id),
    start_time TIMESTAMP WITH TIME ZONE NOT NULL,
    end_time TIMESTAMP WITH TIME ZONE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'scheduled',
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_businesses_name ON businesses(name);
CREATE INDEX idx_locations_business_id ON locations(business_id);
CREATE INDEX idx_roles_business_id ON roles(business_id);
CREATE INDEX idx_business_users_user_id ON business_users(user_id);
CREATE INDEX idx_business_users_business_id ON business_users(business_id);
CREATE INDEX idx_business_users_role_id ON business_users(role_id);
CREATE INDEX idx_team_members_business_user_id ON team_members(business_user_id);
CREATE INDEX idx_services_business_id ON services(business_id);
CREATE INDEX idx_team_member_services_team_member_id ON team_member_services(team_member_id);
CREATE INDEX idx_team_member_services_service_id ON team_member_services(service_id);
CREATE INDEX idx_team_member_schedules_team_member_id ON team_member_schedules(team_member_id);
CREATE INDEX idx_team_member_schedules_location_id ON team_member_schedules(location_id);
CREATE INDEX idx_team_member_schedules_day_of_week ON team_member_schedules(day_of_week);
CREATE INDEX idx_customers_user_id ON customers(user_id);
CREATE INDEX idx_appointments_customer_id ON appointments(customer_id);
CREATE INDEX idx_appointments_team_member_service_id ON appointments(team_member_service_id);
CREATE INDEX idx_appointments_location_id ON appointments(location_id);
CREATE INDEX idx_appointments_start_time ON appointments(start_time);
