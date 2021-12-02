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

    // Initializes the PostgresSQL client.
    postgresql:Client dbClient = check new (username = dbUsername,
                password = dbPassword, database = dbName);

    // Creates a parameterized query to invoke the procedure.
    string personName = "George";
    int personAge = 24;
    int personId = 1;
    sql:ParameterizedCallQuery sqlQuery =
                `CALL InsertStudent(${personId}, ${personName}, ${personAge})`;

    // Invokes the stored procedure `InsertStudent` with the `IN` parameters.
    sql:ProcedureCallResult retCall = check dbClient->call(sqlQuery);
    stream<record{}, error?> resultStream = dbClient->query(`SELECT * FROM Student`);
    check resultStream.forEach(function(record {} result) {
        io:println("Call stored procedure `InsertStudent`." +
                   "\nInserted data: ", result);
    });
    check retCall.close();

    // Initializes the `INOUT` parameters.
    int no = 1;
    int count = 0;
    sql:InOutParameter id = new(no);
    sql:InOutParameter totalCount = new(count);
    sql:ParameterizedCallQuery sqlQuery2 =
                        `CALL GetCount(${id}, ${totalCount})`;

    // The stored procedure with the `INOUT` parameters is invoked.
    sql:ProcedureCallResult retCall2 = check dbClient->call(sqlQuery2);
    io:println("Call stored procedure `GetCount`.");
    io:println("Age of the student with id '1' : ", id.get(int));
    io:println("Total student count: ", totalCount.get(int));
    check retCall2.close();

    // Closes the PostgresSQL client.
    check dbClient.close();
}

// Initializes the database as a prerequisite to the example.
function beforeExample() returns sql:Error? {
    // Initializes the PostgresSQL client.
    postgresql:Client dbClient = check new (username = dbUsername,
                password = dbPassword, database = dbName);

    // Creates a table in the database.
    _ = check dbClient->execute(`DROP TABLE IF EXISTS Student`);
    _ = check dbClient->execute(`CREATE TABLE Student
            (id bigint, age bigint, name text,
            PRIMARY KEY (id))`);

    // Creates the necessary stored procedures using the execute command.
    _ = check dbClient->execute(`CREATE OR REPLACE PROCEDURE
        InsertStudent (IN id bigint, IN pName text, IN pAge bigint) language plpgsql as $$
        BEGIN INSERT INTO Student(id, age, name) VALUES (id, pAge, pName); END; $$ `);

    _ = check dbClient->execute(`CREATE OR REPLACE PROCEDURE GetCount
        (INOUT pID bigint, INOUT totalCount bigint) language plpgsql as $$
        BEGIN
        SELECT age INTO pID FROM Student WHERE id = pID;
        SELECT COUNT(*) INTO totalCount FROM Student;
        END; $$ `);

    // Closes the PostgresSQL client.
    check dbClient.close();
}
