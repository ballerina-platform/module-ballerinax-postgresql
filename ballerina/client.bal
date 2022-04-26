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

# Represents a PostgreSQL database client.
public isolated client class Client {
    *sql:Client;

    # Initializes the PostgreSQL client.
    #
    # + host - Hostname of the PostgreSQL server
    # + user - If the PostgreSQL server is secured, the username
    # + password - The password of the PostgreSQL server for the provided username
    # + database - The name of the database. The default is to connect to a database with the
    #              same name as the username
    # + port - Port number of the PostgreSQL server
    # + options - The database specific PostgreSQL connection properties
    # + connectionPool - The `sql:ConnectionPool` object to be used within the client. If there is no
    #                    `connectionPool` provided, the global connection pool will be used
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

    # Executes the query, which may return multiple results.
    #
    # + sqlQuery - The SQL query such as `` `SELECT * from Album WHERE name={albumName}` ``
    # + rowType - The `typedesc` of the record to which the result needs to be returned
    # + return - Stream of records in the `rowType` type
    remote isolated function query(sql:ParameterizedQuery sqlQuery, typedesc<record {}> rowType = <>) 
    returns stream<rowType, sql:Error?> = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.QueryProcessorUtils",
        name: "nativeQuery"
    } external;

    # Executes the query, which is expected to return at most one row of the result.
    # If the query does not return any results, an `sql:NoRowsError` is returned.
    #
    # + sqlQuery - The SQL query such as `` `SELECT * from Album WHERE name={albumName}` ``
    # + returnType - The `typedesc` of the record to which the result needs to be returned.
    #                It can be a basic type if the query result contains only one column
    # + return - Result in the `returnType` type or an `sql:Error`
    remote isolated function queryRow(sql:ParameterizedQuery sqlQuery, typedesc<anydata> returnType = <>) 
    returns returnType|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.QueryProcessorUtils",
        name: "nativeQueryRow"
    } external;

    # Executes the SQL query. Only the metadata of the execution is returned (not the results from the query).
    #
    # + sqlQuery - The SQL query such as `` `DELETE FROM Album WHERE artist={artistName}` ``
    # + return - Metadata of the query execution as an `sql:ExecutionResult` or an `sql:Error`
    remote isolated function execute(sql:ParameterizedQuery sqlQuery) returns sql:ExecutionResult|sql:Error {
        return nativeExecute(self, sqlQuery);
    }

    # Executes the SQL query with multiple sets of parameters in a batch. Only the metadata of the execution is returned (not results from the query).
    # If one of the commands in the batch fails, the `sql:BatchExecuteError` will be returned immediately.
    #
    # + sqlQueries - The SQL query with multiple sets of parameters
    # + return - Metadata of the query execution as an `sql:ExecutionResult[]` or an `sql:Error`
    remote isolated function batchExecute(sql:ParameterizedQuery[] sqlQueries) returns sql:ExecutionResult[]|sql:Error {
        if sqlQueries.length() == 0 {
            return error sql:ApplicationError("Parameter 'sqlQueries' cannot be empty array");
        }
        return nativeBatchExecute(self, sqlQueries);
    }

    # Executes an SQL query, which calls a stored procedure. This may or may not return results.
    #
    # + sqlQuery - The SQL query such as `` `CALL sp_GetAlbums();` ``
    # + rowTypes - `typedesc` array of the records to which the results need to be returned
    # + return - Summary of the execution and results are returned in an `sql:ProcedureCallResult`, or an `sql:Error`
    remote isolated function call(sql:ParameterizedCallQuery sqlQuery, typedesc<record {}>[] rowTypes = []) 
    returns sql:ProcedureCallResult|sql:Error {
        return nativeCall(self, sqlQuery, rowTypes);
    }

    # Closes the PostgreSQL client and shuts down the connection pool.
    #
    # + return - `()` or an `sql:Error`
    public isolated function close() returns sql:Error? {
        return close(self);
    }
}

# Provides a set of configurations for the PostgreSQL client to be passed internally within the module.
#
# + host - Hostname of the PostgreSQL server
# + port - Port number of the PostgreSQL server
# + user - If the PostgreSQL server is secured, the username
# + password - The password associated with the PostgreSQL server for the provided username
# + database - The name of the database. The default is to connect to a database with the
#              same name as the username
# + options - The database-specific PostgreSQL connection properties
# + connectionPool - The `sql:ConnectionPool` object to be used within the database client. If there is no
#                    `connectionPool` provided, the global connection pool will be used
type ClientConfiguration record {|
    string host;
    int port;
    string? user;
    string? password;
    string? database;
    Options? options;
    sql:ConnectionPool? connectionPool;
|};

# Provides an additional set of configurations related to the PostgreSQL database connection.
#
# + ssl - SSL configurations to be used
# + connectTimeout - Timeout (in seconds) to be used when connecting to the PostgreSQL server
# + socketTimeout - Socket timeout (in seconds) to be used during the read/write operations with the PostgreSQL server
#                   (0 means no socket timeout)
# + loginTimeout - Timeout (in seconds) to be used when connecting to the PostgreSQL server and authentication (0 means no timeout)
# + rowFetchSize - The number of rows to be fetched in one trip to the database
# + cachedMetadataFieldsCount - The maximum number of fields to be cached per connection.
#                               A value of 0 disables the cache
# + cachedMetadataFieldSize - The maximum size (in megabytes) of fields to be cached per connection.
#                             A value of 0 disables the cache
# + preparedStatementThreshold - The number of `PreparedStatement` executions required before switching
#                                over to use server-side prepared statements
# + preparedStatementCacheQueries - The number of queries that are cached in each connection
# + preparedStatementCacheSize - The maximum size (in mebibytes) of the prepared queries
# + cancelSignalTimeout - Time (in seconds) by which the cancel command is sent out of band over its own connection
#                         so that the cancel message itself can get stuck. The default value is 10 seconds
# + keepAliveTcpProbe - Enable or disable the TCP keep-alive probe
# + binaryTransfer - Use the binary format for sending and receiving data if possible
public type Options record {|
    SecureSocket ssl = {};
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
# + mode - The `SSLMode` to be used during the connection
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
# + certFile - A file containing the client certificate
# + keyFile - A file containing the client private key
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
