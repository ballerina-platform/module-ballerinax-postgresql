
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

@test:Config {
    groups: ["datatypes"]
}
function testInsertIntoNumericDataTable() {
    int rowId = 3;
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
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoNumericDataTable]
}
function testInsertIntoNumericDataTable2() {
    int rowId = 4;
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
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoNumericDataTable2]
}
function testInsertIntoNumericDataTable3() {
    int rowId = 5;
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
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoNumericDataTable3]
}
function testInsertIntoCharacterDataTable() {
    int rowId = 4;
    string charValue = "This is a char3";
    string varcharValue = "This is a varchar3";
    string textValue = "This is a text3";
    string nameValue = "This is a name3";

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO CharacterTypes (row_id, char_type, varchar_type, text_type, name_type)
            VALUES(${rowId}, ${charValue}, ${varcharValue}, ${textValue}, ${nameValue})
    `;
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoCharacterDataTable]
}
function testInsertIntoCharacterDataTable2() {
    int rowId = 5;
    sql:CharValue charValue = new ("This is a char3");
    sql:VarcharValue varcharValue = new ("This is a varchar3");
    sql:TextValue textValue = new ("This is a text3");
    string nameValue = "This is a name3";

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO CharacterTypes (row_id, char_type, varchar_type, text_type, name_type)
            VALUES(${rowId}, ${charValue}, ${varcharValue}, ${textValue}, ${nameValue})
    `;
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoCharacterDataTable2]
}
function testInsertIntoCharacterDataTable3() {
    int rowId = 6;
    sql:CharValue charValue = new ();
    sql:VarcharValue varcharValue = new ();
    sql:TextValue textValue = new ();
    string? nameValue = ();

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO CharacterTypes (row_id, char_type, varchar_type, text_type, name_type)
            VALUES(${rowId}, ${charValue}, ${varcharValue}, ${textValue}, ${nameValue})
    `;
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoCharacterDataTable3]
}
function testInsertIntoBooleanDataTable() {
    int rowId = 3;
    boolean booleanType = true;

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO BooleanTypes (row_id, boolean_type)
            VALUES(${rowId}, ${booleanType})
    `;
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoBooleanDataTable]
}
function testInsertIntoBooleanDataTable2() {
    int rowId = 4;
    boolean? booleanType = ();

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO BooleanTypes (row_id, boolean_type)
            VALUES(${rowId}, ${booleanType})
    `;
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoBooleanDataTable2]
}
function testInsertIntoNetworkDataTable() {
    int rowId = 4;
    InetValue inetValue = new ("192.168.0.1/24");
    CidrValue cidrValue = new ("::ffff:1.2.3.0/120");
    MacaddrValue macaddrValue = new ("08:00:2b:01:02:03");
    Macaddr8Value macaddr8Value = new ("08-00-2b-01-02-03-04-00");

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO NetworkTypes (row_id, inet_type, cidr_type, macaddr_type, macaddr8_type)
            VALUES(${rowId}, ${inetValue}, ${cidrValue}, ${macaddrValue}, ${macaddr8Value})
    `;
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoNetworkDataTable]
}
function testInsertIntoNetworkDataTable2() {
    int rowId = 5;
    InetValue inetValue = new ();
    CidrValue cidrValue = new ();
    MacaddrValue macaddrValue = new ();
    Macaddr8Value macaddr8Value = new ();

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO NetworkTypes (row_id, inet_type, cidr_type, macaddr_type, macaddr8_type)
            VALUES(${rowId}, ${inetValue}, ${cidrValue}, ${macaddrValue}, ${macaddr8Value})
    `;
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}


@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoNetworkDataTable2]
}
function testInsertIntoGeometricDataTable() {
    int rowId = 3;
    PointValue pointType = new ("(1,2)");
    LineValue lineType = new ("{1,2,3}");
    LsegValue lsegType = new ("(1,1),(2,2)");
    BoxValue boxType = new ("(1,1),(2,2)");
    // PathValue pathType = new ("[(1,1),(2,2)]");
    // PolygonValue polygonType = new ("[(1,1),(2,2)]");
    CircleValue circleType = new ("<(1,1),1>");

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO GeometricTypes (row_id, point_type, line_type, lseg_type, box_type, circle_type)
            VALUES(${rowId}, ${pointType}, ${lineType}, ${lsegType}, ${boxType},${circleType})
    `;
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoGeometricDataTable]
}
function testInsertIntoGeometricDataTable2() {
    int rowId = 5;
    PointValue pointType = new ({x: 2, y:2});
    LineValue lineType = new ({a:2, b:3, c:4});
    LsegValue lsegType = new ({x1: 2, x2: 3, y1: 2, y2:3});
    BoxValue boxType = new ({x1: 2, x2: 3, y1: 2, y2:3});
    // PathValue pathType = new ("[(1,1),(2,2)]");
    // PolygonValue polygonType = new ("[(1,1),(2,2)]");
    CircleValue circleType = new ({x: 2, y:2, r:2});

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO GeometricTypes (row_id, point_type, line_type, lseg_type, box_type, circle_type)
            VALUES(${rowId}, ${pointType}, ${lineType}, ${lsegType}, ${boxType},${circleType})
    `;
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoGeometricDataTable2]
}
function testInsertIntoGeometricDataTable3() {
    int rowId = 6;
    PointValue pointType = new ();
    LineValue lineType = new ();
    LsegValue lsegType = new ();
    BoxValue boxType = new ();
    // PathValue pathType = new ("[(1,1),(2,2)]");
    // PolygonValue polygonType = new ("[(1,1),(2,2)]");
    CircleValue circleType = new ();

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO GeometricTypes (row_id, point_type, line_type, lseg_type, box_type, circle_type)
            VALUES(${rowId}, ${pointType}, ${lineType}, ${lsegType}, ${boxType},${circleType})
    `;
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoGeometricDataTable3]
}
function testInsertIntoGeometricDataTable4() {
    int rowId = 7;
    PointRecordType point = {x: 2, y:2};
    LineRecordType line = {a: 2, b: 3, c: 4};
    LsegRecordType lseg = {x1: 2, x2: 3, y1: 2, y2: 3};
    BoxRecordType box = {x1: 2, x2: 3, y1: 2, y2: 3};
    CircleRecordType circle = {x: 2, y:2, r:2};

    PointValue pointType = new (point);
    LineValue lineType = new (line);
    LsegValue lsegType = new (lseg);
    BoxValue boxType = new (box);
    // PathValue pathType = new ("[(1,1),(2,2)]");
    // PolygonValue polygonType = new ("[(1,1),(2,2)]");
    CircleValue circleType = new (circle);

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO GeometricTypes (row_id, point_type, line_type, lseg_type, box_type, circle_type)
            VALUES(${rowId}, ${pointType}, ${lineType}, ${lsegType}, ${boxType},${circleType})
    `;
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoGeometricDataTable4]
}
function testInsertIntoGeometricDataTable5() {
    int rowId = 8;
    PointRecordType point = {x: 2, y:2};
    LineRecordType line = {x1: 2, x2: 3, y1: 2, y2: 3};
    LsegRecordType lseg = {x1: 2, x2: 3, y1: 2, y2: 3};
    BoxRecordType box = {x1: 2, x2: 3, y1: 2, y2: 3};
    CircleRecordType circle = {x: 2, y:2, r:2};

    PointValue pointType = new (point);
    LineValue lineType = new (line);
    LsegValue lsegType = new (lseg);
    BoxValue boxType = new (box);
    // PathValue pathType = new ("[(1,1),(2,2)]");
    // PolygonValue polygonType = new ("[(1,1),(2,2)]");
    CircleValue circleType = new (circle);

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO GeometricTypes (row_id, point_type, line_type, lseg_type, box_type, circle_type)
            VALUES(${rowId}, ${pointType}, ${lineType}, ${lsegType}, ${boxType},${circleType})
    `;
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoGeometricDataTable3]
}
function testInsertIntoUuidDataTable() {
    int rowId = 3;
    UuidValue uuidType = new ("a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11");

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO UuidTypes (row_id, uuid_type)
            VALUES(${rowId}, ${uuidType})
    `;
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoUuidDataTable]
}
function testInsertIntoUuidDataTable2() {
    int rowId = 4;
    UuidValue uuidType = new ();

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO UuidTypes (row_id, uuid_type)
            VALUES(${rowId}, ${uuidType})
    `;
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoUuidDataTable2]
}
function testInsertIntoTextSearchDataTable() {
    int rowId = 3;
    TsvectorValue tsvectorType = new ("a fat cat sat on a mat and ate a fat rat");
    TsqueryValue tsqueryType = new ("fat & rat");

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO TextSearchTypes (row_id, tsvector_type, tsquery_type)
            VALUES(${rowId}, ${tsvectorType}, ${tsqueryType})
    `;
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoTextSearchDataTable]
}
function testInsertIntoTextSearchDataTable2() {
    int rowId = 4;
    TsvectorValue tsvectorType = new ();
    TsqueryValue tsqueryType = new ();

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO TextSearchTypes (row_id, tsvector_type, tsquery_type)
            VALUES(${rowId}, ${tsvectorType}, ${tsqueryType})
    `;
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoTextSearchDataTable2]
}
function testInsertIntoJsonDataTable() {
    int rowId = 3;
    JsonValue jsonType = new("{\"a\":1,\"b\":\"Hello\"}");
    JsonbValue jsonbType = new("{\"a\":2,\"b\":\"Hello\"}");
    JsonpathValue jsonpathType = new("$.\"floor\"[*].\"apt\"[*]?(@.\"area\" > 40 && @.\"area\" < 90)?(@.\"rooms\" > 1)");
    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO JsonTypes (row_id, json_type, jsonb_type, jsonpath_type)
            VALUES(${rowId}, ${jsonType}, ${jsonbType}, ${jsonpathType})
    `;
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoJsonDataTable]
}
function testInsertIntoJsonDataTable2() {
    int rowId = 4;
    JsonValue jsonType = new();
    JsonbValue jsonbType = new();
    JsonpathValue jsonpathType = new();

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO JsonTypes (row_id, json_type, jsonb_type, jsonpath_type)
            VALUES(${rowId}, ${jsonType}, ${jsonbType}, ${jsonpathType})
    `;
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoJsonDataTable2]
}
function testInsertIntoJsonDataTable3() {
    int rowId = 5;
    json jsonValue = {"a":11,"b":2};
    JsonValue jsonType = new(jsonValue);
    JsonbValue jsonbType = new(jsonValue);
    JsonpathValue jsonpathType = new("$.\"floor\"[*].\"apt\"[*]?(@.\"area\" > 40 && @.\"area\" < 90)?(@.\"rooms\" > 10)");

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO JsonTypes (row_id, json_type, jsonb_type, jsonpath_type)
            VALUES(${rowId}, ${jsonType}, ${jsonbType}, ${jsonpathType})
    `;
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoJsonDataTable3]
}
function testInsertIntoDateDataTable() {
    time:Time|error timeValue = time:createTime(2017, 3, 28, 23, 42, 45,554, "Asia/Colombo");
    if (timeValue is time:Time) {
        int rowId = 3;
        sql:TimestampValue timestampType = new(timeValue);
        sql:TimestampValue timestamptzType = new(timeValue);
        sql:DateValue dateType = new(timeValue);
        sql:TimeValue timeType = new(timeValue);
        sql:TimeValue timetzType= new(timeValue);
        IntervalValue intervalType= new({years:1, months:2, days:3, hours:4, minutes:5, seconds:6});

        sql:ParameterizedQuery sqlQuery =
            `
            INSERT INTO DateTimeTypes (row_id, timestamp_type, timestamptz_type, date_type, time_type, timetz_type, interval_type)
                    VALUES(${rowId}, ${timestampType}, ${timestamptzType}, ${dateType}, ${timeType}, ${timetzType}, ${intervalType})
            `;
        validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
    }
    else {
        test:assertFail("Invalid Time value generated ");
    }
}


@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoDateDataTable]
}
function testInsertIntoDateDataTable2() {
    int rowId = 4;
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
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoDateDataTable2]
}
function testInsertIntoDateDataTable3() {
    int rowId = 5;
    IntervalValue intervalType= new("1 years 2 mons");

    sql:ParameterizedQuery sqlQuery =
            `
        INSERT INTO DateTimeTypes (row_id, interval_type)
                VALUES(${rowId}, ${intervalType})
        `;
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoDateDataTable3]
}
function testInsertIntoRangeDataTable() {

    time:Time|error startTime = time:createTime(2017, 3, 28, 23, 42, 45,554, "Asia/Colombo");
    time:Time|error endTime = time:createTime(2021, 6, 12, 11, 43, 55,324, "Asia/Colombo");
    if ((startTime is time:Time) && (endTime is time:Time)) {
    
        int rowId = 3;
        Int4rangeValue int4rangeType = new({upper:100 , lower:10 , isUpperboundInclusive: true, isLowerboundInclusive: false});
        Int8rangeValue int8rangeType = new({upper:123450 , lower:13245 , isUpperboundInclusive: false , isLowerboundInclusive: true});
        NumrangeValue numrangeType = new({upper: 12330.121, lower: 1229.12, isUpperboundInclusive: true, isLowerboundInclusive: true});
        TsrangeValue tsrangeType = new({upper:endTime , lower:startTime});
        TstzrangeValue tstzrangeType= new({upper:endTime , lower:startTime});
        DaterangeValue daterangeType= new({upper:endTime , lower:startTime , isUpperboundInclusive: true , isLowerboundInclusive: true});
        // TstzrangeValue tstzrangeType = new ();
        // DaterangeValue daterangeType = new ();

        sql:ParameterizedQuery sqlQuery =
            `
            INSERT INTO RangeTypes (row_id, int4range_type, int8range_type, numrange_type, tsrange_type, tstzrange_type, daterange_type)
                    VALUES(${rowId}, ${int4rangeType}, ${int8rangeType}, ${numrangeType}, ${tsrangeType}, ${tstzrangeType}, ${daterangeType})
            `;
        validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
    }
    else {
        test:assertFail("Invalid Time value generated ");
    }
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoRangeDataTable]
}
function testInsertIntoRangeDataTable2() {
    int rowId = 4;
    Int4rangeValue int4rangeType = new();
    Int8rangeValue int8rangeType = new();
    NumrangeValue numrangeType = new();
    TsrangeValue tsrangeType = new();
    TstzrangeValue tstzrangeType= new();
    DaterangeValue daterangeType = new();

         sql:ParameterizedQuery sqlQuery =
            `
            INSERT INTO RangeTypes (row_id, int4range_type, int8range_type, numrange_type, tsrange_type, tstzrange_type, daterange_type)
                    VALUES(${rowId}, ${int4rangeType}, ${int8rangeType}, ${numrangeType}, ${tsrangeType}, ${tstzrangeType}, ${daterangeType})
            `;
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoRangeDataTable2]
}
function testInsertIntoRangeDataTable3() {
    int rowId = 5;
    Int4rangeValue int4rangeType = new("(2,50)");
    Int8rangeValue int8rangeType = new("(10,100)");
    NumrangeValue numrangeType = new("(0.1,2.4)");
    TsrangeValue tsrangeType = new("(2010-01-01 14:30, 2010-01-01 15:30)");
    TstzrangeValue tstzrangeType= new("(2010-01-01 14:30, 2010-01-01 15:30)");
    DaterangeValue daterangeType= new("(2010-01-01 14:30, 2010-01-03 )");

    sql:ParameterizedQuery sqlQuery =
        `
        INSERT INTO RangeTypes (row_id, int4range_type, int8range_type, numrange_type, tsrange_type, tstzrange_type, daterange_type)
                VALUES(${rowId}, ${int4rangeType}, ${int8rangeType}, ${numrangeType}, ${tsrangeType}, ${tstzrangeType}, ${daterangeType})
        `;
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoRangeDataTable3]
}
function testInsertIntoRangeDataTable4() {

    time:Time|error startTime = time:createTime(2017, 3, 28, 23, 42, 45,554, "Asia/Colombo");
    time:Time|error endTime = time:createTime(2021, 6, 12, 11, 43, 55,324, "Asia/Colombo");
    if ((startTime is time:Time) && (endTime is time:Time)) {
    
        int rowId = 6;
        Int4rangeRecordType int4Range = {upper:100 , lower:10 , isUpperboundInclusive: true, isLowerboundInclusive: false};
        Int8rangeRecordType int8Range = {upper:123450 , lower:13245 , isUpperboundInclusive: false , isLowerboundInclusive: true};
        NumrangeRecordType numRange = {upper: 12330.121, lower: 1229.12, isUpperboundInclusive: true, isLowerboundInclusive: true};
        TsrangeRecordType tsRange = {upper:endTime , lower:startTime};
        TstzrangeRecordType tstzRange = {upper:endTime , lower:startTime};
        DaterangeRecordType dateRange = {upper:endTime , lower:startTime};

        Int4rangeValue int4rangeType = new(int4Range);
        Int8rangeValue int8rangeType = new(int8Range);
        NumrangeValue numrangeType = new(numRange);
        TsrangeValue tsrangeType = new(tsRange);
        TstzrangeValue tstzrangeType= new(tstzRange);
        DaterangeValue daterangeType= new(dateRange);

        sql:ParameterizedQuery sqlQuery =
            `
            INSERT INTO RangeTypes (row_id, int4range_type, int8range_type, numrange_type, tsrange_type, tstzrange_type, daterange_type)
                    VALUES(${rowId}, ${int4rangeType}, ${int8rangeType}, ${numrangeType}, ${tsrangeType}, ${tstzrangeType}, ${daterangeType})
            `;
        validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
    }
    else {
        test:assertFail("Invalid Time value generated ");
    }
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoRangeDataTable4]
}
function testInsertIntoRangeDataTable5() {

    time:Time|error startTime = time:createTime(2017, 3, 28, 23, 42, 45,554, "Asia/Colombo");
    time:Time|error endTime = time:createTime(2021, 6, 12, 11, 43, 55,324, "Asia/Colombo");
    if ((startTime is time:Time) && (endTime is time:Time)) {
    
        int rowId = 7;
        Int4rangeRecordType int4Range = {upper:100 , lower:10 , isUpperboundInclusive: true, isLowerboundInclusive: false};
        Int8rangeRecordType int8Range = {upper:123450 , lower:13245 , isUpperboundInclusive: false , isLowerboundInclusive: true};
        NumrangeRecordType numRange = {upper: 12330.121, lower: 1229.12, isUpperboundInclusive: true, isLowerboundInclusive: true};
        TsrangeRecordType tsRange = {upper:endTime , lower:startTime};
        TstzrangeRecordType tstzRange = {upper:endTime , lower:startTime};
        DaterangeRecordType dateRange = {upper:endTime , lower:startTime};

        Int4rangeValue int4rangeType = new(int4Range);
        Int8rangeValue int8rangeType = new(int8Range);
        NumrangeValue numrangeType = new(numRange);
        TsrangeValue tsrangeType = new(tsRange);
        TstzrangeValue tstzrangeType= new(tstzRange);
        DaterangeValue daterangeType= new(dateRange);
        // TstzrangeValue tstzrangeType = new ();
        // DaterangeValue daterangeType = new ();

        sql:ParameterizedQuery sqlQuery =
            `
            INSERT INTO RangeTypes (row_id, int4range_type, int8range_type, numrange_type, tsrange_type, tstzrange_type, daterange_type)
                    VALUES(${rowId}, ${int4rangeType}, ${int8rangeType}, ${numrangeType}, ${tsrangeType}, ${tstzrangeType}, ${daterangeType})
            `;
        validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
    }
    else {
        test:assertFail("Invalid Time value generated ");
    }
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoRangeDataTable5]
}
function testInsertIntoRangeDataTable6() {
        int rowId = 8;
        Int4rangeRecordType int4Range = {upper:100 , lower:10 , isUpperboundInclusive: true, isLowerboundInclusive: false};
        Int8rangeRecordType int8Range = {upper:123450 , lower:13245 , isUpperboundInclusive: false , isLowerboundInclusive: true};
        NumrangeRecordType numRange = {upper: 12330.121, lower: 1229.12, isUpperboundInclusive: true, isLowerboundInclusive: true};
        TsrangeRecordType tsRange = {lower:"2010-01-01 14:30" , upper:"2010-01-01 15:30"};
        TstzrangeRecordType tstzRange = {lower:"2010-01-01 14:30" , upper:"2010-01-01 15:30"};
        DaterangeRecordType dateRange = {lower:"2010-01-01" , upper:"2010-01-02"};

        Int4rangeValue int4rangeType = new(int4Range);
        Int8rangeValue int8rangeType = new(int8Range);
        NumrangeValue numrangeType = new(numRange);
        TsrangeValue tsrangeType = new(tsRange);
        TstzrangeValue tstzrangeType= new(tstzRange);
        DaterangeValue daterangeType= new(dateRange);

        sql:ParameterizedQuery sqlQuery =
            `
            INSERT INTO RangeTypes (row_id, int4range_type, int8range_type, numrange_type, tsrange_type, tstzrange_type, daterange_type)
                    VALUES(${rowId}, ${int4rangeType}, ${int8rangeType}, ${numrangeType}, ${tsrangeType}, ${tstzrangeType}, ${daterangeType})
            `;
        validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoRangeDataTable4]
}
function testInsertIntoBitDataTable() {
    int rowId = 3;
    BitstringValue bitstringType = new("1110001100");
    VarbitstringValue varbitstringType = new("11001");
    PGBitValue bitType = new("0");
    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO BitTypes (row_id, bitstring_type, varbitstring_type, bit_type)
            VALUES(${rowId}, ${bitstringType}, ${varbitstringType}, ${bitType})
    `;
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoBitDataTable]
}
function testInsertIntoBitDataTable2() {
    int rowId = 4;
    BitstringValue bitstringType = new();
    VarbitstringValue varbitstringType = new();
    PGBitValue bitType = new();

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO BitTypes (row_id, bitstring_type, varbitstring_type, bit_type)
            VALUES(${rowId}, ${bitstringType}, ${varbitstringType}, ${bitType})
    `;
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoBitDataTable2]
}
function testInsertIntoPglsnDataTable() {
    int rowId = 3;
    PglsnValue pglsnType = new ("16/B374D848");

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO PglsnTypes (row_id, pglsn_type)
            VALUES(${rowId}, ${pglsnType})
    `;
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoPglsnDataTable]
}
function testInsertIntoPglsnDataTable2() {
    int rowId = 4;
    PglsnValue pglsnType = new ();

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO PglsnTypes (row_id, pglsn_type)
            VALUES(${rowId}, ${pglsnType})
    `;
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

// public type MoneyRecord record {
//   int row_id;
//   string money_type;
// };

// @test:Config {
//     groups: ["datatypes"]
// }
// function testInsertIntoMoneyDataTable() {
//     int rowId = 3;
//     MoneyValue moneyType = new ("12.23");

//     sql:ParameterizedQuery initMoneyType = 
//     `
//         set lc_monetary to 'en_US.utf8';
//     `;

//     _ = executeQueryPostgresqlClient(initMoneyType, "execute_db");

//     sql:ParameterizedQuery sqlQuery =
//       `
//     INSERT INTO MoneyTypes (row_id, money_type)
//             VALUES(${rowId}, ${moneyType})
//     `;
//     validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
// }

// @test:Config {
//     groups: ["datatypes"],
//     dependsOn: [testInsertIntoMoneyDataTable]
// }
// function testInsertIntoMoneyDataTable2() {
//     int rowId = 4;
//     MoneyValue moneyType = new ();

//     sql:ParameterizedQuery sqlQuery =
//       `
//     INSERT INTO MoneyTypes (row_id, money_type)
//             VALUES(${rowId}, ${moneyType})
//     `;
//     validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
// }

// @test:Config {
//     groups: ["datatypes"],
//     dependsOn: [testInsertIntoMoneyDataTable2]
// }
// function testSelectFromMoneyDataTable() {
//     int rowId = 3;
    
//     sql:ParameterizedQuery sqlQuery = `select * from moneytypes where row_id = ${rowId}`;

//     _ = validateMoneyTableResult(simpleQueryPostgresqlClient(sqlQuery, MoneyRecord, database = "execute_db"));
// }

// public function validateMoneyTableResult(record{}? returnData) {
//     if (returnData is ()) {
//         test:assertFail("Empty row returned.");
//     } else {
//         test:assertEquals(returnData["row_id"], 3);
//         test:assertEquals(returnData["money_type"], "12.23");
//     } 
// }

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoPglsnDataTable2]
}
function testInsertIntoObjectidentifierDataTable() {
    int rowId = 3;
    int oidType = 12;
    RegclassValue regclassType = new("pg_type");
    RegconfigValue regconfigType = new("english");
    RegdictionaryValue regdictionaryType = new("simple");
    RegnamespaceValue regnamespaceType = new("pg_catalog");
    RegoperValue regoperType = new("!");
    RegoperatorValue regoperatorType = new("*(int,int)");
    RegprocValue regprocType = new("NOW");
    RegprocedureValue regprocedureType = new("sum(int4)");
    RegroleValue regroleType = new("postgres");
    RegtypeValue regtypeType = new("int");

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO ObjectidentifierTypes (row_id, oid_type, regclass_type, regconfig_type, regdictionary_type, 
    regnamespace_type, regoper_type, regoperator_type, regproc_type, regprocedure_type, regrole_type, regtype_type) 
            VALUES(${rowId}, ${oidType}, ${regclassType}, ${regconfigType}, ${regdictionaryType}, ${regnamespaceType},
            ${regoperType}, ${regoperatorType}, ${regprocType}, ${regprocedureType}, ${regroleType}, ${regtypeType})
    `;
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoObjectidentifierDataTable]
}
function testInsertIntoObjectidentifierDataTable2() {
    int rowId = 4;
    int? oidType = ();
    RegclassValue regclassType = new();
    RegconfigValue regconfigType = new();
    RegdictionaryValue regdictionaryType = new();
    RegnamespaceValue regnamespaceType = new();
    RegoperValue regoperType = new();
    RegoperatorValue regoperatorType = new();
    RegprocValue regprocType = new();
    RegprocedureValue regprocedureType = new();
    RegroleValue regroleType = new();
    RegtypeValue regtypeType = new();

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO ObjectidentifierTypes (row_id, oid_type, regclass_type, regconfig_type, regdictionary_type, 
    regnamespace_type, regoper_type, regoperator_type, regproc_type, regprocedure_type, regrole_type, regtype_type) 
            VALUES(${rowId}, ${oidType}, ${regclassType}, ${regconfigType}, ${regdictionaryType}, ${regnamespaceType},
            ${regoperType}, ${regoperatorType}, ${regprocType}, ${regprocedureType}, ${regroleType}, ${regtypeType})
    `;
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

public type XmlRecord record {
  int row_id;
  xml xml_type;
};

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoObjectidentifierDataTable2]
}
function testInsertIntoXmlDataTable() {
    int rowId = 3;
    // XmlValue xmlType = new ("16/B374D848");
    xml xmlType = xml `<foo>Value</foo>`;

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO XmlTypes (row_id, xml_type)
            VALUES(${rowId}, ${xmlType})
    `;
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

@test:Config {
    groups: ["datatypes"],
    dependsOn: [testInsertIntoXmlDataTable]
}
function testInsertIntoXmlDataTable2() {
    int rowId = 4;
    // XmlValue xmlType = new ();
    xml? xmlType = ();

    sql:ParameterizedQuery sqlQuery =
      `
    INSERT INTO XmlTypes (row_id, xml_type)
            VALUES(${rowId}, ${xmlType})
    `;
    validateResult(executeQueryPostgresqlClient(sqlQuery, "execute_db"), 1, rowId);
}

// @test:Config {
//     groups: ["datatypes"],
//     dependsOn: [testInsertIntoXmlDataTable]
// }
// function testSelectFromXmlDataTable() {
//     int rowId = 3;
    
//     sql:ParameterizedQuery sqlQuery = `select * from Xmltypes where row_id = ${rowId}`;

//     _ = validateXmlTableResult(simpleQueryPostgresqlClient(sqlQuery, XmlRecord, database = "execute_db"));
// }

public function validateXmlTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 3);
        test:assertEquals(returnData["xml_type"], xml `<foo>Test</foo>`);
    } 
}

function executeQueryPostgresqlClient(sql:ParameterizedQuery sqlQuery, string database) returns sql:ExecutionResult {
    Client dbClient = checkpanic new (host, user, password, database, port);
    sql:ExecutionResult result = checkpanic dbClient->execute(sqlQuery);
    checkpanic dbClient.close();
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
