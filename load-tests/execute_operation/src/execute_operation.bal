// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerinax/postgresql;
import ballerina/sql;
import ballerina/http;

configurable string dbHost = ?;
configurable string dbUsername = ?;
configurable string dbPassword = ?;
configurable string dbName = ?;
configurable int dbPort = ?;

type Customer record {
    int customerId;
    string lastName;
    string firstName;
    int registrationId;
    float creditLimit;
    string country;
};

final postgresql:Client dbClient = check new(host = dbHost, username = dbUsername, password = dbPassword, port = dbPort, database = dbName);

public function main() returns error? {
    _ = check dbClient->execute(`DROP TABLE IF EXISTS Customers`);
    _ = check dbClient->execute(`
        CREATE TABLE Customers (
            customerId SERIAL,
            firstName VARCHAR(300),
            lastName  VARCHAR(300),
            registrationID INT,
            creditLimit FLOAT,
            country  VARCHAR(300)
        );
    `);

    _ = check dbClient->execute(`
        INSERT INTO Customers (firstName, lastName, registrationID, creditLimit, country)
        VALUES ('Peter','Stuart', 1, 5000.75, 'USA')`);
    _ = check dbClient->execute(`
        INSERT INTO Customers (firstName, lastName, registrationID, creditLimit, country)
        VALUES ('Dan', 'Brown', 2, 10000, 'UK')`);
    _ = check dbClient->execute(`
        INSERT INTO Customers (firstName, lastName, registrationID, creditLimit, country)
        VALUES ('Peter','Stuart', 3, 5000.75, 'USA')`);
    _ = check dbClient->execute(`
        INSERT INTO Customers (firstName, lastName, registrationID, creditLimit, country)
        VALUES ('Dan', 'Brown', 4, 10000, 'UK')`);
    _ = check dbClient->execute(`
        INSERT INTO Customers (firstName, lastName, registrationID, creditLimit, country)
        VALUES ('Peter','Stuart', 5, 5000.75, 'USA')`);
    _ = check dbClient->execute(`
        INSERT INTO Customers (firstName, lastName, registrationID, creditLimit, country)
        VALUES ('Dan', 'Brown', 6, 10000, 'UK')`);
    _ = check dbClient->execute(`
        INSERT INTO Customers (firstName, lastName, registrationID, creditLimit, country)
        VALUES ('Peter','Stuart', 7, 5000.75, 'USA')`);
    _ = check dbClient->execute(`
        INSERT INTO Customers (firstName, lastName, registrationID, creditLimit, country)
        VALUES ('Dan', 'Brown', 8, 10000, 'UK')`);
    _ = check dbClient->execute(`
        INSERT INTO Customers (firstName, lastName, registrationID, creditLimit, country)
        VALUES ('Peter','Stuart', 9, 5000.75, 'USA')`);
    _ = check dbClient->execute(`
        INSERT INTO Customers (firstName, lastName, registrationID, creditLimit, country)
        VALUES ('Dan', 'Brown', 10, 10000, 'UK')`);
    _ = check dbClient->execute(`
        INSERT INTO Customers (firstName, lastName, registrationID, creditLimit, country)
        VALUES ('Peter','Stuart', 11, 5000.75, 'USA')`);
    _ = check dbClient->execute(`
        INSERT INTO Customers (firstName, lastName, registrationID, creditLimit, country)
        VALUES ('Dan', 'Brown', 12, 10000, 'UK')`);
    _ = check dbClient->execute(`
        INSERT INTO Customers (firstName, lastName, registrationID, creditLimit, country)
        VALUES ('Peter','Stuart', 13, 5000.75, 'USA')`);
    _ = check dbClient->execute(`
        INSERT INTO Customers (firstName, lastName, registrationID, creditLimit, country)
        VALUES ('Dan', 'Brown', 14, 10000, 'UK')`);
}

isolated service /customer on new http:Listener(9092) {
    resource isolated function post .(int id, float newCreditLimit) returns int?|error {
        sql:ParameterizedQuery updateQuery =
            `UPDATE Customers SET creditLimit = ${newCreditLimit} WHERE customerId = ${id}`;
        sql:ExecutionResult result = check dbClient->execute(updateQuery);
        return result?.affectedRowCount;
    }
}
