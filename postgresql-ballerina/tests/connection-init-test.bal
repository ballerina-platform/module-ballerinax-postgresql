// Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/sql;
import ballerina/test;

@test:Config {
    groups: ["connection", "connection-init"]
}
function testConnectionWithNoFields() {
    Client|sql:Error dbClient = new ();
    test:assertTrue(dbClient is sql:Error, "Initialising connection with no fields should fail.");
}

@test:Config {
    groups: ["connection", "connection-init"]
}
function testConnectionWithUsernameAndPassword() {
    Client dbClient = checkpanic new (username = user, password = password);
    var exitCode = dbClient.close();
    test:assertExactEquals(exitCode, (), "Initialising connection with only username and password fail.");
}

@test:Config {
    groups: ["connection", "connection-init"]
}
function testWithURLParams() {
    Client dbClient = checkpanic new (username = user, password = password, database = connectDB, host = host, port = port);
    var exitCode = dbClient.close();
    test:assertExactEquals(exitCode, (), "Initialising connection with params fails.");
}

@test:Config {
    groups: ["connection", "connection-init"]
}
function testWithoutHost() {
    Client dbClient = checkpanic new (username = user, password = password, database = connectDB, port = port);
    var exitCode = dbClient.close();
    test:assertExactEquals(exitCode, (), "Initialising connection without host fails.");
}

@test:Config {
    groups: ["connection", "connection-init"]
}
function testWithoutDB() {
    Client dbClient = checkpanic new (username = user, password = password, port = port, host = host);
    var exitCode = dbClient.close();
    test:assertExactEquals(exitCode, (), "Initialising connection without database fails.");
}

@test:Config {
    groups: ["connection", "connection-init"]
}
function testWithOptions() {
    Options options = {
        ssl: {
            mode: "PREFER"
        },
        connectTimeoutInSeconds: 50,
        socketTimeoutInSeconds: 60,
        loginTimeoutInSeconds: 60,
        rowFetchSize:20,
        dbMetadataCacheFields:65536,
        dbMetadataCacheFieldsMiB:5,
        prepareThreshold:5,
        preparedStatementCacheQueries:256,
        preparedStatementCacheSize:5,
        cancelSignalTimeoutInSeconds:10,
        tcpKeepAlive:true
    };
    Client dbClient = checkpanic new (username = user, password = password, database = connectDB,
        port = port, options = options);
    var exitCode = dbClient.close();
    test:assertExactEquals(exitCode, (), "Initialising connection with options fails.");
}

@test:Config {
    groups: ["connection", "connection-init"]
}
function testWithOptions2() {
    Options options = {
        ssl: {
            mode: "PREFER"
        },
        connectTimeoutInSeconds: 0,
        socketTimeoutInSeconds: 0,
        loginTimeoutInSeconds: 0,
        rowFetchSize:0,
        dbMetadataCacheFields:0,
        dbMetadataCacheFieldsMiB:0,
        prepareThreshold:0,
        preparedStatementCacheQueries:0,
        preparedStatementCacheSize:0,
        cancelSignalTimeoutInSeconds:0,
        tcpKeepAlive:false
    };
    Client dbClient = checkpanic new (username = user, password = password, database = connectDB,
        port = port, options = options);
    var exitCode = dbClient.close();
    test:assertExactEquals(exitCode, (), "Initialising connection with options fails.");
}

@test:Config {
    groups: ["connection", "connection-init"]
}
function testWithConnectionPool() {
    sql:ConnectionPool connectionPool = {
        maxOpenConnections: 25
    };
    Client dbClient = checkpanic new (username = user, password = password, database = connectDB,
        port = port, connectionPool = connectionPool);
    var exitCode = dbClient.close();
    test:assertExactEquals(exitCode, (), "Initialising connection with option max connection pool fails.");
    test:assertEquals(connectionPool.maxOpenConnections, 25, "Configured max connection config is wrong.");
}

@test:Config {
    groups: ["connection", "connection-init"]
}
function testWithConnectionPool2() {
    sql:ConnectionPool connectionPool = {
        maxOpenConnections: 25,
        maxConnectionLifeTime : 15,
        minIdleConnections : 15
    };
    Client dbClient = checkpanic new (username = user, password = password, database = connectDB,
        port = port, connectionPool = connectionPool);
    var exitCode = dbClient.close();
    test:assertExactEquals(exitCode, (), "Initialising connection with option max connection pool fails.");
    test:assertEquals(connectionPool.maxOpenConnections, 25, "Configured max connection config is wrong.");
    test:assertEquals(connectionPool.maxConnectionLifeTime, <decimal>15, "Configured max connection life time second is wrong.");
    test:assertEquals(connectionPool.minIdleConnections, 15, "Configured min idle connection is wrong.");
}

@test:Config {
    groups: ["connection", "connection-init"]
}
function testWithConnectionParams() {
    sql:ConnectionPool connectionPool = {
        maxOpenConnections: 25,
        maxConnectionLifeTime : 15,
        minIdleConnections : 15
    };
    Options options = {
        ssl: {
            mode: "PREFER"
        },
        connectTimeoutInSeconds: 50,
        socketTimeoutInSeconds: 60,
        loginTimeoutInSeconds: 60,
        rowFetchSize:20,
        dbMetadataCacheFields:65536,
        dbMetadataCacheFieldsMiB:5,
        prepareThreshold:5,
        preparedStatementCacheQueries:256,
        preparedStatementCacheSize:5,
        cancelSignalTimeoutInSeconds:10,
        tcpKeepAlive:true
    };
    Client dbClient = checkpanic new (host = host, username = user, password = password, database = connectDB, port = port, options = options, connectionPool = connectionPool);
    var exitCode = dbClient.close();
    test:assertExactEquals(exitCode, (), "Initialising connection with connection params fails.");
}


@test:Config {
    groups: ["connection", "connection-init"]
}
function testWithConnectionParams2() {
    sql:ConnectionPool connectionPool = {
        maxOpenConnections: 25,
        maxConnectionLifeTime : 15,
        minIdleConnections : 15
    };
    Options options = {
        ssl: {
            mode: "PREFER"
        },
        connectTimeoutInSeconds: 50,
        socketTimeoutInSeconds: 60,
        loginTimeoutInSeconds: 60,
        rowFetchSize:20,
        dbMetadataCacheFields:65536,
        dbMetadataCacheFieldsMiB:5,
        prepareThreshold:5,
        preparedStatementCacheQueries:256,
        preparedStatementCacheSize:5,
        cancelSignalTimeoutInSeconds:10,
        tcpKeepAlive:false
    };
    Client dbClient = checkpanic new (host = host, username = user, password = password, options = options, connectionPool = connectionPool);
    var exitCode = dbClient.close();
    test:assertExactEquals(exitCode, (), "Initialising connection with connection params fails.");
}

@test:Config {
    groups: ["connection", "connection-init"]
}
function testWithConnectionParams3() {
    sql:ConnectionPool connectionPool = {
        maxOpenConnections: 25,
        maxConnectionLifeTime : 15,
        minIdleConnections : 15
    };
    Options options = {
        connectTimeoutInSeconds: 50,
        socketTimeoutInSeconds: 60,
        loginTimeoutInSeconds: 60,
        rowFetchSize:20,
        dbMetadataCacheFields:65536,
        dbMetadataCacheFieldsMiB:5,
        prepareThreshold:5,
        preparedStatementCacheQueries:256,
        preparedStatementCacheSize:5,
        cancelSignalTimeoutInSeconds:10,
        tcpKeepAlive:false
    };
    Client dbClient = checkpanic new (host = host, username = user, password = password, options = options, connectionPool = connectionPool);
    var exitCode = dbClient.close();
    test:assertExactEquals(exitCode, (), "Initialising connection with connection params fails.");
}
