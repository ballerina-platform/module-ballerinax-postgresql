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

type XML xml;
type IntArray int[];
type StringArray string[];
type BooleanArray boolean[];
type FloatArray float[];
type DecimalArray decimal[];
type ByteArray byte[][];
type CivilArray time:Civil[];
type TimeOfDayArray time:TimeOfDay[];
type UtcArray time:Utc[];
type DateArray time:Date[];
type PointArray Point[];
type LineArray Line[];
type LineSegmentArray LineSegment[];
type PathArray Path[];
type PolygonArray Polygon[];
type CircleArray Circle[];
type IntervalArray Interval[];
type IntegerRangeArray IntegerRange[];
type LongRangeArray LongRange[];
type NumericalRangeArray NumericRange[];
type TsTzRangeArray TimestamptzRange[];
type TsRangeArray TimestampRange[];
type DateRangeArray DateRange[];

public type StringDataForCall record {
    string char_type;
    string varchar_type;
    string text_type;
    string name_type;
};

@test:Config {
    groups: ["procedures"]
}
function testProcedureQueryWithSingleData() returns error? {
    int row_id = 1;
    sql:ParameterizedCallQuery callQuery = `
        select * from singleSelectProcedure(${row_id});
    `;

    sql:ProcedureCallResult ret = check callProcedure(callQuery, proceduresDatabase, [StringDataForCall]);
    stream<record {}, sql:Error?>? qResult = ret.queryResult;
    if qResult is () {
        test:assertFail("Empty result set returned.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? value = data?.value;
        StringDataForCall expectedDataRow = {
            char_type: "This is a char1",
            varchar_type: "This is a varchar1",
            text_type: "This is a text1",
            name_type: "This is a name1"
        };
        test:assertEquals(value, expectedDataRow, "Call procedure insert and query did not match.");
        check qResult.close();
        check ret.close();
    }
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testProcedureQueryWithSingleData]
}
function testProcedureQueryWithMultipleData() returns error? {
    sql:ParameterizedCallQuery callQuery = `
        select * from multipleSelectProcedure();
    `;
    sql:ProcedureCallResult ret = check callProcedure(callQuery, proceduresDatabase, [StringDataForCall, StringDataForCall]);

    stream<record {}, sql:Error?>? qResult = ret.queryResult;
    if qResult is () {
        test:assertFail("First result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result1 = data?.value;
        StringDataForCall expectedDataRow = {
            char_type: "This is a char1",
            varchar_type: "This is a varchar1",
            text_type: "This is a text1",
            name_type: "This is a name1"
        };
        test:assertEquals(result1, expectedDataRow, "Call procedure first select did not match.");
    }

    qResult = ret.queryResult;
    if qResult is () {
        test:assertFail("Second result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result2 = data?.value;
        StringDataForCall expectedDataRow2 = {
            char_type: "This is a char2",
            varchar_type: "This is a varchar2",
            text_type: "This is a text2",
            name_type: "This is a name2"
        };
        test:assertEquals(result2, expectedDataRow2, "Call procedure second select did not match.");
        check qResult.close();
        check ret.close();
    }
}

public type StringData record {
    int row_id;
    string char_type;
    string varchar_type;
    string text_type;
    string name_type;
};

@test:Config {
    groups: ["procedures"],
    dependsOn: [testProcedureQueryWithMultipleData]
}
function testProcedureQueryWithMultipleSelectData() returns error? {
    sql:ParameterizedCallQuery callQuery = `
        select * from multipleQuerySelectProcedure();
    `;
    sql:ProcedureCallResult ret = check callProcedure(callQuery, proceduresDatabase, [StringData, StringData]);

    stream<record {}, sql:Error?>? qResult = ret.queryResult;
    if qResult is () {
        test:assertFail("First result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result1 = data?.value;
        StringData expectedDataRow = {
            row_id: 1,
            char_type: "This is a char1",
            varchar_type: "This is a varchar1",
            text_type: "This is a text1",
            name_type: "This is a name1"
        };
        test:assertEquals(result1, expectedDataRow, "Call procedure first select did not match.");
    }
    if qResult is () {
        test:assertFail("Second result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result2 = data?.value;
        StringData expectedDataRow2 = {
            row_id: 2,
            char_type: "This is a char2",
            varchar_type: "This is a varchar2",
            text_type: "This is a text2",
            name_type: "This is a name2"
        };
        test:assertEquals(result2, expectedDataRow2, "Call procedure second select did not match.");
        check qResult.close();
        check ret.close();
    }
}

public type NumericProcedureRecord record {
    int row_id;
    int smallint_type;
    int int_type;
    int bigint_type;
    decimal decimal_type;
    decimal numeric_type;
};

@test:Config {
    groups: ["procedures"],
    dependsOn: [testProcedureQueryWithMultipleSelectData]
}
function testNumericProcedureCall() returns error? {
    int rowId = 35;
    sql:SmallIntValue smallintType = new (1);
    sql:IntegerValue intType = new (1);
    int bigintType = 123456;
    sql:DecimalValue decimalType = new (1234.567);
    decimal numericType = 1234.567;
    sql:RealValue realType = new (123.456);
    sql:DoubleValue doubleType = new (123.456);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call NumericProcedure(${rowId}, ${smallintType}, ${intType}, ${bigintType}, ${decimalType},
                                ${numericType}, ${realType}, ${doubleType});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    sql:ParameterizedQuery query = `SELECT row_id, smallint_type, int_type, bigint_type, decimal_type,
        numeric_type
        from NumericTypes2 where row_id = ${rowId}`;

    NumericProcedureRecord expectedDataRow = {
        row_id: rowId,
        smallint_type: 1,
        int_type: 1,
        bigint_type: 123456,
        decimal_type: 1234.567,
        numeric_type: 1234.567
    };
    test:assertEquals(check queryProcedureClient(query, proceduresDatabase, NumericProcedureRecord), expectedDataRow, "Numeric Call procedure insert and query did not match.");

}

public type CharacterProcedureRecord record {
    int row_id;
    string char_type;
    string varchar_type;
    string text_type;
    string name_type;
};

@test:Config {
    groups: ["procedures"],
    dependsOn: [testNumericProcedureCall]
}
function testCharacterProcedureCall() returns error? {
    int rowId = 35;
    sql:CharValue charValue = new ("This is a char3");
    sql:VarcharValue varcharValue = new ("This is a varchar3");
    string textValue = "This is a text3";
    string nameValue = "This is a name3";

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call CharacterProcedure(${rowId}, ${charValue}, ${varcharValue}, ${textValue}, ${nameValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    sql:ParameterizedQuery query = `SELECT row_id, char_type, varchar_type, text_type, name_type from CharacterTypes where row_id = ${rowId}`;

    CharacterProcedureRecord expectedDataRow = {
        row_id: rowId,
        char_type: "This is a char3",
        varchar_type: "This is a varchar3",
        text_type: "This is a text3",
        name_type: "This is a name3"
    };
    test:assertEquals(check queryProcedureClient(query, proceduresDatabase, CharacterProcedureRecord), expectedDataRow, "Character Call procedure insert and query did not match.");
}

public type BooleanProcedureRecord record {
    int row_id;
    boolean boolean_type;
};

@test:Config {
    groups: ["procedures"],
    dependsOn: [testCharacterProcedureCall]
}
function testBooleanProcedureCall() returns error? {
    int rowId = 35;
    boolean booleanType = false;

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call BooleanProcedure(${rowId}, ${booleanType});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    sql:ParameterizedQuery query = `SELECT row_id, boolean_type from BooleanTypes where row_id = ${rowId}`;

    BooleanProcedureRecord expectedDataRow = {
        row_id: rowId,
        boolean_type: false
    };
    test:assertEquals(check queryProcedureClient(query, proceduresDatabase, BooleanProcedureRecord), expectedDataRow, "Boolean Call procedure insert and query did not match.");
}

public type NetworkProcedureRecord record {
    int row_id;
    string inet_type;
    string cidr_type;
    string macaddr_type;
    string macaddr8_type;
};

@test:Config {
    groups: ["procedures"],
    dependsOn: [testBooleanProcedureCall]
}
function testNetworkProcedureCall() returns error? {
    int rowId = 35;
    InetValue inetValue = new ("192.168.0.2/24");
    CidrValue cidrValue = new ("::ffff:1.2.3.0/120");
    MacAddrValue macaddrValue = new ("08:00:2b:01:02:03");
    MacAddr8Value macaddr8Value = new ("08-00-2b-01-02-03-04-00");

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call NetworkProcedure(${rowId}, ${inetValue}, ${cidrValue}, ${macaddrValue}, ${macaddr8Value});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    sql:ParameterizedQuery query = `SELECT row_id, inet_type, cidr_type, macaddr_type, macaddr8_type from NetworkTypes where row_id = ${rowId}`;

    NetworkProcedureRecord expectedDataRow = {
        row_id: rowId,
        inet_type: "192.168.0.2/24",
        cidr_type: "::ffff:1.2.3.0/120",
        macaddr_type: "08:00:2b:01:02:03",
        macaddr8_type: "08:00:2b:01:02:03:04:00"
    };
    test:assertEquals(check queryProcedureClient(query, proceduresDatabase, NetworkProcedureRecord), expectedDataRow, "Network Call procedure insert and query did not match.");
}

public type GeometricProcedureRecord record {
    int row_id;
    string point_type;
    string line_type;
    string lseg_type;
    string box_type;
    string circle_type;
    string? path_type;
    string? polygon_type;
};

@test:Config {
    groups: ["procedures"],
    dependsOn: [testNetworkProcedureCall]
}
function testGeometricProcedureCall() returns error? {
    int rowId = 35;
    PointValue pointType = new ({x: 2, y: 2});
    LineValue lineType = new ({a: 2, b: 3, c: 4});
    LineSegmentValue lsegType = new ({x1: 2, x2: 3, y1: 2, y2: 3});
    BoxValue boxType = new ({x1: 2, x2: 3, y1: 2, y2: 3});
    PathValue pathType = new ({open: true, points: [{x: 1, y: 1}, {x: 2, y: 2}]});
    PolygonValue polygonType = new ([{x: 1, y: 1}, {x: 2, y: 2}]);
    CircleValue circleType = new ({x: 2, y: 2, r: 2});

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call GeometricProcedure(${rowId}, ${pointType}, ${lineType}, ${lsegType}, ${boxType}, ${pathType}, ${polygonType}, ${circleType});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    sql:ParameterizedQuery query = `SELECT row_id, point_type, line_type, lseg_type, box_type, path_type, polygon_type, circle_type from GeometricTypes where row_id = ${rowId}`;

    GeometricProcedureRecord expectedDataRow = {
        row_id: rowId,
        point_type: "(2,2)",
        line_type: "{2,3,4}",
        lseg_type: "[(2,2),(3,3)]",
        box_type: "(3,3),(2,2)",
        path_type: "[(1,1),(2,2)]",
        polygon_type: "((1,1),(2,2))",
        circle_type: "<(2,2),2>"
    };
    test:assertEquals(check queryProcedureClient(query, proceduresDatabase, GeometricProcedureRecord), expectedDataRow, "Geometric Call procedure insert and query did not match.");
}

public type UuidProcedureRecord record {
    int row_id;
    string uuid_type;
};

@test:Config {
    groups: ["procedures"],
    dependsOn: [testGeometricProcedureCall]
}
function testUuidProcedureCall() returns error? {
    int rowId = 35;
    UuidValue uuidType = new ("a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12");

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call UuidProcedure(${rowId}, ${uuidType});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    sql:ParameterizedQuery query = `SELECT row_id, uuid_type from UuidTypes where row_id = ${rowId}`;

    UuidProcedureRecord expectedDataRow = {
        row_id: rowId,
        uuid_type: "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12"
    };
    test:assertEquals(check queryProcedureClient(query, proceduresDatabase, UuidProcedureRecord), expectedDataRow, "Uuid Call procedure insert and query did not match.");
}

public type PglsnProcedureRecord record {
    int row_id;
    string pglsn_type;
};

@test:Config {
    groups: ["procedures"],
    dependsOn: [testUuidProcedureCall]
}
function testPglsnProcedureCall() returns error? {
    int rowId = 35;
    PglsnValue pglsnType = new ("16/B374D848");

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call PglsnProcedure(${rowId}, ${pglsnType});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    sql:ParameterizedQuery query = `SELECT row_id, pglsn_type from PglsnTypes where row_id = ${rowId}`;

    PglsnProcedureRecord expectedDataRow = {
        row_id: rowId,
        pglsn_type: "16/B374D848"
    };
    test:assertEquals(check queryProcedureClient(query, proceduresDatabase, PglsnProcedureRecord), expectedDataRow, "Pglsn Call procedure insert and query did not match.");
}

public type JsonProcedureRecord record {
    int row_id;
    json json_type;
    json jsonb_type;
    string jsonpath_type;
};

@test:Config {
    groups: ["procedures"],
    dependsOn: [testPglsnProcedureCall]
}
function testJsonProcedureCall() returns error? {
    int rowId = 35;
    json jsonValue = {"a": 11, "b": 2};
    JsonValue jsonType = new (jsonValue);
    JsonBinaryValue jsonbType = new (jsonValue);
    JsonPathValue jsonpathType = new ("$.\"floor\"[*].\"apt\"[*]?(@.\"area\" > 40 && @.\"area\" < 90)?(@.\"rooms\" > 10)");

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call JsonProcedure(${rowId}, ${jsonType}, ${jsonbType}, ${jsonpathType});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    sql:ParameterizedQuery query = `SELECT row_id, json_type, jsonb_type, jsonpath_type from JsonTypes where row_id = ${rowId}`;

    JsonProcedureRecord expectedDataRow = {
        row_id: rowId,
        json_type: jsonValue,
        jsonb_type: jsonValue,
        jsonpath_type: "$.\"floor\"[*].\"apt\"[*]?(@.\"area\" > 40 && @.\"area\" < 90)?(@.\"rooms\" > 10)"
    };
    test:assertEquals(check queryProcedureClient(query, proceduresDatabase, JsonProcedureRecord), expectedDataRow, "Json Call procedure insert and query did not match.");
}

public type BitProcedureRecord record {
    int row_id;
    string varbitstring_type;
    boolean bit_type;
};

@test:Config {
    groups: ["procedures"],
    dependsOn: [testJsonProcedureCall]
}
function testBitProcedureCall() returns error? {
    int rowId = 35;
    VarBitStringValue varbitstringType = new ("111110");
    PGBitValue bitType = new ("1");

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call BitProcedure(${rowId}, ${varbitstringType}, ${bitType});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    sql:ParameterizedQuery query = `SELECT row_id, varbitstring_type, bit_type from BitTypes where row_id = ${rowId}`;

    BitProcedureRecord expectedDataRow = {
        row_id: rowId,
        varbitstring_type: "111110",
        bit_type: true
    };
    test:assertEquals(check queryProcedureClient(query, proceduresDatabase, BitProcedureRecord), expectedDataRow, "Bit Call procedure insert and query did not match.");
}

public type DatetimeProcedureRecord record {
    int row_id;
    string date_type;
    string time_type;
    string timestamp_type;
    string interval_type;
};

@test:Config {
    groups: ["procedures"],
    dependsOn: [testBitProcedureCall]
}
function testDatetimeProcedureCall() returns error? {

    int rowId = 35;
    time:Date date = {year: 2017, month: 12, day: 18};
    time:TimeOfDay time = {hour: 23, minute: 12, second: 18};
    time:Utc timestamp = [100000, 0.5];
    sql:TimestampValue timestampType = new (timestamp);
    sql:TimestampValue timestamptzType = new (timestamp);
    sql:DateValue dateType = new (date);
    sql:TimeValue timeType = new (time);
    sql:TimeValue timetzType = new (time);
    IntervalValue intervalType = new ({years: 1, months: 2, days: 3, hours: 4, minutes: 5, seconds: 6});

    sql:ParameterizedCallQuery sqlQuery = 
    `
    call DatetimeProcedure(${rowId}, ${dateType}, ${timeType}, ${timetzType}, ${timestampType}, ${timestamptzType}, ${intervalType});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    sql:ParameterizedQuery query = `SELECT row_id, date_type, time_type, timestamp_type,
         interval_type from DatetimeTypes where row_id = ${rowId}`;

    DatetimeProcedureRecord expectedDataRow = {
        row_id: rowId,
        date_type: "2017-12-18",
        time_type: "23:12:18",
        timestamp_type: "1970-01-02 03:46:40.5",
        interval_type: "1 year 2 mons 3 days 04:05:06"
    };
    test:assertEquals(check queryProcedureClient(query, proceduresDatabase, DatetimeProcedureRecord), expectedDataRow, "Datetime Call procedure insert and query did not match.");
}

public type RangeProcedureRecord record {
    int row_id;
    string int4range_type;
    string int8range_type;
    string numrange_type;
    string tsrange_type;
    string daterange_type;
};

@test:Config {
    groups: ["procedures"],
    dependsOn: [testDatetimeProcedureCall]
}
function testRangeProcedureCall() returns error? {

    int rowId = 35;
    IntegerRangeValue int4rangeType = new ("(2,50)");
    LongRangeValue int8rangeType = new ("(10,100)");
    NumericRangeValue numrangeType = new ("(0.1,2.4)");
    TsRangeValue tsrangeType = new ("(2010-01-01 14:30, 2010-01-01 15:30)");
    TsTzRangeValue tstzrangeType = new ("(2010-01-01 14:30, 2010-01-01 15:30)");
    DateRangeValue daterangeType = new ("(2010-01-01 14:30, 2010-01-03 )");

    sql:ParameterizedCallQuery sqlQuery = 
        `
        call RangeProcedure(${rowId}, ${int4rangeType}, ${int8rangeType}, ${numrangeType}, ${tsrangeType}, ${tstzrangeType}, ${daterangeType});
        `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    sql:ParameterizedQuery query = `SELECT row_id, int4range_type, int8range_type, numrange_type, tsrange_type,
             daterange_type from RangeTypes where row_id = ${rowId}`;

    RangeProcedureRecord expectedDataRow = {
        row_id: rowId,
        int4range_type: "[3,50)",
        int8range_type: "[11,100)",
        numrange_type: "(0.1,2.4)",
        tsrange_type: "(\"2010-01-01 14:30:00\",\"2010-01-01 15:30:00\")",
        daterange_type: "[2010-01-02,2010-01-03)"
    };
    test:assertEquals(check queryProcedureClient(query, proceduresDatabase, RangeProcedureRecord), expectedDataRow, "Range Call procedure insert and query did not match.");
}

public type TextsearchProcedureRecord record {
    int row_id;
    string tsvector_type;
    string tsquery_type;
};

@test:Config {
    groups: ["procedures"],
    dependsOn: [testRangeProcedureCall]
}
function testTextsearchProcedureCall() returns error? {
    int rowId = 35;
    TsVectorValue tsvectorType = new ("a fat cat sat on a mat and ate a fat rat");
    TsQueryValue tsqueryType = new ("fat & rat");

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call TextsearchProcedure(${rowId}, ${tsvectorType}, ${tsqueryType});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    sql:ParameterizedQuery query = `SELECT row_id, tsvector_type, tsquery_type from TextsearchTypes where row_id = ${rowId}`;

    TextsearchProcedureRecord expectedDataRow = {
        row_id: rowId,
        tsvector_type: "'a' 'and' 'ate' 'cat' 'fat' 'mat' 'on' 'rat' 'sat'",
        tsquery_type: "'fat' & 'rat'"
    };
    test:assertEquals(check queryProcedureClient(query, proceduresDatabase, TextsearchProcedureRecord), expectedDataRow, "Textsearch Call procedure insert and query did not match.");
}

public type ObjectidentifierProcedureRecord record {
    int row_id;
    string oid_type;
    string regclass_type;
    string regconfig_type;
    string regdictionary_type;
    string regnamespace_type;
    string regoper_type;
    string regoperator_type;
    string regproc_type;
    string regprocedure_type;
    string regrole_type;
    string regtype_type;
};

@test:Config {
    groups: ["procedures"],
    dependsOn: [testTextsearchProcedureCall]
}
function testObjectidentifierProcedureCall() returns error? {
    int rowId = 35;
    int oidType = 12;
    RegClassValue regclassType = new ("pg_type");
    RegConfigValue regconfigType = new ("english");
    RegDictionaryValue regdictionaryType = new ("simple");
    RegNamespaceValue regnamespaceType = new ("pg_catalog");
    RegOperValue regoperType = new ("||/");
    RegOperatorValue regoperatorType = new ("*(int,int)");
    RegProcValue regprocType = new ("NOW");
    RegProcedureValue regprocedureType = new ("sum(int4)");
    RegRoleValue regroleType = new ("postgres");
    RegTypeValue regtypeType = new ("int");

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call ObjectidentifierProcedure(${rowId}, ${oidType}, ${regclassType}, ${regconfigType}, ${regdictionaryType},
                                ${regnamespaceType}, ${regoperType}, ${regoperatorType}, ${regprocType}, ${regprocedureType},
                                 ${regroleType}, ${regtypeType});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    sql:ParameterizedQuery query = `SELECT row_id, oid_type, regclass_type, regconfig_type, regdictionary_type,
        regnamespace_type, regoper_type, regoperator_type, regproc_type, regprocedure_type, regrole_type, regtype_type
        from ObjectidentifierTypes where row_id = ${rowId}`;

    ObjectidentifierProcedureRecord expectedDataRow = {
        row_id: rowId,
        oid_type: "12",
        regclass_type: "pg_type",
        regconfig_type: "english",
        regdictionary_type: "simple",
        regnamespace_type: "pg_catalog",
        regoper_type: "||/",
        regoperator_type: "*(integer,integer)",
        regproc_type: "now",
        regprocedure_type: "sum(integer)",
        regrole_type: "postgres",
        regtype_type: "integer"
    };
    test:assertEquals(check queryProcedureClient(query, proceduresDatabase, ObjectidentifierProcedureRecord), expectedDataRow, "Objectidentifier Call procedure insert and query did not match.");
}

public type BinaryProcedureRecord record {
    int row_id;
    byte[] bytea_type;
    byte[] bytea_escape_type;
};

@test:Config {
    groups: ["procedures"],
    dependsOn: [testRangeProcedureCall]
}
function testBinaryProcedureCall() returns error? {
    int rowId = 35;
    byte[] byteArray = [1, 2, 3, 4];
    sql:BinaryValue byteaType = new (byteArray);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call BinaryProcedure(${rowId}, ${byteaType}, ${byteArray});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    sql:ParameterizedQuery query = `SELECT row_id, bytea_type, bytea_escape_type from BinaryTypes where row_id = ${rowId}`;

    BinaryProcedureRecord expectedDataRow = {
        row_id: rowId,
        bytea_type: [1, 2, 3, 4],
        bytea_escape_type: [1, 2, 3, 4]
    };
    test:assertEquals(check queryProcedureClient(query, proceduresDatabase, BinaryProcedureRecord), expectedDataRow, "Binary Call procedure insert and query did not match.");
}

public type XmlProcedureRecord record {
    int row_id;
    xml xml_type;
};

@test:Config {
    groups: ["procedures"],
    dependsOn: [testObjectidentifierProcedureCall]
}
function testXmlProcedureCall() returns error? {
    int rowId = 35;
    xml xmlValue = xml `<tag1>This is tag1<tag2>This is tag 2</tag2></tag1>`;
    PGXmlValue xmlType = new (xmlValue);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call XmlProcedure(${rowId}, ${xmlType});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    sql:ParameterizedQuery query = `SELECT row_id, xml_type from XmlTypes where row_id = ${rowId}`;

    XmlProcedureRecord expectedDataRow = {
        row_id: rowId,
        xml_type: xmlValue
    };
    test:assertEquals(check queryProcedureClient(query, proceduresDatabase, XmlProcedureRecord), expectedDataRow, "Xml Call procedure insert and query did not match.");
}

public type MoneyProcedureRecord record {
    int row_id;
    string money_type;
};

@test:Config {
    groups: ["procedures"],
    dependsOn: [testXmlProcedureCall]
}
function testMoneyProcedureCall() returns error? {
    int rowId = 35;
    decimal moneyValue = 124.56;
    MoneyValue moneyType = new (moneyValue);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call MoneyProcedure(${rowId}, ${moneyType});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    sql:ParameterizedQuery query = `SELECT row_id, money_type from MoneyTypes where row_id = ${rowId}`;

    MoneyProcedureRecord expectedDataRow = {
        row_id: rowId,
        money_type: "124.56"
    };
    test:assertEquals(check queryProcedureClient(query, proceduresDatabase, MoneyProcedureRecord), expectedDataRow, "Money Call procedure insert and query did not match.");
}

public type ArrayProcedureRecord record {
    int row_id;
    int[]? bigintarray_type;
    decimal[]? numericarray_type;
    string[]? varchararray_type;
    string[]? textarray_type;
    boolean[]? booleanarray_type;
};

@test:Config {
    groups: ["procedures"],
    dependsOn: [testTextsearchProcedureCall]
}
function testArrayProcedureCall() returns error? {
    int rowId = 35;
    int[]? bigintarrayType = [111, 111, 111];
    decimal[]? numericarrayType = [11.11, 11.11];
    string[]? varchararrayType = ["This is varchar", "This is varchar"];
    string[]? textarrayType = ["This is text123", "This is text123"];
    boolean[]? booleanarrayType = [true, false, true];
    byte[][]? byteaarrayType = [[1, 2, 3], [11, 5, 7]];

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call ArrayProcedure(${rowId}, ${bigintarrayType},
            ${numericarrayType}, ${varchararrayType}, ${textarrayType}, ${booleanarrayType}, ${byteaarrayType});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    sql:ParameterizedQuery query = `select row_id, bigintarray_type,
            numericarray_type, varchararray_type,
           textarray_type, booleanarray_type
        from ArrayTypes where row_id = ${rowId}`;

    ArrayProcedureRecord expectedDataRow = {
        row_id: rowId,
        bigintarray_type: bigintarrayType,
        numericarray_type: numericarrayType,
        varchararray_type: varchararrayType,
        textarray_type: textarrayType,
        booleanarray_type: booleanarrayType
    };
    test:assertEquals(check queryProcedureClient(query, proceduresDatabase, ArrayProcedureRecord), expectedDataRow, "Array Call procedure insert and query did not match.");
}

public type ArrayProcedureRecord2 record {
    int row_id;
    int?[]? smallint_array;
    int?[]? int_array;
    int?[]? bigint_array;
    decimal?[]? numeric_array;
    string?[]? varchar_array;
    string?[]? string_array;
    boolean?[]? boolean_array;
};

@test:Config {
    groups: ["procedures"],
    dependsOn: [testArrayProcedureCall]
}
function testArrayProcedureCall2() returns error? {
    int rowId = 35;
    float float1 = 122.43;
    float float2 = 212.456;
    sql:SmallIntArrayValue smallintArrayValue = new ([1211, 478]);
    sql:IntegerArrayValue intArrayValue = new ([121, 498]);
    sql:BigIntArrayValue bigintArrayValue = new ([121, 498]);
    sql:DoubleArrayValue doubleArrayValue = new ([float1, float2]);
    sql:RealArrayValue realArrayValue = new ([float1, float2]);
    sql:DecimalArrayValue decimalArrayValue = new ([<decimal>12.245, <decimal>13.245]);
    sql:NumericArrayValue numericArrayValue = new ([float1, float2]);
    sql:VarcharArrayValue varcharArrayValue = new (["Varchar value", "Varying Char"]);
    string[] stringArrayValue = ["Hello", "Ballerina"];
    sql:BooleanArrayValue booleanArrayValue = new ([true, false, true]);
    sql:DateArrayValue dateArrayValue = new (["2021-12-18", "2021-12-19"]);
    time:TimeOfDay time = {hour: 20, minute: 8, second: 12};
    sql:TimeArrayValue timeArrayValue = new ([time, time]);
    time:Civil datetime = {year: 2021, month: 12, day: 18, hour: 20, minute: 8, second: 12};
    sql:DateTimeArrayValue timestampArrayValue = new ([datetime, datetime]);
    byte[] byteArray1 = [1, 2, 3];
    byte[] byteArray2 = [4, 5, 6];
    sql:BinaryArrayValue binaryArrayValue = new ([byteArray1, byteArray2]);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call ArrayProcedure2(${rowId}, ${smallintArrayValue}, ${intArrayValue}, ${bigintArrayValue}, ${decimalArrayValue}, ${numericArrayValue},
         ${realArrayValue}, ${doubleArrayValue}, ${varcharArrayValue}, ${stringArrayValue}, ${booleanArrayValue}, ${dateArrayValue},
          ${timeArrayValue}, ${timestampArrayValue}, ${binaryArrayValue});
    `;

    _ = check callProcedure(sqlQuery, proceduresDatabase);

    sql:ParameterizedQuery query = ` select row_id, smallint_array, int_array, bigint_array, numeric_array,
        varchar_array, string_array, boolean_array from ArrayTypes2 where row_id = ${rowId}`;

    ArrayProcedureRecord2 expectedDataRow = {
        row_id: rowId,
        smallint_array: [1211, 478],
        int_array: [121, 498],
        bigint_array: [121, 498],
        numeric_array: <decimal[]>[122.43, 212.456],
        varchar_array: ["Varchar value", "Varying Char"],
        string_array: ["Hello", "Ballerina"],
        boolean_array: [true, false, true]
    };
    test:assertEquals(check queryProcedureClient(query, proceduresDatabase, ArrayProcedureRecord2), expectedDataRow, "Array Call procedure insert and query did not match.");
}

public type ArrayProcedureRecord3 record {
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
};

@test:Config {
    groups: ["procedures"],
    dependsOn: [testArrayProcedureCall]
}
function testArrayProcedureCall3() returns error? {
    int rowId = 35;
    PointArrayValue pointArrayValue = new ([{x: 1, y: 2}, {x: 2, y: 3}]);
    LineArrayValue lineArrayValue = new ([{a: 1, b: 2, c: 3}, {a: 1, b: 2, c: 3}]);
    LineSegmentArrayValue lsegArrayValue = new ([{x1: 1, x2: 1, y1: 2, y2: 2}, {x1: 1, x2: 1, y1: 2, y2: 2}]);
    BoxArrayValue boxArrayValue = new ([{x1: 2, x2: 3, y1: 2, y2: 3}]);
    Point[] points = [{x: 2, y: 2}, {x: 2, y: 2}];
    PathArrayValue pathArrayValue = new ([points]);
    points = [{x: 1, y: 4}, {x: 2, y: 2}];
    PolygonArrayValue polygonArrayValue = new ([points]);
    CircleArrayValue circleArrayValue = new ([{x: 1, y: 1, r: 1}, {x: 1, y: 1, r: 1}]);
    Interval interval = {years: 1, months: 2, days: 3, hours: 4, minutes: 5, seconds: 6};
    IntervalArrayValue intervalArrayValue = new ([interval, interval]);
    IntegerRange integerRange = {upper: 2, lower: -1, upperboundInclusive: true};
    IntegerRangeArrayValue integerRangeArrayValue = new ([integerRange, integerRange]);
    LongRange longRange = {upper: 12000, lower: 10000, lowerboundInclusive: true};
    LongRangeArrayValue longRangeArrayValue = new ([longRange, longRange]);
    NumericRange numericalRange = {upper: 221.34, lower: 10.17, upperboundInclusive: true, lowerboundInclusive: true};
    NumericRangeArrayValue numericalRangeArrayValue = new ([numericalRange, numericalRange]);
    TimestamptzRange timestamptzRange = {lower: "2010-01-01 20:00:00+01:30", upper: "2010-01-01 23:00:00+02:30", upperboundInclusive: true, lowerboundInclusive: true};
    TsTzRangeArrayValue timestamptzRangeArrayValue = new ([timestamptzRange, timestamptzRange]);
    TimestampRange timestampRange = {lower: "2010-01-01 20:00:00", upper: "2010-01-01 23:00:00"};
    TsRangeArrayValue timestamprangeArrayValue = new ([timestampRange, timestampRange]);
    DateRange dateRange = {lower: "2010-01-01", upper: "2010-01-05"};
    DateRangeArrayValue daterangeArrayValue = new ([dateRange, dateRange]);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call ArrayProcedure3(${rowId}, ${pointArrayValue}, ${lineArrayValue}, ${lsegArrayValue}, ${boxArrayValue},
         ${pathArrayValue}, ${polygonArrayValue}, ${circleArrayValue}, ${intervalArrayValue}, ${integerRangeArrayValue},
         ${longRangeArrayValue}, ${numericalRangeArrayValue}, ${timestamptzRangeArrayValue}, ${timestamprangeArrayValue}, ${daterangeArrayValue});
    `;

    _ = check callProcedure(sqlQuery, proceduresDatabase);

    sql:ParameterizedQuery query = ` select row_id, point_array, line_array, lseg_array, path_array,
        polygon_array, box_array, circle_array, interval_array, int4range_array,int8range_array from ArrayTypes3 where row_id = ${rowId}`;

    ArrayProcedureRecord3 expectedDataRow = {
        row_id: rowId,
        point_array: [<Point>{x: 1, y: 2}, <Point>{x: 2, y: 3}],
        line_array: [<Line>{a: 1, b: 2, c: 3}, <Line>{a: 1, b: 2, c: 3}],
        lseg_array: [<LineSegment>{x1: 1, y1: 2, x2: 1, y2: 2}, <LineSegment>{x1: 1, y1: 2, x2: 1, y2: 2}],
        path_array: [<Path>{points: [<Point>{x: 2, y: 2}, <Point>{x: 2, y: 2}]}],
        polygon_array: [<Polygon>{points: [<Point>{x: 1, y: 4}, <Point>{x: 2, y: 2}]}],
        box_array: [<Box>{x1: 2, x2: 3, y1: 2, y2: 3}],
        circle_array: [<Circle>{x: 1, y: 1, r: 1}, <Circle>{x: 1, y: 1, r: 1}],
        interval_array: [<Interval>{years: 1, months: 2, days: 3, hours: 4, minutes: 5, seconds: 6}, 
                        <Interval>{years: 1, months: 2, days: 3, hours: 4, minutes: 5, seconds: 6}],
        int4range_array: [<IntegerRange>{lower: 0, upper: 3, lowerboundInclusive: true}, 
                        <IntegerRange>{lower: 0, upper: 3, lowerboundInclusive: true}],
        int8range_array: [<IntegerRange>{lower: 10000, upper: 12000, lowerboundInclusive: true}, 
                        <LongRange>{lower: 10000, upper: 12000, lowerboundInclusive: true}]
    };
    test:assertEquals(check queryProcedureClient(query, proceduresDatabase, ArrayProcedureRecord3), expectedDataRow, "Array Call procedure insert and query did not match.");
}

public type ArrayProcedureRecord4 record {
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
};

@test:Config {
    groups: ["procedures"],
    dependsOn: [testArrayProcedureCall]
}
function testArrayProcedureCall4() returns error? {
    int rowId = 36;
    InetArrayValue inetArrayValue = new (["192.168.0.1/24", "192.168.0.1/24"]);
    CidrArrayValue cidrArrayValue = new (["::ffff:1.2.3.0/120", "::ffff:1.2.3.0/120"]);
    MacAddrArrayValue macaddrArrayValue = new (["08:00:2b:01:02:03", "08:00:2b:01:02:03"]);
    MacAddr8ArrayValue macaddr8ArrayValue = new (["08-00-2b-01-02-03-04-05", "08-00-2b-01-02-03-04-05"]);
    UuidArrayValue uuidArrayValue = new (["a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11", "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11"]);
    TsVectorArrayValue tsvectorArrayValue = new (["a fat cat sat on a mat and ate a fat rat", "a fat cat sat on a mat and ate a fat rat"]);
    TsQueryArrayValue tsqueryArrayValue = new (["fat & rat", "fat & rat"]);
    BitStringArrayValue bitstringArrayValue = new (["1110000111", "1110000111"]);
    VarBitStringArrayValue varbitstringArrayValue = new (["1101", "1101"]);
    PGBitArrayValue bitArrayValue = new ([false, false]);
    RegClassArrayValue regclassArrayValue = new (["pg_type", "pg_type"]);
    RegConfigArrayValue regconfigArrayValue = new (["english", "english"]);
    RegDictionaryArrayValue regdictionaryArrayValue = new (["simple", "simple"]);
    RegNamespaceArrayValue regnamespaceArrayValue = new (["pg_catalog", "pg_catalog"]);
    RegOperArrayValue regoperArrayValue = new (["||/", "||/"]);
    RegOperatorArrayValue regoperatorArrayValue = new (["*(integer,integer)", "*(integer,integer)"]);
    RegProcArrayValue regprocArrayValue = new (["now", "now"]);
    RegProcedureArrayValue regprocedureArrayValue = new (["sum(integer)", "sum(integer)"]);
    RegRoleArrayValue regroleArrayValue = new (["postgres", "postgres"]);
    RegTypeArrayValue regtypeArrayValue = new (["integer", "integer"]);
    xml xmlVal = xml `<foo><tag>bar</tag><tag>tag</tag></foo>`;
    PGXmlArrayValue xmlArrayValue = new ([xmlVal, xmlVal]);
    int[] oidArrayValue = [1, 2, 3];

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call ArrayProcedure4(${rowId}, ${inetArrayValue}, ${cidrArrayValue}, ${macaddrArrayValue}, ${macaddr8ArrayValue}, ${uuidArrayValue},
                 ${tsvectorArrayValue}, ${tsqueryArrayValue}, ${bitstringArrayValue}, ${varbitstringArrayValue},
                 ${bitArrayValue}, ${xmlArrayValue}, ${oidArrayValue}, ${regclassArrayValue}, ${regconfigArrayValue},
                 ${regdictionaryArrayValue}, ${regnamespaceArrayValue}, ${regoperArrayValue}, ${regoperatorArrayValue}, ${regprocArrayValue},
                 ${regprocedureArrayValue}, ${regroleArrayValue}, ${regtypeArrayValue});
    `;

    _ = check callProcedure(sqlQuery, proceduresDatabase);

    sql:ParameterizedQuery query = `select row_id, bit_array, inet_array, cidr_array, macaddr_array, macaddr8_array, uuid_array, tsvector_array, tsquery_array,
         varbitstring_array, regclass_array, regconfig_array, regdictionary_array, oid_array,
         regnamespace_array, regoper_array, regoperator_array, regproc_array, regprocedure_array, regrole_array, regtype_array,
          xml_array from Arraytypes4 where row_id = ${rowId}`;

    ArrayProcedureRecord4 expectedDataRow = {
        row_id: rowId,
        inet_array: ["192.168.0.1/24", "192.168.0.1/24"],
        cidr_array: ["::ffff:1.2.3.0/120", "::ffff:1.2.3.0/120"],
        macaddr_array: ["08:00:2b:01:02:03", "08:00:2b:01:02:03"],
        macaddr8_array: ["08:00:2b:01:02:03:04:05", "08:00:2b:01:02:03:04:05"],
        uuid_array: ["a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11", "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11"],
        tsvector_array: ["'a' 'and' 'ate' 'cat' 'fat' 'mat' 'on' 'rat' 'sat'", "'a' 'and' 'ate' 'cat' 'fat' 'mat' 'on' 'rat' 'sat'"],
        tsquery_array: ["'fat' & 'rat'", "'fat' & 'rat'"],
        varbitstring_array: ["1101", "1101"],
        xml_array: ["<foo><tag>bar</tag><tag>tag</tag></foo>", "<foo><tag>bar</tag><tag>tag</tag></foo>"],
        oid_array: [1, 2, 3],
        regclass_array: ["pg_type", "pg_type"],
        regconfig_array: ["english", "english"],
        regdictionary_array: ["simple", "simple"],
        regnamespace_array: ["pg_catalog", "pg_catalog"],
        regoper_array: ["||/", "||/"],
        regoperator_array: ["*(integer,integer)", "*(integer,integer)"],
        regproc_array: ["now", "now"],
        regprocedure_array: ["sum(integer)", "sum(integer)"],
        regrole_array: ["postgres", "postgres"],
        regtype_array: ["integer", "integer"],
        bit_array: [false, false]
    };
    test:assertEquals(check queryProcedureClient(query, proceduresDatabase, ArrayProcedureRecord4), expectedDataRow, "Array Call procedure insert and query did not match.");
}

public type ArrayProcedureRecord5 record {
    int row_id;
    json?[]? json_array;
    json?[]? jsonb_array;
    string?[]? jsonpath_array;
    string?[]? pglsn_array;
};

@test:Config {
    groups: ["procedures"],
    dependsOn: [testArrayProcedureCall]
}
function testArrayProcedureCall5() returns error? {
    int rowId = 37;
    JsonArrayValue jsonArrayValue = new ([<json>"{\"x\": 1, \"key\": \"value\"}", <json>"{\"x\": 1, \"key\": \"value\"}"]);
    JsonBinaryArrayValue jsonbArrayValue = new ([<json>{x: 1, "key": "value"}, <json>{x: 1, "key": "value"}]);
    JsonPathArrayValue jsonpathArrayValue = new (["$.\"floor\"[*].\"apt\"[*]?(@.\"area\" > 40 && @.\"area\" < 90)?(@.\"rooms\" > 1)", 
                                    "$.\"floor\"[*].\"apt\"[*]?(@.\"area\" > 40 && @.\"area\" < 90)?(@.\"rooms\" > 1)"]);
    MoneyArrayValue moneyArrayValue = new ([<decimal>11.21, <decimal>12.78]);
    PglsnArrayValue pglsnArrayValue = new (["16/B374D848", "16/B374D848"]);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call ArrayProcedure5(${rowId}, ${jsonArrayValue}, ${jsonbArrayValue}, ${jsonpathArrayValue}, ${moneyArrayValue}, ${pglsnArrayValue});
    `;

    _ = check callProcedure(sqlQuery, proceduresDatabase);

    sql:ParameterizedQuery query = `select row_id, json_array, jsonb_array, jsonpath_array, pglsn_array from Arraytypes5 where row_id = ${rowId}`;

    ArrayProcedureRecord5 expectedDataRow = {
        row_id: rowId,
        json_array: ["{\"x\": 1, \"key\": \"value\"}", "{\"x\": 1, \"key\": \"value\"}"],
        jsonb_array: ["{\"x\": 1, \"key\": \"value\"}", "{\"x\": 1, \"key\": \"value\"}"],
        jsonpath_array: ["$.\"floor\"[*].\"apt\"[*]?(@.\"area\" > 40 && @.\"area\" < 90)?(@.\"rooms\" > 1)", "$.\"floor\"[*].\"apt\"[*]?(@.\"area\" > 40 && @.\"area\" < 90)?(@.\"rooms\" > 1)"],
        pglsn_array: ["16/B374D848", "16/B374D848"]
    };
    test:assertEquals(check queryProcedureClient(query, proceduresDatabase, ArrayProcedureRecord5), expectedDataRow, "Array Call procedure insert and query did not match.");
}

public type EnumProcedureRecord record {
    int row_id;
    string value_type;
};

@test:Config {
    groups: ["procedures"],
    dependsOn: [testGeometricProcedureCall]
}
function testEnumProcedureCall() returns error? {
    int rowId = 35;
    Enum enumRecord = {value: "value2"};
    EnumValue enumValue = new (sqlTypeName = "value", value = enumRecord);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call EnumProcedure(${rowId}, ${enumValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    sql:ParameterizedQuery query = `SELECT row_id, value_type from EnumTypes where row_id = ${rowId}`;

    EnumProcedureRecord expectedDataRow = {
        row_id: rowId,
        value_type: "value2"
    };
    test:assertEquals(check queryProcedureClient(query, proceduresDatabase, EnumProcedureRecord), expectedDataRow, "Enum Call procedure insert and query did not match.");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testMoneyProcedureCall]
}
function testNumericProcedureOutCall() returns error? {
    int rowId = 1;
    sql:SmallIntValue smallintType = new ();
    sql:IntegerValue intType = new ();
    sql:BigIntValue bigintType = new ();
    sql:DecimalValue decimalType = new ();
    sql:NumericValue numericType = new ();
    sql:RealValue realType = new ();
    sql:DoubleValue doubleType = new ();

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter smallintInoutValue = new (smallintType);
    InOutParameter intInoutValue = new (intType);
    InOutParameter bigintInoutValue = new (bigintType);
    InOutParameter decimalInoutValue = new (decimalType);
    InOutParameter numericInoutValue = new (numericType);
    InOutParameter realInoutValue = new (realType);
    InOutParameter doubleInoutValue = new (doubleType);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call NumericOutProcedure(${rowIdInoutValue}, ${smallintInoutValue}, ${intInoutValue}, ${bigintInoutValue}, ${decimalInoutValue},
                                ${numericInoutValue}, ${realInoutValue}, ${doubleInoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    decimal decimalVal = 123.456;

    test:assertEquals(smallintInoutValue.get(int), 1, "SmallInt Datatype Doesn;t Match");
    test:assertEquals(intInoutValue.get(int), 123, "Int Datatype Doesn't Match");
    test:assertEquals(bigintInoutValue.get(int), 123456, "Bigint Datatype Doesn;t Match");
    test:assertEquals(decimalInoutValue.get(decimal), decimalVal, "Decimal Datatype Doesn't Match");
    test:assertEquals(numericInoutValue.get(decimal), decimalVal, "Numeric Datatype Doesn;t Match");
    test:assertTrue(realInoutValue.get(float) is float, "Real Datatype Doesn't Match");
    test:assertTrue(doubleInoutValue.get(float) is float, "Double Datatype Doesn't Match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testNumericProcedureOutCall]
}
function testCharacterProcedureOutCall() returns error? {
    int rowId = 1;
    sql:CharValue charValue = new ();
    sql:VarcharValue varcharValue = new ();
    sql:TextValue textValue = new ();
    string nameValue = "";

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter charInoutValue = new (charValue);
    InOutParameter varcharInoutValue = new (varcharValue);
    InOutParameter textInoutValue = new (textValue);
    InOutParameter nameInoutValue = new (nameValue);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call CharacterOutProcedure(${rowIdInoutValue}, ${charInoutValue}, ${varcharInoutValue}, ${textInoutValue}, ${nameInoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(charInoutValue.get(string), "This is a char1", "Char Data type doesnt match.");
    test:assertEquals(varcharInoutValue.get(string), "This is a varchar1", "Varchar Data type doesnt match.");
    test:assertEquals(textInoutValue.get(string), "This is a text1", "Text Data type doesnt match.");
    test:assertEquals(nameInoutValue.get(string), "This is a name1", "Name Data type doesnt match.");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testCharacterProcedureOutCall]
}
function testBooleanProcedureOutCall() returns error? {
    int rowId = 1;
    sql:BooleanValue booleanType = new ();

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter booleanInoutValue = new (booleanType);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call BooleanOutProcedure(${rowIdInoutValue}, ${booleanInoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(booleanInoutValue.get(boolean), true, "Boolean Datatype doesn't match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testBooleanProcedureOutCall]
}
function testNetworkProcedureOutCall() returns error? {
    int rowId = 1;
    InetValue inetValue = new ();
    CidrValue cidrValue = new ();
    MacAddrValue macaddrValue = new ();
    MacAddr8Value macaddr8Value = new ();

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter inetInoutValue = new (inetValue);
    InOutParameter cidrInoutValue = new (cidrValue);
    InOutParameter macaddrInoutValue = new (macaddrValue);
    InOutParameter macaddr8InoutValue = new (macaddr8Value);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call NetworkOutProcedure(${rowIdInoutValue}, ${inetInoutValue}, ${cidrInoutValue}, ${macaddrInoutValue}, ${macaddr8InoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(inetInoutValue.get(string), "192.168.0.1/24", "Inet Data type doesnt match.");
    test:assertEquals(cidrInoutValue.get(string), "::ffff:1.2.3.0/120", "Cidr Data type doesnt match.");
    test:assertEquals(macaddrInoutValue.get(string), "08:00:2b:01:02:03", "Macaddress Data type doesnt match.");
    test:assertEquals(macaddr8InoutValue.get(string), "08:00:2b:01:02:03:04:05", "Macadress8 Data type doesnt match.");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testNetworkProcedureOutCall]
}
function testGeometricProcedureOutCall() returns error? {
    int rowId = 1;
    PointValue pointType = new ();
    LineValue lineType = new ();
    LineSegmentValue lsegType = new ();
    BoxValue boxType = new ();
    PathValue pathType = new ();
    PolygonValue polygonType = new ();
    CircleValue circleType = new ();

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter pointInoutValue = new (pointType);
    InOutParameter lineInoutValue = new (lineType);
    InOutParameter lsegInoutValue = new (lsegType);
    InOutParameter boxInoutValue = new (boxType);
    InOutParameter pathInoutValue = new (pathType);
    InOutParameter polygonInoutValue = new (polygonType);
    InOutParameter circleInoutValue = new (circleType);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call GeometricOutProcedure(${rowIdInoutValue}, ${pointInoutValue}, ${lineInoutValue}, ${lsegInoutValue}, ${boxInoutValue}, ${pathInoutValue}, ${polygonInoutValue}, ${circleInoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    Point pointOutRecord = {x: 1.0, y: 2.0};
    Line lineOutRecord = {a: 1.0, b: 2.0, c: 3.0};
    LineSegment lsegOutRecord = {x1: 1.0, y1: 1.0, x2: 2.0, y2: 2.0};
    Box boxOutRecord = {x1: 1.0, y1: 1.0, x2: 2.0, y2: 2.0};
    Path pathOutRecord = {open: true, points: [{x: 1, y: 1}, {x: 2, y: 2}]};
    Polygon polygonOutRecord = {points: [{x: 1, y: 1}, {x: 2, y: 2}]};
    Circle circleOutRecord = {x: 1.0, y: 1.0, r: 1.0};

    test:assertEquals(pointInoutValue.get(string), "(1.0,2.0)", "Point Data type doesnt match.");
    test:assertEquals(lineInoutValue.get(string), "{1.0,2.0,3.0}", "Line Data type doesnt match.");
    test:assertEquals(lsegInoutValue.get(string), "[(1.0,1.0),(2.0,2.0)]", "Line Segment Data type doesnt match.");
    test:assertEquals(boxInoutValue.get(string), "(2.0,2.0),(1.0,1.0)", "Box Data type doesnt match.");
    test:assertEquals(pathInoutValue.get(string), "[(1.0,1.0),(2.0,2.0)]", "Path Data type doesnt match.");
    test:assertEquals(polygonInoutValue.get(string), "((1.0,1.0),(2.0,2.0))", "Polygon Data type doesnt match.");
    test:assertEquals(circleInoutValue.get(string), "<(1.0,1.0),1.0>", "Circle Data type doesnt match.");

    test:assertEquals(pointInoutValue.get(Point), pointOutRecord, "Point Data type doesnt match.");
    test:assertEquals(lineInoutValue.get(Line), lineOutRecord, "Line Data type doesnt match.");
    test:assertEquals(lsegInoutValue.get(LineSegment), lsegOutRecord, "Line Segment Data type doesnt match.");
    test:assertEquals(boxInoutValue.get(Box), boxOutRecord, "Box Data type doesnt match.");
    test:assertEquals(pathInoutValue.get(Path), pathOutRecord, "Path Data type doesnt match.");
    test:assertEquals(polygonInoutValue.get(Polygon), polygonOutRecord, "Polygon Data type doesnt match.");
    test:assertEquals(circleInoutValue.get(Circle), circleOutRecord, "Circle Data type doesnt match.");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testGeometricProcedureOutCall]
}
function testUuidProcedureOutCall() returns error? {
    int rowId = 1;
    UuidValue uuidType = new ();

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter uuidInoutValue = new (uuidType);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call UuidOutProcedure(${rowIdInoutValue}, ${uuidInoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(uuidInoutValue.get(string), "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11", "UUID Datatype doesn't match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testUuidProcedureOutCall]
}
function testPglsnProcedureOutCall() returns error? {
    int rowId = 1;
    PglsnValue pglsnType = new ();

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter pglsnInoutValue = new (pglsnType);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call PglsnOutProcedure(${rowIdInoutValue}, ${pglsnInoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(pglsnInoutValue.get(string), "16/B374D848", "Pg_lsn Data type Doesn't match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testPglsnProcedureOutCall]
}
function testJsonProcedureOutCall() returns error? {
    int rowId = 1;
    JsonValue jsonType = new ();
    JsonBinaryValue jsonbType = new ();
    JsonPathValue jsonpathType = new ();

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter jsonInoutValue = new (jsonType);
    InOutParameter jsonbInoutValue = new (jsonbType);
    InOutParameter jsonPathInoutValue = new (jsonpathType);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call JsonOutProcedure(${rowIdInoutValue}, ${jsonInoutValue}, ${jsonbInoutValue}, ${jsonPathInoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(jsonInoutValue.get(string), "{\"key1\": \"value\", \"key2\": 2}", "Json Datatype Doesn't Match");
    test:assertEquals(jsonbInoutValue.get(string), "{\"key1\": \"value\", \"key2\": 2}", "Jsonb Datatype Doesn't Match");
    test:assertEquals(jsonPathInoutValue.get(string), "$.\"floor\"[*].\"apt\"[*]?(@.\"area\" > 40 && @.\"area\" < 90)?(@.\"rooms\" > 1)", "Json path Datatype Doesn't Match");

    test:assertEquals(jsonInoutValue.get(json), {"key1": "value", "key2": 2}, "Json Datatype Doesn't Match");
    test:assertEquals(jsonbInoutValue.get(json), {"key1": "value", "key2": 2}, "Jsonb Datatype Doesn't Match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testJsonProcedureOutCall]
}
function testBitProcedureOutCall() returns error? {
    int rowId = 1;
    VarBitStringValue varbitstringType = new ();
    PGBitValue bitType = new ();

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter varbitInoutValue = new (varbitstringType);
    InOutParameter bitInoutValue = new (bitType);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call BitOutProcedure(${rowIdInoutValue}, ${varbitInoutValue}, ${bitInoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(varbitInoutValue.get(string), "1101", "Bit Vary Datatype Doesn;t Match");
    test:assertEquals(bitInoutValue.get(boolean), true, "Bit Datatype Doesn't Match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testBitProcedureOutCall]
}
function testDatetimeProcedureOutCall() returns error? {

    int rowId = 1;
    sql:TimestampValue timestampType = new ();
    sql:TimestampValue timestamptzType = new ();
    sql:DateValue dateType = new ();
    sql:TimeValue timeType = new ();
    sql:TimeValue timetzType = new ();
    IntervalValue intervalType = new ();

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter timestampInoutValue = new (timestampType);
    InOutParameter timestamptzInoutValue = new (timestamptzType);
    InOutParameter dateInoutValue = new (dateType);
    InOutParameter timeInoutValue = new (timeType);
    InOutParameter timetzInoutValue = new (timetzType);
    InOutParameter intervalInoutValue = new (intervalType);

    sql:ParameterizedCallQuery sqlQuery = 
    `
        call DatetimeOutProcedure(${rowIdInoutValue}, ${dateInoutValue}, ${timeInoutValue}, ${timetzInoutValue},
            ${timestampInoutValue}, ${timestamptzInoutValue}, ${intervalInoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    test:assertTrue(timestampInoutValue.get(string) is string, "Timestamp Datatype Doesn't Match");
    test:assertTrue(timestamptzInoutValue.get(string) is string, "Timestamptz Datatype Doesn't Match");
    test:assertTrue(dateInoutValue.get(string) is string, "Date Datatype Doesn't Match");
    test:assertTrue(timeInoutValue.get(string) is string, "Time Datatype Doesn't Match");
    test:assertTrue(timetzInoutValue.get(string) is string, "Timetz Datatype Doesn't Match");
    test:assertEquals(intervalInoutValue.get(string), "1 years 2 mons 3 days 4 hours 5 mins 6.0 secs", " Interval Datatype Doesn't Match");

    Interval interval = {years: 1, months: 2, days: 3, hours: 4, minutes: 5, seconds: 6};

    test:assertTrue(timeInoutValue.get(time:TimeOfDay) is time:TimeOfDay, "Time Datatype Doesn't Match");
    test:assertTrue(dateInoutValue.get(time:Date) is time:Date, "Date Datatype Doesn't Match");
    test:assertTrue(timetzInoutValue.get(time:TimeOfDay) is time:TimeOfDay, "Timetz Datatype Doesn't Match");
    test:assertEquals(intervalInoutValue.get(Interval), interval, "Interval Datatype Doesn't Match");
    test:assertTrue(timestampInoutValue.get(time:Civil) is time:Civil, "Timestamp Datatype Doesn't Match");
    test:assertTrue(timestamptzInoutValue.get(time:Civil) is time:Civil, "Timestamptz Datatype Doesn't Match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testDatetimeProcedureOutCall]
}
function testRangeProcedureOutCall() returns error? {

    int rowId = 1;
    IntegerRangeValue int4rangeType = new ();
    LongRangeValue int8rangeType = new ();
    NumericRangeValue numrangeType = new ();
    TsRangeValue tsrangeType = new ();
    TsTzRangeValue tstzrangeType = new ();
    DateRangeValue daterangeType = new ();

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter int4rangeInoutValue = new (int4rangeType);
    InOutParameter int8rangeInoutValue = new (int8rangeType);
    InOutParameter numrangeInoutValue = new (numrangeType);
    InOutParameter tsrangeInoutValue = new (tsrangeType);
    InOutParameter tstzrangeInoutValue = new (tstzrangeType);
    InOutParameter daterangeInoutValue = new (daterangeType);

    IntegerRange int4RangeRecord = {upper: 50, lower: 3, upperboundInclusive: false, lowerboundInclusive: true};
    LongRange int8RangeRecord = {upper: 100, lower: 11, upperboundInclusive: false, lowerboundInclusive: true};
    NumericRange numRangeRecord = {upper: 24d, lower: 0, upperboundInclusive: false, lowerboundInclusive: false};
    TimestampRange tsrangeRecordType = {lower: "2010-01-01 14:30:00", upper: "2010-01-01 15:30:00"};
    DateRange daterangeRecordType = {lower: "2010-01-02", upper: "2010-01-03", lowerboundInclusive: true};

    sql:ParameterizedCallQuery sqlQuery = 
    `
    call RangeOutProcedure(${rowIdInoutValue}, ${int4rangeInoutValue}, ${int8rangeInoutValue}, ${numrangeInoutValue}, ${tsrangeInoutValue}, ${tstzrangeInoutValue}, ${daterangeInoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(int4rangeInoutValue.get(string), "[3,50)", "Int4range Datatype Doesn't Match");
    test:assertEquals(int8rangeInoutValue.get(string), "[11,100)", "Int8range Datatype Doesn't Match");
    test:assertEquals(numrangeInoutValue.get(string), "(0,24)", "Numrnge Datatype Doesn't Match");
    test:assertEquals(tsrangeInoutValue.get(string), "(\"2010-01-01 14:30:00\",\"2010-01-01 15:30:00\")", "Tsrange Datatype Doesn't Match");
    test:assertTrue(tstzrangeInoutValue.get(string) is string, "Tstzrange Datatype Doesn't Match");
    test:assertEquals(daterangeInoutValue.get(string), "[2010-01-02,2010-01-03)", "Daterange Datatype Doesn't Match");

    test:assertEquals(int4rangeInoutValue.get(IntegerRange), int4RangeRecord, "Int4range Datatype Doesn't Match");
    test:assertEquals(int8rangeInoutValue.get(LongRange), int8RangeRecord, "Int8range Datatype Doesn't Match");
    test:assertEquals(numrangeInoutValue.get(NumericRange), numRangeRecord, "Numrnge Datatype Doesn't Match");
    test:assertEquals(tsrangeInoutValue.get(TimestampRange), tsrangeRecordType, "Tsrange Datatype Doesn't Match");
    test:assertTrue(tstzrangeInoutValue.get(TimestamptzRange) is TimestamptzRange, "Tstzrange Datatype Doesn't Match");
    test:assertEquals(daterangeInoutValue.get(DateRange), daterangeRecordType, "Daterange Datatype Doesn't Match");

    test:assertTrue(tsrangeInoutValue.get(TimestampCivilRange) is TimestampCivilRange, "Tsrange Datatype Doesn't Match");
    test:assertTrue(tstzrangeInoutValue.get(TimestamptzCivilRange) is TimestamptzCivilRange, "Tstzrange Datatype Doesn't Match");
    test:assertTrue(daterangeInoutValue.get(DateRecordRange) is DateRecordRange, "Daterange Datatype Doesn't Match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testRangeProcedureOutCall]
}
function testTextsearchProcedureOutCall() returns error? {
    int rowId = 1;
    TsVectorValue tsvectorType = new ();
    TsQueryValue tsqueryType = new ();

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter tsvectorInoutValue = new (tsvectorType);
    InOutParameter tsqueryInoutValue = new (tsqueryType);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call TextsearchOutProcedure(${rowIdInoutValue}, ${tsvectorInoutValue}, ${tsqueryInoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(tsvectorInoutValue.get(string), "'a' 'and' 'ate' 'cat' 'fat' 'mat' 'on' 'rat' 'sat'", "Tsvector Datatype Doesn't Match");
    test:assertEquals(tsqueryInoutValue.get(string), "'fat' & 'rat'", "Tsquery Datatype Doesn't Match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testTextsearchProcedureOutCall]
}
function testObjectidentifierProcedureOutCall() returns error? {
    int rowId = 1;
    int oidType = 12;
    RegClassValue regclassType = new ();
    RegConfigValue regconfigType = new ();
    RegDictionaryValue regdictionaryType = new ();
    RegNamespaceValue regnamespaceType = new ();
    RegOperValue regoperType = new ();
    RegOperatorValue regoperatorType = new ();
    RegProcValue regprocType = new ();
    RegProcedureValue regprocedureType = new ();
    RegRoleValue regroleType = new ();
    RegTypeValue regtypeType = new ();

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter oidInoutValue = new (oidType);
    InOutParameter regclassInoutValue = new (regclassType);
    InOutParameter regconfigInoutValue = new (regconfigType);
    InOutParameter regdictionaryInoutValue = new (regdictionaryType);
    InOutParameter regnamespaceInoutValue = new (regnamespaceType);
    InOutParameter regoperInoutValue = new (regoperType);
    InOutParameter regoperatorInoutValue = new (regoperatorType);
    InOutParameter regprocInoutValue = new (regprocType);
    InOutParameter regprocedureInoutValue = new (regprocedureType);
    InOutParameter regroleInoutValue = new (regroleType);
    InOutParameter regtypeInoutValue = new (regtypeType);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call ObjectidentifierOutProcedure(${rowIdInoutValue}, ${oidInoutValue}, ${regclassInoutValue}, ${regconfigInoutValue}, ${regdictionaryInoutValue},
                                ${regnamespaceInoutValue}, ${regoperInoutValue}, ${regoperatorInoutValue}, ${regprocInoutValue}, ${regprocedureInoutValue},
                                 ${regroleInoutValue}, ${regtypeInoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(oidInoutValue.get(string), "12", "OID Datatype with string Doesn't Match");
    test:assertEquals(oidInoutValue.get(int), 12, "OID Datatype with int Doesn't Match");
    test:assertEquals(regclassInoutValue.get(string), "pg_type", "Reg class Datatype Doesn't Match");
    test:assertEquals(regconfigInoutValue.get(string), "english", "Reg config Datatype Doesn;t Match");
    test:assertEquals(regdictionaryInoutValue.get(string), "simple", "Reg Dictionary Datatype Doesn't Match");
    test:assertEquals(regnamespaceInoutValue.get(string), "pg_catalog", "Reg namespace Datatype Doesn;t Match");
    test:assertEquals(regoperInoutValue.get(string), "||/", "Reg oper Datatype Doesn't Match");
    test:assertEquals(regoperatorInoutValue.get(string), "*(integer,integer)", "Reg operator Datatype Doesn;t Match");
    test:assertEquals(regprocInoutValue.get(string), "now", "Reg proc Datatype Doesn't Match");
    test:assertEquals(regprocedureInoutValue.get(string), "sum(integer)", "Reg procedure Datatype Doesn;t Match");
    test:assertEquals(regroleInoutValue.get(string), "postgres", "Reg role Datatype Doesn't Match");
    test:assertEquals(regtypeInoutValue.get(string), "integer", "Reg type Datatype Doesn;t Match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testObjectidentifierProcedureOutCall]
}
function testXmlProcedureOutCall() returns error? {
    int rowId = 1;
    PGXmlValue xmlType = new ();

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter xmlInoutValue = new (xmlType);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call XmlOutProcedure(${rowIdInoutValue}, ${xmlInoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);
    xml xmlValue = xml `<foo><tag>bar</tag><tag>tag</tag></foo>`;
    test:assertEquals(xmlInoutValue.get(XML), xmlValue, "Xml Datatype doesn't match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testXmlProcedureOutCall]
}
function testBinaryProcedureOutCall() returns error? {
    int rowId = 1;
    sql:BinaryValue byteaType = new ();

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter byteaInoutValue = new (byteaType);
    InOutParameter byteaEscapeInoutValue = new (byteaType);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call BinaryOutProcedure(${rowIdInoutValue}, ${byteaInoutValue}, ${byteaEscapeInoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);
    test:assertTrue(byteaInoutValue.get(string) is string, "Binary Datatype doesn't match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testBinaryProcedureOutCall]
}
function testMoneyProcedureOutCall() returns error? {
    int rowId = 1;
    MoneyValue moneyType = new ();

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter moneyInoutValue = new (moneyType);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call MoneyOutProcedure(${rowIdInoutValue}, ${moneyInoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);
    float moneyValue = 124.56;
    test:assertEquals(moneyInoutValue.get(string), "124.56", "Money Datatype doesn't match");
    test:assertEquals(moneyInoutValue.get(float), moneyValue, "Money Datatype doesn't match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testCharacterProcedureOutCall]
}
function testEnumProcedureOutCall() returns error? {
    int rowId = 1;
    EnumValue enumType = new (sqlTypeName = "value", value = ());

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter enumInoutValue = new (enumType);

    sql:ParameterizedCallQuery sqlQuery = 
    `
    call EnumOutProcedure(${rowIdInoutValue}, ${enumInoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(enumInoutValue.get(string), "value1", "Enum Datatype doesn't match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testMoneyProcedureOutCall]
}
function testNumericProcedureInoutCall() returns error? {
    int rowId = 36;
    decimal decimalVal = 1234.567;
    sql:SmallIntValue smallintType = new (1);
    sql:IntegerValue intType = new (1);
    sql:BigIntValue bigintType = new (123456);
    sql:DecimalValue decimalType = new (decimalVal);
    sql:NumericValue numericType = new (decimalVal);
    sql:RealValue realType = new (123.456);
    sql:DoubleValue doubleType = new (123.456);

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter smallintInoutValue = new (smallintType);
    InOutParameter intInoutValue = new (intType);
    InOutParameter bigintInoutValue = new (bigintType);
    InOutParameter decimalInoutValue = new (decimalType);
    InOutParameter numericInoutValue = new (numericType);
    InOutParameter realInoutValue = new (realType);
    InOutParameter doubleInoutValue = new (doubleType);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call NumericInoutProcedure(${rowIdInoutValue}, ${smallintInoutValue}, ${intInoutValue}, ${bigintInoutValue}, ${decimalInoutValue},
                                ${numericInoutValue}, ${realInoutValue}, ${doubleInoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(smallintInoutValue.get(int), 1, "Smallint Datatype Doesn;t Match");
    test:assertEquals(intInoutValue.get(int), 1, "Integer Datatype Doesn't Match");
    test:assertEquals(bigintInoutValue.get(int), 123456, "Bigint Datatype Doesn;t Match");
    test:assertEquals(decimalInoutValue.get(decimal), decimalVal, "Decimal Datatype Doesn't Match");
    test:assertEquals(numericInoutValue.get(decimal), decimalVal, "Numeric Datatype Doesn;t Match");
    test:assertTrue(realInoutValue.get(float) is float, "Real Datatype Doesn't Match");
    test:assertTrue(doubleInoutValue.get(float) is float, "Double Datatype Doesn;t Match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testNumericProcedureInoutCall]
}
function testCharacterProcedureInoutCall() returns error? {
    int rowId = 36;
    sql:CharValue charValue = new ("This is a char4");
    sql:VarcharValue varcharValue = new ("This is a varchar4");
    sql:TextValue textValue = new ("This is a text4");
    string nameValue = "This is a name4";

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter charInoutValue = new (charValue);
    InOutParameter varcharInoutValue = new (varcharValue);
    InOutParameter textInoutValue = new (textValue);
    InOutParameter nameInoutValue = new (nameValue);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call CharacterInoutProcedure(${rowIdInoutValue}, ${charInoutValue}, ${varcharInoutValue}, ${textInoutValue}, ${nameInoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(charInoutValue.get(string), "This is a char4", "Char Data type doesnt match.");
    test:assertEquals(varcharInoutValue.get(string), "This is a varchar4", "Varchar Data type doesnt match.");
    test:assertEquals(textInoutValue.get(string), "This is a text4", "Text Data type doesnt match.");
    test:assertEquals(nameInoutValue.get(string), "This is a name4", "Name Data type doesnt match.");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testCharacterProcedureInoutCall]
}
function testBooleanProcedureInoutCall() returns error? {
    int rowId = 36;
    boolean booleanType = false;

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter booleanInoutValue = new (booleanType);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call BooleanInoutProcedure(${rowIdInoutValue}, ${booleanInoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(booleanInoutValue.get(boolean), false, "Boolean Datatype doesn't match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testBooleanProcedureInoutCall]
}
function testNetworkProcedureInoutCall() returns error? {
    int rowId = 36;
    InetValue inetValue = new ("192.168.0.1/24");
    CidrValue cidrValue = new ("::ffff:1.2.3.0/120");
    MacAddrValue macaddrValue = new ("08:00:2b:01:02:03");
    MacAddr8Value macaddr8Value = new ("08-00-2b-01-02-03-04-00");

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter inetInoutValue = new (inetValue);
    InOutParameter cidrInoutValue = new (cidrValue);
    InOutParameter macaddrInoutValue = new (macaddrValue);
    InOutParameter macaddr8InoutValue = new (macaddr8Value);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call NetworkInoutProcedure(${rowIdInoutValue}, ${inetInoutValue}, ${cidrInoutValue}, ${macaddrInoutValue}, ${macaddr8InoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(inetInoutValue.get(string), "192.168.0.1/24", "Inet Data type doesnt match.");
    test:assertEquals(cidrInoutValue.get(string), "::ffff:1.2.3.0/120", "Cidr Data type doesnt match.");
    test:assertEquals(macaddrInoutValue.get(string), "08:00:2b:01:02:03", "Macaddress Data type doesnt match.");
    test:assertEquals(macaddr8InoutValue.get(string), "08:00:2b:01:02:03:04:00", "Macadress8 Data type doesnt match.");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testNetworkProcedureInoutCall]
}
function testGeometricProcedureInoutCall() returns error? {
    int rowId = 36;
    PointValue pointType = new ({x: 2, y: 2});
    LineValue lineType = new ({a: 2, b: 3, c: 4});
    LineSegmentValue lsegType = new ({x1: 2, x2: 3, y1: 2, y2: 3});
    BoxValue boxType = new ({x1: 2, x2: 3, y1: 2, y2: 3});
    PathValue pathType = new ({open: false, points: [{x: 1, y: 1}, {x: 2, y: 2}]});
    PolygonValue polygonType = new ([{x: 1, y: 1}, {x: 2, y: 2}]);
    CircleValue circleType = new ({x: 2, y: 2, r: 2});

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter pointInoutValue = new (pointType);
    InOutParameter lineInoutValue = new (lineType);
    InOutParameter lsegInoutValue = new (lsegType);
    InOutParameter boxInoutValue = new (boxType);
    InOutParameter pathInoutValue = new (pathType);
    InOutParameter polygonInoutValue = new (polygonType);
    InOutParameter circleInoutValue = new (circleType);

    Point pointOutRecord = {x: 2, y: 2};
    Line lineOutRecord = {a: 2, b: 3, c: 4};
    LineSegment lsegOutRecord = {x1: 2, y1: 2, x2: 3, y2: 3};
    Box boxOutRecord = {x1: 2, x2: 3, y1: 2, y2: 3};
    Path pathOutRecord = {open: false, points: [{x: 1, y: 1}, {x: 2, y: 2}]};
    Polygon polygonOutRecord = {points: [{x: 1, y: 1}, {x: 2, y: 2}]};
    Circle circleOutRecord = {x: 2, y: 2, r: 2};

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call GeometricInoutProcedure(${rowIdInoutValue}, ${pointInoutValue}, ${lineInoutValue}, ${lsegInoutValue}, ${boxInoutValue}, ${pathInoutValue}, ${polygonInoutValue}, ${circleInoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);
    test:assertEquals(pointInoutValue.get(string), "(2.0,2.0)", "Point Data type doesnt match.");
    test:assertEquals(lineInoutValue.get(string), "{2.0,3.0,4.0}", "Line Data type doesnt match.");
    test:assertEquals(lsegInoutValue.get(string), "[(2.0,2.0),(3.0,3.0)]", "Line Segment Data type doesnt match.");
    test:assertEquals(boxInoutValue.get(string), "(3.0,3.0),(2.0,2.0)", "Box Data type doesnt match.");
    test:assertEquals(pathInoutValue.get(string), "((1.0,1.0),(2.0,2.0))", "Path Data type doesnt match.");
    test:assertEquals(polygonInoutValue.get(string), "((1.0,1.0),(2.0,2.0))", "Polygon Data type doesnt match.");
    test:assertEquals(circleInoutValue.get(string), "<(2.0,2.0),2.0>", "Circle Data type doesnt match.");

    test:assertEquals(pointInoutValue.get(Point), pointOutRecord, "Point Data type doesnt match.");
    test:assertEquals(lineInoutValue.get(Line), lineOutRecord, "Line Data type doesnt match.");
    test:assertEquals(lsegInoutValue.get(LineSegment), lsegOutRecord, "Line Segment Data type doesnt match.");
    test:assertEquals(boxInoutValue.get(Box), boxOutRecord, "Box Data type doesnt match.");
    test:assertEquals(pathInoutValue.get(Path), pathOutRecord, "Path Data type doesnt match.");
    test:assertEquals(polygonInoutValue.get(Polygon), polygonOutRecord, "Polygon Data type doesnt match.");
    test:assertEquals(circleInoutValue.get(Circle), circleOutRecord, "Circle Data type doesnt match.");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testGeometricProcedureInoutCall]
}
function testUuidProcedureInoutCall() returns error? {
    int rowId = 36;
    UuidValue uuidType = new ("a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12");

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter uuidInoutValue = new (uuidType);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call UuidInoutProcedure(${rowIdInoutValue}, ${uuidInoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(uuidInoutValue.get(string), "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12", "UUID Datatype doesn't match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testUuidProcedureInoutCall]
}
function testPglsnProcedureInoutCall() returns error? {
    int rowId = 36;
    PglsnValue pglsnType = new ("16/B374D848");

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter pglsnInoutValue = new (pglsnType);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call PglsnInoutProcedure(${rowIdInoutValue}, ${pglsnInoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(pglsnInoutValue.get(string), "16/B374D848", "Pg_lsn Data type Doesn't match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testPglsnProcedureInoutCall]
}
function testJsonProcedureInoutCall() returns error? {
    int rowId = 36;
    json jsonValue = {"key1": "value", "key2": 2};
    JsonValue jsonType = new (jsonValue);
    JsonBinaryValue jsonbType = new (jsonValue);
    JsonPathValue jsonpathType = new ("$.\"floor\"[*].\"apt\"[*]?(@.\"area\" > 40 && @.\"area\" < 90)?(@.\"rooms\" > 10)");

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter jsonInoutValue = new (jsonType);
    InOutParameter jsonbInoutValue = new (jsonbType);
    InOutParameter jsonPathInoutValue = new (jsonpathType);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call JsonInoutProcedure(${rowIdInoutValue}, ${jsonInoutValue}, ${jsonbInoutValue}, ${jsonPathInoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(jsonInoutValue.get(string), "{\"key1\":\"value\",\"key2\":2}", "Json Datatype Doesn't Match");
    test:assertEquals(jsonbInoutValue.get(string), "{\"key1\": \"value\", \"key2\": 2}", "Jsonb Datatype Doesn't Match");
    test:assertEquals(jsonPathInoutValue.get(string), "$.\"floor\"[*].\"apt\"[*]?(@.\"area\" > 40 && @.\"area\" < 90)?(@.\"rooms\" > 10)", "Json path Datatype Doesn't Match");

    test:assertEquals(jsonInoutValue.get(json), {"key1": "value", "key2": 2}, "Json Datatype Doesn't Match");
    test:assertEquals(jsonbInoutValue.get(json), {"key1": "value", "key2": 2}, "Jsonb Datatype Doesn't Match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testJsonProcedureInoutCall]
}
function testBitProcedureInoutCall() returns error? {
    int rowId = 36;
    VarBitStringValue varbitstringType = new ("111110");
    PGBitValue bitType = new ("0");

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter varbitInoutValue = new (varbitstringType);
    InOutParameter bitInoutValue = new (bitType);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call BitInoutProcedure(${rowIdInoutValue}, ${varbitInoutValue}, ${bitInoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(varbitInoutValue.get(string), "111110", "Bit Vary Datatype Doesn;t Match");
    test:assertEquals(bitInoutValue.get(boolean), false, "Bit Datatype Doesn't Match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testBitProcedureInoutCall]
}
function testDatetimeProcedureInoutCall() returns error? {
    int rowId = 36;
    time:Date date = {year: 2017, month: 12, day: 18};
    time:Civil timestamp = {year: 2017, month: 2, day: 3, hour: 11, minute: 53, second: 0};
    time:Civil timestamptz = {year: 2017, month: 2, day: 3, hour: 11, minute: 53, second: 0, "utcOffset": {hours: 8, minutes: 30}};
    time:TimeOfDay timetz = {hour: 23, minute: 12, second: 18, "utcOffset": {hours: 8, minutes: 30}};
    time:TimeOfDay time = {hour: 23, minute: 12, second: 18};
    sql:DateTimeValue timestampType = new (timestamp);
    sql:DateTimeValue timestamptzType = new (timestamptz);
    sql:DateValue dateType = new (date);
    sql:TimeValue timeType = new (time);
    sql:TimeValue timetzType = new (timetz);
    IntervalValue intervalType = new ({years: 1, months: 2, days: 3, hours: 4, minutes: 5, seconds: 7});

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter timestampInoutValue = new (timestampType);
    InOutParameter timestamptzInoutValue = new (timestamptzType);
    InOutParameter dateInoutValue = new (dateType);
    InOutParameter timeInoutValue = new (timeType);
    InOutParameter timetzInoutValue = new (timetzType);
    InOutParameter intervalInoutValue = new (intervalType);

    sql:ParameterizedCallQuery sqlQuery = 
    `
        call DatetimeInoutProcedure(${rowIdInoutValue}, ${dateInoutValue}, ${timeInoutValue}, ${timetzInoutValue},
            ${timestampInoutValue}, ${timestamptzInoutValue}, ${intervalInoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    test:assertTrue(timestampInoutValue.get(string) is string, "Timestamp Datatype Doesn't Match");
    test:assertTrue(dateInoutValue.get(string) is string, "Date Datatype Doesn't Match");
    test:assertTrue(timestamptzInoutValue.get(string) is string, "Timestamptz Datatype Doesn't Match");
    test:assertTrue(timeInoutValue.get(string) is string, "Time Datatype Doesn't Match");
    test:assertTrue(timetzInoutValue.get(string) is string, "Timetz Datatype Doesn't Match");
    test:assertEquals(intervalInoutValue.get(string), "1 years 2 mons 3 days 4 hours 5 mins 7.0 secs", "Interval Datatype Doesn't Match");

    Interval intervalInout = {years: 1, months: 2, days: 3, hours: 4, minutes: 5, seconds: 7};

    test:assertTrue(timestampInoutValue.get(time:Civil) is time:Civil, "Timestamp Datatype Doesn't Match");
    test:assertTrue(dateInoutValue.get(time:Date) is time:Date, "Date Datatype Doesn't Match");
    test:assertTrue(timestamptzInoutValue.get(time:Civil) is time:Civil, "Timestamptz Datatype Doesn't Match");
    test:assertTrue(timeInoutValue.get(time:TimeOfDay) is time:TimeOfDay, "Time Datatype Doesn't Match");
    test:assertTrue(timetzInoutValue.get(time:TimeOfDay) is time:TimeOfDay, "Timetz Datatype Doesn't Match");
    test:assertEquals(intervalInoutValue.get(Interval), intervalInout, "Interval Datatype Doesn't Match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testDatetimeProcedureInoutCall]
}
function testRangeProcedureInoutCall() returns error? {

    int rowId = 36;
    IntegerRangeValue int4rangeType = new ("(2,50)");
    LongRangeValue int8rangeType = new ("(10,100)");
    NumericRangeValue numrangeType = new ("(0.1,2.4)");
    TsRangeValue tsrangeType = new ("(2010-01-01 14:30, 2010-01-01 15:30)");
    TsTzRangeValue tstzrangeType = new ("(2010-01-01 14:30, 2010-01-01 15:30)");
    DateRangeValue daterangeType = new ("(2010-01-01 14:30, 2010-01-03 )");

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter int4rangeInoutValue = new (int4rangeType);
    InOutParameter int8rangeInoutValue = new (int8rangeType);
    InOutParameter numrangeInoutValue = new (numrangeType);
    InOutParameter tsrangeInoutValue = new (tsrangeType);
    InOutParameter tstzrangeInoutValue = new (tstzrangeType);
    InOutParameter daterangeInoutValue = new (daterangeType);

    sql:ParameterizedCallQuery sqlQuery = 
    `
    call RangeInoutProcedure(${rowIdInoutValue}, ${int4rangeInoutValue}, ${int8rangeInoutValue}, ${numrangeInoutValue}, ${tsrangeInoutValue}, ${tstzrangeInoutValue}, ${daterangeInoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    IntegerRange int4RangeRecord = {upper: 50, lower: 3, lowerboundInclusive: true};
    LongRange int8RangeRecord = {upper: 100, lower: 11, upperboundInclusive: false, lowerboundInclusive: true};
    TimestampRange tsrangeRecordType = {lower: "2010-01-01 14:30:00", upper: "2010-01-01 15:30:00"};
    DateRange daterangeRecordType = {lower: "2010-01-02", upper: "2010-01-03", lowerboundInclusive: true};

    test:assertEquals(int4rangeInoutValue.get(string), "[3,50)", "Int4range Datatype Doesn't Match");
    test:assertEquals(int8rangeInoutValue.get(string), "[11,100)", "Int8range Datatype Doesn't Match");
    test:assertEquals(numrangeInoutValue.get(string), "(0.1,2.4)", "Numrnge Datatype Doesn't Match");
    test:assertEquals(tsrangeInoutValue.get(string), "(\"2010-01-01 14:30:00\",\"2010-01-01 15:30:00\")", "Tsrange Datatype Doesn't Match");
    test:assertTrue(tstzrangeInoutValue.get(string) is string, "Tstzrange Datatype Doesn't Match");
    test:assertEquals(daterangeInoutValue.get(string), "[2010-01-02,2010-01-03)", "Daterange Datatype Doesn't Match");

    test:assertEquals(int4rangeInoutValue.get(IntegerRange), int4RangeRecord, "Int4range Datatype Doesn't Match");
    test:assertEquals(int8rangeInoutValue.get(LongRange), int8RangeRecord, "Int8range Datatype Doesn't Match");
    test:assertTrue(numrangeInoutValue.get(NumericRange) is NumericRange, "Numrnge Datatype Doesn't Match");
    test:assertEquals(tsrangeInoutValue.get(TimestampRange), tsrangeRecordType, "Tsrange Datatype Doesn't Match");
    test:assertTrue(tstzrangeInoutValue.get(TimestamptzRange) is TimestamptzRange, "Tstzrange Datatype Doesn't Match");
    test:assertEquals(daterangeInoutValue.get(DateRange), daterangeRecordType, "Daterange Datatype Doesn't Match");

    test:assertTrue(tsrangeInoutValue.get(TimestampCivilRange) is TimestampCivilRange, "Tsrange Datatype Doesn't Match");
    test:assertTrue(tstzrangeInoutValue.get(TimestamptzCivilRange) is TimestamptzCivilRange, "Tstzrange Datatype Doesn't Match");
    test:assertTrue(daterangeInoutValue.get(DateRecordRange) is DateRecordRange, "Daterange Datatype Doesn't Match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testRangeProcedureInoutCall]
}
function testTextsearchProcedureInoutCall() returns error? {
    int rowId = 36;
    TsVectorValue tsvectorType = new ("a fat cat sat on a mat and ate a fat rat");
    TsQueryValue tsqueryType = new ("fat & rat");

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter tsvectorInoutValue = new (tsvectorType);
    InOutParameter tsqueryInoutValue = new (tsqueryType);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call TextsearchInoutProcedure(${rowIdInoutValue}, ${tsvectorInoutValue}, ${tsqueryInoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(tsvectorInoutValue.get(string), "'a' 'and' 'ate' 'cat' 'fat' 'mat' 'on' 'rat' 'sat'", "Tsvector Datatype Doesn't Match");
    test:assertEquals(tsqueryInoutValue.get(string), "'fat' & 'rat'", "Tsquery Datatype Doesn't Match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testTextsearchProcedureInoutCall]
}
function testObjectidentifierProcedureInoutCall() returns error? {
    int rowId = 36;
    int oidType = 12;
    RegClassValue regclassType = new ("pg_type");
    RegConfigValue regconfigType = new ("english");
    RegDictionaryValue regdictionaryType = new ("simple");
    RegNamespaceValue regnamespaceType = new ("pg_catalog");
    RegOperValue regoperType = new ("||/");
    RegOperatorValue regoperatorType = new ("*(int,int)");
    RegProcValue regprocType = new ("NOW");
    RegProcedureValue regprocedureType = new ("sum(int4)");
    RegRoleValue regroleType = new ("postgres");
    RegTypeValue regtypeType = new ("int");

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter oidInoutValue = new (oidType);
    InOutParameter regclassInoutValue = new (regclassType);
    InOutParameter regconfigInoutValue = new (regconfigType);
    InOutParameter regdictionaryInoutValue = new (regdictionaryType);
    InOutParameter regnamespaceInoutValue = new (regnamespaceType);
    InOutParameter regoperInoutValue = new (regoperType);
    InOutParameter regoperatorInoutValue = new (regoperatorType);
    InOutParameter regprocInoutValue = new (regprocType);
    InOutParameter regprocedureInoutValue = new (regprocedureType);
    InOutParameter regroleInoutValue = new (regroleType);
    InOutParameter regtypeInoutValue = new (regtypeType);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call ObjectidentifierInoutProcedure(${rowIdInoutValue}, ${oidInoutValue}, ${regclassInoutValue}, ${regconfigInoutValue}, ${regdictionaryInoutValue},
                                ${regnamespaceInoutValue}, ${regoperInoutValue}, ${regoperatorInoutValue}, ${regprocInoutValue}, ${regprocedureInoutValue},
                                 ${regroleInoutValue}, ${regtypeInoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(oidInoutValue.get(string), "12", "OID Datatype with string Doesn't Match");
    test:assertEquals(oidInoutValue.get(int), 12, "OID Datatype with int Doesn't Match");
    test:assertEquals(regclassInoutValue.get(string), "pg_type", "Reg class Datatype Doesn't Match");
    test:assertEquals(regconfigInoutValue.get(string), "english", "Reg config Datatype Doesn;t Match");
    test:assertEquals(regdictionaryInoutValue.get(string), "simple", "Reg Dictionary Datatype Doesn't Match");
    test:assertEquals(regnamespaceInoutValue.get(string), "pg_catalog", "Reg namespace Datatype Doesn;t Match");
    test:assertEquals(regoperInoutValue.get(string), "||/", "Reg oper Datatype Doesn't Match");
    test:assertEquals(regoperatorInoutValue.get(string), "*(integer,integer)", "Reg operator Datatype Doesn;t Match");
    test:assertEquals(regprocInoutValue.get(string), "now", "Reg proc Datatype Doesn't Match");
    test:assertEquals(regprocedureInoutValue.get(string), "sum(integer)", "Reg procedure Datatype Doesn;t Match");
    test:assertEquals(regroleInoutValue.get(string), "postgres", "Reg role Datatype Doesn't Match");
    test:assertEquals(regtypeInoutValue.get(string), "integer", "Reg type Datatype Doesn;t Match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testGeometricProcedureInoutCall]
}
function testXmlProcedureInoutCall() returns error? {
    int rowId = 36;
    xml xmlValue = xml `<tag1>This is tag1<tag2>This is tag 2</tag2></tag1>`;
    PGXmlValue xmlType = new (xmlValue);

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter xmlInoutValue = new (xmlType);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call XmlInoutProcedure(${rowIdInoutValue}, ${xmlInoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(xmlInoutValue.get(XML), xmlValue, "Xml Datatype doesn't match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testRangeProcedureInoutCall]
}
function testBinaryProcedureInoutCall() returns error? {
    int rowId = 10;
    byte[] byteArray = [1, 2, 3, 4, 5];
    sql:BinaryValue byteaType = new (byteArray);

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter byteaInoutValue = new (byteaType);
    InOutParameter byteaEscapeInoutValue = new (byteaType);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call BinaryInoutProcedure(${rowIdInoutValue}, ${byteaInoutValue}, ${byteaEscapeInoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);
    test:assertTrue(byteaInoutValue.get(string) is string, "Binary Datatype Doesn't Match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testBinaryProcedureInoutCall]
}
function testMoneyProcedureInoutCall() returns error? {
    int rowId = 36;
    string moneyValue = "$100.67";
    MoneyValue moneyType = new (moneyValue);

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter moneyInoutValue = new (moneyType);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call MoneyInoutProcedure(${rowIdInoutValue}, ${moneyInoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(moneyInoutValue.get(string), "100.67", "Money Datatype doesn't match");
    test:assertEquals(moneyInoutValue.get(float), 100.67, "Money Datatype doesn't match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testBinaryProcedureInoutCall]
}
function testEnumProcedureInoutCall() returns error? {
    int rowId = 36;
    Enum enumRecord = {value: "value2"};
    EnumValue enumValue = new (sqlTypeName = "value", value = enumRecord);

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter enumInoutValue = new (enumValue);

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call EnumInoutProcedure(${rowIdInoutValue}, ${enumInoutValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(enumInoutValue.get(string), "value2", "Enum Datatype doesn't match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testEnumProcedureCall]
}
function testCustomrocedureCall() returns error? {
    int rowId = 35;
    CustomValues complexValue = {values: [1, 1]};
    CustomValues inventoryValue = {values: ["Name", 2, true]};
    CustomTypeValue complexTypeValue = new (value = complexValue, sqlTypeName = "complex");
    CustomTypeValue inventoryTypeValue = new (value = inventoryValue, sqlTypeName = "inventory_item");

    sql:ParameterizedCallQuery sqlQuery = 
    `
      call CustomProcedure(${rowId}, ${complexTypeValue}, ${inventoryTypeValue});
    `;
    _ = check callProcedure(sqlQuery, proceduresDatabase);
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testCustomrocedureCall]
}
public function testTimestampRetrieval() returns error? {
    string datetimetz = "2004-10-19T10:23:54+02:00";

    InOutParameter rowIdInoutValue = new (1);
    sql:DateTimeValue datetimetzValue = new ();
    InOutParameter datetimetzInoutValue = new (datetimetzValue);

    sql:ParameterizedCallQuery sqlQuery = `CALL timestampSelectProcedure (${rowIdInoutValue}, ${datetimetzInoutValue});`;
    _ = check callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(check datetimetzInoutValue.get(time:Utc), check time:utcFromString(datetimetz), 
                    "Retrieved date time with timestamp does not match.");
}

@test:Config {
    groups: ["procedures"]
}
public function testInOutParameterArray() returns error? {
    int rowId = 1;
    PointArrayValue pointArrayValue = new ([{x: 1, y: 2}, {x: 2, y: 3}]);
    LineArrayValue lineArrayValue = new ([{a: 1, b: 2, c: 3}, {a: 1, b: 2, c: 3}]);
    LineSegmentArrayValue lsegArrayValue = new ([{x1: 1, x2: 1, y1: 2, y2: 2}, {x1: 1, x2: 1, y1: 2, y2: 2}]);
    BoxArrayValue boxArrayValue = new ([{x1: 2, x2: 3, y1: 2, y2: 3}]);
    Point[] points = [{x: 2, y: 2}, {x: 2, y: 2}];
    PathArrayValue pathArrayValue = new ([points]);
    points = [{x: 1, y: 4}, {x: 2, y: 2}];
    PolygonArrayValue polygonArrayValue = new ([points]);
    CircleArrayValue circleArrayValue = new ([{x: 1, y: 1, r: 1}, {x: 1, y: 1, r: 1}]);
    Interval interval = {years: 1, months: 2, days: 3, hours: 4, minutes: 5, seconds: 6};
    IntervalArrayValue intervalArrayValue = new ([interval, interval]);
    IntegerRange integerRange = {upper: 2, lower: -1, upperboundInclusive: true};
    IntegerRangeArrayValue integerRangeArrayValue = new ([integerRange, integerRange]);
    LongRange longRange = {upper: 12000, lower: 10000, lowerboundInclusive: true};
    LongRangeArrayValue longRangeArrayValue = new ([longRange, longRange]);
    NumericRange numericalRange = {upper: 221.34, lower: 10.17, upperboundInclusive: true, lowerboundInclusive: true};
    NumericRangeArrayValue numericalRangeArrayValue = new ([numericalRange, numericalRange]);
    TimestamptzRange timestamptzRange = {lower: "2010-01-01 20:00:00+01:30", upper: "2010-01-01 23:00:00+02:30", upperboundInclusive: true, lowerboundInclusive: true};
    TsTzRangeArrayValue timestamptzRangeArrayValue = new ([timestamptzRange, timestamptzRange]);
    TimestampRange timestampRange = {lower: "2010-01-01 20:00:00", upper: "2010-01-01 23:00:00"};
    TsRangeArrayValue timestamprangeArrayValue = new ([timestampRange, timestampRange]);
    DateRange dateRange = {lower: "2010-01-01", upper: "2010-01-05"};
    DateRangeArrayValue daterangeArrayValue = new ([dateRange, dateRange]);
    InetArrayValue inetArrayValue = new (["192.168.2.1/24", "192.168.5.1/24"]);
    CidrArrayValue cidrArrayValue = new (["::ffff:1.2.3.0/120", "::ffff:1.2.3.0/120"]);
    MacAddrArrayValue macaddrArrayValue = new (["08:00:2b:01:02:00", "08:00:2b:01:02:00"]);
    MacAddr8ArrayValue macaddr8ArrayValue = new (["08-00-2b-01-02-03-04-04", "08-00-2b-01-02-03-04-04"]);
    UuidArrayValue uuidArrayValue = new (["a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a14", "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a14"]);
    TsVectorArrayValue tsvectorArrayValue = new (["a fat cat sat on a mat and ate a fat rat", "a fat cat sat on a mat and ate a fat rat"]);
    TsQueryArrayValue tsqueryArrayValue = new (["fat & rat", "fat & rat"]);
    BitStringArrayValue bitstringArrayValue = new (["1", "0"]);
    VarBitStringArrayValue varbitstringArrayValue = new (["1", "0"]);
    PGBitArrayValue bitArrayValue = new ([false, false]);
    RegClassArrayValue regclassArrayValue = new (["pg_type", "pg_type"]);
    RegConfigArrayValue regconfigArrayValue = new (["english", "english"]);
    RegDictionaryArrayValue regdictionaryArrayValue = new (["simple", "simple"]);
    RegNamespaceArrayValue regnamespaceArrayValue = new (["pg_catalog", "pg_catalog"]);
    RegOperArrayValue regoperArrayValue = new (["||/", "||/"]);
    RegOperatorArrayValue regoperatorArrayValue = new (["*(integer,integer)", "*(integer,integer)"]);
    RegProcArrayValue regprocArrayValue = new (["now", "now"]);
    RegProcedureArrayValue regprocedureArrayValue = new (["sum(integer)", "sum(integer)"]);
    RegRoleArrayValue regroleArrayValue = new (["postgres", "postgres"]);
    RegTypeArrayValue regtypeArrayValue = new (["integer", "integer"]);
    xml xmlVal = xml `<foo><tag>bar</tag><tag>tag</tag></foo>`;
    PGXmlArrayValue xmlArrayValue = new ([xmlVal, xmlVal]);
    int[] oidArrayValue = [1, 2, 3];

    InOutParameter inet_array = new (inetArrayValue);
    InOutParameter cidr_array = new (cidrArrayValue);
    InOutParameter macaddr_array = new (macaddrArrayValue);
    InOutParameter macaddr8_array = new (macaddr8ArrayValue);
    InOutParameter uuid_array = new (uuidArrayValue);
    InOutParameter tsvector_array = new (tsvectorArrayValue);
    InOutParameter tsquery_array = new (tsqueryArrayValue);
    InOutParameter bitstring_array = new (bitstringArrayValue);
    InOutParameter varbitstring_array = new (varbitstringArrayValue);
    InOutParameter bit_array = new (bitArrayValue);
    InOutParameter xml_array = new (xmlArrayValue);
    InOutParameter oid_array = new (oidArrayValue);
    InOutParameter regclass_array = new (regclassArrayValue);
    InOutParameter regconfig_array = new (regconfigArrayValue);
    InOutParameter regdictionary_array = new (regdictionaryArrayValue);
    InOutParameter regnamespace_array = new (regnamespaceArrayValue);
    InOutParameter regoper_array = new (regoperArrayValue);
    InOutParameter regoperator_array = new (regoperatorArrayValue);
    InOutParameter regproc_array = new (regprocArrayValue);
    InOutParameter regprocedure_array = new (regprocedureArrayValue);
    InOutParameter regrole_array = new (regroleArrayValue);
    InOutParameter regtype_array = new (regtypeArrayValue);
    InOutParameter point_array = new (pointArrayValue);
    InOutParameter line_array = new (lineArrayValue);
    InOutParameter lseg_array = new (lsegArrayValue);
    InOutParameter box_array = new (boxArrayValue);
    InOutParameter path_array = new (pathArrayValue);
    InOutParameter polygon_array = new (polygonArrayValue);
    InOutParameter circle_array = new (circleArrayValue);
    InOutParameter interval_array = new (intervalArrayValue);
    InOutParameter integer_range_array = new (integerRangeArrayValue);
    InOutParameter long_range_array = new (longRangeArrayValue);
    InOutParameter numerical_range_array = new (numericalRangeArrayValue);
    InOutParameter timestamptz_range_array = new (timestamptzRangeArrayValue);
    InOutParameter timestamp_range_array = new (timestamprangeArrayValue);
    InOutParameter date_range_array = new (daterangeArrayValue);

    sql:ParameterizedCallQuery sqlQuery = `CALL InOutArrayProcedure(${rowId}, ${inet_array}, ${cidr_array},
    ${macaddr_array}, ${macaddr8_array}, ${uuid_array}, ${tsvector_array}, ${tsquery_array}, ${bitstring_array},
    ${varbitstring_array}, ${bit_array}, ${xml_array}, ${oid_array}, ${regclass_array}, ${regconfig_array},
    ${regdictionary_array}, ${regnamespace_array}, ${regoper_array}, ${regoperator_array}, ${regproc_array},
    ${regprocedure_array}, ${regrole_array}, ${regtype_array}, ${point_array}, ${line_array}, ${lseg_array},
    ${box_array}, ${path_array}, ${polygon_array}, ${circle_array}, ${interval_array}, ${integer_range_array},
    ${long_range_array}, ${numerical_range_array}, ${timestamptz_range_array}, ${timestamp_range_array},
    ${date_range_array})`;

    Client dbClient = check new (host, user, password, proceduresDatabase, port, connectionPool = {
        maxOpenConnections: 25,
        maxConnectionLifeTime: 30,
        minIdleConnections: 15
    });
    _ = check dbClient->call(sqlQuery, []);

    test:assertEquals(inet_array.get(StringArray), ["192.168.0.1/24", "192.168.0.1/24"], "Inet array does not match.");
    test:assertEquals(cidr_array.get(StringArray), ["::ffff:1.2.3.0/120", "::ffff:1.2.3.0/120"], 
    "CIDR array does not match.");
    test:assertEquals(macaddr_array.get(StringArray), ["08:00:2b:01:02:03", "08:00:2b:01:02:03"], 
    "Mac address array does not match.");
    test:assertEquals(macaddr8_array.get(StringArray), ["08:00:2b:01:02:03:04:05", "08:00:2b:01:02:03:04:05"], 
    "Mac address8 array does not match.");
    test:assertEquals(uuid_array.get(StringArray), ["a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11", 
    "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11"], "UUID array does not match.");
    test:assertEquals(tsvector_array.get(StringArray), ["'a' 'and' 'ate' 'cat' 'fat' 'mat' 'on' 'rat' 'sat'", 
    "'a' 'and' 'ate' 'cat' 'fat' 'mat' 'on' 'rat' 'sat'"], "Tsvector array does not match.");
    test:assertEquals(tsquery_array.get(StringArray), ["'fat' & 'rat'", "'fat' & 'rat'"], 
    "Tsquery array does not match.");
    test:assertEquals(bitstring_array.get(StringArray), ["true", "false"], "Bitstring array does not match.");
    test:assertEquals(varbitstring_array.get(StringArray), ["1001", "1110"], "Varbitstring array does not match.");
    test:assertEquals(bit_array.get(StringArray), ["true", "false"], "Bit array does not match.");
    test:assertEquals(xml_array.get(StringArray), ["<foo><tag>bar</tag><tag>tag</tag></foo>", 
    "<foo><tag>bar</tag><tag>tag</tag></foo>"], "XML array does not match.");
    test:assertEquals(oid_array.get(StringArray), ["12", "12"], "Oid array does not match.");
    test:assertEquals(regclass_array.get(StringArray), ["pg_type", "pg_type"], "Reg class array does not match.");
    test:assertEquals(regdictionary_array.get(StringArray), ["simple", "simple"], 
    "Reg dictionary array does not match.");
    test:assertEquals(regconfig_array.get(StringArray), ["english", "english"], "Reg config array does not match.");
    test:assertEquals(regnamespace_array.get(StringArray), ["pg_catalog", "pg_catalog"], 
    "Reg namespace array does not match.");
    test:assertEquals(regoper_array.get(StringArray), ["||/", "||/"], "Regoper array does not match.");
    test:assertEquals(regoperator_array.get(StringArray), ["*(integer,integer)", "*(integer,integer)"], 
    "Regoperator array does not match.");
    test:assertEquals(regproc_array.get(StringArray), ["now", "now"], "Regproc array does not match.");
    test:assertEquals(regprocedure_array.get(StringArray), ["sum(integer)", "sum(integer)"], 
    "Regproducer array does not match.");
    test:assertEquals(regrole_array.get(StringArray), ["postgres", "postgres"], 
    "Regrole array does not match.");
    test:assertEquals(regtype_array.get(StringArray), ["integer", "integer"], "Regtype array does not match.");
    test:assertEquals(point_array.get(StringArray), ["(1.0,2.0)", "(3.0,4.0)"], "Point array does not match.");
    test:assertEquals(line_array.get(StringArray), ["{1.0,2.0,3.0}", "{1.0,2.0,3.0}"], "Line array does not match.");
    test:assertEquals(lseg_array.get(StringArray), ["[(1.0,2.0),(3.0,4.0)]", "[(1.0,2.0),(3.0,4.0)]"], 
    "Line segment array does not match.");
    test:assertEquals(path_array.get(StringArray), ["((1.0,2.0))", "((3.0,4.0))"], "Path array does not match.");
    test:assertEquals(box_array.get(StringArray), ["(2.0,2.0),(1.0,2.0)", "(2.0,2.0),(1.0,2.0)"], 
    "Box array does not match.");
    test:assertEquals(circle_array.get(StringArray), ["<(0.0,0.0),2.0>", "<(0.0,0.0),2.0>"], 
    "Circle array does not match.");
    test:assertEquals(polygon_array.get(StringArray), ["((1.0,2.0),(3.0,4.0))", "((1.0,2.0),(3.0,4.0))"], 
    "Polygon array does not match.");
    test:assertEquals(interval_array.get(StringArray), ["1 years 2 mons 3 days 4 hours 5 mins 6.0 secs", 
    "1 years 2 mons 3 days 4 hours 5 mins 6.0 secs"], "Interval array does not match.");
    test:assertEquals(integer_range_array.get(StringArray), ["[2,4)"], "Integer range array does not match.");
    test:assertEquals(long_range_array.get(StringArray), ["[10001,30000)"], "Long range array does not match.");
    test:assertEquals(numerical_range_array.get(StringArray), ["(1.11,3.33]"], "Numerical range array does not match.");
    test:assertTrue(timestamptz_range_array.get(StringArray) is string[], "Timestamp timezone array does not match.");
    test:assertTrue(timestamp_range_array.get(StringArray) is string[], "Timestamp range array does not match.");
    test:assertTrue(date_range_array.get(StringArray) is string[], "Date range array does not match.");
    Point[] pointArray = [{"x": 1.0, "y": 2.0}, {"x": 3.0, "y": 4.0}];
    test:assertEquals(point_array.get(PointArray), pointArray, "Point array does not match.");
    Line[] lineArray = [{"a": 1.0, "b": 2.0, "c": 3.0}, {"a": 1.0, "b": 2.0, "c": 3.0}];
    test:assertEquals(line_array.get(LineArray), lineArray, "Line array does not match.");
    LineSegment[] lineSegmentArray = [{"x1": 1.0, "y1": 2.0, "x2": 3.0, "y2": 4.0}, {"x1": 1.0, "y1": 2.0, "x2": 3.0, "y2": 4.0}];
    test:assertEquals(lseg_array.get(LineSegmentArray), lineSegmentArray, "Line segment array does not match.");
    Path[] pathArray = [{"open": false, "points": [{"x": 1.0, "y": 2.0}]}, {"open": false, "points": [{"x": 3.0, "y": 4.0}]}];
    test:assertEquals(path_array.get(PathArray), pathArray, "Path array does not match.");
    Polygon[] polygonArray = [{"points": [{"x": 1.0, "y": 2.0}, {"x": 3.0, "y": 4.0}]}, 
    {"points": [{"x": 1.0, "y": 2.0}, {"x": 3.0, "y": 4.0}]}];
    test:assertEquals(polygon_array.get(PolygonArray), polygonArray, "Polygon array does not match.");
    Circle[] circlArray = [{"x": 0, "y": 0, "r": 2.0}, {"x": 0, "y": 0, "r": 2.0}];
    test:assertEquals(circle_array.get(CircleArray), circlArray, "Circle array does not match.");
    Interval[] intervalArray = [{"years": 1, "months": 2, "days": 3, "hours": 4, "minutes": 5, "seconds": 6.0}, 
    {"years": 1, "months": 2, "days": 3, "hours": 4, "minutes": 5, "seconds": 6.0}];
    test:assertEquals(interval_array.get(IntervalArray), intervalArray, "Interval array does not match.");
    IntegerRange[] integerArray = [{"upper": 4, "lower": 2, "upperboundInclusive": false, "lowerboundInclusive": true}];
    test:assertEquals(integer_range_array.get(IntegerRangeArray), integerArray, "Integer range array does not match.");
    LongRange[] longArray = [{"upper": 30000, "lower": 10001, "upperboundInclusive": false, "lowerboundInclusive": true}];
    test:assertEquals(long_range_array.get(LongRangeArray), longArray, "Long range array does not match.");
    NumericRange[] numericArray = [{"upper": 3.33, "lower": 1.11, "upperboundInclusive": true, "lowerboundInclusive": false}];
    test:assertEquals(numerical_range_array.get(NumericalRangeArray), numericArray, "Numerical array does not match.");
    TimestamptzRange[] tsTzRange = [{
        "upper": "2010-01-01 14:00:00+00",
        "lower": "2010-01-01 12:00:00+00",
        "upperboundInclusive": true,
        "lowerboundInclusive": false
    }];
    test:assertEquals(timestamptz_range_array.get(TsTzRangeArray), tsTzRange, "Timestamp timezone range array " + 
    "does not match.");
    TimestampRange[] tsRange = [{
        "upper": "2010-01-01 15:30:00",
        "lower": "2010-01-01 14:30:00",
        "upperboundInclusive": true,
        "lowerboundInclusive": false
    }];
    test:assertEquals(timestamp_range_array.get(TsRangeArray), tsRange, "Timestamp range array does not match.");
    DateRange[] dateRangeArray = [{
        "upper": "2010-01-04",
        "lower": "2010-01-02",
        "upperboundInclusive": false,
        "lowerboundInclusive": true
    }];
    test:assertEquals(date_range_array.get(DateRangeArray), dateRangeArray, "Date range array does not match.");
    check dbClient.close();
}

function queryProcedureClient(sql:ParameterizedQuery sqlQuery, string database, typedesc<record {}>? resultType = ()) 
returns record {}|error {
    Client dbClient = check new (host, user, password, database, port);
    stream<record {}, error?> streamData;
    if resultType is () {
        streamData = dbClient->query(sqlQuery);
    } else {
        streamData = dbClient->query(sqlQuery, resultType);
    }
    record {|record {} value;|}? data = check streamData.next();
    check streamData.close();
    record {}? value = data?.value;
    check dbClient.close();
    if value is () {
        return {};
    } else {
        return value;
    }
}

function callProcedure(sql:ParameterizedCallQuery sqlQuery, string database, typedesc<record {}>[] rowTypes = []) returns sql:ProcedureCallResult|error {
    Client dbClient = check new (host, user, password, database, port, connectionPool = {
        maxOpenConnections: 25,
        maxConnectionLifeTime: 30,
        minIdleConnections: 15
    });
    sql:ProcedureCallResult result = check dbClient->call(sqlQuery, rowTypes);
    check dbClient.close();
    return result;
}
