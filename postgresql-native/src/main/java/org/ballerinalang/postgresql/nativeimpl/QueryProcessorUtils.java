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

package org.ballerinalang.postgresql.nativeimpl;

import io.ballerina.runtime.api.PredefinedTypes;
import io.ballerina.runtime.api.creators.TypeCreator;
import io.ballerina.runtime.api.creators.ValueCreator;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BStream;
import io.ballerina.runtime.api.values.BTypedesc;
import org.ballerinalang.postgresql.Constants;
import org.ballerinalang.postgresql.parameterprocessor.PostgresResultParameterProcessor;
import org.ballerinalang.postgresql.parameterprocessor.PostgresStatementParameterProcessor;
import org.ballerinalang.sql.nativeimpl.QueryProcessor;
import org.ballerinalang.sql.utils.ErrorGenerator;
import org.ballerinalang.sql.utils.ModuleUtils;

/**
 * This class provides the query processing implementation which executes sql queries.
 */
public class QueryProcessorUtils {

    private static final String ERROR = "err";
    private static final String RESULT_ITERATOR = "ResultIterator";

    private QueryProcessorUtils() {}
    
    public static BStream nativeQuery(BObject client, Object paramSQLString, BTypedesc recordType) {
        BStream result = QueryProcessor.nativeQuery(client, paramSQLString, recordType,
                    PostgresStatementParameterProcessor.getInstance(), PostgresResultParameterProcessor.getInstance());
        Object error = result.getIteratorObj().get(StringUtils.fromString(ERROR));
        if (error != null && isContainString(error)) {
            BError errorValue =  ErrorGenerator.getSQLApplicationError(Constants.ERROR_MSG);
            return getErrorStream(recordType, errorValue);
        }
        return result;
    }

    private static BStream getErrorStream(Object recordType, BError errorValue) {
        return ValueCreator.createStreamValue(TypeCreator.createStreamType(((BTypedesc) recordType).getDescribingType(),
                PredefinedTypes.TYPE_NULL), createRecordIterator(errorValue));
    }

    private static BObject createRecordIterator(BError errorValue) {
        return ValueCreator.createObjectValue(ModuleUtils.getModule(), RESULT_ITERATOR,
                new Object[]{errorValue, null});
    }

    private static boolean isContainString(Object result) {
        return ((BError) result).getErrorMessage().getValue().contains(Constants.MSG);
    }
}
