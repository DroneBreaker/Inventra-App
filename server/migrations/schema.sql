CREATE TABLE companies (
    id CHAR(36) PRIMARY KEY,
    tin VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE users (
    id CHAR(36) PRIMARY KEY,
    company_tin VARCHAR(50) NOT NULL,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('admin', 'staff') DEFAULT 'staff',
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (company_tin) REFERENCES companies(tin) ON DELETE CASCADE,
    UNIQUE KEY unique_user_per_company (company_tin, username)
);

CREATE TABLE clients (
    id CHAR(36) PRIMARY KEY,
    company_tin VARCHAR(50) NOT NULL,
    client_name VARCHAR(255) NOT NULL,
    client_tin VARCHAR(50),
    client_email VARCHAR(255),
    client_phone VARCHAR(50),
    client_type VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (company_tin) REFERENCES companies(tin) ON DELETE CASCADE
);

CREATE TABLE items (
    id CHAR(36) PRIMARY KEY,
    company_tin VARCHAR(50) NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(15, 2) DEFAULT 0.00,
    cost DECIMAL(15, 2) DEFAULT 0.00,
    quantity INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (company_tin) REFERENCES companies(tin) ON DELETE CASCADE
);

CREATE TABLE invoices (
    id CHAR(36) PRIMARY KEY,
    company_tin VARCHAR(50) NOT NULL,
    invoice_number VARCHAR(50) NOT NULL,
    username VARCHAR(100),
    business_partner_tin VARCHAR(50),
    invoice_type VARCHAR(50),
    calculation_type VARCHAR(50),
    invoice_date DATETIME,
    invoice_time DATETIME,
    due_date DATETIME,
    total_vat DECIMAL(15, 2),
    total_amount DECIMAL(15, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (company_tin) REFERENCES companies(tin) ON DELETE CASCADE,
    UNIQUE KEY unique_invoice_num_per_company (company_tin, invoice_number)
);

CREATE TABLE invoice_items (
    id CHAR(36) PRIMARY KEY,
    invoice_id CHAR(36) NOT NULL,
    item_id CHAR(36),
    description VARCHAR(255) NOT NULL,
    quantity DECIMAL(10, 2) NOT NULL DEFAULT 1,
    unit_price DECIMAL(15, 2) NOT NULL,
    total DECIMAL(15, 2) NOT NULL,
    FOREIGN KEY (invoice_id) REFERENCES invoices(id) ON DELETE CASCADE
);
