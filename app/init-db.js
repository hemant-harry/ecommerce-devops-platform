const pool = require("./db");

async function initializeDatabase() {
  try {
    await pool.query(`
      CREATE TABLE IF NOT EXISTS products (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(150) NOT NULL,
        description TEXT,
        price DECIMAL(10,2) NOT NULL,
        stock INT NOT NULL DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);

    await pool.query(`
      INSERT INTO products (name, description, price, stock)
      SELECT * FROM (
        SELECT 'Laptop', 'Development laptop', 55000.00, 10
        UNION ALL
        SELECT 'Keyboard', 'Mechanical keyboard', 2500.00, 25
        UNION ALL
        SELECT 'Mouse', 'Wireless mouse', 900.00, 40
      ) AS sample
      WHERE NOT EXISTS (SELECT 1 FROM products)
    `);

    console.log("Database initialized successfully.");
  } catch (error) {
    console.error("Database initialization failed:", error.message);
    process.exitCode = 1;
  } finally {
    await pool.end();
  }
}

initializeDatabase();
