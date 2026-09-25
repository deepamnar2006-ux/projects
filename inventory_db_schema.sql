-- =============================================================================
-- INVENTORY MANAGEMENT SYSTEM — inventory_db
-- College-Level MySQL Schema
-- 8 Tables | Simple & Clean
-- =============================================================================

DROP DATABASE IF EXISTS inventory_db;
CREATE DATABASE inventory_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE inventory_db;

-- =============================================================================
-- 1. USERS
-- =============================================================================
CREATE TABLE users (
  user_id    INT          NOT NULL AUTO_INCREMENT,
  full_name  VARCHAR(100) NOT NULL,
  username   VARCHAR(50)  NOT NULL,
  password   VARCHAR(255) NOT NULL COMMENT 'bcrypt hash',
  role       ENUM('Admin','Storekeeper','Sales Staff') NOT NULL,
  status     ENUM('active','inactive') NOT NULL DEFAULT 'active',
  created_at TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (user_id),
  UNIQUE KEY uq_users_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Default admin account  (password: admin123)
INSERT INTO users (full_name, username, password, role) VALUES
  ('System Admin', 'admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Admin');


-- =============================================================================
-- 2. CATEGORIES
-- =============================================================================
CREATE TABLE categories (
  category_id   INT          NOT NULL AUTO_INCREMENT,
  category_name VARCHAR(100) NOT NULL,
  description   VARCHAR(255)     NULL DEFAULT NULL,
  status        ENUM('active','inactive') NOT NULL DEFAULT 'active',

  PRIMARY KEY (category_id),
  UNIQUE KEY uq_categories_name (category_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- =============================================================================
-- 3. SUPPLIERS
-- =============================================================================
CREATE TABLE suppliers (
  supplier_id   INT          NOT NULL AUTO_INCREMENT,
  supplier_name VARCHAR(100) NOT NULL,
  company_name  VARCHAR(150) NOT NULL,
  email         VARCHAR(150)     NULL DEFAULT NULL,
  phone         VARCHAR(20)  NOT NULL,
  address       TEXT             NULL DEFAULT NULL,
  status        ENUM('active','inactive') NOT NULL DEFAULT 'active',

  PRIMARY KEY (supplier_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- =============================================================================
-- 4. PRODUCTS
-- =============================================================================
CREATE TABLE products (
  product_id     INT           NOT NULL AUTO_INCREMENT,
  category_id    INT           NOT NULL,
  supplier_id    INT               NULL DEFAULT NULL,
  product_name   VARCHAR(150)  NOT NULL,
  sku            VARCHAR(100)  NOT NULL,
  description    TEXT              NULL DEFAULT NULL,
  purchase_price DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  selling_price  DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  stock_quantity INT           NOT NULL DEFAULT 0,
  reorder_level  INT           NOT NULL DEFAULT 5,
  status         ENUM('active','inactive') NOT NULL DEFAULT 'active',

  PRIMARY KEY (product_id),
  UNIQUE KEY uq_products_sku (sku),
  CONSTRAINT fk_products_category FOREIGN KEY (category_id)
    REFERENCES categories (category_id) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_products_supplier FOREIGN KEY (supplier_id)
    REFERENCES suppliers (supplier_id) ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- =============================================================================
-- 5. PURCHASES
-- =============================================================================
CREATE TABLE purchases (
  purchase_id   INT           NOT NULL AUTO_INCREMENT,
  supplier_id   INT           NOT NULL,
  user_id       INT           NOT NULL,
  invoice_no    VARCHAR(100)  NOT NULL,
  purchase_date DATE          NOT NULL,
  total_amount  DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  notes         TEXT              NULL DEFAULT NULL,
  created_at    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (purchase_id),
  UNIQUE KEY uq_purchases_invoice (invoice_no),
  CONSTRAINT fk_purchases_supplier FOREIGN KEY (supplier_id)
    REFERENCES suppliers (supplier_id) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_purchases_user FOREIGN KEY (user_id)
    REFERENCES users (user_id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- =============================================================================
-- 6. PURCHASE_ITEMS
-- =============================================================================
CREATE TABLE purchase_items (
  item_id     INT           NOT NULL AUTO_INCREMENT,
  purchase_id INT           NOT NULL,
  product_id  INT           NOT NULL,
  quantity    INT           NOT NULL,
  unit_price  DECIMAL(10,2) NOT NULL,
  subtotal    DECIMAL(10,2) NOT NULL,

  PRIMARY KEY (item_id),
  CONSTRAINT fk_pitems_purchase FOREIGN KEY (purchase_id)
    REFERENCES purchases (purchase_id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_pitems_product FOREIGN KEY (product_id)
    REFERENCES products (product_id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- =============================================================================
-- 7. SALES
-- =============================================================================
CREATE TABLE sales (
  sale_id        INT           NOT NULL AUTO_INCREMENT,
  user_id        INT           NOT NULL,
  invoice_no     VARCHAR(100)  NOT NULL,
  customer_name  VARCHAR(150)      NULL DEFAULT NULL,
  customer_phone VARCHAR(20)       NULL DEFAULT NULL,
  sale_date      DATE          NOT NULL,
  payment_method ENUM('Cash','Card','Transfer') NOT NULL DEFAULT 'Cash',
  total_amount   DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  created_at     TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (sale_id),
  UNIQUE KEY uq_sales_invoice (invoice_no),
  CONSTRAINT fk_sales_user FOREIGN KEY (user_id)
    REFERENCES users (user_id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- =============================================================================
-- 8. SALE_ITEMS
-- =============================================================================
CREATE TABLE sale_items (
  item_id    INT           NOT NULL AUTO_INCREMENT,
  sale_id    INT           NOT NULL,
  product_id INT           NOT NULL,
  quantity   INT           NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  subtotal   DECIMAL(10,2) NOT NULL,

  PRIMARY KEY (item_id),
  CONSTRAINT fk_sitems_sale FOREIGN KEY (sale_id)
    REFERENCES sales (sale_id) ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_sitems_product FOREIGN KEY (product_id)
    REFERENCES products (product_id) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- =============================================================================
-- VERIFY
-- =============================================================================
SHOW TABLES;
