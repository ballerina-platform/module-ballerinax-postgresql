// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.org).
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
import ballerina/log;
import ballerina/os;
import ballerinax/cdc;
import ballerinax/postgresql;
import ballerinax/postgresql.cdc.driver as _;

configurable string username = os:getEnv("DB_USERNAME");
configurable string password = os:getEnv("DB_PASSWORD");

listener postgresql:CdcListener financeDBListener = new (
    database = {
        username,
        password,
        databaseName: "finance_db"
    },
    options = {
        snapshotMode: cdc:NO_DATA,
        skippedOperations: [cdc:NONE]
    }
);

service cdc:Service on financeDBListener {
    isolated remote function onCreate(Transactions trx) returns error? {
        log:printInfo(`Create trx event received Transaction Id: ${trx.tx_id}`);
        if trx.amount > 10000.00 {
            string fraudAlert = string `Fraud detected! Transaction Id: ${trx.tx_id}, User Id: ${trx.user_id}, Amount: $${trx.amount}`;
            log:printInfo(`Email sent. Message ID: ${fraudAlert}`);
        }
    }

    isolated remote function onTruncate() returns error? {
        log:printInfo(`Truncate event received.`);
    }

    isolated remote function onError(cdc:Error e) {
        log:printInfo(`Error occurred: ${e.message()}`);
    }
}

type Transactions record {|
    int tx_id;
    int user_id;
    float amount;
    string status;
    int created_at;
|};
