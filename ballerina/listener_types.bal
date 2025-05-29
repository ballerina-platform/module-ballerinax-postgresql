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
|};

# Represents the configuration for the Postgres CDC listener.
#
# + database - The Postgres database connection configuration
public type PostgresListenerConfiguration record {|
    PostgresDatabaseConnection database;
    *cdc:ListenerConfiguration;
|};
