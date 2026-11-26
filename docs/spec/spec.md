# Specification: Ballerina PostgreSQL Library

_Owners_: @niveathika @aashikam @shafreenAnfar  
_Reviewers_:  
_Created_: 2022/01/14  
_Updated_: 2026/11/26  
_Edition_: Swan Lake  

## Introduction

This is the specification for the PostgreSQL connector of the [Ballerina language](https://ballerina.io/), `ballerinax/postgresql`, which provides a client for PostgreSQL databases built on the `ballerina/sql` library, typed values for PostgreSQL data types, and a change data capture (CDC) listener for PostgreSQL built on the `ballerinax/cdc` library.

This specification is the contract of the library. It defines the observable behaviour of the connector: the configuration it accepts, how it connects to the database, how it changes the default behaviour of the `ballerina/sql` library, the PostgreSQL-specific values it binds and reads, the errors it returns, and what it rejects at compile time. The behaviour that the connector takes unchanged from `ballerina/sql` is specified in the [SQL specification](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md) and is not repeated here. A behaviour of the implementation that differs from this specification is a bug in the implementation. A behaviour that this specification does not define is a gap in the specification, and is also reported as a bug. Signatures and per-symbol documentation are part of the [API documentation](https://central.ballerina.io/ballerinax/postgresql/latest), and usage examples are part of [Ballerina by Example](https://ballerina.io/learn/by-example/). Neither is repeated here.

The released versions of the specification can be found under the relevant GitHub tag. Changes to the specification follow the proposal process described in the [library development process](https://github.com/ballerina-platform/ballerina-library/blob/main/docs/library-development-process.md). If you have any feedback or suggestions about the library, start a discussion via a [GitHub issue](https://github.com/ballerina-platform/ballerina-library/issues) or in the [Discord server](https://discord.gg/ballerinalang).

### Notation

- The key words MUST, MUST NOT, REQUIRED, SHALL, SHALL NOT, SHOULD, SHOULD NOT, RECOMMENDED, MAY and OPTIONAL are interpreted as described in [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119) and [RFC 8174](https://www.rfc-editor.org/rfc/rfc8174) when, and only when, they appear in all capitals. Other statements of behaviour in the present tense are also normative.
- Examples and notes are informative.
- "SQL §*n*" refers to section *n* of the [SQL specification](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md). A table row of the SQL specification is identified by the value of its first cell, as described in [SQL §17.1](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#171-description).
- _Implementation-defined_ behaviour is chosen and documented by the implementation; _unspecified_ behaviour must not be relied on. _Driver-defined_ behaviour is that of the PostgreSQL JDBC driver (pgjdbc) in use.
- PostgreSQL types are written with their PostgreSQL names, e.g. `timestamptz`; JDBC types are written as the names of `java.sql.Types`, e.g. `TIMESTAMP`, as in the SQL specification. Time values are in seconds unless stated otherwise.

## Contents

- [1. Overview](#1-overview)
- [2. Terminology](#2-terminology)
- [3. Client](#3-client)
    - [3.1. Description](#31-description)
    - [3.2. Configuration](#32-configuration)
    - [3.3. Driver](#33-driver)
    - [3.4. Connection URL](#34-connection-url)
    - [3.5. Operations](#35-operations)
    - [3.6. Compile-time validation](#36-compile-time-validation)
    - [3.7. Errors](#37-errors)
    - [3.8. Interactions](#38-interactions)
- [4. Connection options](#4-connection-options)
    - [4.1. Description](#41-description)
    - [4.2. Configuration](#42-configuration)
    - [4.3. Driver properties](#43-driver-properties)
    - [4.4. Compile-time validation](#44-compile-time-validation)
    - [4.5. Errors](#45-errors)
    - [4.6. Interactions](#46-interactions)
- [5. SSL/TLS](#5-ssltls)
    - [5.1. Description](#51-description)
    - [5.2. Configuration](#52-configuration)
    - [5.3. Behaviour](#53-behaviour)
    - [5.4. Errors](#54-errors)
- [6. Parameter binding](#6-parameter-binding)
    - [6.1. Description](#61-description)
    - [6.2. Changes to the default binding](#62-changes-to-the-default-binding)
    - [6.3. Driver-defined outcomes](#63-driver-defined-outcomes)
    - [6.4. Errors](#64-errors)
- [7. PostgreSQL typed values](#7-postgresql-typed-values)
    - [7.1. Description](#71-description)
    - [7.2. Value records](#72-value-records)
    - [7.3. Typed value classes](#73-typed-value-classes)
    - [7.4. Typed array value classes](#74-typed-array-value-classes)
    - [7.5. Errors](#75-errors)
    - [7.6. Interactions](#76-interactions)
- [8. Result mapping](#8-result-mapping)
    - [8.1. Description](#81-description)
    - [8.2. Result conversion](#82-result-conversion)
    - [8.3. PostgreSQL column types](#83-postgresql-column-types)
    - [8.4. PostgreSQL record targets](#84-postgresql-record-targets)
    - [8.5. Time zones](#85-time-zones)
    - [8.6. Errors](#86-errors)
- [9. Stored procedure calls](#9-stored-procedure-calls)
    - [9.1. Description](#91-description)
    - [9.2. Behaviour](#92-behaviour)
    - [9.3. OUT parameter classes](#93-out-parameter-classes)
    - [9.4. INOUT parameters](#94-inout-parameters)
    - [9.5. Compile-time validation](#95-compile-time-validation)
    - [9.6. Errors](#96-errors)
- [10. Connector contract](#10-connector-contract)
    - [10.1. Description](#101-description)
    - [10.2. Obligations](#102-obligations)
    - [10.3. Override points](#103-override-points)
- [11. Observability](#11-observability)
    - [11.1. Description](#111-description)
    - [11.2. Metric tags](#112-metric-tags)
- [12. Change data capture listener](#12-change-data-capture-listener)
    - [12.1. Description](#121-description)
    - [12.2. Configuration](#122-configuration)
    - [12.3. Behaviour](#123-behaviour)
    - [12.4. Errors](#124-errors)
    - [12.5. Interactions](#125-interactions)
- [13. Security considerations](#13-security-considerations)
- [14. Planned changes](#14-planned-changes)
- [References](#references)

## 1. Overview

The `postgresql:Client` class includes `sql:Client`. It connects to a PostgreSQL server through pgjdbc and a connection pool of the `ballerina/sql` library, and executes the operations of `sql:Client` (`query`, `queryRow`, `execute`, `batchExecute`, `call` and `close`) as specified in the SQL specification. This specification states how the client is configured, how its configuration becomes a connection URL and driver properties, and where its behaviour differs from the default behaviour of the SQL specification.

The connector adds typed values for PostgreSQL types that have no counterpart in the SQL specification, such as network addresses, geometric types, ranges, intervals, JSON and enumerated types, together with records that represent their values, OUT parameter classes for them, and its own `InOutParameter` class. Query results of these types can be read into strings, into JSON values, or into the connector's records.

The `postgresql:CdcListener` class is a listener of the `ballerinax/cdc` library that captures row changes through PostgreSQL logical replication. This specification states its PostgreSQL-specific configuration; services, events and the common configuration are specified by the `ballerinax/cdc` library.

## 2. Terminology

The terms of [SQL §2](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#2-terminology) apply. In addition:

| Term | Meaning |
|---|---|
| Driver | The PostgreSQL JDBC driver, pgjdbc, on the program's class path. |
| Driver property | A property of the pgjdbc data source, set by the connector from its configuration. |
| PostgreSQL typed value | An object of a typed value class of this connector ([§7.3](#73-typed-value-classes), [§7.4](#74-typed-array-value-classes)), which includes `sql:TypedValue`. |
| Value record | A record type of this connector that represents the value of a PostgreSQL type, such as `postgresql:Point` ([§7.2](#72-value-records)). |
| Session time zone | The PostgreSQL `TimeZone` setting of a connection ([§8.5](#85-time-zones)). |
| Text form | The text representation of a value that PostgreSQL accepts as input and returns as output for its type, e.g. `(1,2)` for a `point`. |
| Range record | A value record of a range type: `postgresql:Range` and the records that include it. |
| Debezium property | A configuration property of the Debezium PostgreSQL connector, which the CDC listener runs. |

## 3. Client

### 3.1. Description

`postgresql:Client` is a client of a PostgreSQL database. Its initializer builds a connection URL and driver properties from its parameters and creates the client through the `sql` library ([SQL §3.3.1](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#331-creation)).

### 3.2. Configuration

The initializer takes the following parameters.

| Parameter | Type | Default | Meaning |
|---|---|---|---|
| `host` | `string` | `"localhost"` | Host name or IP address of the server. Used in the URL as given ([§3.4](#34-connection-url)). `""` means no host in the URL, so the driver connects to `localhost` (driver-defined). |
| `username` | `string?` | `"postgres"` | User name. `()` means no user is given to the driver, which then uses the name of the operating system user that runs the program (driver-defined). |
| `password` | `string?` | `()` | Password. `()` means no password is given to the driver. |
| `database` | `string?` | `()` | Database to connect to. `()` and `""` mean no database is given in the URL, and the server uses the database with the same name as the user (driver-defined). |
| `port` | `int` | `5432` | Port of the server. A value less than or equal to `0` means no port is given in the URL, so the driver uses its default port, `5432`. |
| `options` | `postgresql:Options?` | `()` | Connection options ([§4](#4-connection-options)). |
| `connectionPool` | `sql:ConnectionPool?` | `()` | Pool configuration ([SQL §4](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#4-connection-pool)). `()` means the global pool configuration ([SQL §4.5](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#45-global-pool-configuration)). |

### 3.3. Driver

1. The connector does not contain the driver. The program MUST provide it, for example by importing `ballerinax/postgresql.driver` or by adding a pgjdbc JAR as a platform dependency.
2. The connector always gives the data source class name `org.postgresql.ds.PGSimpleDataSource`. The URL, the user, the password and the driver properties are therefore set as data source properties ([SQL §4.7](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#47-pool-creation) rule 7). The connector provides no XA data source.
3. If the data source class cannot be loaded, the initializer returns an `sql:ApplicationError` ([SQL §4.10](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#410-errors)).

### 3.4. Connection URL

The connector builds the URL as follows:

1. The URL starts with `jdbc:postgresql://` followed by `host`.
2. If `port` is greater than `0`, `:` and `port` are appended.
3. `/` is appended.
4. If `database` is neither `()` nor `""`, `database` is appended.
5. The connector does not validate, escape or encode `host` or `database`; they are inserted into the URL as given and MUST be trusted input. The driver interprets characters that have a meaning in the URL syntax as further URL parts or properties: for example, the `database` `"shop?sslmode=disable"` connects to `shop` with TLS disabled ([§13](#13-security-considerations)).
6. When `host` or `database` contains one of the characters `/`, `?`, `&`, `;`, `=`, `(`, `)`, `#` and `,`, the initializer logs a warning and creates the client as rule 5 states.

The URL and the driver property map are the pool key of the client ([SQL §4.6](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#46-pool-selection)), so clients with equal parameters and equal options share a pool.

### 3.5. Operations

1. `query`, `queryRow`, `execute`, `batchExecute`, `call` and `close` behave as specified in [SQL §3](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#3-client) and [SQL §8](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#8-query) to [SQL §13](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#13-transactions), with the connector's binding ([§6](#6-parameter-binding), [§7](#7-postgresql-typed-values)), result conversion ([§8](#8-result-mapping)) and procedure call behaviour ([§9](#9-stored-procedure-calls)).
2. The client requests generated keys for both `execute` and `batchExecute`, so `lastInsertId` is set as specified in [SQL §10.4](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#104-generated-keys), except for a DDL statement, as SQL §10.4 rule 1 recognises it, which is prepared without a generated-keys request. The `generatedKeysMode` field of `postgresql:Options` ([§4.2](#42-configuration)) selects the `sql:GeneratedKeysMode` of [SQL §10.4](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#104-generated-keys) rule 7. It is `sql:ALL_STATEMENTS` by default; with `sql:INSERT_ONLY`, generated keys are requested only for the statements that rule names, and every other statement, including `UPDATE` and `DELETE`, gives a `lastInsertId` of `()`.
3. When generated keys are requested, the driver appends `RETURNING *` to an `INSERT`, `UPDATE` or `DELETE` statement that has no `RETURNING` clause, so the generated keys are all columns of the affected rows. Therefore `lastInsertId` is the value of the first column of the table in the first affected row, whether or not that column is generated, and it is also set for `UPDATE` and `DELETE` statements that affect rows. For a statement with its own `RETURNING` clause, `lastInsertId` is the first returned column. This behaviour is driver-defined.

#### 3.5.1. Example: Generated keys

```ballerina
import ballerina/sql;
import ballerinax/postgresql;

# Adds an author and returns its generated ID.
function addAuthor(postgresql:Client db, string name) returns int|sql:Error {
    sql:ExecutionResult result = check db->execute(`INSERT INTO authors (name) VALUES (${name}) RETURNING id`);
    return <int>result.lastInsertId;
}
```

For a table `authors (name text, id serial)`, the statement returns the new `id`, so `lastInsertId` is that `int` ([§3.5](#35-operations) rule 3). Without `RETURNING id`, `lastInsertId` would be the inserted `name`, a `string`, because `name` is the first column of the table, and the cast in the example would panic.

### 3.6. Compile-time validation

The `ballerinax/postgresql` compiler plugin checks each `new` expression whose type is `postgresql:Client`. It checks the `connectionPool` argument when it is a mapping constructor, given as a named argument or as the seventh positional argument in a call without named arguments. For each field whose value is a numeric literal, optionally preceded by a unary `-`, it reports `SQL_101`, `SQL_102` and `SQL_103` under the conditions of the table of [SQL §4.9](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#49-compile-time-validation).

1. Values that are not literals, including the fields given through a spread, are not checked, and the build does not fail because of them.
2. The plugin does not check a module whose compilation already has errors.
3. A numeric literal is checked by its value, whatever its form: a hexadecimal literal such as `0x10` is checked as `16`, and a literal outside the range of a 32-bit integer, such as `3000000000`, is checked by its value.
4. The `options` argument is checked as specified in [§4.4](#44-compile-time-validation).

Values the plugin does not check are checked at run time ([SQL §4.7](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#47-pool-creation) step 3). A `sql:ConnectionPool` variable declaration is checked by the `sql` compiler plugin ([SQL §4.9](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#49-compile-time-validation)).

### 3.7. Errors

| Condition | Error |
|---|---|
| The data source class cannot be loaded (no driver) | `sql:ApplicationError`, returned by the initializer |
| Pool creation or the verification connection fails, including an unreachable server, failed authentication, an unknown database and a failed TLS handshake | As specified in [SQL §3.5](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#35-errors) and [SQL §4.10](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#410-errors) |
| Any other failure | As specified in [SQL §15](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#15-errors) |

### 3.8. Interactions

- A client given no `connectionPool` uses the global pool configuration, so clients with equal URLs and driver property maps share one pool ([SQL §4.6](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#46-pool-selection)); the outcome for a client whose `username` or `password` differs from that pool's is that of SQL §4.6 rule 6.
- `options` are part of the pool key through the driver property map ([§4.3](#43-driver-properties)): two clients whose `options` give different driver property maps use different pools. Timeout fields that are not given set no driver property, so they do not change the map. `options` `()` gives no driver property map, and `{}` gives a map that holds `sslmode` ([§5.3](#53-behaviour) rule 2); an absent map and a map are different keys ([SQL §4.6](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#46-pool-selection) rule 2), so clients whose `options` differ only in `()` and `{}` use different pools.

### 3.9. Example: Client creation

```ballerina
import ballerinax/postgresql;
import ballerinax/postgresql.driver as _;

# Creates a client of the `shop` database on port 5433.
function createShopClient() returns postgresql:Client|error {
    return new ("db.example.com", "app", "secret", "shop", 5433, connectionPool = {maxOpenConnections: 5});
}
```

The URL is `jdbc:postgresql://db.example.com:5433/shop` ([§3.4](#34-connection-url)), no driver property is set because `options` is `()` ([§4.3](#43-driver-properties) rule 1), and the client gets a pool of its own because its pool configuration is written inline ([SQL §4.6](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#46-pool-selection)).

## 4. Connection options

### 4.1. Description

`postgresql:Options` configures the connections to the server. The connector converts it to driver properties.

### 4.2. Configuration

`postgresql:Options` is a closed record. Time values are in seconds.

| Field | Type | Default | Meaning |
|---|---|---|---|
| `ssl` | `postgresql:SecureSocket` | absent | TLS configuration ([§5](#5-ssltls)). Absent: see [§5.3](#53-behaviour) rules 1 and 2. |
| `connectTimeout` | `decimal` | absent | Timeout for opening a connection to the server. `0` means no timeout. Absent and negative values mean the driver's default, `10` seconds. |
| `socketTimeout` | `decimal` | absent | Timeout for each read from the connection's socket. `0` means no timeout. Absent and negative values mean the driver's default, which is no timeout. |
| `loginTimeout` | `decimal` | absent | Timeout for establishing a connection, including authentication. `0` means no timeout. Absent and negative values mean the driver's default, which is no timeout. |
| `rowFetchSize` | `int` | absent | Number of rows fetched from the server in one round trip. Absent, `0` and negative values mean the driver's default, which fetches all rows at once. The driver uses the fetch size only in some cases, such as inside a transaction (driver-defined). |
| `cachedMetadataFieldsCount` | `int` | absent | Maximum number of fields whose metadata is cached per connection. `0` disables the cache. Absent and negative values mean the driver's default, `65536`. |
| `cachedMetadataFieldSize` | `int` | absent | Maximum size of the field metadata cache per connection, in mebibytes. `0` disables the cache. Absent and negative values mean the driver's default, `5`. |
| `preparedStatementThreshold` | `int` | absent | Number of executions of a prepared statement after which the driver uses a server-side prepared statement. `0` disables server-side prepared statements. Absent and negative values mean the driver's default, `5`. |
| `preparedStatementCacheQueries` | `int` | absent | Number of queries cached per connection. `0` disables the cache. Absent and negative values mean the driver's default, `256`. |
| `preparedStatementCacheSize` | `int` | absent | Maximum size of the query cache per connection, in mebibytes. `0` disables the cache. Absent and negative values mean the driver's default, `5`. |
| `cancelSignalTimeout` | `decimal` | absent | Timeout for sending the cancel request, which the driver sends on a separate connection. `0` means no timeout. Absent and negative values mean the driver's default, `10` seconds. |
| `keepAliveTcpProbe` | `boolean` | absent | Whether TCP keep-alive probes are enabled. Absent means the driver's default, `false`. |
| `binaryTransfer` | `boolean` | absent | Whether the driver uses the binary format for the values of the types that support it. Absent means the driver's default, `true`. |
| `currentSchema` | `string` | absent | Schema search path of the connections, for example `"inventory"`, so that unqualified names are resolved in that schema. Absent means the server's default. `""` gives the connections an empty schema search path: only the system schemas are searched for unqualified names, and creating an object with an unqualified name results in an `sql:DatabaseError`. |
| `stringType` | `VARCHAR` or `UNSPECIFIED` | `VARCHAR` | How `string` values and the string forms of the character typed values are sent ([§6.3](#63-driver-defined-outcomes) rule 1). `UNSPECIFIED` sets the driver property `stringtype` to `unspecified`; `VARCHAR` sets no driver property. |
| `generatedKeysMode` | `sql:GeneratedKeysMode` | `sql:ALL_STATEMENTS` | The statements for which generated keys are requested ([§3.5](#35-operations) rule 2). It sets no driver property and is not part of the pool key ([SQL §4.6](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#46-pool-selection) rule 7). |

The driver applies the timeouts in whole seconds; how a value with a fractional part is rounded is _unspecified_.

### 4.3. Driver properties

1. When `options` is `()`, the connector sets no driver property, and the driver defaults apply to every option, including TLS ([§5.3](#53-behaviour)).
2. When `options` is given, the connector sets the following driver properties:
    1. `ssl`: as specified in [§5.3](#53-behaviour).
    2. `connectTimeout`, `socketTimeout`, `loginTimeout` and `cancelSignalTimeout`: the field's value in seconds, each when its field is present and not negative. A timeout field that is not given sets no driver property, so the driver's default applies whether or not `options` is given.
    3. `defaultRowFetchSize`: `rowFetchSize`, when it is greater than `0`.
    4. `databaseMetadataCacheFields`: `cachedMetadataFieldsCount`, and `databaseMetadataCacheFieldsMiB`: `cachedMetadataFieldSize`, each when its field is present and not negative.
    5. `prepareThreshold`: `preparedStatementThreshold`, `preparedStatementCacheQueries`: `preparedStatementCacheQueries`, and `preparedStatementCacheSizeMiB`: `preparedStatementCacheSize`, each when its field is present and not negative.
    6. `tcpKeepAlive`: `keepAliveTcpProbe`, `binaryTransfer`: `binaryTransfer`, and `currentSchema`: `currentSchema`, each when its field is present.
    7. `stringtype`: `unspecified`, when `stringType` is `UNSPECIFIED`.
3. The connector gives the pool no property of its own: the wait for a pool connection is set by the `connectionTimeout` field of the pool configuration alone ([SQL §4.7](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#47-pool-creation)), and no option makes client creation fail through the pool.
4. No other driver property can be set through the client. The driver defaults apply to all others.

### 4.4. Compile-time validation

The compiler plugin checks a mapping constructor that is the `options` argument of a `postgresql:Client` `new` expression (as a named argument, or as the sixth positional argument in a call without named arguments), or the initializer of a variable declaration whose type is `postgresql:Options` or a union containing it. For each field whose value is a numeric literal, optionally preceded by a unary `-`, including the fields with default values of a spread record:

| Code | Field | Condition | Kind |
|---|---|---|---|
| `POSTGRESQL_101` | `connectTimeout`, `socketTimeout`, `loginTimeout`, `cancelSignalTimeout`, `preparedStatementThreshold`, `preparedStatementCacheQueries`, `preparedStatementCacheSize` | value less than `0` | error |
| `POSTGRESQL_102` | `rowFetchSize`, `cachedMetadataFieldsCount`, `cachedMetadataFieldSize` | value less than `0` | error |

Rules 1 to 3 of [§3.6](#36-compile-time-validation) apply. The value `0` is accepted for every field; for `cachedMetadataFieldsCount` and `cachedMetadataFieldSize` it disables the cache, and for `rowFetchSize` it means the driver's default ([§4.2](#42-configuration)).

### 4.5. Errors

1. The options are not validated at run time. Setting an option never makes the initializer panic.
2. A value that the driver rejects makes pool creation or the verification connection fail, reported as specified in [§3.7](#37-errors).

### 4.6. Interactions

- A failure caused by `socketTimeout` during an operation is a database error: the operation returns an `sql:DatabaseError` ([SQL §15.3](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#153-mapping)).
- `currentSchema` applies to every statement of the client, including the statements of `call`.

## 5. SSL/TLS

### 5.1. Description

`postgresql:SecureSocket` configures whether and how the connection to the server is encrypted, and the client certificate.

### 5.2. Configuration

`postgresql:SecureSocket` is a closed record.

| Field | Type | Default | Meaning |
|---|---|---|---|
| `mode` | `postgresql:SSLMode` | `PREFER` | TLS mode ([§5.3](#53-behaviour)). |
| `rootcert` | `string` | absent | Path of a file with the certificates of the certificate authorities that the server certificate is verified against. Absent means the driver's default file, `root.crt` in the `.postgresql` directory of the user's home directory (`%APPDATA%\postgresql\root.crt` on Windows). |
| `key` | `crypto:KeyStore\|postgresql:CertKey` | absent | Client certificate and private key. Absent means no client certificate is sent. |

`postgresql:SSLMode` has the members `PREFER` (`"PREFER"`), `REQUIRE` (`"REQUIRE"`), `DISABLE` (`"DISABLE"`), `ALLOW` (`"ALLOW"`), `VERIFY_CA` (`"VERIFY-CA"`) and `VERIFY_FULL` (`"VERIFY-FULL"`).

`postgresql:CertKey` is a closed record:

| Field | Type | Default | Meaning |
|---|---|---|---|
| `certFile` | `string` | Required | Path of the client certificate file. |
| `keyFile` | `string` | Required | Path of the client private key file. |
| `keyPassword` | `string` | absent | Password of the private key, when it is encrypted. |

### 5.3. Behaviour

1. When `options` is `()`, the connector sets no TLS property, and the driver's default mode, `prefer`, applies.
2. When `options` is given without `ssl`, the connector sets the driver property `sslmode` to `DISABLE`, so the connection is not encrypted, and the initializer logs a warning that TLS is disabled. Giving `ssl` explicitly, for example `ssl: {mode: postgresql:DISABLE}` to keep the connection unencrypted, avoids the warning.
3. When `ssl` is given, the connector sets the driver property `sslmode` to the value of `mode`, and the driver property `ssl` to `true`; `sslmode` determines the behaviour.
4. When `key` is a `crypto:KeyStore`, the driver properties `sslkey` and `sslpassword` are set to its `path` and `password`, so the key store is a PKCS #12 file. When `key` is a `postgresql:CertKey`, `sslcert` is set to `certFile`, `sslkey` to `keyFile`, and `sslpassword` to `keyPassword` when it is present.
5. When `rootcert` is present, the driver property `sslrootcert` is set to it.
6. The modes behave as follows (driver-defined):

    | Mode | Behaviour |
    |---|---|
    | `DISABLE` | The connection is not encrypted. |
    | `ALLOW` | The driver first tries an unencrypted connection, and tries an encrypted one only when the server rejects it. |
    | `PREFER` | The driver first tries an encrypted connection, and falls back to an unencrypted one when the server does not support encryption. The server certificate is not verified. |
    | `REQUIRE` | The connection is encrypted; the client fails to connect when the server does not support encryption. The server certificate is not verified. |
    | `VERIFY_CA` | As `REQUIRE`, and the client fails to connect unless the server certificate is issued by a certificate authority of the root certificate file. |
    | `VERIFY_FULL` | As `VERIFY_CA`, and the client fails to connect unless the host name of the server matches the certificate. |

#### 5.3.1. Example: Verified TLS

```ballerina
import ballerinax/postgresql;

# Creates a client that requires a server certificate issued by the given CA for the host name.
function createSecureClient(string caFile) returns postgresql:Client|error {
    postgresql:Options options = {
        ssl: {mode: postgresql:VERIFY_FULL, rootcert: caFile}
    };
    return new ("db.example.com", "app", "secret", "shop", options = options);
}
```

The driver properties include `sslmode` `VERIFY-FULL` and `sslrootcert` `caFile` ([§5.3](#53-behaviour) rules 3 and 5). The client is created only when the server presents a certificate issued by a certificate authority in `caFile` for `db.example.com` (rule 6); otherwise the initializer returns an error ([§5.4](#54-errors)).

### 5.4. Errors

| Condition | Error |
|---|---|
| The server does not support encryption with mode `REQUIRE`, `VERIFY_CA` or `VERIFY_FULL`; a certificate or key file cannot be read; the server certificate or host name fails verification | A connection failure, reported as specified in [§3.7](#37-errors) |

## 6. Parameter binding

### 6.1. Description

Parameters are bound as specified in [SQL §6](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#6-parameter-binding), with the changes of this section. PostgreSQL typed values are specified in [§7](#7-postgresql-typed-values).

### 6.2. Changes to the default binding

The connector changes the following rows and rules of the SQL specification. The binding of every other value is that of [SQL §6](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#6-parameter-binding).

| SQL specification row or rule | Change |
|---|---|
| [SQL §6.3](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#63-basic-types) row `xml` | The value is bound as a PostgreSQL `xml` value whose text is the XML serialization of the value. |
| [SQL §6.4](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#64-time-types) rule 2.3 | A `time:TimeOfDay` with `utcOffset` is bound as a PostgreSQL `timetz` value with that offset; the `sql:TypeMismatchError` of the rule does not occur. |
| [SQL §6.5](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#65-arrays) row `byte[]?[]` | The element type is `bytea`. |
| [SQL §6.6](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#66-typed-values) row `sql:CharValue` | `()` is bound as `NULL` (`CHAR`). |
| [SQL §6.6](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#66-typed-values) row `sql:TimeValue` | A `time:TimeOfDay` with `utcOffset` is bound as a `timetz` value, as in the change of [SQL §6.4](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#64-time-types) rule 2.3 above. A `string` value is bound with an unspecified type, so the server converts it to the type of the column or parameter, such as `time` or `timetz`. |
| [SQL §6.6](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#66-typed-values) rows `sql:DateTimeValue` and `sql:TimestampValue` | A `string` value is bound with an unspecified type, so the server converts it to the type of the column or parameter, such as `timestamp` or `timestamptz`. |
| [SQL §6.6](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#66-typed-values) rule 4.3 | `sql:RealValue` binds every accepted value, including a `float`, as the nearest 32-bit floating-point number. |
| [SQL §6.7](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#67-typed-array-values) row `sql:CharArrayValue` | The element type is `character` (`bpchar`). |
| [SQL §6.7](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#67-typed-array-values) row `sql:BinaryArrayValue` | The element type is `bytea`. |
| [SQL §6.7](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#67-typed-array-values) rules 2 and 3 | The element types of `sql:TimeArrayValue` are `time` and `timetz`, and those of `sql:DateTimeArrayValue` and `sql:TimestampArrayValue` are `timestamp` and `timestamptz`, chosen as the rules state. |
| [SQL §6.8](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#68-deprecated-array-value) rule 2 | A `byte[][]` value is bound with the element type `bytea`. |

The other element type names of [SQL §6.5](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#65-arrays) and [SQL §6.7](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#67-typed-array-values) are resolved by the driver: `VARCHAR` as `character varying`, `INTEGER` as `integer`, `BIGINT` as `bigint`, `SMALLINT` as `smallint`, `FLOAT` and `DOUBLE` as `double precision`, `REAL` as `real`, `DECIMAL` and `NUMERIC` as `numeric`, `BOOLEAN` as `boolean`, `BIT` as `bit`, `DATE` as `date`.

### 6.3. Driver-defined outcomes

The following outcomes of the binding are determined by the driver and the server:

1. A `string`, and the string forms of `sql:VarcharValue`, `sql:CharValue` and `sql:TextValue`, are sent as `character varying` values. The server does not convert them implicitly to a column or parameter of another type, such as `integer`, `uuid`, `json` or `xml`, so the operation returns an `sql:DatabaseError`. When the `stringType` field of `postgresql:Options` is `UNSPECIFIED` (the default is `VARCHAR`), the driver property `stringtype` is `unspecified` ([§4.3](#43-driver-properties) rule 2.7); with it, these strings are sent with an unspecified type and the server converts them to the type of the column or parameter. The string forms of `sql:TimeValue`, `sql:DateTimeValue` and `sql:TimestampValue` are bound with an unspecified type ([§6.2](#62-changes-to-the-default-binding)), and the string form of `sql:DateValue` is parsed by the library and bound as a `date` ([SQL §6.6](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#66-typed-values) rule 7.1).
2. `sql:NVarcharValue`, `sql:NCharValue`, `sql:ClobValue`, `sql:NClobValue`, `sql:RowValue`, `sql:StructValue`, `sql:RefValue`, `sql:NVarcharArrayValue` and `sql:VarBinaryArrayValue` are rejected by the driver, and the operation returns an `sql:DatabaseError`.
3. `sql:BitValue` and `sql:BooleanValue` are bound as `boolean` values, which the server does not accept for a `bit` column; `postgresql:PGBitValue` binds a `bit` value ([§7.3](#73-typed-value-classes)).
4. A `float` is bound as `double precision`, which the server does not accept for a `money` column; a `decimal` (`numeric`) is accepted.
5. `()` is bound as `NULL` without a type. When the server cannot infer the type of the parameter from the statement, for example in `SELECT ${value}`, the operation returns an `sql:DatabaseError`.
6. An `int` is bound as `bigint` ([SQL §6.3](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#63-basic-types)), so a function or procedure whose parameter is `integer` is not found by a call that passes an `int` ([§9.2](#92-behaviour)).
7. The time zone of `time:Civil` and `time:Utc` values bound to zoned and unzoned columns is specified in [§8.5](#85-time-zones) rule 4.

### 6.4. Errors

| Condition | Error |
|---|---|
| A value rejected by the driver or the server ([§6.3](#63-driver-defined-outcomes)) | `sql:DatabaseError`, returned |
| A PostgreSQL typed value that cannot be bound | As specified in [§7.5](#75-errors) |
| Any other binding failure | As specified in [SQL §6.9](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#69-errors) |

### 6.5. Example: Array and time parameters

```ballerina
import ballerina/sql;
import ballerina/time;
import ballerinax/postgresql;

# Stores readings with the time of day at which they were taken.
function addReadings(postgresql:Client db, float[] values, time:TimeOfDay takenAt) returns sql:Error? {
    sql:DoubleArrayValue readings = new (values);
    _ = check db->execute(`INSERT INTO readings (vals, taken_at) VALUES (${readings}, ${takenAt})`);
}
```

`readings` is bound as a `double precision[]` and `takenAt` as a `time` value, or as a `timetz` value when it has a `utcOffset` ([§6.2](#62-changes-to-the-default-binding)).

## 7. PostgreSQL typed values

### 7.1. Description

The connector defines typed value classes for PostgreSQL types, and value records for the values of the structured ones. A PostgreSQL typed value is bound as a value of its PostgreSQL type. The connector recognises its typed value classes, value records and OUT parameter classes by module and name: a class or record type of another module with the same name is not one of them ([SQL §17.3](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#173-fixed-behaviour)). The same records are the targets of result mapping ([§8.4](#84-postgresql-record-targets)) and OUT parameters ([§9.3](#93-out-parameter-classes)).

### 7.2. Value records

The value records are open records with the following fields.

| Record | Field | Type | Default | Meaning |
|---|---|---|---|---|
| `postgresql:Point` | `x`, `y` | `decimal` | Required | Coordinates. |
| `postgresql:Line` | `a`, `b`, `c` | `decimal` | Required | Coefficients of the line *ax* + *by* + *c* = 0. |
| `postgresql:LineSegment` | `x1`, `y1`, `x2`, `y2` | `decimal` | Required | Coordinates of the two end points. |
| `postgresql:Box` | `x1`, `y1`, `x2`, `y2` | `decimal` | Required | Coordinates of two opposite corners. |
| `postgresql:Path` | `open` | `boolean` | `false` | Whether the path is open. |
| | `points` | `postgresql:Point[]` | Required | Points of the path, in order. |
| `postgresql:Polygon` | `points` | `postgresql:Point[]` | Required | Points of the polygon, in order. |
| `postgresql:Circle` | `x`, `y`, `r` | `decimal` | Required | Centre and radius. |
| `postgresql:Interval` | `years`, `months`, `days`, `hours`, `minutes` | `int` | `0` | Components of the interval. |
| | `seconds` | `decimal` | `0` | Seconds component, with fraction. |
| `postgresql:Range` | `upper`, `lower` | `anydata` | Required | Bounds. |
| | `upperboundInclusive`, `lowerboundInclusive` | `boolean` | `false` | Whether each bound is included. |
| `postgresql:IntegerRange`, `postgresql:LongRange` | `upper`, `lower` | `int` | Required | Bounds of an `int4range` or `int8range`; includes `postgresql:Range`. |
| `postgresql:NumericRange` | `upper`, `lower` | `decimal` | Required | Bounds of a `numrange`; includes `postgresql:Range`. |
| `postgresql:TimestampRange`, `postgresql:TimestamptzRange`, `postgresql:DateRange` | `upper`, `lower` | `string` | Required | Bounds of a `tsrange`, `tstzrange` or `daterange`, in the text form of the bound type; include `postgresql:Range`. |
| `postgresql:TimestampCivilRange`, `postgresql:TimestamptzCivilRange` | `upper`, `lower` | `time:Civil` | Required | Bounds of a `tsrange` or `tstzrange`; include `postgresql:Range`. |
| `postgresql:DateRecordRange` | `upper`, `lower` | `time:Date` | Required | Bounds of a `daterange`; includes `postgresql:Range`. |
| `postgresql:CustomValues` | `values` | `anydata[]?` | Required | Values of the fields of a composite type, in field order ([§7.3](#73-typed-value-classes) rule 7). |
| `postgresql:Enum` | `value` | `string` | absent | Label of an enumerated type. |
| `postgresql:CustomValueRecord` | `sqlTypeName` | `string` | Required | Name of a composite type. |
| | `values` | `postgresql:CustomValues?` | Required | Its values. |
| `postgresql:EnumRecord` | `sqlTypeName` | `string` | Required | Name of an enumerated type. |
| | `value` | `postgresql:Enum?` | Required | Its label. |

`postgresql:CustomValueRecord` and `postgresql:EnumRecord` are the `value` fields of `postgresql:CustomTypeValue` and `postgresql:EnumValue`, which their initializers build.

### 7.3. Typed value classes

Each class holds its value in the field `value`; its initializer's argument defaults to `()`, except for `postgresql:CustomTypeValue` and `postgresql:EnumValue`, whose initializers take the type name and an optional value. A `()` value is bound as SQL `NULL`; the type of the `NULL` is left to the server.

| Class | Accepted `value` | Bound as | Conversion |
|---|---|---|---|
| `postgresql:InetValue` | `string` | `inet` | Text form, parsed by the server. |
| `postgresql:CidrValue` | `string` | `cidr` | Text form. |
| `postgresql:MacAddrValue` | `string` | `macaddr` | Text form. |
| `postgresql:MacAddr8Value` | `string` | `macaddr8` | Text form. |
| `postgresql:UuidValue` | `string` | `uuid` | Text form. |
| `postgresql:TsVectorValue` | `string` | `tsvector` | Text form. |
| `postgresql:TsQueryValue` | `string` | `tsquery` | Text form. |
| `postgresql:JsonPathValue` | `string` | `jsonpath` | Text form. |
| `postgresql:PglsnValue` | `string` | `pg_lsn` | Text form. |
| `postgresql:BitStringValue` | `string` | `bit` | Text form, such as `"101"`. |
| `postgresql:VarBitStringValue` | `string` | `varbit` | Text form. |
| `postgresql:RegClassValue`, `postgresql:RegConfigValue`, `postgresql:RegDictionaryValue`, `postgresql:RegNamespaceValue`, `postgresql:RegOperValue`, `postgresql:RegOperatorValue`, `postgresql:RegProcValue`, `postgresql:RegProcedureValue`, `postgresql:RegRoleValue`, `postgresql:RegTypeValue` | `string` | `regclass`, `regconfig`, `regdictionary`, `regnamespace`, `regoper`, `regoperator`, `regproc`, `regprocedure`, `regrole`, `regtype` respectively | Text form, such as a table name for `regclass`. |
| `postgresql:PointValue` | `postgresql:Point`, `string` | `point` | See rule 1. |
| `postgresql:LineValue` | `postgresql:Line`, `string` | `line` | See rule 1. |
| `postgresql:LineSegmentValue` | `postgresql:LineSegment`, `string` | `lseg` | See rule 1. |
| `postgresql:BoxValue` | `postgresql:Box`, `string` | `box` | See rule 1. |
| `postgresql:PathValue` | `postgresql:Path`, `postgresql:Point[]`, `string` | `path` | See rules 1 and 2. |
| `postgresql:PolygonValue` | `postgresql:Point[]`, `string` | `polygon` | See rules 1 and 2. |
| `postgresql:CircleValue` | `postgresql:Circle`, `string` | `circle` | See rule 1. |
| `postgresql:IntervalValue` | `postgresql:Interval`, `string` | `interval` | See rule 3. |
| `postgresql:IntegerRangeValue` | `postgresql:IntegerRange`, `string` | `int4range` | See rule 4. |
| `postgresql:LongRangeValue` | `postgresql:LongRange`, `string` | `int8range` | See rule 4. |
| `postgresql:NumericRangeValue` | `postgresql:NumericRange`, `string` | `numrange` | See rule 4. |
| `postgresql:TsRangeValue` | `postgresql:TimestampRange`, `postgresql:TimestampCivilRange`, `string` | `tsrange` | See rules 4 and 5. |
| `postgresql:TsTzRangeValue` | `postgresql:TimestamptzRange`, `postgresql:TimestamptzCivilRange`, `string` | `tstzrange` | See rules 4 and 5. |
| `postgresql:DateRangeValue` | `postgresql:DateRange`, `postgresql:DateRecordRange`, `string` | `daterange` | See rules 4 and 5. |
| `postgresql:JsonValue` | `json`, `string` | `json` | See rule 6. |
| `postgresql:JsonBinaryValue` | `json`, `string` | `jsonb` | See rule 6. |
| `postgresql:PGBitValue` | `boolean`, `string` | `bit` | `true` as `1`, `false` as `0`; a `string` as given. |
| `postgresql:MoneyValue` | `decimal`, `float`, `string` | `money` | A `decimal` exactly, as a `numeric` value; a `float` as a 64-bit floating-point number; each rounded by the server to the precision of the currency. A `string` in the text form of `money`, such as `"$12.34"`. |
| `postgresql:PGXmlValue` | `string`, `xml` | `xml` | A `string` as given, an `xml` value as its serialization. |
| `postgresql:CustomTypeValue` | `postgresql:CustomValueRecord` | the composite type named `sqlTypeName` | See rule 7. |
| `postgresql:EnumValue` | `postgresql:EnumRecord` | the enumerated type named `sqlTypeName` | See rule 8. |

1. A geometric value given as a record is bound with its coordinates converted to 64-bit floating-point numbers. A geometric value given as a `string` is parsed by the driver in the text form of the type, such as `"(1,2)"` for a `point`; a string that the driver cannot parse results in an `sql:DatabaseError` whose message is _unspecified_.
2. A `postgresql:Point[]` given to `postgresql:PathValue` is bound as a closed path. A `postgresql:Path` is bound as open or closed according to `open`. An empty array of points, for a path or a polygon, results in an `sql:DataError`.
3. An `postgresql:Interval` is bound with its `int` fields and with `seconds` converted to a 64-bit floating-point number.
4. A range record is bound as the text form of the range: `[` when `lowerboundInclusive` is `true`, otherwise `(`; then `lower`, `,`, `upper`; then `]` when `upperboundInclusive` is `true`, otherwise `)`. Each bound is written in double quotes, with each `"` and `\` of its string form preceded by `\`, so a bound that contains a character of the range literal syntax, such as `,`, `(`, `)`, `[`, `]`, `"` or `\`, is stored as given. The server converts the range to its canonical form; for example, the `int4range` `(1,5)` is stored as `[2,5)`. A `string` is the text form of the range.
5. In a range record, a `time:Civil` bound of a `postgresql:TimestampCivilRange` is written as its date and time fields, and its `utcOffset` is ignored. A `time:Civil` bound of a `postgresql:TimestamptzCivilRange` is written as an instant: with its `utcOffset`, or as a UTC date-time when it has none. A `time:Date` bound is written as `year-month-day`. Fields that do not form a valid date or date-time result in an `sql:ConversionError`.
6. A `string` value that is a valid JSON text is bound as that JSON document, so `"{\"a\":1}"` is bound as an object. Any other `json` value, including a `string` that is not a valid JSON text, is bound as its JSON serialization, so the `string` `"hello"` is bound as the JSON string `"hello"`.
7. `postgresql:CustomTypeValue` is bound as the composite literal `(v1,v2,…)` of `values.values`, in order. Each value is written as its string form in double quotes, with each `"` and `\` preceded by `\`, so a value that contains a character of the composite literal syntax, such as `,`, `(`, `)`, `"` or `\`, and the empty string are stored as given. A record value is written, quoted in the same way, as a nested composite literal of its field values in field declaration order. A `()` member is written as an empty field, so the field is SQL `NULL`. When `values` or `values.values` is `()`, SQL `NULL` is bound. An empty `values.values` results in an `sql:DatabaseError`.
8. `postgresql:EnumValue` is bound as the label in `value.value`. When `value` is `()`, or is an `postgresql:Enum` without the `value` field, SQL `NULL` is bound.

### 7.4. Typed array value classes

Each class of the following table binds an array of the PostgreSQL type of the corresponding class of [§7.3](#73-typed-value-classes). Its `value` is an array whose members are the accepted values of that class or `()`, and its initializer's argument defaults to an empty array. Each element is converted as for that class; a `()` element is bound as a `NULL` element, and an empty array as an empty array.

| Class | Element type |
|---|---|
| `postgresql:InetArrayValue`, `postgresql:CidrArrayValue`, `postgresql:MacAddrArrayValue`, `postgresql:MacAddr8ArrayValue` | `inet`, `cidr`, `macaddr`, `macaddr8` |
| `postgresql:PointArrayValue`, `postgresql:LineArrayValue`, `postgresql:LineSegmentArrayValue`, `postgresql:BoxArrayValue`, `postgresql:PathArrayValue`, `postgresql:PolygonArrayValue`, `postgresql:CircleArrayValue` | `point`, `line`, `lseg`, `box`, `path`, `polygon`, `circle` |
| `postgresql:UuidArrayValue`, `postgresql:TsVectorArrayValue`, `postgresql:TsQueryArrayValue` | `uuid`, `tsvector`, `tsquery` |
| `postgresql:JsonArrayValue`, `postgresql:JsonBinaryArrayValue`, `postgresql:JsonPathArrayValue` | `json`, `jsonb`, `jsonpath` |
| `postgresql:IntervalArrayValue` | `interval` |
| `postgresql:IntegerRangeArrayValue`, `postgresql:LongRangeArrayValue`, `postgresql:NumericRangeArrayValue`, `postgresql:TsRangeArrayValue`, `postgresql:TsTzRangeArrayValue`, `postgresql:DateRangeArrayValue` | `int4range`, `int8range`, `numrange`, `tsrange`, `tstzrange`, `daterange` |
| `postgresql:PglsnArrayValue` | `pg_lsn` |
| `postgresql:BitStringArrayValue`, `postgresql:VarBitStringArrayValue`, `postgresql:PGBitArrayValue` | `bit`, `varbit`, `bit` |
| `postgresql:MoneyArrayValue` | `money` |
| `postgresql:RegClassArrayValue`, `postgresql:RegConfigArrayValue`, `postgresql:RegDictionaryArrayValue`, `postgresql:RegNamespaceArrayValue`, `postgresql:RegOperArrayValue`, `postgresql:RegOperatorArrayValue`, `postgresql:RegProcArrayValue`, `postgresql:RegProcedureArrayValue`, `postgresql:RegRoleArrayValue`, `postgresql:RegTypeArrayValue` | `regclass`, `regconfig`, `regdictionary`, `regnamespace`, `regoper`, `regoperator`, `regproc`, `regprocedure`, `regrole`, `regtype` |
| `postgresql:PGXmlArrayValue` | `xml` |

There are no array classes for `postgresql:CustomTypeValue` and `postgresql:EnumValue`.

### 7.5. Errors

| Condition | Error |
|---|---|
| A geometric string that the driver cannot parse | `sql:DatabaseError` |
| A path or polygon without points | `sql:DataError` |
| Range bounds that do not form a valid date or date-time | `sql:ConversionError` |
| A value that the server rejects, such as an invalid `inet` text | `sql:DatabaseError` |

All binding errors are returned, never raised as panics.

### 7.6. Interactions

- PostgreSQL typed values can be used wherever an `sql:Value` is accepted, including in `batchExecute`, as IN parameters of `call`, and as the IN value of a `postgresql:InOutParameter` ([§9.4](#94-inout-parameters)).
- A `time:Civil` without `utcOffset` is interpreted as UTC in a `postgresql:TimestamptzCivilRange` (rule 5 of [§7.3](#73-typed-value-classes)), but in the session time zone when it is bound directly to a `timestamptz` column ([§8.5](#85-time-zones)).

### 7.7. Example: Geometric, range and JSON values

```ballerina
import ballerina/sql;
import ballerinax/postgresql;

# Stores a delivery zone.
function addZone(postgresql:Client db, string name) returns sql:Error? {
    postgresql:CircleValue area = new ({x: 6.9, y: 79.8, r: 0.5});
    postgresql:IntegerRangeValue hours = new ({lower: 8, upper: 17, lowerboundInclusive: true, upperboundInclusive: true});
    postgresql:JsonBinaryValue tags = new ({express: true, levels: ["A", "B"]});
    _ = check db->execute(`INSERT INTO zones (name, area, hours, tags) VALUES (${name}, ${area}, ${hours}, ${tags})`);
}
```

`area` is bound as the `circle` `<(6.9,79.8),0.5>`, `hours` as the `int4range` `[8,17]`, which the server stores as `[8,18)`, and `tags` as the `jsonb` document `{"express":true,"levels":["A","B"]}` ([§7.3](#73-typed-value-classes) rules 1, 4 and 6).

## 8. Result mapping

### 8.1. Description

Results are mapped as specified in [SQL §7](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#7-result-mapping). This section states the connector's result conversion, the JDBC types that the driver reports for PostgreSQL column types, which select the rows of [SQL §7.6](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#76-column-conversion) and [SQL §7.7](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#77-unmatched-columns) that apply, and the conversion to the connector's value records.

### 8.2. Result conversion

1. The connector supplies its own result conversion and an `sql:CustomResultIterator`, `postgresql:CustomResultIterator`, so its conversion applies to the rows of `query` streams, to `queryRow`, and to the `queryResult` streams of `call` ([SQL §17.5](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#175-interactions)).
2. The conversion is that of [SQL §7.6](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#76-column-conversion), with the following changes.

    | SQL §7.6 row | Change |
    |---|---|
    | any other JDBC type, target type a record type | A value record target of a column of a PostgreSQL type of [§8.4](#84-postgresql-record-targets) rule 1 receives the value converted as [§8.4](#84-postgresql-record-targets) states, instead of an `sql:UnsupportedTypeError`. |
    | `ARRAY` (rule 3.1) | The elements of an array of the geometric, `interval` and range types are value records of [§8.4](#84-postgresql-record-targets); the elements of an array of the types of JDBC type `OTHER` of [§8.3](#83-postgresql-column-types), and of `json`, `jsonb`, `xml` and enumerated types, are `string` values; the elements of a `money[]` are `float` values. |
    | `STRUCT`, `REF` (rule 4) | For a composite type, the targets of the `Composite types` row of [§8.3](#83-postgresql-column-types) apply. |
    | `BIT`, `BOOLEAN` | For a `bit(n)` column with n > 1, the targets of the `bit(n)` row of [§8.3](#83-postgresql-column-types) apply, also when the column is unmatched in an open record. |
    | `DOUBLE` | For a `money` column, a `decimal` target gets the exact amount ([§8.3](#83-postgresql-column-types)). |

3. [§8.3](#83-postgresql-column-types) lists the JDBC type that the driver reports for each PostgreSQL type, which selects the rows of [SQL §7.6](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#76-column-conversion) and [SQL §7.7](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#77-unmatched-columns) that apply, and the result of those rows and of these changes for each PostgreSQL type.

### 8.3. PostgreSQL column types

The driver reports the following JDBC types for PostgreSQL column types; the conversion of each is the [SQL §7.6](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#76-column-conversion) row of that JDBC type with the changes of [§8.2](#82-result-conversion), and the default type of a column of an open record is the [SQL §7.7](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#77-unmatched-columns) row, except as stated. A JDBC type of `OTHER` selects the [SQL §7.6](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#76-column-conversion) row "any other JDBC type". A row that lists target types adds them to the targets of the [SQL §7.6](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#76-column-conversion) row of its JDBC type. For the JDBC type `OTHER`, the targets of the row "any other JDBC type" apply to the text of the value: for example, a `uuid` column read into `byte[]` gives the UTF-8 bytes of its text form, and a `point` column read into `json` results in an `sql:ConversionError`.

| PostgreSQL type | JDBC type | Conversion |
|---|---|---|
| `smallint`, `integer`, `bigint` | `SMALLINT`, `INTEGER`, `BIGINT` | |
| `real`, `double precision` | `REAL`, `DOUBLE` | |
| `numeric` | `NUMERIC` | |
| `money` | `DOUBLE` | `float`; `decimal`: the exact amount, such as `12.34`; and `string` (the number without the currency symbol, such as `"12.34"`). |
| `boolean`, `bit(1)` | `BIT` | |
| `bit(n)`, n > 1 | `BIT` | `string`: the bits, such as `"101"`, also as the default type. Every other target type results in an `sql:TypeMismatchError`. |
| `varbit` | `OTHER` | `string`: the bits, such as `"10101"`. |
| `char(n)`, `varchar`, `text` | `CHAR`, `VARCHAR` | |
| `bytea` | `BINARY` | `byte[]`; `string`: the driver's text form, such as `"\x0102"`. |
| `date`, `time`, `timestamp` | `DATE`, `TIME`, `TIMESTAMP` | |
| `timetz` | `TIME` | The time in the JVM default time zone, without `utcOffset` ([§8.5](#85-time-zones)). |
| `timestamptz` | `TIMESTAMP` | The date-time in the JVM default time zone, without `utcOffset`; a `time:Utc` target gets the instant ([§8.5](#85-time-zones)). |
| `xml` | `SQLXML` | `xml`: the value parsed as XML. A `string` target results in an `sql:TypeMismatchError`. |
| `json`, `jsonb` | `OTHER` | `json`: the value parsed as JSON; `string`: the JSON text. The default type is `string`. |
| `point`, `line`, `lseg`, `box`, `path`, `polygon`, `circle`, `interval`, `int4range`, `int8range`, `numrange`, `tsrange`, `tstzrange`, `daterange` | `OTHER` | `string`: the text form of the value; a value record of [§8.4](#84-postgresql-record-targets). The default type is `string`. |
| `inet`, `cidr`, `macaddr`, `macaddr8`, `uuid`, `tsvector`, `tsquery`, `jsonpath`, `pg_lsn`, the `reg*` types, enumerated types | `OTHER` or `VARCHAR` | `string`: the text form of the value. An enumerated type can also be read into a Ballerina `enum` type whose members are its labels ([SQL §7.6](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#76-column-conversion) rule 1). |
| Composite types | `STRUCT` | `string`: the text form of the value, such as `(1,"a b")`, also as the default type; `postgresql:CustomValues`: the values of the fields in field order, with `()` for a `NULL` field, where the Ballerina type of each field value is _unspecified_. Every other target type results in an `sql:TypeMismatchError`. |
| Arrays | `ARRAY` | [SQL §7.6](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#76-column-conversion) rule 3, and see the next rows. |
| Arrays of the geometric, `interval` and range types | `ARRAY` | An array of the value records of [§8.4](#84-postgresql-record-targets), also as the default type. For `tsrange` and `tstzrange`, the elements are `postgresql:TimestampCivilRange` or `postgresql:TimestamptzCivilRange` records when the target type refers to that record type, and `postgresql:TimestampRange` or `postgresql:TimestamptzRange` records otherwise, also as the default type; for `daterange`, they are `postgresql:DateRange` records when the target type refers to `postgresql:DateRange`, and `postgresql:DateRecordRange` records otherwise, also as the default type. |
| Arrays of the types of the `OTHER` row above, and of `json`, `jsonb`, `xml` and enumerated types | `ARRAY` | An array of `string` values, also for a `json[]` target. |
| `money[]` | `ARRAY` | An array of `float` values, also as the default type. |

The JDBC type reported for a PostgreSQL type is driver-defined; the table states it for pgjdbc 42.

### 8.4. PostgreSQL record targets

1. A field whose type is one of the value records `postgresql:Point`, `postgresql:Line`, `postgresql:LineSegment`, `postgresql:Box`, `postgresql:Path`, `postgresql:Polygon`, `postgresql:Circle`, `postgresql:Interval`, `postgresql:IntegerRange`, `postgresql:LongRange`, `postgresql:NumericRange`, `postgresql:TimestampRange`, `postgresql:TimestampCivilRange`, `postgresql:TimestamptzRange`, `postgresql:TimestamptzCivilRange`, `postgresql:DateRange` or `postgresql:DateRecordRange` receives the column value converted to that value record ([§7.2](#72-value-records)). The conversion is selected by the module and name of the record type, so a record type of another module with one of these names, and a record type without a name, result in an `sql:UnsupportedTypeError`.
2. The column MUST be of the PostgreSQL type of the record: a value of another type results in an `sql:TypeMismatchError`.
3. Geometric values: coordinates are converted from the driver's 64-bit floating-point numbers to `decimal`. For a `box`, `x1` and `y1` are the lower left corner and `x2` and `y2` the upper right corner. For a `path`, `open` is `true` for an open path.
4. `interval` values: the components are those of the interval as the server returns it, with `seconds` including the fraction; for example, `1 year 2 mons 3 days 04:05:06.5` becomes `{years: 1, months: 2, days: 3, hours: 4, minutes: 5, seconds: 6.5}`.
5. Range values: `lowerboundInclusive` is `true` when the text form starts with `[`, and `upperboundInclusive` when it ends with `]`. The bounds are converted to the field types: `int` and `decimal` bounds as numbers; the bounds of `postgresql:TimestampRange`, `postgresql:TimestamptzRange` and `postgresql:DateRange` as their text forms without quotes, a `tstzrange` bound in the session time zone, such as `"2021-01-01 04:30:00+00"`; the bounds of `postgresql:DateRecordRange` as `time:Date` values; the bounds of `postgresql:TimestamptzCivilRange` as `time:Civil` values with the offset of the bound; and the bounds of `postgresql:TimestampCivilRange` as `time:Civil` values with the date and time fields of the bound and the `utcOffset` of the JVM default time zone at that date and time, negative offsets included.
6. An empty range (`empty`) and a range with an unbounded side cannot be represented in a range record: the operation returns an `sql:ConversionError`. A `string` target gets their text form, such as `"empty"`.
7. SQL `NULL` converts to `()` ([SQL §7.5](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#75-building-the-value)).

#### 8.4.1. Example: Reading PostgreSQL values

```ballerina
import ballerina/sql;
import ballerinax/postgresql;

type Zone record {|
    string name;
    postgresql:Circle area;
    postgresql:IntegerRange hours;
    json tags;
    string address;
|};

# Reads the zone with the given name.
function getZone(postgresql:Client db, string name) returns Zone|sql:Error {
    return db->queryRow(`SELECT name, area, hours, tags, address FROM zones WHERE name = ${name}`);
}
```

For the row stored by the example of [§7.7](#77-example-geometric-range-and-json-values) with `name` `"north"`, and an `inet` column `address` holding `192.168.0.1/24`, the result is `{name: "north", area: {x: 6.9, y: 79.8, r: 0.5}, hours: {lower: 8, upper: 18, lowerboundInclusive: true, upperboundInclusive: false}, tags: {express: true, levels: ["A", "B"]}, address: "192.168.0.1/24"}` ([§8.3](#83-postgresql-column-types), [§8.4](#84-postgresql-record-targets) rules 1, 3 and 5).

### 8.5. Time zones

1. The driver sets the session time zone of each connection to the JVM default time zone.
2. A `timestamptz` value is read as the date-time of the instant in the JVM default time zone: into `time:Civil` without `utcOffset`, into `string` without offset, and into `time:Utc` as the instant.
3. A `timetz` value is read as the time in the JVM default time zone, without `utcOffset`; fractional seconds are discarded ([SQL §7.6](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#76-column-conversion) row `TIME`).
4. A `time:Civil` without `utcOffset`, bound to a `timestamptz` column, and a `time:Utc` bound to a `timestamp` column, are interpreted by the server in the session time zone.

For example, with the JVM default time zone UTC, a `timetz` value `10:20:30.5+05:30` is read as the `time:TimeOfDay` `{hour: 4, minute: 50, second: 30}`, and with the JVM default time zone Asia/Colombo (UTC+05:30) as `{hour: 10, minute: 20, second: 30}`.

### 8.6. Errors

| Condition | Error |
|---|---|
| An `xml` column into a `string` target; a `bit(n)` column, n > 1, or a composite column into a target other than those of [§8.3](#83-postgresql-column-types) | `sql:TypeMismatchError` |
| A value record target for a column of another PostgreSQL type | `sql:TypeMismatchError` |
| A record target that is not a value record of this module, for a column of a type of [§8.4](#84-postgresql-record-targets) | `sql:UnsupportedTypeError` |
| An empty or unbounded range into a range record | `sql:ConversionError` |
| Any other failure | As specified in [SQL §7.8](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#78-errors) |

For `query`, these errors are returned by the stream's `next` method for the row, and for `queryRow`, by `queryRow` ([SQL §8](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#8-query), [SQL §9](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#9-query-row)).

## 9. Stored procedure calls

### 9.1. Description

Procedures and functions are called as specified in [SQL §12](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#12-stored-procedure-calls). This section states the PostgreSQL-specific outcomes, the connector's OUT parameter classes and its `InOutParameter` class.

### 9.2. Behaviour

1. The driver accepts `` `CALL name(...)` `` for a procedure, and `` `{call name(...)}` `` for a function with OUT or INOUT parameters or one that returns a set of rows; `` `{${ret} = call name(...)}` `` reads a function's return value into the OUT parameter `ret`. Which forms are accepted is driver-defined ([SQL §12.3](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#123-call-execution)).
2. A function that returns a set of rows produces a result set as its first result, so `queryResult` holds a stream after `call`.
3. The server selects the function or procedure by the types of the bound parameters. An `int` is bound as `bigint` ([SQL §6.3](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#63-basic-types)), so a function or procedure whose parameter is `integer` is not found, and `call` returns an `sql:DatabaseError`; an `sql:IntegerValue` is bound as `integer`.
4. An `sql:CursorOutParameter` can be read only when the call is executed in a transaction ([SQL §13](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#13-transactions)). Outside a transaction, the driver fetches the cursor while the call executes, after the server has closed it, so `call` returns an `sql:DatabaseError` (driver-defined).
5. Every OUT and INOUT value is converted with the connector's conversion ([SQL §17.5](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#175-interactions)): the values of the classes of [§9.3](#93-out-parameter-classes) and of `postgresql:InOutParameter` ([§9.4](#94-inout-parameters)), the values of the OUT parameter classes of the `ballerina/sql` library and of `sql:InOutParameter`, and the rows of an `sql:CursorOutParameter` ([§8.2](#82-result-conversion)). An `sql:InOutParameter` whose IN value is a PostgreSQL typed value is registered and converted as a `postgresql:InOutParameter` with the same IN value ([§9.4](#94-inout-parameters) rules 2 and 3).

### 9.3. OUT parameter classes

Each class is an OUT parameter class ([SQL §12.2](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#122-parameter-classification)); it is registered with the SQL type of the following table, and its `get` method accepts the target types of the table. Any other target type results in an `sql:TypeMismatchError`.

| Class | Registered SQL type | Target types |
|---|---|---|
| `postgresql:InetOutParameter`, `postgresql:CidrOutParameter`, `postgresql:MacAddrOutParameter`, `postgresql:MacAddr8OutParameter`, `postgresql:UuidOutParameter`, `postgresql:TsVectorOutParameter`, `postgresql:TsQueryOutParameter`, `postgresql:JsonPathOutParameter`, `postgresql:VarBitStringOutParameter`, `postgresql:PglsnOutParameter`, `postgresql:RegClassOutParameter`, `postgresql:RegConfigOutParameter`, `postgresql:RegDictionaryOutParameter`, `postgresql:RegNamespaceOutParameter`, `postgresql:RegOperOutParameter`, `postgresql:RegOperatorOutParameter`, `postgresql:RegProcOutParameter`, `postgresql:RegProcedureOutParameter`, `postgresql:RegRoleOutParameter`, `postgresql:RegTypeOutParameter` | `OTHER` | `string`: the text form of the value. |
| `postgresql:PointOutParameter`, `postgresql:LineOutParameter`, `postgresql:LsegOutParameter`, `postgresql:BoxOutParameter`, `postgresql:PathOutParameter`, `postgresql:PolygonOutParameter`, `postgresql:CircleOutParameter`, `postgresql:IntervalOutParameter`, `postgresql:IntegerRangeOutParameter`, `postgresql:LongRangeOutParameter`, `postgresql:NumericRangeOutParameter`, `postgresql:TimestampRangeOutParameter`, `postgresql:TimestampTzRangeOutParameter`, `postgresql:DateRangeOutParameter` | `OTHER` | The value record of the type, converted as in [§8.4](#84-postgresql-record-targets); `string`: the driver's text form of the value, such as `"(1.0,2.0)"` for a `point`. |
| `postgresql:JsonOutParameter`, `postgresql:JsonbOutParameter` | `OTHER` | `json`: the value parsed as JSON; `string`: the JSON text. |
| `postgresql:PGBitOutParameter` | `BIT` | As the [SQL §12.7](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#127-out-parameter-type-mapping) row `BIT`: `boolean`, `int`, `string`. |
| `postgresql:MoneyOutParameter` | `DOUBLE` | As the [SQL §12.7](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#127-out-parameter-type-mapping) row `DOUBLE`: `float`, `string`. |
| `postgresql:EnumOutParameter` | `VARCHAR` | As the [SQL §12.7](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#127-out-parameter-type-mapping) row `VARCHAR`: `string` and `json`, the label. |
| `postgresql:ByteaOutParameter` | `BINARY` | As the [SQL §12.7](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#127-out-parameter-type-mapping) row `BINARY`: `byte[]`, the bytes of the value; `string`, the driver's text form of the value. |
| `postgresql:PGXmlOutParameter` | `SQLXML` | `xml`: the value parsed as XML; `string`: the XML text. |

The result of `get` for an SQL `NULL` value is _unspecified_ ([SQL §12.7](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#127-out-parameter-type-mapping)).

### 9.4. INOUT parameters

1. `postgresql:InOutParameter` is an INOUT parameter class ([SQL §12.2](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#122-parameter-classification)): its initializer takes the IN value, an `sql:Value`, which it holds in the field `in`.
2. It is registered with the SQL type of its IN value as specified in [SQL §12.5](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#125-out-and-inout-parameter-registration). A PostgreSQL typed value registers the SQL type of the corresponding OUT parameter class of [§9.3](#93-out-parameter-classes): `BIT` for `postgresql:PGBitValue` and `postgresql:BitStringValue`, `DOUBLE` for `postgresql:MoneyValue`, `VARCHAR` for `postgresql:EnumValue`, `SQLXML` for `postgresql:PGXmlValue`, `ARRAY` for the classes of [§7.4](#74-typed-array-value-classes), and `OTHER` for every other class of [§7.3](#73-typed-value-classes), including `postgresql:CustomTypeValue`.
3. Its `get` method converts the value as [SQL §12.7](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#127-out-parameter-type-mapping) states for the registered SQL type, with these changes:
    1. A value whose IN value is a class of [§7.3](#73-typed-value-classes) registered as `OTHER` is converted as the OUT parameter class of the same PostgreSQL type in [§9.3](#93-out-parameter-classes). The values of `postgresql:BitStringValue`, for a `bit` parameter, and of `postgresql:VarBitStringValue`, for a `varbit` parameter, are converted to `string`, the bits, such as `"101"`.
    2. A value whose IN value is a typed array value of [§7.4](#74-typed-array-value-classes) is converted to an array of value records for the geometric, `interval` and range types, and to a `string[]` for the other types.
    3. With a `postgresql:CustomTypeValue` IN value, `call` returns an `sql:DatabaseError`, because the driver reports a composite value as `STRUCT` ([§8.3](#83-postgresql-column-types)).

### 9.5. Compile-time validation

The compiler plugin checks each call of the `get` method of an OUT parameter class of this connector with exactly one argument. It reports the following when the kind of the argument, which is the target type, is not one of the kinds listed. A named type and a type alias have the kind of the type they refer to.

| Code | Classes | Allowed kinds | Kind |
|---|---|---|---|
| `POSTGRESQL_201` | `postgresql:InetOutParameter`, `postgresql:CidrOutParameter`, `postgresql:MacAddrOutParameter`, `postgresql:MacAddr8OutParameter`, `postgresql:UuidOutParameter`, `postgresql:TsVectorOutParameter`, `postgresql:TsQueryOutParameter`, `postgresql:JsonPathOutParameter`, `postgresql:VarBitStringOutParameter`, `postgresql:PglsnOutParameter`, `postgresql:ByteaOutParameter`, the ten `postgresql:Reg*OutParameter` classes; `postgresql:PGBitOutParameter` | `string`; also `byte[]` for `postgresql:ByteaOutParameter`; `boolean`, `int`, `string` for `postgresql:PGBitOutParameter` | error |
| `POSTGRESQL_202` | `postgresql:PointOutParameter`, `postgresql:LineOutParameter`, `postgresql:LsegOutParameter`, `postgresql:BoxOutParameter`, `postgresql:PathOutParameter`, `postgresql:PolygonOutParameter`, `postgresql:CircleOutParameter`, `postgresql:IntervalOutParameter`, `postgresql:IntegerRangeOutParameter`, `postgresql:LongRangeOutParameter`, `postgresql:NumericRangeOutParameter`, `postgresql:TimestampRangeOutParameter`, `postgresql:TimestampTzRangeOutParameter`, `postgresql:DateRangeOutParameter` | record, `string` | error |
| `POSTGRESQL_203` | `postgresql:JsonOutParameter`, `postgresql:JsonbOutParameter` | `json`, `string` | error |
| `POSTGRESQL_204` | `postgresql:PGXmlOutParameter` | `xml`, `string` | error |

1. A call without an argument, which infers the target type, is not checked; nor are `postgresql:MoneyOutParameter`, `postgresql:EnumOutParameter` and `postgresql:InOutParameter`.
2. The plugin does not check a module whose compilation already has errors.

### 9.6. Errors

| Condition | Error |
|---|---|
| A function or procedure whose parameter types do not match the bound types | `sql:DatabaseError`, returned by `call` |
| A call with an `sql:CursorOutParameter` outside a transaction | `sql:DatabaseError`, returned by `call` |
| A target type not listed in [§9.3](#93-out-parameter-classes) | `sql:TypeMismatchError`, returned by `get` |
| An INOUT parameter whose IN value is a `postgresql:CustomTypeValue` | `sql:DatabaseError`, returned by `call` |
| Any other failure | As specified in [SQL §12.10](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#1210-errors) |

### 9.7. Example: OUT and INOUT parameters

```ballerina
import ballerina/sql;
import ballerinax/postgresql;

# Moves a point and returns the moved point and the distance of the move.
function movePoint(postgresql:Client db, postgresql:Point p) returns [postgresql:Point, string]|sql:Error {
    postgresql:InOutParameter position = new (new postgresql:PointValue(p));
    postgresql:IntervalOutParameter took = new;
    sql:ProcedureCallResult result = check db->call(`{call move_point(${position}, ${took})}`);
    postgresql:Point moved = check position.get();
    string duration = check took.get(string);
    check result.close();
    return [moved, duration];
}
```

For a function `move_point(INOUT p point, OUT took interval)`, `position` is registered as `OTHER` and bound as a `point`, and `get` converts the returned `point` to a `postgresql:Point` ([§9.4](#94-inout-parameters)); `took` returns the driver's text form of the interval, `"1 secs"` for one second ([§9.3](#93-out-parameter-classes)). The values are read before `close` ([SQL §12.4.3](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#1243-closing)).

## 10. Connector contract

### 10.1. Description

This section states how the connector meets the connector obligations of [SQL §17.2](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#172-connector-obligations), and lists the override points of [SQL §17.4](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#174-override-points) that it uses.

### 10.2. Obligations

| SQL §17.2 rule | How the connector meets it |
|---|---|
| 1 | `postgresql:Client` includes `sql:Client` and delegates every operation to the library ([§3.5](#35-operations)). |
| 2 | It gives the URL of [§3.4](#34-connection-url), the user and password, the data source class name of [§3.3](#33-driver), the driver properties of [§4.3](#43-driver-properties) and the pool configuration. |
| 3 | When `connectionPool` is `()`, it gives `sql:getGlobalConnectionPool()`. |
| 4 | Generated keys are requested for both `execute` and `batchExecute`, except for DDL statements; `generatedKeysMode` `sql:INSERT_ONLY` limits the requests as in [SQL §10.4](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#104-generated-keys) rule 7 ([§3.5](#35-operations) rules 2 and 3). |
| 5 | `batchExecute` with an empty array behaves as [SQL §11.2](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#112-behaviour) rule 2, which is fixed library behaviour; the connector keeps its own check, which returns the same `sql:ApplicationError`. |
| 6 | The typed value classes of [§7.3](#73-typed-value-classes) and [§7.4](#74-typed-array-value-classes) have names that differ from those of `ballerina/sql`; the OUT parameter classes of [§9.3](#93-out-parameter-classes) have names that end with `OutParameter`; the INOUT parameter class is named `InOutParameter` and holds its IN value in the field `in` ([§9.4](#94-inout-parameters)). |
| 7 | The connector provides no `sql:SchemaClient`. |
| 8 | The override points are listed in [§10.3](#103-override-points). |

### 10.3. Override points

| SQL §17.4 area | Used | Delta |
|---|---|---|
| Binding of basic types, `time` values and arrays | Yes | `xml`, `time:TimeOfDay` with `utcOffset`, and `byte[]?[]` ([§6.2](#62-changes-to-the-default-binding)). |
| Binding of typed values | Yes | `sql:CharValue`, `sql:TimeValue`, `sql:DateTimeValue`, `sql:TimestampValue`, `sql:RealValue`, `sql:CharArrayValue`, `sql:BinaryArrayValue`, `sql:TimeArrayValue`, `sql:DateTimeArrayValue`, `sql:TimestampArrayValue` and the `byte[][]` value of `sql:ArrayValue` ([§6.2](#62-changes-to-the-default-binding)). |
| Connector-defined typed values | Yes | [§7.3](#73-typed-value-classes), [§7.4](#74-typed-array-value-classes); their INOUT registration in [§9.4](#94-inout-parameters). |
| Record parameters | No | |
| Nil parameters | No | |
| OUT parameter registration | Yes | The classes of [§9.3](#93-out-parameter-classes). |
| Result conversion | Yes | The [SQL §7.6](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#76-column-conversion) rows any other JDBC type (value record targets), `ARRAY`, `STRUCT`, `BIT` and `DOUBLE`, changed as the table of [§8.2](#82-result-conversion) states; [§8.4](#84-postgresql-record-targets). |
| OUT and INOUT values | Yes | [§9.2](#92-behaviour) rule 5, [§9.3](#93-out-parameter-classes), [§9.4](#94-inout-parameters). |
| Result iteration | Yes | `postgresql:CustomResultIterator`, which applies the connector's result conversion; its `getNextQueryResult` behaves as [SQL §12.4.2](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#1242-moving-to-the-next-result). |
| Pool properties | No | None; the pool configuration alone sets the pool ([§4.3](#43-driver-properties) rule 3). |
| Metric tags | Yes | [§11.2](#112-metric-tags). |
| Data source | Yes | `org.postgresql.ds.PGSimpleDataSource` ([§3.3](#33-driver)). |

## 11. Observability

### 11.1. Description

The pool metrics of [SQL §16](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#16-observability) apply. The connector adds the metric tags of [SQL §16.4](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#164-tags) rule 3.

### 11.2. Metric tags

| Tag | Value | Present |
|---|---|---|
| `db_host` | `host`, as given to the initializer | Always |
| `db_port` | `port` as a decimal integer, as given to the initializer, also when it is less than or equal to `0` | Always |
| `db_name` | `database` | When `database` is neither `()` nor `""` |

## 12. Change data capture listener

### 12.1. Description

`postgresql:CdcListener` is a `cdc:Listener` that captures row changes of a PostgreSQL database through logical replication by running the Debezium PostgreSQL connector. Services, events, the listener lifecycle and the common configuration are specified in the [CDC specification](https://github.com/ballerina-platform/module-ballerinax-cdc/blob/main/docs/spec/spec.md); this section specifies the PostgreSQL-specific configuration. The program MUST provide the Debezium PostgreSQL connector, for example by importing `ballerinax/postgresql.cdc.driver`, and the server MUST have logical replication enabled (`wal_level` `logical`).

### 12.2. Configuration

The initializer takes the fields of `postgresql:PostgresListenerConfiguration` as named arguments. It includes `cdc:ListenerConfiguration` and adds:

| Field | Type | Default | Meaning |
|---|---|---|---|
| `database` | `postgresql:PostgresDatabaseConnection` | Required | Server connection, logical decoding settings and capture filters. |
| `options` | `postgresql:PostgreSqlOptions` | `{}` | CDC options. |

`postgresql:PostgresDatabaseConnection` includes `cdc:DatabaseConnection` (which holds, among others, `username`, `password`, `connectTimeout` and `secure`) and adds or overrides the following fields. Each field sets the Debezium property named in the last column; a list is joined with `,`.

| Field | Type | Default | Meaning | Debezium property |
|---|---|---|---|---|
| `connectorClass` | `string` | `"io.debezium.connector.postgresql.PostgresConnector"` | Debezium connector class. | `connector.class` |
| `hostname` | `string` | `"localhost"` | Server host. | `database.hostname` |
| `port` | `int` | `5432` | Server port. | `database.port` |
| `databaseName` | `string` | Required | Database to capture. | `database.dbname` |
| `includedSchemas` | `string\|string[]` | absent | Regular expressions of the schemas to capture. | `schema.include.list` |
| `excludedSchemas` | `string\|string[]` | absent | Regular expressions of the schemas not to capture. | `schema.exclude.list` |
| `includedTables`, `excludedTables`, `includedColumns`, `excludedColumns`, `messageKeyColumns` | as in `cdc:DatabaseConnection` | absent | Table and column filters and message keys, set as the CDC specification states. | as in the CDC specification |
| `tasksMax` | `int` | `1` | Number of connector tasks. The PostgreSQL connector always uses one task. | `tasks.max` |
| `pluginName` | `postgresql:PostgreSQLLogicalDecodingPlugin` | `PGOUTPUT` | Deprecated since 1.17.0. Use `replicationConfig.pluginName`. Logical decoding plugin, used when `replicationConfig` is absent. | `plugin.name` |
| `slotName` | `string` | `"debezium"` | Deprecated since 1.17.0. Use `replicationConfig.slotName`. Replication slot, used when `replicationConfig` is absent. | `slot.name` |
| `publicationName` | `string` | `"dbz_publication"` | Deprecated since 1.17.0. Use `publicationConfig.publicationName`. Publication, used when `publicationConfig` is absent. | `publication.name` |
| `replicationConfig` | `postgresql:ReplicationConfiguration` | absent | Logical decoding settings. | see below |
| `publicationConfig` | `postgresql:PublicationConfiguration` | absent | Publication settings. | see below |
| `streamingConfig` | `postgresql:StreamingConfiguration` | absent | Status update settings. | see below |

| Record | Field | Type | Default | Meaning | Debezium property |
|---|---|---|---|---|---|
| `postgresql:ReplicationConfiguration` | `pluginName` | `postgresql:PostgreSQLLogicalDecodingPlugin` | `PGOUTPUT` | Logical decoding plugin: `PGOUTPUT` (`"pgoutput"`) or `DECODERBUFS` (`"decoderbufs"`). | `plugin.name` |
| | `slotName` | `string` | `"debezium"` | Name of the logical replication slot. | `slot.name` |
| | `slotDropOnStop` | `boolean` | `false` | Whether the slot is dropped when the listener stops. | `slot.drop.on.stop` |
| | `slotStreamParams` | `string` | absent | Parameters passed to the decoding plugin. | `slot.stream.params` |
| `postgresql:PublicationConfiguration` | `publicationName` | `string` | `"dbz_publication"` | Name of the publication (`pgoutput` only). | `publication.name` |
| | `publicationAutocreateMode` | `postgresql:PublicationAutocreateMode` | `ALL_TABLES` | `ALL_TABLES` (`"all_tables"`): a missing publication is created for all tables; `FILTERED` (`"filtered"`): for the captured tables; `DISABLED` (`"disabled"`): not created. | `publication.autocreate.mode` |
| `postgresql:StreamingConfiguration` | `statusUpdateInterval` | `decimal` | `10` | Interval between status updates sent to the server. | `status.update.interval.ms` |
| | `xminFetchInterval` | `decimal` | `0` | Interval at which the oldest transaction ID is read. `0` disables it. | `xmin.fetch.interval.ms` |
| | `lsnFlushMode` | `postgresql:LsnFlushMode` | absent | LSN flushing strategy: `MANUAL` (`"manual"`), `CONNECTOR` (`"connector"`) or `CONNECTOR_AND_DRIVER` (`"connector_and_driver"`). | `lsn.flush.mode` |
| `postgresql:ExtendedSnapshotConfiguration` | `lockTimeout` | `decimal` | `10` | Timeout for acquiring the table locks of a snapshot. | `snapshot.lock.timeout.ms` |
| | `isolationMode` | `cdc:SnapshotIsolationMode` | absent | Transaction isolation mode of a snapshot. | `snapshot.isolation.mode` |

`postgresql:ExtendedSnapshotConfiguration` also includes the fields of `cdc:RelationalExtendedSnapshotConfiguration`, set as the CDC specification states.

`postgresql:PostgreSqlOptions` includes `cdc:Options` and adds:

| Field | Type | Default | Meaning |
|---|---|---|---|
| `extendedSnapshot` | `postgresql:ExtendedSnapshotConfiguration` | absent | Snapshot settings. |
| `dataTypeConfig` | `cdc:DataTypeConfiguration` | absent | Data type handling, set as the CDC specification states. |
| `heartbeatConfig` | `cdc:RelationalHeartbeatConfiguration` | absent | Heartbeat settings, set as the CDC specification states. |

A time value in seconds is converted to milliseconds and truncated towards zero for its Debezium property.

### 12.3. Behaviour

1. The initializer converts the configuration to Debezium properties: first the properties of the `cdc` library for the common configuration, then the PostgreSQL properties of [§12.2](#122-configuration), then the fields of `options` that are not declared by `postgresql:PostgreSqlOptions`. A later property replaces an earlier one with the same name.
2. When `replicationConfig` is present, its fields set `plugin.name`, `slot.name` and `slot.drop.on.stop`, and the deprecated `pluginName` and `slotName` are ignored. Otherwise `pluginName` and `slotName` set `plugin.name` and `slot.name`, and `slot.drop.on.stop` is `false`.
3. When `publicationConfig` is present, its fields set `publication.name` and `publication.autocreate.mode`, and the deprecated `publicationName` is ignored. Otherwise `publicationName` sets `publication.name`, and `publication.autocreate.mode` is `all_tables`.
4. A field of `options` that is not declared by `postgresql:PostgreSqlOptions` is set as the Debezium property of its name when its value is a `string`, `int`, `boolean`, `decimal` or `float`, as the CDC specification states.
5. A property of a record field that is absent is not set, and the Debezium default applies.
6. `attach`, `detach`, `start`, `gracefulStop` and `immediateStop` behave as specified in the CDC specification. On `start`, the Debezium connector creates the replication slot and, as `publicationAutocreateMode` states, the publication, when they do not exist. With `FILTERED`, an existing publication of that name is changed to cover exactly the captured tables (Debezium-defined).

#### 12.3.1. Example: Capturing one table

```ballerina
import ballerina/log;
import ballerinax/cdc;
import ballerinax/postgresql;
import ballerinax/postgresql.cdc.driver as _;

listener postgresql:CdcListener orders = new (database = {
    username: "cdc",
    password: "secret",
    databaseName: "shop",
    includedTables: "public.orders",
    replicationConfig: {slotName: "orders_slot"},
    publicationConfig: {publicationName: "orders_pub", publicationAutocreateMode: postgresql:FILTERED}
});

service cdc:Service on orders {
    # Logs each inserted order.
    remote function onCreate(record {} after, string tableName) returns error? {
        log:printInfo("order created", 'table = tableName, row = after);
    }
}
```

The listener reads changes of `public.orders` from the slot `orders_slot` with the `pgoutput` plugin, and on start creates the publication `orders_pub` for that table only when it does not exist ([§12.2](#122-configuration), [§12.3](#123-behaviour) rules 2, 3 and 6).

### 12.4. Errors

The listener returns the errors of the CDC specification. In particular, a configuration that the Debezium PostgreSQL connector rejects, or a server without logical replication, makes `start` return a `cdc:Error`. If the Debezium PostgreSQL connector is not available, the initializer and `attach` succeed and `start` returns a `cdc:Error`.

### 12.5. Interactions

- The listener does not use the `postgresql:Client`, its options or its pools. Its TLS and connection settings are those of `cdc:DatabaseConnection` and Debezium properties.
- A replication slot keeps the server's write-ahead log from being removed until the listener has consumed it. A slot that is not dropped on stop (`slotDropOnStop` `false`) keeps it while the listener is not running.
- Two listeners that use the same slot cannot run at the same time. `start` of the second listener returns `()` without an error, and that listener receives no events while the other listener keeps the slot active, so a second listener can stand by for the first.

## 13. Security considerations

1. The security considerations of [SQL §18](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#18-security-considerations) apply, including rule 2 on clients that share a pool through the global pool configuration; a client given its own `sql:ConnectionPool` value does not share a pool with clients that use other credentials.
2. `host` and `database` are placed in the connection URL without validation or escaping, so they MUST be trusted input: a value containing URL syntax can change the server, the database or driver properties, such as `sslmode` ([§3.4](#34-connection-url) rule 5). The initializer logs a warning for such a value ([§3.4](#34-connection-url) rule 6); it is rejected in the next major version ([§14](#14-planned-changes)).
3. When `options` is given without `ssl`, the connection is not encrypted, and the initializer logs a warning ([§5.3](#53-behaviour) rule 2); in the next major version the driver's default mode `prefer` applies instead ([§14](#14-planned-changes)). Without `options`, the driver's default mode `prefer` applies. With `PREFER` and `ALLOW`, the connection is unencrypted when the server does not support encryption, or, for `ALLOW`, when the server accepts unencrypted connections. With `PREFER`, `ALLOW` and `REQUIRE`, the server certificate is not verified, so the connection is not protected against an attacker who can intercept it. Setting `ssl.mode` explicitly to `VERIFY_CA` verifies the certificate chain, and `VERIFY_FULL` also the host name.
4. With `username` `()`, the driver connects as the operating system user that runs the program ([§3.2](#32-configuration)).
5. `password`, the private key password and the key store password are passed to the driver as data source properties; they do not appear in the metric tags ([§11.2](#112-metric-tags)), but `host`, `port` and `database` do.
6. With the default `socketTimeout` of `0`, an operation waits for a server that does not respond for as long as the connection stays open.
7. The wait for a connection of an exhausted pool is bounded by the pool's `connectionTimeout` alone ([§4.3](#43-driver-properties) rule 3, [SQL §4.2](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#42-configuration)); `connectTimeout` bounds only the opening of a connection to the server.
8. The literals of `postgresql:CustomTypeValue` and of range records quote and escape each value ([§7.3](#73-typed-value-classes) rules 4 and 7), so a value from untrusted input cannot change which fields or bounds are stored, and the statement itself cannot change, because the literal is bound as a parameter.
9. The CDC listener reads every change of the captured tables, which requires a user with the `REPLICATION` attribute; with `publicationAutocreateMode` `ALL_TABLES`, the publication it creates covers every table of the database. Its offsets and schema history are stored as configured in the CDC specification, by default in local files. A replication slot that is not consumed retains write-ahead log on the server ([§12.5](#125-interactions)).

## 14. Planned changes

This section is informative. It lists behaviour changes planned for the next major version; the rest of this specification describes the current release.

| Change | Affected rule | Current behaviour | Planned behaviour | How to keep the current behaviour |
|---|---|---|---|---|
| TLS when `options` is given without `ssl` | [§5.3](#53-behaviour) rule 2 | `sslmode` `DISABLE`, with a warning at initialization. | The driver's default mode `prefer` applies, as when `options` is `()`. | Give `ssl: {mode: postgresql:DISABLE}`. |
| Generated keys only for `INSERT` and `MERGE` | [§3.5](#35-operations) rules 2 and 3, [§4.2](#42-configuration) | `generatedKeysMode` defaults to `sql:ALL_STATEMENTS`: generated keys are requested for every statement except DDL, so `UPDATE` and `DELETE` set `lastInsertId` to the first column of the first affected row. | `generatedKeysMode` defaults to `sql:INSERT_ONLY`: generated keys are requested only for the statements of [SQL §10.4](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#104-generated-keys) rule 7; other statements give a `lastInsertId` of `()`. | Set `generatedKeysMode: sql:ALL_STATEMENTS`, or read the values of updated or deleted rows with `query` and a `RETURNING` clause. |
| Rejection of URL syntax in `host` and `database` | [§3.4](#34-connection-url) rules 5 and 6 | Inserted into the URL as given, with a warning at initialization. | The initializer returns an `sql:ApplicationError` when `host` or `database` contains a character of [§3.4](#34-connection-url) rule 6. | None; use the options of [§4](#4-connection-options) for driver properties. |
| Error for an unparsable geometric string | [§7.3](#73-typed-value-classes) rule 1 | `sql:DatabaseError`. | `sql:ConversionError`. | Handle `sql:Error`, which covers both. |
| `time:Civil` without offset in a `tstzrange` | [§7.3](#73-typed-value-classes) rule 5 | Interpreted as UTC. | Interpreted in the session time zone, as a `time:Civil` bound directly ([§8.5](#85-time-zones) rule 4). | Give the bound an explicit `utcOffset`, such as `{hours: 0}`. |
| Zoned reading of `timetz` and `timestamptz` | [§8.3](#83-postgresql-column-types), [§8.5](#85-time-zones) rules 2 and 3 | Read as `TIME` and `TIMESTAMP` values in the JVM default time zone, without `utcOffset`. | Read with the zoned rows of [SQL §7.6](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md#76-column-conversion) (`TIME_WITH_TIMEZONE`, `TIMESTAMP_WITH_TIMEZONE`), with the value's offset. | Read `timestamptz` into `time:Utc`, or convert the value in SQL, for example with `AT TIME ZONE`. |
| `utcOffset` of `tsrange` bounds | [§8.4](#84-postgresql-record-targets) rule 5 | `postgresql:TimestampCivilRange` bounds carry the offset of the JVM default time zone. | They carry no `utcOffset`. | Compute the offset from the JVM default time zone in the program. |
| Empty and unbounded ranges | [§8.4](#84-postgresql-record-targets) rule 6 | `sql:ConversionError`. | Range records have nilable `upper` and `lower` and an empty-range flag, so these ranges are read. | Read the range into `string`. |

## References

- [SQL specification](https://github.com/ballerina-platform/module-ballerina-sql/blob/master/docs/spec/spec.md)
- [CDC specification](https://github.com/ballerina-platform/module-ballerinax-cdc/blob/main/docs/spec/spec.md)
- [pgjdbc connection parameters](https://jdbc.postgresql.org/documentation/use/#connection-parameters)
- [PostgreSQL data types](https://www.postgresql.org/docs/current/datatype.html)
- [Debezium connector for PostgreSQL](https://debezium.io/documentation/reference/stable/connectors/postgresql.html)
- [RFC 2119: Key words for use in RFCs to Indicate Requirement Levels](https://www.rfc-editor.org/rfc/rfc2119)
- [RFC 8174: Ambiguity of Uppercase vs Lowercase in RFC 2119 Key Words](https://www.rfc-editor.org/rfc/rfc8174)
