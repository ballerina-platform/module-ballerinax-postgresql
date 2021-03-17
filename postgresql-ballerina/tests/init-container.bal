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

// Port 5431 will use to connect with Docker container
int port = 5431;

string connectDB = "postgres";
string functionsDatabase = "postgres";
string proceduresDatabase = "postgres";
string queryComplexDatabase = "postgres";
string simpleParamsDb = "postgres";
string executeParamsDatabase = "postgres";
string executeDb = "postgres";
string basicExecuteDatabase = "postgres";
string poolDB_1 = "postgres";
string poolDB_2 = "postgres";
string batchExecuteDB = "postgres";

@test:BeforeSuite
function beforeSuite() {
    io:println("Test suite initiated");
}

@test:AfterSuite {}
function afterSuite() {
    io:println("Test suite finished");
}
