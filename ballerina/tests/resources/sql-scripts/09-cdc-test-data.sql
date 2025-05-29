CREATE TABLE vendors (
  id INT PRIMARY KEY,
  name VARCHAR(255),
  contact_info TEXT
);

INSERT INTO vendors VALUES
(1, 'Samsung', 'contact@samsung.com'),
(2, 'Apple', 'contact@apple.com');

CREATE TABLE products (
  id INT PRIMARY KEY,
  name VARCHAR(255),
  price DECIMAL(10,2),
  description TEXT,
  vendor_id INT,
  FOREIGN KEY (vendor_id) REFERENCES vendors(id)
);

INSERT INTO products VALUES
(1001, 'Samsung Galaxy S24', 999.99, 'Flagship phone with AI camera', 1),
(1002, 'Apple iPhone 15 Pro', 1099.00, 'New titanium design', 2);

ALTER TABLE vendors REPLICA IDENTITY FULL;
ALTER TABLE products REPLICA IDENTITY FULL;
