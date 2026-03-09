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

# Represents publication autocreate modes.
public enum PublicationAutocreateMode {
    ALL_TABLES = "all_tables",
    DISABLED = "disabled",
    FILTERED = "filtered"
}

# Represents LSN flush modes.
public enum LsnFlushMode {
    MANUAL = "manual",
    CONNECTOR = "connector",
    CONNECTOR_AND_DRIVER = "connector_and_driver"
}

# PostgreSQL replication configuration (logical decoding).
#
# + pluginName - Logical decoding plugin to use (pgoutput, decoderbufs)
# + slotName - Name of the PostgreSQL logical replication slot
# + slotDropOnStop - Drop replication slot when connector stops
# + slotStreamParams - Custom replication slot parameters
public type ReplicationConfiguration record {|
    PostgreSQLLogicalDecodingPlugin pluginName = PGOUTPUT;
    string slotName = "debezium";
    boolean slotDropOnStop = false;
    string slotStreamParams?;
|};

# PostgreSQL publication configuration (pgoutput plugin).
#
# + publicationName - Name of PostgreSQL publication
# + publicationAutocreateMode - Mode for auto-creating publications
public type PublicationConfiguration record {|
    string publicationName = "dbz_publication";
    PublicationAutocreateMode publicationAutocreateMode = ALL_TABLES;
|};

# PostgreSQL streaming and status configuration.
#
# + statusUpdateInterval - Interval for sending status updates to PostgreSQL in seconds
# + xminFetchInterval - Interval for fetching current xmin position in seconds
# + lsnFlushMode - LSN flushing strategy
public type StreamingConfiguration record {|
    decimal statusUpdateInterval = 10;
    decimal xminFetchInterval = 0;
    LsnFlushMode lsnFlushMode?;
|};

# Represents the configuration for the Postgres CDC database connection.
#
# + connectorClass - The class name of the PostgreSQL connector implementation to use
# + hostname - The hostname of the PostgreSQL server
# + port - The port number of the PostgreSQL server
# + databaseName - The name of the PostgreSQL database from which to stream the changes.
# + includedSchemas - A list of regular expressions matching fully-qualified schema identifiers to capture changes from
# + excludedSchemas - A list of regular expressions matching fully-qualified schema identifiers to exclude from change capture
# + includedTables - Regex patterns for tables to capture (mutually exclusive with `excludedTables`)
# + excludedTables - Regex patterns for tables to exclude (mutually exclusive with `includedTables`)
# + includedColumns - Regex patterns for columns to capture (mutually exclusive with `excludedColumns`)
# + excludedColumns - Regex patterns for columns to exclude (mutually exclusive with `includedColumns`)
# + messageKeyColumns - Composite message key columns for change events
# + tasksMax - The PostgreSQL connector always uses a single task and therefore does not use this value, so the default is always acceptable
# + pluginName - Deprecated: Use `replicationConfig.pluginName` instead
# + slotName - Deprecated: Use `replicationConfig.slotName` instead
# + publicationName - Deprecated: Use `publicationConfig.publicationName` instead
# + replicationConfig - Replication configuration (logical decoding plugin, slot name and parameters). Takes priority over deprecated top-level fields
# + publicationConfig - Publication configuration (publication name and autocreate mode). Takes priority over deprecated top-level fields
public type PostgresDatabaseConnection record {|
    *cdc:DatabaseConnection;
    string connectorClass = "io.debezium.connector.postgresql.PostgresConnector";
    string hostname = "localhost";
    int port = 5432;
    string databaseName;
    string|string[] includedSchemas?;
    string|string[] excludedSchemas?;
    string|string[] includedTables?;
    string|string[] excludedTables?;
    string|string[] includedColumns?;
    string|string[] excludedColumns?;
    cdc:MessageKeyColumns[] messageKeyColumns?;
    int tasksMax = 1;
    # Deprecated: Use `replicationConfig.pluginName` instead.
    @deprecated
    PostgreSQLLogicalDecodingPlugin pluginName = PGOUTPUT;
    # Deprecated: Use `replicationConfig.slotName` instead.
    @deprecated
    string slotName = "debezium";
    # Deprecated: Use `publicationConfig.publicationName` instead.
    @deprecated
    string publicationName = "dbz_publication";
    ReplicationConfiguration replicationConfig?;
    PublicationConfiguration publicationConfig?;
    StreamingConfiguration streamingConfig?;
|};

# PostgreSQL CDC listener configuration including database connection, storage, and CDC options.
#
# + database - PostgreSQL database connection, logical decoding, and capture settings
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
# + heartbeatConfig - Heartbeat configuration for keeping the PostgreSQL replication slot active
public type PostgreSqlOptions record {|
    *cdc:Options;
    ExtendedSnapshotConfiguration extendedSnapshot?;
    cdc:DataTypeConfiguration dataTypeConfig?;
    cdc:RelationalHeartbeatConfiguration heartbeatConfig?;
|};

# Represents the extended snapshot configuration for the PostgreSQL CDC listener.
#
# + lockTimeout - Lock acquisition timeout in seconds
# + isolationMode - Transaction isolation level during snapshot
public type ExtendedSnapshotConfiguration record {|
    *cdc:RelationalExtendedSnapshotConfiguration;
    decimal lockTimeout = 10;
    cdc:SnapshotIsolationMode isolationMode?;
|};
