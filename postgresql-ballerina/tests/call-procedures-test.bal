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

    sql:ProcedureCallResult ret = callProcedure(callQuery, proceduresDatabase, [StringDataForCall]);
    stream<record{}, sql:Error>? qResult = ret.queryResult;
    if (qResult is ()) {
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
    int row_id = 1;
    sql:ParameterizedCallQuery callQuery = `
        select * from multipleSelectProcedure();
    `;
    sql:ProcedureCallResult ret = callProcedure(callQuery, proceduresDatabase, [StringDataForCall, StringDataForCall]);

    stream<record{}, sql:Error>? qResult = ret.queryResult;
    if (qResult is ()) {
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
    if (qResult is ()) {
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
    int row_id = 1;
    sql:ParameterizedCallQuery callQuery = `
        select * from multipleQuerySelectProcedure();
    `;
    sql:ProcedureCallResult ret = callProcedure(callQuery, proceduresDatabase, [StringData, StringData]);

    stream<record{}, sql:Error>? qResult = ret.queryResult;
    if (qResult is ()) {
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
    if (qResult is ()) {
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
function testNumericProcedureCall() {
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
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

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
    test:assertEquals(queryProcedureClient(query, proceduresDatabase, NumericProcedureRecord), expectedDataRow, "Numeric Call procedure insert and query did not match.");

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
function testCharacterProcedureCall() {
    int rowId = 35;
    sql:CharValue charValue = new("This is a char3");
    sql:VarcharValue varcharValue = new("This is a varchar3");
    string textValue = "This is a text3";
    string nameValue = "This is a name3";

    sql:ParameterizedCallQuery sqlQuery =
      `
      call CharacterProcedure(${rowId}, ${charValue}, ${varcharValue}, ${textValue}, ${nameValue});
    `;
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

    sql:ParameterizedQuery query = `SELECT row_id, char_type, varchar_type, text_type, name_type from CharacterTypes where row_id = ${rowId}`;

    CharacterProcedureRecord expectedDataRow = {
        row_id: rowId,
        char_type: "This is a char3",
        varchar_type: "This is a varchar3",
        text_type: "This is a text3",
        name_type: "This is a name3"
    };
    test:assertEquals(queryProcedureClient(query, proceduresDatabase, CharacterProcedureRecord), expectedDataRow, "Character Call procedure insert and query did not match.");
}

public type BooleanProcedureRecord record {
    int row_id;
    boolean boolean_type;
};

@test:Config {
    groups: ["procedures"],
    dependsOn: [testCharacterProcedureCall]
}
function testBooleanProcedureCall() {
    int rowId = 35;
    boolean booleanType = false;

    sql:ParameterizedCallQuery sqlQuery =
      `
      call BooleanProcedure(${rowId}, ${booleanType});
    `;
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

    sql:ParameterizedQuery query = `SELECT row_id, boolean_type from BooleanTypes where row_id = ${rowId}`;

    BooleanProcedureRecord expectedDataRow = {
        row_id: rowId,
        boolean_type: false
    };
    test:assertEquals(queryProcedureClient(query, proceduresDatabase, BooleanProcedureRecord), expectedDataRow, "Boolean Call procedure insert and query did not match.");
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
function testNetworkProcedureCall() {
    int rowId = 35;
    InetValue inetValue = new ("192.168.0.2/24");
    CidrValue cidrValue = new ("::ffff:1.2.3.0/120");
    MacaddrValue macaddrValue = new ("08:00:2b:01:02:03");
    Macaddr8Value macaddr8Value = new ("08-00-2b-01-02-03-04-00");

    sql:ParameterizedCallQuery sqlQuery =
      `
      call NetworkProcedure(${rowId}, ${inetValue}, ${cidrValue}, ${macaddrValue}, ${macaddr8Value});
    `;
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

    sql:ParameterizedQuery query = `SELECT row_id, inet_type, cidr_type, macaddr_type, macaddr8_type from NetworkTypes where row_id = ${rowId}`;

    NetworkProcedureRecord expectedDataRow = {
        row_id: rowId,
        inet_type: "192.168.0.2/24",
        cidr_type: "::ffff:1.2.3.0/120",
        macaddr_type: "08:00:2b:01:02:03",
        macaddr8_type: "08:00:2b:01:02:03:04:00"
    };
    test:assertEquals(queryProcedureClient(query, proceduresDatabase, NetworkProcedureRecord), expectedDataRow, "Network Call procedure insert and query did not match.");
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
function testGeometricProcedureCall() {
    int rowId = 35;
    PointValue pointType = new ({x: 2, y:2});
    LineValue lineType = new ({a:2, b:3, c:4});
    LsegValue lsegType = new ({x1: 2, x2: 3, y1: 2, y2:3});
    BoxValue boxType = new ({x1: 2, x2: 3, y1: 2, y2:3});
    PathValue pathType = new ({isOpen: true, points: [{x: 1, y:1}, {x: 2, y:2}]});
    PolygonValue polygonType = new ([{x: 1, y:1}, {x: 2, y:2}]);
    CircleValue circleType = new ({x: 2, y:2, r:2});

    sql:ParameterizedCallQuery sqlQuery =
      `
      call GeometricProcedure(${rowId}, ${pointType}, ${lineType}, ${lsegType}, ${boxType}, ${pathType}, ${polygonType}, ${circleType});
    `;
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

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
    test:assertEquals(queryProcedureClient(query, proceduresDatabase, GeometricProcedureRecord), expectedDataRow, "Geometric Call procedure insert and query did not match.");
}

public type UuidProcedureRecord record {
    int row_id;
    string uuid_type;
};

@test:Config {
    groups: ["procedures"],
    dependsOn: [testGeometricProcedureCall]
}
function testUuidProcedureCall() {
    int rowId = 35;
    UuidValue uuidType = new ("a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12");

    sql:ParameterizedCallQuery sqlQuery =
      `
      call UuidProcedure(${rowId}, ${uuidType});
    `;
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

    sql:ParameterizedQuery query = `SELECT row_id, uuid_type from UuidTypes where row_id = ${rowId}`;

    UuidProcedureRecord expectedDataRow = {
        row_id: rowId,
        uuid_type: "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12"
    };
    test:assertEquals(queryProcedureClient(query, proceduresDatabase, UuidProcedureRecord), expectedDataRow, "Uuid Call procedure insert and query did not match.");
}

public type PglsnProcedureRecord record {
    int row_id;
    string pglsn_type;
};

@test:Config {
    groups: ["procedures"],
    dependsOn: [testUuidProcedureCall]
}
function testPglsnProcedureCall() {
    int rowId = 35;
    PglsnValue pglsnType = new ("16/B374D848");

    sql:ParameterizedCallQuery sqlQuery =
      `
      call PglsnProcedure(${rowId}, ${pglsnType});
    `;
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

    sql:ParameterizedQuery query = `SELECT row_id, pglsn_type from PglsnTypes where row_id = ${rowId}`;

    PglsnProcedureRecord expectedDataRow = {
        row_id: rowId,
        pglsn_type: "16/B374D848"
    };
    test:assertEquals(queryProcedureClient(query, proceduresDatabase, PglsnProcedureRecord), expectedDataRow, "Pglsn Call procedure insert and query did not match.");
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
function testJsonProcedureCall() {
    int rowId = 35;
    json jsonValue = {"a":11,"b":2};
    JsonValue jsonType = new(jsonValue);
    JsonbValue jsonbType = new(jsonValue);
    JsonpathValue jsonpathType = new("$.\"floor\"[*].\"apt\"[*]?(@.\"area\" > 40 && @.\"area\" < 90)?(@.\"rooms\" > 10)");

    sql:ParameterizedCallQuery sqlQuery =
      `
      call JsonProcedure(${rowId}, ${jsonType}, ${jsonbType}, ${jsonpathType});
    `;
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

    sql:ParameterizedQuery query = `SELECT row_id, json_type, jsonb_type, jsonpath_type from JsonTypes where row_id = ${rowId}`;

    JsonProcedureRecord expectedDataRow = {
        row_id: rowId,
        json_type: jsonValue,
        jsonb_type: jsonValue,
        jsonpath_type: "$.\"floor\"[*].\"apt\"[*]?(@.\"area\" > 40 && @.\"area\" < 90)?(@.\"rooms\" > 10)"
    };
    test:assertEquals(queryProcedureClient(query, proceduresDatabase, JsonProcedureRecord), expectedDataRow, "Json Call procedure insert and query did not match.");
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
function testBitProcedureCall() {
    int rowId = 35;
    VarbitstringValue bitstringType = new("1110001100");
    VarbitstringValue varbitstringType = new("111110");
    PGBitValue bitType = new("1");

    sql:ParameterizedCallQuery sqlQuery =
      `
      call BitProcedure(${rowId}, ${varbitstringType}, ${bitType});
    `;
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

    sql:ParameterizedQuery query = `SELECT row_id, varbitstring_type, bit_type from BitTypes where row_id = ${rowId}`;

    BitProcedureRecord expectedDataRow = {
        row_id: rowId,
        varbitstring_type: "111110",
        bit_type: true
    };
    test:assertEquals(queryProcedureClient(query, proceduresDatabase, BitProcedureRecord), expectedDataRow, "Bit Call procedure insert and query did not match.");
}

public type DatetimeProcedureRecord record {
  int row_id;
  string date_type;
  string time_type;
  string timetz_type;
  string timestamp_type;
  string timestamptz_type;
  string interval_type;
};

@test:Config {
    groups: ["procedures"],
    dependsOn: [testBitProcedureCall]
}
function testDatetimeProcedureCall() {

    time:Time|error timeValue = time:createTime(2017, 3, 28, 23, 42, 45,554, "Asia/Colombo");
    if (timeValue is time:Time) {
        int rowId = 35;
        sql:TimestampValue timestampType = new(timeValue);
        sql:TimestampValue timestamptzType = new(timeValue);
        sql:DateValue dateType = new(timeValue);
        sql:TimeValue timeType = new(timeValue);
        sql:TimeValue timetzType= new(timeValue);
        IntervalValue intervalType= new({years:1, months:2, days:3, hours:4, minutes:5, seconds:6});

        sql:ParameterizedCallQuery sqlQuery =
        `
        call DatetimeProcedure(${rowId}, ${dateType}, ${timeType}, ${timetzType}, ${timestampType}, ${timestamptzType}, ${intervalType});
        `;
        sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

        sql:ParameterizedQuery query = `SELECT row_id, date_type, time_type, timetz_type, timestamp_type, 
                timestamptz_type, interval_type from DatetimeTypes where row_id = ${rowId}`;

        DatetimeProcedureRecord expectedDataRow = {
            row_id: rowId,
            date_type: "2017-03-28+05:30",
            time_type: "05:12:45.554+05:30",
            timetz_type: "23:42:45.554+05:30",
            timestamp_type: "2017-03-29T05:12:45.554+05:30",
            timestamptz_type: "2017-03-28T23:42:45.554+05:30",
            interval_type: "1 year 2 mons 3 days 04:05:06"
        };
        test:assertEquals(queryProcedureClient(query, proceduresDatabase, DatetimeProcedureRecord), expectedDataRow, "Datetime Call procedure insert and query did not match.");
    }
    else {
        test:assertFail("Invalid Time value generated ");
    }
}

public type RangeProcedureRecord record {
  int row_id;
  string int4range_type;
  string int8range_type;
  string numrange_type;
  string tsrange_type;
  string tstzrange_type;
  string daterange_type;
};

@test:Config {
    groups: ["procedures"],
    dependsOn: [testDatetimeProcedureCall]
}
function testRangeProcedureCall() {

        int rowId = 35;
        Int4rangeValue int4rangeType = new("(2,50)");
        Int8rangeValue int8rangeType = new("(10,100)");
        NumrangeValue numrangeType = new("(0.1,2.4)");
        TsrangeValue tsrangeType = new("(2010-01-01 14:30, 2010-01-01 15:30)");
        TstzrangeValue tstzrangeType= new("(2010-01-01 14:30, 2010-01-01 15:30)");
        DaterangeValue daterangeType= new("(2010-01-01 14:30, 2010-01-03 )");
        
        sql:ParameterizedCallQuery sqlQuery =
        `
        call RangeProcedure(${rowId}, ${int4rangeType}, ${int8rangeType}, ${numrangeType}, ${tsrangeType}, ${tstzrangeType}, ${daterangeType});
        `;
        sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

        sql:ParameterizedQuery query = `SELECT row_id, int4range_type, int8range_type, numrange_type, tsrange_type, 
                tstzrange_type, daterange_type from RangeTypes where row_id = ${rowId}`;

        RangeProcedureRecord expectedDataRow = {
            row_id: rowId,
            int4range_type: "[3,50)",
            int8range_type: "[11,100)",
            numrange_type: "(0.1,2.4)",
            tsrange_type: "(\"2010-01-01 14:30:00\",\"2010-01-01 15:30:00\")",
            tstzrange_type: "(\"2010-01-01 14:30:00+05:30\",\"2010-01-01 15:30:00+05:30\")",
            daterange_type: "[2010-01-02,2010-01-03)"
        };
        test:assertEquals(queryProcedureClient(query, proceduresDatabase, RangeProcedureRecord), expectedDataRow, "Range Call procedure insert and query did not match.");
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
function testTextsearchProcedureCall() {
    int rowId = 35;
    TsvectorValue tsvectorType = new ("a fat cat sat on a mat and ate a fat rat");
    TsqueryValue tsqueryType = new ("fat & rat");

    sql:ParameterizedCallQuery sqlQuery =
      `
      call TextsearchProcedure(${rowId}, ${tsvectorType}, ${tsqueryType});
    `;
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

    sql:ParameterizedQuery query = `SELECT row_id, tsvector_type, tsquery_type from TextsearchTypes where row_id = ${rowId}`;

    TextsearchProcedureRecord expectedDataRow = {
        row_id: rowId,
        tsvector_type: "'a' 'and' 'ate' 'cat' 'fat' 'mat' 'on' 'rat' 'sat'",
        tsquery_type: "'fat' & 'rat'"
    };
    test:assertEquals(queryProcedureClient(query, proceduresDatabase, TextsearchProcedureRecord), expectedDataRow, "Textsearch Call procedure insert and query did not match.");
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
function testObjectidentifierProcedureCall() {
    int rowId = 35;
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

    sql:ParameterizedCallQuery sqlQuery =
      `
      call ObjectidentifierProcedure(${rowId}, ${oidType}, ${regclassType}, ${regconfigType}, ${regdictionaryType}, 
                                ${regnamespaceType}, ${regoperType}, ${regoperatorType}, ${regprocType}, ${regprocedureType},
                                 ${regroleType}, ${regtypeType});
    `;
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

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
        regoper_type: "!",
        regoperator_type: "*(integer,integer)",
        regproc_type: "now",
        regprocedure_type: "sum(integer)",
        regrole_type: "postgres",
        regtype_type: "integer"
    };
    test:assertEquals(queryProcedureClient(query, proceduresDatabase, ObjectidentifierProcedureRecord), expectedDataRow, "Objectidentifier Call procedure insert and query did not match.");
}

public type XmlProcedureRecord record {
    int row_id;
    xml xml_type;
};

@test:Config {
    groups: ["procedures"],
    dependsOn: [testObjectidentifierProcedureCall]
}
function testXmlProcedureCall() {
    int rowId = 35;
    xml xmlValue = xml `<tag1>This is tag1<tag2>This is tag 2</tag2></tag1>`;
    PGXmlValue xmlType = new (xmlValue);

    sql:ParameterizedCallQuery sqlQuery =
      `
      call XmlProcedure(${rowId}, ${xmlType});
    `;
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

    sql:ParameterizedQuery query = `SELECT row_id, xml_type from XmlTypes where row_id = ${rowId}`;

    XmlProcedureRecord expectedDataRow = {
        row_id: rowId,
        xml_type: xmlValue
    };
    test:assertEquals(queryProcedureClient(query, proceduresDatabase, XmlProcedureRecord), expectedDataRow, "Xml Call procedure insert and query did not match.");
}


@test:Config {
    groups: ["procedures"],
    dependsOn: [testXmlProcedureCall]
}
function testNumericProcedureOutCall() {
    int rowId = 1;
    sql:SmallIntValue smallintType = new ();
    sql:IntegerValue intType = new();
    sql:BigIntValue bigintType = new();
    sql:DecimalValue decimalType = new();
    sql:NumericValue numericType = new();
    sql:RealValue realType = new();
    sql:DoubleValue doubleType = new();

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
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

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
function testCharacterProcedureOutCall() {
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
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(charInoutValue.get(string), "This is a char1", "Char Data type doesnt match.");
    test:assertEquals(varcharInoutValue.get(string), "This is a varchar1", "Varchar Data type doesnt match.");
    test:assertEquals(textInoutValue.get(string), "This is a text1", "Text Data type doesnt match.");
    test:assertEquals(nameInoutValue.get(string), "This is a name1", "Name Data type doesnt match.");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testCharacterProcedureOutCall]
}
function testBooleanProcedureOutCall() {
    int rowId = 1;
    sql:BooleanValue booleanType = new();

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter booleanInoutValue = new (booleanType);

    sql:ParameterizedCallQuery sqlQuery =
      `
      call BooleanOutProcedure(${rowIdInoutValue}, ${booleanInoutValue});
    `;
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(booleanInoutValue.get(boolean), true, "Boolean Datatype doesn't match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testBooleanProcedureOutCall]
}
function testNetworkProcedureOutCall() {
    int rowId = 1;
    InetValue inetValue = new ();
    CidrValue cidrValue = new ();
    MacaddrValue macaddrValue = new ();
    Macaddr8Value macaddr8Value = new ();

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter inetInoutValue = new (inetValue);
    InOutParameter cidrInoutValue = new (cidrValue);
    InOutParameter macaddrInoutValue = new (macaddrValue);
    InOutParameter macaddr8InoutValue = new (macaddr8Value);

    sql:ParameterizedCallQuery sqlQuery =
      `
      call NetworkOutProcedure(${rowIdInoutValue}, ${inetInoutValue}, ${cidrInoutValue}, ${macaddrInoutValue}, ${macaddr8InoutValue});
    `;
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

 
    test:assertEquals(inetInoutValue.get(string), "192.168.0.1/24", "Inet Data type doesnt match.");
    test:assertEquals(cidrInoutValue.get(string), "::ffff:1.2.3.0/120", "Cidr Data type doesnt match.");
    test:assertEquals(macaddrInoutValue.get(string), "08:00:2b:01:02:03", "Macaddress Data type doesnt match.");
    test:assertEquals(macaddr8InoutValue.get(string), "08:00:2b:01:02:03:04:05", "Macadress8 Data type doesnt match.");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testNetworkProcedureOutCall]
}
function testGeometricProcedureOutCall() {
    int rowId = 1;
    PointValue pointType = new ();
    LineValue lineType = new ();
    LsegValue lsegType = new ();
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
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

    PointRecordType pointOutRecord = {x: 1.0, y: 2.0};
    LineType lineOutRecord = {a: 1.0, b: 2.0, c: 3.0};
    LsegRecordType lsegOutRecord = {x1: 1.0, y1: 1.0, x2: 2.0, y2: 2.0};
    BoxRecordType boxOutRecord = {x1: 1.0, y1: 1.0, x2: 2.0, y2: 2.0};
    PathRecordType pathOutRecord = {isOpen: true, points: [{x: 1, y: 1}, {x: 2, y: 2}]};
    PolygonRecordType polygonOutRecord = {points: [{x: 1, y: 1}, {x: 2, y: 2}]};
    CircleRecordType circleOutRecord = {x: 1.0, y: 1.0, r:1.0};

    test:assertEquals(pointInoutValue.get(string), "(1.0,2.0)", "Point Data type doesnt match.");
    test:assertEquals(lineInoutValue.get(string), "{1.0,2.0,3.0}", "Line Data type doesnt match.");
    test:assertEquals(lsegInoutValue.get(string), "[(1.0,1.0),(2.0,2.0)]", "Line Segment Data type doesnt match.");
    test:assertEquals(boxInoutValue.get(string), "(2.0,2.0),(1.0,1.0)", "Box Data type doesnt match.");
    test:assertEquals(pathInoutValue.get(string), "[(1.0,1.0),(2.0,2.0)]", "Path Data type doesnt match.");
    test:assertEquals(polygonInoutValue.get(string), "((1.0,1.0),(2.0,2.0))", "Polygon Data type doesnt match.");
    test:assertEquals(circleInoutValue.get(string), "<(1.0,1.0),1.0>", "Circle Data type doesnt match.");

    test:assertEquals(pointInoutValue.get(PointRecordType), pointOutRecord, "Point Data type doesnt match.");
    test:assertEquals(lineInoutValue.get(LineType), lineOutRecord, "Line Data type doesnt match.");
    test:assertEquals(lsegInoutValue.get(LsegRecordType), lsegOutRecord, "Line Segment Data type doesnt match.");
    test:assertEquals(boxInoutValue.get(BoxRecordType), boxOutRecord, "Box Data type doesnt match.");
    test:assertEquals(pathInoutValue.get(PathRecordType), pathOutRecord, "Path Data type doesnt match.");
    test:assertEquals(polygonInoutValue.get(PolygonRecordType), polygonOutRecord, "Polygon Data type doesnt match.");
    test:assertEquals(circleInoutValue.get(CircleRecordType), circleOutRecord, "Circle Data type doesnt match.");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testGeometricProcedureOutCall]
}
function testUuidProcedureOutCall() {
    int rowId = 1;
    UuidValue uuidType = new ();

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter uuidInoutValue = new (uuidType);

    sql:ParameterizedCallQuery sqlQuery =
      `
      call UuidOutProcedure(${rowIdInoutValue}, ${uuidInoutValue});
    `;
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(uuidInoutValue.get(string), "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11", "UUID Datatype doesn't match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testUuidProcedureOutCall]
}
function testPglsnProcedureOutCall() {
    int rowId = 1;
    PglsnValue pglsnType = new ();

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter pglsnInoutValue = new (pglsnType);

    sql:ParameterizedCallQuery sqlQuery =
      `
      call PglsnOutProcedure(${rowIdInoutValue}, ${pglsnInoutValue});
    `;
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(pglsnInoutValue.get(string), "16/B374D848", "Pg_lsn Data type Doesn't match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testPglsnProcedureOutCall]
}
function testJsonProcedureOutCall() {
    int rowId = 1;
    JsonValue jsonType = new();
    JsonbValue jsonbType = new();
    JsonpathValue jsonpathType = new();

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter jsonInoutValue = new (jsonType);
    InOutParameter jsonbInoutValue = new (jsonbType);
    InOutParameter jsonPathInoutValue = new (jsonpathType);

    sql:ParameterizedCallQuery sqlQuery =
      `
      call JsonOutProcedure(${rowIdInoutValue}, ${jsonInoutValue}, ${jsonbInoutValue}, ${jsonPathInoutValue});
    `;
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

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
function testBitProcedureOutCall() {
    int rowId = 1;
    VarbitstringValue varbitstringType = new();
    PGBitValue bitType = new();

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter varbitInoutValue = new (varbitstringType);
    InOutParameter bitInoutValue = new (bitType);

    sql:ParameterizedCallQuery sqlQuery =
      `
      call BitOutProcedure(${rowIdInoutValue}, ${varbitInoutValue}, ${bitInoutValue});
    `;
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(varbitInoutValue.get(string), "1101", "Bit Vary Datatype Doesn;t Match");
    test:assertEquals(bitInoutValue.get(boolean), true, "Bit Datatype Doesn't Match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testBitProcedureOutCall]
}
function testDatetimeProcedureOutCall() {

        int rowId = 1;
        sql:TimestampValue timestampType = new();
        sql:TimestampValue timestamptzType = new();
        sql:DateValue dateType = new();
        sql:TimeValue timeType = new();
        sql:TimeValue timetzType= new();
        IntervalValue intervalType= new();

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
        sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

        IntervalRecordType intervalRecord = {years: 1, months: 2, days: 3, hours: 4, minutes: 5, seconds: 6};

        test:assertEquals(timestampInoutValue.get(string), "1999-01-08T10:05:06.000+06:00", " Timestamp Datatype Doesn't Match");
        test:assertEquals(timestamptzInoutValue.get(string), "2004-10-19T20:23:54.000+06:00", " Timestamptz Datatype Doesn't Match");
        test:assertEquals(dateInoutValue.get(string), "1999-01-08+06:00", " Date Datatype Doesn't Match");
        test:assertEquals(timeInoutValue.get(string), "09:35:06.000+05:30", " Time Datatype Doesn't Match");
        test:assertEquals(timetzInoutValue.get(string), "19:05:06.000+05:30", " Timetz Datatype Doesn't Match");
        test:assertEquals(intervalInoutValue.get(string), "1 years 2 mons 3 days 4 hours 5 mins 6.0 secs", " Interval Datatype Doesn't Match");

        test:assertTrue(timestampInoutValue.get(time:Time) is time:Time, " Timestamp Datatype Doesn't Match");
        test:assertTrue(timestamptzInoutValue.get(time:Time) is time:Time, " Timestamptz Datatype Doesn't Match");
        test:assertTrue(dateInoutValue.get(time:Time) is time:Time, " Date Datatype Doesn't Match");
        test:assertTrue(timeInoutValue.get(time:Time) is time:Time, " Time Datatype Doesn't Match");
        test:assertTrue(timetzInoutValue.get(time:Time) is time:Time, " Timetz Datatype Doesn't Match");
        test:assertEquals(intervalInoutValue.get(IntervalRecordType), intervalRecord, " Interval Datatype Doesn't Match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testDatetimeProcedureOutCall]
}
function testRangeProcedureOutCall() {

        int rowId = 1;
        Int4rangeValue int4rangeType = new();
        Int8rangeValue int8rangeType = new();
        NumrangeValue numrangeType = new();
        TsrangeValue tsrangeType = new();
        TstzrangeValue tstzrangeType= new();
        DaterangeValue daterangeType= new();

        InOutParameter rowIdInoutValue = new (rowId);
        InOutParameter int4rangeInoutValue = new (int4rangeType);
        InOutParameter int8rangeInoutValue = new (int8rangeType);
        InOutParameter numrangeInoutValue = new (numrangeType);
        InOutParameter tsrangeInoutValue = new (tsrangeType);
        InOutParameter tstzrangeInoutValue = new (tstzrangeType);
        InOutParameter daterangeInoutValue = new (daterangeType);

        Int4rangeType int4RangeRecord = {upper: 50 , lower: 3 , isUpperboundInclusive: false, isLowerboundInclusive: true};        
        Int8rangeType int8RangeRecord = {upper: 100, lower: 11, isUpperboundInclusive: false, isLowerboundInclusive: true};
        NumrangeType numRangeRecord = {upper: 24, lower: 0, isUpperboundInclusive: false, isLowerboundInclusive: false}; 
               
        sql:ParameterizedCallQuery sqlQuery =
        `
        call RangeOutProcedure(${rowIdInoutValue}, ${int4rangeInoutValue}, ${int8rangeInoutValue}, ${numrangeInoutValue}, ${tsrangeInoutValue}, ${tstzrangeInoutValue}, ${daterangeInoutValue});
        `;
        sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

        test:assertEquals(int4rangeInoutValue.get(string), "[3,50)", "Int4range Datatype Doesn't Match");
        test:assertEquals(int8rangeInoutValue.get(string), "[11,100)", "Int8range Datatype Doesn't Match");
        test:assertEquals(numrangeInoutValue.get(string), "(0,24)", "Numrnge Datatype Doesn't Match");
        test:assertEquals(tsrangeInoutValue.get(string), "(\"2010-01-01 14:30:00\",\"2010-01-01 15:30:00\")", "Tsrange Datatype Doesn't Match");
        test:assertEquals(tstzrangeInoutValue.get(string), "(\"2010-01-01 20:00:00+05:30\",\"2010-01-01 21:00:00+05:30\")", "Tstzrange Datatype Doesn't Match");
        test:assertEquals(daterangeInoutValue.get(string), "[2010-01-02,2010-01-03)", "Daterange Datatype Doesn't Match");

        test:assertEquals(int4rangeInoutValue.get(Int4rangeType), int4RangeRecord, "Int4range Datatype Doesn't Match");
        test:assertEquals(int8rangeInoutValue.get(Int8rangeType), int8RangeRecord, "Int8range Datatype Doesn't Match");
        test:assertEquals(numrangeInoutValue.get(NumrangeType), numRangeRecord, "Numrnge Datatype Doesn't Match");
        test:assertTrue(tsrangeInoutValue.get(TsrangeType) is TsrangeType, "Tsrange Datatype Doesn't Match");
        test:assertTrue(tstzrangeInoutValue.get(TstzrangeType) is TstzrangeType, "Tstzrange Datatype Doesn't Match");
        test:assertTrue(daterangeInoutValue.get(DaterangeType) is DaterangeType, "Daterange Datatype Doesn't Match");
}
 
@test:Config {
    groups: ["procedures"],
    dependsOn: [testRangeProcedureOutCall]
}
function testTextsearchProcedureOutCall() {
    int rowId = 1;
    TsvectorValue tsvectorType = new ();
    TsqueryValue tsqueryType = new ();

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter tsvectorInoutValue = new (tsvectorType);
    InOutParameter tsqueryInoutValue = new (tsqueryType);

    sql:ParameterizedCallQuery sqlQuery =
      `
      call TextsearchOutProcedure(${rowIdInoutValue}, ${tsvectorInoutValue}, ${tsqueryInoutValue});
    `;
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(tsvectorInoutValue.get(string), "'a' 'and' 'ate' 'cat' 'fat' 'mat' 'on' 'rat' 'sat'", "Tsvector Datatype Doesn't Match");
    test:assertEquals(tsqueryInoutValue.get(string), "'fat' & 'rat'", "Tsquery Datatype Doesn't Match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testTextsearchProcedureOutCall]
}
function testObjectidentifierProcedureOutCall() {
    int rowId = 1;
    int oidType = 12;
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
    InOutParameter regtypeInoutValue = new(regtypeType);

    sql:ParameterizedCallQuery sqlQuery =
      `
      call ObjectidentifierOutProcedure(${rowIdInoutValue}, ${oidInoutValue}, ${regclassInoutValue}, ${regconfigInoutValue}, ${regdictionaryInoutValue}, 
                                ${regnamespaceInoutValue}, ${regoperInoutValue}, ${regoperatorInoutValue}, ${regprocInoutValue}, ${regprocedureInoutValue},
                                 ${regroleInoutValue}, ${regtypeInoutValue});
    `;
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(oidInoutValue.get(string), "12", "OID Datatype Doesn;t Match");
    test:assertEquals(regclassInoutValue.get(string), "pg_type", "Reg class Datatype Doesn't Match");
    test:assertEquals(regconfigInoutValue.get(string), "english", "Reg config Datatype Doesn;t Match");
    test:assertEquals(regdictionaryInoutValue.get(string), "simple", "Reg Dictionary Datatype Doesn't Match");
    test:assertEquals(regnamespaceInoutValue.get(string), "pg_catalog", "Reg namespace Datatype Doesn;t Match");
    test:assertEquals(regoperInoutValue.get(string), "!", "Reg oper Datatype Doesn't Match");
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
function testXmlProcedureOutCall() {
    int rowId = 1;
    PGXmlValue xmlType = new ();

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter xmlInoutValue = new (xmlType);

    sql:ParameterizedCallQuery sqlQuery =
      `
      call XmlOutProcedure(${rowIdInoutValue}, ${xmlInoutValue});
    `;
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);
    xml xmlValue = xml `<foo><tag>bar</tag><tag>tag</tag></foo>`;
    test:assertEquals(xmlInoutValue.get(xml), xmlValue, "Xml Datatype doesn't match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testObjectidentifierProcedureOutCall]
}
function testNumericProcedureInoutCall() {
    int rowId = 36;
    decimal decimalVal = 1234.567;
    sql:SmallIntValue smallintType = new(1);
    sql:IntegerValue intType = new(1);
    sql:BigIntValue bigintType = new(123456);
    sql:DecimalValue decimalType = new(decimalVal);
    sql:NumericValue numericType = new(decimalVal);
    sql:RealValue realType = new(123.456);
    sql:DoubleValue doubleType = new(123.456);

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
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

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
function testCharacterProcedureInoutCall() {
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
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

 
    test:assertEquals(charInoutValue.get(string), "This is a char4", "Char Data type doesnt match.");
    test:assertEquals(varcharInoutValue.get(string), "This is a varchar4", "Varchar Data type doesnt match.");
    test:assertEquals(textInoutValue.get(string), "This is a text4", "Text Data type doesnt match.");
    test:assertEquals(nameInoutValue.get(string), "This is a name4", "Name Data type doesnt match.");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testCharacterProcedureInoutCall]
}
function testBooleanProcedureInoutCall() {
    int rowId = 36;
    boolean booleanType = false;

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter booleanInoutValue = new (booleanType);

    sql:ParameterizedCallQuery sqlQuery =
      `
      call BooleanInoutProcedure(${rowIdInoutValue}, ${booleanInoutValue});
    `;
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(booleanInoutValue.get(boolean), false, "Boolean Datatype doesn't match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testBooleanProcedureInoutCall]
}
function testNetworkProcedureInoutCall() {
    int rowId = 36;
    InetValue inetValue = new ("192.168.0.1/24");
    CidrValue cidrValue = new ("::ffff:1.2.3.0/120");
    MacaddrValue macaddrValue = new ("08:00:2b:01:02:03");
    Macaddr8Value macaddr8Value = new ("08-00-2b-01-02-03-04-00");

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter inetInoutValue = new (inetValue);
    InOutParameter cidrInoutValue = new (cidrValue);
    InOutParameter macaddrInoutValue = new (macaddrValue);
    InOutParameter macaddr8InoutValue = new (macaddr8Value);

    sql:ParameterizedCallQuery sqlQuery =
      `
      call NetworkInoutProcedure(${rowIdInoutValue}, ${inetInoutValue}, ${cidrInoutValue}, ${macaddrInoutValue}, ${macaddr8InoutValue});
    `;
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

 
    test:assertEquals(inetInoutValue.get(string), "192.168.0.1/24", "Inet Data type doesnt match.");
    test:assertEquals(cidrInoutValue.get(string), "::ffff:1.2.3.0/120", "Cidr Data type doesnt match.");
    test:assertEquals(macaddrInoutValue.get(string), "08:00:2b:01:02:03", "Macaddress Data type doesnt match.");
    test:assertEquals(macaddr8InoutValue.get(string), "08:00:2b:01:02:03:04:00", "Macadress8 Data type doesnt match.");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testNetworkProcedureInoutCall]
}
function testGeometricProcedureInoutCall() {
    int rowId = 36;
    PointValue pointType = new ({x: 2, y:2});
    LineValue lineType = new ({a:2, b:3, c:4});
    LsegValue lsegType = new ({x1: 2, x2: 3, y1: 2, y2:3});
    BoxValue boxType = new ({x1: 2, x2: 3, y1: 2, y2:3});
    PathValue pathType = new ({isOpen: false, points: [{x: 1, y:1}, {x: 2, y: 2}]});
    PolygonValue polygonType = new ([{x: 1, y:1}, {x: 2, y: 2}]);
    CircleValue circleType = new ({x: 2, y:2, r:2});

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter pointInoutValue = new (pointType);
    InOutParameter lineInoutValue = new (lineType);
    InOutParameter lsegInoutValue = new (lsegType);
    InOutParameter boxInoutValue = new (boxType);
    InOutParameter pathInoutValue = new (pathType);
    InOutParameter polygonInoutValue = new (polygonType);
    InOutParameter circleInoutValue = new (circleType);

    PointRecordType pointOutRecord = {x: 2, y: 2};
    LineType lineOutRecord = {a: 2, b: 3,c: 4};
    LsegRecordType lsegOutRecord = {x1: 2, y1: 2, x2: 3, y2: 3};
    BoxRecordType boxOutRecord = {x1: 2, x2: 3, y1: 2, y2:3};
    PathRecordType pathOutRecord = {isOpen: false, points: [{x: 1, y: 1}, {x: 2, y: 2}]};
    PolygonRecordType polygonOutRecord = {points: [{x: 1, y: 1}, {x: 2, y: 2}]};
    CircleRecordType circleOutRecord = {x: 2, y:2, r:2};

    sql:ParameterizedCallQuery sqlQuery =
      `
      call GeometricInoutProcedure(${rowIdInoutValue}, ${pointInoutValue}, ${lineInoutValue}, ${lsegInoutValue}, ${boxInoutValue}, ${pathInoutValue}, ${polygonInoutValue}, ${circleInoutValue});
    `;
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);
    test:assertEquals(pointInoutValue.get(string), "(2.0,2.0)", "Point Data type doesnt match.");
    test:assertEquals(lineInoutValue.get(string), "{2.0,3.0,4.0}", "Line Data type doesnt match.");
    test:assertEquals(lsegInoutValue.get(string), "[(2.0,2.0),(3.0,3.0)]", "Line Segment Data type doesnt match.");
    test:assertEquals(boxInoutValue.get(string), "(3.0,3.0),(2.0,2.0)", "Box Data type doesnt match.");
    test:assertEquals(pathInoutValue.get(string), "((1.0,1.0),(2.0,2.0))", "Path Data type doesnt match.");
    test:assertEquals(polygonInoutValue.get(string), "((1.0,1.0),(2.0,2.0))", "Polygon Data type doesnt match.");
    test:assertEquals(circleInoutValue.get(string), "<(2.0,2.0),2.0>", "Circle Data type doesnt match.");

    test:assertEquals(pointInoutValue.get(PointRecordType), pointOutRecord, "Point Data type doesnt match.");
    test:assertEquals(lineInoutValue.get(LineType), lineOutRecord, "Line Data type doesnt match.");
    test:assertEquals(lsegInoutValue.get(LsegRecordType), lsegOutRecord, "Line Segment Data type doesnt match.");
    test:assertEquals(boxInoutValue.get(BoxRecordType), boxOutRecord, "Box Data type doesnt match.");
    test:assertEquals(pathInoutValue.get(PathRecordType), pathOutRecord, "Path Data type doesnt match.");
    test:assertEquals(polygonInoutValue.get(PolygonRecordType), polygonOutRecord, "Polygon Data type doesnt match.");
    test:assertEquals(circleInoutValue.get(CircleRecordType), circleOutRecord, "Circle Data type doesnt match.");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testGeometricProcedureInoutCall]
}
function testUuidProcedureInoutCall() {
    int rowId = 36;
    UuidValue uuidType = new ("a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12");

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter uuidInoutValue = new (uuidType);

    sql:ParameterizedCallQuery sqlQuery =
      `
      call UuidInoutProcedure(${rowIdInoutValue}, ${uuidInoutValue});
    `;
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(uuidInoutValue.get(string), "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12", "UUID Datatype doesn't match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testUuidProcedureInoutCall]
}
function testPglsnProcedureInoutCall() {
    int rowId = 36;
    PglsnValue pglsnType = new ("16/B374D848");

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter pglsnInoutValue = new (pglsnType);

    sql:ParameterizedCallQuery sqlQuery =
      `
      call PglsnInoutProcedure(${rowIdInoutValue}, ${pglsnInoutValue});
    `;
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(pglsnInoutValue.get(string), "16/B374D848", "Pg_lsn Data type Doesn't match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testPglsnProcedureInoutCall]
}
function testJsonProcedureInoutCall() {
    int rowId = 36;
    json jsonValue = {"key1":"value","key2":2};
    JsonValue jsonType = new(jsonValue);
    JsonbValue jsonbType = new(jsonValue);
    JsonpathValue jsonpathType = new("$.\"floor\"[*].\"apt\"[*]?(@.\"area\" > 40 && @.\"area\" < 90)?(@.\"rooms\" > 10)");

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter jsonInoutValue = new (jsonType);
    InOutParameter jsonbInoutValue = new (jsonbType);
    InOutParameter jsonPathInoutValue = new (jsonpathType);

    sql:ParameterizedCallQuery sqlQuery =
      `
      call JsonInoutProcedure(${rowIdInoutValue}, ${jsonInoutValue}, ${jsonbInoutValue}, ${jsonPathInoutValue});
    `;
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

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
function testBitProcedureInoutCall() {
    int rowId = 36;
    VarbitstringValue varbitstringType = new("111110");
    PGBitValue bitType = new("0");

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter varbitInoutValue = new (varbitstringType);
    InOutParameter bitInoutValue = new (bitType);

    sql:ParameterizedCallQuery sqlQuery =
      `
      call BitInoutProcedure(${rowIdInoutValue}, ${varbitInoutValue}, ${bitInoutValue});
    `;
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(varbitInoutValue.get(string), "111110", "Bit Vary Datatype Doesn;t Match");
    test:assertEquals(bitInoutValue.get(boolean), false, "Bit Datatype Doesn't Match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testBitProcedureInoutCall]
}
function testDatetimeProcedureInoutCall() {

    time:Time|error timeValue = time:createTime(2017, 3, 28, 23, 42, 45,554, "Asia/Colombo");
    if (timeValue is time:Time) {
        int rowId = 36;
        sql:TimestampValue timestampType = new(timeValue);
        sql:TimestampValue timestamptzType = new(timeValue);
        sql:DateValue dateType = new(timeValue);
        sql:TimeValue timeType = new(timeValue);
        sql:TimeValue timetzType= new(timeValue);
        IntervalValue intervalType= new({years:1, months:2, days:3, hours:4, minutes:5, seconds:7});

        InOutParameter rowIdInoutValue = new (rowId);
        InOutParameter timestampInoutValue = new (timestampType);
        InOutParameter timestamptzInoutValue = new (timestamptzType);
        InOutParameter dateInoutValue = new (dateType);
        InOutParameter timeInoutValue = new (timeType);
        InOutParameter timetzInoutValue = new (timetzType);
        InOutParameter intervalInoutValue = new (intervalType);

        IntervalRecordType intervalRecordType = {years:1, months:2, days:3, hours:4, minutes:5, seconds:7};
    
        sql:ParameterizedCallQuery sqlQuery =
        `
            call DatetimeInoutProcedure(${rowIdInoutValue}, ${dateInoutValue}, ${timeInoutValue}, ${timetzInoutValue},
                ${timestampInoutValue}, ${timestamptzInoutValue}, ${intervalInoutValue});
        `;
        sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

        test:assertEquals(timestampInoutValue.get(string), "2017-03-29T05:12:45.554+05:30", " Timestamp Datatype Doesn't Match");
        test:assertEquals(timestamptzInoutValue.get(string), "2017-03-29T05:12:45.554+05:30", " Timestamptz Datatype Doesn't Match");
        test:assertEquals(dateInoutValue.get(string), "2017-03-28+05:30", " Date Datatype Doesn't Match");
        test:assertEquals(timeInoutValue.get(string), "05:12:45.000+05:30", " Time Datatype Doesn't Match");
        test:assertEquals(timetzInoutValue.get(string), "05:12:45.000+05:30", " Timetz Datatype Doesn't Match");
        test:assertEquals(intervalInoutValue.get(string), "1 years 2 mons 3 days 4 hours 5 mins 7.0 secs", " Interval Datatype Doesn't Match");

        test:assertTrue(timestampInoutValue.get(time:Time) is time:Time, " Timestamp Datatype Doesn't Match");
        test:assertTrue(timestamptzInoutValue.get(time:Time) is time:Time, " Timestamptz Datatype Doesn't Match");
        test:assertTrue(dateInoutValue.get(time:Time) is time:Time, " Date Datatype Doesn't Match");
        test:assertTrue(timeInoutValue.get(time:Time) is time:Time, " Time Datatype Doesn't Match");
        test:assertTrue(timetzInoutValue.get(time:Time) is time:Time, " Timetz Datatype Doesn't Match");
        test:assertEquals(intervalInoutValue.get(IntervalRecordType),
                     intervalRecordType, " Interval Datatype Doesn't Match");
    }
    else {
        test:assertFail("Invalid Time value generated ");
    }
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testDatetimeProcedureInoutCall]
}
function testRangeProcedureInoutCall() {

        int rowId = 36;
        Int4rangeValue int4rangeType = new("(2,50)");
        Int8rangeValue int8rangeType = new("(10,100)");
        NumrangeValue numrangeType = new("(0.1,2.4)");
        TsrangeValue tsrangeType = new("(2010-01-01 14:30, 2010-01-01 15:30)");
        TstzrangeValue tstzrangeType= new("(2010-01-01 14:30, 2010-01-01 15:30)");
        DaterangeValue daterangeType= new("(2010-01-01 14:30, 2010-01-03 )");

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
        sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

        Int4rangeType int4RangeRecord = {upper: 50 , lower: 3, isLowerboundInclusive: true};        
        Int8rangeType int8RangeRecord = {upper: 100, lower: 11, isUpperboundInclusive: false, isLowerboundInclusive: true};
        TsrangeType tsrangeRecordType = {lower: "2010-01-01 14:30:00", upper: "2010-01-01 15:30:00"};
        TstzrangeType tstzrangeRecordType = {lower: "2010-01-01 14:30:00+05:30", upper: "2010-01-01 15:30:00+05:30"};
        DaterangeType daterangeRecordType = {lower: "2010-01-02", upper: "2010-01-03", isLowerboundInclusive: true};

        test:assertEquals(int4rangeInoutValue.get(string), "[3,50)", "Int4range Datatype Doesn't Match");
        test:assertEquals(int8rangeInoutValue.get(string), "[11,100)", "Int8range Datatype Doesn't Match");
        test:assertEquals(numrangeInoutValue.get(string), "(0.1,2.4)", "Numrnge Datatype Doesn't Match");
        test:assertEquals(tsrangeInoutValue.get(string), "(\"2010-01-01 14:30:00\",\"2010-01-01 15:30:00\")", "Tsrange Datatype Doesn't Match");
        test:assertEquals(tstzrangeInoutValue.get(string), "(\"2010-01-01 14:30:00+05:30\",\"2010-01-01 15:30:00+05:30\")", "Tstzrange Datatype Doesn't Match");
        test:assertEquals(daterangeInoutValue.get(string), "[2010-01-02,2010-01-03)", "Daterange Datatype Doesn't Match");

        test:assertEquals(int4rangeInoutValue.get(Int4rangeType), int4RangeRecord, "Int4range Datatype Doesn't Match");
        test:assertEquals(int8rangeInoutValue.get(Int8rangeType), int8RangeRecord, "Int8range Datatype Doesn't Match");
        test:assertTrue(numrangeInoutValue.get(NumrangeType) is NumrangeType, "Numrnge Datatype Doesn't Match");
        test:assertEquals(tsrangeInoutValue.get(TsrangeType), tsrangeRecordType, "Tsrange Datatype Doesn't Match");
        test:assertEquals(tstzrangeInoutValue.get(TstzrangeType), tstzrangeRecordType, "Tstzrange Datatype Doesn't Match");
        test:assertEquals(daterangeInoutValue.get(DaterangeType), daterangeRecordType, "Daterange Datatype Doesn't Match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testRangeProcedureInoutCall]
}
function testTextsearchProcedureInoutCall() {
    int rowId = 36;
    TsvectorValue tsvectorType = new ("a fat cat sat on a mat and ate a fat rat");
    TsqueryValue tsqueryType = new ("fat & rat");

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter tsvectorInoutValue = new (tsvectorType);
    InOutParameter tsqueryInoutValue = new (tsqueryType);

    sql:ParameterizedCallQuery sqlQuery =
      `
      call TextsearchInoutProcedure(${rowIdInoutValue}, ${tsvectorInoutValue}, ${tsqueryInoutValue});
    `;
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(tsvectorInoutValue.get(string), "'a' 'and' 'ate' 'cat' 'fat' 'mat' 'on' 'rat' 'sat'", "Tsvector Datatype Doesn't Match");
    test:assertEquals(tsqueryInoutValue.get(string), "'fat' & 'rat'", "Tsquery Datatype Doesn't Match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testTextsearchProcedureInoutCall]
}
function testObjectidentifierProcedureInoutCall() {
    int rowId = 36;
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
    InOutParameter regtypeInoutValue = new(regtypeType);

    sql:ParameterizedCallQuery sqlQuery =
      `
      call ObjectidentifierInoutProcedure(${rowIdInoutValue}, ${oidInoutValue}, ${regclassInoutValue}, ${regconfigInoutValue}, ${regdictionaryInoutValue}, 
                                ${regnamespaceInoutValue}, ${regoperInoutValue}, ${regoperatorInoutValue}, ${regprocInoutValue}, ${regprocedureInoutValue},
                                 ${regroleInoutValue}, ${regtypeInoutValue});
    `;
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(oidInoutValue.get(string), "12", "OID Datatype Doesn;t Match");
    test:assertEquals(regclassInoutValue.get(string), "pg_type", "Reg class Datatype Doesn't Match");
    test:assertEquals(regconfigInoutValue.get(string), "english", "Reg config Datatype Doesn;t Match");
    test:assertEquals(regdictionaryInoutValue.get(string), "simple", "Reg Dictionary Datatype Doesn't Match");
    test:assertEquals(regnamespaceInoutValue.get(string), "pg_catalog", "Reg namespace Datatype Doesn;t Match");
    test:assertEquals(regoperInoutValue.get(string), "!", "Reg oper Datatype Doesn't Match");
    test:assertEquals(regoperatorInoutValue.get(string), "*(integer,integer)", "Reg operator Datatype Doesn;t Match");
    test:assertEquals(regprocInoutValue.get(string), "now", "Reg proc Datatype Doesn't Match");
    test:assertEquals(regprocedureInoutValue.get(string), "sum(integer)", "Reg procedure Datatype Doesn;t Match");
    test:assertEquals(regroleInoutValue.get(string), "postgres", "Reg role Datatype Doesn't Match");
    test:assertEquals(regtypeInoutValue.get(string), "integer", "Reg type Datatype Doesn;t Match");
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
function testBinaryProcedureCall() {
    int rowId = 35;
    byte[] byteArray = [1, 2, 3, 4];
    sql:BinaryValue byteaType = new (byteArray);

    sql:ParameterizedCallQuery sqlQuery =
      `
      call BinaryProcedure(${rowId}, ${byteaType}, ${byteArray});
    `;
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

    sql:ParameterizedQuery query = `SELECT row_id, bytea_type, bytea_escape_type from BinaryTypes where row_id = ${rowId}`;

    BinaryProcedureRecord expectedDataRow = {
        row_id: rowId,
        bytea_type: [1, 2, 3, 4],
        bytea_escape_type: [1, 2, 3, 4]
    };
    test:assertEquals(queryProcedureClient(query, proceduresDatabase, BinaryProcedureRecord), expectedDataRow, "Binary Call procedure insert and query did not match.");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testGeometricProcedureInoutCall]
}
function testXmlProcedureInoutCall() {
    int rowId = 36;
    xml xmlValue = xml `<tag1>This is tag1<tag2>This is tag 2</tag2></tag1>`;
    PGXmlValue xmlType = new (xmlValue);

    InOutParameter rowIdInoutValue = new (rowId);
    InOutParameter xmlInoutValue = new (xmlType);

    sql:ParameterizedCallQuery sqlQuery =
      `
      call XmlInoutProcedure(${rowIdInoutValue}, ${xmlInoutValue});
    `;
    sql:ProcedureCallResult result = callProcedure(sqlQuery, proceduresDatabase);

    test:assertEquals(xmlInoutValue.get(xml), xmlValue, "Xml Datatype doesn't match");
}

function queryProcedureClient(@untainted string|sql:ParameterizedQuery sqlQuery, string database, typedesc<record {}>? resultType = ())
returns @tainted record {} {
    Client dbClient = checkpanic new (host, user, password, database, port);
    stream<record{}, error> streamData = dbClient->query(sqlQuery, resultType);
    record {|record {} value;|}? data = checkpanic streamData.next();
    checkpanic streamData.close();
    record {}? value = data?.value;
    checkpanic dbClient.close();
    if (value is ()) {
        return {};
    } else {
        return value;
    }
}

function callProcedure(sql:ParameterizedCallQuery sqlQuery, string database, typedesc<record {}>[] rowTypes = []) returns sql:ProcedureCallResult {
    Client dbClient = checkpanic new (host, user, password, database, port, connectionPool = {
        maxOpenConnections: 25,
        maxConnectionLifeTime : 15,
        minIdleConnections : 15
    });
    sql:ProcedureCallResult result = checkpanic dbClient->call(sqlQuery, rowTypes);
    checkpanic dbClient.close();
    return result;
}
