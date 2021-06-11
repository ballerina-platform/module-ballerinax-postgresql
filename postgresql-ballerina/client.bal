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

import ballerina/jballerina.java;
import ballerina/sql;

# Represents a PostgreSQL database client.
public client class Client {
    *sql:Client;
    private boolean clientActive = true;

    # Initialize the PostgreSQL client.
    #
    # + host - Hostname of the PostgreSQL server to be connected
    # + user - If the PostgreSQL server is secured, the username to be used to connect to the PostgreSQL server
    # + password - The password associated with the provided username of the database
    # + database - The name of the database to be connected. The default is to connect to a database with the
    #              same name as the user name
    # + port - Port of the PostgreSQL server to be connected
    # + options - The database-specific PostgreSQL client properties
    # + connectionPool - The `sql:ConnectionPool` object to be used within the PostgreSQL client
    #                   If there is no `connectionPool` provided, the global connection pool will be used and it will
    #                   be shared by other clients, which have the same properties.
    public isolated function init(string host = "localhost", string? username = (), string? password = (), string? database = (),
        int port = 5432, Options? options = (), sql:ConnectionPool? connectionPool = ()) returns sql:Error? {

        ClientConfiguration clientConfig = {
            host: host,
            port: port,
            user: username,
            password: password,
            database: database,
            options: options,
            connectionPool: connectionPool
        };

        return createClient(self, clientConfig, sql:getGlobalConnectionPool());
    }

    # Queries the database with the query provided by the user and returns the result as a stream.
    #
    # + sqlQuery - The query, which needs to be executed as a `string` or `ParameterizedQuery` when the SQL query has
    #              params to be passed in
    # + rowType - The `typedesc` of the record that should be returned as a result. If this is not provided, the default
    #             column names of the query result set will be used for the record attributes.
    # + return - Stream of records in the type of `rowType`
    remote isolated function query(@untainted string|sql:ParameterizedQuery sqlQuery, typedesc<record {}>? rowType = ())
    returns @tainted stream <record {}, sql:Error> {
        if (self.clientActive) {
            return nativeQuery(self, sqlQuery, rowType);
        } else {
            return sql:generateApplicationErrorStream("PostgreSQL Client is already closed,"
                + "hence further operations are not allowed");
        }
    }

    # Executes the DDL or DML SQL queries provided by the user and returns a summary of the execution.
    #
    # + sqlQuery - The DDL or DML query such as INSERT, DELETE, UPDATE, etc. as a `string` or `ParameterizedQuery`
    #              when the query has params to be passed in
    # + return - Summary of the SQL update query as an `ExecutionResult` or returns an `Error`
    #           if any error occurred when executing the query
    remote isolated function execute(@untainted string|sql:ParameterizedQuery sqlQuery) returns sql:ExecutionResult|sql:Error {
        if (self.clientActive) {
            return nativeExecute(self, sqlQuery);
        } else {
            return error sql:ApplicationError("PostgreSQL Client is already closed, hence further operations are not allowed");
        }
    }

    # Executes a batch of parameterized DDL or DML SQL query provided by the user
    # and returns the summary of the execution.
    #
    # + sqlQueries - The DDL or DML query such as INSERT, DELETE, UPDATE, etc. as a `ParameterizedQuery` with an array
    #                of values passed in
    # + return - Summary of the executed SQL queries as an `ExecutionResult[]`, which includes details such as
    #            `affectedRowCount` and `lastInsertId`. If one of the commands in the batch fails, this isolated function
    #            will return a `BatchExecuteError`. However, the PostgreSQL driver may or may not continue to process the
    #            remaining commands in the batch after a failure. The summary of the executed queries in case of an error
    #            can be accessed as `(<sql:BatchExecuteError> result).detail()?.executionResults`.
    remote isolated function batchExecute(@untainted sql:ParameterizedQuery[] sqlQueries) returns sql:ExecutionResult[]|sql:Error {
        if (sqlQueries.length() == 0) {
            return error sql:ApplicationError("Parameter 'sqlQueries' cannot be empty array");
        }
        if (self.clientActive) {
            return nativeBatchExecute(self, sqlQueries);
        } else {
            return error sql:ApplicationError("PostgreSQL Client is already closed, hence further operations are not allowed");
        }
    }

    # Executes a SQL stored procedure and returns the result as a stream and an execution summary.
    #
    # + sqlQuery - The query to execute the SQL stored procedure
    # + rowTypes - The array of `typedesc` of the records that should be returned as a result. If this is not provided,
    #               the default column names of the query result set will be used for the record attributes
    # + return - Summary of the execution is returned in a `ProcedureCallResult` or an `sql:Error`
    remote isolated function call(@untainted string|sql:ParameterizedCallQuery sqlQuery, typedesc<record {}>[] rowTypes = [])
    returns sql:ProcedureCallResult|sql:Error {
        if (self.clientActive) {
            return nativeCall(self, sqlQuery, rowTypes);
        } else {
            return error sql:ApplicationError("PostgreSQL Client is already closed, hence further operations are not allowed");
        }
    }

    # Close the SQL client.
    #
    # + return - Possible error during closing the client
    public isolated function close() returns sql:Error? {
        self.clientActive = false;
        return close(self);
    }
}

isolated function createClient(Client postgresqlClient, ClientConfiguration clientConf,
    sql:ConnectionPool globalConnPool) returns sql:Error? = @java:Method {
    'class: "org.ballerinalang.postgresql.nativeimpl.ClientProcessorUtils"
} external;

isolated function nativeQuery(Client sqlClient, string|sql:ParameterizedQuery sqlQuery, typedesc<record {}>? rowType)
returns stream <record {}, sql:Error> = @java:Method {
    'class: "org.ballerinalang.postgresql.nativeimpl.QueryProcessorUtils"
} external;

isolated function nativeExecute(Client sqlClient, string|sql:ParameterizedQuery sqlQuery)
returns sql:ExecutionResult|sql:Error = @java:Method {
    'class: "org.ballerinalang.postgresql.nativeimpl.ExecuteProcessorUtils"
} external;

isolated function nativeBatchExecute(Client sqlClient, sql:ParameterizedQuery[] sqlQueries)
returns sql:ExecutionResult[]|sql:Error = @java:Method {
    'class: "org.ballerinalang.postgresql.nativeimpl.ExecuteProcessorUtils"
} external;

isolated function nativeCall(Client sqlClient, string|sql:ParameterizedCallQuery sqlQuery, typedesc<record {}>[] rowTypes)
returns sql:ProcedureCallResult|sql:Error = @java:Method {
    'class: "org.ballerinalang.postgresql.nativeimpl.CallProcessorUtils"
} external;

isolated function close(Client postgresqlClient) returns sql:Error? = @java:Method {
    'class: "org.ballerinalang.postgresql.nativeimpl.ClientProcessorUtils"
} external;
