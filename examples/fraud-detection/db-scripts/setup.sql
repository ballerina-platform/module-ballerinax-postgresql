
-- Transactions table
CREATE TABLE transactions (
    tx_id SERIAL PRIMARY KEY,
    user_id INT,
    amount DECIMAL(10,2),
    status VARCHAR(50),
    created_at TIMESTAMP NOT NULL
);

-- Sample data
INSERT INTO transactions (user_id, amount, status, created_at) VALUES
(10, 8500.00, 'COMPLETED', '2025-04-01 08:00:00'),
(11, 11500.00, 'COMPLETED', '2025-04-01 08:10:00'), -- this one should trigger fraud logic
(12, 4000.00, 'PENDING',   '2025-04-01 08:30:00');

ALTER TABLE transactions REPLICA IDENTITY FULL;
