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
    sql:ProcedureCallResult ret = callFunction(sqlQuery, functionsDatabase, [NumericFunctionRecord, NumericFunctionRecord, NumericFunctionRecord]);

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
    sql:ProcedureCallResult ret = callFunction(sqlQuery, functionsDatabase, [CharacterFunctionRecord, CharacterFunctionRecord, CharacterFunctionRecord]);

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
    sql:ProcedureCallResult ret = callFunction(sqlQuery, functionsDatabase, [BooleanFunctionRecord, BooleanFunctionRecord, BooleanFunctionRecord]);

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
    sql:ProcedureCallResult ret = callFunction(sqlQuery, functionsDatabase, [UuidFunctionRecord, UuidFunctionRecord, UuidFunctionRecord]);

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
    MacaddrValue macaddrValue = new("08:00:2b:01:02:03");
    Macaddr8Value macaddr8Value = new("08:00:2b:01:02:03:04:05");

    sql:ParameterizedCallQuery sqlQuery =
      `
      select * from NetworkInFunction(${rowId}, ${inetValue}, ${cidrValue}, ${macaddrValue}, ${macaddr8Value});
    `;
    sql:ProcedureCallResult ret = callFunction(sqlQuery, functionsDatabase, [NetworkFunctionRecord, NetworkFunctionRecord, NetworkFunctionRecord]);

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
    PathValue pathType = new ({points: [{x: 2, y:2}, {x: 2, y:2}], isOpen: true});
    PolygonValue polygonType = new ([{x: 2, y:2}, {x: 2, y:2}]);
    CircleValue circleType = new ({x: 2, y:2, r:2});

    sql:ParameterizedCallQuery sqlQuery =
      `
      select * from GeometricInFunction(${rowId}, ${pointType}, ${lineType}, ${lsegType}, ${boxType}, ${pathType}, ${polygonType}, ${circleType});
    `;
    sql:ProcedureCallResult ret = callFunction(sqlQuery, functionsDatabase, [GeometricFunctionRecord, GeometricFunctionRecord, GeometricFunctionRecord]);

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
    sql:ProcedureCallResult ret = callFunction(sqlQuery, functionsDatabase, [JsonFunctionRecord, JsonFunctionRecord, JsonFunctionRecord]);

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
    sql:ProcedureCallResult ret = callFunction(sqlQuery, functionsDatabase, [BitFunctionRecord, BitFunctionRecord, BitFunctionRecord]);

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
    sql:ProcedureCallResult ret = callFunction(sqlQuery, functionsDatabase, [PglsnFunctionRecord, PglsnFunctionRecord, PglsnFunctionRecord]);

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
    string? timetz_type;
    string? timestamp_type;
    string? timestamptz_type;
    IntervalRecordType? interval_type;
};

@test:Config {
    groups: ["functions"],
    dependsOn: [testPglsnFunctionInParameter]
}
function testDatetimeFunctionInParameter() returns error? {
    int rowId = 3;
    time:Time|error timeGenerated = time:createTime(2017, 3, 28, 23, 42, 45,554, "Asia/Colombo");
    if (timeGenerated is time:Time) {
        sql:TimestampValue timestampValue = new(timeGenerated);
        sql:TimestampValue timestamptzValue = new(timeGenerated);
        sql:DateValue dateValue = new(timeGenerated);
        sql:TimeValue timeValue = new(timeGenerated);
        sql:TimeValue timetzValue = new(timeGenerated);
        IntervalValue intervalValue = new({years:1, months:2, days:3, hours:4, minutes:5, seconds:6});


        sql:ParameterizedCallQuery sqlQuery =
        `
        select * from DatetimeInFunction(${rowId}, ${dateValue}, ${timeValue}, ${timetzValue}, ${timestampValue}, ${timestamptzValue}, ${intervalValue});
        `;
        sql:ProcedureCallResult ret = callFunction(sqlQuery, functionsDatabase, [DatetimeFunctionRecord, DatetimeFunctionRecord, DatetimeFunctionRecord]);

        stream<record{}, sql:Error>? qResult = ret.queryResult;

        if (qResult is ()) {
            test:assertFail("First result set is empty.");
        } else {
            record {|record {} value;|}? data = check qResult.next();
            record {}? result1 = data?.value;
            DatetimeFunctionRecord expectedDataRow = {
                row_id: 1,
                date_type: "1999-01-08+06:00",
                time_type: "09:35:06.000+05:30",
                timetz_type: "13:35:06.000+05:30",
                timestamp_type: "1999-01-08T10:05:06.000+06:00",
                timestamptz_type: "2004-10-19T14:23:54.000+06:00",
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
                timetz_type: (),
                timestamp_type: (),
                timestamptz_type: (),
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
                date_type: "2017-03-28+05:30",
                time_type: "05:12:45.554+05:30",
                timetz_type: "23:42:45.554+05:30",
                timestamp_type: "2017-03-29T05:12:45.554+05:30",
                timestamptz_type: "2017-03-28T23:42:45.554+05:30",
                interval_type: {years:1, months:2, days:3, hours:4, minutes:5, seconds:6}
            }; 
            
            test:assertEquals(result4, expectedDataRow4, "Datetime Function third select did not match.");
            check qResult.close();
            check ret.close();
        }

    }
    else {
        test:assertFail("Invalid Time value generated ");
    }
}

public type RangeFunctionRecord record {
    int? row_id;
    string? int4range_type;
    string? int8range_type;
    string? numrange_type;
    string? tsrange_type;
    string? tstzrange_type;
    string? daterange_type;
};

@test:Config {
    groups: ["functions"],
    dependsOn: [testDatetimeFunctionInParameter]
}
function testRangeFunctionInParameter() returns error? {
    int rowId = 3;
    Int4rangeValue int4rangeValue = new("(2,50)");
    Int8rangeValue int8rangeValue = new("(10,100)");
    NumrangeValue numrangeValue = new("(0.1,2.4)");
    TsrangeValue tsrangeValue = new("(2010-01-01 14:30, 2010-01-01 15:30)");
    TstzrangeValue tstzrangeValue = new("(2010-01-01 14:30, 2010-01-01 15:30)");
    DaterangeValue daterangeValue = new("(2010-01-01 14:30, 2010-01-03 )");


    sql:ParameterizedCallQuery sqlQuery =
    `
    select * from RangeInFunction(${rowId}, ${int4rangeValue}, ${int8rangeValue}, ${numrangeValue}, ${tsrangeValue}, ${tstzrangeValue}, ${daterangeValue});
    `;
    sql:ProcedureCallResult ret = callFunction(sqlQuery, functionsDatabase, [RangeFunctionRecord, RangeFunctionRecord, RangeFunctionRecord]);

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
            tstzrange_type: "(\"2010-01-01 20:00:00+05:30\",\"2010-01-01 21:00:00+05:30\")",
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
            tstzrange_type: (),
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
            tstzrange_type: "(\"2010-01-01 14:30:00+05:30\",\"2010-01-01 15:30:00+05:30\")",
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
    sql:ProcedureCallResult ret = callFunction(sqlQuery, functionsDatabase, [TextSearchFunctionRecord, TextSearchFunctionRecord, TextSearchFunctionRecord]);

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
    sql:ProcedureCallResult ret = callFunction(sqlQuery, functionsDatabase, [ObjectidentifierFunctionRecord, ObjectidentifierFunctionRecord, ObjectidentifierFunctionRecord]);

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
    sql:ProcedureCallResult ret = callFunction(sqlQuery, functionsDatabase, [BinaryFunctionRecord, BinaryFunctionRecord, BinaryFunctionRecord]);

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
    sql:ProcedureCallResult ret = callFunction(sqlQuery, functionsDatabase, [XmlFunctionRecord, XmlFunctionRecord, XmlFunctionRecord]);

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

function callFunction(sql:ParameterizedCallQuery sqlQuery, string database, typedesc<record {}>[] rowTypes = []) returns sql:ProcedureCallResult {
    Client dbClient = checkpanic new (host, user, password, database, port);
    sql:ProcedureCallResult result = checkpanic dbClient->call(sqlQuery, rowTypes);
    checkpanic dbClient.close();
    return result;
}
