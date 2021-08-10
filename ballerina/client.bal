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
    remote isolated function query(string|sql:ParameterizedQuery sqlQuery, typedesc<record {}> rowType = <>)
    returns stream <rowType, sql:Error> = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.QueryProcessorUtils",
        name: "nativeQuery"
    } external;

    # Queries the database with the provided query and returns the first row as a if the expected return type is
    # a record. If the expected return type is not a record, then a single value is returned.
    #
    # + sqlQuery - The query, which needs to be executed as a `string` or  an `sql:ParameterizedQuery` when the SQL
    #               query has params to be passed in
    # + returnType - The `typedesc` of the record/type that should be returned as a result. If this is not provided, the
    #                default column names/type of the query result set will be used
    # + return - Result in the type of `returnType`. If the `returnType` is not provided, the column names/type of
    #               the query are used
    remote isolated function queryRow(string|sql:ParameterizedQuery sqlQuery, typedesc<any> returnType = <>)
    returns returnType|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.QueryProcessorUtils",
        name: "nativeQueryRow"
    } external;

    # Executes the DDL or DML SQL queries provided by the user and returns a summary of the execution.
    #
    # + sqlQuery - The DDL or DML query such as INSERT, DELETE, UPDATE, etc. as a `string` or `ParameterizedQuery`
    #              when the query has params to be passed in
    # + return - Summary of the SQL update query as an `ExecutionResult` or returns an `Error`
    #           if any error occurred when executing the query
    remote isolated function execute(string|sql:ParameterizedQuery sqlQuery) returns sql:ExecutionResult|sql:Error {
        return nativeExecute(self, sqlQuery);
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
    remote isolated function batchExecute(sql:ParameterizedQuery[] sqlQueries) returns sql:ExecutionResult[]|sql:Error {
        if (sqlQueries.length() == 0) {
            return error sql:ApplicationError("Parameter 'sqlQueries' cannot be empty array");
        }
        return nativeBatchExecute(self, sqlQueries);
    }

    # Executes a SQL stored procedure and returns the result as a stream and an execution summary.
    #
    # + sqlQuery - The query to execute the SQL stored procedure
    # + rowTypes - The array of `typedesc` of the records that should be returned as a result. If this is not provided,
    #               the default column names of the query result set will be used for the record attributes
    # + return - Summary of the execution is returned in a `ProcedureCallResult` or an `sql:Error`
    remote isolated function call(string|sql:ParameterizedCallQuery sqlQuery, typedesc<record {}>[] rowTypes = [])
    returns sql:ProcedureCallResult|sql:Error {
        return nativeCall(self, sqlQuery, rowTypes);
    }

    # Close the SQL client.
    #
    # + return - Possible error during closing the client
    public isolated function close() returns sql:Error? {
        return close(self);
    }
}

# Provides a set of configurations for the PostgreSQL client to be passed internally within the module.
#
# + host - URL of the database to connect
# + port - Port of the database to connect
# + user - Username for the database connection
# + password - Password for the database connection
# + database - Name of the database. The default name is the same name as the user name.
# + options - PostgreSQL datasource `Options` to be configured
# + connectionPool - Properties for the connection pool configuration. For more details, see the `sql:ConnectionPool`
type ClientConfiguration record {|
    string host;
    int port;
    string? user;
    string? password;
    string? database;
    Options? options;
    sql:ConnectionPool? connectionPool;
|};

# PostgreSQL database options.
#
# + ssl - SSL Configuration to be used
# + connectTimeout - The timeout value used for socket connect operations.
#                    If connecting to the server takes longer than this value, the connection is broken.
#                    Value of zero means that it is disabled.
# + socketTimeout - The timeout value used for socket read operations.
#                   If reading from the server takes longer than this value, the connection is closed
#                   Value of zero means that it is disabled.
# + loginTimeout - Specify how long to wait for establishment of a database connection.
#                  Value of zero means that it is infinite.
# + rowFetchSize - Determine the number of rows fetched in the `ResultSet` by one fetch with a trip to the database.
# + cachedMetadataFieldsCount - Specifies the maximum number of fields to be cached per connection.
#                           A value of 0 disables the cache.
# + cachedMetadataFieldSize - Specifies the maximum size (in megabytes) of fields to be cached per connection.
#                            A value of 0 disables the cache.
# + preparedStatementThreshold - Determine the number of `PreparedStatement` executions required before switching
#                                over to use server-side prepared statements.
# + preparedStatementCacheQueries - Determine the number of queries that are cached in each connection.
# + preparedStatementCacheSize - Determine the maximum size (in mebibytes) of the prepared queries.
# + cancelSignalTimeout - Time (in seconds) by which, the cancel command is sent out of band over its own connection
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

# The SSL configuration to be used when connecting to the PostgreSQL server.
#
# + mode - The `SSLMode` to be used during the connection
# + key - Keystore configuration of the client certificates
# + rootcert - File name of the SSL root certificate. Defaults to the `defaultdir/root.crt`.
#             in which the `defaultdir` is `${user.home}/.postgresql/` in Unix systems and
#             `%appdata%/postgresql/` on Windows.
public type SecureSocket record {|
    SSLMode mode = PREFER;
    string rootcert?;
    crypto:KeyStore | CertKey key?;
|};

# Represents the combination of the certificate, private key, and private key password if encrypted
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

isolated function nativeExecute(Client sqlClient, string|sql:ParameterizedQuery sqlQuery)
returns sql:ExecutionResult|sql:Error = @java:Method {
    'class: "io.ballerina.stdlib.postgresql.nativeimpl.ExecuteProcessorUtils"
} external;

isolated function nativeBatchExecute(Client sqlClient, sql:ParameterizedQuery[] sqlQueries)
returns sql:ExecutionResult[]|sql:Error = @java:Method {
    'class: "io.ballerina.stdlib.postgresql.nativeimpl.ExecuteProcessorUtils"
} external;

isolated function nativeCall(Client sqlClient, string|sql:ParameterizedCallQuery sqlQuery, typedesc<record {}>[] rowTypes)
returns sql:ProcedureCallResult|sql:Error = @java:Method {
    'class: "io.ballerina.stdlib.postgresql.nativeimpl.CallProcessorUtils"
} external;

isolated function close(Client postgresqlClient) returns sql:Error? = @java:Method {
    'class: "io.ballerina.stdlib.postgresql.nativeimpl.ClientProcessorUtils"
} external;
