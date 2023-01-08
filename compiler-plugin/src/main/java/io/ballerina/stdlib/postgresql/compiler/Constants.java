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
    public static final String OUT_PARAMETER_POSTFIX = "OutParameter";

    /**
     * Constants related to Client object.
     */
    public static class Client {
        public static final String NAME = "Client";
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

    /**
     * Constants for fields in OutParameter objects.
     */
    public static class OutParameter {
        public static final String METHOD_NAME = "get";

        public static final String INET = "InetOutParameter";
        public static final String CIDR = "CidrOutParameter";
        public static final String MACADDR = "MacAddrOutParameter";
        public static final String MACADDR8 = "MacAddr8OutParameter";
        public static final String POINT = "PointOutParameter";
        public static final String LINE = "LineOutParameter";
        public static final String LSEG = "LsegOutParameter";
        public static final String PATH = "PathOutParameter";
        public static final String BOX = "BoxOutParameter";
        public static final String POLYGON = "PolygonOutParameter";
        public static final String CIRCLE = "CircleOutParameter";
        public static final String UUID = "UuidOutParameter";
        public static final String TSVECTOR = "TsVectorOutParameter";
        public static final String TSQUERY = "TsQueryOutParameter";
        public static final String JSON = "JsonOutParameter";
        public static final String JSONB = "JsonbOutParameter";
        public static final String JSONPATH = "JsonPathOutParameter";
        public static final String INTERVAL = "IntervalOutParameter";
        public static final String INT4RANGE = "IntegerRangeOutParameter";
        public static final String INT8RANGE = "LongRangeOutParameter";
        public static final String NUMRANGE = "NumericRangeOutParameter";
        public static final String TSRANGE = "TimestampRangeOutParameter";
        public static final String TSTZRANGE = "TimestampTzRangeOutParameter";
        public static final String DATERANGE = "DateRangeOutParameter";
        public static final String PGBIT = "PGBitOutParameter";
        public static final String VARBITSTRING = "VarBitStringOutParameter";
        public static final String BITSTRING = "BitStringOutParameter";
        public static final String PGLSN = "PglsnOutParameter";
        public static final String MONEY = "MoneyOutParameter";
        public static final String REGCLASS = "RegClassOutParameter";
        public static final String REGCONFIG = "RegConfigOutParameter";
        public static final String REGDICTIONARY = "RegDictionaryOutParameter";
        public static final String REGNAMESPACE = "RegNamespaceOutParameter";
        public static final String REGOPER = "RegOperOutParameter";
        public static final String REGOPERATOR = "RegOperatorOutParameter";
        public static final String REGPROC = "RegProcOutParameter";
        public static final String REGPROCEDURE = "RegProcedureOutParameter";
        public static final String REGROLE = "RegRoleOutParameter";
        public static final String REGTYPE = "RegTypeOutParameter";
        public static final String BINARY = "ByteaOutParameter";
        public static final String XML = "PGXmlOutParameter";
    }

    public static final String UNNECESSARY_CHARS_REGEX = "\"|\\n";

}
