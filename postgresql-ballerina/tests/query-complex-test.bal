//// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
////
//// WSO2 Inc. licenses this file to you under the Apache License,
//// Version 2.0 (the "License"); you may not use this file except
//// in compliance with the License.
//// You may obtain a copy of the License at
////
//// http://www.apache.org/licenses/LICENSE-2.0
////
//// Unless required by applicable law or agreed to in writing,
//// software distributed under the License is distributed on an
//// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
//// KIND, either express or implied.  See the License for the
//// specific language governing permissions and limitations
//// under the License.
//
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
    groups: ["query"]
}
function testSelectFromNumericDataTable() returns error? {
    int rowId = 1;

    sql:ParameterizedQuery sqlQuery = `select * from Numerictypes where row_id = ${rowId}`;

    _ = validateNumericTableResult(check simpleQueryPostgresqlClient(sqlQuery, NumericRecord, database = queryComplexDatabase));
}

isolated function validateNumericTableResult(record{}? returnData) {
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
    groups: ["query"],
    dependsOn: [testSelectFromNumericDataTable]
}
function testSelectFromNumericDataTable2() returns error? {
    int rowId = 2;

    sql:ParameterizedQuery sqlQuery = `select * from Numerictypes2 where row_id = ${rowId}`;

    _ = validateNumericTableResult2(check simpleQueryPostgresqlClient(sqlQuery, NumericRecord2, database = queryComplexDatabase));
}

isolated function validateNumericTableResult2(record{}? returnData) {
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
    groups: ["query"],
    dependsOn: [testSelectFromNumericDataTable2]
}
function testSelectFromCharacterDataTable() returns error? {
    int rowId = 1;

    sql:ParameterizedQuery sqlQuery = `select * from charactertypes where row_id = ${rowId}`;

    _ = validateCharacterTableResult(check simpleQueryPostgresqlClient(sqlQuery, CharacterRecord, database = queryComplexDatabase));
}

isolated function validateCharacterTableResult(record{}? returnData) {
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
    groups: ["query"],
    dependsOn: [testSelectFromCharacterDataTable]
}
function testSelectFromCharacterDataTable2() returns error? {
    int rowId = 3;

    sql:ParameterizedQuery sqlQuery = `select * from charactertypes where row_id = ${rowId}`;

    _ = validateCharacterTableResult2(check simpleQueryPostgresqlClient(sqlQuery, CharacterRecord, database = queryComplexDatabase));
}

isolated function validateCharacterTableResult2(record{}? returnData) {
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
    groups: ["query"],
    dependsOn: [testSelectFromCharacterDataTable2]
}
function testSelectFromBooleanDataTable() returns error? {
    int rowId = 1;

    sql:ParameterizedQuery sqlQuery = `select * from booleantypes where row_id = ${rowId}`;

    _ = validateBooleanTableResult(check simpleQueryPostgresqlClient(sqlQuery, BooleanRecord, database = queryComplexDatabase));
}

isolated function validateBooleanTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["boolean_type"], true);
    }
}

@test:Config {
    groups: ["query"],
    dependsOn: [testSelectFromBooleanDataTable]
}
function testSelectFromBooleanDataTable2() returns error? {
    int rowId = 2;

    sql:ParameterizedQuery sqlQuery = `select * from booleantypes where row_id = ${rowId}`;

    _ = validateBooleanTableResult2(check simpleQueryPostgresqlClient(sqlQuery, BooleanRecord, database = queryComplexDatabase));
}

isolated function validateBooleanTableResult2(record{}? returnData) {
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
    groups: ["query"],
    dependsOn: [testSelectFromBooleanDataTable2]
}
function testSelectFromNetworkDataTable() returns error? {
    int rowId = 1;

    sql:ParameterizedQuery sqlQuery = `select * from networktypes where row_id = ${rowId}`;

    _ = validateNetworkTableResult(check simpleQueryPostgresqlClient(sqlQuery, NetworkRecord, database = queryComplexDatabase));
}

isolated function validateNetworkTableResult(record{}? returnData) {
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
    groups: ["query"],
    dependsOn: [testSelectFromNetworkDataTable]
}
function testSelectFromNetworkDataTable2() returns error? {
    int rowId = 2;

    sql:ParameterizedQuery sqlQuery = `select * from networktypes where row_id = ${rowId}`;

    _ = validateNetworkTableResult2(check simpleQueryPostgresqlClient(sqlQuery, NetworkRecord, database = queryComplexDatabase));
}

isolated function validateNetworkTableResult2(record{}? returnData) {
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
    Point? point_type;
    Line? line_type;
    LineSegment? lseg_type;
    Box? box_type;
    Circle? circle_type;
    Path? path_type;
    Polygon? polygon_type;
};

@test:Config {
    groups: ["query"],
    dependsOn: [testSelectFromNetworkDataTable2]
}
function testSelectFromGeometricDataTable() returns error? {
    int rowId = 1;

    sql:ParameterizedQuery sqlQuery = `select * from geometrictypes where row_id = ${rowId}`;

     _ = validateGeometricTableResult(check simpleQueryPostgresqlClient(sqlQuery, GeometricRecord, database = queryComplexDatabase));
}

isolated function validateGeometricTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["point_type"], "(1,2)");
        test:assertEquals(returnData["line_type"], "{1,2,3}");
        test:assertEquals(returnData["lseg_type"], "[(1,1),(2,2)]");
        test:assertEquals(returnData["box_type"], "(2,2),(1,1)");
        test:assertEquals(returnData["path_type"], "[(1,1),(2,2)]");
        test:assertEquals(returnData["polygon_type"], "((1,1),(2,2))");
        test:assertEquals(returnData["circle_type"], "<(1,1),1>");
    }
}

@test:Config {
    groups: ["query"],
    dependsOn: [testSelectFromNetworkDataTable]
}
function testSelectFromGeometricDataTable2() returns error? {
    int rowId = 1;

    sql:ParameterizedQuery sqlQuery = `select * from geometrictypes where row_id = ${rowId}`;

     _ = validateGeometricTableResult2(check simpleQueryPostgresqlClient(sqlQuery, GeometricRecord2, database = queryComplexDatabase));
}

isolated function validateGeometricTableResult2(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        Point pointRecordType = {x: 1, y: 2};
        Line lineRecordType = {a: 1, b: 2, c: 3};
        LineSegment lsegRecordType = {x1: 1, y1: 1, x2: 2, y2: 2};
        Box boxRecordType = {x1: 1, y1: 1, x2: 2, y2: 2};
        Circle circleRecordType = {x: 1, y:1, r: 1};
        Path pathRecordType = {open: true, points: [{x: 1, y: 1}, {x: 2, y:2}]};
        Polygon polygonRecordType = {points: [{x: 1, y: 1}, {x: 2, y:2}]};

        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["point_type"], pointRecordType);
        test:assertEquals(returnData["line_type"], lineRecordType);
        test:assertEquals(returnData["lseg_type"], lsegRecordType);
        test:assertEquals(returnData["box_type"], boxRecordType);
        test:assertEquals(returnData["path_type"], pathRecordType);
        test:assertEquals(returnData["polygon_type"], polygonRecordType);
        test:assertEquals(returnData["circle_type"], circleRecordType);
    }
}

@test:Config {
    groups: ["query"],
    dependsOn: [testSelectFromGeometricDataTable]
}
function testSelectFromGeometricDataTable3() returns error? {
    int rowId = 2;

    sql:ParameterizedQuery sqlQuery = `select * from geometrictypes where row_id = ${rowId}`;

     _ = validateGeometricTableResult3(check simpleQueryPostgresqlClient(sqlQuery, GeometricRecord, database = queryComplexDatabase));
}

isolated function validateGeometricTableResult3(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 2);
        test:assertEquals(returnData["point_type"], ());
        test:assertEquals(returnData["line_type"], ());
        test:assertEquals(returnData["lseg_type"], ());
        test:assertEquals(returnData["box_type"], ());
        test:assertEquals(returnData["path_type"], ());
        test:assertEquals(returnData["polygon_type"], ());
        test:assertEquals(returnData["circle_type"], ());
    }
}

@test:Config {
    groups: ["query"],
    dependsOn: [testSelectFromNetworkDataTable]
}
function testSelectFromGeometricDataTable4() returns error? {
    int rowId = 2;

    sql:ParameterizedQuery sqlQuery = `select * from geometrictypes where row_id = ${rowId}`;

     _ = validateGeometricTableResult4(check simpleQueryPostgresqlClient(sqlQuery, GeometricRecord2, database = queryComplexDatabase));
}

isolated function validateGeometricTableResult4(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        Point? pointRecordType = ();
        Line? lineRecordType = ();
        LineSegment? lsegRecordType = ();
        Box? boxRecordType = ();
        Circle? circleRecordType = ();
        Path? pathRecordType = ();
        Polygon? polygonRecordType = ();

        test:assertEquals(returnData["row_id"], 2);
        test:assertEquals(returnData["point_type"], pointRecordType);
        test:assertEquals(returnData["line_type"], lineRecordType);
        test:assertEquals(returnData["lseg_type"], lsegRecordType);
        test:assertEquals(returnData["box_type"], boxRecordType);
        test:assertEquals(returnData["path_type"], pathRecordType);
        test:assertEquals(returnData["polygon_type"], polygonRecordType);
        test:assertEquals(returnData["circle_type"], circleRecordType);
    }
}

public type UuidRecord record {
  int row_id;
  string? uuid_type;
};

@test:Config {
    groups: ["query"],
    dependsOn: [testSelectFromGeometricDataTable3]
}
function testSelectFromUuidDataTable() returns error? {
    int rowId = 1;

    sql:ParameterizedQuery sqlQuery = `select * from uuidtypes where row_id = ${rowId}`;

    _ = validateUuidTableResult(check simpleQueryPostgresqlClient(sqlQuery, UuidRecord, database = queryComplexDatabase));
}

isolated function validateUuidTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["uuid_type"], "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11");
    }
}

@test:Config {
    groups: ["query"],
    dependsOn: [testSelectFromUuidDataTable]
}
function testSelectFromUuidDataTable2() returns error? {
    int rowId = 2;
    sql:ParameterizedQuery sqlQuery = `select * from uuidtypes where row_id = ${rowId}`;

    _ = validateUuidTableResult2(check simpleQueryPostgresqlClient(sqlQuery, UuidRecord, database = queryComplexDatabase));
}

isolated function validateUuidTableResult2(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 2);
        test:assertEquals(returnData["uuid_type"], ());
    }
}

public type TextSearchRecord record {
  int row_id;
  string? tsvector_type;
  string? tsquery_type;
};

@test:Config {
    groups: ["query"],
    dependsOn: [testSelectFromUuidDataTable2]
}
function testSelectFromTextSearchDataTable() returns error? {
    int rowId = 1;

    sql:ParameterizedQuery sqlQuery = `select * from TextSearchTypes where row_id = ${rowId}`;

    _ = validateTextSearchTableResult(check simpleQueryPostgresqlClient(sqlQuery, TextSearchRecord, database = queryComplexDatabase));
}

isolated function validateTextSearchTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["tsvector_type"], "'a' 'and' 'ate' 'cat' 'fat' 'mat' 'on' 'rat' 'sat'");
        test:assertEquals(returnData["tsquery_type"], "'fat' & 'rat'");
    }
}

@test:Config {
    groups: ["query"],
    dependsOn: [testSelectFromTextSearchDataTable]
}
function testSelectFromTextSearchDataTable2() returns error? {
    int rowId = 2;

    sql:ParameterizedQuery sqlQuery = `select * from TextSearchTypes where row_id = ${rowId}`;

    _ = validateTextSearchTableResult2(check simpleQueryPostgresqlClient(sqlQuery, TextSearchRecord, database = queryComplexDatabase));
}

isolated function validateTextSearchTableResult2(record{}? returnData) {
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
    groups: ["query"],
    dependsOn: [testSelectFromTextSearchDataTable2]
}
function testSelectFromJsonDataTable() returns error? {
    int rowId = 1;

    sql:ParameterizedQuery sqlQuery = `select * from JsonTypes where row_id = ${rowId}`;

    _ = validateJsonTableResult(check simpleQueryPostgresqlClient(sqlQuery, JsonRecord, database = queryComplexDatabase));
}

isolated function validateJsonTableResult(record{}? returnData) {
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
    groups: ["query"],
    dependsOn: [testSelectFromJsonDataTable]
}
function testSelectFromJsonDataTable2() returns error? {
    int rowId = 1;

    sql:ParameterizedQuery sqlQuery = `select * from JsonTypes where row_id = ${rowId}`;

    _ = validateJsonTableResult2(check simpleQueryPostgresqlClient(sqlQuery, JsonRecord2, database = queryComplexDatabase));
}

isolated function validateJsonTableResult2(record{}? returnData) {
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
    groups: ["query"],
    dependsOn: [testSelectFromJsonDataTable2]
}
function testSelectFromJsonDataTable3() returns error? {
    int rowId = 2;

    sql:ParameterizedQuery sqlQuery = `select * from JsonTypes where row_id = ${rowId}`;

    _ = validateJsonTableResult3(check simpleQueryPostgresqlClient(sqlQuery, JsonRecord2, database = queryComplexDatabase));
}

isolated function validateJsonTableResult3(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 2);
        test:assertEquals(returnData["json_type"], ());
        test:assertEquals(returnData["jsonb_type"], ());
        test:assertEquals(returnData["jsonpath_type"], ());
    }
}

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
  time:Date? date_type;
  time:TimeOfDay? time_type;
  time:TimeOfDay? timetz_type;
  time:Civil? timestamp_type;
  time:Civil? timestamptz_type;
  Interval? interval_type;
};

@test:Config {
    groups: ["query"],
    dependsOn: [testSelectFromJsonDataTable2]
}
function testSelectFromDateDataTable() returns error? {
    int rowId = 1;

    sql:ParameterizedQuery sqlQuery = `select * from DateTimeTypes where row_id = ${rowId}`;

    _ = validateDateTableResult(check simpleQueryPostgresqlClient(sqlQuery, DateTimeRecord, database = queryComplexDatabase));
}

isolated function validateDateTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertTrue(returnData["time_type"] is string);
        test:assertTrue(returnData["timestamp_type"] is string);
        test:assertTrue(returnData["date_type"] is string);
        test:assertEquals(returnData["interval_type"], "1 year 2 mons 3 days 04:05:06");
    }
}

@test:Config {
    groups: ["query"],
    dependsOn: [testSelectFromDateDataTable]
}
function testSelectFromDateDataTable2() returns error? {
    int rowId = 2;

    sql:ParameterizedQuery sqlQuery = `select * from DateTimeTypes where row_id = ${rowId}`;

    _ = validateDateTableResult2(check simpleQueryPostgresqlClient(sqlQuery, DateTimeRecord, database = queryComplexDatabase));
}

isolated function validateDateTableResult2(record{}? returnData) {
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
    groups: ["query"],
    dependsOn: [testSelectFromDateDataTable2]
}
function testSelectFromDateDataTable3() returns error? {
    int rowId = 2;

    sql:ParameterizedQuery sqlQuery = `select * from DateTimeTypes where row_id = ${rowId}`;

    _ = validateDateTableResult3(check simpleQueryPostgresqlClient(sqlQuery, DateTimeRecord2, database = queryComplexDatabase));
}

isolated function validateDateTableResult3(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        Interval? intervalRecordType = ();
        test:assertEquals(returnData["row_id"], 2);
        test:assertEquals(returnData["time_type"] , ());
        test:assertEquals(returnData["timetz_type"] , ());
        test:assertEquals(returnData["timestamp_type"] , ());
        test:assertEquals(returnData["timestamptz_type"] , ());
        test:assertEquals(returnData["date_type"] , ());
        test:assertEquals(returnData["interval_type"], intervalRecordType);
    }
}

@test:Config {
    groups: ["query"],
    dependsOn: [testSelectFromDateDataTable3]
}
function testSelectFromDateDataTable4() returns error? {
    int rowId = 1;

    sql:ParameterizedQuery sqlQuery = `select * from DateTimeTypes where row_id = ${rowId}`;

    _ = validateDateTableResult4(check simpleQueryPostgresqlClient(sqlQuery, DateTimeRecord2, database = queryComplexDatabase));
}

isolated function validateDateTableResult4(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        Interval interval = {years: 1, months: 2, days: 3, hours: 4, minutes: 5, seconds: 6};
        test:assertEquals(returnData["row_id"], 1);
        test:assertTrue(returnData["date_type"] is time:Date);
        test:assertTrue(returnData["time_type"] is time:TimeOfDay);
        test:assertTrue(returnData["timetz_type"] is time:TimeOfDay);
        test:assertEquals(returnData["interval_type"], interval);
        test:assertTrue(returnData["timestamptz_type"] is time:Civil);
        test:assertTrue(returnData["timestamptz_type"] is time:Civil);
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
  IntegerRange? int4range_type;
  LongRange? int8range_type;
  NumericRange? numrange_type;
  TimestampRange? tsrange_type;
  TimestamptzRange? tstzrange_type;
  DateRange? daterange_type;
};

public type RangeRecord3 record {
  int row_id;
  TimestampCivilRange? tsrange_type;
  TimestamptzCivilRange? tstzrange_type;
  DateRecordRange? daterange_type;
};

@test:Config {
    groups: ["query"],
    dependsOn: [testSelectFromDateDataTable2]
}
function testSelectFromRangeDataTable() returns error? {
    int rowId = 1;

    sql:ParameterizedQuery sqlQuery = `select * from RangeTypes where row_id = ${rowId}`;

    _ = validateRangeTableResult(check simpleQueryPostgresqlClient(sqlQuery, RangeRecord, database = queryComplexDatabase));
}

isolated function validateRangeTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["int4range_type"], "[3,50)");
        test:assertEquals(returnData["int8range_type"], "[11,100)");
        test:assertEquals(returnData["numrange_type"], "(0,24)");
        test:assertEquals(returnData["tsrange_type"], "(\"2010-01-01 14:30:00\",\"2010-01-01 15:30:00\")");
        test:assertEquals(returnData["daterange_type"], "[2010-01-02,2010-01-03)");
    }
}

@test:Config {
    groups: ["query"],
    dependsOn: [testSelectFromRangeDataTable]
}
function testSelectFromRangeDataTable2() returns error? {
    int rowId = 2;

    sql:ParameterizedQuery sqlQuery = `select * from RangeTypes where row_id = ${rowId}`;

    _ = validateRangeTableResult2(check simpleQueryPostgresqlClient(sqlQuery, RangeRecord, database = queryComplexDatabase));
}

isolated function validateRangeTableResult2(record{}? returnData) {
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
    groups: ["query"],
    dependsOn: [testSelectFromRangeDataTable2]
}
function testSelectFromRangeDataTable3() returns error? {
    int rowId = 1;

    sql:ParameterizedQuery sqlQuery = `select * from RangeTypes where row_id = ${rowId}`;

    error? result = validateRangeTableResult3(check simpleQueryPostgresqlClient(sqlQuery, RangeRecord2, database = queryComplexDatabase));
    if (result is error) {
        test:assertFail("Invalid Time Values generated");
    }
}

isolated function validateRangeTableResult3(record{}? returnData) returns error? {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        IntegerRange int4rangeRecordType = {upper: 50, lower :3, lowerboundInclusive: true, upperboundInclusive: false};
        LongRange  int8rangeRecordType = {upper: 100, lower : 11, lowerboundInclusive: true, upperboundInclusive: false};
        NumericRange numrangeRecordType = {upper: 24, lower : 0, lowerboundInclusive: false, upperboundInclusive: false};
        TimestampRange tsrangeRecordType = {upper: "2010-01-01 15:30:00", lower: "2010-01-01 14:30:00"};
        TimestamptzRange tstzrangeRecordType = {upper: "2010-01-01 21:00:00+05:30", lower: "2010-01-01 20:00:00+05:30"};
        DateRange daterangeRecordType = {upper: "2010-01-03", lower: "2010-01-02", lowerboundInclusive: true};

        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["int4range_type"], int4rangeRecordType);
        test:assertEquals(returnData["int8range_type"], int8rangeRecordType);
        test:assertEquals(returnData["numrange_type"], numrangeRecordType);
        test:assertEquals(returnData["tsrange_type"], tsrangeRecordType);
        test:assertTrue(returnData["tstzrange_type"] is TimestamptzRange);
        test:assertEquals(returnData["daterange_type"], daterangeRecordType);
    }
}

@test:Config {
    groups: ["query"],
    dependsOn: [testSelectFromRangeDataTable3]
}
function testSelectFromRangeDataTable4() returns error? {
    int rowId = 2;

    sql:ParameterizedQuery sqlQuery = `select * from RangeTypes where row_id = ${rowId}`;

    _ = validateRangeTableResult4(check simpleQueryPostgresqlClient(sqlQuery, RangeRecord2, database = queryComplexDatabase));
}

isolated function validateRangeTableResult4(record{}? returnData) {
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
    groups: ["query"],
    dependsOn: [testSelectFromRangeDataTable4]
}
function testSelectFromRangeDataTable5() returns error? {
    int rowId = 1;

    sql:ParameterizedQuery sqlQuery = `select row_id, tsrange_type, tstzrange_type, daterange_type
                 from RangeTypes where row_id = ${rowId}`;

    _ = validateRangeTableResult5(check simpleQueryPostgresqlClient(sqlQuery, RangeRecord3, database = queryComplexDatabase));
}

isolated function validateRangeTableResult5(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertTrue(returnData["tsrange_type"] is TimestampCivilRange);
        test:assertTrue(returnData["tstzrange_type"] is TimestamptzCivilRange);
        test:assertTrue(returnData["daterange_type"] is DateRecordRange);
    }
}

public type BitRecord record {
  int row_id;
  string? varbitstring_type;
  boolean? bit_type;
};

@test:Config {
    groups: ["query"],
    dependsOn: [testSelectFromRangeDataTable2]
}
function testSelectFromBitDataTable() returns error? {
    int rowId = 1;

    sql:ParameterizedQuery sqlQuery = `select row_id, varbitstring_type, bit_type from BitTypes where row_id = ${rowId}`;

    _ = validateBitTableResult(check simpleQueryPostgresqlClient(sqlQuery, BitRecord, database = queryComplexDatabase));
}

isolated function validateBitTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["varbitstring_type"], "1101");
        test:assertEquals(returnData["bit_type"], true);
    }
}

@test:Config {
    groups: ["query"],
    dependsOn: [testSelectFromBitDataTable]
}
function testSelectFromBitDataTable2() returns error? {
    int rowId = 2;

    sql:ParameterizedQuery sqlQuery = `select row_id, varbitstring_type, bit_type from BitTypes where row_id = ${rowId}`;

    _ = validateBitTableResult2(check simpleQueryPostgresqlClient(sqlQuery, BitRecord, database = queryComplexDatabase));
}

isolated function validateBitTableResult2(record{}? returnData) {
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
    groups: ["query"],
    dependsOn: [testSelectFromBitDataTable2]
}
function testSelectFromPglsnDataTable() returns error? {
    int rowId = 1;

    sql:ParameterizedQuery sqlQuery = `select * from Pglsntypes where row_id = ${rowId}`;

    _ = validatePglsnTableResult(check simpleQueryPostgresqlClient(sqlQuery, PglsnRecord, database = queryComplexDatabase));
}

isolated function validatePglsnTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["pglsn_type"], "16/B374D848");
    }
}

@test:Config {
    groups: ["query"],
    dependsOn: [testSelectFromPglsnDataTable]
}
function testSelectFromPglsnDataTable2() returns error? {
    int rowId = 2;

    sql:ParameterizedQuery sqlQuery = `select * from Pglsntypes where row_id = ${rowId}`;

    _ = validatePglsnTableResult2(check simpleQueryPostgresqlClient(sqlQuery, PglsnRecord, database = queryComplexDatabase));
}

isolated function validatePglsnTableResult2(record{}? returnData) {
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

public type ObjectidentifierRecord2 record {
  int row_id;
  int? oid_type;
};

@test:Config {
    groups: ["query"],
    dependsOn: [testSelectFromPglsnDataTable2]
}
function testSelectFromObjectidentifierDataTable() returns error? {
    int rowId = 1;

    sql:ParameterizedQuery sqlQuery = `select * from Objectidentifiertypes where row_id = ${rowId}`;

    _ = validateObjectidentifierTableResult(check simpleQueryPostgresqlClient(sqlQuery, ObjectidentifierRecord, database = queryComplexDatabase));
}

isolated function validateObjectidentifierTableResult(record{}? returnData) {
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
    groups: ["query"],
    dependsOn: [testSelectFromObjectidentifierDataTable]
}
function testSelectFromObjectidentifierDataTable2() returns error? {
    int rowId = 2;

    sql:ParameterizedQuery sqlQuery = `select * from Objectidentifiertypes where row_id = ${rowId}`;

    _ = validateObjectidentifierTableResult2(check simpleQueryPostgresqlClient(sqlQuery, ObjectidentifierRecord, database = queryComplexDatabase));
}

isolated function validateObjectidentifierTableResult2(record{}? returnData) {
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

@test:Config {
    groups: ["query"],
    dependsOn: [testSelectFromObjectidentifierDataTable2]
}
function testSelectFromObjectidentifierDataTable3() returns error? {
    int rowId = 1;

    sql:ParameterizedQuery sqlQuery = `select row_id, oid_type from Objectidentifiertypes where row_id = ${rowId}`;

    _ = validateObjectidentifierTableResult3(check simpleQueryPostgresqlClient(sqlQuery, ObjectidentifierRecord2, database = queryComplexDatabase));
}

isolated function validateObjectidentifierTableResult3(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["oid_type"], 12);
    }
}

@test:Config {
    groups: ["query"],
    dependsOn: [testSelectFromObjectidentifierDataTable3]
}
function testSelectFromObjectidentifierDataTable4() returns error? {
    int rowId = 2;

    sql:ParameterizedQuery sqlQuery = `select row_id, oid_type from Objectidentifiertypes where row_id = ${rowId}`;

    _ = validateObjectidentifierTableResult4(check simpleQueryPostgresqlClient(sqlQuery, ObjectidentifierRecord2, database = queryComplexDatabase));
}

isolated function validateObjectidentifierTableResult4(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 2);
        test:assertEquals(returnData["oid_type"], ());
    }
}

public type BinaryRecord record {
  int row_id;
  byte []? bytea_type;
  byte []? bytea_escape_type;
};

public type BinaryRecord2 record {
  int row_id;
  string? bytea_type;
  string? bytea_escape_type;
};

@test:Config {
    groups: ["query"],
    dependsOn: [testSelectFromObjectidentifierDataTable2]
}
function testSelectFromBinaryDataTable() returns error? {
    int rowId = 1;

    sql:ParameterizedQuery sqlQuery = `select * from BinaryTypes where row_id = ${rowId}`;

    _ = validateBinaryTableResult(check simpleQueryPostgresqlClient(sqlQuery, BinaryRecord, database = queryComplexDatabase));
}

isolated function validateBinaryTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertTrue(returnData["bytea_type"] is byte[]);
        test:assertTrue(returnData["bytea_escape_type"] is byte[]);
    }
}

@test:Config {
    groups: ["query"],
    dependsOn: [testSelectFromBinaryDataTable]
}
function testSelectFromBinaryDataTable2() returns error? {
    int rowId = 1;

    sql:ParameterizedQuery sqlQuery = `select * from BinaryTypes where row_id = ${rowId}`;

    _ = validateBinaryTableResult2(check simpleQueryPostgresqlClient(sqlQuery, BinaryRecord2, database = queryComplexDatabase));
}

isolated function validateBinaryTableResult2(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertTrue(returnData["bytea_type"] is string);
        test:assertTrue(returnData["bytea_escape_type"] is string);
    }
}

@test:Config {
    groups: ["query"],
    dependsOn: [testSelectFromBinaryDataTable2]
}
function testSelectFromBinaryDataTable3() returns error? {
    int rowId = 2;

    sql:ParameterizedQuery sqlQuery = `select * from BinaryTypes where row_id = ${rowId}`;

    _ = validateBinaryTableResult3(check simpleQueryPostgresqlClient(sqlQuery, BinaryRecord, database = queryComplexDatabase));
}

isolated function validateBinaryTableResult3(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 2);
        test:assertEquals(returnData["bytea_type"], ());
        test:assertEquals(returnData["bytea_escape_type"], ());
    }
}

@test:Config {
    groups: ["query"],
    dependsOn: [testSelectFromBinaryDataTable3]
}
function testSelectFromBinaryDataTable4() returns error? {
    int rowId = 2;

    sql:ParameterizedQuery sqlQuery = `select * from BinaryTypes where row_id = ${rowId}`;

    _ = validateBinaryTableResult4(check simpleQueryPostgresqlClient(sqlQuery, BinaryRecord2, database = queryComplexDatabase));
}

isolated function validateBinaryTableResult4(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 2);
        test:assertEquals(returnData["bytea_type"], ());
        test:assertEquals(returnData["bytea_escape_type"], ());
    }
}

public type XmlRecord record {
  int row_id;
  xml xml_type;
};

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testSelectFromBinaryDataTable3]
}
function testSelectFromXmlDataTable() returns error? {
    int rowId = 1;

    sql:ParameterizedQuery sqlQuery = `select * from Xmltypes where row_id = ${rowId}`;

    _ = validateXmlTableResult(check simpleQueryPostgresqlClient(sqlQuery, XmlRecord, database = executeParamsDatabase));
}

isolated function validateXmlTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["xml_type"], xml `<foo><tag>bar</tag><tag>tag</tag></foo>`);
    }
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testSelectFromXmlDataTable]
}
function testSelectFromXmlDataTable2() returns error? {
    int rowId = 2;

    sql:ParameterizedQuery sqlQuery = `select * from Xmltypes where row_id = ${rowId}`;

    _ = validateXmlTableResult2(check simpleQueryPostgresqlClient(sqlQuery, XmlRecord, database = executeParamsDatabase));
}

isolated function validateXmlTableResult2(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 2);
        test:assertEquals(returnData["xml_type"], ());
    }
}

public type MoneyRecord record {
  int row_id;
  string? money_type;
};

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testSelectFromXmlDataTable2]
}
function testSelectFromMoneyDataTable() returns error? {
    int rowId = 1;

    sql:ParameterizedQuery sqlQuery = `select * from Moneytypes where row_id = ${rowId}`;

    _ = validateMoneyTableResult(check simpleQueryPostgresqlClient(sqlQuery, MoneyRecord, database = executeParamsDatabase));
}

isolated function validateMoneyTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["money_type"], "124.56");
    }
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testSelectFromMoneyDataTable]
}
function testSelectFromMoneyDataTable2() returns error? {
    int rowId = 2;

    sql:ParameterizedQuery sqlQuery = `select * from Moneytypes where row_id = ${rowId}`;

    _ = validateMoneyTableResult2(check simpleQueryPostgresqlClient(sqlQuery, MoneyRecord, database = executeParamsDatabase));
}

isolated function validateMoneyTableResult2(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 2);
        test:assertEquals(returnData["money_type"], ());
    }
}

public type ArrayRecord record {
  int row_id;
  int[]? bigintarray_type;
  decimal[]? decimalarray_type;
  decimal[]? numericarray_type;
  float[]? realarray_type;
  float[]? doublearray_type;
  string[]? chararray_type;
  string[]? varchararray_type;
  string[]? textarray_type;
  boolean[]? booleanarray_type;
};

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testSelectFromXmlDataTable2]
}
function testSelectFromArrayDataTable() returns error? {
    int rowId = 1;

    sql:ParameterizedQuery sqlQuery = `select row_id, bigintarray_type,
     decimalarray_type, numericarray_type, realarray_type, doublearray_type, chararray_type, varchararray_type,
            textarray_type, booleanarray_type from Arraytypes where row_id = ${rowId}`;

    _ = validateArrayTableResult(check simpleQueryPostgresqlClient(sqlQuery, ArrayRecord, database = executeParamsDatabase));
}

isolated function validateArrayTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        decimal[] decimalArray = [1.1,2.2,3.3,4.4];
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["bigintarray_type"], [10000,20000,30000]);
        test:assertEquals(returnData["decimalarray_type"], decimalArray);
        test:assertEquals(returnData["numericarray_type"], decimalArray);
        test:assertTrue(returnData["realarray_type"] is float[]);
        test:assertTrue(returnData["doublearray_type"] is float[]);
        test:assertEquals(returnData["chararray_type"], ["This is a Char1","This is a Char2"]);
        test:assertEquals(returnData["varchararray_type"], ["This is a VarChar1","This is a VarChar2"]);
        test:assertEquals(returnData["textarray_type"], ["This is a Text1","This is a Text2"]);
        test:assertEquals(returnData["booleanarray_type"], [true,false,true]);
    }
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testSelectFromMoneyDataTable]
}
function testSelectFromArrayDataTable2() returns error? {
    int rowId = 2;

    sql:ParameterizedQuery sqlQuery = `select row_id, bigintarray_type,
     decimalarray_type, numericarray_type, chararray_type, varchararray_type,
            textarray_type, booleanarray_type from Arraytypes where row_id = ${rowId}`;

    _ = validateArrayTableResult2(check simpleQueryPostgresqlClient(sqlQuery, ArrayRecord, database = executeParamsDatabase));
}

isolated function validateArrayTableResult2(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 2);
        test:assertEquals(returnData["bigintarray_type"], ());
        test:assertEquals(returnData["decimalarray_type"], ());
        test:assertEquals(returnData["numericarray_type"], ());
        test:assertEquals(returnData["chararray_type"], ());
        test:assertEquals(returnData["varchararray_type"], ());
        test:assertEquals(returnData["textarray_type"], ());
        test:assertEquals(returnData["booleanarray_type"], ());
    }
}

public type ArrayRecord2 record {
    int row_id;
    int?[]? smallint_array;
    int?[]? int_array;
    int?[]? bigint_array;
    decimal?[]? decimal_array;
    decimal?[]? numeric_array;
    float?[]? real_array;
    float?[]? double_array;
    string?[]? varchar_array;
    string?[]? string_array;
    string?[]? char_array;
    boolean?[]? boolean_array;
    time:Date?[]? date_array;
    time:TimeOfDay?[]? time_array;
    time:TimeOfDay?[]? timetz_array;
    time:Civil?[]? timestamp_array;
    time:Civil?[]? timestamptz_array;
    byte[]?[]? bytea_array;
    boolean?[]? bit_array;
};

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testSelectFromArrayDataTable2]
}
function testSelectFromArrayDataTable3() returns error? {
    int rowId = 1;

    sql:ParameterizedQuery sqlQuery = `select * from Arraytypes2 where row_id = ${rowId}`;

    _ = validateArrayTableResult3(check simpleQueryPostgresqlClient(sqlQuery, ArrayRecord2, database = executeParamsDatabase));
}

isolated function validateArrayTableResult3(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["smallint_array"], [12, 232]);
        test:assertEquals(returnData["int_array"], [1, 2, 3]);
        test:assertEquals(returnData["bigint_array"], [100000000, 200000000, 300000000]);
        test:assertEquals(returnData["decimal_array"], <decimal[]>[245.12, 5559.12, 8796.12]);
        test:assertEquals(returnData["numeric_array"], <decimal[]>[12.323, 232.21]);
        test:assertTrue(returnData["real_array"] is float[]);
        test:assertTrue(returnData["double_array"] is float[]);
        test:assertEquals(returnData["varchar_array"], ["Hello", "Ballerina"]);
        test:assertEquals(returnData["string_array"], ["Hello", "Ballerina"]);
        test:assertEquals(returnData["char_array"], ["Hello          ", "Ballerina      "]);
        test:assertEquals(returnData["boolean_array"], [true, false, true]);
        test:assertTrue(returnData["bytea_array"] is byte[][]);
        test:assertEquals(returnData["bit_array"], [null, false]);
    }
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testSelectFromArrayDataTable3]
}
function testSelectFromArrayDataTable4() returns error? {
    int rowId = 2;

    sql:ParameterizedQuery sqlQuery = `select * from Arraytypes2 where row_id = ${rowId}`;

    _ = validateArrayTableResult4(check simpleQueryPostgresqlClient(sqlQuery, ArrayRecord2, database = executeParamsDatabase));
}

isolated function validateArrayTableResult4(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 2);
        test:assertEquals(returnData["smallint_array"], ());
        test:assertEquals(returnData["int_array"], ());
        test:assertEquals(returnData["bigint_array"], ());
        test:assertEquals(returnData["decimal_array"], ());
        test:assertEquals(returnData["numeric_array"], ());
        test:assertEquals(returnData["real_array"], ());
        test:assertEquals(returnData["double_array"], ());
        test:assertEquals(returnData["varchar_array"], ());
        test:assertEquals(returnData["string_array"], ());
        test:assertEquals(returnData["char_array"], ());
        test:assertEquals(returnData["boolean_array"], ());
        test:assertEquals(returnData["date_array"], ());
        test:assertEquals(returnData["time_array"] ,());
        test:assertEquals(returnData["timestamp_array"], ());
        test:assertEquals(returnData["timetz_array"] ,());
        test:assertEquals(returnData["timestamptz_array"], ());
        test:assertEquals(returnData["bytea_array"], ());
        test:assertEquals(returnData["bit_array"], ());
    }
}

public type ArrayRecord3 record {
    int row_id;
    Point?[]? point_array;
    Line?[]? line_array;
    LineSegment?[]? lseg_array;
    Path?[]? path_array;
    Polygon?[]? polygon_array;
    Box?[]? box_array;
    Circle?[]? circle_array;
    Interval?[]? interval_array;
    IntegerRange?[]? int4range_array;
    LongRange?[]? int8range_array;
    NumericRange?[]? numrange_array;
    TimestampCivilRange?[]? tsrange_array;
    TimestamptzCivilRange?[]? tstzrange_array;
    DateRecordRange?[]? daterange_array;
};

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testSelectFromArrayDataTable2]
}
function testSelectFromArrayDataTable5() returns error? {
    int rowId = 1;

    sql:ParameterizedQuery sqlQuery = `select * from Arraytypes3 where row_id = ${rowId}`;

    _ = validateArrayTableResult5(check simpleQueryPostgresqlClient(sqlQuery, ArrayRecord3, database = executeParamsDatabase));
}

isolated function validateArrayTableResult5(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["point_array"], [<Point>{x: 1, y: 2}, <Point>{x: 2, y: 3}]);
        test:assertEquals(returnData["line_array"], [<Line>{a:1, b: 2, c: 3}, <Line>{a:1, b: 2, c: 3}]);
        test:assertEquals(returnData["lseg_array"], [<LineSegment>{x1: 1, x2: 2, y1: 1, y2: 2}]);
        test:assertEquals(returnData["path_array"], [<Path>{points: [<Point>{x: 1, y: 3}, <Point>{x: 2, y: 2}], open: true}]);
        test:assertEquals(returnData["polygon_array"], [<Polygon>{points: [<Point>{x: 1, y: 4}, <Point>{x: 2, y: 2}]}]);
        test:assertEquals(returnData["box_array"], [<Box>{x1: 1, x2: 2, y1: 2, y2: 2}]);
        test:assertEquals(returnData["circle_array"], [<Circle>{x: 1, y: 1, r: 1}, <Circle>{x: 1, y: 1, r: 1}]);
        test:assertEquals(returnData["interval_array"], [<Interval>{years:1, months:2, days:3, hours:4, minutes:5, seconds:6},
                                                         <Interval>{years:1, months:2, days:3, hours:4, minutes:5, seconds:6}]);
        test:assertEquals(returnData["int4range_array"], [<IntegerRange>{lower: 1, upper: 3, lowerboundInclusive: true},
                                                          <IntegerRange>{lower: 2, upper: 4, lowerboundInclusive: true}]);
        test:assertEquals(returnData["int8range_array"], [<IntegerRange>{lower: 10000, upper: 30001, lowerboundInclusive: true},
                                                          <LongRange>{lower: 10001, upper: 30000, lowerboundInclusive: true}]);
    }
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testSelectFromArrayDataTable3]
}
function testSelectFromArrayDataTable6() returns error? {
    int rowId = 2;

    sql:ParameterizedQuery sqlQuery = `select * from Arraytypes3 where row_id = ${rowId}`;

    _ = validateArrayTableResult6(check simpleQueryPostgresqlClient(sqlQuery, ArrayRecord3, database = executeParamsDatabase));
}

isolated function validateArrayTableResult6(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 2);
        test:assertEquals(returnData["point_array"], ());
        test:assertEquals(returnData["line_array"], ());
        test:assertEquals(returnData["lseg_array"], ());
        test:assertEquals(returnData["path_array"], ());
        test:assertEquals(returnData["polygon_array"], ());
        test:assertEquals(returnData["box_array"], ());
        test:assertEquals(returnData["circle_array"], ());
        test:assertEquals(returnData["interval_array"], ());
        test:assertEquals(returnData["int4range_array"], ());
        test:assertEquals(returnData["int8range_array"], ());
        test:assertEquals(returnData["numrange_array"], ());
        test:assertEquals(returnData["tstzrange_array"], ());
        test:assertEquals(returnData["tsrange_array"], ());
        test:assertEquals(returnData["daterange_array"], ());
    }
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testSelectFromArrayDataTable2]
}
function testSelectFromArrayDataTable7() returns error? {
    int rowId = 3;

    sql:ParameterizedQuery sqlQuery = `select * from Arraytypes3 where row_id = ${rowId}`;

    _ = validateArrayTableResult7(check simpleQueryPostgresqlClient(sqlQuery, ArrayRecord3, database = executeParamsDatabase));
}

isolated function validateArrayTableResult7(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 3);
        test:assertEquals(returnData["point_array"], [null, <Point>{x: 2, y: 3}]);
        test:assertEquals(returnData["line_array"], [null, <Line>{a:1, b: 2, c: 3}]);
        test:assertEquals(returnData["lseg_array"], [null, <LineSegment>{x1: 1, x2: 2, y1: 1, y2: 2}]);
        test:assertEquals(returnData["path_array"], [null, <Path>{points: [<Point>{x: 1, y: 3}, <Point>{x: 2, y: 2}], open: true}]);
        test:assertEquals(returnData["polygon_array"], [null, <Polygon>{points: [<Point>{x: 1, y: 4}, <Point>{x: 2, y: 2}]}]);
        test:assertEquals(returnData["box_array"], [null, <Box>{x1: 1, x2: 2, y1: 2, y2: 2}]);
        test:assertEquals(returnData["circle_array"], [null, <Circle>{x: 1, y: 1, r: 1}, <Circle>{x: 1, y: 1, r: 1}]);
        test:assertEquals(returnData["interval_array"], [null, <Interval>{years:1, months:2, days:3, hours:4, minutes:5, seconds:6},
                                                               <Interval>{years:1, months:2, days:3, hours:4, minutes:5, seconds:6}]);
        test:assertEquals(returnData["int4range_array"], [null, <IntegerRange>{lower: 2, upper: 4, lowerboundInclusive: true}]);
        test:assertEquals(returnData["int8range_array"], [null, <LongRange>{lower: 10001, upper: 30000, lowerboundInclusive: true}]);
    }
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testSelectFromArrayDataTable3]
}
function testSelectFromArrayDataTable8() returns error? {
    int rowId = 4;

    sql:ParameterizedQuery sqlQuery = `select * from Arraytypes3 where row_id = ${rowId}`;

    _ = validateArrayTableResult8(check simpleQueryPostgresqlClient(sqlQuery, ArrayRecord3, database = executeParamsDatabase));
}

isolated function validateArrayTableResult8(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 4);
        test:assertEquals(returnData["point_array"], [null, null]);
        test:assertEquals(returnData["line_array"], [null, null]);
        test:assertEquals(returnData["lseg_array"], [null, null]);
        test:assertEquals(returnData["path_array"], [null, null]);
        test:assertEquals(returnData["polygon_array"], [null, null]);
        test:assertEquals(returnData["box_array"], [null, null]);
        test:assertEquals(returnData["circle_array"], [null, null]);
        test:assertEquals(returnData["interval_array"], [null, null]);
        test:assertEquals(returnData["int4range_array"], [null, null]);
        test:assertEquals(returnData["int8range_array"], [null, null]);
        test:assertEquals(returnData["numrange_array"], [null, null]);
        test:assertEquals(returnData["tstzrange_array"], [null, null]);
        test:assertEquals(returnData["daterange_array"], [null, null]);
        test:assertEquals(returnData["tsrange_array"], [null, null]);
    }
}

public type ArrayRecord4 record {
  int row_id;
  string?[]? inet_array;
  string?[]? cidr_array;
  string?[]? macaddr_array;
  string?[]? macaddr8_array;
  string?[]? uuid_array;
  string?[]? tsvector_array;
  string?[]? tsquery_array;
  string?[]? varbitstring_array;
  boolean?[]? bit_array;
  string?[]? xml_array;
  int?[]? oid_array;
  string?[]? regclass_array;
  string?[]? regconfig_array;
  string?[]? regdictionary_array;
  string?[]? regnamespace_array;
  string?[]? regoper_array;
  string?[]? regoperator_array;
  string?[]? regproc_array;
  string?[]? regprocedure_array;
  string?[]? regrole_array;
  string?[]? regtype_array;
  string?[]? bitstring_array;
};

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testSelectFromArrayDataTable2]
}
function testSelectFromArrayDataTable9() returns error? {
    int rowId = 1;

    sql:ParameterizedQuery sqlQuery = `select row_id, inet_array, cidr_array, macaddr_array, macaddr8_array, uuid_array, tsvector_array, tsquery_array,
         varbitstring_array, bit_array, regclass_array, regconfig_array, regdictionary_array, oid_array,
         regnamespace_array, regoper_array, regoperator_array, regproc_array, regprocedure_array, regrole_array, regtype_array,
          xml_array from Arraytypes4 where row_id = ${rowId}`;

    _ = validateArrayTableResult9(check simpleQueryPostgresqlClient(sqlQuery, ArrayRecord4, database = executeParamsDatabase));
}

isolated function validateArrayTableResult9(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["inet_array"], ["192.168.0.1/24", "192.168.0.1/24"]);
        test:assertEquals(returnData["cidr_array"], ["::ffff:1.2.3.0/120", "::ffff:1.2.3.0/120"]);
        test:assertEquals(returnData["macaddr_array"], ["08:00:2b:01:02:03", "08:00:2b:01:02:03"]);
        test:assertEquals(returnData["macaddr8_array"], ["08:00:2b:01:02:03:04:05", "08:00:2b:01:02:03:04:05"]);
        test:assertEquals(returnData["uuid_array"], ["a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11", "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11"]);
        test:assertEquals(returnData["tsvector_array"], ["'a' 'and' 'ate' 'cat' 'fat' 'mat' 'on' 'rat' 'sat'", "'a' 'and' 'ate' 'cat' 'fat' 'mat' 'on' 'rat' 'sat'"]);
        test:assertEquals(returnData["tsquery_array"], ["'fat' & 'rat'", "'fat' & 'rat'"]);
        test:assertEquals(returnData["varbitstring_array"], ["1101", "1101"]);
        test:assertEquals(returnData["bit_array"], [true, true]);
        test:assertEquals(returnData["xml_array"], ["<foo><tag>bar</tag><tag>tag</tag></foo>", "<foo><tag>bar</tag><tag>tag</tag></foo>"]);
        test:assertEquals(returnData["oid_array"], [12, 12]);
        test:assertEquals(returnData["regclass_array"], ["pg_type", "pg_type"]);
        test:assertEquals(returnData["regconfig_array"], ["english", "english"]);
        test:assertEquals(returnData["regdictionary_array"], ["simple", "simple"]);
        test:assertEquals(returnData["regnamespace_array"], ["pg_catalog", "pg_catalog"]);
        test:assertEquals(returnData["regoper_array"], ["!", "!"]);
        test:assertEquals(returnData["regoperator_array"], ["*(integer,integer)", "*(integer,integer)"]);
        test:assertEquals(returnData["regproc_array"], ["now", "now"]);
        test:assertEquals(returnData["regprocedure_array"], ["sum(integer)", "sum(integer)"]);
        test:assertEquals(returnData["regrole_array"], ["postgres", "postgres"]);
        test:assertEquals(returnData["regtype_array"], ["integer", "integer"]);
    }
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testSelectFromArrayDataTable3]
}
function testSelectFromArrayDataTable10() returns error? {
    int rowId = 2;

    sql:ParameterizedQuery sqlQuery = `select * from Arraytypes4 where row_id = ${rowId}`;

    _ = validateArrayTableResult10(check simpleQueryPostgresqlClient(sqlQuery, ArrayRecord4, database = executeParamsDatabase));
}

isolated function validateArrayTableResult10(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 2);
        test:assertEquals(returnData["inet_array"], ());
        test:assertEquals(returnData["cidr_array"], ());
        test:assertEquals(returnData["macaddr_array"], ());
        test:assertEquals(returnData["macaddr8_array"], ());
        test:assertEquals(returnData["uuid_array"], ());
        test:assertEquals(returnData["tsvector_array"], ());
        test:assertEquals(returnData["tsquery_array"], ());
        test:assertEquals(returnData["bitstring_array"], ());
        test:assertEquals(returnData["varbitstring_array"], ());
        test:assertEquals(returnData["bit_array"], ());
        test:assertEquals(returnData["xml_array"], ());
        test:assertEquals(returnData["oid_array"], ());
        test:assertEquals(returnData["regclass_array"], ());
        test:assertEquals(returnData["regconfig_array"], ());
        test:assertEquals(returnData["regdictionary_array"], ());
        test:assertEquals(returnData["regnamespace_array"], ());
        test:assertEquals(returnData["regoper_array"], ());
        test:assertEquals(returnData["regoperator_array"], ());
        test:assertEquals(returnData["regproc_array"], ());
        test:assertEquals(returnData["regprocedure_array"], ());
        test:assertEquals(returnData["regrole_array"], ());
        test:assertEquals(returnData["regtype_array"], ());
    }
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testSelectFromArrayDataTable2]
}
function testSelectFromArrayDataTable11() returns error? {
    int rowId = 3;

        sql:ParameterizedQuery sqlQuery = `select row_id, inet_array, cidr_array, macaddr_array, macaddr8_array, uuid_array, tsvector_array, tsquery_array,
         varbitstring_array, bit_array, regclass_array, regconfig_array, regdictionary_array, oid_array,
         regnamespace_array, regoper_array, regoperator_array, regproc_array, regprocedure_array, regrole_array, regtype_array,
          xml_array from Arraytypes4 where row_id = ${rowId}`;

    _ = validateArrayTableResult11(check simpleQueryPostgresqlClient(sqlQuery, ArrayRecord4, database = executeParamsDatabase));
}

isolated function validateArrayTableResult11(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 3);
        test:assertEquals(returnData["inet_array"], [null, "192.168.0.1/24"]);
        test:assertEquals(returnData["cidr_array"], [null, "::ffff:1.2.3.0/120"]);
        test:assertEquals(returnData["macaddr_array"], [null, "08:00:2b:01:02:03"]);
        test:assertEquals(returnData["macaddr8_array"], [null, "08:00:2b:01:02:03:04:05"]);
        test:assertEquals(returnData["uuid_array"], [null, "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11"]);
        test:assertEquals(returnData["tsvector_array"], [null, "'a' 'and' 'ate' 'cat' 'fat' 'mat' 'on' 'rat' 'sat'"]);
        test:assertEquals(returnData["tsquery_array"], [null, "'fat' & 'rat'"]);
        test:assertEquals(returnData["varbitstring_array"], [null, "1101"]);
        test:assertEquals(returnData["bit_array"], [null, true]);
        test:assertEquals(returnData["xml_array"], [null, "<foo><tag>bar</tag><tag>tag</tag></foo>"]);
        test:assertEquals(returnData["oid_array"], [null, 12]);
        test:assertEquals(returnData["regclass_array"], [null, "pg_type"]);
        test:assertEquals(returnData["regconfig_array"], [null, "english"]);
        test:assertEquals(returnData["regdictionary_array"], [null, "simple"]);
        test:assertEquals(returnData["regnamespace_array"], [null, "pg_catalog"]);
        test:assertEquals(returnData["regoper_array"], [null, "!"]);
        test:assertEquals(returnData["regoperator_array"], [null, "*(integer,integer)"]);
        test:assertEquals(returnData["regproc_array"], [null, "now"]);
        test:assertEquals(returnData["regprocedure_array"], [null, "sum(integer)"]);
        test:assertEquals(returnData["regrole_array"], [null, "postgres"]);
        test:assertEquals(returnData["regtype_array"], [null, "integer"]);
    }
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testSelectFromArrayDataTable3]
}
function testSelectFromArrayDataTable12() returns error? {
    int rowId = 4;

    sql:ParameterizedQuery sqlQuery = `select * from Arraytypes4 where row_id = ${rowId}`;

    _ = validateArrayTableResult12(check simpleQueryPostgresqlClient(sqlQuery, ArrayRecord4, database = executeParamsDatabase));
}

isolated function validateArrayTableResult12(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 4);
        test:assertEquals(returnData["inet_array"], [null, null]);
        test:assertEquals(returnData["cidr_array"], [null, null]);
        test:assertEquals(returnData["macaddr_array"], [null, null]);
        test:assertEquals(returnData["macaddr8_array"], [null, null]);
        test:assertEquals(returnData["uuid_array"], [null, null]);
        test:assertEquals(returnData["tsvector_array"], [null, null]);
        test:assertEquals(returnData["tsquery_array"], [null, null]);
        test:assertEquals(returnData["bitstring_array"], [null, null]);
        test:assertEquals(returnData["varbitstring_array"], [null, null]);
        test:assertEquals(returnData["bit_array"], [null, null]);
        test:assertEquals(returnData["xml_array"], [null, null]);
        test:assertEquals(returnData["oid_array"], [null, null]);
        test:assertEquals(returnData["regclass_array"], [null, null]);
        test:assertEquals(returnData["regconfig_array"], [null, null]);
        test:assertEquals(returnData["regdictionary_array"], [null, null]);
        test:assertEquals(returnData["regnamespace_array"], [null, null]);
        test:assertEquals(returnData["regoper_array"], [null, null]);
        test:assertEquals(returnData["regoperator_array"], [null, null]);
        test:assertEquals(returnData["regproc_array"], [null, null]);
        test:assertEquals(returnData["regprocedure_array"], [null, null]);
        test:assertEquals(returnData["regrole_array"], [null, null]);
        test:assertEquals(returnData["regtype_array"], [null, null]);
    }
}

public type ArrayRecord5 record {
  int row_id;
  json?[]? json_array;
  json?[]? jsonb_array;
  string?[]? jsonpath_array;
  string?[]? pglsn_array;
  string?[]? money_array;
};

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testSelectFromArrayDataTable2]
}
function testSelectFromArrayDataTable13() returns error? {
    int rowId = 1;

    sql:ParameterizedQuery sqlQuery = `select row_id, json_array, jsonb_array, jsonpath_array, pglsn_array from Arraytypes5 where row_id = ${rowId}`;

    _ = validateArrayTableResult13(check simpleQueryPostgresqlClient(sqlQuery, ArrayRecord5, database = executeParamsDatabase));
}

isolated function validateArrayTableResult13(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["json_array"], [{"key1":"value","key2":2},{"key1":"value","key2":2}]);
        test:assertEquals(returnData["jsonb_array"], ["{\"key1\": \"value\", \"key2\": 2}","{\"key1\": \"value\", \"key2\": 2}"]);
        test:assertEquals(returnData["jsonpath_array"], ["$.\"floor\"[*].\"apt\"[*]?(@.\"area\" > 40 && @.\"area\" < 90)?(@.\"rooms\" > 1)", "$.\"floor\"[*].\"apt\"[*]?(@.\"area\" > 40 && @.\"area\" < 90)?(@.\"rooms\" > 1)"]);
        test:assertEquals(returnData["pglsn_array"], ["16/B374D848", "16/B374D848"]);
    }
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testSelectFromArrayDataTable3]
}
function testSelectFromArrayDataTable14() returns error? {
    int rowId = 2;

    sql:ParameterizedQuery sqlQuery = `select * from Arraytypes5 where row_id = ${rowId}`;

    _ = validateArrayTableResult14(check simpleQueryPostgresqlClient(sqlQuery, ArrayRecord5, database = executeParamsDatabase));
}

isolated function validateArrayTableResult14(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 2);
        test:assertEquals(returnData["json_array"], ());
        test:assertEquals(returnData["jsonb_array"], ());
        test:assertEquals(returnData["jsonpath_array"], ());
        test:assertEquals(returnData["money_array"], ());
        test:assertEquals(returnData["pglsn_array"], ());
    }
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testSelectFromArrayDataTable2]
}
function testSelectFromArrayDataTable15() returns error? {
    int rowId = 3;

    sql:ParameterizedQuery sqlQuery = `select row_id, json_array, jsonb_array, jsonpath_array, pglsn_array from Arraytypes5 where row_id = ${rowId}`;

    _ = validateArrayTableResult15(check simpleQueryPostgresqlClient(sqlQuery, ArrayRecord5, database = executeParamsDatabase));
}

isolated function validateArrayTableResult15(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 3);
        test:assertEquals(returnData["json_array"], [null,{"key1":"value","key2":2}]);
        test:assertEquals(returnData["jsonb_array"], [null,"{\"key1\": \"value\", \"key2\": 2}"]);
        test:assertEquals(returnData["jsonpath_array"], [null, "$.\"floor\"[*].\"apt\"[*]?(@.\"area\" > 40 && @.\"area\" < 90)?(@.\"rooms\" > 1)"]);
        test:assertEquals(returnData["pglsn_array"], [null, "16/B374D848"]);
    }
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testSelectFromArrayDataTable3]
}
function testSelectFromArrayDataTable16() returns error? {
    int rowId = 4;

    sql:ParameterizedQuery sqlQuery = `select * from Arraytypes5 where row_id = ${rowId}`;

    _ = validateArrayTableResult16(check simpleQueryPostgresqlClient(sqlQuery, ArrayRecord5, database = executeParamsDatabase));
}

isolated function validateArrayTableResult16(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 4);
        test:assertEquals(returnData["json_array"], [null, null]);
        test:assertEquals(returnData["jsonb_array"], [null, null]);
        test:assertEquals(returnData["jsonpath_array"], [null, null]);
        test:assertEquals(returnData["money_array"], [null, null]);
        test:assertEquals(returnData["pglsn_array"], [null, null]);
    }
}

public type EnumQueryRecord record {
  int row_id;
  string value_type;
};

@test:Config {
    groups: ["query"],
    dependsOn: [testSelectFromUuidDataTable2]
}
function testSelectFromEnumDataTable() returns error? {
    int rowId = 1;

    sql:ParameterizedQuery sqlQuery = `select * from EnumTypes where row_id = ${rowId}`;

    _ = validateEnumTableResult(check simpleQueryPostgresqlClient(sqlQuery, EnumQueryRecord, database = queryComplexDatabase));
}

isolated function validateEnumTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["value_type"], "value1");
    }
}

@test:Config {
    groups: ["query"],
    dependsOn: [testSelectFromEnumDataTable]
}
function testSelectFromEnumDataTable2() returns error? {
    int rowId = 2;

    sql:ParameterizedQuery sqlQuery = `select * from EnumTypes where row_id = ${rowId}`;

    _ = validateEnumTableResult2(check simpleQueryPostgresqlClient(sqlQuery, EnumQueryRecord, database = queryComplexDatabase));
}

isolated function validateEnumTableResult2(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 2);
        test:assertEquals(returnData["value_type"], ());
    }
}

function simpleQueryPostgresqlClient(@untainted string|sql:ParameterizedQuery sqlQuery, typedesc<record {}>? resultType = (), string database = simpleParamsDb)
returns @tainted record {}? | error {
    Client dbClient = check new (host, user, password, database, port);
    stream<record {}, error> streamData;
    if resultType is () {
        streamData = dbClient->query(sqlQuery);
    } else {
        streamData = dbClient->query(sqlQuery, resultType);
    }
    record {|record {} value;|}? data = check streamData.next();
    check streamData.close();
    record {}? value = data?.value;
    check dbClient.close();
    return value;
}
