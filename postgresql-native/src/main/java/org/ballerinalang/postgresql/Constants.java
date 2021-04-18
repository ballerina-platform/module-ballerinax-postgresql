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
 * @since 0.1.0
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
        public static final BString CONNECT_TIMEOUT_SECONDS = StringUtils.fromString("connectTimeout");
        public static final BString SOCKET_TIMEOUT_SECONDS = StringUtils.fromString("socketTimeout");
        public static final BString LOGIN_TIMEOUT_SECONDS = StringUtils.fromString("loginTimeout");
        public static final BString ROW_FETCH_SIZE = StringUtils.fromString("rowFetchSize");
        public static final BString DB_METADATA_CACHE_FIELDS = StringUtils.fromString("cachedMetadataFieldsCount");
        public static final BString DB_METADATA_CACHE_FIELDS_MIB = StringUtils.fromString("cachedMetadataFieldSize");
        public static final BString PREPARE_THRESHOLD = StringUtils.fromString("preparedStatementThreshold");
        public static final BString PREPARED_STATEMENT_CACHE_QUERIES = StringUtils
                        .fromString("preparedStatementCacheQueries");
        public static final BString PREPARED_STATEMENT_CACHE_SIZE_MIB = StringUtils
                        .fromString("preparedStatementCacheSize");
        public static final BString CANCEL_SIGNAL_TIMEOUT = StringUtils.fromString("cancelSignalTimeout");
        public static final BString TCP_KEEP_ALIVE = StringUtils.fromString("keepAliveTcpProbe");
        public static final BString BINARY_TRANSFER = StringUtils.fromString("binaryTransfer");
    }
    /**
     * Constants for ssl configuration.
     */
    public static final class SecureSocket {
        public static final BString MODE = StringUtils.fromString("mode");
        public static final BString SSL_KEY = StringUtils.fromString("sslkey");
        public static final BString SSL_PASSWORD = StringUtils.fromString("sslpassword");
        public static final BString SSL_ROOT_CERT = StringUtils.fromString("sslrootcert");
        public static final BString SSL_CERT = StringUtils.fromString("sslcert");
        public static final BString KEY = StringUtils.fromString("key");
        public static final BString ROOT_CERT = StringUtils.fromString("rootcert");
        /**
         The following constants are used to process ballerina `crypto:KeyStore` record.
        */
        public static final class CryptoKeyStoreRecord {
            public static final BString KEY_STORE_RECORD_PATH_FIELD = StringUtils.fromString("path");
            public static final BString KEY_STORE_RECORD_PASSWORD_FIELD = StringUtils.fromString("password");
        }
        /**
         The following constants are used to process `postgresql:CertKey` record.
        */
        public static final class CertKeyRecord {
            public static final BString CERT_FILE = StringUtils.fromString("certFile");
            public static final BString KEY_FILE = StringUtils.fromString("keyFile");
            public static final BString KEY_PASSWORD = StringUtils.fromString("keyPassword");
        }
    }
    /**
     * Constants for Hikari database Properties names.
     */
    public static final class DatabaseProps {
        public static final BString SSL = StringUtils.fromString("ssl");
        public static final BString SSL_MODE = StringUtils.fromString("sslmode");
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
        public static final BString BINARY_TRANSFER = StringUtils.fromString("binaryTransfer");
    }
    /**
     * Constants for Out Parameter Type Names. 
     */
    public static final class ParameterObject {
        public static final String INOUT_PARAMETER = "InOutParameter";
        public static final String OUT_PARAMETER_SUFFIX = "OutParameter";
    }
    /**
     * Constants for PostgreSQL Geometric datatypes.
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
        public static final String OPEN = "open";
    }
    /**
     * Constants for PostgreSQL Interval datatype.
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
     * Constants for PostgreSQL Range datatypes.
     */
    public static final class Range {
        public static final String UPPER = "upper";
        public static final String LOWER = "lower";
        public static final String UPPERINCLUSIVE = "upperboundInclusive";
        public static final String LOWERINCLUSIVE = "lowerboundInclusive";
    }
    /**
     * Constants for PostgreSQL User Defined datatypes.
     */
    public static final class Custom {
        public static final String TYPE = "sqlTypeName";
        public static final String VALUES = "values";
        public static final String VALUE = "value";
    }
    /**
     * Constants for PostgreSQL Records for query operation.
     */
    public static final class TypeRecordNames {
        public static final String POINTRECORD = "Point";
        public static final String LINERECORD = "Line";
        public static final String LSEGRECORD = "LineSegment";
        public static final String PATHRECORD = "Path";
        public static final String POLYGONRECORD = "Polygon";
        public static final String BOXRECORD = "Box";
        public static final String CIRCLERECORD = "Circle";
        public static final String INTERVALRECORD = "Interval";
        public static final String INTEGERRANGERECORD = "IntegerRange";
        public static final String LONGRANGERECORD = "LongRange";
        public static final String NUMERICALRANGERECORD = "NumericalRange";
        public static final String TIMESTAMPRANGERECORD = "TimestampRange";
        public static final String TIMESTAMPTZRANGERECORD = "TimestamptzRange";
        public static final String DATERANGERECORD = "DateRange";
        public static final String TIMESTAMP_RANGE_RECORD_CIVIL = "TimestampCivilRange";
        public static final String TIMESTAMPTZ_RANGE_RECORD_CIVIL = "TimestamptzCivilRange";
        public static final String DATERANGE_RECORD_TYPE = "DateRecordRange";
        public static final String CUSTOM_TYPES = "CustomValues";
        public static final String ENUM = "Enum";
    }    
    /**
     * Constants for Custom PostgreSQL Ballerina Datatypes names.
     */
    public static final class PGTypeNames {
        public static final String INET = "InetValue";
        public static final String CIDR = "CidrValue";
        public static final String MACADDR = "MacAddrValue";
        public static final String MACADDR8 = "MacAddr8Value";
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
        public static final String INT4RANGE = "IntegerRangeValue";
        public static final String INT8RANGE = "LongRangeValue";
        public static final String NUMRANGE = "NumericRangeValue";
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
        public static final String CUSTOM_TYPES = "CustomTypeValue";
        public static final String ENUM = "EnumValue";
    }
    /**
     * Constants for Custom PostgreSQL Ballerina Out Parameter names.
    */
    public static final class OutParameterNames {
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
        public static final String TSVECTOR = "TsvectorOutParameter";
        public static final String TSQUERY = "TsqueryOutParameter";
        public static final String JSON = "JsonOutParameter";
        public static final String JSONB = "JsonbOutParameter";
        public static final String JSONPATH = "JsonpathOutParameter";
        public static final String INTERVAL = "IntervalOutParameter";
        public static final String INT4RANGE = "IntegerRangeOutParameter";
        public static final String INT8RANGE = "LongRangeOutParameter";
        public static final String NUMRANGE = "NumericRangeOutParameter";
        public static final String TSRANGE = "TimestampRangeOutParameter";
        public static final String TSTZRANGE = "TimestamptzRangeOutParameter";
        public static final String DATERANGE = "DateRangeOutParameter";
        public static final String PGBIT = "PGBitOutParameter";
        public static final String VARBITSTRING = "VarbitStringOutParameter";
        public static final String BITSTRING = "BitstringOutParameter";
        public static final String PGLSN = "PglsnOutParameter";
        public static final String MONEY = "MoneyOutParameter";
        public static final String REGCLASS = "RegclassOutParameter";
        public static final String REGCONFIG = "RegconfigOutParameter";
        public static final String REGDICTIONARY = "RegdictionaryOutParameter";
        public static final String REGNAMESPACE = "RegnamespaceOutParameter";
        public static final String REGOPER = "RegoperOutParameter";
        public static final String REGOPERATOR = "RegoperatorOutParameter";
        public static final String REGPROC = "RegprocOutParameter";
        public static final String REGPROCEDURE = "RegprocedureOutParameter";
        public static final String REGROLE = "RegroleOutParameter";
        public static final String REGTYPE = "RegtypeOutParameter";
        public static final String BINARY = "ByteaOutParameter";
        public static final String XML = "PGXmlOutParameter";
        public static final String ENUM = "EnumOutParameter";
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
        public static final String TIMETZ = "timetz";
    }
        /**
     * Constants for Datatypes names in PostgreSQL.
     */
    public static final class ArrayTypes {
        public static final String POINT = "point";
        public static final String LINE = "line";
        public static final String LSEG = "lseg";
        public static final String BOX = "box";
        public static final String PATH = "path";
        public static final String POLYGON = "polygon";
        public static final String CIRCLE = "circle";
        public static final String INTERVAL = "interval";
        public static final String INT4RANGE = "int4range";
        public static final String INT8RANGE = "int8range";
        public static final String NUMRANGE = "numrange";
        public static final String TSRANGE = "tsrange";
        public static final String TSTZRANGE = "tstzrange";
        public static final String DATERANGE = "daterange";
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
    public static final String POOL_CONNECT_TIMEOUT = "ConnectionTimeout";
    public static final String CUSTOM_RESULT_ITERATOR_OBJECT = "CustomResultIterator";
    public static final String JDBC_URL = "jdbc:postgresql://";
}
