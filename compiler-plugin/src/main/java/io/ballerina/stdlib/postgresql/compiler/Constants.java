/*
 * Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
package io.ballerina.stdlib.postgresql.compiler;

/**
 * Constants for PostgreSQL compiler plugin.
 */
public class Constants {
    public static final String BALLERINAX = "ballerinax";
    public static final String POSTGRESQL = "postgresql";
    public static final String CONNECTION_POOL_PARAM_NAME = "connectionPool";
    public static final String OPTIONS_PARAM_NAME = "options";

    /**
     * Constants related to Client object.
     */
    public static class Client {
        public static final String CLIENT = "Client";
        public static final String QUERY = "query";
        public static final String QUERY_ROW = "queryRow";
    }

    /**
     * Constants for fields in sql:ConnectionPool.
     */
    public static class ConnectionPool {
        public static final String MAX_OPEN_CONNECTIONS = "maxOpenConnections";
        public static final String MAX_CONNECTION_LIFE_TIME = "maxConnectionLifeTime";
        public static final String MIN_IDLE_CONNECTIONS = "minIdleConnections";
    }

    /**
     * Constants for fields in postgresql:Options.
     */
    public static class Options {
        public static final String NAME = "Options";
        public static final String CONNECT_TIMEOUT = "connectTimeout";
        public static final String SOCKET_TIMEOUT = "socketTimeout";
        public static final String LOGIN_TIMEOUT = "loginTimeout";
        public static final String CANCEL_SIGNAL_TIMEOUT = "cancelSignalTimeout";

        public static final String ROW_FETCH_SIZE = "rowFetchSize";
        public static final String CACHED_METADATA_FIELD_COUNT = "cachedMetadataFieldsCount";
        public static final String CACHED_METADATA_FIELD_SIZE = "cachedMetadataFieldSize";
        public static final String PREPARED_STATEMENT_THRESHOLD = "preparedStatementThreshold";
        public static final String PREPARED_STATEMENT_CACHE_QUERIES = "preparedStatementCacheQueries";
        public static final String PREPARED_STATEMENT_CACHE_SIZE_MIB = "preparedStatementCacheSize";
    }

    public static final String UNNECESSARY_CHARS_REGEX = "\"|\\n";

}
