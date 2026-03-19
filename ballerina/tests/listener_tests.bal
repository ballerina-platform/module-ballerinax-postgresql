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

import ballerina/lang.runtime;
import ballerina/test;
import ballerinax/cdc;
import ballerinax/postgresql.cdc.driver as _;

string cdcUsername = "postgres";
string cdcPassword = "root@123";
string cdcDatabase = "store_db";
int cdcPort = 5430;
decimal sleepBetweenSteps = 10;

cdc:Service testService = service object {
    remote function onCreate(record {} after, string tableName = "") returns error? {
    }
};

function getDummyPostgresqlListener() returns CdcListener {
    return new ({
        database: {
            username: "testUser",
            password: "testPassword",
            databaseName: "test"
        }
    });
}

@test:Config {
    groups: ["cdc"]
}
function testStartingWithoutAService() returns error? {
    CdcListener postgresqlListener = getDummyPostgresqlListener();
    cdc:Error? result = postgresqlListener.'start();
    test:assertEquals(result is () ? "" : result.message(), "Cannot start the listener without at least one attached service.");
}

@test:Config {
    groups: ["cdc"]
}
function testStopWithoutStart() returns error? {
    CdcListener postgresqlListener = getDummyPostgresqlListener();
    error? result = postgresqlListener.gracefulStop();
    test:assertTrue(result is ());
}

@test:Config {
    groups: ["cdc"]
}
function testStartWithConflictingServices() returns error? {
    CdcListener postgresqlListener = getDummyPostgresqlListener();

    cdc:Service service1 = service object {
        remote function onCreate(record {} after, string tableName) returns error? {
        }
    };

    cdc:Service service2 = service object {
        remote function onCreate(record {} after, string tableName) returns error? {
        }
    };

    check postgresqlListener.attach(service1);
    cdc:Error? result = postgresqlListener.attach(service2);
    test:assertEquals(result is () ? "" : result.message(),
            "The 'cdc:ServiceConfig' annotation is mandatory when attaching multiple services to the 'cdc:Listener'.");
    check postgresqlListener.detach(service1);
}

@test:Config {
    groups: ["cdc"]
}
function testStartWithServicesWithSameAnnotation() returns error? {
    CdcListener postgresqlListener = getDummyPostgresqlListener();

    cdc:Service service1 = @cdc:ServiceConfig {
        tables: "table1"
    } service object {
        remote function onCreate(record {} after, string tableName = "table1") returns error? {
        }
    };

    cdc:Service service2 = @cdc:ServiceConfig {
        tables: "table1"
    } service object {
        remote function onCreate(record {} after, string tableName = "table1") returns error? {
        }
    };

    check postgresqlListener.attach(service1);
    error? result = postgresqlListener.attach(service2);
    test:assertEquals(result is () ? "" : result.message(),
            "Multiple services cannot be used to receive events from the same table 'table1'.");
    check postgresqlListener.detach(service1);
}

@test:Config {
    groups: ["cdc"]
}
function testAttachAfterStart() returns error? {
    CdcListener postgresqlListener = new ({
        database: {
            username: cdcUsername,
            password: cdcPassword,
            port: cdcPort,
            databaseName: cdcDatabase
        },
        options: {
            snapshotMode: cdc:NO_DATA
        }
    });
    check postgresqlListener.attach(testService);
    check postgresqlListener.'start();
    error? result = postgresqlListener.attach(testService);
    test:assertEquals(result is () ? "" : result.message(),
            "Cannot attach a CDC service to the listener once it is running.");
    check postgresqlListener.immediateStop();
}

@test:Config {
    groups: ["cdc"],
    dependsOn: [testAttachAfterStart]
}
function testDetachAfterStart() returns error? {
    CdcListener postgresqlListener = new ({
        database: {
            username: cdcUsername,
            password: cdcPassword,
            port: cdcPort,
            databaseName: cdcDatabase
        },
        options: {
            snapshotMode: cdc:NO_DATA
        }
    });

    check postgresqlListener.attach(testService);
    check postgresqlListener.'start();
    error? result = postgresqlListener.detach(testService);
    test:assertEquals(result is () ? "" : result.message(),
            "Cannot detach a CDC service from the listener once it is running.");
    check postgresqlListener.gracefulStop();
}

cdc:Service postgresqlTestService =
@cdc:ServiceConfig {tables: "store_db.public.products"}
service object {
    remote function onCreate(record {} after, string tableName) returns error? {
        createEventCount = createEventCount + 1;
    }

    remote function onUpdate(record {} before, record {} after, string tableName) returns error? {
        updateEventCount = updateEventCount + 1;
    }

    remote function onDelete(record {} before, string tableName) returns error? {
        deleteEventCount = deleteEventCount + 1;
    }

    remote function onRead(record {} before, string tableName) returns error? {
        readEventCount = readEventCount + 1;
    }
};

cdc:Service postgresqlDataBindingFailService =
@cdc:ServiceConfig {tables: "store_db.public.vendors"}
service object {

    remote function onCreate(WrongVendor after) returns error? {
        createEventCount = createEventCount + 1;
    }

    remote function onError(cdc:Error e) returns error? {
        onErrorCount = onErrorCount + 1;
    }
};

type WrongVendor record {|
    int test;
|};

final Client postgresqlClient = check new (
    host = "localhost",
    port = cdcPort,
    username = cdcUsername,
    password = cdcPassword,
    database = cdcDatabase
);

int createEventCount = 0;
int updateEventCount = 0;
int deleteEventCount = 0;
int readEventCount = 0;
int onErrorCount = 0;

@test:Config {
    groups: ["cdc"],
    dependsOn: [testDetachAfterStart]
}
function testCdcListenerEvents() returns error? {
    CdcListener testListener = new ({
        database: {
            username: cdcUsername,
            password: cdcPassword,
            port: cdcPort,
            databaseName: cdcDatabase
        }
    });

    check testListener.attach(postgresqlTestService);
    check testListener.attach(postgresqlDataBindingFailService);
    check testListener.start();
    runtime:sleep(sleepBetweenSteps);

    test:assertEquals(readEventCount, 2, msg = "READ event count mismatch.");

    // Test CREATE event
    _ = check postgresqlClient->execute(
        `INSERT INTO products (id, name, price, description, vendor_id) 
        VALUES (1103, 'Product A', 10.0, 'testProduct', 1)`);
    runtime:sleep(sleepBetweenSteps);
    test:assertEquals(createEventCount, 1, msg = "CREATE event count mismatch.");

    // Test UPDATE event
    _ = check postgresqlClient->execute(
        `UPDATE products SET price = 15.0 WHERE id = 1103`);
    runtime:sleep(sleepBetweenSteps);
    test:assertEquals(updateEventCount, 1, msg = "UPDATE event count mismatch.");

    // Test DELETE event
    _ = check postgresqlClient->execute(
        `DELETE FROM products WHERE id = 1103`);
    runtime:sleep(sleepBetweenSteps);
    test:assertEquals(deleteEventCount, 1, msg = "DELETE event count mismatch.");

    // Test CREATE event for vendors table
    _ = check postgresqlClient->execute(
        `INSERT INTO vendors (id, name, contact_info) 
        VALUES (201, 'Vendor A', 'contact@vendora.com')`);
    runtime:sleep(sleepBetweenSteps);
    test:assertEquals(onErrorCount, 3, msg = "Error count mismatch.");
    // 1,2 for onRead method not present, 3 for payload binding failure

    check testListener.gracefulStop();
}

@test:Config {groups: ["postgres-replication"]}
function testPostgresReplicationConfiguration() {
    map<string> expectedProperties = {
        "plugin.name": "decoderbufs",
        "slot.name": "custom_slot",
        "slot.drop.on.stop": "true",
        "slot.stream.params": "include-unchanged-toast=true"
    };

    PostgresDatabaseConnection connection = {
        username: "testuser",
        password: "testpass",
        databaseName: "testdb",
        replicationConfig: {
            pluginName: DECODERBUFS,
            slotName: "custom_slot",
            slotDropOnStop: true,
            slotStreamParams: "include-unchanged-toast=true"
        }
    };

    map<string> actualProperties = {};
    populateDatabaseConfigurations(connection, actualProperties);

    test:assertEquals(actualProperties["plugin.name"],
        expectedProperties["plugin.name"],
        msg = "Plugin name does not match.");
    test:assertEquals(actualProperties["slot.drop.on.stop"],
        expectedProperties["slot.drop.on.stop"],
        msg = "Slot drop on stop does not match.");
}

@test:Config {groups: ["postgres-publication"]}
function testPostgresPublicationConfiguration() {
    map<string> expectedProperties = {
        "publication.name": "my_publication",
        "publication.autocreate.mode": "filtered"
    };

    PostgresDatabaseConnection connection = {
        username: "testuser",
        password: "testpass",
        databaseName: "testdb",
        publicationConfig: {
            publicationName: "my_publication",
            publicationAutocreateMode: FILTERED
        }
    };

    map<string> actualProperties = {};
    populateDatabaseConfigurations(connection, actualProperties);

    test:assertEquals(actualProperties["publication.name"],
        expectedProperties["publication.name"],
        msg = "Publication name does not match.");
    test:assertEquals(actualProperties["publication.autocreate.mode"],
        expectedProperties["publication.autocreate.mode"],
        msg = "Publication autocreate mode does not match.");
}

@test:Config {groups: ["postgres-streaming"]}
function testPostgresStreamingConfiguration() {
    map<string> expectedProperties = {
        "status.update.interval.ms": "5000",
        "xmin.fetch.interval.ms": "1000",
        "lsn.flush.mode": "connector"
    };

    PostgresDatabaseConnection connection = {
        username: "testuser",
        password: "testpass",
        databaseName: "testdb",
        streamingConfig: {
            statusUpdateInterval: 5.0,
            xminFetchInterval: 1,
            lsnFlushMode: CONNECTOR
        }
    };

    map<string> actualProperties = {};
    populateDatabaseConfigurations(connection, actualProperties);

    test:assertEquals(actualProperties["status.update.interval.ms"],
        expectedProperties["status.update.interval.ms"],
        msg = "Status update interval does not match.");
    test:assertEquals(actualProperties["lsn.flush.mode"],
        expectedProperties["lsn.flush.mode"],
        msg = "LSN flush mode does not match.");
}

@test:Config {groups: ["postgres-relational"]}
function testPostgresRelationalCommonConfiguration() {
    map<string> expectedProperties = {
        "schema.include.list": "public,custom"
    };

    PostgresDatabaseConnection connection = {
        username: "testuser",
        password: "testpass",
        databaseName: "testdb",
        includedSchemas: ["public", "custom"]
    };

    map<string> actualProperties = {};
    populateDatabaseConfigurations(connection, actualProperties);

    test:assertEquals(actualProperties["schema.include.list"],
        expectedProperties["schema.include.list"],
        msg = "Schema include list does not match.");
}

@test:Config {groups: ["postgres-relational"]}
function testPostgresRelationalFilteringConfiguration() {
    map<string> expectedProperties = {
        "schema.include.list": "public,custom",
        "table.include.list": "public.users,public.orders",
        "column.exclude.list": "public.*.password,public.*.ssn",
        "message.key.columns": "public.users:id;public.orders:order_id"
    };

    PostgresDatabaseConnection connection = {
        username: "testuser",
        password: "testpass",
        databaseName: "testdb",
        includedSchemas: ["public", "custom"],
        includedTables: ["public.users", "public.orders"],
        excludedColumns: ["public.*.password", "public.*.ssn"],
        messageKeyColumns: [
            {tableName: "public.users", columns: ["id"]},
            {tableName: "public.orders", columns: ["order_id"]}
        ]
    };

    map<string> actualProperties = {};
    populateDatabaseConfigurations(connection, actualProperties);

    test:assertEquals(actualProperties["schema.include.list"],
        expectedProperties["schema.include.list"],
        msg = "Schema include list does not match.");
    test:assertEquals(actualProperties["table.include.list"],
        expectedProperties["table.include.list"],
        msg = "Table include list does not match.");
    test:assertEquals(actualProperties["column.exclude.list"],
        expectedProperties["column.exclude.list"],
        msg = "Column exclude list does not match.");
    test:assertEquals(actualProperties["message.key.columns"],
        expectedProperties["message.key.columns"],
        msg = "Message key columns does not match.");
}

@test:Config {groups: ["postgres-snapshot"]}
function testPostgresExtendedSnapshotConfiguration() {
    map<string> expectedProperties = {
        "snapshot.lock.timeout.ms": "20000"
    };

    PostgreSqlOptions options = {
        extendedSnapshot: {
            lockTimeout: 20
        }
    };

    map<string> actualProperties = {};
    populateOptions(options, actualProperties);

    test:assertEquals(actualProperties["snapshot.lock.timeout.ms"],
        expectedProperties["snapshot.lock.timeout.ms"],
        msg = "Snapshot lock timeout does not match.");
}

@test:Config {groups: ["postgres-options"]}
function testPostgresOptionsWithHeartbeat() {
    map<string> expectedProperties = {
        "heartbeat.interval.ms": "15000",
        "heartbeat.action.query": "SELECT NOW()"
    };

    PostgreSqlOptions options = {
        heartbeatConfig: {
            interval: 15,
            actionQuery: "SELECT NOW()"
        }
    };

    map<string> actualProperties = {};
    cdc:populateOptions(options, actualProperties);
    populateOptions(options, actualProperties);

    test:assertEquals(actualProperties["heartbeat.interval.ms"],
        expectedProperties["heartbeat.interval.ms"],
        msg = "Heartbeat interval does not match.");
    test:assertEquals(actualProperties["heartbeat.action.query"],
        expectedProperties["heartbeat.action.query"],
        msg = "Heartbeat action query does not match.");
}
