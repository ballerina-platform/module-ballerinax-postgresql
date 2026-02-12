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

const string SCHEMA_INCLUDE_LIST = "schema.include.list";
const string SCHEMA_EXCLUDE_LIST = "schema.exclude.list";

const string POSTGRESQL_DATABASE_NAME = "database.dbname";
const string POSTGRESQL_PLUGIN_NAME = "plugin.name";
const string POSTGRESQL_SLOT_NAME = "slot.name";
const string POSTGRESQL_PUBLICATION_NAME = "publication.name";

// PostgreSQL-specific advanced configuration properties
const string SLOT_DROP_ON_STOP = "slot.drop.on.stop";
const string PUBLICATION_AUTOCREATE_MODE = "publication.autocreate.mode";
const string STATUS_UPDATE_INTERVAL_MS = "status.update.interval.ms";
const string XMIN_FETCH_INTERVAL_MS = "xmin.fetch.interval.ms";
const string LSN_FLUSH_MODE = "lsn.flush.mode";
const string SLOT_STREAM_PARAMS = "slot.stream.params";
const string UNAVAILABLE_VALUE_PLACEHOLDER = "unavailable.value.placeholder";

// Relational-common configuration properties (applicable to MySQL, PostgreSQL, SQL Server)
const string MESSAGE_KEY_COLUMNS = "message.key.columns";

isolated function populatePostgresAdvancedConfiguration(PostgresAdvancedConfiguration? config, map<string> configMap) {
    if config is () {
        return;
    }

    configMap[SLOT_DROP_ON_STOP] = config.slotDropOnStop.toString();
    configMap[PUBLICATION_AUTOCREATE_MODE] = config.publicationAutocreateMode.toString();
    configMap[STATUS_UPDATE_INTERVAL_MS] = config.statusUpdateIntervalMs.toString();
    configMap[XMIN_FETCH_INTERVAL_MS] = config.xminFetchIntervalMs.toString();

    if config.lsnFlushMode !is () {
        configMap[LSN_FLUSH_MODE] = (config.lsnFlushMode ?: ALWAYS).toString();
    }

    if config.slotStreamParams !is () {
        configMap[SLOT_STREAM_PARAMS] = config.slotStreamParams ?: "";
    }

    configMap[UNAVAILABLE_VALUE_PLACEHOLDER] = config.unavailableValuePlaceholder;
}

isolated function populateRelationalCommonConfiguration(RelationalCommonConfiguration? config, map<string> configMap) {
    if config is () {
        return;
    }

    // Note: schemaIncludeList and schemaExcludeList are already handled by populateSchemaConfigurations
    // from the top-level includedSchemas/excludedSchemas fields for backward compatibility

    if config.messageKeyColumns !is () {
        string|string[] keyColumns = config.messageKeyColumns ?: "";
        configMap[MESSAGE_KEY_COLUMNS] = keyColumns is string ? keyColumns : string:'join(";", ...keyColumns);
    }
}

// Populates PostgreSQL-specific configurations
isolated function populatePostgresConfigurations(PostgresDatabaseConnection connection, map<string> configMap) {
    configMap[POSTGRESQL_DATABASE_NAME] = connection.databaseName;
    populateSchemaConfigurations(connection, configMap);
    configMap[POSTGRESQL_PLUGIN_NAME] = connection.pluginName;
    configMap[POSTGRESQL_SLOT_NAME] = connection.slotName;
    configMap[POSTGRESQL_PUBLICATION_NAME] = connection.publicationName;

    // Populate PostgreSQL-specific advanced configuration
    populatePostgresAdvancedConfiguration(connection.postgresAdvancedConfig, configMap);

    // Populate relational-common configuration
    populateRelationalCommonConfiguration(connection.relationalCommonConfig, configMap);
}

// Populates schema inclusion/exclusion configurations
isolated function populateSchemaConfigurations(PostgresDatabaseConnection connection, map<string> configMap) {
    string|string[]? includedSchemas = connection.includedSchemas;
    if includedSchemas !is () {
        configMap[SCHEMA_INCLUDE_LIST] = includedSchemas is string ? includedSchemas : string:'join(",", ...includedSchemas);
    }

    string|string[]? excludedSchemas = connection.excludedSchemas;
    if excludedSchemas !is () {
        configMap[SCHEMA_EXCLUDE_LIST] = excludedSchemas is string ? excludedSchemas : string:'join(",", ...excludedSchemas);
    }
}

const string SNAPSHOT_LOCK_TIMEOUT_MS = "snapshot.lock.timeout.ms";
const string INCLUDE_SCHEMA_CHANGES = "include.schema.changes";

// Populates PostgreSQL-specific options
isolated function populatePostgresOptions(PostgreSqlOptions options, map<string> configMap) {
    // Populate common options from cdc module
    cdc:populateOptions(options, configMap);

    // Populate PostgreSQL-specific extended snapshot configuration
    ExtendedSnapshotConfiguration? extendedSnapshot = options.extendedSnapshot;
    if extendedSnapshot is ExtendedSnapshotConfiguration {
        cdc:populateRelationalExtendedSnapshotConfiguration(extendedSnapshot, configMap);
        populatePostgresExtendedSnapshotConfiguration(extendedSnapshot, configMap);
    }

    // Populate PostgreSQL-specific data type configuration
    DataTypeConfiguration? dataTypeConfig = options.dataTypeConfig;
    if dataTypeConfig is DataTypeConfiguration {
        cdc:populateDataTypeConfiguration(dataTypeConfig, configMap);
        configMap[INCLUDE_SCHEMA_CHANGES] = dataTypeConfig.includeSchemaChanges.toString();
    }
}

// Populates PostgreSQL-specific extended snapshot properties
isolated function populatePostgresExtendedSnapshotConfiguration(ExtendedSnapshotConfiguration config, map<string> configMap) {
    configMap[SNAPSHOT_LOCK_TIMEOUT_MS] = getMillisecondValueOf(config.lockTimeout);
}

isolated function getMillisecondValueOf(decimal value) returns string {
    string milliSecondVal = (value * 1000).toBalString();
    return milliSecondVal.substring(0, milliSecondVal.indexOf(".") ?: milliSecondVal.length());
}
