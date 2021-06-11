import ballerina/io;
import ballerinax/postgresql;
import ballerina/sql;

// The username , password and name of the PostgreSQL database
// You have to update these based on your setup.
string dbUsername = "postgres";
string dbPassword = "postgres";
string dbName = "postgres";

public function main() returns error? {
    // Runs the prerequisite setup for the example.
    check beforeExample();

    // Initializes the PostgresSQL client.
    postgresql:Client dbClient = check new (username = dbUsername,
                password = dbPassword, database = dbName);

    float newCreditLimit = 15000.5;

    // Creates a parameterized query for the record update.
    sql:ParameterizedQuery updateQuery =
            `UPDATE Customers SET creditLimit = ${newCreditLimit}
            where customerId = 1`;

    sql:ExecutionResult result = check dbClient->execute(updateQuery);
    io:println("Updated Row count: ", result?.affectedRowCount);

    string firstName = "Dan";

    // Creates a parameterized query for deleting the records.
    sql:ParameterizedQuery deleteQuery =
            `DELETE FROM Customers WHERE firstName = ${firstName}`;

    result = check dbClient->execute(deleteQuery);
    io:println("Deleted Row count: ", result.affectedRowCount);

    // Closes the PostgresSQL client.
    check dbClient.close();
}

// Initializes the database as a prerequisite to the example.
function beforeExample() returns sql:Error? {
    // Initializes the PostgresSQL client.
    postgresql:Client dbClient = check new (username = dbUsername,
                password = dbPassword, database = dbName);

    //Creates a table in the database.
    sql:ExecutionResult result = check dbClient->execute(`DROP TABLE IF EXISTS Customers`);
    result = check dbClient->execute(`CREATE TABLE Customers
            (customerId SERIAL, firstName
            VARCHAR(300), lastName  VARCHAR(300), registrationID INTEGER,
            creditLimit DOUBLE PRECISION, country VARCHAR(300),
            PRIMARY KEY (customerId))`);

    // Inserts data into the table. The result will have the `affectedRowCount`
    // and `lastInsertedId` with the auto-generated ID of the last row.

    result = check dbClient->execute(`INSERT INTO Customers
            (firstName, lastName, registrationID,creditLimit,country) VALUES
            ('Peter','Stuart', 1, 5000.75, 'USA')`);
    result = check dbClient->execute(`INSERT INTO Customers
            (firstName, lastName, registrationID,creditLimit,country) VALUES
            ('Dan', 'Brown', 2, 10000, 'UK')`);

    io:println("Rows affected: ", result.affectedRowCount);
    io:println("Generated Customer ID: ", result.lastInsertId);

    // Closes the PostgresSQL client.
    check dbClient.close();
}
