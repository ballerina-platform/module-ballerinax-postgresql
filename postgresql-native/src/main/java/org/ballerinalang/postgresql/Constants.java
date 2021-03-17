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
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
package org.ballerinalang.postgresql;

import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.values.BString;

import static io.ballerina.runtime.api.utils.StringUtils.fromString;
/**
 * Constants for JDBC client.
 *
 * @since 1.2.0
 */
public final class Constants {
    /**
     * Constants for Client Configs.
     */
    public static final class ClientConfiguration {
        public static final BString HOST = StringUtils.fromString("host");
        public static final BString PORT = StringUtils.fromString("port");
        public static final BString USER = StringUtils.fromString("user");
        public static final BString PASSWORD = StringUtils.fromString("password");
        public static final BString DATABASE = StringUtils.fromString("database");
        public static final BString OPTIONS = StringUtils.fromString("options");
        public static final BString CONNECTION_POOL_OPTIONS = StringUtils.fromString("connectionPool");
    }
    /**
     * Constants for database options.
     */
    public static final class Options {
        public static final BString SSL = StringUtils.fromString("ssl");
        public static final BString CONNECT_TIMEOUT_SECONDS = StringUtils.fromString("connectTimeoutInSeconds");
        public static final BString SOCKET_TIMEOUT_SECONDS = StringUtils.fromString("socketTimeoutInSeconds");
        public static final BString LOGIN_TIMEOUT_SECONDS = StringUtils.fromString("loginTimeoutInSeconds");
        public static final BString ROW_FETCH_SIZE = StringUtils.fromString("rowFetchSize");
        public static final BString DB_METADATA_CACHE_FIELDS = StringUtils.fromString("dbMetadataCacheFields");
        public static final BString DB_METADATA_CACHE_FIELDS_MIB = StringUtils.fromString("dbMetadataCacheFieldsMiB");
        public static final BString PREPARE_THRESHOLD = StringUtils.fromString("prepareThreshold");
        public static final BString PREPARED_STATEMENT_CACHE_QUERIES = StringUtils
                        .fromString("preparedStatementCacheQueries");
        public static final BString PREPARED_STATEMENT_CACHE_SIZE_MIB = StringUtils
                        .fromString("preparedStatementCacheSize");
        public static final BString CANCEL_SIGNAL_TIMEOUT = StringUtils.fromString("cancelSignalTimeoutInSeconds");
        public static final BString TCP_KEEP_ALIVE = StringUtils.fromString("tcpKeepAlive");
    }
    /**
     * Constants for ssl configuration.
     */
    public static final class SSLConfig {
        public static final BString MODE = StringUtils.fromString("mode");
        public static final BString SSL_KEY = StringUtils.fromString("sslkey");
        public static final BString SSL_PASWORD = StringUtils.fromString("sslpassword");
        public static final BString SSL_ROOT_CERT = StringUtils.fromString("sslrootcert");
        public static final BString SSL_CERT = StringUtils.fromString("sslcert");

        /**
         The following constants are used to process ballerina `crypto:KeyStore`.
        */
        public static final class CryptoKeyStoreRecord {
            public static final BString KEY_STORE_RECORD_PATH_FIELD = StringUtils.fromString("path");
            public static final BString KEY_STORE_RECORD_PASSWORD_FIELD = StringUtils.fromString("password");
        }
    }
    /**
     * Constants for Hikari database Properties names.
     */
    public static final class DatabaseProps {
        public static final BString SSL_MODE = StringUtils.fromString("sslMode");
        public static final BString SSL_MODE_DISABLED = StringUtils.fromString("DISABLE");
        public static final BString DB_METADATA_CACHE_FIELDS = StringUtils.fromString("databaseMetadataCacheFields");
        public static final BString DB_METADATA_CACHE_FIELDS_MIB = StringUtils
                        .fromString("databaseMetadataCacheFieldsMiB");
        public static final BString PREPARE_THRESHOLD = StringUtils.fromString("prepareThreshold");
        public static final BString PREPARED_STATEMENT_CACHE_QUERIES = StringUtils.
                            fromString("preparedStatementCacheQueries");
        public static final BString PREPARED_STATEMENT_CACHE_SIZE_MIB = StringUtils.
                            fromString("preparedStatementCacheSizeMiB");
        public static final BString CANCEL_SIGNAL_TIMEOUT = StringUtils.fromString("cancelSignalTimeout");
        public static final BString TCP_KEEP_ALIVE = StringUtils.fromString("tcpKeepAlive");
        public static final BString CONNECT_TIMEOUT = StringUtils.fromString("connectTimeout");
        public static final BString SOCKET_TIMEOUT = StringUtils.fromString("socketTimeout");
        public static final BString LOGIN_TIMEOUT = StringUtils.fromString("loginTimeout");
        public static final BString ROW_FETCH_SIZE = StringUtils.fromString("defaultRowFetchSize");
    }
    /**
     * Constants for PostgreSQL Geometric datatypes related Constants.
     */
    public static final class Geometric {
        public static final String X = "x";
        public static final String Y = "y";
        public static final String R = "r";
        public static final String X1 = "x1";
        public static final String Y1 = "y1";
        public static final String X2 = "x2";
        public static final String Y2 = "y2";
        public static final String A = "a";
        public static final String B = "b";
        public static final String C = "c";
        public static final String P1 = "p1";
        public static final String P2 = "p2";
        public static final String POINTS = "points";
        public static final String ISOPEN = "isOpen";
    }
    /**
     * Constants for PostgreSQL Interval datatype related Constants.
     */
    public static final class Interval {
        public static final String YEARS = "years";
        public static final String MONTHS = "months";
        public static final String DAYS = "days";
        public static final String HOURS = "hours";
        public static final String MINUTES = "minutes";
        public static final String SECONDS = "seconds";
    }
    /**
     * Constants for PostgreSQL Range datatypes related Constants.
     */
    public static final class Range {
        public static final String UPPER = "upper";
        public static final String LOWER = "lower";
        public static final String UPPERINCLUSIVE = "isUpperboundInclusive";
        public static final String LOWERINCLUSIVE = "isLowerboundInclusive";
    }
    /**
     * Constants for PostgreSQL Records for query operation.
     */
    public static final class TypeRecordNames {
        public static final String POINTRECORD = "PointRecordType";
        public static final String LINERECOORDINATE = "CoordinateType";
        public static final String LINEEQUATION = "LineType";
        public static final String LSEGRECORD = "LsegRecordType";
        public static final String PATHRECORD = "PathRecordType";
        public static final String POLYGONRECORD = "PolygonRecordType";
        public static final String BOXRECORD = "BoxRecordType";
        public static final String CIRCLERECORD = "CircleRecordType";
        public static final String INTERVALRECORD = "IntervalRecordType";
        public static final String INT4RANGERECORD = "Int4rangeType";
        public static final String INT8RANGERECORD = "Int8rangeType";
        public static final String NUMRANGERECORD = "NumrangeType";
        public static final String TIMESTAMPRANGERECORD = "TsrangeType";
        public static final String TIMESTAMPTZRANGERECORD = "TstzrangeType";
        public static final String DATERANGERECORD = "DaterangeType";
    }    
    /**
     * Custom PostgreSQL Ballerina Datatypes names.
     */
    public static final class PGTypeNames {
        public static final String INET = "InetValue";
        public static final String CIDR = "CidrValue";
        public static final String MACADDR = "MacaddrValue";
        public static final String MACADDR8 = "Macaddr8Value";
        public static final String POINT = "PointValue";
        public static final String LINE = "LineValue";
        public static final String LSEG = "LsegValue";
        public static final String PATH = "PathValue";
        public static final String BOX = "BoxValue";
        public static final String POLYGON = "PolygonValue";
        public static final String CIRCLE = "CircleValue";
        public static final String UUID = "UuidValue";
        public static final String TSVECTOR = "TsvectorValue";
        public static final String TSQUERY = "TsqueryValue";
        public static final String JSON = "JsonValue";
        public static final String JSONB = "JsonbValue";
        public static final String JSONPATH = "JsonpathValue";
        public static final String INTERVAL = "IntervalValue";
        public static final String INT4RANGE = "Int4rangeValue";
        public static final String INT8RANGE = "Int8rangeValue";
        public static final String NUMRANGE = "NumrangeValue";
        public static final String TSRANGE = "TsrangeValue";
        public static final String TSTZRANGE = "TstzrangeValue";
        public static final String DATERANGE = "DaterangeValue";
        public static final String PGBIT = "PGBitValue";
        public static final String VARBITSTRING = "VarbitstringValue";
        public static final String BITSTRING = "BitstringValue";
        public static final String PGLSN = "PglsnValue";
        public static final String MONEY = "MoneyValue";
        public static final String REGCLASS = "RegclassValue";
        public static final String REGCONFIG = "RegconfigValue";
        public static final String REGDICTIONARY = "RegdictionaryValue";
        public static final String REGNAMESPACE = "RegnamespaceValue";
        public static final String REGOPER = "RegoperValue";
        public static final String REGOPERATOR = "RegoperatorValue";
        public static final String REGPROC = "RegprocValue";
        public static final String REGPROCEDURE = "RegprocedureValue";
        public static final String REGROLE = "RegroleValue";
        public static final String REGTYPE = "RegtypeValue";
        public static final String XML = "PGXmlValue";
    }
    /**
     * Constants for Datatypes names in PostgreSQL.
     */
    public static final class PGtypes {
        public static final String INET = "inet";
        public static final String CIDR = "cidr";
        public static final String MACADDR = "macaddr";
        public static final String MACADDR8 = "macaddr8";
        public static final String POINT = "point";
        public static final String LINE = "line";
        public static final String UUID = "uuid";
        public static final String TSVECTOR = "tsvector";
        public static final String TSQUERY = "tsquery";
        public static final String JSON = "json";
        public static final String JSONB = "jsonb";
        public static final String JSONPATH = "jsonpath";
        public static final String INT4RANGE = "int4range";
        public static final String INT8RANGE = "int8range";
        public static final String NUMRANGE = "numrange";
        public static final String TSRANGE = "tsrange";
        public static final String TSTZRANGE = "tstzrange";
        public static final String DATERANGE = "daterange";
        public static final String BITSTRING = "bit";
        public static final String VARBITSTRING = "varbit";
        public static final String PGBIT = "bit";
        public static final String PGLSN = "pg_lsn";
        public static final String XML = "xml";
        public static final String REGCLASS = "regclass";
        public static final String REGCONFIG = "regconfig";
        public static final String REGDICTIONARY = "regdictionary";
        public static final String REGNAMESPACE = "regnamespace";
        public static final String REGOPER = "regoper";
        public static final String REGOPERATOR = "regoperator";
        public static final String REGPROC = "regproc";
        public static final String REGPROCEDURE = "regprocedure";
        public static final String REGROLE = "regrole";
        public static final String REGTYPE = "regtype";
    }
    /**
     * Constants for the Value field in Custom datatypes.
     */
    public static final class TypedValueFields {
        public static final BString VALUE = fromString("value");
    }
    /**
     * Other Constants.
     */
    public static final String POSTGRESQL_DATASOURCE_NAME = "org.postgresql.ds.PGSimpleDataSource";
    public static final String FILE = "file:";
    public static final String POOL_CONNECT_TIMEOUT = "ConnectionTimeout";
    public static final String CUSTOM_RESULT_ITERATOR_OBJECT = "CustomResultIterator";
    public static final String JDBC_URL = "jdbc:postgresql://";
}
