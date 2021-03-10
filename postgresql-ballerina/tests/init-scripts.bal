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
import ballerina/sql;

public function initTestScripts() {
    _ = createExecuteDB();
    _ = createBatchExecuteDB();
    _ = createBasicExecuteDB();
    _ = createSimpleQueryDB();
    _ = createQueryDB();
    _ = createProcedureDB();
    _ = createLocalTransactionDB();
    _ = createConnectionPool1DB();
    _ = createConnectionPool2DB();
}


public function createExecuteDB() {
    _ = createDatabaseQuery(createExecuteDBQuery);
    _ = executeQuery("execute_db", tableInitDBQuery);
}

public function createBatchExecuteDB() {
    _ = createDatabaseQuery(createBatchExecuteDBQuery);
    _ = executeQuery("batch_execute_db", tableInitDBQuery);
}

public function createBasicExecuteDB() {
    _ = createDatabaseQuery(createBasicExecuteDBQuery);
    _ = executeQuery("basic_execute_db", tableInitDBQuery);
}

public function createSimpleQueryDB() {
    _ = createDatabaseQuery(simpleQueryDBQuery);
    _ = executeQuery("simple_query_params_db", tableInitDBQuery);
}

public function createQueryDB() {
    _ = createDatabaseQuery(createQueryDBQuery);
    _ = executeQuery("query_db", tableInitDBQuery);
}

public function createLocalTransactionDB() {
    _ = createDatabaseQuery(createLocalTransactionDBQuery);
    _ = executeQuery("local_transaction", localTransactionInitQuery);
}

public function createConnectionPool1DB() {
    _ = createDatabaseQuery(createConnectionPool1DBQuery);
    _ = executeQuery("pool_db_1", connectonPool1InitQuery);
}

public function createConnectionPool2DB() {
    _ = createDatabaseQuery(createConnectionPool2DBQuery);
    _ = executeQuery("pool_db_2", connectonPool2InitQuery);
}

public function createProcedureDB() {
    _ = createDatabaseQuery(procedureDBQuery);
    _ = executeQuery("procedure_db", tableInitDBQuery);
    _ = executeQuery("procedure_db", procedureInQuery);
    _ = executeQuery("procedure_db", procedureOutQuery);
    _ = executeQuery("procedure_db", procedureInoutQuery);
    _ = executeQuery("procedure_db", procedureSelectQuery);
}

public function createDatabaseQuery(sql:ParameterizedQuery query) {

    Client|sql:Error postgresClient = new(username="postgres", password="postgres");

    if (postgresClient is sql:Error) {
        io:println("Client init failed\n", postgresClient);
    }
    else {
        sql:ExecutionResult|sql:Error result__;
        sql:Error? e__;

        result__ = postgresClient->execute(query);
        if (result__ is sql:Error) {
            io:println("Database drop failed\n", result__);
        }
        checkpanic postgresClient.close();

    }

}

public function executeQuery(string database, sql:ParameterizedQuery query) {

    Client|sql:Error postgresClient = new(username="postgres", password="postgres", database = database);

    if (postgresClient is sql:Error) {
        io:println("Client init failed\n", postgresClient);
    }
    else {
        sql:ExecutionResult|sql:Error result__;
        sql:Error? e__;

        result__ = postgresClient->execute(query);
        if (result__ is sql:Error) {
            io:println("Init Execute drop failed\n", result__);
        }
        checkpanic postgresClient.close();
    }
}
