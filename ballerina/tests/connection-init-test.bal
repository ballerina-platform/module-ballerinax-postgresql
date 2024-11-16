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
import ballerina/lang.'string as strings;

@test:Config {
    groups: ["connection", "connection-init"]
}
isolated function testConnectionWithNoFields() returns error? {
    Client dbClient = check new ();
    error? exitCode = dbClient.close();
    test:assertExactEquals(exitCode, (), "Initialising connection with no fields fails.");
}

@test:Config {
    groups: ["connection", "connection-init"]
}
function testConnectionWithUsernameAndPassword() returns error? {
    Client dbClient = check new (username = user, password = password);
    error? exitCode = dbClient.close();
    test:assertExactEquals(exitCode, (), "Initialising connection with only username and password fails.");
}

@test:Config {
    groups: ["connection", "connection-init"]
}
function testWithURLParams() returns error? {
    Client dbClient = check new (username = user, password = password, database = connectDB, host = host, port = port);
    error? exitCode = dbClient.close();
    test:assertExactEquals(exitCode, (), "Initialising connection with params fails.");
}

@test:Config {
    groups: ["connection", "connection-init"]
}
function testWithoutHost() returns error? {
    Client dbClient = check new (username = user, password = password, database = connectDB, port = port);
    error? exitCode = dbClient.close();
    test:assertExactEquals(exitCode, (), "Initialising connection without host fails.");
}

@test:Config {
    groups: ["connection", "connection-init"]
}
function testWithoutPort() returns error? {
    Client dbClient = check new (username = user, password = password, database = connectDB);
    error? exitCode = dbClient.close();
    test:assertExactEquals(exitCode, (), "Initialising connection without host fails.");
}

@test:Config {
    groups: ["connection", "connection-init"]
}
function testWithoutUsername() returns error? {
    Client dbClient = check new (host = host, password = password, database = connectDB, port = port);
    error? exitCode = dbClient.close();
    test:assertExactEquals(exitCode, (), "Initialising connection without username fails.");
}

@test:Config {
    groups: ["connection", "connection-init"]
}
function testWithoutDB() returns error? {
    Client dbClient = check new (username = user, password = password, port = port, host = host);
    error? exitCode = dbClient.close();
    test:assertExactEquals(exitCode, (), "Initialising connection without database fails.");
}

@test:Config {
    groups: ["connection", "connection-init"]
}
function testWithOptions() returns error? {
    Options options = {
        ssl: {
            mode: "PREFER"
        },
        connectTimeout: 50.34,
        socketTimeout: 60.332,
        loginTimeout: 60.33,
        rowFetchSize: 20,
        cachedMetadataFieldsCount: 65536,
        cachedMetadataFieldSize: 5,
        preparedStatementThreshold: 5,
        preparedStatementCacheQueries: 256,
        preparedStatementCacheSize: 5,
        cancelSignalTimeout: 10.112,
        keepAliveTcpProbe: true
    };
    Client dbClient = check new (username = user, password = password, database = connectDB, 
        port = port, options = options);
    error? exitCode = dbClient.close();
    test:assertExactEquals(exitCode, (), "Initialising connection with options fails.");
}

@test:Config {
    groups: ["connection", "connection-init"]
}
function testWithOptions2() returns error? {
    Options options = {
        ssl: {
            mode: "PREFER"
        },
        connectTimeout: 0,
        socketTimeout: 0,
        loginTimeout: 0,
        rowFetchSize: 0,
        cachedMetadataFieldsCount: 0,
        cachedMetadataFieldSize: 0,
        preparedStatementThreshold: -1,
        preparedStatementCacheQueries: -1,
        preparedStatementCacheSize: -1,
        cancelSignalTimeout: 0,
        keepAliveTcpProbe: false
    };
    Client dbClient = check new (username = user, password = password, database = connectDB, 
        port = port, options = options);
    error? exitCode = dbClient.close();
    test:assertExactEquals(exitCode, (), "Initialising connection with options fails.");
}

@test:Config {
    groups: ["connection", "connection-init"]
}
function testWithConnectionPool() returns error? {
    sql:ConnectionPool connectionPool = {
        maxOpenConnections: 25
    };
    Client dbClient = check new (username = user, password = password, database = connectDB, 
        port = port, connectionPool = connectionPool);
    error? exitCode = dbClient.close();
    test:assertExactEquals(exitCode, (), "Initialising connection with option max connection pool fails.");
    test:assertEquals(connectionPool.maxOpenConnections, 25, "Configured max connection config is wrong.");
}

@test:Config {
    groups: ["connection", "connection-init"]
}
function testWithConnectionPool2() returns error? {
    sql:ConnectionPool connectionPool = {
        maxOpenConnections: 25,
        maxConnectionLifeTime: 30,
        minIdleConnections: 15
    };
    Client dbClient = check new (username = user, password = password, database = connectDB, 
        port = port, connectionPool = connectionPool);
    error? exitCode = dbClient.close();
    test:assertExactEquals(exitCode, (), "Initialising connection with option max connection pool fails.");
    test:assertEquals(connectionPool.maxOpenConnections, 25, "Configured max connection config is wrong.");
    test:assertEquals(connectionPool.maxConnectionLifeTime, <decimal>30, "Configured max connection life time second is wrong.");
    test:assertEquals(connectionPool.minIdleConnections, 15, "Configured min idle connection is wrong.");
}

@test:Config {
    groups: ["connection", "connection-init"]
}
function testWithConnectionParams() returns error? {
    sql:ConnectionPool connectionPool = {
        maxOpenConnections: 25,
        maxConnectionLifeTime: 30,
        minIdleConnections: 15
    };
    Options options = {
        ssl: {
            mode: "PREFER"
        },
        connectTimeout: 50,
        socketTimeout: 60,
        loginTimeout: 60,
        rowFetchSize: 20,
        cachedMetadataFieldsCount: 65536,
        cachedMetadataFieldSize: 5,
        preparedStatementThreshold: 5,
        preparedStatementCacheQueries: 256,
        preparedStatementCacheSize: 5,
        cancelSignalTimeout: 10,
        keepAliveTcpProbe: true
    };
    Client dbClient = check new (host = host, username = user, password = password, database = connectDB, port = port, options = options, connectionPool = connectionPool);
    error? exitCode = dbClient.close();
    test:assertExactEquals(exitCode, (), "Initialising connection with connection params fails.");
}

@test:Config {
    groups: ["connection", "connection-init"]
}
function testWithConnectionParams2() returns error? {
    sql:ConnectionPool connectionPool = {
        maxOpenConnections: 25,
        maxConnectionLifeTime: 30,
        minIdleConnections: 15
    };
    Options options = {
        ssl: {
            mode: "PREFER"
        },
        connectTimeout: 50,
        socketTimeout: 60,
        loginTimeout: 60,
        rowFetchSize: 20,
        cachedMetadataFieldsCount: 65536,
        cachedMetadataFieldSize: 5,
        preparedStatementThreshold: 5,
        preparedStatementCacheQueries: 256,
        preparedStatementCacheSize: 5,
        cancelSignalTimeout: 10,
        keepAliveTcpProbe: false
    };
    Client dbClient = check new (host = host, username = user, password = password, options = options, connectionPool = connectionPool);
    error? exitCode = dbClient.close();
    test:assertExactEquals(exitCode, (), "Initialising connection with connection params fails.");
}

@test:Config {
    groups: ["connection", "connection-init"]
}
function testWithConnectionParams3() returns error? {
    sql:ConnectionPool connectionPool = {
        maxOpenConnections: 25,
        maxConnectionLifeTime: 30,
        minIdleConnections: 15
    };
    Options options = {
        connectTimeout: 50,
        socketTimeout: 60,
        loginTimeout: 60,
        rowFetchSize: 20,
        cachedMetadataFieldsCount: 65536,
        cachedMetadataFieldSize: 5,
        preparedStatementThreshold: 0,
        preparedStatementCacheQueries: 256,
        preparedStatementCacheSize: 5,
        cancelSignalTimeout: 10,
        keepAliveTcpProbe: false
    };
    Client dbClient = check new (host = host, username = user, password = password, options = options, connectionPool = connectionPool);
    error? exitCode = dbClient.close();
    test:assertExactEquals(exitCode, (), "Initialising connection with connection params fails.");
}

@test:Config {
    groups: ["connection", "connection-init"]
}
function testWithConnectionParams4() returns error? {
    sql:ConnectionPool connectionPool = {
        maxOpenConnections: 25,
        maxConnectionLifeTime: 30,
        minIdleConnections: 15
    };
    Options options = {
        binaryTransfer: true
    };
    Client dbClient = check new (host = host, username = user, password = password, options = options, connectionPool = connectionPool);

    error? exitCode = dbClient.close();
    test:assertExactEquals(exitCode, (), "Initialising connection with connection params fails.");
}

@test:Config {
    groups: ["connection", "connection-init"]
}
function testWithConnectionParams5() returns error? {
    sql:ConnectionPool connectionPool = {
        maxOpenConnections: 25,
        maxConnectionLifeTime: 30,
        minIdleConnections: 15
    };
    Options options = {};
    Client dbClient = check new (host = host, username = user, password = password, options = options, connectionPool = connectionPool);

    error? exitCode = dbClient.close();
    test:assertExactEquals(exitCode, (), "Initialising connection with connection params fails.");
}

@test:Config {
    groups: ["connection", "connection-init"]
}
function testWithConnectionParams6() returns error? {
    sql:ConnectionPool? connectionPool = ();
    Options? options = ();
    Client dbClient = check new (host = host, username = user, password = password, options = options, connectionPool = connectionPool);

    error? exitCode = dbClient.close();
    test:assertExactEquals(exitCode, (), "Initialising connection with connection params fails.");
}

@test:Config {
    groups: ["connection", "connection-init"]
}
function testWithConnectionParams7() returns error? {
    sql:ConnectionPool connectionPool = {};
    Options options = {
        connectTimeout: 50,
        socketTimeout: 60,
        loginTimeout: 60,
        rowFetchSize: 20,
        cachedMetadataFieldsCount: 65536,
        cachedMetadataFieldSize: 5,
        preparedStatementThreshold: 5,
        preparedStatementCacheQueries: 256,
        preparedStatementCacheSize: 5,
        cancelSignalTimeout: 10,
        keepAliveTcpProbe: false,
        binaryTransfer: true
    };
    Client dbClient = check new (host = host, username = user, password = password, options = options, connectionPool = connectionPool);

    error? exitCode = dbClient.close();
    test:assertExactEquals(exitCode, (), "Initialising connection with connection params fails.");
}

@test:Config {
    groups: ["connection", "connection-init"]
}
function testWithClosedClient1() returns error? {
    Client dbClient = check new (username = user, password = password);
    error? exitCode = dbClient.close();
    test:assertExactEquals(exitCode, (), "Initialising connection with connection params fails.");
    sql:ExecutionResult|sql:Error result = dbClient->execute(`CREATE TABLE test (id bigint)`);
    if result is sql:Error {
        string expectedErrorMessage = "SQL Client is already closed, hence further operations are not allowed";
        test:assertTrue(result.message().startsWith(expectedErrorMessage), 
            "Error message does not match, actual :\n'" + result.message() + "'\nExpected : \n" + expectedErrorMessage);
    } else {
        test:assertFail("Error expected");
    }
}

@test:Config {
    groups: ["connection", "connection-init"]
}
function testWithClosedClient2() returns error? {
    Client dbClient = check new (username = user, password = password);
    error? exitCode = dbClient.close();
    test:assertExactEquals(exitCode, (), "Initialising connection with connection params fails.");
    sql:ExecutionResult[]|sql:Error result = dbClient->batchExecute([`CREATE TABLE test (id bigint)`, `Insert Into test (id) VALUES (5)`]);
    if result is sql:Error {
        string expectedErrorMessage = "SQL Client is already closed, hence further operations are not allowed";
        test:assertTrue(result.message().startsWith(expectedErrorMessage), 
            "Error message does not match, actual :\n'" + result.message() + "'\nExpected : \n" + expectedErrorMessage);
    } else {
        test:assertFail("Error expected");
    }
}

@test:Config {
    groups: ["connection", "connection-init"]
}
function testWithClosedClient3() returns error? {
    Client dbClient = check new (username = user, password = password);
    error? exitCode = dbClient.close();
    test:assertExactEquals(exitCode, (), "Initialising connection with connection params fails.");
    sql:ProcedureCallResult|sql:Error result = dbClient->call(`call testProcedure()`);
    if result is sql:Error {
        string expectedErrorMessage = "SQL Client is already closed, hence further operations are not allowed";
        test:assertTrue(result.message().startsWith(expectedErrorMessage), 
            "Error message does not match, actual :\n'" + result.message() + "'\nExpected : \n" + expectedErrorMessage);
    } else {
        test:assertFail("Error expected");
    }
}

@test:Config {
    groups: ["connection", "connection-init"]
}
function testConnectionServerRejection() returns error? {
    Options options = {
        connectTimeout: 5
    };

    Client dbClient = check new (host, user, password, connectDB, port = limitedPort, options = options);
    Client dbClient2 = check new (host, user, password, connectDB, port = limitedPort, options = options);
    Client dbClient3 = check new (host, user, password, connectDB, port = limitedPort, options = options);
    Client dbClient4 = check new (host, user, password, connectDB, port = limitedPort, options = options);
    Client dbClient5 = check new (host, user, password, connectDB, port = limitedPort, options = options);
    Client dbClient6 = check new (host, user, password, connectDB, port = limitedPort, options = options);

    stream<record {}, error?> streamData = dbClient->query(`SELECT * FROM Customers`);
    stream<record {}, error?> streamData2 = dbClient2->query(`SELECT * FROM Customers`);
    stream<record {}, error?> streamData3 = dbClient3->query(`SELECT * FROM Customers`);
    stream<record {}, error?> streamData4 = dbClient4->query(`SELECT * FROM Customers`);
    stream<record {}, error?> streamData5 = dbClient5->query(`SELECT * FROM Customers`);
    stream<record {}, error?> streamData6 = dbClient6->query(`SELECT * FROM Customers`);

    record {|record {} value;|}|error? data = streamData.next();
    record {|record {} value;|}|error? data2 = streamData2.next();
    record {|record {} value;|}|error? data3 = streamData3.next();
    record {|record {} value;|}|error? data4 = streamData4.next();
    record {|record {} value;|}|error? data5 = streamData5.next();
    record {|record {} value;|}|error? data6 = streamData6.next();

    _ = check streamData.close();
    _ = check streamData2.close();
    _ = check streamData3.close();
    _ = check streamData4.close();
    _ = check streamData5.close();
    _ = check streamData6.close();

    _ = check dbClient.close();
    _ = check dbClient2.close();
    _ = check dbClient3.close();
    _ = check dbClient4.close();
    _ = check dbClient5.close();
    _ = check dbClient6.close();

    if data is error || data2 is error || data3 is error || data4 is error || data5 is error {
        test:assertFail("Connection failed before limit was reached.");
    }

    if data6 is error {
        test:assertTrue(strings:includes(data6.message(), "sorry, too many clients already."), data6.message());
    } else {
        test:assertFail("Error expected.");
    }
}
