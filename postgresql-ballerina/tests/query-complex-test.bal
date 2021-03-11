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

import ballerina/sql;
import ballerina/test;
import ballerina/time;

public type NumericRecord record {
    int row_id;
    int smallint_type;
    int int_type;
    int bigint_type;
    decimal decimal_type;
    decimal numeric_type;
    float real_type;
    float double_type;
    int smallserial_type;
    int serial_type;
    int bigserial_type;
};

public type NumericRecord2 record {
    int row_id;
    int? smallint_type;
    int? int_type;
    int? bigint_type;
    decimal? decimal_type;
    decimal? numeric_type;
    float? real_type;
    float? double_type;
};

@test:Config {
    groups: ["datatypes"]
}
function testSelectFromNumericDataTable() {
    int rowId = 1;
    
    sql:ParameterizedQuery sqlQuery = `select * from Numerictypes where row_id = ${rowId}`;

    _ = validateNumericTableResult(simpleQueryPostgresqlClient(sqlQuery, NumericRecord, database = "query_db"));
}

public function validateNumericTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        decimal decimalVal = 123.456;
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["smallint_type"], 1);
        test:assertEquals(returnData["int_type"], 123);
        test:assertEquals(returnData["bigint_type"], 123456);
        test:assertEquals(returnData["decimal_type"], decimalVal);
        test:assertEquals(returnData["numeric_type"], decimalVal);
        test:assertTrue(returnData["real_type"] is float);
        test:assertTrue(returnData["double_type"] is float);
        test:assertEquals(returnData["smallserial_type"], 1);
        test:assertEquals(returnData["serial_type"], 123);
        test:assertEquals(returnData["bigserial_type"], 123456);
    } 
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testSelectFromNumericDataTable]
}
function testSelectFromNumericDataTable2() {
    int rowId = 2;
    
    sql:ParameterizedQuery sqlQuery = `select * from Numerictypes2 where row_id = ${rowId}`;

    _ = validateNumericTableResult2(simpleQueryPostgresqlClient(sqlQuery, NumericRecord2, database = "query_db"));
}

public function validateNumericTableResult2(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 2);
        test:assertEquals(returnData["smallint_type"], ());
        test:assertEquals(returnData["int_type"], ());
        test:assertEquals(returnData["bigint_type"], ());
        test:assertEquals(returnData["decimal_type"], ());
        test:assertEquals(returnData["numeric_type"], ());
        test:assertEquals(returnData["real_type"], ());
        test:assertEquals(returnData["double_type"], ());
    } 
}

public type CharacterRecord record {
    int row_id;
    string? char_type;
    string? varchar_type;
    string? text_type;
    string? name_type;
};

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testSelectFromNumericDataTable2]
}
function testSelectFromCharacterDataTable() {
    int rowId = 1;
    
    sql:ParameterizedQuery sqlQuery = `select * from charactertypes where row_id = ${rowId}`;

    _ = validateCharacterTableResult(simpleQueryPostgresqlClient(sqlQuery, CharacterRecord, database = "query_db"));
}

public function validateCharacterTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["char_type"], "This is a char1");
        test:assertEquals(returnData["varchar_type"], "This is a varchar1");
        test:assertEquals(returnData["text_type"], "This is a text1");   
        test:assertEquals(returnData["name_type"], "This is a name1");
    } 
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testSelectFromCharacterDataTable]
}
function testSelectFromCharacterDataTable2() {
    int rowId = 3;
    
    sql:ParameterizedQuery sqlQuery = `select * from charactertypes where row_id = ${rowId}`;

    _ = validateCharacterTableResult2(simpleQueryPostgresqlClient(sqlQuery, CharacterRecord, database = "query_db"));
}

public function validateCharacterTableResult2(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 3);
        test:assertEquals(returnData["char_type"], ());
        test:assertEquals(returnData["varchar_type"], ());
        test:assertEquals(returnData["text_type"], ());   
        test:assertEquals(returnData["name_type"], ());
    } 
}

public type BooleanRecord record {
  int row_id;
  boolean? boolean_type;
};

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testSelectFromCharacterDataTable2]
}
function testSelectFromBooleanDataTable() {
    int rowId = 1;
    
    sql:ParameterizedQuery sqlQuery = `select * from booleantypes where row_id = ${rowId}`;

    _ = validateBooleanTableResult(simpleQueryPostgresqlClient(sqlQuery, BooleanRecord, database = "query_db"));
}

public function validateBooleanTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["boolean_type"], true);
    } 
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testSelectFromBooleanDataTable]
}
function testSelectFromBooleanDataTable2() {
    int rowId = 2;
    
    sql:ParameterizedQuery sqlQuery = `select * from booleantypes where row_id = ${rowId}`;

    _ = validateBooleanTableResult2(simpleQueryPostgresqlClient(sqlQuery, BooleanRecord, database = "query_db"));
}

public function validateBooleanTableResult2(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 2);
        test:assertEquals(returnData["boolean_type"], ());
    } 
}

public type NetworkRecord record {
    
    int row_id;
    string? inet_type;
    string? cidr_type;
    string? macaddr_type;
    string? macaddr8_type;
};

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testSelectFromBooleanDataTable2]
}
function testSelectFromNetworkDataTable() {
    int rowId = 1;
    
    sql:ParameterizedQuery sqlQuery = `select * from networktypes where row_id = ${rowId}`;

    _ = validateNetworkTableResult(simpleQueryPostgresqlClient(sqlQuery, NetworkRecord, database = "query_db"));
}

public function validateNetworkTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["inet_type"], "192.168.0.1/24");
        test:assertEquals(returnData["cidr_type"], "::ffff:1.2.3.0/120");
        test:assertEquals(returnData["macaddr_type"], "08:00:2b:01:02:03");   
        test:assertEquals(returnData["macaddr8_type"], "08:00:2b:01:02:03:04:05");
    } 
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testSelectFromNetworkDataTable]
}
function testSelectFromNetworkDataTable2() {
    int rowId = 2;
    
    sql:ParameterizedQuery sqlQuery = `select * from networktypes where row_id = ${rowId}`;

    _ = validateNetworkTableResult2(simpleQueryPostgresqlClient(sqlQuery, NetworkRecord, database = "query_db"));
}

public function validateNetworkTableResult2(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 2);
        test:assertEquals(returnData["inet_type"], ());
        test:assertEquals(returnData["cidr_type"], ());
        test:assertEquals(returnData["macaddr_type"], ());   
        test:assertEquals(returnData["macaddr8_type"], ());
    } 
}

public type GeometricRecord record {
    int row_id;
    string? point_type;
    string? line_type;
    string? lseg_type;
    string? box_type;
    string? circle_type;
    string? path_type;
    string? polygon_type;
};

public type GeometricRecord2 record {
    int row_id;
    PointRecordType? point_type;
    Line? line_type;
    LsegRecordType? lseg_type;
    BoxRecordType? box_type;
    CircleRecordType? circle_type;
    string? path_type;
    string? polygon_type;
};

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testSelectFromNetworkDataTable2]
}
function testSelectFromGeometricDataTable() {
    int rowId = 1;

    sql:ParameterizedQuery sqlQuery = `select * from geometrictypes where row_id = ${rowId}`;

     _ = validateGeometricTableResult(simpleQueryPostgresqlClient(sqlQuery, GeometricRecord, database = "query_db"));
}

public function validateGeometricTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["point_type"], "(1,2)");
        test:assertEquals(returnData["line_type"], "{1,2,3}");
        test:assertEquals(returnData["lseg_type"], "[(1,1),(2,2)]");   
        test:assertEquals(returnData["box_type"], "(2,2),(1,1)"); 
        test:assertEquals(returnData["circle_type"], "<(1,1),1>");
    } 
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testSelectFromNetworkDataTable]
}
function testSelectFromGeometricDataTable2() {
    int rowId = 1;

    sql:ParameterizedQuery sqlQuery = `select * from geometrictypes where row_id = ${rowId}`;

     _ = validateGeometricTableResult2(simpleQueryPostgresqlClient(sqlQuery, GeometricRecord2, database = "query_db"));
}

public function validateGeometricTableResult2(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        PointRecordType pointRecordType = {x: 1, y: 2};
        Line lineRecordType = {a: 1, b: 2, c: 3};
        LsegRecordType lsegRecordType = {x1: 1, y1: 1, x2: 2, y2: 2};
        BoxRecordType boxRecordType = {x1: 1, y1: 1, x2: 2, y2: 2};
        CircleRecordType circleRecordType = {x: 1, y:1, r: 1};
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["point_type"], pointRecordType);
        test:assertEquals(returnData["line_type"], lineRecordType);
        test:assertEquals(returnData["lseg_type"], lsegRecordType);   
        test:assertEquals(returnData["box_type"], boxRecordType); 
        test:assertEquals(returnData["circle_type"], circleRecordType);
    } 
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testSelectFromGeometricDataTable]
}
function testSelectFromGeometricDataTable3() {
    int rowId = 2;

    sql:ParameterizedQuery sqlQuery = `select * from geometrictypes where row_id = ${rowId}`;

     _ = validateGeometricTableResult3(simpleQueryPostgresqlClient(sqlQuery, GeometricRecord, database = "query_db"));
}

public function validateGeometricTableResult3(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 2);
        test:assertEquals(returnData["point_type"], ());
        test:assertEquals(returnData["line_type"], ());
        test:assertEquals(returnData["lseg_type"], ());   
        test:assertEquals(returnData["box_type"], ()); 
        test:assertEquals(returnData["circle_type"], ());
    } 
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testSelectFromNetworkDataTable]
}
function testSelectFromGeometricDataTable4() {
    int rowId = 2;

    sql:ParameterizedQuery sqlQuery = `select * from geometrictypes where row_id = ${rowId}`;

     _ = validateGeometricTableResult4(simpleQueryPostgresqlClient(sqlQuery, GeometricRecord2, database = "query_db"));
}

public function validateGeometricTableResult4(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        PointRecordType? pointRecordType = ();
        Line? lineRecordType = ();
        LsegRecordType? lsegRecordType = ();
        BoxRecordType? boxRecordType = ();
        CircleRecordType? circleRecordType = ();
        test:assertEquals(returnData["row_id"], 2);
        test:assertEquals(returnData["point_type"], pointRecordType);
        test:assertEquals(returnData["line_type"], lineRecordType);
        test:assertEquals(returnData["lseg_type"], lsegRecordType);   
        test:assertEquals(returnData["box_type"], boxRecordType); 
        test:assertEquals(returnData["circle_type"], circleRecordType);
    } 
}

public type UuidRecord record {
  int row_id;
  string? uuid_type;
};

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testSelectFromGeometricDataTable3]
}
function testSelectFromUuidDataTable() {
    int rowId = 1;
    
    sql:ParameterizedQuery sqlQuery = `select * from uuidtypes where row_id = ${rowId}`;

    _ = validateUuidTableResult(simpleQueryPostgresqlClient(sqlQuery, UuidRecord, database = "query_db"));
}

public function validateUuidTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["uuid_type"], "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11");
    } 
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testSelectFromUuidDataTable]
}
function testSelectFromUuidDataTable2() {
    int rowId = 2;    
    sql:ParameterizedQuery sqlQuery = `select * from uuidtypes where row_id = ${rowId}`;

    _ = validateUuidTableResult2(simpleQueryPostgresqlClient(sqlQuery, UuidRecord, database = "query_db"));
}

public function validateUuidTableResult2(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 2);
        test:assertEquals(returnData["uuid_type"], ());
    } 
}

public type TextSearchRecord record {
  int row_id;
  string?? tsvector_type;
  string?? tsquery_type;
};

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testSelectFromUuidDataTable2]
}
function testSelectFromTextSearchDataTable() {
    int rowId = 1;
    
    sql:ParameterizedQuery sqlQuery = `select * from TextSearchTypes where row_id = ${rowId}`;

    _ = validateTextSearchTableResult(simpleQueryPostgresqlClient(sqlQuery, TextSearchRecord, database = "query_db"));
}

public function validateTextSearchTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["tsvector_type"], "'a' 'and' 'ate' 'cat' 'fat' 'mat' 'on' 'rat' 'sat'");
        test:assertEquals(returnData["tsquery_type"], "'fat' & 'rat'");
    } 
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testSelectFromTextSearchDataTable]
}
function testSelectFromTextSearchDataTable2() {
    int rowId = 2;
    
    sql:ParameterizedQuery sqlQuery = `select * from TextSearchTypes where row_id = ${rowId}`;

    _ = validateTextSearchTableResult2(simpleQueryPostgresqlClient(sqlQuery, TextSearchRecord, database = "query_db"));
}

public function validateTextSearchTableResult2(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 2);
        test:assertEquals(returnData["tsvector_type"], ());
        test:assertEquals(returnData["tsquery_type"], ());
    } 
}

public type JsonRecord record {
  int row_id;
  json? json_type;
  json? jsonb_type;
  string? jsonpath_type;
};

public type JsonRecord2 record {
  int row_id;
  string? json_type;
  string? jsonb_type;
  string? jsonpath_type;
};

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testSelectFromTextSearchDataTable2]
}
function testSelectFromJsonDataTable() {
    int rowId = 1;
    
    sql:ParameterizedQuery sqlQuery = `select * from JsonTypes where row_id = ${rowId}`;

    _ = validateJsonTableResult(simpleQueryPostgresqlClient(sqlQuery, JsonRecord, database = "query_db"));
}

public function validateJsonTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["json_type"], {"key1": "value", "key2": 2});
        test:assertEquals(returnData["jsonb_type"], {"key1": "value", "key2": 2});
        test:assertEquals(returnData["jsonpath_type"], "$.\"floor\"[*].\"apt\"[*]?(@.\"area\" > 40 && @.\"area\" < 90)?(@.\"rooms\" > 1)");
    } 
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testSelectFromJsonDataTable]
}
function testSelectFromJsonDataTable2() {
    int rowId = 1;
    
    sql:ParameterizedQuery sqlQuery = `select * from JsonTypes where row_id = ${rowId}`;

    _ = validateJsonTableResult2(simpleQueryPostgresqlClient(sqlQuery, JsonRecord2, database = "query_db"));
}

public function validateJsonTableResult2(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["json_type"], "{\"key1\": \"value\", \"key2\": 2}");
        test:assertEquals(returnData["jsonb_type"], "{\"key1\": \"value\", \"key2\": 2}");
        test:assertEquals(returnData["jsonpath_type"], "$.\"floor\"[*].\"apt\"[*]?(@.\"area\" > 40 && @.\"area\" < 90)?(@.\"rooms\" > 1)");
    } 
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testSelectFromJsonDataTable2]
}
function testSelectFromJsonDataTable3() {
    int rowId = 2;
    
    sql:ParameterizedQuery sqlQuery = `select * from JsonTypes where row_id = ${rowId}`;

    _ = validateJsonTableResult3(simpleQueryPostgresqlClient(sqlQuery, JsonRecord2, database = "query_db"));
}

public function validateJsonTableResult3(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 2);
        test:assertEquals(returnData["json_type"], ());
        test:assertEquals(returnData["jsonb_type"], ());
        test:assertEquals(returnData["jsonpath_type"], ());
    } 
}

// @test:Config {
//     groups: ["datatypes"],
//     dependsOn: [testSelectFromJsonDataTable3]
// }
// function testSelectFromJsonDataTable4() {
//     int rowId = 2;
    
//     sql:ParameterizedQuery sqlQuery = `select * from JsonTypes where row_id = ${rowId}`;

//     _ = validateJsonTableResult4(simpleQueryPostgresqlClient(sqlQuery, JsonRecord, database = "query_db"));
// }

// public function validateJsonTableResult4(record{}? returnData) {
//     if (returnData is ()) {
//         test:assertFail("Empty row returned.");
//     } else {
//         test:assertEquals(returnData["row_id"], 2);
//         test:assertEquals(returnData["json_type"], ());
//         test:assertEquals(returnData["jsonb_type"], ());
//         test:assertEquals(returnData["jsonpath_type"], ());
//     } 
// }


public type DateTimeRecord record {
  int row_id;
  string? date_type;
  string? time_type;
  string? timetz_type;
  string? timestamp_type;
  string? timestamptz_type;
  string? interval_type;
};

public type DateTimeRecord2 record {
  int row_id;
  time:Time? date_type;
  time:Time? time_type;
  time:Time? timetz_type;
  time:Time? timestamp_type;
  time:Time? timestamptz_type;
  IntervalRecordType? interval_type;
};

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testSelectFromJsonDataTable2]
}
function testSelectFromDateDataTable() {
    int rowId = 1;
    
    sql:ParameterizedQuery sqlQuery = `select * from DateTimeTypes where row_id = ${rowId}`;

    _ = validateDateTableResult(simpleQueryPostgresqlClient(sqlQuery, DateTimeRecord, database = "query_db"));
}

public function validateDateTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["time_type"], "09:35:06.000+05:30");
        test:assertEquals(returnData["timetz_type"], "13:35:06.000+05:30");
        test:assertEquals(returnData["timestamp_type"], "1999-01-08T10:05:06.000+06:00");
        test:assertEquals(returnData["timestamptz_type"], "2004-10-19T14:23:54.000+06:00");
        test:assertEquals(returnData["date_type"], "1999-01-08+06:00");
        test:assertEquals(returnData["interval_type"], "1 year 2 mons 3 days 04:05:06");
    } 
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testSelectFromDateDataTable]
}
function testSelectFromDateDataTable2() {
    int rowId = 2;
    
    sql:ParameterizedQuery sqlQuery = `select * from DateTimeTypes where row_id = ${rowId}`;

    _ = validateDateTableResult2(simpleQueryPostgresqlClient(sqlQuery, DateTimeRecord, database = "query_db"));
}

public function validateDateTableResult2(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 2);
        test:assertEquals(returnData["time_type"], ());
        test:assertEquals(returnData["timetz_type"], ());
        test:assertEquals(returnData["timestamp_type"], ());
        test:assertEquals(returnData["timestamptz_type"], ());
        test:assertEquals(returnData["date_type"], ());
        test:assertEquals(returnData["interval_type"], ());
    } 
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testSelectFromDateDataTable2]
}
function testSelectFromDateDataTable3() {
    int rowId = 1;
    
    sql:ParameterizedQuery sqlQuery = `select * from DateTimeTypes where row_id = ${rowId}`;

    _ = validateDateTableResult3(simpleQueryPostgresqlClient(sqlQuery, DateTimeRecord2, database = "query_db"));
}

public function validateDateTableResult3(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        IntervalRecordType intervalRecordType = {years: 1, months: 2, days: 3, hours: 4, minutes: 5, seconds: 6};
        test:assertEquals(returnData["row_id"], 1);
        test:assertTrue(returnData["time_type"] is time:Time);
        test:assertTrue(returnData["timetz_type"] is time:Time);
        test:assertTrue(returnData["timestamp_type"] is time:Time);
        test:assertTrue(returnData["timestamptz_type"] is time:Time);
        test:assertTrue(returnData["date_type"] is time:Time);
        test:assertEquals(returnData["interval_type"], intervalRecordType);
    } 
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testSelectFromDateDataTable3]
}
function testSelectFromDateDataTable4() {
    int rowId = 2;
    
    sql:ParameterizedQuery sqlQuery = `select * from DateTimeTypes where row_id = ${rowId}`;

    _ = validateDateTableResult4(simpleQueryPostgresqlClient(sqlQuery, DateTimeRecord2, database = "query_db"));
}

public function validateDateTableResult4(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        IntervalRecordType? intervalRecordType = ();
        test:assertEquals(returnData["row_id"], 2);
        test:assertEquals(returnData["time_type"] , ());
        test:assertEquals(returnData["timetz_type"] , ());
        test:assertEquals(returnData["timestamp_type"] , ());
        test:assertEquals(returnData["timestamptz_type"] , ());
        test:assertEquals(returnData["date_type"] , ());
        test:assertEquals(returnData["interval_type"], intervalRecordType);
    } 
}

public type RangeRecord record {
  int row_id;
  string? int4range_type;
  string? int8range_type;
  string? numrange_type;
  string? tsrange_type;
  string? tstzrange_type;
  string? daterange_type;
};

public type RangeRecord2 record {
  int row_id;
  Int4rangeType? int4range_type;
  Int8rangeType? int8range_type;
  NumrangeType? numrange_type;
  TsrangeType? tsrange_type;
  TstzrangeType? tstzrange_type;
  DaterangeType? daterange_type;
};

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testSelectFromDateDataTable2]
}
function testSelectFromRangeDataTable() {
    int rowId = 1;
    
    sql:ParameterizedQuery sqlQuery = `select * from RangeTypes where row_id = ${rowId}`;

    _ = validateRangeTableResult(simpleQueryPostgresqlClient(sqlQuery, RangeRecord, database = "query_db"));
}

public function validateRangeTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["int4range_type"], "[3,50)");
        test:assertEquals(returnData["int8range_type"], "[11,100)");
        test:assertEquals(returnData["numrange_type"], "(0,24)");
        test:assertEquals(returnData["tsrange_type"], "(\"2010-01-01 14:30:00\",\"2010-01-01 15:30:00\")");
        test:assertEquals(returnData["tstzrange_type"], "(\"2010-01-01 14:30:00+05:30\",\"2010-01-01 15:30:00+05:30\")");
        test:assertEquals(returnData["daterange_type"], "[2010-01-02,2010-01-03)");
    } 
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testSelectFromRangeDataTable]
}
function testSelectFromRangeDataTable2() {
    int rowId = 2;
    
    sql:ParameterizedQuery sqlQuery = `select * from RangeTypes where row_id = ${rowId}`;

    _ = validateRangeTableResult2(simpleQueryPostgresqlClient(sqlQuery, RangeRecord, database = "query_db"));
}

public function validateRangeTableResult2(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 2);
        test:assertEquals(returnData["int4range_type"], ());
        test:assertEquals(returnData["int8range_type"], ());
        test:assertEquals(returnData["numrange_type"], ());
        test:assertEquals(returnData["tsrange_type"], ());
        test:assertEquals(returnData["tstzrange_type"], ());
        test:assertEquals(returnData["daterange_type"], ());
    } 
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testSelectFromRangeDataTable2]
}
function testSelectFromRangeDataTable3() {
    int rowId = 1;
    
    sql:ParameterizedQuery sqlQuery = `select * from RangeTypes where row_id = ${rowId}`;

    _ = validateRangeTableResult3(simpleQueryPostgresqlClient(sqlQuery, RangeRecord2, database = "query_db"));
}

public function validateRangeTableResult3(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        Int4rangeType int4rangeRecordType = {upper: 50, lower :3, isLowerboundInclusive: true, isUpperboundInclusive: false};
        Int8rangeType  int8rangeRecordType = {upper: 100, lower : 11, isLowerboundInclusive: true, isUpperboundInclusive: false};
        NumrangeType numrangeRecordType = {upper: 24, lower : 0, isLowerboundInclusive: false, isUpperboundInclusive: false};
        TsrangeType tsrangeRecordType = {upper: "2010-01-01 15:30:00", lower: "2010-01-01 14:30:00"};
        TstzrangeType tstzrangeRecordType = {upper: "2010-01-01 15:30:00+05:30", lower: "2010-01-01 14:30:00+05:30"};
        DaterangeType daterangeRecordType = {upper: "2010-01-03", lower: "2010-01-02", isLowerboundInclusive: true};

        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["int4range_type"], int4rangeRecordType);
        test:assertEquals(returnData["int8range_type"], int8rangeRecordType);
        test:assertEquals(returnData["numrange_type"], numrangeRecordType);
        test:assertEquals(returnData["tsrange_type"], tsrangeRecordType);
        test:assertEquals(returnData["tstzrange_type"], tstzrangeRecordType);
        test:assertEquals(returnData["daterange_type"], daterangeRecordType);
    } 
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testSelectFromRangeDataTable3]
}
function testSelectFromRangeDataTable4() {
    int rowId = 2;
    
    sql:ParameterizedQuery sqlQuery = `select * from RangeTypes where row_id = ${rowId}`;

    _ = validateRangeTableResult4(simpleQueryPostgresqlClient(sqlQuery, RangeRecord2, database = "query_db"));
}

public function validateRangeTableResult4(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 2);
        test:assertEquals(returnData["int4range_type"], ());
        test:assertEquals(returnData["int8range_type"], ());
        test:assertEquals(returnData["numrange_type"], ());
        test:assertEquals(returnData["tsrange_type"], ());
        test:assertEquals(returnData["tstzrange_type"], ());
        test:assertEquals(returnData["daterange_type"], ());
    } 
}

public type BitRecord record {
  int row_id;
//   string bitstring_type;
  string? varbitstring_type;
  boolean? bit_type;
};

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testSelectFromRangeDataTable2]
}
function testSelectFromBitDataTable() {
    int rowId = 1;
    
    sql:ParameterizedQuery sqlQuery = `select row_id, varbitstring_type, bit_type from BitTypes where row_id = ${rowId}`;

    _ = validateBitTableResult(simpleQueryPostgresqlClient(sqlQuery, BitRecord, database = "query_db"));
}

public function validateBitTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["varbitstring_type"], "1101");
        test:assertEquals(returnData["bit_type"], true);
    } 
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testSelectFromBitDataTable]
}
function testSelectFromBitDataTable2() {
    int rowId = 2;
    
    sql:ParameterizedQuery sqlQuery = `select row_id, varbitstring_type, bit_type from BitTypes where row_id = ${rowId}`;

    _ = validateBitTableResult2(simpleQueryPostgresqlClient(sqlQuery, BitRecord, database = "query_db"));
}

public function validateBitTableResult2(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 2);
        test:assertEquals(returnData["varbitstring_type"], ());
        test:assertEquals(returnData["bit_type"], ());
    } 
}

public type PglsnRecord record {
  int row_id;
  string? pglsn_type;
};

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testSelectFromBitDataTable2]
}
function testSelectFromPglsnDataTable() {
    int rowId = 1;
    
    sql:ParameterizedQuery sqlQuery = `select * from Pglsntypes where row_id = ${rowId}`;

    _ = validatePglsnTableResult(simpleQueryPostgresqlClient(sqlQuery, PglsnRecord, database = "query_db"));
}

public function validatePglsnTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["pglsn_type"], "16/B374D848");
    } 
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testSelectFromPglsnDataTable]
}
function testSelectFromPglsnDataTable2() {
    int rowId = 2;
    
    sql:ParameterizedQuery sqlQuery = `select * from Pglsntypes where row_id = ${rowId}`;

    _ = validatePglsnTableResult2(simpleQueryPostgresqlClient(sqlQuery, PglsnRecord, database = "query_db"));
}

public function validatePglsnTableResult2(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 2);
        test:assertEquals(returnData["pglsn_type"], ());
    } 
}

public type ObjectidentifierRecord record {
  int row_id;
  string? oid_type;
  string? regclass_type;
  string? regconfig_type;
  string? regdictionary_type;
  string? regnamespace_type;
  string? regoper_type;
  string? regoperator_type;
  string? regproc_type;
  string? regprocedure_type;
  string? regrole_type;
  string? regtype_type;
};

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testSelectFromPglsnDataTable2]
}
function testSelectFromObjectidentifierDataTable() {
    int rowId = 1;
    
    sql:ParameterizedQuery sqlQuery = `select * from Objectidentifiertypes where row_id = ${rowId}`;

    _ = validateObjectidentifierTableResult(simpleQueryPostgresqlClient(sqlQuery, ObjectidentifierRecord, database = "query_db"));
}

public function validateObjectidentifierTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["oid_type"], "12");
        test:assertEquals(returnData["regclass_type"], "pg_type");
        test:assertEquals(returnData["regconfig_type"], "english");
        test:assertEquals(returnData["regdictionary_type"], "simple");
        test:assertEquals(returnData["regnamespace_type"], "pg_catalog");
        test:assertEquals(returnData["regoper_type"], "!");
        test:assertEquals(returnData["regoperator_type"], "*(integer,integer)");
        test:assertEquals(returnData["regproc_type"], "now");
        test:assertEquals(returnData["regprocedure_type"], "sum(integer)");
        test:assertEquals(returnData["regrole_type"], "postgres");
        test:assertEquals(returnData["regtype_type"], "integer");
    } 
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testSelectFromObjectidentifierDataTable]
}
function testSelectFromObjectidentifierDataTable2() {
    int rowId = 2;
    
    sql:ParameterizedQuery sqlQuery = `select * from Objectidentifiertypes where row_id = ${rowId}`;

    _ = validateObjectidentifierTableResult2(simpleQueryPostgresqlClient(sqlQuery, ObjectidentifierRecord, database = "query_db"));
}

public function validateObjectidentifierTableResult2(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 2);
        test:assertEquals(returnData["oid_type"], ());
        test:assertEquals(returnData["regclass_type"], ());
        test:assertEquals(returnData["regconfig_type"], ());
        test:assertEquals(returnData["regdictionary_type"], ());
        test:assertEquals(returnData["regnamespace_type"], ());
        test:assertEquals(returnData["regoper_type"], ());
        test:assertEquals(returnData["regoperator_type"], ());
        test:assertEquals(returnData["regproc_type"], ());
        test:assertEquals(returnData["regprocedure_type"], ());
        test:assertEquals(returnData["regrole_type"], ());
        test:assertEquals(returnData["regtype_type"], ());
    } 
}

function simpleQueryPostgresqlClient(@untainted string|sql:ParameterizedQuery sqlQuery, typedesc<record {}>? resultType = (), string database = simpleParamsDb)
returns @tainted record {}? {
    Client dbClient = checkpanic new (host, user, password, database, port);
    stream<record {}, error> streamData = dbClient->query(sqlQuery, resultType);
    record {|record {} value;|}? data = checkpanic streamData.next();
    checkpanic streamData.close();
    record {}? value = data?.value;
    checkpanic dbClient.close();
    return value;
}
