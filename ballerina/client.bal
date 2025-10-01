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

import ballerina/crypto;
import ballerina/jballerina.java;
import ballerina/sql;

# PostgreSQL database client that enables interaction with PostgreSQL servers and supports standard SQL operations.
public isolated client class Client {
    *sql:Client;

    # Connects to a PostgreSQL database with the specified configuration.
    #
    # + host - PostgreSQL server hostname
    # + user - Database username
    # + password - Database password
    # + database - Database name to connect to. The default is to connect to a database with the
    #              same name as the username
    # + port - PostgreSQL server port
    # + options - The database specific PostgreSQL advanced connection options
    # + connectionPool - The `sql:ConnectionPool` object to be used within the client. If not provided, the global connection pool (shared by all clients) will be used
    # + return - An `sql:Error` if the client creation fails
    public isolated function init(string host = "localhost", string? username = "postgres", string? password = (), string? database = (),
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

    # Executes a SQL query and returns multiple results as a stream.
    #
    # + sqlQuery - The SQL query as `sql:ParameterizedQuery` (e.g., `` `SELECT * FROM users WHERE id=${userId}` ``)
    # + rowType - The `typedesc` of the record type to which the result needs to be mapped
    # + return - Stream of records containing the query results. Please ensure that the stream is fully consumed, or close the stream.
    remote isolated function query(sql:ParameterizedQuery sqlQuery, typedesc<record {}> rowType = <>) 
    returns stream<rowType, sql:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.QueryProcessorUtils",
        name: "nativeQuery"
    } external;

    # Executes a SQL query that is expected to return a single row or value as the result.
    #
    # + sqlQuery - The SQL query as `sql:ParameterizedQuery` (e.g., `` `SELECT * from Album WHERE name=${albumName}` ``)
    # + returnType - The `typedesc` of the anydata (record or basic type) to which the result needs to be returned.
    #                It can be a basic type if the query result contains only one column
    # + return - The result of the query or an `sql:Error`.
    #           - If the query does not return any results, an `sql:NoRowsError` is returned.
    #           - If the query returns multiple rows, only the first row is returned.
    remote isolated function queryRow(sql:ParameterizedQuery sqlQuery, typedesc<anydata> returnType = <>) 
    returns returnType|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.QueryProcessorUtils",
        name: "nativeQueryRow"
    } external;

    # Executes a SQL query and returns execution metadata (not the actual query results).
    # This function is typically used for operations like `INSERT`, `UPDATE`, or `DELETE`.
    #
    # + sqlQuery - The SQL query as `sql:ParameterizedQuery` (e.g., `` `DELETE FROM Album WHERE artist=${artistName}` ``)
    # + return - The execution metadata as an `sql:ExecutionResult`, or an `sql:Error` if execution fails
    remote isolated function execute(sql:ParameterizedQuery sqlQuery) returns sql:ExecutionResult|sql:Error {
        return nativeExecute(self, sqlQuery);
    }

    # Executes a SQL query with multiple sets of parameters in a single batch operation and returns execution metadata (not the actual query results).
    # This function is typically used for batch operations like `INSERT`, `UPDATE`, or `DELETE`.
    #
    # + sqlQueries - The SQL query with multiple sets of parameters as an array of `sql:ParameterizedQuery`
    # + return - The execution metadata as an array of `sql:ExecutionResult` or an `sql:Error`
                - If one of the commands in the batch fails, an `sql:BatchExecuteError` will be returned immediately
    remote isolated function batchExecute(sql:ParameterizedQuery[] sqlQueries) returns sql:ExecutionResult[]|sql:Error {
        if sqlQueries.length() == 0 {
            return error sql:ApplicationError("Parameter 'sqlQueries' cannot be empty array");
        }
        return nativeBatchExecute(self, sqlQueries);
    }

    # Calls a stored procedure with the given SQL query.
    #
    # + sqlQuery - The SQL query to call the procedure as `sql:ParameterizedQuery` (e.g., `` `CALL get_user(${id})` ``)
    # + rowTypes - An array of `typedesc` of the record type to which the result needs to be mapped
    # + return - The summary of the execution and results are returned in an `sql:ProcedureCallResult`, or an `sql:Error`
               - Once the results are processed, invoke the `close` method on the `sql:ProcedureCallResult`.
    remote isolated function call(sql:ParameterizedCallQuery sqlQuery, typedesc<record {}>[] rowTypes = []) 
    returns sql:ProcedureCallResult|sql:Error {
        return nativeCall(self, sqlQuery, rowTypes);
    }

    # Closes the PostgreSQL client and shuts down the connection pool.
    # The client should be closed only at the end of the application lifetime, or when performing graceful stops in a service.
    #
    # + return - `sql:Error` if closing the client fails, else `()`
    public isolated function close() returns sql:Error? {
        return close(self);
    }
}

# Represents the configurations for the PostgreSQL client to be passed internally within the module.
#
# + host - PostgreSQL server hostname
# + port - Port number of the PostgreSQL server
# + user - Database username
# + password - Database password
# + database - Database name to connect to. The default is to connect to a database with the
#              same name as the username
# + options - The database specific PostgreSQL advanced connection options
# + connectionPool - The `sql:ConnectionPool` object to be used within the client.
#                       If not provided, the global connection pool (shared by all clients) will be used
type ClientConfiguration record {|
    string host;
    int port;
    string? user;
    string? password;
    string? database;
    Options? options;
    sql:ConnectionPool? connectionPool;
|};

# Represents an additional set of configurations related to the PostgreSQL database connection.
#
# + ssl - SSL configurations to be used
# + connectTimeout - Timeout in seconds for connecting to the server
# + socketTimeout - Socket timeout in seconds for read/write operations with the server (0 means no socket timeout)
# + loginTimeout - Timeout in seconds for connecting to the server and authentication (0 means no timeout)
# + rowFetchSize - The number of rows to be fetched in one trip to the database
# + cachedMetadataFieldsCount - The maximum number of fields to be cached per connection. A value of 0 disables the cache
# + cachedMetadataFieldSize - The maximum size in megabytes of fields to be cached per connection. A value of 0 disables the cache
# + preparedStatementThreshold - The number of `PreparedStatement` executions required before switching
#                                over to use server-side prepared statements. A value of 0 disables the cache.
# + preparedStatementCacheQueries - The number of queries that are cached in each connection
#                                   A value of 0 for preparedStatementThreshold disables the cache.
# + preparedStatementCacheSize - The maximum size in mebibytes of the prepared queries
#                                  A value of 0 for preparedStatementThreshold disables the cache.
# + cancelSignalTimeout - Time in seconds for sending the cancel command out of band over its own connection
# + keepAliveTcpProbe - Enable or disable the TCP keep-alive probe
# + binaryTransfer - Use the binary format for sending and receiving data if possible
# + currentSchema - The schema to be used by the client
public type Options record {|
    SecureSocket ssl?;
    decimal connectTimeout = 0;
    decimal socketTimeout = 0;
    decimal loginTimeout = 0;
    int rowFetchSize?;
    int cachedMetadataFieldsCount?;
    int cachedMetadataFieldSize?;
    int preparedStatementThreshold?;
    int preparedStatementCacheQueries?;
    int preparedStatementCacheSize?;
    decimal cancelSignalTimeout = 10;
    boolean keepAliveTcpProbe?;
    boolean binaryTransfer?;
    string currentSchema?;
|};

# Possible values for the SSL mode.
public enum SSLMode {
    PREFER,
    REQUIRE,
    DISABLE,
    ALLOW,
    VERIFY_CA = "VERIFY-CA",
    VERIFY_FULL = "VERIFY-FULL"
}

# The SSL configurations to be used when connecting to the PostgreSQL server.
#
# + mode - The `postgresql:SSLMode` to be used during the connection
# + key - Keystore configuration of the client certificates
# + rootcert - File name of the SSL root certificate. Defaults to the `defaultdir/root.crt`.
#             in which the `defaultdir` is `${user.home}/.postgresql/` in Unix systems and
#             `%appdata%/postgresql/` on Windows.
public type SecureSocket record {|
    SSLMode mode = PREFER;
    string rootcert?;
    crypto:KeyStore|CertKey key?;
|};

# Represents the combination of the certificate, the private key, and the private key password if encrypted
#
# + certFile - The client certificate file
# + keyFile - The client private key file
# + keyPassword - Password of the private key if it is encrypted
public type CertKey record {|
    string certFile;
    string keyFile;
    string keyPassword?;
|};

isolated function createClient(Client postgresqlClient, ClientConfiguration clientConf, 
    sql:ConnectionPool globalConnPool) returns sql:Error? = @java:Method {
    'class: "io.ballerina.stdlib.postgresql.nativeimpl.ClientProcessorUtils"
} external;

isolated function nativeExecute(Client sqlClient, sql:ParameterizedQuery sqlQuery) 
returns sql:ExecutionResult|sql:Error = @java:Method {
    'class: "io.ballerina.stdlib.postgresql.nativeimpl.ExecuteProcessorUtils"
} external;

isolated function nativeBatchExecute(Client sqlClient, sql:ParameterizedQuery[] sqlQueries) 
returns sql:ExecutionResult[]|sql:Error = @java:Method {
    'class: "io.ballerina.stdlib.postgresql.nativeimpl.ExecuteProcessorUtils"
} external;

isolated function nativeCall(Client sqlClient, sql:ParameterizedCallQuery sqlQuery, typedesc<record {}>[] rowTypes) 
returns sql:ProcedureCallResult|sql:Error = @java:Method {
    'class: "io.ballerina.stdlib.postgresql.nativeimpl.CallProcessorUtils"
} external;

isolated function close(Client postgresqlClient) returns sql:Error? = @java:Method {
    'class: "io.ballerina.stdlib.postgresql.nativeimpl.ClientProcessorUtils"
} external;
