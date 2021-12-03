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

import ballerina/io;
import ballerinax/postgresql;
import ballerina/sql;

// The username , password and name of the PostgreSQL database
configurable string dbUsername = "postgres";
configurable string dbPassword = "postgres";
configurable string dbName = "postgres";
configurable int port = 5432;

public function main() returns error? {
    // Runs the prerequisite setup for the example.
    check beforeExample();

    // Initializes the PostgreSQL client.
    postgresql:Client dbClient = check new (username = dbUsername, 
                password = dbPassword, database = dbName);

    // Records with the duplicate `registrationID` entry.
    // Here it is `registrationID` = 1.
    var insertRecords = [
        {
            firstName: "Linda",
            lastName: "Jones",
            registrationID: 4,
            creditLimit: 10000.75,
            country: "USA"
        },
        {
            firstName: "Peter",
            lastName: "Stuart",
            registrationID: 1,
            creditLimit: 5000.75,
            country: "USA"
        },
        {
            firstName: "Camellia",
            lastName: "Potter",
            registrationID: 5,
            creditLimit: 2000.25,
            country: "USA"
        }
    ];

    // Creates a batch parameterized query.
    sql:ParameterizedQuery[] insertQueries = 
        from var data in insertRecords
            select `INSERT INTO Students
                (firstName, lastName, registrationID, creditLimit, country)
                VALUES (${data.firstName}, ${data.lastName},
                ${data.registrationID}, ${data.creditLimit}, ${data.country})`;

    // The transaction block can be used to roll back if any error occurred.
    transaction {
        var result = dbClient->batchExecute(insertQueries);
        if result is sql:BatchExecuteError {
            io:println(result.message());
            io:println(result.detail()?.executionResults);
            io:println("Rollback transaction.\n");
            rollback;
        } else {
            error? err = commit;
            if err is error {
                io:println("Error occurred while committing: ", err);
            }
        }
    }

    // Checks the data after the batch execution.
    stream<record {}, error?> resultStream = 
        dbClient->query(`SELECT * FROM Students`);

    io:println("Data in Students table:");
    check resultStream.forEach(function(record {} result) {
        io:println(result.toString());
    });

    // Closes the PostgreSQL client.
    check dbClient.close();
}

// Initializes the database as a prerequisite to the example.
function beforeExample() returns sql:Error? {
    // Initializes the PostgreSQL client.
    postgresql:Client dbClient = check new (username = dbUsername, 
                password = dbPassword, database = dbName);

    // Creates a table in the database.
    _ = check dbClient->execute(`DROP TABLE IF EXISTS Students`);
    _ = check dbClient->execute(`CREATE TABLE Students
            (customerId SERIAL, firstName VARCHAR(300), lastName  VARCHAR(300),
             registrationID INTEGER UNIQUE, creditLimit DOUBLE PRECISION,
             country  VARCHAR(300), PRIMARY KEY (customerId))`);

    // Adds records to the newly-created table.
    _ = check dbClient->execute(`INSERT INTO Students
            (firstName, lastName, registrationID,creditLimit,country) VALUES
            ('Peter', 'Stuart', 1, 5000.75, 'USA')`);
    // Closes the PostgreSQL client.
    check dbClient.close();
}
