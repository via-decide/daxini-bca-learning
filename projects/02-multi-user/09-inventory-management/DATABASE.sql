-- Schema Design
CREATE TABLE products (
    id UUID PRIMARY KEY,
    sku VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    current_stock INT DEFAULT 0 -- Cached value for fast reads
);

CREATE TABLE inventory_transactions (
    id UUID PRIMARY KEY,
    product_id UUID REFERENCES products(id),
    user_id UUID REFERENCES users(id),
    quantity_change INT NOT NULL,
    reason VARCHAR(50)
);
