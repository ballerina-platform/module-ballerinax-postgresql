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
package io.ballerina.stdlib.postgresql.utils;

import io.ballerina.runtime.api.creators.ValueCreator;
import io.ballerina.runtime.api.values.BDecimal;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.stdlib.postgresql.Constants;

/**
 * This class includes utility functions.
 */
public class Utils {
    public static BMap generateOptionsMap(BMap postgresqlOptions) {
        if (postgresqlOptions != null) {
            BMap<BString, Object> options = ValueCreator.createMapValue();
            addSSLOptions(postgresqlOptions.getMapValue(Constants.Options.SSL), options);
            long connectTimeout = getTimeout(postgresqlOptions.get(Constants.Options.CONNECT_TIMEOUT_SECONDS));
            if (connectTimeout >= 0) {
                options.put(Constants.DatabaseProps.CONNECT_TIMEOUT, connectTimeout);
            }
            long socketTimeout = getTimeout(postgresqlOptions.get(Constants.Options.SOCKET_TIMEOUT_SECONDS));
            if (socketTimeout >= 0) {
                options.put(Constants.DatabaseProps.SOCKET_TIMEOUT, socketTimeout);
            }
            long loginTimeout = getTimeout(postgresqlOptions.get(Constants.Options.LOGIN_TIMEOUT_SECONDS));
            if (loginTimeout >= 0) {
                options.put(Constants.DatabaseProps.LOGIN_TIMEOUT, loginTimeout);
            }
            if (postgresqlOptions.containsKey(Constants.Options.ROW_FETCH_SIZE)) {
                long rowFetchSize = postgresqlOptions.getIntValue(Constants.Options.ROW_FETCH_SIZE);
                if (rowFetchSize > 0) {
                    options.put(Constants.DatabaseProps.ROW_FETCH_SIZE, rowFetchSize);
                }
            }
            if (postgresqlOptions.containsKey(Constants.Options.DB_METADATA_CACHE_FIELDS)) {
                long cachedMetadataFieldsCount = postgresqlOptions
                                    .getIntValue(Constants.Options.DB_METADATA_CACHE_FIELDS);
                if (cachedMetadataFieldsCount >= 0) {
                    options.put(Constants.DatabaseProps.DB_METADATA_CACHE_FIELDS, cachedMetadataFieldsCount);
                }
            }
            if (postgresqlOptions.containsKey(Constants.Options.DB_METADATA_CACHE_FIELDS)) {
                long cachedMetadataFieldSize = postgresqlOptions
                                    .getIntValue(Constants.Options.DB_METADATA_CACHE_FIELDS_MIB);
                if (cachedMetadataFieldSize >= 0) {
                    options.put(Constants.DatabaseProps.DB_METADATA_CACHE_FIELDS_MIB, cachedMetadataFieldSize);
                }
            }
            if (postgresqlOptions.containsKey(Constants.Options.PREPARE_THRESHOLD)) {
                long preparedStatementThreshold = postgresqlOptions.
                                    getIntValue(Constants.Options.PREPARE_THRESHOLD);
                if (preparedStatementThreshold >= 0) {
                    options.put(Constants.DatabaseProps.PREPARE_THRESHOLD, preparedStatementThreshold);
                }
            }
            if (postgresqlOptions.containsKey(Constants.Options.PREPARED_STATEMENT_CACHE_QUERIES)) {
                long preparedStatementCacheQueries = postgresqlOptions
                                    .getIntValue(Constants.Options.PREPARED_STATEMENT_CACHE_QUERIES);
                if (preparedStatementCacheQueries >= 0) {
                    options.put(Constants.DatabaseProps.PREPARED_STATEMENT_CACHE_QUERIES,
                                     preparedStatementCacheQueries);
                }
            }
            if (postgresqlOptions.containsKey(Constants.Options.PREPARED_STATEMENT_CACHE_QUERIES)) {
                long preparedStatementCacheSize = postgresqlOptions
                                    .getIntValue(Constants.Options.PREPARED_STATEMENT_CACHE_SIZE_MIB);
                if (preparedStatementCacheSize >= 0) {
                    options.put(Constants.DatabaseProps.PREPARED_STATEMENT_CACHE_SIZE_MIB, preparedStatementCacheSize);
                }
            }
            long cancelSignalTimeout = getTimeout(postgresqlOptions.get(Constants.Options.CANCEL_SIGNAL_TIMEOUT));
            if (cancelSignalTimeout >= 0) {
                options.put(Constants.DatabaseProps.CANCEL_SIGNAL_TIMEOUT, cancelSignalTimeout);
            }
            int keepAliveTcpProbe = getBooleanValue(postgresqlOptions.get(Constants.Options.TCP_KEEP_ALIVE));
            if (keepAliveTcpProbe >= 0) {
                if (keepAliveTcpProbe == 1) {
                    options.put(Constants.DatabaseProps.TCP_KEEP_ALIVE, true);
                } else {
                    options.put(Constants.DatabaseProps.TCP_KEEP_ALIVE, false);
                }
            }
            int binaryTransfer = getBooleanValue(postgresqlOptions
                        .get(Constants.Options.BINARY_TRANSFER));
            if (binaryTransfer >= 0) {
                if (binaryTransfer == 1) {
                    options.put(Constants.DatabaseProps.BINARY_TRANSFER, true);
                } else {
                    options.put(Constants.DatabaseProps.BINARY_TRANSFER, false);
                }
            }
            if (postgresqlOptions.containsKey(Constants.Options.CURRENT_SCHEMA)) {
                options.put(Constants.DatabaseProps.CURRENT_SCHEMA, postgresqlOptions
                        .getStringValue(Constants.Options.CURRENT_SCHEMA));
            }
            return options;
        }
        return null;
    }
    
    private static int getBooleanValue(Object value) {
        if (value instanceof Boolean) {
            if (((Boolean) value) == true) {
                return 1;
            }
            return 0;
        }
        return -1;
    }

    public static long getTimeout(Object secondsDecimal) {
        if (secondsDecimal instanceof BDecimal) {
            BDecimal timeoutSec = (BDecimal) secondsDecimal;
            if (timeoutSec.floatValue() >= 0) {
                return Double.valueOf(timeoutSec.floatValue()  * 1000).longValue();
            }
        }
        return -1;
    }

    private static void addSSLOptions(BMap secureSocket, BMap<BString, Object> options) {
        if (secureSocket == null) {
            options.put(Constants.DatabaseProps.SSL_MODE, Constants.DatabaseProps.SSL_MODE_DISABLED);
        } else {
            BString mode = secureSocket.getStringValue(Constants.SecureSocket.MODE);
            options.put(Constants.DatabaseProps.SSL_MODE, mode);
            if (mode != Constants.DatabaseProps.SSL_MODE_DISABLED) {
                options.put(Constants.DatabaseProps.SSL, true);
            }
            BMap key = secureSocket.getMapValue(Constants.SecureSocket.KEY);
            if (key != null) {
                if (key.containsKey(Constants.SecureSocket.CryptoKeyStoreRecord.KEY_STORE_RECORD_PATH_FIELD) 
                        && key.
                        containsKey(Constants.SecureSocket.CryptoKeyStoreRecord.KEY_STORE_RECORD_PASSWORD_FIELD)) {
                    options.put(Constants.SecureSocket.SSL_KEY, 
                             key.getStringValue(
                                    Constants.SecureSocket.CryptoKeyStoreRecord.KEY_STORE_RECORD_PATH_FIELD));
                    options.put(Constants.SecureSocket.SSL_PASSWORD, key
                        .getStringValue(Constants.SecureSocket.CryptoKeyStoreRecord.KEY_STORE_RECORD_PASSWORD_FIELD));
                } else {
                    options.put(Constants.SecureSocket.SSL_CERT, key
                        .getStringValue(Constants.SecureSocket.CertKeyRecord.CERT_FILE));
                    options.put(Constants.SecureSocket.SSL_KEY, key
                        .getStringValue(Constants.SecureSocket.CertKeyRecord.KEY_FILE));
                    BString keyPassword = key.getStringValue(Constants.SecureSocket.CertKeyRecord.KEY_PASSWORD);
                    if (keyPassword != null) {
                        options.put(Constants.SecureSocket.SSL_PASSWORD, keyPassword);
                    }
                }
            }
            BString sslrootcert = secureSocket.getStringValue(Constants.SecureSocket.ROOT_CERT);
            if (sslrootcert != null) {
                options.put(Constants.SecureSocket.SSL_ROOT_CERT, sslrootcert);
            }
        }
    }
}
