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
package io.ballerina.stdlib.postgresql.parameterprocessor;

import io.ballerina.runtime.api.TypeTags;
import io.ballerina.runtime.api.types.ArrayType;
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.utils.TypeUtils;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BDecimal;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.api.values.BXml;
import io.ballerina.stdlib.io.channels.base.Channel;
import io.ballerina.stdlib.io.utils.IOConstants;
import io.ballerina.stdlib.io.utils.IOUtils;
import io.ballerina.stdlib.postgresql.Constants;
import io.ballerina.stdlib.postgresql.utils.ConverterUtils;
import io.ballerina.stdlib.sql.exception.ConversionError;
import io.ballerina.stdlib.sql.exception.DataError;
import io.ballerina.stdlib.sql.exception.TypeMismatchError;
import io.ballerina.stdlib.sql.exception.UnsupportedTypeError;
import io.ballerina.stdlib.sql.parameterprocessor.DefaultStatementParameterProcessor;
import io.ballerina.stdlib.sql.utils.Utils;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Array;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Types;
import java.time.LocalTime;
import java.time.OffsetTime;
import java.time.ZoneOffset;

/**
 * Represent the methods for process SQL statements.
 *
 * @since 0.1.0
 */
public class PostgresStatementParameterProcessor extends DefaultStatementParameterProcessor {
    private static final PostgresStatementParameterProcessor instance = new PostgresStatementParameterProcessor();

     /**
     * Singleton static method that returns an instance of `PostgresStatementParameterProcessor`.
     * @return PostgresStatementParameterProcessor
     */
    public static PostgresStatementParameterProcessor getInstance() {
        return instance;
    }

    @Override
    protected Object[] getDateTimeValueArrayData(Object value) throws DataError {
        return StatementParameterUtils.getDateTimeAndTimestampValueArrayData(value);
    }

    protected Object[] getTimeValueArrayData(Object value) throws DataError {
        BArray array = (BArray) value;
        int arrayLength = array.size();
        Object innerValue;
        Object[] arrayData = new Object[arrayLength];
        boolean containsTimeZone = false;
        for (int i = 0; i < arrayLength; i++) {
            innerValue = array.get(i);
            if (innerValue == null) {
                arrayData[i] = null;
            } else if (innerValue instanceof BString) {
                StatementParameterUtils.getTimeFromString(arrayData, innerValue, i);
            } else if (innerValue instanceof BMap) {
                containsTimeZone = StatementParameterUtils.getTimeFromMap(arrayData, innerValue, i);
            } else {
                throw io.ballerina.stdlib.sql.utils.Utils.throwInvalidParameterError(innerValue, "Time Array");
            }
        }
        if (containsTimeZone) {
            return new Object[]{arrayData, Constants.ArrayTypes.TIMETZ};
        } else {
            return new Object[]{arrayData, Constants.ArrayTypes.TIME};
        }
    }

    @Override
    protected Object[] getTimestampValueArrayData(Object value) throws DataError {
        return StatementParameterUtils.getDateTimeAndTimestampValueArrayData(value);
    }

    @Override
    protected Object[] getNestedArrayData(Object value) throws DataError {
        Type type = TypeUtils.getType(value);
        Type elementType = ((ArrayType) type).getElementType();
        Type elementTypeOfArrayElement = ((ArrayType) elementType)
                .getElementType();
        if (elementTypeOfArrayElement.getTag() == TypeTags.BYTE_TAG) {
            BArray arrayValue = (BArray) value;
            Object[] arrayData = new byte[arrayValue.size()][];
            for (int i = 0; i < arrayData.length; i++) {
                arrayData[i] = ((BArray) arrayValue.get(i)).getBytes();
            }
            return new Object[]{arrayData, "BYTEA"};
        } else {
            throw Utils.throwInvalidParameterError(value, io.ballerina.stdlib.sql.Constants.SqlTypes.ARRAY);
        }
    }

    @Override
    protected Object[] getDoubleValueArrayData(Object value) throws DataError {
        BArray array = (BArray) value;
        int arrayLength = array.size();
        Object innerValue;
        Object[] arrayData = new Double[arrayLength];
        for (int i = 0; i < arrayLength; i++) {
            innerValue = array.get(i);
            if (innerValue == null) {
                arrayData[i] = null;
            } else if (innerValue instanceof Double) {
                arrayData[i] = ((Number) innerValue).doubleValue();
            } else if (innerValue instanceof Long || innerValue instanceof Float || innerValue instanceof Integer) {
                arrayData[i] = ((Number) innerValue).doubleValue();
            } else if (innerValue instanceof BDecimal) {
                arrayData[i] = ((BDecimal) innerValue).decimalValue().doubleValue();
            } else {
                throw Utils.throwInvalidParameterError(innerValue, "Double Array");
            }            
        }        
        return new Object[]{arrayData, "FLOAT4"};
    }

    @Override
    protected Object[] getRealValueArrayData(Object value) throws DataError {
        BArray array = (BArray) value;
        int arrayLength = array.size();
        Object innerValue;
        Object[] arrayData = new Double[arrayLength];
        for (int i = 0; i < arrayLength; i++) {
            innerValue = array.get(i);
            if (innerValue == null) {
                arrayData[i] = null;
            } else if (innerValue instanceof Double) {
                arrayData[i] = ((Number) innerValue).doubleValue();
            } else if (innerValue instanceof Long || innerValue instanceof Float || innerValue instanceof Integer) {
                arrayData[i] = ((Number) innerValue).doubleValue();
            } else if (innerValue instanceof BDecimal) {
                arrayData[i] = ((BDecimal) innerValue).decimalValue().doubleValue();
            } else {
                throw Utils.throwInvalidParameterError(innerValue, "Real Array");
            }            
        }        
        return new Object[]{arrayData, "FLOAT4"};
    }

    @Override
    public Object[] getBinaryValueArrayData(Object value) throws DataError {
        BObject objectValue;
        BArray array = (BArray) value;
        int arrayLength = array.size();
        Object innerValue;
        byte[][] byteArray = new byte[arrayLength][];
        for (int i = 0; i < arrayLength; i++) {
            innerValue = array.get(i);
            if (innerValue == null) {
                byteArray[i] = null;
            } else if (innerValue instanceof BArray) {                
                BArray arrayValue = (BArray) innerValue;
                if (arrayValue.getElementType().getTag() == org.wso2.ballerinalang.compiler.util.TypeTags.BYTE) {
                    byteArray[i] = arrayValue.getBytes();
                } else {
                    throw Utils.throwInvalidParameterError(innerValue, Constants.TypeRecordNames.BYTEA);
                }
            } else if (innerValue instanceof BObject) {                
                objectValue = (BObject) innerValue;
                if (objectValue.getType().getName().
                        equalsIgnoreCase(io.ballerina.stdlib.sql.Constants.READ_BYTE_CHANNEL_STRUCT) &&
                        objectValue.getType().getPackage().toString()
                            .equalsIgnoreCase(IOUtils.getIOPackage().toString())) {
                    try {
                        Channel byteChannel = (Channel) objectValue.getNativeData(IOConstants.BYTE_CHANNEL_NAME);
                        byteArray[i] = toByteArray(byteChannel.getInputStream());
                    } catch (IOException e) {
                        throw new ConversionError("", "byte[]", e.getMessage());
                    }
                } else {
                    throw Utils.throwInvalidParameterError(innerValue,
                            Constants.TypeRecordNames.BYTEA + " Array");
                }
            } else {
                throw Utils.throwInvalidParameterError(innerValue, Constants.TypeRecordNames.BYTEA);
            }            
        }   
        return byteArray;
    }

    @Override
    protected void setBinaryArray(Connection conn, PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, DataError {
        Array array = conn.createArrayOf(Constants.TypeRecordNames.BYTEA, this.getBinaryValueArrayData(value));
        preparedStatement.setArray(index, array);
    }

    @Override
    protected Object[] getCustomArrayData(Object value) throws DataError, SQLException {
        Type type = TypeUtils.getType(value);
        Type elementType = ((ArrayType) type).getElementType();
        int typeTag = elementType.getTag();
        switch (typeTag) {
            case TypeTags.OBJECT_TYPE_TAG:
                return StatementParameterUtils.convertObjectToArray(elementType, value);
            case TypeTags.RECORD_TYPE_TAG:
                return StatementParameterUtils.convertRecordToArray(elementType, value);
            default:
                throw new TypeMismatchError("Array", elementType.getName(),
                        "postgres module specific records/objects");
        }
    }

    @Override
    public int getCustomOutParameterType(BObject typedValue) throws DataError {
        String sqlType = typedValue.getType().getName();
        switch (sqlType) {
            case Constants.OutParameterNames.PGBIT:
                return Types.BIT;
            case Constants.OutParameterNames.XML:
                return Types.SQLXML;
            case Constants.OutParameterNames.BINARY:
                return Types.BINARY;
            case Constants.OutParameterNames.MONEY:
                return Types.DOUBLE;
            case Constants.OutParameterNames.ENUM:
                return Types.VARCHAR;
            case Constants.OutParameterNames.INET:
            case Constants.OutParameterNames.CIDR:
            case Constants.OutParameterNames.MACADDR:
            case Constants.OutParameterNames.MACADDR8:
            case Constants.OutParameterNames.POINT:
            case Constants.OutParameterNames.LINE:
            case Constants.OutParameterNames.LSEG:
            case Constants.OutParameterNames.POLYGON:
            case Constants.OutParameterNames.PATH:
            case Constants.OutParameterNames.CIRCLE:
            case Constants.OutParameterNames.BOX:
            case Constants.OutParameterNames.UUID:
            case Constants.OutParameterNames.TSVECTOR:
            case Constants.OutParameterNames.TSQUERY:
            case Constants.OutParameterNames.JSON:
            case Constants.OutParameterNames.JSONB:
            case Constants.OutParameterNames.JSONPATH:
            case Constants.OutParameterNames.INTERVAL:
            case Constants.OutParameterNames.INT4RANGE:
            case Constants.OutParameterNames.INT8RANGE:
            case Constants.OutParameterNames.NUMRANGE:
            case Constants.OutParameterNames.TSRANGE:
            case Constants.OutParameterNames.TSTZRANGE:
            case Constants.OutParameterNames.DATERANGE:
            case Constants.OutParameterNames.VARBITSTRING:
            case Constants.OutParameterNames.BITSTRING:
            case Constants.OutParameterNames.PGLSN:
            case Constants.OutParameterNames.REGCLASS:
            case Constants.OutParameterNames.REGCONFIG:
            case Constants.OutParameterNames.REGDICTIONARY:
            case Constants.OutParameterNames.REGNAMESPACE:
            case Constants.OutParameterNames.REGOPER:
            case Constants.OutParameterNames.REGOPERATOR:
            case Constants.OutParameterNames.REGPROC:
            case Constants.OutParameterNames.REGPROCEDURE:
            case Constants.OutParameterNames.REGROLE:
            case Constants.OutParameterNames.REGTYPE:
                return Types.OTHER;
            default:
                throw new UnsupportedTypeError(String.format(
                        "ParameterizedQuery consists of a out parameter of unsupported type '%s'.", sqlType));
        }
    }

    @Override
    protected int getCustomSQLType(BObject typedValue) throws DataError {
        String sqlType = typedValue.getType().getName();
        switch (sqlType) {
            case Constants.PGTypeNames.PGBIT:
                return Types.BIT;
            case Constants.PGTypeNames.XML:
                return Types.SQLXML;
            case Constants.PGTypeNames.MONEY:
                return Types.DOUBLE;
            case Constants.PGTypeNames.ENUM:
                return Types.VARCHAR;
            case Constants.PGTypeNames.INET:
            case Constants.PGTypeNames.CIDR:
            case Constants.PGTypeNames.MACADDR:
            case Constants.PGTypeNames.MACADDR8:
            case Constants.PGTypeNames.POINT:
            case Constants.PGTypeNames.LINE:
            case Constants.PGTypeNames.LSEG:
            case Constants.PGTypeNames.POLYGON:
            case Constants.PGTypeNames.PATH:
            case Constants.PGTypeNames.CIRCLE:
            case Constants.PGTypeNames.BOX:
            case Constants.PGTypeNames.UUID:
            case Constants.PGTypeNames.TSVECTOR:
            case Constants.PGTypeNames.TSQUERY:
            case Constants.PGTypeNames.JSON:
            case Constants.PGTypeNames.JSONB:
            case Constants.PGTypeNames.JSON_PATH:
            case Constants.PGTypeNames.INTERVAL:
            case Constants.PGTypeNames.INT4RANGE:
            case Constants.PGTypeNames.INT8RANGE:
            case Constants.PGTypeNames.NUMRANGE:
            case Constants.PGTypeNames.TSRANGE:
            case Constants.PGTypeNames.TSTZRANGE:
            case Constants.PGTypeNames.DATERANGE:
            case Constants.PGTypeNames.VARBITSTRING:
            case Constants.PGTypeNames.BITSTRING:
            case Constants.PGTypeNames.PGLSN:
            case Constants.PGTypeNames.REGCLASS:
            case Constants.PGTypeNames.REGCONFIG:
            case Constants.PGTypeNames.REGDICTIONARY:
            case Constants.PGTypeNames.REGNAMESPACE:
            case Constants.PGTypeNames.REGOPER:
            case Constants.PGTypeNames.REG_OPERATOR:
            case Constants.PGTypeNames.REG_PROC:
            case Constants.PGTypeNames.REG_PROCEDURE:
            case Constants.PGTypeNames.REG_ROLE:
            case Constants.PGTypeNames.REG_TYPE:
            case Constants.PGTypeNames.CUSTOM_TYPES:
                return Types.OTHER;
            case Constants.PGTypeNames.POINT_ARRAY:
            case Constants.PGTypeNames.BIT_STRING_ARRAY:
            case Constants.PGTypeNames.BOX_ARRAY:
            case Constants.PGTypeNames.CIDR_ARRAY:
            case Constants.PGTypeNames.CIRCLE_ARRAY:
            case Constants.PGTypeNames.DATE_RANGE_ARRAY:
            case Constants.PGTypeNames.INET_ARRAY:
            case Constants.PGTypeNames.INTEGER_RANGE_ARRAY:
            case Constants.PGTypeNames.INTERVAL_ARRAY:
            case Constants.PGTypeNames.JSON_ARRAY:
            case Constants.PGTypeNames.JSON_BINARY_ARRAY:
            case Constants.PGTypeNames.JSON_PATH_ARRAY:
            case Constants.PGTypeNames.LINE_ARRAY:
            case Constants.PGTypeNames.LONG_RANGE_ARRAY:
            case Constants.PGTypeNames.LSEG_ARRAY:
            case Constants.PGTypeNames.MACADDR8_ARRAY:
            case Constants.PGTypeNames.MACADDR_ARRAY:
            case Constants.PGTypeNames.MONEY_ARRAY:
            case Constants.PGTypeNames.NUM_RANGE_ARRAY:
            case Constants.PGTypeNames.PATH_ARRAY:
            case Constants.PGTypeNames.PG_BIT_ARRAY:
            case Constants.PGTypeNames.PGLSN_ARRAY:
            case Constants.PGTypeNames.REG_DICTIONARY_ARRAY:
            case Constants.PGTypeNames.POLYGON_ARRAY:
            case Constants.PGTypeNames.REG_CLASS_ARRAY:
            case Constants.PGTypeNames.REG_CONFIG_ARRAY:
            case Constants.PGTypeNames.REG_NAME_SPACE_ARRAY:
            case Constants.PGTypeNames.REG_OPER_ARRAY:
            case Constants.PGTypeNames.REG_OPERATOR_ARRAY:
            case Constants.PGTypeNames.REG_PROC_ARRAY:
            case Constants.PGTypeNames.REG_PROCEDURE_ARRAY:
            case Constants.PGTypeNames.REG_ROLE_ARRAY:
            case Constants.PGTypeNames.REG_TYPE_ARRAY:
            case Constants.PGTypeNames.TIME_STAMP_RANGE_ARRAY:
            case Constants.PGTypeNames.TIME_STAMP_Z_RANGE_ARRAY:
            case Constants.PGTypeNames.TSQUERY_ARRAY:
            case Constants.PGTypeNames.TSVECTOR_ARRAY:
            case Constants.PGTypeNames.UUID_ARRAY:
            case Constants.PGTypeNames.VAR_BIT_STRING_ARRAY:
            case Constants.PGTypeNames.XML_ARRAY:
                return Types.ARRAY;
            default:
                throw new UnsupportedTypeError(String.format(
                        "ParameterizedQuery consists of a out parameter of unsupported type '%s'.", sqlType));
        }
    }

    @Override
    protected void setCustomSqlTypedParam(Connection connection, PreparedStatement preparedStatement,
                    int index, BObject typedValue) throws SQLException, DataError {
        String sqlType = typedValue.getType().getName();
        Object value = typedValue.get(io.ballerina.stdlib.sql.Constants.TypedValueFields.VALUE);
        if (sqlType.contains("Array")) {
            setValueArray(sqlType, connection, preparedStatement, index, value);
        } else {
            setValue(sqlType, preparedStatement, index, value);
        }
    }

    private void setValueArray(String sqlType, Connection connection, PreparedStatement preparedStatement,
                               int index, Object value) throws SQLException, DataError {
        switch (sqlType) {
            case Constants.PGTypeNames.INET_ARRAY:
                StatementParameterUtils.setInetArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.CIDR_ARRAY:
                StatementParameterUtils.setCidrArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.MACADDR_ARRAY:
                StatementParameterUtils.setMacAddrArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.MACADDR8_ARRAY:
                StatementParameterUtils.setMacAddr8Array(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.POINT_ARRAY:
                StatementParameterUtils.setPointArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.LINE_ARRAY:
                StatementParameterUtils.setLineArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.LSEG_ARRAY:
                StatementParameterUtils.setLineSegArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.PATH_ARRAY:
                StatementParameterUtils.setPathArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.POLYGON_ARRAY:
                StatementParameterUtils.setLPolygonArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.CIRCLE_ARRAY:
                StatementParameterUtils.setCircleArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.BOX_ARRAY:
                StatementParameterUtils.setBoxArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.UUID_ARRAY:
                StatementParameterUtils.setUuidArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.TSVECTOR_ARRAY:
                StatementParameterUtils.setTsVectorArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.TSQUERY_ARRAY:
                StatementParameterUtils.setTsQueryArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.JSON_ARRAY:
                StatementParameterUtils.setJsonArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.JSON_BINARY_ARRAY:
                StatementParameterUtils.setJsonBArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.JSON_PATH_ARRAY:
                StatementParameterUtils.setJsonPathArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.INTERVAL_ARRAY:
                StatementParameterUtils.setIntervalArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.INTEGER_RANGE_ARRAY:
                StatementParameterUtils.setIntegerRangeArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.LONG_RANGE_ARRAY:
                StatementParameterUtils.setLongRangeArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.NUM_RANGE_ARRAY:
                StatementParameterUtils.setNumRangeArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.TIME_STAMP_RANGE_ARRAY:
                StatementParameterUtils.setTimeStampRangeArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.TIME_STAMP_Z_RANGE_ARRAY:
                StatementParameterUtils.setTimeStampZRangeArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.DATE_RANGE_ARRAY:
                StatementParameterUtils.setDateRangeArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.PG_BIT_ARRAY:
                StatementParameterUtils.setPGBitArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.VAR_BIT_STRING_ARRAY:
                StatementParameterUtils.setVarBitStringArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.BIT_STRING_ARRAY:
                StatementParameterUtils.setBitStringArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.PGLSN_ARRAY:
                StatementParameterUtils.setPglsnArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.MONEY_ARRAY:
                StatementParameterUtils.setMoneyArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.REG_CLASS_ARRAY:
                StatementParameterUtils.setRegClassArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.REG_CONFIG_ARRAY:
                StatementParameterUtils.setRegConfigArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.REG_DICTIONARY_ARRAY:
                StatementParameterUtils.setRegDictionaryArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.REG_NAME_SPACE_ARRAY:
                StatementParameterUtils.setRegNamespaceArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.REG_OPER_ARRAY:
                StatementParameterUtils.setRegOperArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.REG_OPERATOR_ARRAY:
                StatementParameterUtils.setRegOperatorArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.REG_PROC_ARRAY:
                StatementParameterUtils.setRegProcArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.REG_PROCEDURE_ARRAY:
                StatementParameterUtils.setRegProcedureArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.REG_ROLE_ARRAY:
                StatementParameterUtils.setRegRoleArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.REG_TYPE_ARRAY:
                StatementParameterUtils.setRegTypeArray(connection, preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.XML_ARRAY:
                StatementParameterUtils.setXmlValueArray(connection, preparedStatement, index, value);
                break;
            default:
                throw new UnsupportedTypeError(String.format(
                        "ParameterizedQuery consists of an Array parameter of unsupported type '%s'.", sqlType));
        }
    }

    private void setValue(String sqlType, PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, DataError {
        switch (sqlType) {
            case Constants.PGTypeNames.INET:
                StatementParameterUtils.setInet(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.CIDR:
                StatementParameterUtils.setCidr(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.MACADDR:
                StatementParameterUtils.setMacAddr(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.MACADDR8:
                StatementParameterUtils.setMacAddr8(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.POINT:
                StatementParameterUtils.setPoint(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.LINE:
                StatementParameterUtils.setLine(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.LSEG:
                StatementParameterUtils.setLineSeg(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.PATH:
                StatementParameterUtils.setPath(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.POLYGON:
                StatementParameterUtils.setPolygon(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.CIRCLE:
                StatementParameterUtils.setCircle(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.BOX:
                StatementParameterUtils.setBox(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.UUID:
                StatementParameterUtils.setUuid(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.TSVECTOR:
                StatementParameterUtils.setTsVector(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.TSQUERY:
                StatementParameterUtils.setTsQuery(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.JSON:
                StatementParameterUtils.setJson(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.JSONB:
                StatementParameterUtils.setJsonb(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.JSON_PATH:
                StatementParameterUtils.setJsonPath(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.INTERVAL:
                StatementParameterUtils.setInterval(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.INT4RANGE:
                StatementParameterUtils.setInt4Range(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.INT8RANGE:
                StatementParameterUtils.setInt8Range(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.NUMRANGE:
                StatementParameterUtils.setNumRange(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.TSRANGE:
                StatementParameterUtils.setTsRange(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.TSTZRANGE:
                StatementParameterUtils.setTsTzRange(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.DATERANGE:
                StatementParameterUtils.setDateRange(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.PGBIT:
                StatementParameterUtils.setPGBit(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.VARBITSTRING:
                StatementParameterUtils.setVarBitString(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.BITSTRING:
                StatementParameterUtils.setBitString(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.PGLSN:
                StatementParameterUtils.setPglsn(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.MONEY:
                StatementParameterUtils.setMoney(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.REGCLASS:
                StatementParameterUtils.setRegClass(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.REGCONFIG:
                StatementParameterUtils.setRegConfig(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.REGDICTIONARY:
                StatementParameterUtils.setRegDictionary(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.REGNAMESPACE:
                StatementParameterUtils.setRegNamespace(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.REGOPER:
                StatementParameterUtils.setRegOper(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.REG_OPERATOR:
                StatementParameterUtils.setRegOperator(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.REG_PROC:
                StatementParameterUtils.setRegProc(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.REG_PROCEDURE:
                StatementParameterUtils.setRegProcedure(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.REG_ROLE:
                StatementParameterUtils.setRegRole(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.REG_TYPE:
                StatementParameterUtils.setRegType(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.XML:
                StatementParameterUtils.setXmlValue(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.CUSTOM_TYPES:
                setCustomType(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.ENUM:
                StatementParameterUtils.setEnum(preparedStatement, index, value);
                break;
            default:
                throw new UnsupportedTypeError(String.format(
                        "ParameterizedQuery consists of a parameter of unsupported type '%s'.", sqlType));
        }
    }

    @Override
    protected void setTime(PreparedStatement preparedStatement, String sqlType, int index, Object value)
            throws SQLException, DataError {
        if (value == null) {
            preparedStatement.setTime(index, null);
        } else {
            if (value instanceof BString) {
                preparedStatement.setString(index, value.toString());
            } else if (value instanceof BMap) {
                BMap timeMap = (BMap) value;
                int hour = Math.toIntExact(timeMap.getIntValue(
                        StringUtils.fromString(io.ballerina.stdlib.time.util.Constants.TIME_OF_DAY_RECORD_HOUR)));
                int minute = Math.toIntExact(timeMap.getIntValue(
                        StringUtils.fromString(io.ballerina.stdlib.time.util.Constants.TIME_OF_DAY_RECORD_MINUTE)));
                BDecimal second = BDecimal.valueOf(0);
                if (timeMap.containsKey(StringUtils.fromString(
                        io.ballerina.stdlib.time.util.Constants.TIME_OF_DAY_RECORD_SECOND))) {
                    second = ((BDecimal) timeMap.get(StringUtils.fromString(
                            io.ballerina.stdlib.time.util.Constants.TIME_OF_DAY_RECORD_SECOND)));
                }
                int zoneHours = 0;
                int zoneMinutes = 0;
                BDecimal zoneSeconds = BDecimal.valueOf(0);
                boolean timeZone = false;
                if (timeMap.containsKey(StringUtils.
                        fromString(io.ballerina.stdlib.time.util.Constants.CIVIL_RECORD_UTC_OFFSET))) {
                    timeZone = true;
                    BMap zoneMap = (BMap) timeMap.get(StringUtils.
                            fromString(io.ballerina.stdlib.time.util.Constants.CIVIL_RECORD_UTC_OFFSET));
                    zoneHours = Math.toIntExact(zoneMap.getIntValue(StringUtils.
                            fromString(io.ballerina.stdlib.time.util.Constants.ZONE_OFFSET_RECORD_HOUR)));
                    zoneMinutes = Math.toIntExact(zoneMap.getIntValue(StringUtils.
                            fromString(io.ballerina.stdlib.time.util.Constants.ZONE_OFFSET_RECORD_MINUTE)));
                    if (zoneMap.containsKey(StringUtils.
                            fromString(io.ballerina.stdlib.time.util.Constants.ZONE_OFFSET_RECORD_SECOND))) {
                        zoneSeconds = ((BDecimal) zoneMap.get(StringUtils.
                                fromString(io.ballerina.stdlib.time.util.Constants.ZONE_OFFSET_RECORD_SECOND)));
                    }
                }
                int intSecond = second.decimalValue().setScale(0, RoundingMode.FLOOR).intValue();
                int intNanoSecond = second.decimalValue().subtract(new BigDecimal(intSecond))
                        .multiply(io.ballerina.stdlib.time.util.Constants.ANALOG_GIGA)
                        .setScale(0, RoundingMode.HALF_UP).intValue();
                LocalTime localTime = LocalTime.of(hour, minute, intSecond, intNanoSecond);
                if (timeZone) {
                    int intZoneSecond = zoneSeconds.decimalValue().setScale(0, RoundingMode.HALF_UP)
                            .intValue();
                    OffsetTime offsetTime = OffsetTime.of(localTime,
                            ZoneOffset.ofHoursMinutesSeconds(zoneHours, zoneMinutes, intZoneSecond));
                    Object timeObject = ConverterUtils.convertTimetz(offsetTime);
                    preparedStatement.setObject(index, timeObject);
                } else {
                    preparedStatement.setTime(index, Time.valueOf(localTime));
                }
            } else {
                throw Utils.throwInvalidParameterError(value, sqlType);
            }
        }
    }
    
    @Override
    protected void setReal(PreparedStatement preparedStatement, String sqlType, int index, Object value)
            throws SQLException, DataError {
        if (value == null) {
            preparedStatement.setNull(index, Types.REAL);
        } else if (value instanceof Double || value instanceof Long ||
                value instanceof Float || value instanceof Integer) {
            preparedStatement.setFloat(index, ((Number) value).floatValue());
        } else if (value instanceof BDecimal) {
            preparedStatement.setFloat(index, ((BDecimal) value).decimalValue().floatValue());
        } else {
            throw Utils.throwInvalidParameterError(value, sqlType);
        }
    }

    @Override
    protected void setChar(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setNull(index, Types.CHAR);
        } else {
            preparedStatement.setString(index, value.toString());
        }
    }

    @Override
    protected void setBit(PreparedStatement preparedStatement, String sqlType, int index, Object value)
            throws SQLException, DataError {
        super.setBit(preparedStatement, sqlType, index, value);
    }

    private void setCustomType(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException, DataError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertCustomType(value);
            preparedStatement.setObject(index, object);
        }
    }

    @Override
    protected void setXml(Connection connection, PreparedStatement preparedStatement,
                          int index, BXml value) throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertXml(value);
            preparedStatement.setObject(index, object);
        }
    }
}
