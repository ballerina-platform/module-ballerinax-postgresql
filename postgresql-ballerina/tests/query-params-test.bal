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

// import ballerina/io;
import ballerina/sql;
import ballerina/test;
import ballerina/time;

string simpleParamsDb = "simple_query_params_db";

@test:Config {
    groups: ["query","query-simple-params"]
}
function querySmallIntParam() {
    int rowId = 1;
    int smalIntValue1 = 1;
    sql:SmallIntValue smalIntValue2 = new (1);
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from NumericTypes WHERE smallint_type = ${smalIntValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from NumericTypes WHERE smallint_type = ${smalIntValue2}`;
    sql:ParameterizedQuery sqlQuery3 = `SELECT * from NumericTypes WHERE smallint_type = ${smalIntValue1} and row_id = ${rowId}`;
    sql:ParameterizedQuery sqlQuery4 = `SELECT * from NumericTypes WHERE smallint_type = ${smalIntValue2} and row_id = ${rowId}`;

    validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
    validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery3, database = simpleParamsDb));
    validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery4, database = simpleParamsDb));

}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryIntParam() {
    int rowId = 1;
    int intValue1 = 123;
    sql:IntegerValue intValue2 = new (123);
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from NumericTypes WHERE int_type = ${intValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from NumericTypes WHERE int_type = ${intValue2}`;
    sql:ParameterizedQuery sqlQuery3 = `SELECT * from NumericTypes WHERE int_type = ${intValue1} and row_id = ${rowId}`;
    sql:ParameterizedQuery sqlQuery4 = `SELECT * from NumericTypes WHERE int_type = ${intValue2} and row_id = ${rowId}`;

    validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
    validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery3, database = simpleParamsDb));
    validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery4, database = simpleParamsDb));

}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryBigIntParam() {
    int rowId = 1;
    int bigIntValue1 = 123456;
    sql:BigIntValue bigIntValue2 = new (123456);
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from NumericTypes WHERE bigint_type = ${bigIntValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from NumericTypes WHERE bigint_type = ${bigIntValue2}`;
    sql:ParameterizedQuery sqlQuery3 = `SELECT * from NumericTypes WHERE bigint_type = ${bigIntValue1} and row_id = ${rowId}`;
    sql:ParameterizedQuery sqlQuery4 = `SELECT * from NumericTypes WHERE bigint_type = ${bigIntValue2} and row_id = ${rowId}`;

    validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
    validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery3, database = simpleParamsDb));
    validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery4, database = simpleParamsDb));

}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryDecimalParam() {
    int rowId = 1;
    decimal decimalValue1 = 123.456;
    sql:DecimalValue decimalValue2 = new (123.456);
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from NumericTypes WHERE decimal_type = ${decimalValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from NumericTypes WHERE decimal_type = ${decimalValue2}`;
    sql:ParameterizedQuery sqlQuery3 = `SELECT * from NumericTypes WHERE decimal_type = ${decimalValue1} and row_id = ${rowId}`;
    sql:ParameterizedQuery sqlQuery4 = `SELECT * from NumericTypes WHERE decimal_type = ${decimalValue2} and row_id = ${rowId}`;

    validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
    validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery3, database = simpleParamsDb));
    validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery4, database = simpleParamsDb));

}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryNumericParam() {
    int rowId = 1;
    decimal numericValue1 = 123.456;
    sql:NumericValue numericValue2 = new (123.456);
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from NumericTypes WHERE numeric_type = ${numericValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from NumericTypes WHERE numeric_type = ${numericValue2}`;
    sql:ParameterizedQuery sqlQuery3 = `SELECT * from NumericTypes WHERE numeric_type = ${numericValue1} and row_id = ${rowId}`;
    sql:ParameterizedQuery sqlQuery4 = `SELECT * from NumericTypes WHERE numeric_type = ${numericValue2} and row_id = ${rowId}`;

    validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
    validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery3, database = simpleParamsDb));
    validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery4, database = simpleParamsDb));

}

// @test:Config {
//     groups: ["query","query-simple-params"]
// }
// function queryRealParam() {
//     int rowId = 1;
//     float realValue1 = 234.567;
//     sql:RealValue realValue2 = new (234.567);
//     sql:ParameterizedQuery sqlQuery1 = `SELECT * from NumericTypes WHERE real_type = ${realValue1}`;
//     sql:ParameterizedQuery sqlQuery2 = `SELECT * from NumericTypes WHERE real_type = ${realValue2}`;
//     sql:ParameterizedQuery sqlQuery3 = `SELECT * from NumericTypes WHERE real_type = ${realValue1} and row_id = ${rowId}`;
//     sql:ParameterizedQuery sqlQuery4 = `SELECT * from NumericTypes WHERE real_type = ${realValue2} and row_id = ${rowId}`;

//     validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
//     validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
//     validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery3, database = simpleParamsDb));
//     validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery4, database = simpleParamsDb));

// }

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryDoubleParam() {
    int rowId = 1;
    float doubleValue1 = 234.567;
    sql:DoubleValue doubleValue2 = new (234.567);
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from NumericTypes WHERE double_type = ${doubleValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from NumericTypes WHERE double_type = ${doubleValue2}`;
    sql:ParameterizedQuery sqlQuery3 = `SELECT * from NumericTypes WHERE double_type = ${doubleValue1} and row_id = ${rowId}`;
    sql:ParameterizedQuery sqlQuery4 = `SELECT * from NumericTypes WHERE double_type = ${doubleValue2} and row_id = ${rowId}`;

    validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
    validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery3, database = simpleParamsDb));
    validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery4, database = simpleParamsDb));

}

@test:Config {
    groups: ["query","query-simple-params"]
}
function querySmallSerialParam() {
    int rowId = 1;
    int smallSerialValue1 = 1;
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from NumericTypes WHERE smallserial_type = ${smallSerialValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from NumericTypes WHERE smallserial_type = ${smallSerialValue1} and row_id = ${rowId}`;

    validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"]
}
function querySerialParam() {
    int rowId = 1;
    int serialValue1 = 123;
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from NumericTypes WHERE serial_type = ${serialValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from NumericTypes WHERE serial_type = ${serialValue1} and row_id = ${rowId}`;

    validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryBigSerialParam() {
    int rowId = 1;
    int bigSerialValue1 = 123456;
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from NumericTypes WHERE bigserial_type = ${bigSerialValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from NumericTypes WHERE bigserial_type = ${bigSerialValue1} and row_id = ${rowId}`;

    validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateNumericTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryCharParam() {
    int rowId = 1;
    string charValue1 = "This is a char1";
    sql:CharValue charValue2 = new ("This is a char1");
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from CharacterTypes WHERE char_type = ${charValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from CharacterTypes WHERE char_type = ${charValue2}`;
    sql:ParameterizedQuery sqlQuery3 = `SELECT * from CharacterTypes WHERE char_type = ${charValue1} and row_id = ${rowId}`;
    sql:ParameterizedQuery sqlQuery4 = `SELECT * from CharacterTypes WHERE char_type = ${charValue2} and row_id = ${rowId}`;

    validateCharacterTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateCharacterTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
    validateCharacterTableQueryResult(simpleQueryPostgresqlClient(sqlQuery3, database = simpleParamsDb));
    validateCharacterTableQueryResult(simpleQueryPostgresqlClient(sqlQuery4, database = simpleParamsDb));

}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryVarcharParam() {
    int rowId = 1;
    string varcharValue1 = "This is a varchar1";
    sql:VarcharValue varcharValue2 = new ("This is a varchar1");
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from CharacterTypes WHERE varchar_type = ${varcharValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from CharacterTypes WHERE varchar_type = ${varcharValue2}`;
    sql:ParameterizedQuery sqlQuery3 = `SELECT * from CharacterTypes WHERE varchar_type = ${varcharValue1} and row_id = ${rowId}`;
    sql:ParameterizedQuery sqlQuery4 = `SELECT * from CharacterTypes WHERE varchar_type = ${varcharValue2} and row_id = ${rowId}`;

    validateCharacterTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateCharacterTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
    validateCharacterTableQueryResult(simpleQueryPostgresqlClient(sqlQuery3, database = simpleParamsDb));
    validateCharacterTableQueryResult(simpleQueryPostgresqlClient(sqlQuery4, database = simpleParamsDb));

}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryTextParam() {
    int rowId = 1;
    string textValue1 = "This is a text1";
    sql:TextValue textValue2 = new ("This is a text1");
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from CharacterTypes WHERE text_type = ${textValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from CharacterTypes WHERE text_type = ${textValue2}`;
    sql:ParameterizedQuery sqlQuery3 = `SELECT * from CharacterTypes WHERE text_type = ${textValue1} and row_id = ${rowId}`;
    sql:ParameterizedQuery sqlQuery4 = `SELECT * from CharacterTypes WHERE text_type = ${textValue2} and row_id = ${rowId}`;

    validateCharacterTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateCharacterTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
    validateCharacterTableQueryResult(simpleQueryPostgresqlClient(sqlQuery3, database = simpleParamsDb));
    validateCharacterTableQueryResult(simpleQueryPostgresqlClient(sqlQuery4, database = simpleParamsDb));

}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryNameParam() {
    int rowId = 1;
    string nameValue1 = "This is a name1";
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from CharacterTypes WHERE name_type = ${nameValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from CharacterTypes WHERE name_type = ${nameValue1} and row_id = ${rowId}`;

    validateCharacterTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateCharacterTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryBooleanParam() {
    int rowId = 1;
    boolean booleanValue1 = true;
    sql:BooleanValue booleanValue2 = new (true);
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from BooleanTypes WHERE boolean_type = ${booleanValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from BooleanTypes WHERE boolean_type = ${booleanValue2}`;
    sql:ParameterizedQuery sqlQuery3 = `SELECT * from BooleanTypes WHERE boolean_type = ${booleanValue1} and row_id = ${rowId}`;
    sql:ParameterizedQuery sqlQuery4 = `SELECT * from BooleanTypes WHERE boolean_type = ${booleanValue2} and row_id = ${rowId}`;

    validateBooleanTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateBooleanTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
    validateBooleanTableQueryResult(simpleQueryPostgresqlClient(sqlQuery3, database = simpleParamsDb));
    validateBooleanTableQueryResult(simpleQueryPostgresqlClient(sqlQuery4, database = simpleParamsDb));

}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryInetParam() {
    int rowId = 1;
    InetValue inetValue1 = new ("192.168.0.1/24");
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from NetworkTypes WHERE inet_type = ${inetValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from NetworkTypes WHERE inet_type = ${inetValue1} and row_id = ${rowId}`;

    validateNetworkTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateNetworkTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryCidrParam() {
    int rowId = 1;
    CidrValue cidrValue1 = new ("::ffff:1.2.3.0/120");
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from NetworkTypes WHERE cidr_type = ${cidrValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from NetworkTypes WHERE cidr_type = ${cidrValue1} and row_id = ${rowId}`;

    validateNetworkTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateNetworkTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
}

function queryMacaddrParam() {
    int rowId = 1;
    MacaddrValue macaddrValue1 = new ("08:00:2b:01:02:03");
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from NetworkTypes WHERE macaddr_type = ${macaddrValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from NetworkTypes WHERE macaddr_type = ${macaddrValue1} and row_id = ${rowId}`;

    validateNetworkTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateNetworkTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryMacaddr8Param() {
    int rowId = 1;
    Macaddr8Value macaddr8Value1 = new ("08:00:2b:01:02:03:04:05");
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from NetworkTypes WHERE macaddr8_type = ${macaddr8Value1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from NetworkTypes WHERE macaddr8_type = ${macaddr8Value1} and row_id = ${rowId}`;

    validateNetworkTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateNetworkTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryLineParam() {
    int rowId = 1;
    LineValue lineValue1 = new ("{1,2,3}");
    LineValue lineValue2 = new ({a: 1, b:2, c:3});
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from GeometricTypes WHERE line_type = ${lineValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from GeometricTypes WHERE line_type = ${lineValue1} and row_id = ${rowId}`;
    sql:ParameterizedQuery sqlQuery3 = `SELECT * from GeometricTypes WHERE line_type = ${lineValue2}`;
    sql:ParameterizedQuery sqlQuery4 = `SELECT * from GeometricTypes WHERE line_type = ${lineValue2} and row_id = ${rowId}`;

    validateGeometricTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateGeometricTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
    validateGeometricTableQueryResult(simpleQueryPostgresqlClient(sqlQuery3, database = simpleParamsDb));
    validateGeometricTableQueryResult(simpleQueryPostgresqlClient(sqlQuery4, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryLsegParam() {
    int rowId = 1;
    LsegValue lsegValue1 = new ("[(1,1),(2,2)]");
    LsegValue lsegValue2 = new ({x1: 1, y1: 1, x2: 2, y2: 2});
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from GeometricTypes WHERE lseg_type = ${lsegValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from GeometricTypes WHERE lseg_type = ${lsegValue1} and row_id = ${rowId}`;
    sql:ParameterizedQuery sqlQuery3 = `SELECT * from GeometricTypes WHERE lseg_type = ${lsegValue2}`;
    sql:ParameterizedQuery sqlQuery4 = `SELECT * from GeometricTypes WHERE lseg_type = ${lsegValue2} and row_id = ${rowId}`;

    validateGeometricTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateGeometricTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
    validateGeometricTableQueryResult(simpleQueryPostgresqlClient(sqlQuery3, database = simpleParamsDb));
    validateGeometricTableQueryResult(simpleQueryPostgresqlClient(sqlQuery4, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryBoxParam() {
    int rowId = 1;
    BoxValue boxValue1 = new ("(2,2),(1,1)");
    BoxValue boxValue2 = new ({x1: 1, y1: 1, x2: 2, y2: 2});
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from GeometricTypes WHERE box_type = ${boxValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from GeometricTypes WHERE box_type = ${boxValue1} and row_id = ${rowId}`;
    sql:ParameterizedQuery sqlQuery3 = `SELECT * from GeometricTypes WHERE box_type = ${boxValue2}`;
    sql:ParameterizedQuery sqlQuery4 = `SELECT * from GeometricTypes WHERE box_type = ${boxValue2} and row_id = ${rowId}`;

    validateGeometricTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateGeometricTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
    validateGeometricTableQueryResult(simpleQueryPostgresqlClient(sqlQuery3, database = simpleParamsDb));
    validateGeometricTableQueryResult(simpleQueryPostgresqlClient(sqlQuery4, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryCircleParam() {
    int rowId = 1;
    CircleValue circleValue1 = new ("<(1,1),1>");
    CircleValue circleValue2 = new ({x: 1, y:1, r:1});
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from GeometricTypes WHERE circle_type = ${circleValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from GeometricTypes WHERE circle_type = ${circleValue1} and row_id = ${rowId}`;
    sql:ParameterizedQuery sqlQuery3 = `SELECT * from GeometricTypes WHERE circle_type = ${circleValue2}`;
    sql:ParameterizedQuery sqlQuery4 = `SELECT * from GeometricTypes WHERE circle_type = ${circleValue2} and row_id = ${rowId}`;

    validateGeometricTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateGeometricTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
    validateGeometricTableQueryResult(simpleQueryPostgresqlClient(sqlQuery3, database = simpleParamsDb));
    validateGeometricTableQueryResult(simpleQueryPostgresqlClient(sqlQuery4, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryUuidParam() {
    int rowId = 1;
    UuidValue uuidValue1 = new ("a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11");
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from UuidTypes WHERE uuid_type = ${uuidValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from UuidTypes WHERE uuid_type = ${uuidValue1} and row_id = ${rowId}`;

    validateUuidTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateUuidTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryTsvectorParam() {
    int rowId = 1;
    TsvectorValue tsvectorValue1 = new ("a fat cat sat on a mat and ate a fat rat");
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from TextSearchTypes WHERE tsvector_type = ${tsvectorValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from TextSearchTypes WHERE tsvector_type = ${tsvectorValue1} and row_id = ${rowId}`;

    validateTextSearchTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateTextSearchTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryTsqueryParam() {
    int rowId = 1;
    TsqueryValue tsqueryValue1 = new ("fat & rat");
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from TextSearchTypes WHERE tsquery_type = ${tsqueryValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from TextSearchTypes WHERE tsquery_type = ${tsqueryValue1} and row_id = ${rowId}`;

    validateTextSearchTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateTextSearchTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
}


@test:Config {
    groups: ["query","query-simple-params"]
}
function queryJsonbParam() {
    int rowId = 1;
    json jsonbValue = {"key1": "value", "key2": 2};
    JsonbValue jsonbValue1 = new ("{\"key1\": \"value\", \"key2\": 2}");
    JsonbValue jsonbValue2 = new (jsonbValue);
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from JsonTypes WHERE jsonb_type = ${jsonbValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from JsonTypes WHERE jsonb_type = ${jsonbValue1} and row_id = ${rowId}`;
    sql:ParameterizedQuery sqlQuery3 = `SELECT * from JsonTypes WHERE jsonb_type = ${jsonbValue2}`;
    sql:ParameterizedQuery sqlQuery4 = `SELECT * from JsonTypes WHERE jsonb_type = ${jsonbValue2} and row_id = ${rowId}`;

    validateJsonTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateJsonTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
    validateJsonTableQueryResult(simpleQueryPostgresqlClient(sqlQuery3, database = simpleParamsDb));
    validateJsonTableQueryResult(simpleQueryPostgresqlClient(sqlQuery4, database = simpleParamsDb));

}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryDateValueParam() {
    int rowId = 1;
    time:Time|error dateValue = time:createTime(1999, 1, 8);
    if (dateValue is time:Time) {
        sql:DateValue dateValue1 = new (dateValue);
        sql:ParameterizedQuery sqlQuery1 = `SELECT * from DatetimeTypes WHERE date_type = ${dateValue1}`;
        sql:ParameterizedQuery sqlQuery2 = `SELECT * from DatetimeTypes WHERE date_type = ${dateValue1} and row_id = ${rowId}`;
        
        validateDatetimeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
        validateDatetimeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
    } else {
        test:assertFail("Invalid Time value generated ");
    }
}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryTimeValueParam() {
    int rowId = 1;
    time:Time|error timeValue = time:createTime(1999, 1, 8, 4, 5, 6);
    if (timeValue is time:Time) {
        sql:TimeValue timeValue1 = new (timeValue);
        sql:ParameterizedQuery sqlQuery1 = `SELECT * from DatetimeTypes WHERE time_type = ${timeValue1}`;
        sql:ParameterizedQuery sqlQuery2 = `SELECT * from DatetimeTypes WHERE time_type = ${timeValue1} and row_id = ${rowId}`;
        
        validateDatetimeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
        validateDatetimeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
    } else {
        test:assertFail("Invalid Time value generated ");
    }
 }

// // @test:Config {
// //     groups: ["query","query-simple-params"]
// // }
// // function queryTimetzValueParam() {
// //     int rowId = 1;
// //     time:Time|error timetzValue = time:createTime(2003, 4, 12, 4, 5, 6, 0, "America/New_York");
// //     if (timetzValue is time:Time) {
// //         sql:TimeValue timetzValue1 = new (timetzValue);
// //         sql:ParameterizedQuery sqlQuery1 = `SELECT * from DatetimeTypes WHERE timetz_type = ${timetzValue1}`;
// //         sql:ParameterizedQuery sqlQuery2 = `SELECT * from DatetimeTypes WHERE timetz_type = ${timetzValue1} and row_id = ${rowId}`;
        
// //         validateDatetimeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
// //         validateDatetimeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
// //     }
// //     else {
// //         test:assertFail("Invalid Time value generated ");
// //     }
// // }

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryTimestampValueParam() {
    int rowId = 1;
    time:Time|error timestampValue = time:createTime(1999, 1, 8, 4, 5, 6, 0);
    if (timestampValue is time:Time) {
        sql:TimestampValue timestampValue1 = new (timestampValue);
        sql:ParameterizedQuery sqlQuery1 = `SELECT * from DatetimeTypes WHERE timestamp_type = ${timestampValue1}`;
        sql:ParameterizedQuery sqlQuery2 = `SELECT * from DatetimeTypes WHERE timestamp_type = ${timestampValue1} and row_id = ${rowId}`;
        
        validateDatetimeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
        validateDatetimeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
    } else {
        test:assertFail("Invalid Time value generated ");
    }
}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryTimestamptzValueParam() {
    int rowId = 1;
    time:Time|error timestamptzValue = time:createTime(2004, 10, 19, 10, 23, 54, 0, "+02");
    if (timestamptzValue is time:Time) {
        sql:TimestampValue timestamptzValue1 = new (timestamptzValue);
        sql:ParameterizedQuery sqlQuery1 = `SELECT * from DatetimeTypes WHERE timestamptz_type = ${timestamptzValue1}`;
        sql:ParameterizedQuery sqlQuery2 = `SELECT * from DatetimeTypes WHERE timestamptz_type = ${timestamptzValue1} and row_id = ${rowId}`;
        
        validateDatetimeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
        validateDatetimeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
    } else {
        test:assertFail("Invalid Time value generated ");
    }
}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryInt4rangeParam() {
    int rowId = 1;
    Int4rangeValue int4rangeValue1 = new ("[3,50)");
    Int4rangeValue int4rangeValue2 = new ({upper: 50, lower :3, isLowerboundInclusive: true, isUpperboundInclusive: false});
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from RangeTypes WHERE int4range_type = ${int4rangeValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from RangeTypes WHERE int4range_type = ${int4rangeValue1} and row_id = ${rowId}`;
    sql:ParameterizedQuery sqlQuery3 = `SELECT * from RangeTypes WHERE int4range_type = ${int4rangeValue2}`;
    sql:ParameterizedQuery sqlQuery4 = `SELECT * from RangeTypes WHERE int4range_type = ${int4rangeValue2} and row_id = ${rowId}`;

    validateRangeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateRangeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
    validateRangeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery3, database = simpleParamsDb));
    validateRangeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery4, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryInt8rangeParam() {
    int rowId = 1;
    Int8rangeValue int8rangeValue1 = new ("[11,100)");
    Int8rangeValue int8rangeValue2 = new ({upper: 100, lower : 11, isLowerboundInclusive: true, isUpperboundInclusive: false});
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from RangeTypes WHERE int8range_type = ${int8rangeValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from RangeTypes WHERE int8range_type = ${int8rangeValue1} and row_id = ${rowId}`;
    sql:ParameterizedQuery sqlQuery3 = `SELECT * from RangeTypes WHERE int8range_type = ${int8rangeValue2}`;
    sql:ParameterizedQuery sqlQuery4 = `SELECT * from RangeTypes WHERE int8range_type = ${int8rangeValue2} and row_id = ${rowId}`;

    validateRangeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateRangeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
    validateRangeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery3, database = simpleParamsDb));
    validateRangeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery4, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryNumrangeParam() {
    int rowId = 1;
    NumrangeValue numrangeValue1 = new ("(0,24)");
    NumrangeValue numrangeValue2 = new ({upper: 24, lower : 0, isLowerboundInclusive: false, isUpperboundInclusive: false});
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from RangeTypes WHERE numrange_type = ${numrangeValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from RangeTypes WHERE numrange_type = ${numrangeValue1} and row_id = ${rowId}`;
    sql:ParameterizedQuery sqlQuery3 = `SELECT * from RangeTypes WHERE numrange_type = ${numrangeValue2}`;
    sql:ParameterizedQuery sqlQuery4 = `SELECT * from RangeTypes WHERE numrange_type = ${numrangeValue2} and row_id = ${rowId}`;

    validateRangeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateRangeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
    validateRangeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery3, database = simpleParamsDb));
    validateRangeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery4, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryTsrangeParam() {
    int rowId = 1;
    time:Time|error startTime = time:createTime(2010, 1, 1, 14, 30);
    time:Time|error endTime = time:createTime(2010, 1, 1, 15, 30);
    if ((startTime is time:Time) && (endTime is time:Time)) {
        TsrangeValue tsrangeValue1 = new ("(2010-01-01 14:30, 2010-01-01 15:30)");
        TsrangeValue tsrangeValue2 = new ({upper: endTime, lower : startTime, isLowerboundInclusive: false, isUpperboundInclusive: false});
        sql:ParameterizedQuery sqlQuery1 = `SELECT * from RangeTypes WHERE tsrange_type = ${tsrangeValue1}`;
        sql:ParameterizedQuery sqlQuery2 = `SELECT * from RangeTypes WHERE tsrange_type = ${tsrangeValue1} and row_id = ${rowId}`;
        sql:ParameterizedQuery sqlQuery3 = `SELECT * from RangeTypes WHERE tsrange_type = ${tsrangeValue2}`;
        sql:ParameterizedQuery sqlQuery4 = `SELECT * from RangeTypes WHERE tsrange_type = ${tsrangeValue2} and row_id = ${rowId}`;

        validateRangeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
        validateRangeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
        validateRangeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery3, database = simpleParamsDb));
        validateRangeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery4, database = simpleParamsDb));
    } else {
        test:assertFail("Invalid Time value generated ");
    }
}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryTstzrangeParam() {
    int rowId = 1;
    time:Time|error startTime = time:createTime(2010, 1, 1, 14, 30);
    time:Time|error endTime = time:createTime(2010, 1, 1, 15, 30);
    if ((startTime is time:Time) && (endTime is time:Time)) {
        TstzrangeValue tstzrangeValue1 = new ("(2010-01-01 14:30, 2010-01-01 15:30)");
        TstzrangeValue tstzrangeValue2 = new ({upper: endTime, lower : startTime, isLowerboundInclusive: false, isUpperboundInclusive: false});
        sql:ParameterizedQuery sqlQuery1 = `SELECT * from RangeTypes WHERE tstzrange_type = ${tstzrangeValue1}`;
        sql:ParameterizedQuery sqlQuery2 = `SELECT * from RangeTypes WHERE tstzrange_type = ${tstzrangeValue1} and row_id = ${rowId}`;
        sql:ParameterizedQuery sqlQuery3 = `SELECT * from RangeTypes WHERE tstzrange_type = ${tstzrangeValue2}`;
        sql:ParameterizedQuery sqlQuery4 = `SELECT * from RangeTypes WHERE tstzrange_type = ${tstzrangeValue2} and row_id = ${rowId}`;

        validateRangeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
        validateRangeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
        validateRangeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery3, database = simpleParamsDb));
        validateRangeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery4, database = simpleParamsDb));
    } else {
        test:assertFail("Invalid Time value generated ");
    }
}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryDaterangeParam() {
    int rowId = 1;
    time:Time|error startTime = time:createTime(2010, 1, 1, 14, 30);
    time:Time|error endTime = time:createTime(2010, 1, 3);
    if ((startTime is time:Time) && (endTime is time:Time)) {
        DaterangeValue daterangeValue1 = new ("(2010-01-01 14:30, 2010-01-03 )");
        DaterangeValue daterangeValue2 = new ({upper: endTime, lower : startTime, isLowerboundInclusive: false, isUpperboundInclusive: false});
        sql:ParameterizedQuery sqlQuery1 = `SELECT * from RangeTypes WHERE daterange_type = ${daterangeValue1}`;
        sql:ParameterizedQuery sqlQuery2 = `SELECT * from RangeTypes WHERE daterange_type = ${daterangeValue1} and row_id = ${rowId}`;
        sql:ParameterizedQuery sqlQuery3 = `SELECT * from RangeTypes WHERE daterange_type = ${daterangeValue2}`;
        sql:ParameterizedQuery sqlQuery4 = `SELECT * from RangeTypes WHERE daterange_type = ${daterangeValue2} and row_id = ${rowId}`;

        validateRangeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
        validateRangeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
        validateRangeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery3, database = simpleParamsDb));
        validateRangeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery4, database = simpleParamsDb));
    } else {
        test:assertFail("Invalid Time value generated ");
    }
}

// @test:Config {
//     groups: ["query","query-simple-params"]
// }
// function queryBitParam() {
//     int rowId = 1;
//     BitstringValue bitstringValue1 = new ("1110000111");
//     sql:ParameterizedQuery sqlQuery1 = `SELECT * from BitTypes WHERE bitstring_type = ${bitstringValue1}`;
//     sql:ParameterizedQuery sqlQuery2 = `SELECT * from BitTypes WHERE bitstring_type = ${bitstringValue1} and row_id = ${rowId}`;

//     validateBitTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
//     validateBitTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
// }

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryVarbitParam() {
    int rowId = 1;
    VarbitstringValue varbitstringValue1 = new ("1101");
    sql:ParameterizedQuery sqlQuery1 = `SELECT row_id, varbitstring_type, bit_type from BitTypes WHERE varbitstring_type = ${varbitstringValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT row_id, varbitstring_type, bit_type from BitTypes WHERE varbitstring_type = ${varbitstringValue1} and row_id = ${rowId}`;

    validateBitTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateBitTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryBitValueParam() {
    int rowId = 1;
    PGBitValue bitValue1 = new ("1");
    sql:ParameterizedQuery sqlQuery1 = `SELECT row_id, varbitstring_type, bit_type from BitTypes WHERE bit_type = ${bitValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT row_id, varbitstring_type, bit_type from BitTypes WHERE bit_type = ${bitValue1} and row_id = ${rowId}`;

    validateBitTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateBitTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
}


@test:Config {
    groups: ["query","query-simple-params"]
}
function queryOidValueParam() {
    int rowId = 1;
    int oidValue1 = 12;
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from Objectidentifiertypes WHERE oid_type = ${oidValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from Objectidentifiertypes WHERE oid_type = ${oidValue1} and row_id = ${rowId}`;

    validateObjectidentifierTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateObjectidentifierTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryRegclassValueParam() {
    int rowId = 1;
    RegclassValue regclassValue1 = new ("pg_type");
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from Objectidentifiertypes WHERE regclass_type = ${regclassValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from Objectidentifiertypes WHERE regclass_type = ${regclassValue1} and row_id = ${rowId}`;

    validateObjectidentifierTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateObjectidentifierTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryRegconfigValueParam() {
    int rowId = 1;
    RegconfigValue regconfigValue1 = new ("english");
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from Objectidentifiertypes WHERE regconfig_type = ${regconfigValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from Objectidentifiertypes WHERE regconfig_type = ${regconfigValue1} and row_id = ${rowId}`;

    validateObjectidentifierTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateObjectidentifierTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryRegdictionaryValueParam() {
    int rowId = 1;
    RegdictionaryValue regdictionaryValue1 = new ("simple");
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from Objectidentifiertypes WHERE regdictionary_type = ${regdictionaryValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from Objectidentifiertypes WHERE regdictionary_type = ${regdictionaryValue1} and row_id = ${rowId}`;

    validateObjectidentifierTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateObjectidentifierTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryRegnamespaceValueParam() {
    int rowId = 1;
    RegnamespaceValue regnamespaceValue1 = new ("pg_catalog");
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from Objectidentifiertypes WHERE regnamespace_type = ${regnamespaceValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from Objectidentifiertypes WHERE regnamespace_type = ${regnamespaceValue1} and row_id = ${rowId}`;

    validateObjectidentifierTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateObjectidentifierTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryRegoperValueParam() {
    int rowId = 1;
    RegoperValue regoperValue1 = new ("!");
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from Objectidentifiertypes WHERE regoper_type = ${regoperValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from Objectidentifiertypes WHERE regoper_type = ${regoperValue1} and row_id = ${rowId}`;

    validateObjectidentifierTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateObjectidentifierTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryRegoperatorValueParam() {
    int rowId = 1;
    RegoperatorValue regoperatorValue1 = new ("*(integer,integer)");
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from Objectidentifiertypes WHERE regoperator_type = ${regoperatorValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from Objectidentifiertypes WHERE regoperator_type = ${regoperatorValue1} and row_id = ${rowId}`;

    validateObjectidentifierTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateObjectidentifierTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryRegprocValueParam() {
    int rowId = 1;
    RegprocValue regprocValue1 = new ("now");
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from Objectidentifiertypes WHERE regproc_type = ${regprocValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from Objectidentifiertypes WHERE regproc_type = ${regprocValue1} and row_id = ${rowId}`;

    validateObjectidentifierTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateObjectidentifierTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryRegprocedureValueParam() {
    int rowId = 1;
    RegprocedureValue regprocedureValue1 = new ("sum(integer)");
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from Objectidentifiertypes WHERE regprocedure_type = ${regprocedureValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from Objectidentifiertypes WHERE regprocedure_type = ${regprocedureValue1} and row_id = ${rowId}`;

    validateObjectidentifierTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateObjectidentifierTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryRegroleValueParam() {
    int rowId = 1;
    RegroleValue regroleValue1 = new ("postgres");
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from Objectidentifiertypes WHERE regrole_type = ${regroleValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from Objectidentifiertypes WHERE regrole_type = ${regroleValue1} and row_id = ${rowId}`;

    validateObjectidentifierTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateObjectidentifierTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"]
}
function queryRegtypeValueParam() {
    int rowId = 1;
    RegtypeValue regtypeValue1 = new ("integer");
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from Objectidentifiertypes WHERE regtype_type = ${regtypeValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from Objectidentifiertypes WHERE regtype_type = ${regtypeValue1} and row_id = ${rowId}`;

    validateObjectidentifierTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateObjectidentifierTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
}

isolated function validateNumericTableQueryResult(record{}? returnData) {
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

isolated function validateCharacterTableQueryResult(record{}? returnData) {
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

public function validateBooleanTableQueryResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["boolean_type"], true);
    } 
}

isolated function validateNetworkTableQueryResult(record{}? returnData) {
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

isolated function validateGeometricTableQueryResult(record{}? returnData) {
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

isolated function validateUuidTableQueryResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["uuid_type"], "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11");
    } 
}

isolated function validateTextSearchTableQueryResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["tsvector_type"], "'a' 'and' 'ate' 'cat' 'fat' 'mat' 'on' 'rat' 'sat'");
        test:assertEquals(returnData["tsquery_type"], "'fat' & 'rat'");
    } 
}

isolated function validateJsonTableQueryResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["json_type"], "{\"key1\": \"value\", \"key2\": 2}");
        test:assertEquals(returnData["jsonb_type"], "{\"key1\": \"value\", \"key2\": 2}");
        test:assertEquals(returnData["jsonpath_type"], "$.\"floor\"[*].\"apt\"[*]?(@.\"area\" > 40 && @.\"area\" < 90)?(@.\"rooms\" > 1)");
    } 
}

isolated function validateDatetimeTableQueryResult(record{}? returnData) {
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

isolated function validateRangeTableQueryResult(record{}? returnData) {
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

isolated function validatePglsnTableQueryResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["pglsn_type"], "16/B374D848"); 
    } 
}

isolated function validateBitTableQueryResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        // test:assertEquals(returnData["bitstring_type"], "1110001100");
        test:assertEquals(returnData["varbitstring_type"], "1101");
        test:assertEquals(returnData["bit_type"], true);
    } 
}

isolated function validateObjectidentifierTableQueryResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["oid_type"], 12);
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
