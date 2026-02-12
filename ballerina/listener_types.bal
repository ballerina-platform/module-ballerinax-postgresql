// Copyright (c) 2025, WSO2 LLC. (https://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerinax/cdc;

# Represents the PostgreSQL logical decoding plugins.
#
# + PGOUTPUT - The standard logical decoding output plug-in in PostgreSQL 10+
# + DECODERBUFS - A logical decoding plugin based on Protobuf and maintained by the Debezium community
public enum PostgreSQLLogicalDecodingPlugin {
    PGOUTPUT = "pgoutput",
    DECODERBUFS = "decoderbufs"
}

# Represents PostgreSQL-specific advanced configuration options.
#
# + slotDropOnStop - Whether to drop the replication slot when the connector stops
# + publicationAutocreateMode - Mode for auto-creating publications (all_tables, disabled, filtered)
# + statusUpdateIntervalMs - Interval in milliseconds for sending status updates to the server
# + xminFetchIntervalMs - Interval in milliseconds for fetching the current xmin value
# + lsnFlushMode - Mode for flushing LSN to the server (always or lazy)
# + slotStreamParams - Parameters to pass to the replication slot stream
# + unavailableValuePlaceholder - Placeholder string for unavailable column values during TOAST handling
public type PostgresAdvancedConfiguration record {|
    boolean slotDropOnStop = false;
    cdc:PublicationAutocreateMode publicationAutocreateMode = ALL_TABLES;
    int statusUpdateIntervalMs = 10000;
    int xminFetchIntervalMs = 0;
    cdc:LsnFlushMode lsnFlushMode?;
    string slotStreamParams?;
    string unavailableValuePlaceholder = "__debezium_unavailable_value";
|};

# Represents relational database common configuration options.
# These properties are applicable to all relational databases (MySQL, PostgreSQL, SQL Server).
#
# + schemaIncludeList - List of schemas to include (comma-separated regular expressions)
# + schemaExcludeList - List of schemas to exclude (comma-separated regular expressions)
# + messageKeyColumns - Custom message key columns (format: schemaName.tableName:keyColumn1,keyColumn2)
public type RelationalCommonConfiguration record {|
    string|string[] schemaIncludeList?;
    string|string[] schemaExcludeList?;
    string|string[] messageKeyColumns?;
|};

# Represents the configuration for the Postgres CDC database connection.
#
# + connectorClass - The class name of the PostgreSQL connector implementation to use
# + hostname - The hostname of the PostgreSQL server
# + port - The port number of the PostgreSQL server
# + databaseName - The name of the PostgreSQL database from which to stream the changes.
# + includedSchemas - A list of regular expressions matching fully-qualified schema identifiers to capture changes from
# + excludedSchemas - A list of regular expressions matching fully-qualified schema identifiers to exclude from change capture
# + tasksMax - The PostgreSQL connector always uses a single task and therefore does not use this value, so the default is always acceptable
# + pluginName - The name of the PostgreSQL logical decoding plug-in installed on the server
# + slotName - The name of the PostgreSQL logical decoding slot
# + publicationName - The name of the PostgreSQL publication created for streaming changes when using pgoutput.
# + postgresAdvancedConfig - PostgreSQL-specific advanced configuration options
# + relationalCommonConfig - Relational database common configuration options (applicable to MySQL, PostgreSQL, SQL Server)
public type PostgresDatabaseConnection record {|
    *cdc:DatabaseConnection;
    string connectorClass = "io.debezium.connector.postgresql.PostgresConnector";
    string hostname = "localhost";
    int port = 5432;
    string databaseName;
    string|string[] includedSchemas?;
    string|string[] excludedSchemas?;
    int tasksMax = 1;
    PostgreSQLLogicalDecodingPlugin pluginName = PGOUTPUT;
    string slotName = "debezium";
    string publicationName = "dbz_publication";
    PostgresAdvancedConfiguration postgresAdvancedConfig?;
    RelationalCommonConfiguration relationalCommonConfig?;
|};

# PostgreSQL CDC listener configuration including database connection, storage, and CDC options.
#
# + database - PostgreSQL database connection, logical decoding, and capture settings
# + engineName - Unique name for the CDC engine instance
# + internalSchemaStorage - Schema history storage backend (file, Kafka, memory, JDBC, Redis, S3, Azure Blob, RocketMQ)
# + offsetStorage - Offset storage backend for tracking connector progress (file, Kafka, memory, JDBC, Redis)
# + options - PostgreSQL-specific CDC options including snapshot, heartbeat, signals, and data type handling
public type PostgresListenerConfiguration record {|
    PostgresDatabaseConnection database;
    *cdc:ListenerConfiguration;
    PostgreSqlOptions options = {};
|};

# PostgreSQL-specific CDC options for configuring snapshot behavior and data type handling.
#
# + extendedSnapshot - Extended snapshot configuration with PostgreSQL-specific lock timeout and query settings
# + dataTypeConfig - Data type handling configuration including schema change tracking
public type PostgreSqlOptions record {|
    *cdc:Options;
    ExtendedSnapshotConfiguration extendedSnapshot?;
    DataTypeConfiguration dataTypeConfig?;
|};

# Represents the extended snapshot configuration for the PostgreSQL CDC listener.
# 
# + lockTimeout - Lock acquisition timeout in seconds
public type ExtendedSnapshotConfiguration record {|
    *cdc:RelationalExtendedSnapshotConfiguration;
    decimal lockTimeout = 10;
|};

# Represents data type handling configuration.
#
# + includeSchemaChanges - Whether to include schema change events
public type DataTypeConfiguration record {|
    *cdc:DataTypeConfiguration;
    boolean includeSchemaChanges = true;
|};