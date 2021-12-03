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

import ballerina/io;
import ballerinax/postgresql;
import ballerina/sql;
import ballerina/time;

// The username , password and name of the PostgreSQL database
configurable string dbUsername = "postgres";
configurable string dbPassword = "postgres";
configurable string dbName = "postgres";
configurable int port = 5432;

// The `JsonType` record to represent the `JSON_TYPES` database table.
public type JsonType record {
    int row_id;
    json? json_type;
    json? jsonb_type;
    string? jsonpath_type;
};

// The `RangeType` record to represent the `RANGE_TYPES` database table.
type RangeType record {|
    int row_id;
    postgresql:IntegerRange? int4range_type;
    postgresql:LongRange? int8range_type;
    postgresql:NumericRange? numrange_type;
    postgresql:TimestampRange? tsrange_type;
    postgresql:TimestamptzRange? tstzrange_type;
    postgresql:DateRange? daterange_type;
|};

// The `DateTimeType` record to represent the `DATE_TIME_TYPES` database table.
type DateTimeType record {|
    int row_id;
    time:Date? date_type;
    time:TimeOfDay? time_type;
    time:TimeOfDay? timetz_type;
    time:Civil? timestamp_type;
    time:Civil? timestamptz_type;
    postgresql:Interval? interval_type;
|};

public function main() returns error? {
    // Runs the prerequisite setup for the example.
    check beforeExample();

    // Initializes the PostgreSQL client.
    postgresql:Client dbClient = check new (username = dbUsername, 
                password = dbPassword, database = dbName);

    // Since the `rowType` is provided as a `JonType`, the `resultStream`
    // will have `JonType` records.
    stream<JsonType, error?> jsonStream = 
                dbClient->query(`SELECT * FROM JSON_TYPES`);

    io:println("Json types Result :");
    // Iterates the `binaryResultStream`.
    check jsonStream.forEach(function(JsonType result) {
        io:println(result);
    });

    // Since the `rowType` is provided as an `RangeType`, the `resultStream2` will
    // have `RangeType` records.
    stream<RangeType, error?> rangeStream = 
                dbClient->query(`SELECT * FROM RANGE_TYPES`);

    io:println("Range type Result :");
    // Iterates the `jsonResultStream`.
    check rangeStream.forEach(function(RangeType result) {
        io:println(result);
    });

    // Since the `rowType` is provided as a `DateTimeType`, the `resultStream3`
    // will have `DateTimeType` records. The `Date`, `Time`, `DateTime`, and
    // `Timestamp` fields of the database table can be mapped to `time:Utc`,
    // string, and int types in Ballerina.
    stream<DateTimeType, error?> dateStream = 
                dbClient->query(`SELECT * FROM DATE_TIME_TYPES`);

    io:println("DateTime types Result :");
    // Iterates the `dateResultStream`.
    check dateStream.forEach(function(DateTimeType result) {
        io:println(result);
    });

    // Closes the PostgreSQL client.
    check dbClient.close();
}

// Initializes the database as a prerequisite to the example.
function beforeExample() returns sql:Error? {
    // Initializes the PostgreSQL client.
    postgresql:Client dbClient = check new (username = dbUsername, 
                password = dbPassword, database = dbName);

    // Create complex data type tables in the database.
    _ = check dbClient->execute(`DROP TABLE IF EXISTS JSON_TYPES`);
    _ = check dbClient->execute(`CREATE TABLE IF NOT EXISTS JSON_TYPES(row_id SERIAL,
            json_type JSON, jsonb_type JSONB, jsonpath_type JSONPATH,
            PRIMARY KEY(row_id))`);

    _ = check dbClient->execute(`DROP TABLE IF EXISTS DATE_TIME_TYPES`);
    _ = check dbClient->execute(
            `CREATE TABLE IF NOT EXISTS DATE_TIME_TYPES (row_id SERIAL, time_type TIME,
            timetz_type TIMETZ, timestamp_type TIMESTAMP,
            timestamptz_type TIMESTAMPTZ, date_type DATE,
            interval_type INTERVAL, PRIMARY KEY(row_id))`);

    _ = check dbClient->execute(`DROP TABLE IF EXISTS RANGE_TYPES`);
    _ = check dbClient->execute(
            `CREATE TABLE IF NOT EXISTS RANGE_TYPES (row_id SERIAL,
            int4range_type INT4RANGE, int8range_type INT8RANGE, numrange_type NUMRANGE,
            tsrange_type TSRANGE, tstzrange_type TSTZRANGE, daterange_type DATERANGE,
            PRIMARY KEY(row_id))`);

    // Adds the records to the newly-created tables.
    _ = check dbClient->execute(
            `INSERT INTO JSON_TYPES(json_type, jsonb_type, jsonpath_type)
             VALUES(
             '{"key1": "value", "key2": 2}', '{"key1": "value", "key2": 2}',
             '$."floor"[*]."apt"[*]?(@."area" > 40 && @."area" < 90)?(@."rooms" > 1)')`);
    _ = check dbClient->execute(
            `INSERT INTO DATE_TIME_TYPES(time_type, timetz_type, timestamp_type,
             timestamptz_type, date_type, interval_type)
             VALUES(
             '04:05:06', '2003-04-12 04:05:06 America/New_York', '1999-01-08 04:05:06',
             '2004-10-19 10:23:54+02', '1999-01-08', 'P1Y2M3DT4H5M6.0S')`);
    _ = check dbClient->execute(
            `INSERT INTO RANGE_TYPES(int4range_type, int8range_type, numrange_type,
              tsrange_type, tstzrange_type, daterange_type)
              VALUES('(2,50)', '(10,100)', '(0,24)', '(2010-01-01 14:30, 2010-01-01 15:30)',
             '(2010-01-01 14:30, 2010-01-01 15:30)', '(2010-01-01 14:30, 2010-01-03 )')`);
    // Closes the PostgreSQL client.
    check dbClient.close();
}
