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
    groups: ["query","query-simple-params"],
    dependsOn: [querySmallIntParam]
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryIntParam]
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryBigIntParam]
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryDecimalParam]
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

@test:Config {
    groups: ["query","query-simple-params"],
    dependsOn: [queryDecimalParam]
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryDoubleParam]
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
    groups: ["query","query-simple-params"],
    dependsOn: [querySmallIntParam]
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
    groups: ["query","query-simple-params"],
    dependsOn: [querySerialParam]
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryBigSerialParam]
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryCharParam]
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryVarcharParam]
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryTextParam]
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryNameParam]
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryBooleanParam]
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryInetParam]
}
function queryCidrParam() {
    int rowId = 1;
    CidrValue cidrValue1 = new ("::ffff:1.2.3.0/120");
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from NetworkTypes WHERE cidr_type = ${cidrValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from NetworkTypes WHERE cidr_type = ${cidrValue1} and row_id = ${rowId}`;

    validateNetworkTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateNetworkTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"],
    dependsOn: [queryCidrParam]
}
function queryMacaddrParam() {
    int rowId = 1;
    MacAddrValue macaddrValue1 = new ("08:00:2b:01:02:03");
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from NetworkTypes WHERE macaddr_type = ${macaddrValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from NetworkTypes WHERE macaddr_type = ${macaddrValue1} and row_id = ${rowId}`;

    validateNetworkTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateNetworkTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"],
    dependsOn: [queryMacaddrParam]
}
function queryMacaddr8Param() {
    int rowId = 1;
    MacAddr8Value macaddr8Value1 = new ("08:00:2b:01:02:03:04:05");
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from NetworkTypes WHERE macaddr8_type = ${macaddr8Value1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from NetworkTypes WHERE macaddr8_type = ${macaddr8Value1} and row_id = ${rowId}`;

    validateNetworkTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateNetworkTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"],
    dependsOn: [queryMacaddr8Param]
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryLineParam]
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryLsegParam]
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryBoxParam]
}
function queryPathParam() {
    int rowId = 1;
    PathValue pathValue1 = new ("[(1,1),(2,2)]");
    PathValue pathValue2 = new ({open: true, points: [{x: 1, y: 1}, {x:2, y:2}]});
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from GeometricTypes WHERE path_type = ${pathValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from GeometricTypes WHERE path_type = ${pathValue1} and row_id = ${rowId}`;
    sql:ParameterizedQuery sqlQuery3 = `SELECT * from GeometricTypes WHERE path_type = ${pathValue2}`;
    sql:ParameterizedQuery sqlQuery4 = `SELECT * from GeometricTypes WHERE path_type = ${pathValue2} and row_id = ${rowId}`;

    validateGeometricTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateGeometricTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
    validateGeometricTableQueryResult(simpleQueryPostgresqlClient(sqlQuery3, database = simpleParamsDb));
    validateGeometricTableQueryResult(simpleQueryPostgresqlClient(sqlQuery4, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"],
    dependsOn: [queryBoxParam]
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryCircleParam]
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryUuidParam]
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryTsvectorParam]
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryTsqueryParam]
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryJsonbParam]
}
function queryDateValueParam() {
    int rowId = 1;
    time:Date dateValue = {year: 1999, month: 1, day: 8};
    sql:DateValue dateValue1 = new (dateValue);
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from DatetimeTypes WHERE date_type = ${dateValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from DatetimeTypes WHERE date_type = ${dateValue1} and row_id = ${rowId}`;
    
    validateDatetimeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateDatetimeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"],
    dependsOn: [queryDateValueParam]
}
function queryTimeValueParam() {
    int rowId = 1;
    time:TimeOfDay time = {hour: 4, minute: 5, second: 6};
    sql:TimeValue timeValue1 = new (time);
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from DatetimeTypes WHERE time_type = ${timeValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from DatetimeTypes WHERE time_type = ${timeValue1} and row_id = ${rowId}`;
    
    validateDatetimeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateDatetimeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
 }

@test:Config {
    groups: ["query","query-simple-params"],
    dependsOn: [queryTimeValueParam]
}
function queryTimestampValueParam() returns error? {
    int rowId = 1;
    time:Utc timestampValue = check time:utcFromString("1999-01-08T04:05:06.000+00:00");
    sql:TimestampValue timestampValue1 = new (timestampValue);
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from DatetimeTypes WHERE timestamp_type = ${timestampValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from DatetimeTypes WHERE timestamp_type = ${timestampValue1} and row_id = ${rowId}`;
    
    validateDatetimeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateDatetimeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"],
    dependsOn: [queryTimestampValueParam]
}
function queryTimestamptzValueParam() returns error? {
    int rowId = 1;
    time:Utc timestamptz = check time:utcFromString("2004-10-19T08:23:54.000+00:00");
    sql:TimestampValue timestamptzValue = new (timestamptz);
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from DatetimeTypes WHERE timestamptz_type = ${timestamptzValue}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from DatetimeTypes WHERE timestamptz_type = ${timestamptzValue} and row_id = ${rowId}`;
    
    validateDatetimeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateDatetimeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"],
    dependsOn: [queryTimestamptzValueParam]
}
function queryInt4rangeParam() {
    int rowId = 1;
    IntegerRangeValue int4rangeValue1 = new ("[3,50)");
    IntegerRangeValue int4rangeValue2 = new ({upper: 50, lower :3, lowerboundInclusive: true, upperboundInclusive: false});
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryInt4rangeParam]
}
function queryInt8rangeParam() {
    int rowId = 1;
    LongRangeValue int8rangeValue1 = new ("[11,100)");
    LongRangeValue int8rangeValue2 = new ({upper: 100, lower : 11, lowerboundInclusive: true, upperboundInclusive: false});
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryInt8rangeParam]
}
function queryNumrangeParam() {
    int rowId = 1;
    NumericRangeValue numrangeValue1 = new ("(0,24)");
    NumericRangeValue numrangeValue2 = new ({upper: 24, lower : 0, lowerboundInclusive: false, upperboundInclusive: false});
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryNumrangeParam]
}
function queryTsrangeParam() {
    int rowId = 1;
    TsrangeValue tsrangeValue1 = new ("(2010-01-01 14:30, 2010-01-01 15:30)");
    TsrangeValue tsrangeValue2 = new ({lower: "2010-01-01 14:30", upper: "2010-01-01 15:30"});
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from RangeTypes WHERE tsrange_type = ${tsrangeValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from RangeTypes WHERE tsrange_type = ${tsrangeValue1} and row_id = ${rowId}`;
    sql:ParameterizedQuery sqlQuery3 = `SELECT * from RangeTypes WHERE tsrange_type = ${tsrangeValue2}`;
    sql:ParameterizedQuery sqlQuery4 = `SELECT * from RangeTypes WHERE tsrange_type = ${tsrangeValue2} and row_id = ${rowId}`;

    validateRangeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateRangeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
    validateRangeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery3, database = simpleParamsDb));
    validateRangeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery4, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"],
    dependsOn: [queryTsrangeParam]
}
function queryDaterangeParam() {
    int rowId = 1;
    DaterangeValue daterangeValue1 = new ("(2010-01-01 14:30, 2010-01-03 )");
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from RangeTypes WHERE daterange_type = ${daterangeValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from RangeTypes WHERE daterange_type = ${daterangeValue1} and row_id = ${rowId}`;
   
    validateRangeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateRangeTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"],
    dependsOn: [queryDaterangeParam]
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryVarbitParam]
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryBitValueParam]
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryOidValueParam]
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryRegclassValueParam]
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryRegconfigValueParam]
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryRegdictionaryValueParam]
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryRegnamespaceValueParam]
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryRegoperValueParam]
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryRegoperatorValueParam]
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryRegprocValueParam]
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryRegprocedureValueParam]
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
    groups: ["query","query-simple-params"],
    dependsOn: [queryRegroleValueParam]
}
function queryRegtypeValueParam() {
    int rowId = 1;
    RegtypeValue regtypeValue1 = new ("integer");
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from Objectidentifiertypes WHERE regtype_type = ${regtypeValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from Objectidentifiertypes WHERE regtype_type = ${regtypeValue1} and row_id = ${rowId}`;

    validateObjectidentifierTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateObjectidentifierTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"],
    dependsOn: [queryUuidParam]
}
function queryByteaParam() {
    int rowId = 1;
    byte[] byteArray = [222,173,190,239];
    sql:BinaryValue byteaValue1 = new (byteArray);
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from BinaryTypes WHERE bytea_type = ${byteaValue1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from BinaryTypes WHERE bytea_type = ${byteaValue1} and row_id = ${rowId}`;

    validateBinaryTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateBinaryTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"],
    dependsOn: [queryByteaParam]
}
function queryMoneyParam() {
    int rowId = 1;
    string moneyValue1 = "$124.56";
    decimal moneyValue2 = 124.56;
    MoneyValue moneyType1 = new (moneyValue1);
    MoneyValue moneyType2 = new (moneyValue2);
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from MoneyTypes WHERE money_type = ${moneyType1}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from MoneyTypes WHERE money_type = ${moneyType1} and row_id = ${rowId}`;
    sql:ParameterizedQuery sqlQuery3 = `SELECT * from MoneyTypes WHERE money_type = ${moneyType2}`;
    sql:ParameterizedQuery sqlQuery4 = `SELECT * from MoneyTypes WHERE money_type = ${moneyType2} and row_id = ${rowId}`;

    validateMoneyTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateMoneyTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
    validateMoneyTableQueryResult(simpleQueryPostgresqlClient(sqlQuery3, database = simpleParamsDb));
    validateMoneyTableQueryResult(simpleQueryPostgresqlClient(sqlQuery4, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"],
    dependsOn: [queryMoneyParam]
}
function queryArrayParam() {
    int rowId = 1;
    int[] bigIntArray = [10000,20000,30000];
    decimal[] decimalArray =  [1.1,2.2,3.3,4.4];
    decimal[] numericArray =  [1.1,2.2,3.3,4.4];
    string[] varcharArray = ["This is a VarChar1","This is a VarChar2"];
    boolean[] booleanArray = [true, false, true];

    sql:ArrayValue bigintarrayType = new(bigIntArray);
    sql:ArrayValue decimalarrayType = new(decimalArray);
    sql:ArrayValue numericarrayType = new(numericArray);
    sql:ArrayValue varchararrayType = new(varcharArray);
    sql:ArrayValue booleanarrayType = new(booleanArray);

    sql:ParameterizedQuery sqlQuery5 = `SELECT * from ArrayTypes WHERE bigintarray_type = ${bigintarrayType}`;
    sql:ParameterizedQuery sqlQuery6 = `SELECT * from ArrayTypes WHERE bigintarray_type = ${bigintarrayType} and row_id = ${rowId}`;
    sql:ParameterizedQuery sqlQuery7 = `SELECT * from ArrayTypes WHERE decimalarray_type = ${decimalarrayType}`;
    sql:ParameterizedQuery sqlQuery8 = `SELECT * from ArrayTypes WHERE decimalarray_type = ${decimalarrayType} and row_id = ${rowId}`;
    sql:ParameterizedQuery sqlQuery9 = `SELECT * from ArrayTypes WHERE numericarray_type = ${numericarrayType}`;
    sql:ParameterizedQuery sqlQuery10 = `SELECT * from ArrayTypes WHERE numericarray_type = ${numericarrayType} and row_id = ${rowId}`;
    sql:ParameterizedQuery sqlQuery13 = `SELECT * from ArrayTypes WHERE varchararray_type = ${varchararrayType}`;
    sql:ParameterizedQuery sqlQuery14 = `SELECT * from ArrayTypes WHERE varchararray_type = ${varchararrayType} and row_id = ${rowId}`;
    sql:ParameterizedQuery sqlQuery17 = `SELECT * from ArrayTypes WHERE booleanarray_type = ${booleanarrayType}`;
    sql:ParameterizedQuery sqlQuery18= `SELECT * from ArrayTypes WHERE booleanarray_type = ${booleanarrayType} and row_id = ${rowId}`;

    validateArrayTableQueryResult(simpleQueryPostgresqlClient(sqlQuery5, database = simpleParamsDb));
    validateArrayTableQueryResult(simpleQueryPostgresqlClient(sqlQuery6, database = simpleParamsDb));
    validateArrayTableQueryResult(simpleQueryPostgresqlClient(sqlQuery7, database = simpleParamsDb));
    validateArrayTableQueryResult(simpleQueryPostgresqlClient(sqlQuery8, database = simpleParamsDb));
    validateArrayTableQueryResult(simpleQueryPostgresqlClient(sqlQuery9, database = simpleParamsDb));
    validateArrayTableQueryResult(simpleQueryPostgresqlClient(sqlQuery10, database = simpleParamsDb));
    validateArrayTableQueryResult(simpleQueryPostgresqlClient(sqlQuery13, database = simpleParamsDb));
    validateArrayTableQueryResult(simpleQueryPostgresqlClient(sqlQuery14, database = simpleParamsDb));
    validateArrayTableQueryResult(simpleQueryPostgresqlClient(sqlQuery17, database = simpleParamsDb));
    validateArrayTableQueryResult(simpleQueryPostgresqlClient(sqlQuery18, database = simpleParamsDb));
}

@test:Config {
    groups: ["query","query-simple-params"],
    dependsOn: [queryMoneyParam]
}
function queryEnumParam() {
    int rowId = 1;
    Enum enumRecord = {value: "value1"};
    EnumValue enumValue = new (sqlTypeName = "value", value = enumRecord);
    sql:ParameterizedQuery sqlQuery1 = `SELECT * from EnumTypes WHERE value_type = ${enumValue}`;
    sql:ParameterizedQuery sqlQuery2 = `SELECT * from EnumTypes WHERE value_type = ${enumValue} and row_id = ${rowId}`;

    validateEnumTableQueryResult(simpleQueryPostgresqlClient(sqlQuery1, database = simpleParamsDb));
    validateEnumTableQueryResult(simpleQueryPostgresqlClient(sqlQuery2, database = simpleParamsDb));
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

isolated function validateBooleanTableQueryResult(record{}? returnData) {
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
        test:assertEquals(returnData["path_type"], "[(1,1),(2,2)]");
        test:assertEquals(returnData["polygon_type"], "((1,1),(2,2))"); 
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
        test:assertEquals(returnData["time_type"], "04:05:06.000+00:00");
        test:assertEquals(returnData["timestamp_type"], "1999-01-08T04:05:06.000+00:00");
        test:assertEquals(returnData["date_type"], "1999-01-08+00:00");
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

isolated function validateBinaryTableQueryResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["bytea_type"], [222,173,190,239]); 
    } 
}

isolated function validateXmlTableQueryResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["xml_type"], xml `<foo><tag>bar</tag><tag>tag</tag></foo>`);
    } 
}

isolated function validateMoneyTableQueryResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["money_type"], 124.56);
    } 
}

isolated function validateEnumTableQueryResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["value_type"], "value1");
    } 
}

isolated function validateArrayTableQueryResult(record{}? returnData) {
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
