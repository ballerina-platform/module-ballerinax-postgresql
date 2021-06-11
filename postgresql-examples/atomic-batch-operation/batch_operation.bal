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

// The username , password and name of the PostgreSQL database
// You have to update these based on your setup.
string dbUsername = "postgres";
string dbPassword = "postgres";
string dbName = "postgres";

public function main() returns error? {

    // Initializes the PostgreSQL client.
    postgresql:Client dbClient = check new (username = dbUsername,
            password = dbPassword, database = dbName);

    // Runs the prerequisite setup for the example.
    check createTable(dbClient);

    // Executes batch operation query with transaction block.
    check extecuteBatchOperation(dbClient);

    // Reads all the existing data from the table.
    printTableData(dbClient);

    // Closes the PostgreSQL client.
    check dbClient.close();
}
