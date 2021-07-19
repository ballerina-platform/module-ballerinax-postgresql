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

import ballerina/test;
import ballerina/sql;
import ballerina/time;

@test:Config {
    groups: ["timestamp"]
}
public function testStringTimestamp() returns error? {
    Client dbClient = check new (host, user, password, database = proceduresDatabase);

    string datetimetz = "2021-07-21T12:00:00+03:30";
    sql:ExecutionResult ret = check dbClient->execute("INSERT INTO DateTimeTypes (ROW_ID, TIMESTAMPTZ_TYPE) " +
                                                      "VALUES(11, '"+datetimetz+"')");

    InOutParameter rowIdInoutValue = new (11);
    sql:DateTimeValue datetimetzValue = new();
    InOutParameter datetimetzInoutValue = new (datetimetzValue);

    sql:ParameterizedCallQuery sqlQuery =
        `
        CALL TimestampProcedure (${rowIdInoutValue}, ${datetimetzInoutValue});
	    `;
    sql:ProcedureCallResult result = check dbClient->call(sqlQuery, []);

    test:assertEquals(check datetimetzInoutValue.get(time:Utc), check time:utcFromString(datetimetz),
                      "Retrieved date time with timestamp does not match.");
}

@test:Config {
    groups: ["timestamp"]
}
public function testStringParamTimestamp() returns error? {
    Client dbClient = check new (host, user, password, database = proceduresDatabase);

    string datetimetzString = "2021-07-21T12:00:00+03:30";
    time:Civil datetimetzCivil = check time:civilFromString(datetimetzString);
    sql:DateTimeValue timestamptzType = new(datetimetzCivil);
    int rowId = 12;
    sql:ParameterizedQuery insertQuery =
        `
        INSERT INTO DateTimeTypes (ROW_ID, TIMESTAMPTZ_TYPE)
        VALUES(${rowId}, ${timestamptzType})
        `;
    sql:ExecutionResult ret = check dbClient->execute(insertQuery);

    InOutParameter rowIdInoutValue = new (rowId);
    sql:DateTimeValue datetimetzValue = new();
    InOutParameter datetimetzInoutValue = new (datetimetzValue);

    sql:ParameterizedCallQuery sqlQuery =
        `
        CALL TimestampProcedure (${rowIdInoutValue}, ${datetimetzInoutValue});
	    `;
    sql:ProcedureCallResult result = check dbClient->call(sqlQuery, []);

    test:assertEquals(check datetimetzInoutValue.get(time:Utc), check time:utcFromString(datetimetzString),
                      "Retrieved date time with timestamp does not match.");
}


@test:Config {
    groups: ["timestamp"]
}
public function testCivilTimestamp() returns error? {
    Client dbClient = check new (host, user, password, database = proceduresDatabase);

    time:Civil timestamptz = {year:2021, month:7, day:15, hour:12, minute:0, second:0, utcOffset: {hours: 3, minutes:30}};
    sql:DateTimeValue timestamptzType = new(timestamptz);
    int rowId = 13;
    sql:ParameterizedQuery insertQuery =
        `
        INSERT INTO DateTimeTypes (ROW_ID, TIMESTAMPTZ_TYPE)
        VALUES(${rowId}, ${timestamptzType})
        `;
    sql:ExecutionResult ret = check dbClient->execute(insertQuery);

    InOutParameter rowIdInoutValue = new (rowId);
    sql:DateTimeValue datetimetzValue = new();
    InOutParameter datetimetzInoutValue = new (datetimetzValue);

    sql:ParameterizedCallQuery sqlQuery =
        `
        CALL TimestampProcedure (${rowIdInoutValue}, ${datetimetzInoutValue});
	    `;
    sql:ProcedureCallResult result = check dbClient->call(sqlQuery, []);

    test:assertEquals(check datetimetzInoutValue.get(time:Utc), check time:utcFromCivil(timestamptz),
                      "Retrieved date time with timestamp does not match.");
}

public type Timestamptz record {
  time:Utc? timestamptz_type;
};

@test:Config {
    groups: ["timestamp"]
}
public function testCivilTimestamp2() returns error? {
    Client dbClient = check new (host, user, password, database = proceduresDatabase);

    time:Civil timestamptz = {year:2021, month:7, day:15, hour:12, minute:0, second:0, utcOffset: {hours: 3, minutes:30}};
    sql:DateTimeValue timestamptzType = new(timestamptz);
    int rowId = 14;
    sql:ParameterizedQuery insertQuery =
        `
        INSERT INTO DateTimeTypes (ROW_ID, TIMESTAMPTZ_TYPE)
        VALUES(${rowId}, ${timestamptzType})
        `;
    sql:ExecutionResult ret = check dbClient->execute(insertQuery);

    sql:ParameterizedQuery sqlQuery = `SELECT timestamptz_type FROM DateTimeTypes WHERE row_id = ${rowId}`;
    stream<Timestamptz, error> streamData = dbClient->query(sqlQuery);
    record {|Timestamptz value;|}? data = check streamData.next();
    Timestamptz? value = data?.value;

    if (value is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(value["timestamptz_type"], check time:utcFromCivil(timestamptz),
                          "Retrieved date time with timestamp does not match.");
    }
}
