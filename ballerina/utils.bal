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

isolated function populateDebeziumProperties(PostgresListenerConfiguration config, map<string> debeziumConfigs) {
    cdc:populateDebeziumProperties({
                                       engineName: config.engineName,
                                       offsetStorage: config.offsetStorage,
                                       internalSchemaStorage: config.internalSchemaStorage
                                   }, debeziumConfigs);
    populateDatabaseConfigurations(config.database, debeziumConfigs);
    populateOptions(config.options, debeziumConfigs);
}


// Populates PostgreSQL-specific configurations
isolated function populateDatabaseConfigurations(PostgresDatabaseConnection database, map<string> debeziumConfigs) {
    cdc:populateDatabaseConfigurations({
        connectorClass: database.connectorClass,
        hostname: database.hostname,
        port: database.port,
        username: database.username,
        password: database.password,
        connectTimeout: database.connectTimeout,
        tasksMax: database.tasksMax,
        secure: database.secure,
        includedTables: database.includedTables,
        excludedTables: database.excludedTables,
        includedColumns: database.includedColumns,
        excludedColumns: database.excludedColumns
        }, debeziumConfigs);
    
    debeziumConfigs[POSTGRESQL_DATABASE_NAME] = database.databaseName;
    populateSchemaConfigurations(database, debeziumConfigs);

    // Replication configuration (fields inlined from ReplicationConfiguration)
    debeziumConfigs[POSTGRESQL_PLUGIN_NAME] = database.pluginName;
    debeziumConfigs[POSTGRESQL_SLOT_NAME] = database.slotName;
    debeziumConfigs[SLOT_DROP_ON_STOP] = database.slotDropOnStop.toString();
    string? slotStreamParams = database.slotStreamParams;
    if slotStreamParams !is () {
        debeziumConfigs[SLOT_STREAM_PARAMS] = slotStreamParams;
    }

    // Publication configuration (fields inlined from PublicationConfiguration)
    debeziumConfigs[POSTGRESQL_PUBLICATION_NAME] = database.publicationName;
    debeziumConfigs[PUBLICATION_AUTOCREATE_MODE] = database.publicationAutocreateMode.toString();

    // Streaming configuration (fields inlined from StreamingConfiguration)
    debeziumConfigs[STATUS_UPDATE_INTERVAL_MS] = database.statusUpdateIntervalMs.toString();
    debeziumConfigs[XMIN_FETCH_INTERVAL_MS] = database.xminFetchIntervalMs.toString();
    LsnFlushMode? lsnFlushMode = database.lsnFlushMode;
    if lsnFlushMode !is () {
        debeziumConfigs[LSN_FLUSH_MODE] = lsnFlushMode.toString();
    }

    // Data handling configuration (fields inlined from DataHandlingConfiguration)
    debeziumConfigs[UNAVAILABLE_VALUE_PLACEHOLDER] = database.unavailableValuePlaceholder;
}

// Populates schema inclusion/exclusion configurations
isolated function populateSchemaConfigurations(PostgresDatabaseConnection connection, map<string> debeziumConfigs) {
    string|string[]? includedSchemas = connection.includedSchemas;
    if includedSchemas !is () {
        debeziumConfigs[SCHEMA_INCLUDE_LIST] = includedSchemas is string ? includedSchemas : string:'join(",", ...includedSchemas);
    }

    string|string[]? excludedSchemas = connection.excludedSchemas;
    if excludedSchemas !is () {
        debeziumConfigs[SCHEMA_EXCLUDE_LIST] = excludedSchemas is string ? excludedSchemas : string:'join(",", ...excludedSchemas);
    }
}

const string SNAPSHOT_LOCK_TIMEOUT_MS = "snapshot.lock.timeout.ms";

// Populates PostgreSQL-specific options
isolated function populateOptions(PostgreSqlOptions options, map<string> debeziumConfigs) {
    // Populate PostgreSQL-specific extended snapshot configuration
    ExtendedSnapshotConfiguration? extendedSnapshot = options.extendedSnapshot;
    if extendedSnapshot is ExtendedSnapshotConfiguration {
        populateExtendedSnapshotConfiguration(extendedSnapshot, debeziumConfigs);
    }

    // PostgreSQL uses generic cdc:DataTypeConfiguration (no PostgreSQL-specific extensions)
    cdc:DataTypeConfiguration? dataTypeConfig = options.dataTypeConfig;
    if dataTypeConfig is cdc:DataTypeConfiguration {
        cdc:populateDataTypeConfiguration(dataTypeConfig, debeziumConfigs);
    }

    // Populate common options from cdc module
    cdc:populateOptions(options, debeziumConfigs, typeof options);
}

// Populates PostgreSQL-specific extended snapshot properties
isolated function populateExtendedSnapshotConfiguration(ExtendedSnapshotConfiguration config, map<string> debeziumConfigs) {
    cdc:populateRelationalExtendedSnapshotConfiguration(config, debeziumConfigs);
    debeziumConfigs[SNAPSHOT_LOCK_TIMEOUT_MS] = getMillisecondValueOf(config.lockTimeout);
}

isolated function getMillisecondValueOf(decimal value) returns string {
    string milliSecondVal = (value * 1000).toBalString();
    return milliSecondVal.substring(0, milliSecondVal.indexOf(".") ?: milliSecondVal.length());
}
