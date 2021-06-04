
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
import ballerina/io;

@test:Config {
    groups: ["execute-params", "execute"]
}
function testInsertIntoNumericDataTable() returns error? {
    int rowId = 43;
    sql:SmallIntValue smallintType = new(1);
    sql:IntegerValue intType = new(1);
    sql:BigIntValue bigintType = new(123456);
    sql:DecimalValue decimalType = new(1234.567);
    sql:NumericValue numericType = new(1234.567);
    sql:RealValue realType = new(123.456);
    sql:DoubleValue doubleType = new(123.456);
    int smallserialType = 1;
    int serialType = 123;
    int bigserialType = 12345;

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO NumericTypes (row_id, smallint_type, int_type, bigint_type, decimal_type,
    numeric_type, real_type, double_type, smallserial_type, serial_type, bigserial_type)
            VALUES(${rowId}, ${smallintType}, ${intType}, ${bigintType}, ${decimalType}, ${numericType},
            ${realType}, ${doubleType}, ${smallserialType}, ${serialType}, ${bigserialType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoNumericDataTable]
}
function testInsertIntoNumericDataTable2() returns error? {
    int rowId = 44;
    sql:SmallIntValue smallintType = new ();
    sql:IntegerValue intType = new();
    sql:BigIntValue bigintType = new();
    sql:DecimalValue decimalType = new();
    sql:NumericValue numericType = new();
    sql:RealValue realType = new();
    sql:DoubleValue doubleType = new();

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO NumericTypes2 (row_id, smallint_type, int_type, bigint_type, decimal_type,
    numeric_type, real_type, double_type)
            VALUES(${rowId}, ${smallintType}, ${intType}, ${bigintType}, ${decimalType}, ${numericType},
            ${realType}, ${doubleType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoNumericDataTable2]
}
function testInsertIntoNumericDataTable3() returns error? {
    int rowId = 45;
    int smallintType = 1;
    int intType = 1;
    int bigintType = 123456;
    decimal decimalType = 1234.567;
    decimal numericType = 1234.567;
    float realType = 123.456;
    float doubleType = 123.456;
    int smallserialType = 1;
    int serialType = 123;
    int bigserialType = 12345;

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO NumericTypes (row_id, smallint_type, int_type, bigint_type, decimal_type,
    numeric_type, real_type, double_type, smallserial_type, serial_type, bigserial_type)
            VALUES(${rowId}, ${smallintType}, ${intType}, ${bigintType}, ${decimalType}, ${numericType},
            ${realType}, ${doubleType}, ${smallserialType}, ${serialType}, ${bigserialType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoNumericDataTable3]
}
function testInsertIntoCharacterDataTable() returns error? {
    int rowId = 44;
    string charValue = "This is a char3";
    string varcharValue = "This is a varchar3";
    string textValue = "This is a text3";
    string nameValue = "This is a name3";

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO CharacterTypes (row_id, char_type, varchar_type, text_type, name_type)
            VALUES(${rowId}, ${charValue}, ${varcharValue}, ${textValue}, ${nameValue})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoCharacterDataTable]
}
function testInsertIntoCharacterDataTable2() returns error? {
    int rowId = 45;
    sql:CharValue charValue = new ("This is a char3");
    sql:VarcharValue varcharValue = new ("This is a varchar3");
    sql:TextValue textValue = new ("This is a text3");
    string nameValue = "This is a name3";

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO CharacterTypes (row_id, char_type, varchar_type, text_type, name_type)
            VALUES(${rowId}, ${charValue}, ${varcharValue}, ${textValue}, ${nameValue})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoCharacterDataTable2]
}
function testInsertIntoCharacterDataTable3() returns error? {
    int rowId = 46;
    sql:CharValue charValue = new ();
    sql:VarcharValue varcharValue = new ();
    sql:TextValue textValue = new ();
    string? nameValue = ();

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO CharacterTypes (row_id, char_type, varchar_type, text_type, name_type)
            VALUES(${rowId}, ${charValue}, ${varcharValue}, ${textValue}, ${nameValue})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoCharacterDataTable3]
}
function testInsertIntoBooleanDataTable() returns error? {
    int rowId = 43;
    boolean booleanType = true;

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO BooleanTypes (row_id, boolean_type)
            VALUES(${rowId}, ${booleanType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoBooleanDataTable]
}
function testInsertIntoBooleanDataTable2() returns error? {
    int rowId = 44;
    boolean? booleanType = ();

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO BooleanTypes (row_id, boolean_type)
            VALUES(${rowId}, ${booleanType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoBooleanDataTable2]
}
function testInsertIntoNetworkDataTable() returns error? {
    int rowId = 44;
    InetValue inetValue = new ("192.168.0.1/24");
    CidrValue cidrValue = new ("::ffff:1.2.3.0/120");
    MacAddrValue macaddrValue = new ("08:00:2b:01:02:03");
    MacAddr8Value macaddr8Value = new ("08-00-2b-01-02-03-04-00");

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO NetworkTypes (row_id, inet_type, cidr_type, macaddr_type, macaddr8_type)
            VALUES(${rowId}, ${inetValue}, ${cidrValue}, ${macaddrValue}, ${macaddr8Value})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoNetworkDataTable]
}
function testInsertIntoNetworkDataTable2() returns error? {
    int rowId = 45;
    InetValue inetValue = new ();
    CidrValue cidrValue = new ();
    MacAddrValue macaddrValue = new ();
    MacAddr8Value macaddr8Value = new ();

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO NetworkTypes (row_id, inet_type, cidr_type, macaddr_type, macaddr8_type)
            VALUES(${rowId}, ${inetValue}, ${cidrValue}, ${macaddrValue}, ${macaddr8Value})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}


@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoNetworkDataTable2]
}
function testInsertIntoGeometricDataTable() returns error? {
    int rowId = 43;
    PointValue pointType = new ("(1,2)");
    LineValue lineType = new ("{1,2,3}");
    LsegValue lsegType = new ("(1,1),(2,2)");
    BoxValue boxType = new ("(1,1),(2,2)");
    PathValue pathType = new ("[(1,1),(2,2)]");
    PolygonValue polygonType = new ("((1,1),(2,2))");
    CircleValue circleType = new ("<(1,1),1>");

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO GeometricTypes (row_id, point_type, line_type, lseg_type, box_type, path_type, polygon_type, circle_type)
            VALUES(${rowId}, ${pointType}, ${lineType}, ${lsegType}, ${boxType}, ${pathType}, ${polygonType}, ${circleType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoGeometricDataTable]
}
function testInsertIntoGeometricDataTable2() returns error? {
    int rowId = 45;
    PointValue pointType = new ({x: 2, y:2});
    LineValue lineType = new ({a:2, b:3, c:4});
    LsegValue lsegType = new ({x1: 2, x2: 3, y1: 2, y2:3});
    BoxValue boxType = new ({x1: 2, x2: 3, y1: 2, y2:3});
    PathValue pathType = new ([{x: 2, y:2}, {x: 2, y:2}]);
    PolygonValue polygonType = new ([{x: 2, y:2}, {x: 2, y:2}]);
    CircleValue circleType = new ({x: 2, y:2, r:2});

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO GeometricTypes (row_id, point_type, line_type, lseg_type, box_type, path_type, polygon_type, circle_type)
            VALUES(${rowId}, ${pointType}, ${lineType}, ${lsegType}, ${boxType}, ${pathType}, ${polygonType}, ${circleType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoGeometricDataTable2]
}
function testInsertIntoGeometricDataTable3() returns error? {
    int rowId = 46;
    PointValue pointType = new ();
    LineValue lineType = new ();
    LsegValue lsegType = new ();
    BoxValue boxType = new ();
    PathValue pathType = new ();
    PolygonValue polygonType = new ();
    CircleValue circleType = new ();

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO GeometricTypes (row_id, point_type, line_type, lseg_type, box_type, path_type, polygon_type, circle_type)
            VALUES(${rowId}, ${pointType}, ${lineType}, ${lsegType}, ${boxType}, ${pathType}, ${polygonType}, ${circleType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoGeometricDataTable3]
}
function testInsertIntoGeometricDataTable4() returns error? {
    int rowId = 47;
    Point point = {x: 2, y:2};
    Line line = {a: 2, b: 3, c: 4};
    LineSegment lseg = {x1: 2, x2: 3, y1: 2, y2: 3};
    Box box = {x1: 2, x2: 3, y1: 2, y2: 3};
    Circle circle = {x: 2, y:2, r:2};

    PointValue pointType = new (point);
    LineValue lineType = new (line);
    LsegValue lsegType = new (lseg);
    BoxValue boxType = new (box);
    PathValue pathType = new ([point, point, point]);
    PolygonValue polygonType = new ([point, point, point]);
    CircleValue circleType = new (circle);

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO GeometricTypes (row_id, point_type, line_type, lseg_type, box_type, path_type, polygon_type, circle_type)
            VALUES(${rowId}, ${pointType}, ${lineType}, ${lsegType}, ${boxType}, ${pathType}, ${polygonType}, ${circleType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoGeometricDataTable4]
}
function testInsertIntoGeometricDataTable5() returns error? {
    int rowId = 48;
    Point point = {x: 2, y:2};
    Line line = {a: 123.453, b:11.231, c:1.23};
    LineSegment lseg = {x1: 2, x2: 3, y1: 2, y2: 3};
    Box box = {x1: 2, x2: 3, y1: 2, y2: 3};
    Circle circle = {x: 2, y:2, r:2};

    Path pathRecordType = {points: [point, point], open: true};

    PointValue pointType = new (point);
    LineValue lineType = new (line);
    LsegValue lsegType = new (lseg);
    BoxValue boxType = new (box);
    PathValue pathType = new (pathRecordType);
    PolygonValue polygonType = new ([point, point]);
    CircleValue circleType = new (circle);

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO GeometricTypes (row_id, point_type, line_type, lseg_type, box_type, path_type, polygon_type, circle_type)
            VALUES(${rowId}, ${pointType}, ${lineType}, ${lsegType}, ${boxType}, ${pathType}, ${polygonType}, ${circleType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoGeometricDataTable3]
}
function testInsertIntoUuidDataTable() returns error? {
    int rowId = 43;
    UuidValue uuidType = new ("a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11");

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO UuidTypes (row_id, uuid_type)
            VALUES(${rowId}, ${uuidType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoUuidDataTable]
}
function testInsertIntoUuidDataTable2() returns error? {
    int rowId = 44;
    UuidValue uuidType = new ();

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO UuidTypes (row_id, uuid_type)
            VALUES(${rowId}, ${uuidType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoUuidDataTable2]
}
function testInsertIntoTextSearchDataTable() returns error? {
    int rowId = 43;
    TsvectorValue tsvectorType = new ("a fat cat sat on a mat and ate a fat rat");
    TsqueryValue tsqueryType = new ("fat & rat");

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO TextSearchTypes (row_id, tsvector_type, tsquery_type)
            VALUES(${rowId}, ${tsvectorType}, ${tsqueryType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoTextSearchDataTable]
}
function testInsertIntoTextSearchDataTable2() returns error? {
    int rowId = 44;
    TsvectorValue tsvectorType = new ();
    TsqueryValue tsqueryType = new ();

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO TextSearchTypes (row_id, tsvector_type, tsquery_type)
            VALUES(${rowId}, ${tsvectorType}, ${tsqueryType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoTextSearchDataTable2]
}
function testInsertIntoJsonDataTable() returns error? {
    int rowId = 43;
    JsonValue jsonType = new("{\"a\":1,\"b\":\"Hello\"}");
    JsonbValue jsonbType = new("{\"a\":2,\"b\":\"Hello\"}");
    JsonPathValue jsonpathType = new("$.\"floor\"[*].\"apt\"[*]?(@.\"area\" > 40 && @.\"area\" < 90)?(@.\"rooms\" > 1)");
    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO JsonTypes (row_id, json_type, jsonb_type, jsonpath_type)
            VALUES(${rowId}, ${jsonType}, ${jsonbType}, ${jsonpathType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoJsonDataTable]
}
function testInsertIntoJsonDataTable2() returns error? {
    int rowId = 44;
    JsonValue jsonType = new();
    JsonbValue jsonbType = new();
    JsonPathValue jsonpathType = new();

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO JsonTypes (row_id, json_type, jsonb_type, jsonpath_type)
            VALUES(${rowId}, ${jsonType}, ${jsonbType}, ${jsonpathType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoJsonDataTable2]
}
function testInsertIntoJsonDataTable3() returns error? {
    int rowId = 45;
    json jsonValue = {"a":11,"b":2};
    JsonValue jsonType = new(jsonValue);
    JsonbValue jsonbType = new(jsonValue);
    JsonPathValue jsonpathType = new("$.\"floor\"[*].\"apt\"[*]?(@.\"area\" > 40 && @.\"area\" < 90)?(@.\"rooms\" > 10)");

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO JsonTypes (row_id, json_type, jsonb_type, jsonpath_type)
            VALUES(${rowId}, ${jsonType}, ${jsonbType}, ${jsonpathType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoJsonDataTable3]
}
function testInsertIntoDateDataTable() returns error? {
    int rowId = 43;
    time:Date date = {year: 2017, month: 12, day: 18};
    time:TimeOfDay time = {hour: 23, minute: 12, second: 18};
    time:TimeOfDay timetz = {hour: 23, minute: 12, second: 18};
    time:Utc timestamp = [100000, 0.5];
    time:Utc timestamptz = [100000, 0.5];
    sql:TimestampValue timestampType = new(timestamp);
    sql:TimestampValue timestamptzType = new(timestamptz);
    sql:DateValue dateType = new(date);
    sql:TimeValue timeType = new(time);
    sql:TimeValue timetzType= new(timetz);
    IntervalValue intervalType= new({years:1, months:2, days:3, hours:4, minutes:5, seconds:6});

    sql:ParameterizedQuery sqlQuery =
        `
        INSERT INTO DateTimeTypes (row_id, timestamp_type, timestamptz_type, date_type, time_type, timetz_type, interval_type)
                VALUES(${rowId}, ${timestampType}, ${timestamptzType}, ${dateType}, ${timeType}, ${timetzType}, ${intervalType})
        `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}


@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoDateDataTable]
}
function testInsertIntoDateDataTable2() returns error? {
    int rowId = 44;
    sql:TimestampValue timestampType = new();
    sql:TimestampValue timestamptzType = new();
    sql:DateValue dateType = new();
    sql:TimeValue timeType = new();
    sql:TimeValue timetzType= new();
    IntervalValue intervalType = new();

    sql:ParameterizedQuery sqlQuery =
         `
            INSERT INTO DateTimeTypes (row_id, timestamp_type, timestamptz_type, date_type, time_type, timetz_type, interval_type)
                    VALUES(${rowId}, ${timestampType}, ${timestamptzType}, ${dateType}, ${timeType}, ${timetzType}, ${intervalType})
        `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoDateDataTable2]
}
function testInsertIntoDateDataTable3() returns error? {
    int rowId = 45;
    IntervalValue intervalType= new("1 years 2 mons");

    sql:ParameterizedQuery sqlQuery =
            `
        INSERT INTO DateTimeTypes (row_id, interval_type)
                VALUES(${rowId}, ${intervalType})
        `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoDateDataTable3]
}
function testInsertIntoDateDataTable4() returns error? {
    int rowId = 46;
    time:Date date = {year: 2017, month: 12, day: 18};
    time:TimeOfDay time = {hour: 23, minute: 12, second: 18, "utcOffset": {hours: 8, minutes: 30}};
    time:Civil timestamp = {year: 2017, month:2, day: 3, hour: 11, minute: 53, second:0, "utcOffset": {hours: 8, minutes: 30}};
    sql:DateTimeValue timestamptzType = new(timestamp);
    sql:DateTimeValue timestampType = new(timestamp);
    sql:DateValue dateType = new(date);
    sql:TimeValue timeType = new(time);
    sql:TimeValue timetzType= new(time);
    IntervalValue intervalType= new({years:1, months:2, days:3, hours:4, minutes:5, seconds:6});

    sql:ParameterizedQuery sqlQuery =
        `
        INSERT INTO DateTimeTypes (row_id, timestamp_type, timestamptz_type, date_type, time_type, timetz_type, interval_type)
                VALUES(${rowId}, ${timestampType}, ${timestamptzType}, ${dateType}, ${timeType}, ${timetzType}, ${intervalType})
        `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoDateDataTable3]
}
function testInsertIntoRangeDataTable() returns error? {
    int rowId = 43;
    IntegerRange int4rangeRecordType = {upper: 50 , lower: 3 , upperboundInclusive: false, lowerboundInclusive: true};
    LongRange int8rangeRecordType = {upper: 100, lower: 11, upperboundInclusive: false, lowerboundInclusive: true};
    NumericalRange numrangeRecordType = {upper: 24, lower: 0, upperboundInclusive: false, lowerboundInclusive: false};
    TimestampRange tsrangeRecordType = {lower: "2010-01-01 14:30:00", upper: "2010-01-01 15:30:00"};
    TimestamptzRange tstzrangeRecordType = {lower: "2010-01-01 20:00:00+05:30", upper: "2010-01-01 21:00:00+05:30"};
    DateRange daterangeRecordType = {lower: "2010-01-02", upper: "2010-01-03", lowerboundInclusive: true};

    IntegerRangeValue int4rangeType = new(int4rangeRecordType);
    LongRangeValue int8rangeType = new(int8rangeRecordType);
    NumericRangeValue numrangeType = new(numrangeRecordType);
    TsrangeValue tsrangeType = new(tsrangeRecordType);
    TstzrangeValue tstzrangeType= new(tstzrangeRecordType);
    DateRangeValue daterangeType= new(daterangeRecordType);

    sql:ParameterizedQuery sqlQuery =
        `
        INSERT INTO RangeTypes (row_id, int4range_type, int8range_type, numrange_type, tsrange_type, tstzrange_type, daterange_type)
                VALUES(${rowId}, ${int4rangeType}, ${int8rangeType}, ${numrangeType}, ${tsrangeType}, ${tstzrangeType}, ${daterangeType})
        `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoRangeDataTable]
}
function testInsertIntoRangeDataTable2() returns error? {
    int rowId = 44;
    IntegerRangeValue int4rangeType = new();
    LongRangeValue int8rangeType = new();
    NumericRangeValue numrangeType = new();
    TsrangeValue tsrangeType = new();
    TstzrangeValue tstzrangeType= new();
    DateRangeValue daterangeType = new();

        sql:ParameterizedQuery sqlQuery =
        `
        INSERT INTO RangeTypes (row_id, int4range_type, int8range_type, numrange_type, tsrange_type, tstzrange_type, daterange_type)
                VALUES(${rowId}, ${int4rangeType}, ${int8rangeType}, ${numrangeType}, ${tsrangeType}, ${tstzrangeType}, ${daterangeType})
        `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoRangeDataTable2]
}
function testInsertIntoRangeDataTable3() returns error? {
    int rowId = 45;
    IntegerRangeValue int4rangeType = new("(2,50)");
    LongRangeValue int8rangeType = new("(10,100)");
    NumericRangeValue numrangeType = new("(0.1,2.4)");
    TsrangeValue tsrangeType = new("(2010-01-01 14:30, 2010-01-01 15:30)");
    TstzrangeValue tstzrangeType= new("(2010-01-01 14:30, 2010-01-01 15:30)");
    DateRangeValue daterangeType= new("(2010-01-01 14:30, 2010-01-03 )");

    sql:ParameterizedQuery sqlQuery =
        `
        INSERT INTO RangeTypes (row_id, int4range_type, int8range_type, numrange_type, tsrange_type, tstzrange_type, daterange_type)
                VALUES(${rowId}, ${int4rangeType}, ${int8rangeType}, ${numrangeType}, ${tsrangeType}, ${tstzrangeType}, ${daterangeType})
        `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoRangeDataTable3]
}
function testInsertIntoRangeDataTable4() returns error? {
    int rowId = 48;
    IntegerRange int4Range = {upper:100 , lower:10 , upperboundInclusive: true, lowerboundInclusive: false};
    LongRange int8Range = {upper:123450 , lower:13245 , upperboundInclusive: false , lowerboundInclusive: true};
    NumericalRange numRange = {upper: 12330.121, lower: 1229.12, upperboundInclusive: true, lowerboundInclusive: true};
    TimestampRange tsRange = {lower:"2010-01-01 14:30" , upper:"2010-01-01 15:30"};
    TimestamptzRange tstzRange = {lower:"2010-01-01 14:30" , upper:"2010-01-01 15:30"};
    DateRange dateRange = {lower:"2010-01-01" , upper:"2010-01-02"};

    IntegerRangeValue int4rangeType = new(int4Range);
    LongRangeValue int8rangeType = new(int8Range);
    NumericRangeValue numrangeType = new(numRange);
    TsrangeValue tsrangeType = new(tsRange);
    TstzrangeValue tstzrangeType= new(tstzRange);
    DateRangeValue daterangeType= new(dateRange);

    sql:ParameterizedQuery sqlQuery =
        `
        INSERT INTO RangeTypes (row_id, int4range_type, int8range_type, numrange_type, tsrange_type, tstzrange_type, daterange_type)
                VALUES(${rowId}, ${int4rangeType}, ${int8rangeType}, ${numrangeType}, ${tsrangeType}, ${tstzrangeType}, ${daterangeType})
        `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoRangeDataTable4]
}
function testInsertIntoRangeDataTable5() returns error? {
    int rowId = 49;
    time:Date date1 = {year: 2017, month: 12, day: 18};
    time:Date date2 = {year: 2017, month: 12, day: 20};
    time:Civil timestamp1 = {year: 2031, month:2, day: 3, hour: 11, minute: 53, second:0, "utcOffset": {hours: 2, minutes: 30}};
    time:Civil timestamp2 = {year: 2031, month:2, day: 3, hour: 11, minute: 55, second:0, "utcOffset": {hours: 1, minutes: 30}};
    time:Civil timestamp3 = {year: 2031, month:2, day: 3, hour: 11, minute: 53, second:0, "utcOffset": {hours: 4, minutes: 30}};
    time:Civil timestamp4 = {year: 2031, month:2, day: 3, hour: 11, minute: 55, second:0, "utcOffset": {hours: 3, minutes: 30}};

    TimestampCivilRange tsRange = {lower: timestamp1 , upper: timestamp2, upperboundInclusive: true};
    TimestamptzCivilRange tstzRange = {lower: timestamp3 , upper: timestamp4, lowerboundInclusive: true};
    DateRecordRange dateRange = {lower: date1 , upper: date2, lowerboundInclusive: true, upperboundInclusive: true};

    TsrangeValue tsrangeType = new(tsRange);
    TstzrangeValue tstzrangeType= new(tstzRange);
    DateRangeValue daterangeType= new(dateRange);

    sql:ParameterizedQuery sqlQuery =
        `
        INSERT INTO RangeTypes (row_id,tsrange_type, tstzrange_type, daterange_type)
                VALUES(${rowId}, ${tsrangeType}, ${tstzrangeType}, ${daterangeType})
        `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoRangeDataTable4]
}
function testInsertIntoBitDataTable() returns error? {
    int rowId = 43;
    BitstringValue bitstringType = new("1110001100");
    VarbitstringValue varbitstringType = new("11001");
    PGBitValue bitType = new("0");
    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO BitTypes (row_id, bitstring_type, varbitstring_type, bit_type)
            VALUES(${rowId}, ${bitstringType}, ${varbitstringType}, ${bitType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoBitDataTable]
}
function testInsertIntoBitDataTable2() returns error? {
    int rowId = 44;
    BitstringValue bitstringType = new();
    VarbitstringValue varbitstringType = new();
    PGBitValue bitType = new();

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO BitTypes (row_id, bitstring_type, varbitstring_type, bit_type)
            VALUES(${rowId}, ${bitstringType}, ${varbitstringType}, ${bitType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoBitDataTable2]
}
function testInsertIntoPglsnDataTable() returns error? {
    int rowId = 43;
    PglsnValue pglsnType = new ("16/B374D848");

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO PglsnTypes (row_id, pglsn_type)
            VALUES(${rowId}, ${pglsnType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoPglsnDataTable]
}
function testInsertIntoPglsnDataTable2() returns error? {
    int rowId = 44;
    PglsnValue pglsnType = new ();

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO PglsnTypes (row_id, pglsn_type)
            VALUES(${rowId}, ${pglsnType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoPglsnDataTable2]
}
function testInsertIntoObjectidentifierDataTable() returns error? {
    int rowId = 43;
    int oidType = 12;
    RegClassValue regclassType = new("pg_type");
    RegConfigValue regconfigType = new("english");
    RegDictionaryValue regdictionaryType = new("simple");
    RegNameSpaceValue regnamespaceType = new("pg_catalog");
    RegOperValue regoperType = new("!");
    RegOperatorValue regoperatorType = new("*(int,int)");
    RegProcValue regprocType = new("NOW");
    RegProcedureValue regprocedureType = new("sum(int4)");
    RegRoleValue regroleType = new("postgres");
    RegTypeValue regtypeType = new("int");

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO ObjectidentifierTypes (row_id, oid_type, regclass_type, regconfig_type, regdictionary_type,
    regnamespace_type, regoper_type, regoperator_type, regproc_type, regprocedure_type, regrole_type, regtype_type)
            VALUES(${rowId}, ${oidType}, ${regclassType}, ${regconfigType}, ${regdictionaryType}, ${regnamespaceType},
            ${regoperType}, ${regoperatorType}, ${regprocType}, ${regprocedureType}, ${regroleType}, ${regtypeType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoObjectidentifierDataTable]
}
function testInsertIntoObjectidentifierDataTable2() returns error? {
    int rowId = 44;
    int? oidType = ();
    RegClassValue regclassType = new();
    RegConfigValue regconfigType = new();
    RegDictionaryValue regdictionaryType = new();
    RegNameSpaceValue regnamespaceType = new();
    RegOperValue regoperType = new();
    RegOperatorValue regoperatorType = new();
    RegProcValue regprocType = new();
    RegProcedureValue regprocedureType = new();
    RegRoleValue regroleType = new();
    RegTypeValue regtypeType = new();

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO ObjectidentifierTypes (row_id, oid_type, regclass_type, regconfig_type, regdictionary_type,
    regnamespace_type, regoper_type, regoperator_type, regproc_type, regprocedure_type, regrole_type, regtype_type)
            VALUES(${rowId}, ${oidType}, ${regclassType}, ${regconfigType}, ${regdictionaryType}, ${regnamespaceType},
            ${regoperType}, ${regoperatorType}, ${regprocType}, ${regprocedureType}, ${regroleType}, ${regtypeType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoObjectidentifierDataTable2]
}
function testInsertIntoBinaryDataTable() returns error? {
    int rowId = 43;
    byte [] byteArray = [1, 2, 3, 4];
    sql:BinaryValue byteaType = new (byteArray);
    sql:BinaryValue byteaEscapeType = new (byteArray);

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO BinaryTypes (row_id, bytea_type, bytea_escape_type)
            VALUES(${rowId}, ${byteaType}, ${byteaEscapeType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoBinaryDataTable]
}
function testInsertIntoBinaryDataTable2() returns error? {
    int rowId = 44;
    sql:BinaryValue byteaType = new ();
    sql:BinaryValue byteaEscapeType = new ();

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO BinaryTypes (row_id, bytea_type, bytea_escape_type)
            VALUES(${rowId}, ${byteaType}, ${byteaEscapeType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}


@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoBinaryDataTable2]
}
function testInsertIntoBinaryDataTable3() returns error? {
    int rowId = 45;
    io:ReadableByteChannel byteChannel = check getByteaColumnChannel();
    sql:BinaryValue byteaType = new (byteChannel);
    sql:BinaryValue byteaEscapeType = new (byteChannel);

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO BinaryTypes (row_id, bytea_type, bytea_escape_type)
            VALUES(${rowId}, ${byteaType}, ${byteaEscapeType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoBinaryDataTable3]
}
function testInsertIntoBinaryDataTable4() returns error? {
    int rowId = 46;
    io:ReadableByteChannel byteChannel = check getByteaColumnChannel2();
    sql:BinaryValue byteaType = new (byteChannel);
    sql:BinaryValue byteaEscapeType = new (byteChannel);

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO BinaryTypes (row_id, bytea_type, bytea_escape_type)
            VALUES(${rowId}, ${byteaType}, ${byteaEscapeType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoBinaryDataTable4]
}
function testInsertIntoBinaryDataTable5() returns error? {
    int rowId = 47;
    byte [] byteArray = [1, 2, 3, 4];

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO BinaryTypes (row_id, bytea_type, bytea_escape_type)
            VALUES(${rowId}, ${byteArray}, ${byteArray})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoObjectidentifierDataTable2]
}
function testInsertIntoXmlDataTable() returns error? {
    int rowId = 43;
    xml xmlValue = xml `<foo>Value</foo>`;
    PGXmlValue xmlType = new (xmlValue);

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO XmlTypes (row_id, xml_type)
            VALUES(${rowId}, ${xmlType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoXmlDataTable]
}
function testInsertIntoXmlDataTable2() returns error? {
    int rowId = 44;
    string xmlValue = "<foo>Value</foo>";
    PGXmlValue xmlType = new (xmlValue);

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO XmlTypes (row_id, xml_type)
            VALUES(${rowId}, ${xmlType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoXmlDataTable2]
}
function testInsertIntoXmlDataTable3() returns error? {
    int rowId = 45;
    PGXmlValue xmlType = new ();

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO XmlTypes (row_id, xml_type)
            VALUES(${rowId}, ${xmlType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoXmlDataTable3]
}
function testInsertIntoXmlDataTable4() returns error? {
    int rowId = 46;
    xml? xmlType = ();

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO XmlTypes (row_id, xml_type)
            VALUES(${rowId}, ${xmlType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoXmlDataTable4]
}
function testInsertIntoXmlDataTable5() returns error? {
    int rowId = 47;
    xml xmlValue = xml `<foo>Value</foo>`;

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO XmlTypes (row_id, xml_type)
            VALUES(${rowId}, ${xmlValue})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoXmlDataTable5]
}
function testInsertIntoMoneyDataTable() returns error? {
    int rowId = 43;
    float moneyValue = 10001.67;
    MoneyValue moneyType = new (moneyValue);

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO MoneyTypes (row_id, money_type)
            VALUES(${rowId}, ${moneyType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoMoneyDataTable]
}
function testInsertIntoMoneyDataTable2() returns error? {
    int rowId = 44;
    string moneyValue = "$1900.67";
    MoneyValue moneyType = new (moneyValue);

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO MoneyTypes (row_id, money_type)
            VALUES(${rowId}, ${moneyType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoMoneyDataTable2]
}
function testInsertIntoMoneyDataTable3() returns error? {
    int rowId = 45;
    decimal moneyValue = 10001.67;
    MoneyValue moneyType = new (moneyValue);

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO MoneyTypes (row_id, money_type)
            VALUES(${rowId}, ${moneyType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoMoneyDataTable3]
}
function testInsertIntoMoneyDataTable4() returns error? {
    int rowId = 46;
    MoneyValue moneyType = new ();

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO MoneyTypes (row_id, money_type)
            VALUES(${rowId}, ${moneyType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoMoneyDataTable4]
}
function testInsertIntoArrayDataTable() returns error? {
    int rowId = 43;

    int[] smallIntArray = [1, 1];
    int[] intArray = [11, 11];
    int[] bigIntArray = [111,111,111];
    decimal[] decimalArray =  [11.11,11.11];
    decimal[] numericArray =  [11.11,11.11];
    decimal[] realArray =  [11.11,11.11];
    decimal[] doubleArray =  [11.11,11.11];
    string[] charArray = ["This is char123","This is char123"];
    string[] varcharArray = ["This is varchar","This is varchar"];
    string[] textArray = ["This is text123","This is text123"];
    boolean[] booleanArray = [true, false, true];
    byte[][] byteaArray = [[1,2,3],[11,5,7]];

    sql:ArrayValue smallintarrayType = new(smallIntArray);
    sql:ArrayValue intarrayType = new(intArray);
    sql:ArrayValue bigintarrayType = new(bigIntArray);
    sql:ArrayValue decimalarrayType = new(decimalArray);
    sql:ArrayValue numericarrayType = new(numericArray);
    sql:ArrayValue realarrayType = new(realArray);
    sql:ArrayValue doublearrayType = new(doubleArray);
    sql:ArrayValue chararrayType = new(charArray);
    sql:ArrayValue varchararrayType = new(varcharArray);
    sql:ArrayValue textarrayType = new(textArray);
    sql:ArrayValue booleanarrayType = new(booleanArray);
    sql:ArrayValue byteaarrayType = new(byteaArray);

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO ArrayTypes (row_id, smallintarray_type, intarray_type, bigintarray_type,
     decimalarray_type, numericarray_type, realarray_type, doublearray_type,
      chararray_type, varchararray_type,
            textarray_type, booleanarray_type, byteaarray_type)
            VALUES(${rowId}, ${smallintarrayType}, ${intarrayType}, ${bigintarrayType}, ${decimalarrayType},
            ${numericarrayType}, ${realarrayType}, ${doublearrayType}, ${chararrayType}, ${varchararrayType}, ${textarrayType}, ${booleanarrayType}, ${byteaarrayType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoArrayDataTable]
}
function testInsertIntoArrayDataTable2() returns error? {
    int rowId = 44;

    sql:ArrayValue smallintarrayType = new();
    sql:ArrayValue intarrayType = new();
    sql:ArrayValue bigintarrayType = new();
    sql:ArrayValue decimalarrayType = new();
    sql:ArrayValue numericarrayType = new();
    sql:ArrayValue chararrayType = new();
    sql:ArrayValue varchararrayType = new();
    sql:ArrayValue textarrayType = new();
    sql:ArrayValue booleanarrayType = new();
    sql:ArrayValue byteaarrayType = new();

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO ArrayTypes (row_id, smallintarray_type, intarray_type, bigintarray_type,
     decimalarray_type, numericarray_type, chararray_type, varchararray_type,
            textarray_type, booleanarray_type, byteaarray_type)
            VALUES(${rowId}, ${smallintarrayType}, ${intarrayType}, ${bigintarrayType}, ${decimalarrayType},
            ${numericarrayType}, ${chararrayType}, ${varchararrayType}, ${textarrayType}, ${booleanarrayType}, ${byteaarrayType})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute", "execute-params"],
    dependsOn: [testInsertIntoArrayDataTable2]
}
function testInsertIntoArrayDataTable3() returns error? {
    int rowId = 43;
    float float1 = 19.21;
    float float2 = 492.98;
    sql:SmallIntArrayValue smallintArrayValue = new([1211, 478]);
    sql:IntegerArrayValue intArrayValue = new([1211, 478]);
    sql:BigIntArrayValue bigintArrayValue = new([1211, 478]);
    sql:DoubleArrayValue doubleArrayValue = new([float1, float2]);
    sql:RealArrayValue realArrayValue = new([float1, float2]);
    sql:DecimalArrayValue decimalArrayValue = new([<decimal> 12.245, <decimal> 13.245]);
    sql:NumericArrayValue numericArrayValue = new([float1, float2]);
    sql:CharArrayValue charArrayValue = new(["Char value", "Character"]);
    sql:VarcharArrayValue varcharArrayValue = new(["Varchar value", "Varying Char"]);
    string[] stringArrayValue = ["Hello", "Ballerina"];
    sql:BooleanArrayValue booleanArrayValue = new([true, false, true]);
    sql:DateArrayValue dateArrayValue = new(["2021-12-18", "2021-12-19"]);
    time:TimeOfDay time = {hour: 20, minute: 8, second: 12};
    sql:TimeArrayValue timeArrayValue = new([time, time]);
    time:Civil datetime = {year: 2021, month: 12, day: 18, hour: 20, minute: 8, second: 12};
    sql:DateTimeArrayValue timestampArrayValue = new([datetime, datetime]);
    byte[] byteArray1 = [1, 2, 3];
    byte[] byteArray2 = [4, 5, 6];
    sql:BinaryArrayValue binaryArrayValue = new([byteArray1, byteArray2]);
    sql:BitArrayValue bitArrayValue = new([true, false]);

    sql:ParameterizedQuery sqlQuery =
        `INSERT INTO ArrayTypes2 (row_id, smallint_array, int_array, bigint_array, decimal_array, numeric_array,
         real_array, double_array, boolean_array, char_array, varchar_array, string_array, date_array, time_array,
         timestamp_array, bytea_array, bit_array)
         VALUES(${rowId}, ${smallintArrayValue}, ${intArrayValue}, ${bigintArrayValue}, ${decimalArrayValue}, ${numericArrayValue},
         ${realArrayValue}, ${doubleArrayValue}, ${booleanArrayValue}, ${charArrayValue}, ${varcharArrayValue}, ${stringArrayValue},
         ${dateArrayValue}, ${timeArrayValue}, ${timestampArrayValue}, ${binaryArrayValue}, ${bitArrayValue})`;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute", "execute-params"],
    dependsOn: [testInsertIntoArrayDataTable3]
}
function testInsertIntoArrayDataTable4() returns error? {
    int rowId = 44;
    sql:ArrayValue smallintArrayValue = new ();
    sql:ArrayValue intArrayValue = new ();
    sql:ArrayValue bigintArrayValue = new ();
    sql:ArrayValue decimalArrayValue = new ();
    sql:ArrayValue numericArrayValue = new ();
    sql:ArrayValue realArrayValue = new ();
    sql:ArrayValue doubleArrayValue = new ();
    sql:ArrayValue charArrayValue = new ();
    sql:ArrayValue varcharArrayValue = new ();
    sql:ArrayValue stringArrayValue = new ();
    sql:ArrayValue booleanArrayValue = new ();
    sql:ArrayValue dateArrayValue = new ();
    sql:ArrayValue timeArrayValue = new ();
    sql:ArrayValue timestampArrayValue = new ();
    sql:ArrayValue binaryArrayValue = new ();

    sql:ParameterizedQuery sqlQuery =
        `INSERT INTO ArrayTypes2 (row_id, smallint_array, int_array, bigint_array, decimal_array, numeric_array,
         real_array, double_array, boolean_array, char_array, varchar_array, string_array, date_array, time_array, timestamp_array, bytea_array)
         VALUES(${rowId}, ${smallintArrayValue}, ${intArrayValue}, ${bigintArrayValue}, ${decimalArrayValue}, ${numericArrayValue},
         ${realArrayValue}, ${doubleArrayValue}, ${booleanArrayValue}, ${charArrayValue}, ${varcharArrayValue}, ${stringArrayValue}, ${dateArrayValue}, ${timeArrayValue}, ${timestampArrayValue}, ${binaryArrayValue})`;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute", "execute-params"],
    dependsOn: [testInsertIntoArrayDataTable4]
}
function testInsertIntoArrayDataTable5() returns error? {
    int rowId = 45;
    sql:SmallIntArrayValue smallintArrayValue = new([null, null]);
    sql:IntegerArrayValue intArrayValue = new([null, null]);
    sql:BigIntArrayValue bigintArrayValue = new([null, null]);
    sql:DoubleArrayValue doubleArrayValue = new(<int?[]>[null, null]);
    sql:RealArrayValue realArrayValue = new(<int?[]>[null, null]);
    sql:DecimalArrayValue decimalArrayValue = new(<int?[]>[null, null]);
    sql:NumericArrayValue numericArrayValue = new(<int?[]>[null, null]);
    sql:CharArrayValue charArrayValue = new([null, null]);
    sql:VarcharArrayValue varcharArrayValue = new([null, null]);
    sql:BooleanArrayValue booleanArrayValue = new([null, null]);
    sql:DateArrayValue dateArrayValue = new(<string?[]>[null, null]);
    sql:TimeArrayValue timeArrayValue = new(<string?[]>[null, null]);
    sql:DateTimeArrayValue timestampArrayValue = new(<string?[]>[null, null]);
    sql:BinaryArrayValue binaryArrayValue = new([null, null]);
    sql:BitArrayValue bitArrayValue = new(<int?[]>[null, null]);

    sql:ParameterizedQuery sqlQuery =
        `INSERT INTO ArrayTypes2 (row_id, smallint_array, int_array, bigint_array, decimal_array, numeric_array,
         real_array, double_array, boolean_array, char_array, varchar_array, date_array, time_array, timestamp_array,
         bytea_array, bit_array)
         VALUES(${rowId}, ${smallintArrayValue}, ${intArrayValue}, ${bigintArrayValue}, ${decimalArrayValue}, ${numericArrayValue},
         ${realArrayValue}, ${doubleArrayValue}, ${booleanArrayValue}, ${charArrayValue}, ${varcharArrayValue}, ${dateArrayValue},
         ${timeArrayValue}, ${timestampArrayValue}, ${binaryArrayValue}, ${bitArrayValue})`;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute", "execute-params"],
    dependsOn: [testInsertIntoArrayDataTable5]
}
function testInsertIntoArrayDataTable6() returns error? {
    int rowId = 46;
    decimal decimal1 = 19.21;
    decimal decimal2 = 492.98;
    sql:DoubleArrayValue doubleArrayValue = new([decimal1, decimal2]);
    sql:RealArrayValue realArrayValue = new([decimal1, decimal2]);
    sql:DecimalArrayValue decimalArrayValue = new([decimal1, decimal2]);
    sql:NumericArrayValue numericArrayValue = new([decimal1, decimal2]);
    sql:DateArrayValue dateArrayValue = new(["2021-12-18", "2021-12-19"]);
    time:TimeOfDay time = {hour: 23, minute: 12, second: 18};
    sql:TimeArrayValue timeArrayValue = new([time, time]);
    time:TimeOfDay timetz = {hour: 23, minute: 12, second: 18, "utcOffset": {hours: 2, minutes: 30}};
    sql:TimeArrayValue timetzArrayValue = new([timetz, timetz]);
    time:Civil datetime = {year: 2031, month:2, day: 3, hour: 11, minute: 53, second:0, "utcOffset": {hours: 2, minutes: 30}};
    time:Civil datetimetz = {year: 2031, month:2, day: 3, hour: 11, minute: 53, second:0, "utcOffset": {hours: 2, minutes: 30}};
    sql:DateTimeArrayValue timestampArrayValue = new([datetime, datetime]);
    sql:DateTimeArrayValue timestamptzArrayValue = new([datetimetz, datetimetz]);
    io:ReadableByteChannel byteChannel1 = check getByteaColumnChannel();
    io:ReadableByteChannel byteChannel2 = check getByteaColumnChannel();
    sql:BinaryArrayValue binaryArrayValue = new([byteChannel1, byteChannel2]);
    sql:BitArrayValue bitArrayValue = new([1, 0]);

    sql:ParameterizedQuery sqlQuery =
        `INSERT INTO ArrayTypes2 (row_id, decimal_array, numeric_array,
         real_array, double_array, date_array, time_array, timetz_array, timestamp_array,
            timestamptz_array, bytea_array, bit_array)
         VALUES(${rowId}, ${decimalArrayValue}, ${numericArrayValue},
            ${realArrayValue}, ${doubleArrayValue}, ${dateArrayValue}, ${timeArrayValue},
            ${timetzArrayValue}, ${timestampArrayValue}, ${timestamptzArrayValue}, ${binaryArrayValue},
            ${bitArrayValue})`;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute", "execute-params"],
    dependsOn: [testInsertIntoArrayDataTable6]
}
function testInsertIntoArrayDataTable7() returns error? {
    int rowId = 47;
    Point point1 = {x: 1, y: 2.2};
    Point point2 = {x: 2, y: 3.2};
    PointArrayValue pointArrayValue = new([point1, point2]);
    Line line1 = {a: 2, b: 23, c: 4};
    Line line2 = {a: 12, b: 13, c: 14};
    LineArrayValue lineArrayValue = new([line1, line2]);
    LineSegment lseg1 = {x1: 12, x2: 23, y1: 32, y2: 43};
    LineSegment lseg2 = {x1: 12, x2: 23, y1: 32, y2: 43};
    LsegArrayValue lsegArrayValue = new([lseg1, lseg2]);
    Box box1 = {x1: 2, x2: 3, y1: 2, y2: 3};
    Box box2 = {x1: 2, x2: 3, y1: 2, y2: 3};
    BoxArrayValue boxArrayValue = new([box1, box2]);
    Path path1 = {points: [point1, point2], open: true};
    Path path2 = {points: [point1, point2], open: false};
    PathArrayValue pathArrayValue = new([path1, path2]);
    Circle circle1 = {x: 2, y:2, r: 2};
    Circle circle2 = {x: 2, y:2, r: 12};
    CircleArrayValue circleArrayValue = new([circle1, circle2]);
    Interval interval = {years:1, months:2, days:3, hours:4, minutes:5, seconds:6};
    IntervalArrayValue intervalArrayValue = new([interval, interval]);
    IntegerRange int4range = {upper: 2, lower: -1, upperboundInclusive: true};
    IntegerRangeArrayValue int4rangeArrayValue = new([int4range, int4range]);
    LongRange int8range = {upper: 12000, lower: 10000, lowerboundInclusive: true};
    LongRangeArrayValue int8rangeArrayValue = new([int8range, int8range]);
    NumericalRange numrange = {upper: 221.34, lower: 10.17, upperboundInclusive: true, lowerboundInclusive: true};
    NumericRangeArrayValue numrangeArrayValue = new([numrange, numrange]);
    TimestamptzRange timestamptzRange = {lower: "2010-01-01 20:00:00+01:30", upper: "2010-01-01 23:00:00+02:30"};
    TstzrangeArrayValue timestamptzrangeArrayValue = new([timestamptzRange, timestamptzRange]);
    TimestampRange timestampRange = {lower: "2010-01-01 20:00:00", upper: "2010-01-01 23:00:00"};
    TsrangeArrayValue timestamprangeArrayValue = new([timestampRange, timestampRange]);
    DateRange dateRange = {lower: "2010-01-01", upper: "2010-01-05"};
    DateRangeArrayValue daterangeArrayValue = new([dateRange, dateRange]);
    PolygonArrayValue polygonArrayValue = new([[point1]]);

    sql:ParameterizedQuery sqlQuery =
        `INSERT INTO ArrayTypes3 (row_id, point_array, line_array, lseg_array, box_array, path_array, polygon_array,
                circle_array, interval_array, int4range_array, int8range_array, numrange_array, tstzrange_array,
                tsrange_array, daterange_array)
         VALUES(${rowId}, ${pointArrayValue}, ${lineArrayValue}, ${lsegArrayValue}, ${boxArrayValue}, ${pathArrayValue},
                 ${polygonArrayValue}, ${circleArrayValue}, ${intervalArrayValue}, ${int4rangeArrayValue}, ${int8rangeArrayValue},
                 ${numrangeArrayValue}, ${timestamptzrangeArrayValue}, ${timestamprangeArrayValue}, ${daterangeArrayValue})`;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute", "execute-params"],
    dependsOn: [testInsertIntoArrayDataTable6]
}
function testInsertIntoArrayDataTable8() returns error? {
    int rowId = 48;
    PointArrayValue pointArrayValue = new([{x: 1, y: 2.2}, {x: 2, y: 3.2}]);
    LineArrayValue lineArrayValue = new([{a:2, b:13, c:4}, {a:2, b:13, c:4}]);
    LsegArrayValue lsegArrayValue = new([{x1: 2, x2: 3, y1: 2, y2:3}, {x1: 2, x2: 3, y1: 2, y2:3}]);
    BoxArrayValue boxArrayValue = new([{x1: 2, x2: 3, y1: 2, y2:3}, {x1: 2, x2: 3, y1: 2, y2:3}]);
    PathArrayValue pathArrayValue = new([[{x: 2, y:2}, {x: 2, y:2}], [{x: 2, y:2}, {x: 2, y:2}]]);
    PolygonArrayValue polygonArrayValue = new([[{x: 2, y:2}, {x: 2, y:2}], [{x: 2, y:2}, {x: 2, y:2}]]);
    CircleArrayValue circleArrayValue = new([{x: 2, y:2, r:2}, {x: 2, y:2, r:2}]);
    Interval interval = {years:1, months:2, days:3, hours:4, minutes:5, seconds:6};
    IntervalArrayValue intervalArrayValue = new([interval, interval]);
    IntegerRange integerRange = {upper: 2, lower: -1, upperboundInclusive: true};
    IntegerRangeArrayValue integerRangeArrayValue = new([integerRange, integerRange]);
    LongRange longRange = {upper: 12000, lower: 10000, lowerboundInclusive: true};
    LongRangeArrayValue longRangeArrayValue = new([longRange, longRange]);
    NumericalRange numericalRange = {upper: 221.34, lower: 10.17, upperboundInclusive: true, lowerboundInclusive: true};
    NumericRangeArrayValue numericalRangeArrayValue = new([numericalRange, numericalRange]);
    TimestamptzRange timestamptzRange = {lower: "2010-01-01 20:00:00+01:30", upper: "2010-01-01 23:00:00+02:30", upperboundInclusive: true, lowerboundInclusive: true};
    TstzrangeArrayValue timestamptzRangeArrayValue = new([timestamptzRange, timestamptzRange]);
    TimestampRange timestampRange = {lower: "2010-01-01 20:00:00", upper: "2010-01-01 23:00:00"};
    TsrangeArrayValue timestamprangeArrayValue = new([timestampRange, timestampRange]);
    DateRange dateRange = {lower: "2010-01-01", upper: "2010-01-05"};
    DateRangeArrayValue daterangeArrayValue = new([dateRange, dateRange]);

    sql:ParameterizedQuery sqlQuery =
        `INSERT INTO ArrayTypes3 (row_id, point_array, line_array, lseg_array, box_array, path_array, polygon_array, circle_array,
         interval_array, int4range_array, int8range_array, numrange_array, tstzrange_array, tsrange_array, daterange_array)
         VALUES(${rowId}, ${pointArrayValue}, ${lineArrayValue}, ${lsegArrayValue}, ${boxArrayValue}, ${pathArrayValue},
                 ${polygonArrayValue}, ${circleArrayValue}, ${intervalArrayValue}, ${integerRangeArrayValue},
                 ${longRangeArrayValue}, ${numericalRangeArrayValue}, ${timestamptzRangeArrayValue},
                 ${timestamprangeArrayValue}, ${daterangeArrayValue})`;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute", "execute-params"],
    dependsOn: [testInsertIntoArrayDataTable6]
}
function testInsertIntoArrayDataTable9() returns error? {
    int rowId = 49;
    time:Date date1 = {year: 2017, month: 12, day: 18};
    time:Date date2 = {year: 2017, month: 12, day: 20};
    time:Civil timestamp1 = {year: 2031, month:2, day: 3, hour: 11, minute: 53, second:0, "utcOffset": {hours: 2, minutes: 30}};
    time:Civil timestamp2 = {year: 2031, month:2, day: 3, hour: 11, minute: 55, second:0, "utcOffset": {hours: 1, minutes: 30}};
    time:Civil timestamp3 = {year: 2031, month:2, day: 3, hour: 11, minute: 53, second:0, "utcOffset": {hours: 4, minutes: 30}};
    time:Civil timestamp4 = {year: 2031, month:2, day: 3, hour: 11, minute: 55, second:0, "utcOffset": {hours: 3, minutes: 30}};

    TimestampCivilRange tsRange = {lower: timestamp1 , upper: timestamp2, upperboundInclusive: true};
    TimestamptzCivilRange tstzRange = {lower: timestamp3 , upper: timestamp4, lowerboundInclusive: true};
    DateRecordRange dateRange = {lower: date1 , upper: date2, lowerboundInclusive: true, upperboundInclusive: true};

    TstzrangeArrayValue timestamptzRangeArrayValue = new([tstzRange, tstzRange]);
    TsrangeArrayValue timestampRangeArrayValue = new([tsRange, tsRange]);
    DateRangeArrayValue dateRangeArrayValue = new([dateRange, dateRange]);

    sql:ParameterizedQuery sqlQuery =
        `INSERT INTO ArrayTypes3 (row_id, tstzrange_array, tsrange_array, daterange_array)
         VALUES(${rowId}, ${timestamptzRangeArrayValue}, ${timestampRangeArrayValue}, ${dateRangeArrayValue})`;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute", "execute-params"],
    dependsOn: [testInsertIntoArrayDataTable6]
}
function testInsertIntoArrayDataTable10() returns error? {
    int rowId = 50;
    time:Date date1 = {year: 2017, month: 12, day: 18};
    time:Date date2 = {year: 2017, month: 12, day: 20};
    time:Civil timestamp1 = {year: 2031, month:2, day: 3, hour: 11, minute: 53, second:0, "utcOffset": {hours: 2, minutes: 30}};
    time:Civil timestamp2 = {year: 2031, month:2, day: 3, hour: 11, minute: 55, second:0, "utcOffset": {hours: 1, minutes: 30}};
    time:Civil timestamp3 = {year: 2031, month:2, day: 3, hour: 11, minute: 53, second:0, "utcOffset": {hours: 4, minutes: 30}};
    time:Civil timestamp4 = {year: 2031, month:2, day: 3, hour: 11, minute: 55, second:0, "utcOffset": {hours: 3, minutes: 30}};

    TimestampCivilRange tsRange = {lower: timestamp1 , upper: timestamp2, upperboundInclusive: true};
    TimestamptzCivilRange tstzRange = {lower: timestamp3 , upper: timestamp4, lowerboundInclusive: true};
    DateRecordRange dateRange = {lower: date1 , upper: date2, lowerboundInclusive: true, upperboundInclusive: true};

    TstzrangeArrayValue timestamptzRangeArrayValue = new([tstzRange, tstzRange]);
    TsrangeArrayValue timestampRangeArrayValue = new([tsRange, tsRange]);
    DateRangeArrayValue dateRangeArrayValue = new([dateRange, dateRange]);

    sql:ParameterizedQuery sqlQuery =
        `INSERT INTO ArrayTypes3 (row_id, tstzrange_array, tsrange_array, daterange_array)
         VALUES(${rowId}, ${timestamptzRangeArrayValue}, ${timestampRangeArrayValue}, ${dateRangeArrayValue})`;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute", "execute-params"],
    dependsOn: [testInsertIntoArrayDataTable6]
}
function testInsertIntoArrayDataTable11() returns error? {
    int rowId = 51;

    PointArrayValue pointArrayValue = new([null, null]);
    LineArrayValue lineArrayValue = new(<string?[]>[null, null]);
    LsegArrayValue lsegArrayValue = new(<string?[]>[null, null]);
    BoxArrayValue boxArrayValue = new(<string?[]>[null, null]);
    PathArrayValue pathArrayValue = new(<string?[]>[null, null]);
    PolygonArrayValue polygonArrayValue = new(<string?[]>[null, null]);
    CircleArrayValue circleArrayValue = new(<string?[]>[null, null]);
    IntervalArrayValue intervalArrayValue = new(<string?[]>[null, null]);
    IntegerRangeArrayValue integerRangeArrayValue = new(<string?[]>[null, null]);
    LongRangeArrayValue longRangeArrayValue = new(<string?[]>[null, null]);
    NumericRangeArrayValue numericalRangeArrayValue = new(<string?[]>[null, null]);
    TstzrangeArrayValue timestamptzRangeArrayValue = new(<string?[]>[null, null]);
    TsrangeArrayValue timestamprangeArrayValue = new(<string?[]>[null, null]);
    DateRangeArrayValue daterangeArrayValue = new(<string?[]>[null, null]);

    sql:ParameterizedQuery sqlQuery =
        `INSERT INTO ArrayTypes3 (row_id, point_array, line_array, lseg_array, box_array, path_array, polygon_array, circle_array,
         interval_array, int4range_array, int8range_array, numrange_array, tstzrange_array, tsrange_array, daterange_array)
         VALUES(${rowId}, ${pointArrayValue}, ${lineArrayValue}, ${lsegArrayValue}, ${boxArrayValue}, ${pathArrayValue},
                 ${polygonArrayValue}, ${circleArrayValue}, ${intervalArrayValue}, ${integerRangeArrayValue},
                 ${longRangeArrayValue}, ${numericalRangeArrayValue}, ${timestamptzRangeArrayValue},
                 ${timestamprangeArrayValue}, ${daterangeArrayValue})`;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute", "execute-params"],
    dependsOn: [testInsertIntoArrayDataTable11]
}
function testInsertIntoArrayDataTable12() returns error? {
    int rowId = 43;
    InetArrayValue inetArrayValue = new(["192.168.0.1/24", "192.168.0.1/24"]);
    CidrArrayValue cidrArrayValue = new(["::ffff:1.2.3.0/120", "::ffff:1.2.3.0/120"]);
    MacAddrArrayValue macaddrArrayValue = new(["08:00:2b:01:02:03", "08:00:2b:01:02:03"]);
    MacAddr8ArrayValue macaddr8ArrayValue = new(["08-00-2b-01-02-03-04-05", "08-00-2b-01-02-03-04-05"]);
    UuidArrayValue uuidArrayValue = new(["a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11", "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11"]);
    TsvectorArrayValue tsvectorArrayValue = new(["a fat cat sat on a mat and ate a fat rat", "a fat cat sat on a mat and ate a fat rat"]);
    TsqueryArrayValue tsqueryArrayValue = new(["fat & rat", "fat & rat"]);
    BitstringArrayValue bitstringArrayValue = new(["1110000111", "1110000111"]);
    VarbitstringArrayValue varbitstringArrayValue = new(["1101", "1101"]);
    PGBitArrayValue bitArrayValue = new([false, false]);
    RegClassArrayValue regclassArrayValue = new(["pg_type", "pg_type"]);
    RegConfigArrayValue regconfigArrayValue = new(["english", "english"]);
    RegDictionaryArrayValue regdictionaryArrayValue = new(["simple", "simple"]);
    RegNameSpaceArrayValue regnamespaceArrayValue = new(["pg_catalog", "pg_catalog"]);
    RegOperArrayValue regoperArrayValue = new(["!", "!"]);
    RegOperatorArrayValue regoperatorArrayValue = new(["*(integer,integer)", "*(integer,integer)"]);
    RegProcArrayValue regprocArrayValue = new(["now", "now"]);
    RegProcedureArrayValue regprocedureArrayValue = new(["sum(integer)", "sum(integer)"]);
    RegRoleArrayValue regroleArrayValue = new(["postgres", "postgres"]);
    RegTypeArrayValue regtypeArrayValue = new(["integer", "integer"]);
    xml xmlVal = xml `<foo><tag>bar</tag><tag>tag</tag></foo>`;
    PGXmlArrayValue xmlArrayValue = new([xmlVal, xmlVal]);
    int[] oidArrayValue = [1,2,3];

    sql:ParameterizedQuery sqlQuery =
        `INSERT INTO ArrayTypes4 (row_id, inet_array, cidr_array, macaddr_array, macaddr8_array, uuid_array, tsvector_array, tsquery_array,
         bitstring_array, varbitstring_array, bit_array, regclass_array, regconfig_array, regdictionary_array,
         regnamespace_array, regoper_array, regoperator_array, regproc_array, regprocedure_array, regrole_array, regtype_array,
          xml_array, oid_array)
         VALUES(${rowId}, ${inetArrayValue}, ${cidrArrayValue}, ${macaddrArrayValue}, ${macaddr8ArrayValue}, ${uuidArrayValue},
                 ${tsvectorArrayValue}, ${tsqueryArrayValue}, ${bitstringArrayValue}, ${varbitstringArrayValue},
                 ${bitArrayValue}, ${regclassArrayValue}, ${regconfigArrayValue},
                 ${regdictionaryArrayValue}, ${regnamespaceArrayValue}, ${regoperArrayValue}, ${regoperatorArrayValue}, ${regprocArrayValue},
                 ${regprocedureArrayValue}, ${regroleArrayValue}, ${regtypeArrayValue}, ${xmlArrayValue}, ${oidArrayValue})`;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute", "execute-params"],
    dependsOn: [testInsertIntoArrayDataTable11]
}
function testInsertIntoArrayDataTable13() returns error? {
    int rowId = 44;
    InetArrayValue inetArrayValue = new([null, null]);
    CidrArrayValue cidrArrayValue = new(<string?[]>[null, null]);
    MacAddrArrayValue macaddrArrayValue = new([null, null]);
    MacAddr8ArrayValue macaddr8ArrayValue = new([null, null]);
    UuidArrayValue uuidArrayValue = new([null, null]);
    TsvectorArrayValue tsvectorArrayValue = new([null, null]);
    TsqueryArrayValue tsqueryArrayValue = new([null, null]);
    BitstringArrayValue bitstringArrayValue = new([null, null]);
    VarbitstringArrayValue varbitstringArrayValue = new([null, null]);
    PGBitArrayValue bitArrayValue = new(<string?[]>[null, null]);
    RegClassArrayValue regclassArrayValue = new([null, null]);
    RegConfigArrayValue regconfigArrayValue = new([null, null]);
    RegDictionaryArrayValue regdictionaryArrayValue = new([null, null]);
    RegNameSpaceArrayValue regnamespaceArrayValue = new([null, null]);
    RegOperArrayValue regoperArrayValue = new([null, null]);
    RegOperatorArrayValue regoperatorArrayValue = new([null, null]);
    RegProcArrayValue regprocArrayValue = new([null, null]);
    RegProcedureArrayValue regprocedureArrayValue = new([null, null]);
    RegRoleArrayValue regroleArrayValue = new([null, null]);
    RegTypeArrayValue regtypeArrayValue = new([null, null]);
    PGXmlArrayValue xmlArrayValue = new(<string?[]>[null, null]);
    int[] oidArrayValue = [1,2,3];

    sql:ParameterizedQuery sqlQuery =
        `INSERT INTO ArrayTypes4 (row_id, inet_array, cidr_array, macaddr_array, macaddr8_array, uuid_array, tsvector_array, tsquery_array,
         bitstring_array, varbitstring_array, bit_array, regclass_array, regconfig_array, regdictionary_array,
         regnamespace_array, regoper_array, regoperator_array, regproc_array, regprocedure_array, regrole_array, regtype_array,
          xml_array, oid_array)
         VALUES(${rowId}, ${inetArrayValue}, ${cidrArrayValue}, ${macaddrArrayValue}, ${macaddr8ArrayValue}, ${uuidArrayValue},
                 ${tsvectorArrayValue}, ${tsqueryArrayValue}, ${bitstringArrayValue}, ${varbitstringArrayValue},
                 ${bitArrayValue}, ${regclassArrayValue}, ${regconfigArrayValue},
                 ${regdictionaryArrayValue}, ${regnamespaceArrayValue}, ${regoperArrayValue}, ${regoperatorArrayValue}, ${regprocArrayValue},
                 ${regprocedureArrayValue}, ${regroleArrayValue}, ${regtypeArrayValue}, ${xmlArrayValue}, ${oidArrayValue})`;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute", "execute-params"],
    dependsOn: [testInsertIntoArrayDataTable11]
}
function testInsertIntoArrayDataTable14() returns error? {
    int rowId = 45;
    JsonArrayValue jsonArrayValue = new([<json>{x: 1, "key": "value"}, <json>{x: 1, "key": "value"}]);
    JsonbArrayValue jsonbArrayValue = new([<json>{x: 1, "key": "value"}, <json>{x: 1, "key": "value"}]);
    string value =  ("$.\"floor\"[*].\"apt\"[*]?(@.\"area\" > 40 && @.\"area\" < 90)?(@.\"rooms\" > 1)");
    JsonPathArrayValue jsonpathArrayValue = new([value, value]);
    MoneyArrayValue moneyArrayValue = new([<decimal>11.21, <decimal>12.78]);
    PglsnArrayValue pglsnArrayValue = new(["16/B374D848", "16/B374D848"]);

    sql:ParameterizedQuery sqlQuery =
        `INSERT INTO ArrayTypes5 (row_id, json_array, jsonb_array, jsonpath_array, money_array, pglsn_array)
         VALUES(${rowId}, ${jsonArrayValue}, ${jsonbArrayValue}, ${jsonpathArrayValue}, ${moneyArrayValue}, ${pglsnArrayValue})`;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute", "execute-params"],
    dependsOn: [testInsertIntoArrayDataTable11]
}
function testInsertIntoArrayDataTable15() returns error? {
    int rowId = 46;
    JsonArrayValue jsonArrayValue = new(<string?[]>[null, null]);
    JsonbArrayValue jsonbArrayValue = new(<string?[]>[null, null]);
    JsonPathArrayValue jsonpathArrayValue = new([null, null]);
    MoneyArrayValue moneyArrayValue = new(<string?[]>[null, null]);
    PglsnArrayValue pglsnArrayValue = new([null, null]);

    sql:ParameterizedQuery sqlQuery =
        `INSERT INTO ArrayTypes5 (row_id, json_array, jsonb_array, jsonpath_array, money_array, pglsn_array)
         VALUES(${rowId}, ${jsonArrayValue}, ${jsonbArrayValue}, ${jsonpathArrayValue}, ${moneyArrayValue}, ${pglsnArrayValue})`;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoArrayDataTable3]
}
function testInsertIntoEnumDataTable() returns error? {
    int rowId = 43;
    Enum enumRecord = {value: "value1"};
    EnumValue enumValue = new (sqlTypeName = "value", value = enumRecord);

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO EnumTypes (row_id, value_type)
            VALUES(${rowId}, ${enumValue})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

@test:Config {
    groups: ["execute-params", "execute"],
    dependsOn: [testInsertIntoEnumDataTable]
}
function testInsertIntoEnumDataTable2() returns error? {
    int rowId = 44;
    EnumValue? enumValue = ();

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO EnumTypes (row_id, value_type)
            VALUES(${rowId}, ${enumValue})
    `;
    validateResult(check executeQueryPostgresqlClient(sqlQuery, executeParamsDatabase), 1, rowId);
}

function executeQueryPostgresqlClient(sql:ParameterizedQuery sqlQuery, string database) returns sql:ExecutionResult | error {
    Client dbClient = check new (host, user, password, database, port);
    sql:ExecutionResult result = check dbClient->execute(sqlQuery);
    check dbClient.close();
    return result;
}

isolated function validateResult(sql:ExecutionResult result, int rowCount, int? lastId = ()) {
    test:assertExactEquals(result.affectedRowCount, rowCount, "Affected row count is different.");

    if (lastId is ()) {
        test:assertEquals(result.lastInsertId, (), "Last Insert Id is not nil.");
    } else {
        int|string? lastInsertIdVal = result.lastInsertId;
        if (lastInsertIdVal is int) {
            test:assertTrue(lastInsertIdVal >= 1, "Last Insert Id is nil.");
        } else {
            test:assertFail("The last insert id should be an integer.");
        }
    }

}
