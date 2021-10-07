/*
 *  Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */

package io.ballerina.stdlib.postgresql.nativeimpl;

import io.ballerina.runtime.api.Environment;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BStream;
import io.ballerina.runtime.api.values.BTypedesc;
import io.ballerina.stdlib.postgresql.parameterprocessor.PostgresResultParameterProcessor;
import io.ballerina.stdlib.postgresql.parameterprocessor.PostgresStatementParameterProcessor;

/**
 * This class provides the query processing implementation which executes sql queries.
 */
public class QueryProcessorUtils {

    private QueryProcessorUtils() {}
    
    public static BStream nativeQuery(Environment env, BObject client, BObject paramSQLString, BTypedesc recordType) {
        return io.ballerina.stdlib.sql.nativeimpl.QueryProcessor.nativeQuery(env, client, paramSQLString, recordType,
                    PostgresStatementParameterProcessor.getInstance(), PostgresResultParameterProcessor.getInstance());
    }

    public static Object nativeQueryRow(Environment env, BObject client, BObject paramSQLString, BTypedesc recordType) {
        PostgresStatementParameterProcessor statementParametersProcessor = PostgresStatementParameterProcessor
                .getInstance();
        PostgresResultParameterProcessor resultParametersProcessor = PostgresResultParameterProcessor.getInstance();
        return io.ballerina.stdlib.sql.nativeimpl.QueryProcessor.nativeQueryRow(env, client, paramSQLString, recordType,
                statementParametersProcessor, resultParametersProcessor);
    }
}
