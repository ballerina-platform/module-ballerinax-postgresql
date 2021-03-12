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

string executeDb = "basic_execute_db";

@test:Config {
    groups: ["execute", "execute-basic"]
}
function testCreateTable() {
    Client dbClient = checkpanic new (host, user, password, executeDb, port);
    sql:ExecutionResult result = checkpanic dbClient->execute("CREATE TABLE TestCreateTable(studentID int, LastName"
        + " varchar(255))");
    checkpanic dbClient.close();
    test:assertExactEquals(result.affectedRowCount, 0, "Affected row count is different.");
    test:assertExactEquals(result.lastInsertId, (), "Last Insert Id is not nil.");
}

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testCreateTable]
}
function testInsertTable() {
    Client dbClient = checkpanic new (host, user, password, executeDb, port);
    sql:ExecutionResult result = checkpanic dbClient->execute("Insert into NumericTypes2 (int_type) values (20)");
    checkpanic dbClient.close();
    
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
function testInsertTableWithoutGeneratedKeys() {
    Client dbClient = checkpanic new (host, user, password, executeDb, port);
    sql:ExecutionResult result = checkpanic dbClient->execute("Insert into CharacterTypes (row_id, varchar_type)"
        + " values (20, 'test')");
    checkpanic dbClient.close();
    test:assertExactEquals(result.affectedRowCount, 1, "Affected row count is different.");
    test:assertEquals(result.lastInsertId, 20, "Last Insert Id is nil.");
}

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testInsertTableWithoutGeneratedKeys]
}
function testInsertTableWithGeneratedKeys() {
    Client dbClient = checkpanic new (host, user, password, executeDb, port);
    sql:ExecutionResult result = checkpanic dbClient->execute("insert into NumericTypes2 (int_type) values (21)");
    checkpanic dbClient.close();
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
function testInsertAndSelectTableWithGeneratedKeys() {
    Client dbClient = checkpanic new (host, user, password, executeDb, port);
    sql:ExecutionResult result = checkpanic dbClient->execute("insert into NumericTypes2 (int_type) values (10)");

    test:assertExactEquals(result.affectedRowCount, 1, "Affected row count is different.");
    
    string|int? insertedId = result.lastInsertId;
    if (insertedId is int) {
        string query = string `SELECT * from NumericTypes2 where row_id = ${insertedId}`;
        stream<record{}, error> queryResult = dbClient->query(query, NumericType);

        stream<NumericType, sql:Error> streamData = <stream<NumericType, sql:Error>>queryResult;
        record {|NumericType value;|}? data = checkpanic streamData.next();
        checkpanic streamData.close();
        test:assertNotExactEquals(data?.value, (), "Incorrect InsetId returned.");
    } else {
        test:assertFail("Insert Id should be an integer.");
    }
    checkpanic dbClient.close();
}

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testInsertAndSelectTableWithGeneratedKeys]
}
function testInsertWithAllNilAndSelectTableWithGeneratedKeys() {
    Client dbClient = checkpanic new (host, user, password, executeDb, port);
    sql:ExecutionResult result = checkpanic dbClient->execute("Insert into NumericTypes2 (smallint_type, int_type, "
        + "bigint_type, decimal_type, numeric_type, double_type, real_type) "
        + "values (null, null, null, null, null, null, null)");

    test:assertExactEquals(result.affectedRowCount, 1, "Affected row count is different.");

    string|int? insertedId = result.lastInsertId;
    if (insertedId is int) {
        string query = string `SELECT * from NumericTypes2 where row_id = ${insertedId}`;
        stream<record{}, error> queryResult = dbClient->query(query, NumericType);

        stream<NumericType, sql:Error> streamData = <stream<NumericType, sql:Error>>queryResult;
        record {|NumericType value;|}? data = checkpanic streamData.next();
        checkpanic streamData.close();
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
function testInsertWithStringAndSelectTable() {
    Client dbClient = checkpanic new (host, user, password, executeDb, port);
    string intIDVal = "25";
    string insertQuery = "Insert into CharacterTypes (row_id,varchar_type , char_type , text_type , "
        + "name_type) values ("
        + intIDVal + ",'str1','This is a char','This is a text','This is a name')";
    sql:ExecutionResult result = checkpanic dbClient->execute(insertQuery);
    
    test:assertExactEquals(result.affectedRowCount, 1, "Affected row count is different.");

    string query = string `SELECT * from CharacterTypes where row_id = ${intIDVal}`;
    stream<record{}, error> queryResult = dbClient->query(query, StringDataType);
    stream<StringDataType, sql:Error> streamData = <stream<StringDataType, sql:Error>>queryResult;
    record {|StringDataType value;|}? data = checkpanic streamData.next();
    checkpanic streamData.close();

    StringDataType expectedInsertRow = {
        row_id: 25,
        varchar_type: "str1",
        char_type: "This is a char ",
        text_type: "This is a text",
        name_type: "This is a name"
    };
    test:assertEquals(data?.value, expectedInsertRow, "Incorrect InsetId returned.");

    checkpanic dbClient.close();
}

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testInsertWithStringAndSelectTable]
}
function testInsertWithEmptyStringAndSelectTable() {
    Client dbClient = checkpanic new (host, user, password, executeDb, port);
    string intIDVal = "35";
    string insertQuery = "Insert into CharacterTypes (row_id,varchar_type , char_type , text_type , "
        + "name_type) values (" + intIDVal +
        ",'','','','')";
    sql:ExecutionResult result = checkpanic dbClient->execute(insertQuery);
    test:assertExactEquals(result.affectedRowCount, 1, "Affected row count is different.");

    string query = string `SELECT * from CharacterTypes where row_id = ${intIDVal}`;
    stream<record{}, error> queryResult = dbClient->query(query, StringDataType);
    stream<StringDataType, sql:Error> streamData = <stream<StringDataType, sql:Error>>queryResult;
    record {|StringDataType value;|}? data = checkpanic streamData.next();
    checkpanic streamData.close();

    StringDataType expectedInsertRow = {
        row_id: 35,
        varchar_type: "",
        char_type: "               ",
        text_type: "",
        name_type: ""
    };
    test:assertEquals(data?.value, expectedInsertRow, "Incorrect InsetId returned.");

    checkpanic dbClient.close();
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
function testInsertWithNilStringAndSelectTable() {
    Client dbClient = checkpanic new (host, user, password, executeDb, port);
    string intIDVal = "45";
    string insertQuery = "Insert into CharacterTypes (row_id,varchar_type , char_type , text_type , "
        + "name_type) values ("
        + intIDVal + ", null, null, null, null)";
    sql:ExecutionResult result = checkpanic dbClient->execute(insertQuery);
    test:assertExactEquals(result.affectedRowCount, 1, "Affected row count is different.");

    string query = string `SELECT * from CharacterTypes where row_id = ${intIDVal}`;
    stream<record{}, error> queryResult = dbClient->query(query, StringNilData);
    stream<StringNilData, sql:Error> streamData = <stream<StringNilData, sql:Error>>queryResult;
    record {|StringNilData value;|}? data = checkpanic streamData.next();
    checkpanic streamData.close();
    
    StringNilData expectedInsertRow = {
        row_id: 45,
        varchar_type: (),
        char_type: (),
        text_type: (),
        name_type: ()
    };
    test:assertEquals(data?.value, expectedInsertRow, "Incorrect InsetId returned.");
    checkpanic dbClient.close();
}

type BooleanData record {
    int row_id;
    boolean boolean_type;   
};

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testInsertWithNilStringAndSelectTable]
}
function testInsertWithBooleanAndSelectTable() {
    Client dbClient = checkpanic new (host, user, password, executeDb, port);
    string intIDVal = "15";
    string insertQuery = "Insert into BooleanTypes (row_id, boolean_type "
        + ") values ("
        + intIDVal + ",'true')";
    sql:ExecutionResult result = checkpanic dbClient->execute(insertQuery);
    
    test:assertExactEquals(result.affectedRowCount, 1, "Affected row count is different.");

    string query = string `SELECT * from BooleanTypes where row_id = ${intIDVal}`;
    stream<record{}, error> queryResult = dbClient->query(query, BooleanData);
    stream<BooleanData, sql:Error> streamData = <stream<BooleanData, sql:Error>>queryResult;
    record {|BooleanData value;|}? data = checkpanic streamData.next();
    checkpanic streamData.close();

    BooleanData expectedInsertRow = {
        row_id: 15,
        boolean_type: true
    };
    test:assertEquals(data?.value, expectedInsertRow, "Incorrect InsetId returned.");

    checkpanic dbClient.close();
}

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testInsertWithNilStringAndSelectTable]
}
function testInsertTableWithDatabaseError() {
    Client dbClient = checkpanic new (host, user, password, executeDb, port);
    sql:ExecutionResult|sql:Error result = dbClient->execute("Insert into NumericTypes2NonExistTable (int_type) values (20)");

    string expectedErrorMessage = "Error while executing SQL query: Insert into NumericTypes2NonExistTable (int_type) values (20). ERROR: relation \"numerictypes2nonexisttable\" does not exist";

    if (result is sql:DatabaseError) {
        test:assertTrue(result.message().startsWith(expectedErrorMessage), 
                        "Error message does not match, actual :\n'" + result.message() + "'\nExpected : \n" + expectedErrorMessage);

        sql:DatabaseErrorDetail errorDetails = result.detail();
        // test:assertEquals(errorDetails.errorCode, 0, "SQL Error code does not match");
        // test:assertEquals(errorDetails.sqlState, "42P01", "SQL Error state does not match");
    } else {
        test:assertFail("Database Error expected.");
    }

    checkpanic dbClient.close();
}

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testInsertTableWithDatabaseError]
}
function testInsertTableWithDataTypeError() {
    Client dbClient = checkpanic new (host, user, password, executeDb, port);
    sql:ExecutionResult|sql:Error result = dbClient->execute("Insert into NumericTypes2 (int_type) values"
        + " ('This is wrong type')");

    if (result is sql:DatabaseError) {
        string expectedErrorMessage = "Error while executing SQL query: Insert into NumericTypes2 (int_type) values ('This is wrong type'). ERROR: invalid input syntax for type integer: \"This is wrong type\"";
        test:assertTrue(result.message().startsWith(expectedErrorMessage), 
                    "Error message does not match, actual :'" + result.message() + "'\nExpected: "+expectedErrorMessage);
        sql:DatabaseErrorDetail errorDetails = result.detail();
        // test:assertEquals(errorDetails.errorCode, 0, "SQL Error code does not match");
        // test:assertEquals(errorDetails.sqlState, "22P02", "SQL Error state does not match");
    } else {
        test:assertFail("Database Error expected.");
    }

    checkpanic dbClient.close();
}

type ResultCount record {
    int countVal;
};

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testInsertTableWithDataTypeError]
}
function testUpdateNumericData() {
    Client dbClient = checkpanic new (host, user, password, executeDb, port);
    sql:ExecutionResult result = checkpanic dbClient->execute("Update NumericTypes2 set int_type = 11 where int_type = 10");
    test:assertExactEquals(result.affectedRowCount, 1, "Affected row count is different.");
    
    stream<record{}, error> queryResult = dbClient->query("SELECT count(*) as countval from NumericTypes2"
        + " where int_type = 11", ResultCount);
    stream<ResultCount, sql:Error> streamData = <stream<ResultCount, sql:Error>>queryResult;
    record {|ResultCount value;|}? data = checkpanic streamData.next();
    checkpanic streamData.close();
    test:assertEquals(data?.value?.countVal, 1, "Numeric table Update command was not successful.");

    checkpanic dbClient.close();
}

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testUpdateNumericData]
}
function testUpdateStringData() {
    Client dbClient = checkpanic new (host, user, password, executeDb, port);
    sql:ExecutionResult result = checkpanic dbClient->execute("Update CharacterTypes set varchar_type = 'updatedstr' where varchar_type = 'str1'");
    test:assertExactEquals(result.affectedRowCount, 1, "Affected row count is different.");
    
    stream<record{}, error> queryResult = dbClient->query("SELECT count(*) as countval from CharacterTypes"
        + " where varchar_type = 'updatedstr'", ResultCount);
    stream<ResultCount, sql:Error> streamData = <stream<ResultCount, sql:Error>>queryResult;
    record {|ResultCount value;|}? data = checkpanic streamData.next();
    checkpanic streamData.close();
    test:assertEquals(data?.value?.countVal, 1, "String table Update command was not successful.");

    checkpanic dbClient.close();
}

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testUpdateStringData]
}
function testUpdateBooleanData() {
    Client dbClient = checkpanic new (host, user, password, executeDb, port);
    string intId = "25";
    sql:ExecutionResult result = checkpanic dbClient->execute("insert into BooleanTypes (row_id, boolean_type) values ("+
                    intId+", true)");
    result = checkpanic dbClient->execute("Update BooleanTypes set boolean_type = false where row_id = 25");
    test:assertExactEquals(result.affectedRowCount, 1, "Affected row count is different.");
    
    stream<record{}, error> queryResult = dbClient->query("SELECT count(*) as countval from BooleanTypes"
        + " where row_id = 25", ResultCount);
    stream<ResultCount, sql:Error> streamData = <stream<ResultCount, sql:Error>>queryResult;
    record {|ResultCount value;|}? data = checkpanic streamData.next();
    checkpanic streamData.close();
    test:assertEquals(data?.value?.countVal, 1, "Boolean table Update command was not successful.");

    checkpanic dbClient.close();
}

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testUpdateStringData]
}
function testDeleteNumericData() {
    Client dbClient = checkpanic new (host, user, password, executeDb, port);
    sql:ExecutionResult result = checkpanic dbClient->execute("insert into NumericTypes2 (int_type) values (51)");
    result = checkpanic dbClient->execute("Delete from NumericTypes2 where int_type = 51");
    test:assertExactEquals(result.affectedRowCount, 1, "Affected row count is different.");
    
    stream<record{}, error> queryResult = dbClient->query("SELECT count(*) as countval from NumericTypes2"
        + " where int_type = 51", ResultCount);
    stream<ResultCount, sql:Error> streamData = <stream<ResultCount, sql:Error>>queryResult;
    record {|ResultCount value;|}? data = checkpanic streamData.next();
    checkpanic streamData.close();
    test:assertEquals(data?.value?.countVal, 0, "Numeric table Delete command was not successful.");

    checkpanic dbClient.close();
}

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testDeleteNumericData]
}
function testDeleteStringData() {
    Client dbClient = checkpanic new (host, user, password, executeDb, port);
    string intId = "55";
    sql:ExecutionResult result = checkpanic dbClient->execute("insert into CharacterTypes (row_id, varchar_type) values ("+
                    intId+", 'deletestr')");
    result = checkpanic dbClient->execute("Delete from CharacterTypes where varchar_type = 'deletestr'");
    test:assertExactEquals(result.affectedRowCount, 1, "Affected row count is different.");
    
    stream<record{}, error> queryResult = dbClient->query("SELECT count(*) as countval from CharacterTypes"
        + " where varchar_type = 'deletestr'", ResultCount);
    stream<ResultCount, sql:Error> streamData = <stream<ResultCount, sql:Error>>queryResult;
    record {|ResultCount value;|}? data = checkpanic streamData.next();
    checkpanic streamData.close();
    test:assertEquals(data?.value?.countVal, 0, "String table Delete command was not successful.");

    checkpanic dbClient.close();
}

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testDeleteNumericData]
}
function testDeleteBooleanData() {
    Client dbClient = checkpanic new (host, user, password, executeDb, port);
    string intId = "65";
    sql:ExecutionResult result = checkpanic dbClient->execute("insert into BooleanTypes (row_id, boolean_type) values ("+
                    intId+", false)");
    result = checkpanic dbClient->execute("Delete from BooleanTypes where row_id = 65");
    test:assertExactEquals(result.affectedRowCount, 1, "Affected row count is different.");
    
    stream<record{}, error> queryResult = dbClient->query("SELECT count(*) as countval from BooleanTypes"
        + " where row_id = 65", ResultCount);
    stream<ResultCount, sql:Error> streamData = <stream<ResultCount, sql:Error>>queryResult;
    record {|ResultCount value;|}? data = checkpanic streamData.next();
    checkpanic streamData.close();
    test:assertEquals(data?.value?.countVal, 0, "Boolean table Delete command was not successful.");

    checkpanic dbClient.close();
}

class TestSQLErrorValue {
    public int? value;
    public function init (int? value) {
        self.value = value;
    }
} 

@test:Config {
    groups: ["execute", "execute-basic"],
    dependsOn: [testDeleteBooleanData]
}
function testSqlTypedError() {
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
function testInetTypeError() {
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
function testPglasnTypeError() {
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
function testPointTypeError() {
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
function testLsegTypeError() {
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
function testBoxTypeError() {
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
function testCircleTypeError() {
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
    Client dbClient = checkpanic new (host, user, password, executeDb, port);
    sql:ExecutionResult|sql:Error result = dbClient->execute(sqlQuery);
    checkpanic dbClient.close();
    return result;
}

function queryPostgresqlClient(@untainted string|sql:ParameterizedQuery sqlQuery, typedesc<record {}>? resultType = (), string database = executeDb)
returns @tainted record {}? {
    Client dbClient = checkpanic new (host, user, password, database, port);
    stream<record {}, error> streamData = dbClient->query(sqlQuery, resultType);
    record {|record {} value;|}? data = checkpanic streamData.next();
    checkpanic streamData.close();
    record {}? value = data?.value;
    checkpanic dbClient.close();
    return value;
}
