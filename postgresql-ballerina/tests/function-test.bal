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

public type NumericFunctionRecord record {
    int? row_id;
    int? smallint_type;
    int? int_type;
    int? bigint_type;
    decimal? decimal_type;
    decimal? numeric_type;
};

@test:Config {
    groups: ["functions"]
}
function testNumericFunctionInParameter() returns error? {
    int rowId = 3;
    sql:SmallIntValue smallintType = new (1);
    sql:IntegerValue intType = new (1);
    int bigintType = 123456;
    sql:DecimalValue decimalType = new (1234.567);
    decimal numericType = 1234.567;
    sql:RealValue realType = new (123.456);
    sql:DoubleValue doubleType = new (123.456);

    sql:ParameterizedCallQuery sqlQuery =
      `
      select * from NumericInFunction(${rowId}, ${smallintType}, ${intType}, ${bigintType}, ${decimalType}, 
                                ${numericType}, ${realType}, ${doubleType});
    `;
    sql:ProcedureCallResult ret = check callFunction(sqlQuery, functionsDatabase, [NumericFunctionRecord, NumericFunctionRecord, NumericFunctionRecord]);

    stream<record{}, sql:Error>? qResult = ret.queryResult;

    if (qResult is ()) {
        test:assertFail("First result set is empty.");
    } else {
        decimal decimalVal = 123.456;
        record {|record {} value;|}? data = check qResult.next();
        record {}? result1 = data?.value;
        NumericFunctionRecord expectedDataRow = {
            row_id: 1,
            smallint_type: 1,
            int_type: 123,
            bigint_type: 123456,
            decimal_type: decimalVal,
            numeric_type: decimalVal
        };        
        test:assertEquals(result1, expectedDataRow, "Numeric Function first select did not match.");
    }

    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Second result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result2 = data?.value;
        NumericFunctionRecord expectedDataRow2 = {
            row_id: 2,
            smallint_type: (),
            int_type: (),
            bigint_type: (),
            decimal_type: (),
            numeric_type: ()
        }; 
        
        test:assertEquals(result2, expectedDataRow2, "Numeric Function second select did not match.");
    }

    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Third result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result3 = data?.value;
        NumericFunctionRecord expectedDataRow3 = {
            row_id: 3,
            smallint_type: 1,
            int_type: 1,
            bigint_type: 123456,
            decimal_type: 1234.567,
            numeric_type: 1234.567
        }; 
        
        test:assertEquals(result3, expectedDataRow3, "Numeric Function third select did not match.");
        check qResult.close();
        check ret.close();
    }
}

public type CharacterFunctionRecord record {
    int? row_id;
    string? char_type;
    string? varchar_type;
    string? text_type;
    string? name_type;
};

@test:Config {
    groups: ["functions"],
    dependsOn: [testNumericFunctionInParameter]
}
function testCharacterFunctionInParameter() returns error? {
    int rowId = 4;
    sql:CharValue charValue = new("This is a char3");
    sql:VarcharValue varcharValue = new("This is a varchar3");
    string textValue = "This is a text3";
    string nameValue = "This is a name3";

    sql:ParameterizedCallQuery sqlQuery =
      `
      select * from CharacterInFunction(${rowId}, ${charValue}, ${varcharValue}, ${textValue}, ${nameValue});
    `;
    sql:ProcedureCallResult ret = check callFunction(sqlQuery, functionsDatabase, [CharacterFunctionRecord, CharacterFunctionRecord, CharacterFunctionRecord]);

    stream<record{}, sql:Error>? qResult = ret.queryResult;

    if (qResult is ()) {
        test:assertFail("First result set is empty.");
    } else {
        decimal decimalVal = 123.456;
        record {|record {} value;|}? data = check qResult.next();
        record {}? result1 = data?.value;
        CharacterFunctionRecord expectedDataRow = {
            row_id: 1,
            char_type: "This is a char1",
            varchar_type: "This is a varchar1",
            text_type: "This is a text1",
            name_type: "This is a name1"
        };      
        test:assertEquals(result1, expectedDataRow, "Character Function first select did not match.");
    }

    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Second result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result2 = data?.value;
        CharacterFunctionRecord expectedDataRow2 = {
            row_id: 2,
            char_type: "This is a char2",
            varchar_type: "This is a varchar2",
            text_type: "This is a text2",
            name_type: "This is a name2"
        };
        
        test:assertEquals(result2, expectedDataRow2, "Character Function second select did not match.");
    }

    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Second result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result3 = data?.value;
        CharacterFunctionRecord expectedDataRow3 = {
            row_id: 3,
            char_type: (),
            varchar_type: (),
            text_type: (),
            name_type: ()
        }; 
        
        test:assertEquals(result3, expectedDataRow3, "Character Function second select did not match.");
    }
    
    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Third result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result4 = data?.value;
        CharacterFunctionRecord expectedDataRow4 = {
            row_id: rowId,
            char_type: "This is a char3",
            varchar_type: "This is a varchar3",
            text_type: "This is a text3",
            name_type: "This is a name3"
        }; 
        
        test:assertEquals(result4, expectedDataRow4, "Character Function third select did not match.");
        check qResult.close();
        check ret.close();
    }
}

public type BooleanFunctionRecord record {
    int? row_id;
    boolean? boolean_type;
};

@test:Config {
    groups: ["functions"],
    dependsOn: [testCharacterFunctionInParameter]
}
function testBooleanFunctionInParameter() returns error? {
    int rowId = 3;
    boolean booleanType = true;

    sql:ParameterizedCallQuery sqlQuery =
      `
      select * from BooleanInFunction(${rowId}, ${booleanType});
    `;
    sql:ProcedureCallResult ret = check callFunction(sqlQuery, functionsDatabase, [BooleanFunctionRecord, BooleanFunctionRecord, BooleanFunctionRecord]);

    stream<record{}, sql:Error>? qResult = ret.queryResult;

    if (qResult is ()) {
        test:assertFail("First result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result1 = data?.value;
        BooleanFunctionRecord expectedDataRow = {
            row_id: 1,
            boolean_type: true
        };        
        test:assertEquals(result1, expectedDataRow, "Boolean Function first select did not match.");
    }

    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Second result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result2 = data?.value;
        BooleanFunctionRecord expectedDataRow2 = {
            row_id: 2,
            boolean_type: ()
        }; 
        
        test:assertEquals(result2, expectedDataRow2, "Boolean Function second select did not match.");
    }

    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Third result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result3 = data?.value;
        BooleanFunctionRecord expectedDataRow3 = {
            row_id: 3,
            boolean_type: true
        }; 
        test:assertEquals(result3, expectedDataRow3, "Boolean Function third select did not match.");
        check qResult.close();
        check ret.close();
    }
}

public type UuidFunctionRecord record {
    int? row_id;
    string? uuid_type;
};

@test:Config {
    groups: ["functions"],
    dependsOn: [testBooleanFunctionInParameter]
}
function testUuidFunctionInParameter() returns error? {
    int rowId = 3;
    UuidValue uuidType = new ("a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12");

    sql:ParameterizedCallQuery sqlQuery =
      `
      select * from UuidInFunction(${rowId}, ${uuidType});
    `;
    sql:ProcedureCallResult ret = check callFunction(sqlQuery, functionsDatabase, [UuidFunctionRecord, UuidFunctionRecord, UuidFunctionRecord]);

    stream<record{}, sql:Error>? qResult = ret.queryResult;

    if (qResult is ()) {
        test:assertFail("First result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result1 = data?.value;
        UuidFunctionRecord expectedDataRow = {
            row_id: 1,
            uuid_type: "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11"
        };        
        test:assertEquals(result1, expectedDataRow, "Uuid Function first select did not match.");
    }

    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Second result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result2 = data?.value;
        UuidFunctionRecord expectedDataRow2 = {
            row_id: 2,
            uuid_type: ()
        }; 
        
        test:assertEquals(result2, expectedDataRow2, "Uuid Function second select did not match.");
    }

    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Third result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result3 = data?.value;
        UuidFunctionRecord expectedDataRow3 = {
            row_id: 3,
            uuid_type: "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12"
        }; 
        test:assertEquals(result3, expectedDataRow3, "Uuid Function third select did not match.");
        check qResult.close();
        check ret.close();
    }
}

public type NetworkFunctionRecord record {
    int? row_id;
    string? inet_type;
    string? cidr_type;
    string? macaddr_type;
    string? macaddr8_type;
};

@test:Config {
    groups: ["functions"],
    dependsOn: [testUuidFunctionInParameter]
}
function testNetworkFunctionInParameter() returns error? {
    int rowId = 3;
    InetValue inetValue = new("192.168.0.1/24");
    CidrValue cidrValue = new("::ffff:1.2.3.0/120");
    MacAddrValue macaddrValue = new("08:00:2b:01:02:03");
    MacAddr8Value macaddr8Value = new("08:00:2b:01:02:03:04:05");

    sql:ParameterizedCallQuery sqlQuery =
      `
      select * from NetworkInFunction(${rowId}, ${inetValue}, ${cidrValue}, ${macaddrValue}, ${macaddr8Value});
    `;
    sql:ProcedureCallResult ret = check callFunction(sqlQuery, functionsDatabase, [NetworkFunctionRecord, NetworkFunctionRecord, NetworkFunctionRecord]);

    stream<record{}, sql:Error>? qResult = ret.queryResult;

    if (qResult is ()) {
        test:assertFail("First result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result1 = data?.value;
        NetworkFunctionRecord expectedDataRow = {
            row_id: 1,
            inet_type: "192.168.0.1/24",
            cidr_type: "::ffff:1.2.3.0/120",
            macaddr_type: "08:00:2b:01:02:03",
            macaddr8_type: "08:00:2b:01:02:03:04:05"
        };      
        test:assertEquals(result1, expectedDataRow, "Network Function first select did not match.");
    }

    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Second result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result3 = data?.value;
        NetworkFunctionRecord expectedDataRow3 = {
            row_id: 2,
            inet_type: (),
            cidr_type: (),
            macaddr_type: (),
            macaddr8_type: ()
        }; 
        
        test:assertEquals(result3, expectedDataRow3, "Network Function second select did not match.");
    }
    
    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Third result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result4 = data?.value;
        NetworkFunctionRecord expectedDataRow4 = {
            row_id: rowId,
            inet_type: "192.168.0.1/24",
            cidr_type: "::ffff:1.2.3.0/120",
            macaddr_type: "08:00:2b:01:02:03",
            macaddr8_type: "08:00:2b:01:02:03:04:05"
        }; 
        
        test:assertEquals(result4, expectedDataRow4, "Network Function third select did not match.");
        check qResult.close();
        check ret.close();
    }
}

public type GeometricFunctionRecord record {
    int? row_id;
    string? point_type;
    string? line_type;
    string? lseg_type;
    string? box_type;
    string? path_type;
    string? polygon_type;
    string? circle_type;
};

@test:Config {
    groups: ["functions"],
    dependsOn: [testNetworkFunctionInParameter]
}
function testGeometricFunctionInParameter() returns error? {
    int rowId = 3;
    PointValue pointType = new ({x: 2, y:2});
    LineValue lineType = new ({a:2, b:3, c:4});
    LsegValue lsegType = new ({x1: 2, x2: 3, y1: 2, y2:3});
    BoxValue boxType = new ({x1: 2, x2: 3, y1: 2, y2:3});
    PathValue pathType = new ({points: [{x: 2, y:2}, {x: 2, y:2}], open: true});
    PolygonValue polygonType = new ([{x: 2, y:2}, {x: 2, y:2}]);
    CircleValue circleType = new ({x: 2, y:2, r:2});

    sql:ParameterizedCallQuery sqlQuery =
      `
      select * from GeometricInFunction(${rowId}, ${pointType}, ${lineType}, ${lsegType}, ${boxType}, ${pathType}, ${polygonType}, ${circleType});
    `;
    sql:ProcedureCallResult ret = check callFunction(sqlQuery, functionsDatabase, [GeometricFunctionRecord, GeometricFunctionRecord, GeometricFunctionRecord]);

    stream<record{}, sql:Error>? qResult = ret.queryResult;

    if (qResult is ()) {
        test:assertFail("First result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result1 = data?.value;
        GeometricFunctionRecord expectedDataRow = {
            row_id: 1,
            point_type: "(1,2)",
            line_type: "{1,2,3}",
            lseg_type: "[(1,1),(2,2)]",
            box_type: "(2,2),(1,1)",
            path_type: "[(1,1),(2,2)]",
            polygon_type: "((1,1),(2,2))",
            circle_type: "<(1,1),1>"
        };
        test:assertEquals(result1, expectedDataRow, "Geometric Function first select did not match.");
    }

    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Second result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result3 = data?.value;
        GeometricFunctionRecord expectedDataRow3 = {
            row_id: 2,
            point_type: (),
            line_type: (),
            lseg_type: (),
            box_type: (),
            path_type: (),
            polygon_type: (),
            circle_type: ()
        }; 
        
        test:assertEquals(result3, expectedDataRow3, "Geometric Function second select did not match.");
    }
    
    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Third result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result4 = data?.value;
        GeometricFunctionRecord expectedDataRow4 = {
            row_id: rowId,
            point_type: "(2,2)",
            line_type: "{2,3,4}",
            lseg_type: "[(2,2),(3,3)]",
            box_type: "(3,3),(2,2)",
            path_type: "[(2,2),(2,2)]",
            polygon_type: "((2,2),(2,2))",
            circle_type: "<(2,2),2>"
        }; 
        
        test:assertEquals(result4, expectedDataRow4, "Geometric Function third select did not match.");
        check qResult.close();
        check ret.close();
    }
}

public type JsonFunctionRecord record {
    int? row_id;
    json? json_type;
    json? jsonb_type;
    string? jsonpath_type;
};

@test:Config {
    groups: ["functions"],
    dependsOn: [testGeometricFunctionInParameter]
}
function testJsonFunctionInParameter() returns error? {
    int rowId = 3;
    json jsonValue = {"a":11,"b":2};
    JsonValue jsonType = new(jsonValue);
    JsonbValue jsonbType = new(jsonValue);
    JsonpathValue jsonpathType = new("$.\"floor\"[*].\"apt\"[*]?(@.\"area\" > 40 && @.\"area\" < 90)?(@.\"rooms\" > 1)");

    sql:ParameterizedCallQuery sqlQuery =
      `
      select * from JsonInFunction(${rowId}, ${jsonType}, ${jsonbType}, ${jsonpathType});
    `;
    sql:ProcedureCallResult ret = check callFunction(sqlQuery, functionsDatabase, [JsonFunctionRecord, JsonFunctionRecord, JsonFunctionRecord]);

    stream<record{}, sql:Error>? qResult = ret.queryResult;

    if (qResult is ()) {
        test:assertFail("First result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result1 = data?.value;
        JsonFunctionRecord expectedDataRow = {
            row_id: 1,
            json_type: {"key1": "value", "key2": 2},
            jsonb_type: {"key1": "value", "key2": 2},
            jsonpath_type: "$.\"floor\"[*].\"apt\"[*]?(@.\"area\" > 40 && @.\"area\" < 90)?(@.\"rooms\" > 1)"
        };      
        test:assertEquals(result1, expectedDataRow, "Json Function first select did not match.");
        check qResult.close();
        check ret.close();
    }
}

public type BitFunctionRecord record {
    int? row_id;
    string? varbitstring_type;
    boolean? bit_type;
};

@test:Config {
    groups: ["functions"],
    dependsOn: [testJsonFunctionInParameter]
}
function testBitFunctionInParameter() returns error? {
    int rowId = 3;
    VarbitstringValue varbitstringType = new("111110");
    PGBitValue bitType = new("1");

    sql:ParameterizedCallQuery sqlQuery =
      `
      select * from BitInFunction(${rowId}, ${varbitstringType}, ${bitType});
    `;
    sql:ProcedureCallResult ret = check callFunction(sqlQuery, functionsDatabase, [BitFunctionRecord, BitFunctionRecord, BitFunctionRecord]);

    stream<record{}, sql:Error>? qResult = ret.queryResult;

    if (qResult is ()) {
        test:assertFail("First result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result1 = data?.value;
        BitFunctionRecord expectedDataRow = {
            row_id: 1,
            varbitstring_type: "1101",
            bit_type: true
        };      
        test:assertEquals(result1, expectedDataRow, "Bit Function first select did not match.");
    }

    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Second result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result3 = data?.value;
        BitFunctionRecord expectedDataRow3 = {
            row_id: 2,
            varbitstring_type: (),
            bit_type: ()
        }; 
        
        test:assertEquals(result3, expectedDataRow3, "Bit Function second select did not match.");
    }
    
    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Third result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result4 = data?.value;
        BitFunctionRecord expectedDataRow4 = {
            row_id: rowId,
            varbitstring_type: "111110",
            bit_type: true
        }; 
        
        test:assertEquals(result4, expectedDataRow4, "Bit Function third select did not match.");
        check qResult.close();
        check ret.close();
    }
}

public type PglsnFunctionRecord record {
    int? row_id;
    string? pglsn_type;
};

@test:Config {
    groups: ["functions"],
    dependsOn: [testBitFunctionInParameter]
}
function testPglsnFunctionInParameter() returns error? {
    int rowId = 3;
    PglsnValue pglsnType = new ("16/B374D848");

    sql:ParameterizedCallQuery sqlQuery =
      `
      select * from PglsnInFunction(${rowId}, ${pglsnType});
    `;
    sql:ProcedureCallResult ret = check callFunction(sqlQuery, functionsDatabase, [PglsnFunctionRecord, PglsnFunctionRecord, PglsnFunctionRecord]);

    stream<record{}, sql:Error>? qResult = ret.queryResult;

    if (qResult is ()) {
        test:assertFail("First result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result1 = data?.value;
        PglsnFunctionRecord expectedDataRow = {
            row_id: 1,
            pglsn_type: "16/B374D848"
        };        
        test:assertEquals(result1, expectedDataRow, "Pglsn Function first select did not match.");
    }

    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Second result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result2 = data?.value;
        PglsnFunctionRecord expectedDataRow2 = {
            row_id: 2,
            pglsn_type: ()
        }; 
        
        test:assertEquals(result2, expectedDataRow2, "Pglsn Function second select did not match.");
    }

    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Third result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result3 = data?.value;
        PglsnFunctionRecord expectedDataRow3 = {
            row_id: 3,
            pglsn_type: "16/B374D848"
        }; 
        test:assertEquals(result3, expectedDataRow3, "Pglsn Function third select did not match.");
        check qResult.close();
        check ret.close();
    }
}

public type DatetimeFunctionRecord record {
    int? row_id;
    string? date_type;
    string? time_type;
    string? timestamp_type;
    Interval? interval_type;
};

@test:Config {
    groups: ["functions"],
    dependsOn: [testPglsnFunctionInParameter]
}
function testDatetimeFunctionInParameter() returns error? {
    int rowId = 3;
    time:Date date = {year: 2017, month: 12, day: 18};
    time:TimeOfDay time = {hour: 23, minute: 12, second: 18};
    time:Utc timestamp = [100000, 0.5];
    sql:TimestampValue timestampType = new(timestamp);
    sql:TimestampValue timestamptzType = new(timestamp);
    sql:DateValue dateType = new(date);
    sql:TimeValue timeType = new(time);
    sql:TimeValue timetzType= new(time);
    IntervalValue intervalType= new({years:1, months:2, days:3, hours:4, minutes:5, seconds:6});

    sql:ParameterizedCallQuery sqlQuery =
    `
    select row_id, date_type, time_type, timestamp_type, interval_type from DatetimeInFunction(${rowId}, ${dateType}, ${timeType}, ${timetzType}, ${timestampType}, ${timestamptzType}, ${intervalType});
    `;
    sql:ProcedureCallResult ret = check callFunction(sqlQuery, functionsDatabase, [DatetimeFunctionRecord, DatetimeFunctionRecord, DatetimeFunctionRecord]);

    stream<record{}, sql:Error>? qResult = ret.queryResult;

    if (qResult is ()) {
        test:assertFail("First result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result1 = data?.value;
        DatetimeFunctionRecord expectedDataRow = {
            row_id: 1,
            date_type: "1999-01-08",
            time_type: "04:05:06",
            timestamp_type: "1999-01-08 04:05:06.0",
            interval_type: {years:1, months:2, days:3, hours:4, minutes:5, seconds:6}
        };      
        test:assertEquals(result1, expectedDataRow, "Datetime Function first select did not match.");
    }

    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Second result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result3 = data?.value;
        DatetimeFunctionRecord expectedDataRow3 = {
            row_id: 2,
            date_type: (),
            time_type: (),
            timestamp_type: (),
            interval_type: ()
        }; 
        
        test:assertEquals(result3, expectedDataRow3, "Datetime Function second select did not match.");
    }
    
    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Third result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result4 = data?.value;
        DatetimeFunctionRecord expectedDataRow4 = {
            row_id: rowId,
            date_type: "2017-12-18",
            time_type: "23:12:18",
            timestamp_type: "1970-01-02 03:46:40.5",
            interval_type: {years:1, months:2, days:3, hours:4, minutes:5, seconds:6}
        }; 
        
        test:assertEquals(result4, expectedDataRow4, "Datetime Function third select did not match.");
        check qResult.close();
        check ret.close();
    }
}

public type RangeFunctionRecord record {
    int? row_id;
    string? int4range_type;
    string? int8range_type;
    string? numrange_type;
    string? tsrange_type;
    string? daterange_type;
};

@test:Config {
    groups: ["functions"],
    dependsOn: [testDatetimeFunctionInParameter]
}
function testRangeFunctionInParameter() returns error? {
    int rowId = 3;
    IntegerRangeValue int4rangeValue = new("(2,50)");
    LongRangeValue int8rangeValue = new("(10,100)");
    NumericRangeValue numrangeValue = new("(0.1,2.4)");
    TsrangeValue tsrangeValue = new("(2010-01-01 14:30, 2010-01-01 15:30)");
    TstzrangeValue tstzrangeValue = new("(2010-01-01 14:30, 2010-01-01 15:30)");
    DaterangeValue daterangeValue = new("(2010-01-01 14:30, 2010-01-03 )");


    sql:ParameterizedCallQuery sqlQuery =
    `
    select row_id, int4range_type, int8range_type, numrange_type, tsrange_type,
        daterange_type  from RangeInFunction(${rowId}, ${int4rangeValue}, ${int8rangeValue}, ${numrangeValue}, ${tsrangeValue}, ${tstzrangeValue}, ${daterangeValue});
    `;
    sql:ProcedureCallResult ret = check callFunction(sqlQuery, functionsDatabase, [RangeFunctionRecord, RangeFunctionRecord, RangeFunctionRecord]);

    stream<record{}, sql:Error>? qResult = ret.queryResult;

    if (qResult is ()) {
        test:assertFail("First result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result1 = data?.value;
        RangeFunctionRecord expectedDataRow = {
            row_id: 1,
            int4range_type: "[3,50)",
            int8range_type: "[11,100)",
            numrange_type: "(0,24)",
            tsrange_type: "(\"2010-01-01 14:30:00\",\"2010-01-01 15:30:00\")",
            daterange_type: "[2010-01-02,2010-01-03)"
        };      
        test:assertEquals(result1, expectedDataRow, "Range Function first select did not match.");
    }

    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Second result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result3 = data?.value;
        RangeFunctionRecord expectedDataRow3 = {
            row_id: 2,
            int4range_type: (),
            int8range_type: (),
            numrange_type: (),
            tsrange_type: (),
            daterange_type: ()
        }; 
        
        test:assertEquals(result3, expectedDataRow3, "Range Function second select did not match.");
    }
    
    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Third result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result4 = data?.value;
        RangeFunctionRecord expectedDataRow4 = {
            row_id: rowId,
            int4range_type: "[3,50)",
            int8range_type: "[11,100)",
            numrange_type: "(0.1,2.4)",
            tsrange_type: "(\"2010-01-01 14:30:00\",\"2010-01-01 15:30:00\")",
            daterange_type: "[2010-01-02,2010-01-03)"
        }; 
        
        test:assertEquals(result4, expectedDataRow4, "Range Function third select did not match.");
        check qResult.close();
        check ret.close();
    }

}

public type TextSearchFunctionRecord record {
    int? row_id;
    string? tsvector_type;
    string? tsquery_type;
};

@test:Config {
    groups: ["functions"],
    dependsOn: [testRangeFunctionInParameter]
}
function testTextSearchFunctionInParameter() returns error? {
    int rowId = 3;
    TsvectorValue tsvectorType = new ("a fat cat sat on a mat and ate a fat rat");
    TsqueryValue tsqueryType = new ("fat & rat");

    sql:ParameterizedCallQuery sqlQuery =
      `
      select * from TextSearchInFunction(${rowId}, ${tsvectorType}, ${tsqueryType});
    `;
    sql:ProcedureCallResult ret = check callFunction(sqlQuery, functionsDatabase, [TextSearchFunctionRecord, TextSearchFunctionRecord, TextSearchFunctionRecord]);

    stream<record{}, sql:Error>? qResult = ret.queryResult;

    if (qResult is ()) {
        test:assertFail("First result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result1 = data?.value;
        TextSearchFunctionRecord expectedDataRow = {
            row_id: 1,
            tsvector_type: "'a' 'and' 'ate' 'cat' 'fat' 'mat' 'on' 'rat' 'sat'",
            tsquery_type: "'fat' & 'rat'"
        };      
        test:assertEquals(result1, expectedDataRow, "TextSearch Function first select did not match.");
    }

    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Second result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result3 = data?.value;
        TextSearchFunctionRecord expectedDataRow3 = {
            row_id: 2,
            tsvector_type: (),
            tsquery_type: ()
        }; 
        
        test:assertEquals(result3, expectedDataRow3, "TextSearch Function second select did not match.");
    }
    
    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Third result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result4 = data?.value;
        TextSearchFunctionRecord expectedDataRow4 = {
            row_id: rowId,
            tsvector_type: "'a' 'and' 'ate' 'cat' 'fat' 'mat' 'on' 'rat' 'sat'",
            tsquery_type: "'fat' & 'rat'"
        }; 
        
        test:assertEquals(result4, expectedDataRow4, "TextSearch Function third select did not match.");
        check qResult.close();
        check ret.close();
    }
}

public type ObjectidentifierFunctionRecord record {
    int? row_id;
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
    groups: ["functions"],
    dependsOn: [testTextSearchFunctionInParameter]
}
function testObjectidentifierFunctionInParameter() returns error? {
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


    sql:ParameterizedCallQuery sqlQuery =
    `
    select * from ObjectidentifierInFunction(${rowId}, ${oidType}, ${regclassType}, ${regconfigType}, ${regdictionaryType}, 
                                ${regnamespaceType}, ${regoperType}, ${regoperatorType}, ${regprocType}, ${regprocedureType},
                                 ${regroleType}, ${regtypeType});
    `;
    sql:ProcedureCallResult ret = check callFunction(sqlQuery, functionsDatabase, [ObjectidentifierFunctionRecord, ObjectidentifierFunctionRecord, ObjectidentifierFunctionRecord]);

    stream<record{}, sql:Error>? qResult = ret.queryResult;

    if (qResult is ()) {
        test:assertFail("First result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result1 = data?.value;
        ObjectidentifierFunctionRecord expectedDataRow = {
            row_id: 1,
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
        test:assertEquals(result1, expectedDataRow, "Objectidentifier Function first select did not match.");
    }

    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Second result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result3 = data?.value;
        ObjectidentifierFunctionRecord expectedDataRow3 = {
            row_id: 2,
            oid_type: (),
            regclass_type: (),
            regconfig_type: (),
            regdictionary_type: (),
            regnamespace_type: (),
            regoper_type: (),
            regoperator_type: (),
            regproc_type: (),
            regprocedure_type: (),
            regrole_type: (),
            regtype_type: ()
        }; 
        
        test:assertEquals(result3, expectedDataRow3, "Objectidentifier Function second select did not match.");
    }
    
    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Third result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result4 = data?.value;
        ObjectidentifierFunctionRecord expectedDataRow4 = {
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
        
        test:assertEquals(result4, expectedDataRow4, "Objectidentifier Function third select did not match.");
        check qResult.close();
        check ret.close();
        }

}

public type BinaryFunctionRecord record {
    int? row_id;
    byte[]? bytea_type;
    byte[]? bytea_escape_type;
};

@test:Config {
    groups: ["functions"],
    dependsOn: [testRangeFunctionInParameter]
}
function testBinaryFunctionInParameter() returns error? {
    int rowId = 3;
    byte[] byteArray = [1,2,3,4];
    sql:BinaryValue byteaType = new (byteArray);
    sql:BinaryValue byteaEscapeType = new (byteArray);

    sql:ParameterizedCallQuery sqlQuery =
      `
      select * from BinaryInFunction(${rowId}, ${byteaType}, ${byteaEscapeType});
    `;
    sql:ProcedureCallResult ret = check callFunction(sqlQuery, functionsDatabase, [BinaryFunctionRecord, BinaryFunctionRecord, BinaryFunctionRecord]);

    stream<record{}, sql:Error>? qResult = ret.queryResult;

    if (qResult is ()) {
        test:assertFail("First result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
    }

    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Second result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result3 = data?.value;
        BinaryFunctionRecord expectedDataRow3 = {
            row_id: 2,
            bytea_type: (),
            bytea_escape_type: ()
        }; 
        
        test:assertEquals(result3, expectedDataRow3, "Binary Function second select did not match.");
    }
    
    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Third result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result4 = data?.value;
        BinaryFunctionRecord expectedDataRow4 = {
            row_id: rowId,
            bytea_type: byteArray,
            bytea_escape_type: byteArray
        }; 
        
        test:assertEquals(result4, expectedDataRow4, "Binary Function third select did not match.");
        check qResult.close();
        check ret.close();
    }
}

public type XmlFunctionRecord record {
    int? row_id;
    xml? xml_type;
};

@test:Config {
    groups: ["functions"],
    dependsOn: [testBooleanFunctionInParameter]
}
function testXmlFunctionInParameter() returns error? {
    int rowId = 3;
    PGXmlValue xmlType = new ("<foo><tag>bar</tag><tag>tag</tag></foo>");

    sql:ParameterizedCallQuery sqlQuery =
      `
      select * from XmlInFunction(${rowId}, ${xmlType});
    `;
    sql:ProcedureCallResult ret = check callFunction(sqlQuery, functionsDatabase, [XmlFunctionRecord, XmlFunctionRecord, XmlFunctionRecord]);

    stream<record{}, sql:Error>? qResult = ret.queryResult;

    if (qResult is ()) {
        test:assertFail("First result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result1 = data?.value;
        XmlFunctionRecord expectedDataRow = {
            row_id: 1,
            xml_type: xml `<foo><tag>bar</tag><tag>tag</tag></foo>`
        };        
        test:assertEquals(result1, expectedDataRow, "Xml Function first select did not match.");
    }

    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Second result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result2 = data?.value;
        XmlFunctionRecord expectedDataRow2 = {
            row_id: 2,
            xml_type: ()
        }; 
        
        test:assertEquals(result2, expectedDataRow2, "Xml Function second select did not match.");
    }

    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Third result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result3 = data?.value;
        XmlFunctionRecord expectedDataRow3 = {
            row_id: 3,
            xml_type: xml `<foo><tag>bar</tag><tag>tag</tag></foo>`
        }; 
        test:assertEquals(result3, expectedDataRow3, "Xml Function third select did not match.");
        check qResult.close();
        check ret.close();
    }
}

public type MoneyFunctionRecord record {
    int? row_id;
    float? money_type;
};

@test:Config {
    groups: ["functions"],
    dependsOn: [testXmlFunctionInParameter]
}
function testMoneyFunctionInParameter() returns error? {
    int rowId = 3;
    MoneyValue moneyType = new (11.1);

    sql:ParameterizedCallQuery sqlQuery =
      `
      select * from MoneyInFunction(${rowId}, ${moneyType});
    `;
    sql:ProcedureCallResult ret = check callFunction(sqlQuery, functionsDatabase, [MoneyFunctionRecord, MoneyFunctionRecord, MoneyFunctionRecord]);

    stream<record{}, sql:Error>? qResult = ret.queryResult;

    if (qResult is ()) {
        test:assertFail("First result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result1 = data?.value;
        MoneyFunctionRecord expectedDataRow = {
            row_id: 1,
            money_type: 124.56
        };        
        test:assertEquals(result1, expectedDataRow, "Money Function first select did not match.");
    }

    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Second result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result2 = data?.value;
        MoneyFunctionRecord expectedDataRow2 = {
            row_id: 2,
            money_type: ()
        }; 
        
        test:assertEquals(result2, expectedDataRow2, "Money Function second select did not match.");
    }

    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Third result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result3 = data?.value;
        MoneyFunctionRecord expectedDataRow3 = {
            row_id: 3,
            money_type: 11.1
        }; 
        test:assertEquals(result3, expectedDataRow3, "Money Function third select did not match.");
        check qResult.close();
        check ret.close();
    }
}

public type EnumFunctionRecord record {
    int? row_id;
    string? value_type;
};

@test:Config {
    groups: ["functions"],
    dependsOn: [testCharacterFunctionInParameter]
}
function testEnumFunctionInParameter() returns error? {
    int rowId = 3;
    Enum enumRecord = {value: "value2"};
    EnumValue enumValue = new (sqlTypeName = "value", value = enumRecord);

    sql:ParameterizedCallQuery sqlQuery =
      `
      select * from EnumInFunction(${rowId}, ${enumValue});
    `;
    sql:ProcedureCallResult ret = check callFunction(sqlQuery, functionsDatabase, [EnumFunctionRecord, EnumFunctionRecord, EnumFunctionRecord]);

    stream<record{}, sql:Error>? qResult = ret.queryResult;

    if (qResult is ()) {
        test:assertFail("First result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result1 = data?.value;
        EnumFunctionRecord expectedDataRow = {
            row_id: 1,
            value_type: "value1"
        };        
        test:assertEquals(result1, expectedDataRow, "Enum Function first select did not match.");
    }

    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Second result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result2 = data?.value;
        EnumFunctionRecord expectedDataRow2 = {
            row_id: 2,
            value_type: ()
        }; 
        
        test:assertEquals(result2, expectedDataRow2, "Enum Function second select did not match.");
    }

    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Third result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result3 = data?.value;
        EnumFunctionRecord expectedDataRow3 = {
            row_id: 3,
            value_type: "value2"
        }; 
        test:assertEquals(result3, expectedDataRow3, "Enum Function third select did not match.");
        check qResult.close();
        check ret.close();
    }
}

public type ArrayFunctionRecord record {
  int row_id;
  int[]? bigintarray_type;
  decimal[]? numericarray_type;
  string[]? varchararray_type;
  string[]? textarray_type;
  boolean[]? booleanarray_type;
};

@test:Config {
    groups: ["functions"],
    dependsOn: [testTextSearchFunctionInParameter]
}
function testArrayFunctionInParameter() returns error? {
    int rowId = 3;
    int[]? bigIntArray = [111,111,111];
    decimal[]? numericArray =  [11.11,11.11];
    string[]? varcharArray = ["This is varchar","This is varchar"];
    string[]? textArray = ["This is text123","This is text123"];
    boolean[]? booleanArray = [true, false, true];
    byte[][]? byteaArray = [[1,2,3],[11,5,7]];

    sql:ArrayValue bigintarrayType = new(bigIntArray);
    sql:ArrayValue numericarrayType = new(numericArray);
    sql:ArrayValue varchararrayType = new(varcharArray);
    sql:ArrayValue textarrayType = new(textArray);
    sql:ArrayValue booleanarrayType = new(booleanArray);
    sql:ArrayValue byteaarrayType = new(byteaArray);


    sql:ParameterizedCallQuery sqlQuery =
    `
    select row_id, booleanarray_type, bigintarray_type, numericarray_type,
    varchararray_type, textarray_type from ArrayInFunction(${rowId}, ${bigintarrayType},
     ${numericarrayType}, ${varchararrayType}, ${textarrayType}, ${booleanarrayType}, ${byteaarrayType});
    `;
    sql:ProcedureCallResult ret = check callFunction(sqlQuery, functionsDatabase, [ArrayFunctionRecord, ArrayFunctionRecord, ArrayFunctionRecord]);

    stream<record{}, sql:Error>? qResult = ret.queryResult;

    if (qResult is ()) {
        test:assertFail("First result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result1 = data?.value;
        int[]? bigIntArray2 = [10000,20000,30000];
        decimal[]? numericArray2 = [1.1,2.2,3.3,4.4];
        string[]? varcharArray2 = ["This is a VarChar1","This is a VarChar2"];
        string[]? textArray2 = ["This is a Text1","This is a Text2"];
        ArrayFunctionRecord expectedDataRow = {
            row_id: 1,
            bigintarray_type: bigIntArray2,
            numericarray_type: numericArray2,
            varchararray_type: varcharArray2,
            textarray_type: textArray2,
            booleanarray_type: booleanArray
        };      
        test:assertEquals(result1, expectedDataRow, "Array Function first select did not match.");
    }

    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Second result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result3 = data?.value;
        ArrayFunctionRecord expectedDataRow3 = {
            row_id: 2,
            bigintarray_type: (),
            numericarray_type: (),
            varchararray_type: (),
            textarray_type: (),
            booleanarray_type: ()
        }; 
        
        test:assertEquals(result3, expectedDataRow3, "Array Function second select did not match.");
    }
    
    qResult = ret.queryResult;
    if (qResult is ()) {
        test:assertFail("Third result set is empty.");
    } else {
        record {|record {} value;|}? data = check qResult.next();
        record {}? result4 = data?.value;
        ArrayFunctionRecord expectedDataRow4 = {
            row_id: rowId,
            bigintarray_type: bigIntArray,
            numericarray_type: numericArray,
            varchararray_type: varcharArray,
            textarray_type: textArray,
            booleanarray_type: booleanArray
        }; 
        
        test:assertEquals(result4, expectedDataRow4, "Array Function third select did not match.");
        check qResult.close();
        check ret.close();
        }

}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testXmlFunctionInParameter]
}
function testNumericFunctionOutParameter() returns error? {
    int rowId = 1;
    InOutParameter rowIdOutParameter = new (rowId);
    sql:SmallIntOutParameter smallintOutParameter = new ();
    sql:IntegerOutParameter intOutParameter = new ();
    sql:BigIntOutParameter bigintOutParameter = new ();
    sql:DecimalOutParameter decimalOutParameter = new ();
    sql:NumericOutParameter numericOutParameter = new ();
    sql:RealOutParameter realOutParameter = new ();
    sql:DoubleOutParameter doubleOutParameter = new ();

    sql:ParameterizedCallQuery sqlQuery =
      `
      { call NumericOutFunction(${rowIdOutParameter}, ${smallintOutParameter}, ${intOutParameter}, ${bigintOutParameter}, ${decimalOutParameter},
                                ${numericOutParameter}, ${realOutParameter}, ${doubleOutParameter}) }
    `;
    sql:ProcedureCallResult result = check callFunction(sqlQuery, functionsDatabase);

    decimal decimalVal = 123.456;

    test:assertEquals(smallintOutParameter.get(int), 1, "SmallInt Datatype Doesn;t Match");
    test:assertEquals(intOutParameter.get(int), 123, "Int Datatype Doesn't Match");
    test:assertEquals(bigintOutParameter.get(int), 123456, "Bigint Datatype Doesn;t Match");
    test:assertEquals(decimalOutParameter.get(decimal), decimalVal, "Decimal Datatype Doesn't Match");
    test:assertEquals(numericOutParameter.get(decimal), decimalVal, "Numeric Datatype Doesn;t Match");
    test:assertTrue(realOutParameter.get(float) is float, "Real Datatype Doesn't Match");
    test:assertTrue(doubleOutParameter.get(float) is float, "Double Datatype Doesn't Match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testNumericFunctionOutParameter]
}
function testCharacterFunctionOutParameter() returns error? {
    int rowId = 1;
    InOutParameter rowIdInoutValue = new (rowId);
    sql:CharOutParameter charOutValue = new ();
    sql:VarcharOutParameter varcharOutValue = new ();
    sql:TextOutParameter textOutValue = new ();
    sql:TextOutParameter nameOutValue = new ();

    sql:ParameterizedCallQuery sqlQuery =
      `
      { call CharacterOutFunction(${rowIdInoutValue}, ${charOutValue}, ${varcharOutValue}, ${textOutValue}, ${nameOutValue}) }
    `;
    sql:ProcedureCallResult result = check callFunction(sqlQuery, functionsDatabase);

    test:assertEquals(charOutValue.get(string), "This is a char1", "Char Data type doesnt match.");
    test:assertEquals(varcharOutValue.get(string), "This is a varchar1", "Varchar Data type doesnt match.");
    test:assertEquals(textOutValue.get(string), "This is a text1", "Text Data type doesnt match.");
    test:assertEquals(nameOutValue.get(string), "This is a name1", "Name Data type doesnt match.");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testCharacterFunctionOutParameter]
}
function testBooleanFunctionOutParameter() returns error? {
    int rowId = 1;
    InOutParameter rowIdInoutValue = new (rowId);
    sql:BooleanOutParameter booleanOutValue = new ();

    sql:ParameterizedCallQuery sqlQuery =
      `
      { call BooleanOutFunction(${rowIdInoutValue}, ${booleanOutValue}) }
    `;
    sql:ProcedureCallResult result = check callFunction(sqlQuery, functionsDatabase);

    test:assertEquals(booleanOutValue.get(boolean), true, "Boolean Datatype doesn't match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testBooleanFunctionOutParameter]
}
function testDatetimeFunctionOutParameter() returns error? {

    int rowId = 1;
    InOutParameter rowIdInoutValue = new (rowId);
    sql:DateOutParameter dateOutValue = new ();
    sql:TimeOutParameter timetzOutValue = new ();
    sql:TimeOutParameter timeOutValue = new ();
    sql:TimestampOutParameter timestampOutValue = new ();
    sql:TimestampOutParameter timestamptzOutValue = new ();
    IntervalOutParameter intervalOutValue = new ();

    sql:ParameterizedCallQuery sqlQuery =
    `
        { call DatetimeOutFunction(${rowIdInoutValue}, ${dateOutValue}, ${timeOutValue}, ${timetzOutValue},
            ${timestampOutValue}, ${timestamptzOutValue}, ${intervalOutValue}) }
    `;
    sql:ProcedureCallResult result = check callFunction(sqlQuery, functionsDatabase);

    Interval intervalRecord = {years: 1, months: 2, days: 3, hours: 4, minutes: 5, seconds: 6};

    test:assertTrue(timestampOutValue.get(string) is string, "Timestamp Datatype Doesn't Match");
    test:assertTrue(timestamptzOutValue.get(string) is string, "Timestamptz Datatype Doesn't Match");
    test:assertTrue(dateOutValue.get(string)is string, "Date Datatype Doesn't Match");
    test:assertTrue(timeOutValue.get(string) is string, "Time Datatype Doesn't Match");
    test:assertTrue(timetzOutValue.get(string) is string, "Timetz Datatype Doesn't Match");
    test:assertEquals(intervalOutValue.get(string), "1 years 2 mons 3 days 4 hours 5 mins 6.0 secs", "Interval Datatype Doesn't Match");

    Interval interval = {years: 1, months: 2, days: 3, hours: 4, minutes: 5, seconds: 6};

    test:assertTrue(dateOutValue.get(time:Date) is time:Date, "Date Datatype Doesn't Match");
    test:assertTrue(timeOutValue.get(time:TimeOfDay) is time:TimeOfDay, "Time Datatype Doesn't Match");
    test:assertTrue(timetzOutValue.get(time:TimeOfDay) is time:TimeOfDay, "Timetz Datatype Doesn't Match");
    test:assertEquals(intervalOutValue.get(Interval), interval, "Interval Datatype Doesn't Match");
    test:assertTrue(timestampOutValue.get(time:Civil) is time:Civil, "Timestamp Datatype Doesn't Match");
    test:assertTrue(timestamptzOutValue.get(time:Civil) is time:Civil, "Timestamptz Datatype Doesn't Match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testDatetimeFunctionOutParameter]
}
function testNetworkFunctionOutParameter() returns error? {
    int rowId = 1;

    InOutParameter rowIdInoutValue = new (rowId);
    InetOutParameter inetInoutValue = new ();
    CidrOutParameter cidrInoutValue = new ();
    MacAddrOutParameter macaddrInoutValue = new ();
    MacAddr8OutParameter macaddr8InoutValue = new ();

    sql:ParameterizedCallQuery sqlQuery =
      `
      { call NetworkOutFunction(${rowIdInoutValue}, ${inetInoutValue}, ${cidrInoutValue},
       ${macaddrInoutValue}, ${macaddr8InoutValue}) }
    `;
    sql:ProcedureCallResult result = check callFunction(sqlQuery, functionsDatabase);

 
    test:assertEquals(inetInoutValue.get(string), "192.168.0.1/24", "Inet Data type doesnt match.");
    test:assertEquals(cidrInoutValue.get(string), "::ffff:1.2.3.0/120", "Cidr Data type doesnt match.");
    test:assertEquals(macaddrInoutValue.get(string), "08:00:2b:01:02:03", "Macaddress Data type doesnt match.");
    test:assertEquals(macaddr8InoutValue.get(string), "08:00:2b:01:02:03:04:05", "Macadress8 Data type doesnt match.");
}



@test:Config {
    groups: ["procedures"],
    dependsOn: [testNetworkFunctionOutParameter]
}
function testGeometricFunctionOutParameter() returns error? {
    int rowId = 1;
    InOutParameter rowIdInoutValue = new (rowId);
    PointOutParameter pointOutValue = new ();
    LineOutParameter lineOutValue = new ();
    LsegOutParameter lsegOutValue = new ();
    BoxOutParameter boxOutValue = new ();
    PolygonOutParameter polygonOutValue = new ();
    PathOutParameter pathOutValue = new ();
    CircleOutParameter circleOutValue = new ();

    sql:ParameterizedCallQuery sqlQuery =
      `
      { call GeometricOutFunction(${rowIdInoutValue}, ${pointOutValue}, ${lineOutValue}, ${lsegOutValue}, ${boxOutValue}, ${pathOutValue}, ${polygonOutValue}, ${circleOutValue}) }
    `;
    sql:ProcedureCallResult result = check callFunction(sqlQuery, functionsDatabase);

    Point pointOutRecord = {x: 1.0, y: 2.0};
    Line lineOutRecord = {a: 1.0, b: 2.0, c: 3.0};
    LineSegment lsegOutRecord = {x1: 1.0, y1: 1.0, x2: 2.0, y2: 2.0};
    Box boxOutRecord = {x1: 1.0, y1: 1.0, x2: 2.0, y2: 2.0};
    Path pathOutRecord = {open: true, points: [{x: 1, y: 1}, {x: 2, y: 2}]};
    Polygon polygonOutRecord = {points: [{x: 1, y: 1}, {x: 2, y: 2}]};
    Circle circleOutRecord = {x: 1.0, y: 1.0, r:1.0};

    test:assertEquals(pointOutValue.get(string), "(1.0,2.0)", "Point Data type doesnt match.");
    test:assertEquals(lineOutValue.get(string), "{1.0,2.0,3.0}", "Line Data type doesnt match.");
    test:assertEquals(lsegOutValue.get(string), "[(1.0,1.0),(2.0,2.0)]", "Line Segment Data type doesnt match.");
    test:assertEquals(boxOutValue.get(string), "(2.0,2.0),(1.0,1.0)", "Box Data type doesnt match.");
    test:assertEquals(pathOutValue.get(string), "[(1.0,1.0),(2.0,2.0)]", "Path Data type doesnt match.");
    test:assertEquals(polygonOutValue.get(string), "((1.0,1.0),(2.0,2.0))", "Polygon Data type doesnt match.");
    test:assertEquals(circleOutValue.get(string), "<(1.0,1.0),1.0>", "Circle Data type doesnt match.");

    test:assertEquals(pointOutValue.get(Point), pointOutRecord, "Point Data type doesnt match.");
    test:assertEquals(lineOutValue.get(Line), lineOutRecord, "Line Data type doesnt match.");
    test:assertEquals(lsegOutValue.get(LineSegment), lsegOutRecord, "Line Segment Data type doesnt match.");
    test:assertEquals(boxOutValue.get(Box), boxOutRecord, "Box Data type doesnt match.");
    test:assertEquals(pathOutValue.get(Path), pathOutRecord, "Path Data type doesnt match.");
    test:assertEquals(polygonOutValue.get(Polygon), polygonOutRecord, "Polygon Data type doesnt match.");
    test:assertEquals(circleOutValue.get(Circle), circleOutRecord, "Circle Data type doesnt match.");
}


@test:Config {
    groups: ["procedures"],
    dependsOn: [testGeometricFunctionOutParameter]
}
function testUuidFunctionOutParameter() returns error? {
    int rowId = 1;
    InOutParameter rowIdInoutValue = new (rowId);
    UuidOutParameter uuidOutValue = new ();

    sql:ParameterizedCallQuery sqlQuery =
      `
      { call UuidOutFunction(${rowIdInoutValue}, ${uuidOutValue}) }
    `;
    sql:ProcedureCallResult result = check callFunction(sqlQuery, functionsDatabase);

    test:assertEquals(uuidOutValue.get(string), "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11", "UUID Datatype doesn't match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testUuidFunctionOutParameter]
}
function testPglsnFunctionOutParameter() returns error? {
    int rowId = 1;
    InOutParameter rowIdInoutValue = new (rowId);
    PglsnOutParameter pglsnOutValue = new ();

    sql:ParameterizedCallQuery sqlQuery =
      `
      { call PglsnOutFunction(${rowIdInoutValue}, ${pglsnOutValue}) }
    `;
    sql:ProcedureCallResult result = check callFunction(sqlQuery, functionsDatabase);

    test:assertEquals(pglsnOutValue.get(string), "16/B374D848", "Pg_lsn Data type Doesn't match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testPglsnFunctionOutParameter]
}
function testJsonFunctionOutParameter() returns error? {
    int rowId = 1;
    InOutParameter rowIdInoutValue = new (rowId);
    JsonOutParameter jsonOutValue = new ();
    JsonbOutParameter jsonbOutValue = new ();
    JsonpathOutParameter jsonPathOutValue = new ();

    sql:ParameterizedCallQuery sqlQuery =
      `
      { call JsonOutFunction(${rowIdInoutValue}, ${jsonOutValue}, ${jsonbOutValue}, ${jsonPathOutValue}) }
    `;
    sql:ProcedureCallResult result = check callFunction(sqlQuery, functionsDatabase);

    test:assertEquals(jsonOutValue.get(string), "{\"key1\": \"value\", \"key2\": 2}", "Json Datatype Doesn't Match");
    test:assertEquals(jsonbOutValue.get(string), "{\"key1\": \"value\", \"key2\": 2}", "Jsonb Datatype Doesn't Match");
    test:assertEquals(jsonPathOutValue.get(string), "$.\"floor\"[*].\"apt\"[*]?(@.\"area\" > 40 && @.\"area\" < 90)?(@.\"rooms\" > 1)", "Json path Datatype Doesn't Match");

    test:assertEquals(jsonOutValue.get(json), {"key1": "value", "key2": 2}, "Json Datatype Doesn't Match");
    test:assertEquals(jsonbOutValue.get(json), {"key1": "value", "key2": 2}, "Jsonb Datatype Doesn't Match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testJsonFunctionOutParameter]
}
function testBitFunctionOutParameter() returns error? {
    int rowId = 1;
    InOutParameter rowIdInoutValue = new (rowId);
    VarbitStringOutParameter varbitOutValue = new ();
    PGBitOutParameter bitOutValue = new ();

    sql:ParameterizedCallQuery sqlQuery =
      `
      { call BitOutFunction(${rowIdInoutValue}, ${varbitOutValue}, ${bitOutValue}) }
    `;
    sql:ProcedureCallResult result = check callFunction(sqlQuery, functionsDatabase);

    test:assertEquals(varbitOutValue.get(string), "1101", "Bit Vary Datatype Doesn;t Match");
    test:assertEquals(bitOutValue.get(boolean), true, "Bit Datatype Doesn't Match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testBitFunctionOutParameter]
}
function testRangeFunctionOutParameter() returns error? {
    int rowId = 1;
    InOutParameter rowIdInoutValue = new (rowId);
    IntegerRangeOutParameter int4rangeOutValue = new ();
    LongRangeOutParameter int8rangeOutValue = new ();
    NumericRangeOutParameter numrangeOutValue = new ();
    TimestampRangeOutParameter tsrangeOutValue = new ();
    TimestamptzRangeOutParameter tstzrangeOutValue = new ();
    DateRangeOutParameter daterangeOutValue = new ();

    IntegerRange int4RangeRecord = {upper: 50 , lower: 3 , upperboundInclusive: false, lowerboundInclusive: true};        
    LongRange int8RangeRecord = {upper: 100, lower: 11, upperboundInclusive: false, lowerboundInclusive: true};
    NumericaRange numRangeRecord = {upper: 24, lower: 0, upperboundInclusive: false, lowerboundInclusive: false}; 
    TimestampRange tsrangeRecordType = {lower: "2010-01-01 14:30:00", upper: "2010-01-01 15:30:00"};
    TimestamptzRange tstzrangeRecordType = {lower: "2010-01-01 20:00:00+05:30", upper: "2010-01-01 21:00:00+05:30"};
    DateRange daterangeRecordType = {lower: "2010-01-02", upper: "2010-01-03", lowerboundInclusive: true};

    sql:ParameterizedCallQuery sqlQuery =
    `
    { call RangeOutFunction(${rowIdInoutValue}, ${int4rangeOutValue}, ${int8rangeOutValue}, ${numrangeOutValue}, ${tsrangeOutValue}, ${tstzrangeOutValue}, ${daterangeOutValue}) }
    `;
    sql:ProcedureCallResult result = check callFunction(sqlQuery, functionsDatabase);

    test:assertEquals(int4rangeOutValue.get(string), "[3,50)", "Int4range Datatype Doesn't Match");
    test:assertEquals(int8rangeOutValue.get(string), "[11,100)", "Int8range Datatype Doesn't Match");
    test:assertEquals(numrangeOutValue.get(string), "(0,24)", "Numrnge Datatype Doesn't Match");
    test:assertEquals(tsrangeOutValue.get(string), "(\"2010-01-01 14:30:00\",\"2010-01-01 15:30:00\")", "Tsrange Datatype Doesn't Match");
    test:assertTrue(tstzrangeOutValue.get(string) is string, "Tstzrange Datatype Doesn't Match");
    test:assertEquals(daterangeOutValue.get(string), "[2010-01-02,2010-01-03)", "Daterange Datatype Doesn't Match");

    test:assertEquals(int4rangeOutValue.get(IntegerRange), int4RangeRecord, "Int4range Datatype Doesn't Match");
    test:assertEquals(int8rangeOutValue.get(LongRange), int8RangeRecord, "Int8range Datatype Doesn't Match");
    test:assertEquals(numrangeOutValue.get(NumericaRange), numRangeRecord, "Numrnge Datatype Doesn't Match");
    test:assertEquals(tsrangeOutValue.get(TimestampRange), tsrangeRecordType, "Tsrange Datatype Doesn't Match");
    test:assertTrue(tstzrangeOutValue.get(TimestamptzRange) is TimestamptzRange, "Tstzrange Datatype Doesn't Match");
    test:assertEquals(daterangeOutValue.get(DateRange), daterangeRecordType, "Daterange Datatype Doesn't Match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testRangeFunctionOutParameter]
}
function testTextsearchFunctionOutParameter() returns error? {
    int rowId = 1;
    InOutParameter rowIdInoutValue = new (rowId);
    TsvectorOutParameter tsvectorOutValue = new ();
    TsqueryOutParameter tsqueryOutValue = new ();

    sql:ParameterizedCallQuery sqlQuery =
      `
      { call TextsearchOutFunction(${rowIdInoutValue}, ${tsvectorOutValue}, ${tsqueryOutValue}) }
    `;
    sql:ProcedureCallResult result = check callFunction(sqlQuery, functionsDatabase);

    test:assertEquals(tsvectorOutValue.get(string), "'a' 'and' 'ate' 'cat' 'fat' 'mat' 'on' 'rat' 'sat'", "Tsvector Datatype Doesn't Match");
    test:assertEquals(tsqueryOutValue.get(string), "'fat' & 'rat'", "Tsquery Datatype Doesn't Match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testTextsearchFunctionOutParameter]
}
function testObjectidentifierFunctionOutParameter() returns error? {
    int rowId = 1;
    InOutParameter rowIdInoutValue = new (rowId);
    sql:BigIntOutParameter oidOutValue = new ();
    RegclassOutParameter regclassOutValue = new ();
    RegnamespaceOutParameter regconfigOutValue = new ();
    RegconfigOutParameter regdictionaryOutValue = new ();
    RegdictionaryOutParameter regnamespaceOutValue = new ();
    RegoperOutParameter regoperOutValue = new ();
    RegoperatorOutParameter regoperatorOutValue = new ();
    RegprocOutParameter regprocOutValue = new ();
    RegprocedureOutParameter regprocedureOutValue = new ();
    RegroleOutParameter regroleOutValue = new ();
    RegtypeOutParameter regtypeOutValue = new();

    sql:ParameterizedCallQuery sqlQuery =
      `
      { call ObjectidentifierOutFunction(${rowIdInoutValue}, ${oidOutValue}, ${regclassOutValue}, ${regconfigOutValue}, ${regdictionaryOutValue}, 
                                ${regnamespaceOutValue}, ${regoperOutValue}, ${regoperatorOutValue}, ${regprocOutValue}, ${regprocedureOutValue},
                                 ${regroleOutValue}, ${regtypeOutValue}) }
    `;
    sql:ProcedureCallResult result = check callFunction(sqlQuery, functionsDatabase);

    test:assertEquals(oidOutValue.get(string), "12", "OID Datatype Doesn;t Match");
    test:assertEquals(regclassOutValue.get(string), "pg_type", "Reg class Datatype Doesn't Match");
    test:assertEquals(regconfigOutValue.get(string), "english", "Reg config Datatype Doesn;t Match");
    test:assertEquals(regdictionaryOutValue.get(string), "simple", "Reg Dictionary Datatype Doesn't Match");
    test:assertEquals(regnamespaceOutValue.get(string), "pg_catalog", "Reg namespace Datatype Doesn;t Match");
    test:assertEquals(regoperOutValue.get(string), "!", "Reg oper Datatype Doesn't Match");
    test:assertEquals(regoperatorOutValue.get(string), "*(integer,integer)", "Reg operator Datatype Doesn;t Match");
    test:assertEquals(regprocOutValue.get(string), "now", "Reg proc Datatype Doesn't Match");
    test:assertEquals(regprocedureOutValue.get(string), "sum(integer)", "Reg procedure Datatype Doesn;t Match");
    test:assertEquals(regroleOutValue.get(string), "postgres", "Reg role Datatype Doesn't Match");
    test:assertEquals(regtypeOutValue.get(string), "integer", "Reg type Datatype Doesn;t Match");
}


@test:Config {
    groups: ["procedures"],
    dependsOn: [testObjectidentifierFunctionOutParameter]
}
function testXmlFunctionOutParameter() returns error? {
    int rowId = 1;

    InOutParameter rowIdInoutValue = new (rowId);
    PGXmlOutParameter xmlOutValue = new ();

    sql:ParameterizedCallQuery sqlQuery =
      `
      { call XmlOutFunction(${rowIdInoutValue}, ${xmlOutValue}) }
    `;
    sql:ProcedureCallResult result = check callFunction(sqlQuery, functionsDatabase);
    xml xmlValue = xml `<foo><tag>bar</tag><tag>tag</tag></foo>`;
    test:assertEquals(xmlOutValue.get(xml), xmlValue, "Xml Datatype doesn't match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testXmlFunctionOutParameter]
}
function testBinaryFunctionOutParameter() returns error? {
    int rowId = 1;

    InOutParameter rowIdInoutValue = new (rowId);
    ByteaOutParameter byteaOutValue = new ();
    ByteaOutParameter byteaEscapeOutValue = new ();

    sql:ParameterizedCallQuery sqlQuery =
      `
      { call BinaryOutFunction(${rowIdInoutValue}, ${byteaOutValue}, ${byteaEscapeOutValue}) }
    `;
    sql:ProcedureCallResult result = check callFunction(sqlQuery, functionsDatabase);
    test:assertTrue(byteaOutValue.get(string) is string, "Binary Datatype doesn't match");
    test:assertTrue(byteaEscapeOutValue.get(string) is string, "Binary Datatype doesn't match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testBinaryFunctionOutParameter]
}
function testMoneyFunctionOutParameter() returns error? {
    int rowId = 1;
    MoneyValue moneyType = new ();

    InOutParameter rowIdInoutValue = new (rowId);
    MoneyOutParameter moneyInoutValue = new ();

    sql:ParameterizedCallQuery sqlQuery =
      `
      { call MoneyOutFunction(${rowIdInoutValue}, ${moneyInoutValue}) }
    `;
    sql:ProcedureCallResult result = check callFunction(sqlQuery, proceduresDatabase);
    float moneyValue = 124.56;
    test:assertEquals(moneyInoutValue.get(string), "124.56", "Money Datatype doesn't match");
    test:assertEquals(moneyInoutValue.get(float), moneyValue, "Money Datatype doesn't match");
}

@test:Config {
    groups: ["procedures"],
    dependsOn: [testGeometricFunctionOutParameter]
}
function testEnumFunctionOutParameter() returns error? {
    int rowId = 1;
    InOutParameter rowIdInoutValue = new (rowId);
    EnumOutParameter valueOutValue = new ();

    sql:ParameterizedCallQuery sqlQuery =
      `
      { call EnumOutFunction(${rowIdInoutValue}, ${valueOutValue}) }
    `;
    sql:ProcedureCallResult result = check callFunction(sqlQuery, functionsDatabase);

    test:assertEquals(valueOutValue.get(string), "value1", "Enum Datatype doesn't match");
}

function callFunction(sql:ParameterizedCallQuery sqlQuery, string database, typedesc<record {}>[] rowTypes = []) returns sql:ProcedureCallResult | error {
    Client dbClient = check new (host, user, password, database, port, connectionPool = {
        maxOpenConnections: 7
    });
    sql:ProcedureCallResult result = check dbClient->call(sqlQuery, rowTypes);
    check dbClient.close();
    return result;
}
