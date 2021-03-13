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

import ballerina/file;
import ballerina/io;
import ballerina/test;

string resourcePath = check file:getAbsolutePath("tests/resources");

string host = "localhost";
string user = "postgres";
string password = "postgres";
int port = 5432;

string connectDB = "connect_db";
string functionsDatabase = "function_db";
string proceduresDatabase = "procedure_db";
string queryComplexDatabase = "query_db";
string simpleParamsDb = "simple_query_params_db";
string executeParamsDatabase = "execute_db";
string executeDb = "basic_execute_db";
string basicExecuteDatabase = "basic_execute_db";
string poolDB_1 = "pool_db_1";
string poolDB_2 = "pool_db_2";
string batchExecuteDB = "batch_execute_db";

@test:BeforeSuite
function beforeSuite() {
    io:println("Test suite initiated");
    _ = initTestScripts();
}

@test:AfterSuite {}
function afterSuite() {
    io:println("Test suite finished");
}
