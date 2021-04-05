// Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/sql;
import ballerina/test;

@test:Config {
    groups: ["execute", "execute-basic"]
}
function testCreateTable() returns error? {
    Client dbClient = check new (host, user, password, basicExecuteDatabase, port);
    sql:ExecutionResult result = check dbClient->execute("CREATE TABLE Student(student_id int, LastName"
        + " varchar(255))");
    check dbClient.close();
    test:assertExactEquals(result.affectedRowCount, 0, "Affected row count is different.");
    test:assertExactEquals(result.lastInsertId, (), "Last Insert Id is not nil.");
}

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testCreateTable]
}
function testInsertTable() returns error? {
    Client dbClient = check new (host, user, password, basicExecuteDatabase, port);
    sql:ExecutionResult result = check dbClient->execute("Insert into Student (student_id) values (20)");
    check dbClient.close();
    
    test:assertExactEquals(result.affectedRowCount, 1, "Affected row count is different.");
    var insertId = result.lastInsertId;
    if (insertId is int) {
        test:assertTrue(insertId > 1, "Last Insert Id is nil.");
    } else {
        test:assertFail("Insert Id should be an integer.");
    }
}

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testInsertTable]
}
function testInsertTableWithoutGeneratedKeys() returns error? {
    Client dbClient = check new (host, user, password, basicExecuteDatabase, port);
    sql:ExecutionResult result = check dbClient->execute("Insert into CharacterTypes (row_id, varchar_type)"
        + " values (20, 'test')");
    check dbClient.close();
    test:assertExactEquals(result.affectedRowCount, 1, "Affected row count is different.");
    test:assertEquals(result.lastInsertId, 20, "Last Insert Id is nil.");
}

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testInsertTableWithoutGeneratedKeys]
}
function testInsertTableWithGeneratedKeys() returns error? {
    Client dbClient = check new (host, user, password, basicExecuteDatabase, port);
    sql:ExecutionResult result = check dbClient->execute("insert into NumericTypes2 (row_id, int_type) values (21, 21)");
    check dbClient.close();
    test:assertExactEquals(result.affectedRowCount, 1, "Affected row count is different.");
    var insertId = result.lastInsertId;
    if (insertId is int) {
        test:assertTrue(insertId > 1, "Last Insert Id is nil.");
    } else {
        test:assertFail("Insert Id should be an integer.");
    }
}

type NumericType record {
    int row_id;
    int? smallint_type;
    int? int_type;
    int? bigint_type;
    decimal? decimal_type;
    decimal? numeric_type;
    float? double_type;
    float? real_type;
};

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testInsertTableWithGeneratedKeys]
}
function testInsertAndSelectTableWithGeneratedKeys() returns error? {
    Client dbClient = check new (host, user, password, basicExecuteDatabase, port);
    sql:ExecutionResult result = check dbClient->execute("insert into NumericTypes2 (row_id, int_type) values (22,10)");

    test:assertExactEquals(result.affectedRowCount, 1, "Affected row count is different.");
    
    string|int? insertedId = result.lastInsertId;
    if (insertedId is int) {
        string query = string `SELECT * from NumericTypes2 where row_id = ${insertedId}`;
        stream<record{}, error> queryResult = dbClient->query(query, NumericType);

        stream<NumericType, sql:Error> streamData = <stream<NumericType, sql:Error>>queryResult;
        record {|NumericType value;|}? data = check streamData.next();
        check streamData.close();
        test:assertNotExactEquals(data?.value, (), "Incorrect InsetId returned.");
    } else {
        test:assertFail("Insert Id should be an integer.");
    }
    check dbClient.close();
}

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testInsertAndSelectTableWithGeneratedKeys]
}
function testInsertWithAllNilAndSelectTableWithGeneratedKeys() returns error? {
    Client dbClient = check new (host, user, password, basicExecuteDatabase, port);
    sql:ExecutionResult result = check dbClient->execute("Insert into NumericTypes2 (row_id,smallint_type, int_type, "
        + "bigint_type, decimal_type, numeric_type, double_type, real_type) "
        + "values (23, null, null, null, null, null, null, null)");

    test:assertExactEquals(result.affectedRowCount, 1, "Affected row count is different.");

    string|int? insertedId = result.lastInsertId;
    if (insertedId is int) {
        string query = string `SELECT * from NumericTypes2 where row_id = ${insertedId}`;
        stream<record{}, error> queryResult = dbClient->query(query, NumericType);

        stream<NumericType, sql:Error> streamData = <stream<NumericType, sql:Error>>queryResult;
        record {|NumericType value;|}? data = check streamData.next();
        check streamData.close();
        test:assertNotExactEquals(data?.value, (), "Incorrect InsetId returned.");
    } else {
        test:assertFail("Insert Id should be an integer.");
    }
}

type StringDataType record {
    int row_id;
    string varchar_type;
    string char_type;
    string text_type;
    string name_type;    
};

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testInsertWithAllNilAndSelectTableWithGeneratedKeys]
}
function testInsertWithStringAndSelectTable() returns error? {
    Client dbClient = check new (host, user, password, basicExecuteDatabase, port);
    string intIDVal = "22";
    string insertQuery = "Insert into CharacterTypes (row_id,varchar_type , char_type , text_type , "
        + "name_type) values ("
        + intIDVal + ",'str1','This is a char','This is a text','This is a name')";
    sql:ExecutionResult result = check dbClient->execute(insertQuery);
    
    test:assertExactEquals(result.affectedRowCount, 1, "Affected row count is different.");

    string query = string `SELECT * from CharacterTypes where row_id = ${intIDVal}`;
    stream<record{}, error> queryResult = dbClient->query(query, StringDataType);
    stream<StringDataType, sql:Error> streamData = <stream<StringDataType, sql:Error>>queryResult;
    record {|StringDataType value;|}? data = check streamData.next();
    check streamData.close();

    StringDataType expectedInsertRow = {
        row_id: 22,
        varchar_type: "str1",
        char_type: "This is a char ",
        text_type: "This is a text",
        name_type: "This is a name"
    };
    test:assertEquals(data?.value, expectedInsertRow, "Incorrect InsetId returned.");

    check dbClient.close();
}

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testInsertWithStringAndSelectTable]
}
function testInsertWithEmptyStringAndSelectTable() returns error? {
    Client dbClient = check new (host, user, password, basicExecuteDatabase, port);
    string intIDVal = "23";
    string insertQuery = "Insert into CharacterTypes (row_id,varchar_type , char_type , text_type , "
        + "name_type) values (" + intIDVal +
        ",'','','','')";
    sql:ExecutionResult result = check dbClient->execute(insertQuery);
    test:assertExactEquals(result.affectedRowCount, 1, "Affected row count is different.");

    string query = string `SELECT * from CharacterTypes where row_id = ${intIDVal}`;
    stream<record{}, error> queryResult = dbClient->query(query, StringDataType);
    stream<StringDataType, sql:Error> streamData = <stream<StringDataType, sql:Error>>queryResult;
    record {|StringDataType value;|}? data = check streamData.next();
    check streamData.close();

    StringDataType expectedInsertRow = {
        row_id: 23,
        varchar_type: "",
        char_type: "               ",
        text_type: "",
        name_type: ""
    };
    test:assertEquals(data?.value, expectedInsertRow, "Incorrect InsetId returned.");

    check dbClient.close();
}

type StringNilData record {
    int row_id;
    string? varchar_type;
    string? char_type;
    string? text_type;
    string? name_type; 
};

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testInsertWithEmptyStringAndSelectTable]
}
function testInsertWithNilStringAndSelectTable() returns error? {
    Client dbClient = check new (host, user, password, basicExecuteDatabase, port);
    string intIDVal = "24";
    string insertQuery = "Insert into CharacterTypes (row_id,varchar_type , char_type , text_type , "
        + "name_type) values ("
        + intIDVal + ", null, null, null, null)";
    sql:ExecutionResult result = check dbClient->execute(insertQuery);
    test:assertExactEquals(result.affectedRowCount, 1, "Affected row count is different.");

    string query = string `SELECT * from CharacterTypes where row_id = ${intIDVal}`;
    stream<record{}, error> queryResult = dbClient->query(query, StringNilData);
    stream<StringNilData, sql:Error> streamData = <stream<StringNilData, sql:Error>>queryResult;
    record {|StringNilData value;|}? data = check streamData.next();
    check streamData.close();
    
    StringNilData expectedInsertRow = {
        row_id: 24,
        varchar_type: (),
        char_type: (),
        text_type: (),
        name_type: ()
    };
    test:assertEquals(data?.value, expectedInsertRow, "Incorrect InsetId returned.");
    check dbClient.close();
}

type BooleanData record {
    int row_id;
    boolean boolean_type;   
};

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testInsertWithNilStringAndSelectTable]
}
function testInsertWithBooleanAndSelectTable() returns error? {
    Client dbClient = check new (host, user, password, basicExecuteDatabase, port);
    string intIDVal = "20";
    string insertQuery = "Insert into BooleanTypes (row_id, boolean_type "
        + ") values ("
        + intIDVal + ",'true')";
    sql:ExecutionResult result = check dbClient->execute(insertQuery);
    
    test:assertExactEquals(result.affectedRowCount, 1, "Affected row count is different.");

    string query = string `SELECT * from BooleanTypes where row_id = ${intIDVal}`;
    stream<record{}, error> queryResult = dbClient->query(query, BooleanData);
    stream<BooleanData, sql:Error> streamData = <stream<BooleanData, sql:Error>>queryResult;
    record {|BooleanData value;|}? data = check streamData.next();
    check streamData.close();

    BooleanData expectedInsertRow = {
        row_id: 20,
        boolean_type: true
    };
    test:assertEquals(data?.value, expectedInsertRow, "Incorrect InsetId returned.");

    check dbClient.close();
}

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testInsertWithNilStringAndSelectTable]
}
function testInsertTableWithDatabaseError() returns error? {
    Client dbClient = check new (host, user, password, basicExecuteDatabase, port);
    sql:ExecutionResult|sql:Error result = dbClient->execute("Insert into NumericTypes2NonExistTable (int_type) values (20)");

    string expectedErrorMessage = "Error while executing SQL query: Insert into NumericTypes2NonExistTable (int_type) values (20). ERROR: relation \"numerictypes2nonexisttable\" does not exist";

    if (result is sql:DatabaseError) {
        test:assertTrue(result.message().startsWith(expectedErrorMessage), 
                        "Error message does not match, actual :\n'" + result.message() + "'\nExpected : \n" + expectedErrorMessage);

        sql:DatabaseErrorDetail errorDetails = result.detail();
    } else {
        test:assertFail("Database Error expected.");
    }

    check dbClient.close();
}

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testInsertTableWithDatabaseError]
}
function testInsertTableWithDataTypeError() returns error? {
    Client dbClient = check new (host, user, password, basicExecuteDatabase, port);
    sql:ExecutionResult|sql:Error result = dbClient->execute("Insert into NumericTypes2 (int_type) values"
        + " ('This is wrong type')");

    if (result is sql:DatabaseError) {
        string expectedErrorMessage = "Error while executing SQL query: Insert into NumericTypes2 (int_type) values ('This is wrong type'). ERROR: invalid input syntax for type integer: \"This is wrong type\"";
        test:assertTrue(result.message().startsWith(expectedErrorMessage), 
                    "Error message does not match, actual :'" + result.message() + "'\nExpected: "+expectedErrorMessage);
        sql:DatabaseErrorDetail errorDetails = result.detail();
    } else {
        test:assertFail("Database Error expected.");
    }

    check dbClient.close();
}

type ResultCount record {
    int countVal;
};

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testInsertTableWithDataTypeError]
}
function testUpdateNumericData() returns error? {
    Client dbClient = check new (host, user, password, basicExecuteDatabase, port);
    sql:ExecutionResult result = check dbClient->execute("Update NumericTypes2 set int_type = 31 where int_type = 10");
    test:assertExactEquals(result.affectedRowCount, 1, "Affected row count is different.");
    
    stream<record{}, error> queryResult = dbClient->query("SELECT count(*) as countval from NumericTypes2"
        + " where int_type = 31", ResultCount);
    stream<ResultCount, sql:Error> streamData = <stream<ResultCount, sql:Error>>queryResult;
    record {|ResultCount value;|}? data = check streamData.next();
    check streamData.close();
    test:assertEquals(data?.value?.countVal, 1, "Numeric table Update command was not successful.");

    check dbClient.close();
}

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testUpdateNumericData]
}
function testUpdateStringData() returns error? {
    Client dbClient = check new (host, user, password, basicExecuteDatabase, port);
    sql:ExecutionResult result = check dbClient->execute("Update CharacterTypes set varchar_type = 'updatedstring' where varchar_type = 'str1'");
    test:assertExactEquals(result.affectedRowCount, 1, "Affected row count is different.");
    
    stream<record{}, error> queryResult = dbClient->query("SELECT count(*) as countval from CharacterTypes"
        + " where varchar_type = 'updatedstring'", ResultCount);
    stream<ResultCount, sql:Error> streamData = <stream<ResultCount, sql:Error>>queryResult;
    record {|ResultCount value;|}? data = check streamData.next();
    check streamData.close();
    test:assertEquals(data?.value?.countVal, 1, "String table Update command was not successful.");

    check dbClient.close();
}

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testUpdateStringData]
}
function testUpdateBooleanData() returns error? {
    Client dbClient = check new (host, user, password, basicExecuteDatabase, port);
    string intId = "22";
    sql:ExecutionResult result = check dbClient->execute("insert into BooleanTypes (row_id, boolean_type) values ("+
                    intId+", true)");
    result = check dbClient->execute("Update BooleanTypes set boolean_type = false where row_id = 22");
    test:assertExactEquals(result.affectedRowCount, 1, "Affected row count is different.");
    
    stream<record{}, error> queryResult = dbClient->query("SELECT count(*) as countval from BooleanTypes"
        + " where row_id = 22 and boolean_type = false", ResultCount);
    stream<ResultCount, sql:Error> streamData = <stream<ResultCount, sql:Error>>queryResult;
    record {|ResultCount value;|}? data = check streamData.next();
    check streamData.close();
    test:assertEquals(data?.value?.countVal, 1, "Boolean table Update command was not successful.");

    check dbClient.close();
}

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testUpdateStringData]
}
function testDeleteNumericData() returns error? {
    Client dbClient = check new (host, user, password, basicExecuteDatabase, port);
    sql:ExecutionResult result = check dbClient->execute("insert into NumericTypes2 (row_id, int_type) values (27, 1451)");
    result = check dbClient->execute("Delete from NumericTypes2 where int_type = 1451");
    test:assertExactEquals(result.affectedRowCount, 1, "Affected row count is different.");
    
    stream<record{}, error> queryResult = dbClient->query("SELECT count(*) as countval from NumericTypes2"
        + " where int_type = 1451", ResultCount);
    stream<ResultCount, sql:Error> streamData = <stream<ResultCount, sql:Error>>queryResult;
    record {|ResultCount value;|}? data = check streamData.next();
    check streamData.close();
    test:assertEquals(data?.value?.countVal, 0, "Numeric table Delete command was not successful.");

    check dbClient.close();
}

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testDeleteNumericData]
}
function testDeleteStringData() returns error? {
    Client dbClient = check new (host, user, password, basicExecuteDatabase, port);
    string intId = "28";
    sql:ExecutionResult result = check dbClient->execute("insert into CharacterTypes (row_id, varchar_type) values ("+
                    intId+", 'deletestr')");
    result = check dbClient->execute("Delete from CharacterTypes where varchar_type = 'deletestr'");
    test:assertExactEquals(result.affectedRowCount, 1, "Affected row count is different.");
    
    stream<record{}, error> queryResult = dbClient->query("SELECT count(*) as countval from CharacterTypes"
        + " where varchar_type = 'deletestr'", ResultCount);
    stream<ResultCount, sql:Error> streamData = <stream<ResultCount, sql:Error>>queryResult;
    record {|ResultCount value;|}? data = check streamData.next();
    check streamData.close();
    test:assertEquals(data?.value?.countVal, 0, "String table Delete command was not successful.");

    check dbClient.close();
}

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testDeleteNumericData]
}
function testDeleteBooleanData() returns error? {
    Client dbClient = check new (host, user, password, basicExecuteDatabase, port);
    string intId = "25";
    sql:ExecutionResult result = check dbClient->execute("insert into BooleanTypes (row_id, boolean_type) values ("+
                    intId+", false)");
    result = check dbClient->execute("Delete from BooleanTypes where row_id = 25");
    test:assertExactEquals(result.affectedRowCount, 1, "Affected row count is different.");
    
    stream<record{}, error> queryResult = dbClient->query("SELECT count(*) as countval from BooleanTypes"
        + " where row_id = 25", ResultCount);
    stream<ResultCount, sql:Error> streamData = <stream<ResultCount, sql:Error>>queryResult;
    record {|ResultCount value;|}? data = check streamData.next();
    check streamData.close();
    test:assertEquals(data?.value?.countVal, 0, "Boolean table Delete command was not successful.");

    check dbClient.close();
}

class TestSQLErrorValue {
    public int? value;
    public isolated function init (int? value) {
        self.value = value;
    }
} 

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testDeleteBooleanData]
}
function testSqlTypedError() returns error? {
    TestSQLErrorValue testSQLErrorValue = new (1);
    sql:ParameterizedQuery sqlQuery = `Insert Into Numerictypes (int_type) values (${testSQLErrorValue});`;
    sql:ExecutionResult|sql:Error result = executePostgreSQLClient(sqlQuery);
    test:assertTrue(result is error);
    string expectedErrorMessage = "Error while executing SQL query: Insert Into Numerictypes (int_type)" +
                                     " values ( ? );. Unsupported SQL type:";
    if (result is sql:Error) {
        test:assertTrue(result.message().startsWith(expectedErrorMessage), 
           "Error message does not match, actual :\n'" + result.message() + "'\nExpected : \n" + expectedErrorMessage);
    } else {
        test:assertFail("Error expected");
    }
}

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testDeleteBooleanData]
}
function testInetTypeError() returns error? {
    InetValue inetValue = new ("Invalid Value");
    sql:ParameterizedQuery sqlQuery = `Insert Into NetworkTypes (inet_type) values (${inetValue});`;
    sql:ExecutionResult|sql:Error result = executePostgreSQLClient(sqlQuery);
    test:assertTrue(result is error);
    string expectedErrorMessage = "Error while executing SQL query: Insert Into NetworkTypes (inet_type) " +
                                 "values ( ? );. ERROR: invalid input syntax for type inet: \"Invalid Value\".";
    if (result is sql:Error) {
        test:assertTrue(result.message().startsWith(expectedErrorMessage), 
           "Error message does not match, actual :\n'" + result.message() + "'\nExpected : \n" + expectedErrorMessage);
    } else {
        test:assertFail("Error expected");
    }
}

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testInetTypeError]
}
function testPglasnTypeError() returns error? {
    PglsnValue pglsnValue = new ("Invalid Value");
    sql:ParameterizedQuery sqlQuery = `Insert Into PglsnTypes (pglsn_type) values (${pglsnValue});`;
    sql:ExecutionResult|sql:Error result = executePostgreSQLClient(sqlQuery);
    test:assertTrue(result is error);
    string expectedErrorMessage = "Error while executing SQL query: Insert Into PglsnTypes (pglsn_type) " +
                                 "values ( ? );. ERROR: invalid input syntax for type pg_lsn: \"Invalid Value\".";
    if (result is sql:Error) {
        test:assertTrue(result.message().startsWith(expectedErrorMessage), 
           "Error message does not match, actual :\n'" + result.message() + "'\nExpected : \n" + expectedErrorMessage);
    } else {
        test:assertFail("Error expected");
    }
}

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testPglasnTypeError]
}
function testPointTypeError() returns error? {
    PointValue pointValue = new ("Invalid Value");
    sql:ParameterizedQuery sqlQuery = `Insert Into GeometricTypes (point_type) values (${pointValue});`;
    sql:ExecutionResult|sql:Error result = executePostgreSQLClient(sqlQuery);
    test:assertTrue(result is error);
    string expectedErrorMessage = "Error while executing SQL query: Insert Into GeometricTypes (point_type)" + 
                " values ( ? );. Unsupported Value: Invalid Value for type: point.";
    if (result is sql:Error) {
        test:assertTrue(result.message().startsWith(expectedErrorMessage), 
           "Error message does not match, actual :\n'" + result.message() + "'\nExpected : \n" + expectedErrorMessage);
    } else {
        test:assertFail("Error expected");
    }
}

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testPointTypeError]
}
function testLsegTypeError() returns error? {
    LsegValue lsegValue = new ("Invalid Value");
    sql:ParameterizedQuery sqlQuery = `Insert Into GeometricTypes (lseg_type) values (${lsegValue});`;
    sql:ExecutionResult|sql:Error result = executePostgreSQLClient(sqlQuery);
    test:assertTrue(result is error);
    string expectedErrorMessage = "Error while executing SQL query: Insert Into GeometricTypes (lseg_type)" + 
                " values ( ? );. Unsupported Value: Invalid Value for type: lseg.";
    if (result is sql:Error) {
        test:assertTrue(result.message().startsWith(expectedErrorMessage), 
           "Error message does not match, actual :\n'" + result.message() + "'\nExpected : \n" + expectedErrorMessage);
    } else {
        test:assertFail("Error expected");
    }
}

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testLsegTypeError]
}
function testBoxTypeError() returns error? {
    BoxValue boxValue = new ("Invalid Value");
    sql:ParameterizedQuery sqlQuery = `Insert Into GeometricTypes (box_type) values (${boxValue});`;
    sql:ExecutionResult|sql:Error result = executePostgreSQLClient(sqlQuery);
    test:assertTrue(result is error);
    string expectedErrorMessage = "Error while executing SQL query: Insert Into GeometricTypes (box_type)" + 
                " values ( ? );. Unsupported Value: Invalid Value for type: box.";
    if (result is sql:Error) {
        test:assertTrue(result.message().startsWith(expectedErrorMessage), 
           "Error message does not match, actual :\n'" + result.message() + "'\nExpected : \n" + expectedErrorMessage);
    } else {
        test:assertFail("Error expected");
    }
}

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testBoxTypeError]
}
function testCircleTypeError() returns error? {
    CircleValue circleValue = new ("Invalid Value");
    sql:ParameterizedQuery sqlQuery = `Insert Into GeometricTypes (circle_type) values (${circleValue});`;
    sql:ExecutionResult|sql:Error result = executePostgreSQLClient(sqlQuery);
    test:assertTrue(result is error);
    string expectedErrorMessage = "Error while executing SQL query: Insert Into GeometricTypes (circle_type)" + 
                " values ( ? );. Unsupported Value: Invalid Value for type: circle.";
    if (result is sql:Error) {
        test:assertTrue(result.message().startsWith(expectedErrorMessage), 
           "Error message does not match, actual :\n'" + result.message() + "'\nExpected : \n" + expectedErrorMessage);
    } else {
        test:assertFail("Error expected");
    }
}

function executePostgreSQLClient (sql:ParameterizedQuery|string sqlQuery) returns sql:ExecutionResult|sql:Error {
    Client dbClient = check new (host, user, password, basicExecuteDatabase, port);
    sql:ExecutionResult|sql:Error result = dbClient->execute(sqlQuery);
    check dbClient.close();
    return result;
}
