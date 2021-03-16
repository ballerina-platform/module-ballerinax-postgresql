        DROP TABLE IF EXISTS Customers;
        CREATE TABLE IF NOT EXISTS Customers(
        customerId SERIAL,
        firstName  VARCHAR(300),
        lastName  VARCHAR(300),
        registrationID INTEGER,
        creditLimit DOUBLE PRECISION,
        country  VARCHAR(300),
        PRIMARY KEY (customerId)
        );

        INSERT INTO Customers (firstName, lastName, registrationID, creditLimit, country)
        VALUES ('Peter', 'Stuart', 1, 5000.75, 'USA');

        INSERT INTO Customers (firstName, lastName, registrationID, creditLimit, country)
        VALUES ('Dan', 'Brown', 2, 10000, 'UK');