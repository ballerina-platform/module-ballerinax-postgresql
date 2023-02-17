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

import ballerina/sql;

# Represents an SQL metadata client.
isolated client class SchemaClient {
    private final Client dbClient;        
    private final string database;

    # Initializes the SchemaClient object
    #
    # + host - Hostname of the PostgreSQL server
    # + user - If the PostgreSQL server is secured, the username
    # + password - The password of the PostgreSQL server for the provided username
    # + database - The name of the database. The default is to connect to a database with the
    #              same name as the username
    # + port - Port number of the PostgreSQL server
    # + options - The database specific PostgreSQL connection properties
    # + connectionPool - The `sql:ConnectionPool` object to be used within the client. If there is no
    #                    `connectionPool` provided, the global connection pool will be used         
    # + return - An `sql:Error` if the client creation fails
    public function init(string host, string user, string password, string database, int port, 
            Options? options = (), sql:ConnectionPool? connectionPool = ()) returns sql:Error? {        
        self.database =  database;
        self.dbClient = check new (host, user, password, database, port, options, connectionPool);
    }

    # Retrieves all tables in the database.
    #
    # + return - A string array containing the names of the tables or an `sql:Error`
    isolated remote function listTables() returns string[]|sql:Error {
        string[] tables = [];
        stream<record {}, sql:Error?> tableStream = self.dbClient->query(
            `SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES 
            WHERE TABLE_CATALOG = ${self.database} AND TABLE_SCHEMA NOT IN ('pg_catalog', 'information_schema');`
        );

        do {
            tables = check from record {} 'table in tableStream
                select <string>'table["table_name"];
        } on fail error e {
            return error sql:Error(string `Error while listing the tables in the ${self.database} database.`, cause = e);
        }

        check tableStream.close();
        return tables;
    }

    # Retrieves information relevant to the provided table in the database.
    #
    # + tableName - The name of the table
    # + include - Options on whether column and constraint related information should be fetched.
    #             If `NO_COLUMNS` is provided, then no information related to columns will be retrieved.
    #             If `COLUMNS_ONLY` is provided, then columnar information will be retrieved, but not constraint
    #             related information.
    #             If `COLUMNS_WITH_CONSTRAINTS` is provided, then columar information along with constraint related
    #             information will be retrieved
    # + return - An 'sql:TableDefinition' with the relevant table information or an `sql:Error`
    isolated remote function getTableInfo(string tableName, sql:ColumnRetrievalOptions include = sql:COLUMNS_ONLY) returns sql:TableDefinition|sql:Error {
        record {}|sql:Error 'table = self.dbClient->queryRow(
            `SELECT TABLE_TYPE FROM INFORMATION_SCHEMA.TABLES 
             WHERE (TABLE_CATALOG=${self.database} AND TABLE_NAME = ${tableName});`
        );

        if 'table is sql:NoRowsError {
            return error sql:NoRowsError("The selected table does not exist or the user does not have the required privilege level to view the table.");
        } else if 'table is sql:Error {
            return 'table;
        } else {
            sql:TableDefinition tableDef = {
                name: tableName,
                'type: <sql:TableType>'table["table_type"]
            };

            if !(include == sql:NO_COLUMNS) {
                tableDef = check self.addColumns(tableName, tableDef);

                if include == sql:COLUMNS_WITH_CONSTRAINTS {
                    tableDef = check self.getConstraints(tableName, tableDef);
                }    
            }

            return tableDef;
        }
    }

    # Retrieves all routines in the database.
    #
    # + return - A string array containing the names of the routines or an `sql:Error`
    isolated remote function listRoutines() returns string[]|sql:Error {
        string[] routines = [];
        stream<record {}, sql:Error?> results = self.dbClient->query(
            `SELECT ROUTINE_NAME FROM INFORMATION_SCHEMA.ROUTINES
            WHERE ROUTINE_CATALOG = ${self.database} AND ROUTINE_SCHEMA NOT IN ('pg_catalog', 'information_schema');`
        );

        do {
            routines = check from record {} result in results
                select <string>result["routine_name"];
        } on fail error e {
            return error(string `Error while listing routines in the ${self.database} database.`, cause = e);
        }

        check results.close();

        return routines;
    }

    # Retrieves information relevant to the provided routine in the database.
    #
    # + name - The name of the routine
    # + return - An 'sql:RoutineDefinition' with the relevant routine information or an `sql:Error`
    isolated remote function getRoutineInfo(string name) returns sql:RoutineDefinition|sql:Error {
        sql:RoutineDefinition|sql:Error routine = self.dbClient->queryRow(
            `SELECT ROUTINE_TYPE, DATA_TYPE FROM INFORMATION_SCHEMA.ROUTINES 
             WHERE ROUTINE_NAME = ${name};`
        );

        if routine is sql:NoRowsError {
            return error sql:NoRowsError("Selected routine does not exist in the database, or the user does not have required privilege level to view it.");
        } else if routine is sql:Error {
            return routine;
        } else {

            routine = check self.getParameters(name, routine);

            return routine;
        }
    }

    # Retrieves column information of the provided table in the database.
    #
    # + tableName - The name of the table
    # + tableDef - The table definition created in getTableInfo()
    # + return - An 'sql:TableDefinition' now including the column information or an `sql:Error`
    isolated function addColumns(string tableName, sql:TableDefinition tableDef) returns sql:TableDefinition|sql:Error {
        sql:ColumnDefinition[] columns = [];
        stream<record {}, sql:Error?> colResults = self.dbClient->query(
            `SELECT COLUMN_NAME, DATA_TYPE, COLUMN_DEFAULT, IS_NULLABLE FROM INFORMATION_SCHEMA.COLUMNS 
                WHERE (TABLE_CATALOG=${self.database} AND TABLE_NAME = ${tableName});`
        );
        do {
            check from record {} result in colResults
                do {
                    sql:ColumnDefinition column = {
                        name: <string>result["column_name"],
                        'type: <string>result["data_type"],
                        defaultValue: result["column_default"],
                        nullable: (<string>result["is_nullable"]) == "YES" ? true : false
                    };
                    columns.push(column);
                };
        } on fail error e {
            return error sql:Error(string `Error while reading column info in the ${tableName} table, in the ${self.database} database.`, cause = e);
        }

        check colResults.close();

        tableDef.columns = columns;

        return tableDef;
    }

    # Retrieves constraints information of the provided table in the database.
    #
    # + tableName - The name of the table
    # + tableDef - The table definition created in getTableInfo()
    # + return - An 'sql:TableDefinition' now including the constraint information or an `sql:Error`
    isolated function getConstraints(string tableName, sql:TableDefinition tableDef) returns sql:TableDefinition|sql:Error {
        sql:CheckConstraint[] checkConstList =  [];

        stream<record {}, sql:Error?> checkResults = self.dbClient->query(
            `SELECT DISTINCT CC.CONSTRAINT_NAME, CC.CHECK_CLAUSE 
            FROM INFORMATION_SCHEMA.CHECK_CONSTRAINTS AS CC 
            JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS TC 
            ON CC.CONSTRAINT_NAME = TC.CONSTRAINT_NAME
            WHERE TC.TABLE_NAME=${tableName};`
        );
        do {
            check from record {} result in checkResults
                do {
                    sql:CheckConstraint 'check = {
                        name: <string>result["constraint_name"],
                        clause: <string>result["check_clause"]
                    };
                    checkConstList.push('check);
                };
        } on fail error e {
            return error sql:Error(string `Error while reading check constraints in the ${self.database} database.`, cause = e);
        }

        check checkResults.close();        

        tableDef.checkConstraints = checkConstList;

        map<sql:ReferentialConstraint[]> refConstMap = {};

        stream<record {}, sql:Error?> refResults = self.dbClient->query(
            `SELECT KCU.CONSTRAINT_NAME, KCU.TABLE_NAME, KCU.COLUMN_NAME, RC.UPDATE_RULE, RC.DELETE_RULE
            FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS RC 
            JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE as KCU
            ON KCU.CONSTRAINT_CATALOG = RC.CONSTRAINT_CATALOG 
            AND KCU.CONSTRAINT_CATALOG = RC.CONSTRAINT_CATALOG
            AND KCU.CONSTRAINT_NAME = RC.CONSTRAINT_NAME
            WHERE (RC.CONSTRAINT_CATALOG=${self.database} AND KCU.TABLE_NAME = ${tableName});`
        );
        do {
            check from record {} result in refResults
                do {
                    sql:ReferentialConstraint ref = {
                        name: <string>result["constraint_name"],
                        tableName: <string>result["table_name"],
                        columnName: <string>result["column_name"],
                        updateRule: <sql:ReferentialRule>result["update_rule"],
                        deleteRule: <sql:ReferentialRule>result["delete_rule"]
                    };

                    string colName = <string>result["column_name"];
                    if refConstMap[colName] is () {
                        refConstMap[colName] = [];
                    }
                    refConstMap.get(colName).push(ref);
                };
        } on fail error e {
            return error sql:Error(string `Error while reading referential constraints in the ${tableName} table, in the ${self.database} database.`, cause = e);
        }

        foreach sql:ColumnDefinition col in <sql:ColumnDefinition[]>tableDef.columns {
            sql:ReferentialConstraint[]? refConst = refConstMap[col.name];
            if refConst is sql:ReferentialConstraint[] && refConst.length() != 0 {
                col.referentialConstraints = refConst;
            }
        }

        check refResults.close();

        return tableDef;
    }

    # Retrieves parameter information of the provided routine in the database.
    #
    # + name - The name of the routine
    # + routine - The routine definition created in getRoutineInfo()
    # + return - An 'sql:RoutineDefinition' now including the parameter information or an `sql:Error`
    isolated function getParameters(string name, sql:RoutineDefinition routine) returns sql:RoutineDefinition|sql:Error {
        sql:ParameterDefinition[] parameterList = [];

        stream<sql:ParameterDefinition, sql:Error?> paramResults = self.dbClient->query(
            `SELECT P.PARAMETER_MODE, P.PARAMETER_NAME, P.DATA_TYPE
            FROM INFORMATION_SCHEMA.PARAMETERS AS P
            JOIN INFORMATION_SCHEMA.ROUTINES AS R
            ON P.SPECIFIC_NAME = R.SPECIFIC_NAME
            WHERE R.ROUTINE_NAME = ${name};`
        );
        do {
            check from sql:ParameterDefinition parameters in paramResults
                do {
                    sql:ParameterDefinition 'parameter = {
                        mode: <sql:ParameterMode>parameters["parameter_mode"],
                        name: <string>parameters["parameter_name"],
                        'type: <string>parameters["data_type"]
                    };
                    parameterList.push('parameter);
                };
        } on fail error e {
            return error sql:Error(string `Error while reading parameters in the ${name} routine, in the ${self.database} database.`, cause = e);
        }

        check paramResults.close();

        sql:RoutineDefinition routineDef = {
            name: name,
            'type: <sql:RoutineType>routine["routine_type"],
            returnType: <string?>routine["data_type"],
            parameters: parameterList
        };

        return routineDef;
    }

    public isolated function close() returns error? {
        do {
            _ = check self.dbClient.close();
        } on fail error e {
            return error("Error while closing the client", cause = e);
        }
    }
}
