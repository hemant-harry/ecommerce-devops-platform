
const express = require("express");
require("dotenv").config();

const pool = require("./db");
const app = express();

app.use(express.json());

app.get("/", (req, res) => {
  res.json({
    message: "E-Commerce DevOps Platform API",
    status: "running"
  });
});

app.get("/health", (req, res) => {
  res.status(200).json({ status: "healthy" });
});

app.get("/api/products", async (req, res) => {
  try {
    const [products] = await pool.query(
      "SELECT * FROM products ORDER BY id"
    );

    res.json(products);
  } catch (error) {
    console.error("Failed to fetch products:", error.message);
    res.status(500).json({ error: "Unable to fetch products" });
  }
});


app.post("/api/products", async (req, res) => {
  const { name, description, price, stock } = req.body ||  {};

  if (
    typeof name !== "string" ||
    !name.trim() ||
    !Number.isFinite(price) ||
    price <= 0 ||
    !Number.isInteger(stock) ||
    stock < 0
  ) {
    return res.status(400).json({
      error: "Valid name, positive price and non-negative integer stock are required"
    });
  }

  try {
    const [result] = await pool.execute(
      `INSERT INTO products (name, description, price, stock)
       VALUES (?, ?, ?, ?)`,
      [name.trim(), description || null, price, stock]
    );

    res.status(201).json({
      message: "Product created successfully",
      id: result.insertId
    });
  } catch (error) {
    console.error("Failed to create product:", error.message);
    res.status(500).json({ error: "Unable to create product" });
  }
});


const PORT = process.env.PORT || 3000;

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server running on port ${PORT}`);
});

