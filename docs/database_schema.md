# Inventra Database Schema (MySQL)

## 1. Companies Table
The root of all data.
```sql
CREATE TABLE companies (
    id CHAR(36) PRIMARY KEY, -- UUID
    tin VARCHAR(50) NOT NULL UNIQUE, -- Business Key & Foreign Key for other tables
    name VARCHAR(255) NOT NULL,
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

## 2. Users Table
Users belong to a company.
```sql
CREATE TABLE users (
    id CHAR(36) PRIMARY KEY, -- UUID
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
```

## 3. Clients (Customers/Suppliers)
```sql
CREATE TABLE clients (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    company_tin VARCHAR(50) NOT NULL,
    name VARCHAR(255) NOT NULL,
    tin VARCHAR(50), -- Client's TIN
    email VARCHAR(255),
    phone VARCHAR(50),
    address TEXT,
    type ENUM('customer', 'supplier', 'both') DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (company_tin) REFERENCES companies(tin) ON DELETE CASCADE
);
```

## 4. Items (Inventory/Services)
```sql
CREATE TABLE items (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    company_tin VARCHAR(50) NOT NULL,
    sku VARCHAR(100),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(15, 2) DEFAULT 0.00,
    cost DECIMAL(15, 2) DEFAULT 0.00,
    quantity INT DEFAULT 0, -- Simple inventory tracking
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (company_tin) REFERENCES companies(tin) ON DELETE CASCADE
);
```

## 5. Invoices
```sql
CREATE TABLE invoices (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    company_tin VARCHAR(50) NOT NULL,
    client_id BIGINT NOT NULL,
    invoice_number VARCHAR(50) NOT NULL, -- Format typically defined by company (e.g., INV-001)
    status ENUM('draft', 'sent', 'paid', 'overdue', 'cancelled') DEFAULT 'draft',
    issue_date DATE NOT NULL,
    due_date DATE,
    total_amount DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    notes TEXT,
    created_by_user_id CHAR(36), -- Audit trail
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (company_tin) REFERENCES companies(tin) ON DELETE CASCADE,
    FOREIGN KEY (client_id) REFERENCES clients(id),
    UNIQUE KEY unique_invoice_num_per_company (company_tin, invoice_number)
);
```

## 6. Invoice Items
```sql
CREATE TABLE invoice_items (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    invoice_id BIGINT NOT NULL,
    item_id BIGINT,
    description VARCHAR(255) NOT NULL,
    quantity DECIMAL(10, 2) NOT NULL DEFAULT 1,
    unit_price DECIMAL(15, 2) NOT NULL,
    total DECIMAL(15, 2) NOT NULL, -- quantity * unit_price
    FOREIGN KEY (invoice_id) REFERENCES invoices(id) ON DELETE CASCADE
);
```
