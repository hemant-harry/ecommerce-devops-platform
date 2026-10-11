CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO products (name, description, price, stock)
VALUES
('Wireless Mouse', 'Ergonomic wireless mouse', 799.00, 25),
('Mechanical Keyboard', 'USB mechanical keyboard', 2499.00, 10),
('USB-C Hub', 'Multiport USB-C hub', 1499.00, 15);
