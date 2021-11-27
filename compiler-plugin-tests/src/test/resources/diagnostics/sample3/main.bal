// Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

import ballerinax/postgresql;

public function main() {

    int id = 5;

    int|postgresql:Options pool1 = 5;

    int|postgresql:Options pool2 = {
        loginTimeout: -2,
        socketTimeout: -3
    };

    postgresql:Options|int pool3 = {
        loginTimeout: -2,
        socketTimeout: -3
    };

    postgresql:Options pool4 = {
        ssl: {
           mode: "PREFER"
        },
        connectTimeout: -1,
        socketTimeout: -1,
        loginTimeout: -1,
        cancelSignalTimeout: -1,
        rowFetchSize: 0,
        cachedMetadataFieldsCount: -1,
        cachedMetadataFieldSize: -1,
        preparedStatementThreshold: -1,
        preparedStatementCacheQueries: -1,
        preparedStatementCacheSize: -1
    };

    postgresql:Options pool5 = {
    };
}
