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

import ballerina/io;

isolated function getUntaintedData(record {}|error? value, string fieldName) returns @untainted anydata {
    if (value is record {}) {
        return value[fieldName];
    }
    return {};
}

isolated function getByteaColumnChannel() returns @untainted io:ReadableByteChannel | error {
    io:ReadableByteChannel byteChannel = check io:openReadableFile("./tests/resources/files/byteValue.txt");
    return byteChannel;
}

isolated function getByteaColumnChannel2() returns @untainted io:ReadableByteChannel | error {
    io:ReadableByteChannel byteChannel = check io:openReadableFile("./tests/resources/files/emptyByteValue.txt");
    return byteChannel;
}
