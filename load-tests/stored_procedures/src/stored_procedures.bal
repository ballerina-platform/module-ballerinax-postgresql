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

final postgresql:Client dbClient = check new(host = dbHost, username = dbUsername, password = dbPassword, port = dbPort, database = dbName);

public function main() returns error? {

    _ = check dbClient->execute(`DROP TABLE IF EXISTS Student`);
   _ = check dbClient->execute(`CREATE TABLE Student
            (id bigint, age bigint, name text,
            PRIMARY KEY (id))`);

    _ = check dbClient->execute(`INSERT INTO Student(id, age, name) VALUES (1, 24, 'George')`);
    _ = check dbClient->execute(`INSERT INTO Student(id, age, name) VALUES (2, 25, 'Tom')`);
    _ = check dbClient->execute(`INSERT INTO Student(id, age, name) VALUES (3, 35, 'Michael')`);
    _ = check dbClient->execute(`INSERT INTO Student(id, age, name) VALUES (4, 24, 'George')`);
    _ = check dbClient->execute(`INSERT INTO Student(id, age, name) VALUES (5, 25, 'Tom')`);
    _ = check dbClient->execute(`INSERT INTO Student(id, age, name) VALUES (6, 35, 'Michael')`);
    _ = check dbClient->execute(`INSERT INTO Student(id, age, name) VALUES (7, 24, 'George')`);
    _ = check dbClient->execute(`INSERT INTO Student(id, age, name) VALUES (8, 25, 'Tom')`);
    _ = check dbClient->execute(`INSERT INTO Student(id, age, name) VALUES (9, 35, 'Michael')`);

    result = check dbClient->execute(`CREATE OR REPLACE PROCEDURE GetCount
        (INOUT pID bigint, INOUT totalCount bigint) language plpgsql as $$
        BEGIN
        SELECT age INTO pID FROM Student WHERE id = pID;
        SELECT COUNT(*) INTO totalCount FROM Student;
        END; $$ `);
}

isolated service /student on new http:Listener(9092) {
    resource isolated function get .(int personId) returns record {}|error {
        int count = 0;
        sql:InOutParameter id = new(personId);
        sql:InOutParameter totalCount = new(count);
        sql:ProcedureCallResult retCall = check dbClient->call(`CALL GetCount(${id}, ${totalCount})`);

        record {} result = {
            "age": check id.get(int),
            "totalCount": check totalCount.get(int)
        };

        check retCall.close();
        return result;
    }
}
