// Copyright (c) 2022 WSO2 LLC. (https://www.wso2.com) All Rights Reserved.
//
// WSO2 LLC. licenses this file to you under the Apache License,
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

import ballerina/test;
import ballerina/sql;

@test:Config {
    groups: ["metadata"]
}
function testListTables() returns error? {
    SchemaClient client1 = check new(host, user, password, "metadatadatabase", port);
    string[] tableList = check client1->listTables();
    check client1.close();
    test:assertEquals(tableList, ["employees", "offices"]);
}

@test:Config {
    groups: ["metadata"]
}
function testListTablesNegative() returns error? {
    SchemaClient client1 = check new(host, user, password, "metadatadatabaseempty", port);
    string[] tableList = check client1->listTables();
    check client1.close();
    test:assertEquals(tableList, []);
}

@test:Config {
    groups: ["metadata"]
}
function testGetTableInfoNoColumns() returns error? {
    SchemaClient client1 = check new(host, user, password, "metadatadatabase", port);
    TableDefinition 'table = check client1->getTableInfo("employees", include = sql:NO_COLUMNS);
    check client1.close();
    test:assertEquals('table, {"name": "employees", "type": "BASE TABLE"});
}

@test:Config {
    groups: ["metadata"]
}
function testGetTableInfoColumnsOnly() returns error? {
    SchemaClient client1 = check new(host, user, password, "metadatadatabase", port);
    TableDefinition 'table = check client1->getTableInfo("employees", include = sql:COLUMNS_ONLY);
    check client1.close();
    test:assertEquals('table.name, "employees");
    test:assertEquals('table.'type, "BASE TABLE");

    string tableCol = (<sql:ColumnDefinition[]>'table.columns).toString();
    boolean colCheck = tableCol.includes("employeenumber") && tableCol.includes("lastname") && 
                         tableCol.includes("firstname") && tableCol.includes("extension") && 
                         tableCol.includes("email") && tableCol.includes("officecode") && 
                         tableCol.includes("reportsto") && tableCol.includes("jobtitle");

    test:assertEquals(colCheck, true);
}

@test:Config {
    groups: ["metadata"]
}
function testGetTableInfoColumnsWithConstraints() returns error? {
    SchemaClient client1 = check new(host, user, password, "metadatadatabase", port);
    TableDefinition 'table = check client1->getTableInfo("employees", include = sql:COLUMNS_WITH_CONSTRAINTS);
    check client1.close();

    test:assertEquals('table.name, "employees");
    test:assertEquals('table.'type, "BASE TABLE");

    string tableCheckConst = (<sql:CheckConstraint[]>'table.checkConstraints).toString();
    boolean checkConstCheck = tableCheckConst.includes("chk_empnums");

    test:assertEquals(checkConstCheck, true);

    string tableCol = (<sql:ColumnDefinition[]>'table.columns).toString();
    boolean colCheck = tableCol.includes("employeenumber") && tableCol.includes("lastname") && 
                         tableCol.includes("firstname") && tableCol.includes("extension") && 
                         tableCol.includes("email") && tableCol.includes("officecode") && 
                         tableCol.includes("reportsto") && tableCol.includes("jobtitle") && 
                         tableCol.includes("fk_employeesoffice") && tableCol.includes("fk_employeesmanager");

    test:assertEquals(colCheck, true);
}

@test:Config {
    groups: ["metadata"]
}
function testGetTableInfoNegative() returns error? {
    SchemaClient client1 = check new(host, user, password, "metadatadatabase", port);
    TableDefinition|sql:Error 'table = client1->getTableInfo("employee", include = sql:NO_COLUMNS);
    check client1.close();
    if 'table is sql:Error {
        test:assertEquals('table.message(), "The selected table does not exist or the user does not have the required privilege level to view the table.");
    } else {
        test:assertFail("Expected result not received");
    }
}

@test:Config {
    groups: ["metadata"]
}
function testListRoutines() returns error? {
    SchemaClient client1 = check new(host, user, password, "metadatadatabase", port);
    string[] routineList = check client1->listRoutines();
    check client1.close();
    test:assertEquals(routineList, ["getempsname", "getempsemail"]);
}

@test:Config {
    groups: ["metadata"]
}
function testListRoutinesNegative() returns error? {
    SchemaClient client1 = check new(host, user, password, "metadatadatabaseempty", port);
    string[] routineList = check client1->listRoutines();
    check client1.close();
    test:assertEquals(routineList, []);
}

@test:Config {
    groups: ["metadata"]
}
function testGetRoutineInfo() returns error? {
    SchemaClient client1 = check new(host, user, password, "metadatadatabase", port);
    sql:RoutineDefinition routine = check client1->getRoutineInfo("getempsname");
    check client1.close();
    test:assertEquals(routine.name, "getempsname");
    test:assertEquals(routine.'type, "PROCEDURE");

    string routineParams = (<sql:ParameterDefinition[]>routine.parameters).toString();
    boolean paramCheck = routineParams.includes("empnumber") && routineParams.includes("fname");
    test:assertEquals(paramCheck, true);
}

@test:Config {
    groups: ["metadata"]
}
function testGetRoutineInfoNegative() returns error? {
    SchemaClient client1 = check new(host, user, password, "metadatadatabase", port);
    sql:RoutineDefinition|sql:Error routine = client1->getRoutineInfo("getempsnames");
    check client1.close();
    if routine is sql:Error {
        test:assertEquals(routine.message(), "Selected routine does not exist in the database, or the user does not have required privilege level to view it.");
    } else {
        test:assertFail("Expected result not recieved");
    }
}
