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

package org.ballerinalang.postgresql.parameterprocessor;

import io.ballerina.runtime.api.TypeTags;
import io.ballerina.runtime.api.types.ArrayType;
import io.ballerina.runtime.api.types.Field;
import io.ballerina.runtime.api.types.StructureType;
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.utils.TypeUtils;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BDecimal;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BString;
import org.ballerinalang.postgresql.Constants;
import org.ballerinalang.postgresql.utils.ConvertorUtils;
import org.ballerinalang.sql.exception.ApplicationError;
import org.ballerinalang.sql.parameterprocessor.DefaultStatementParameterProcessor;
import org.ballerinalang.stdlib.io.channels.base.Channel;
import org.ballerinalang.stdlib.io.utils.IOConstants;
import org.ballerinalang.stdlib.io.utils.IOUtils;
import org.ballerinalang.stdlib.time.util.TimeUtils;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Array;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.ZonedDateTime;
import java.util.Iterator;
import java.util.Locale;
import java.util.Map;

import static io.ballerina.runtime.api.utils.StringUtils.fromString;
import static org.ballerinalang.sql.utils.Utils.throwInvalidParameterError;

/**
 * Represent the Process methods for statements.
 *
 * @since 0.5.6
 */
public class PostgresStatementParameterProcessor extends DefaultStatementParameterProcessor {

    private static final Object lock = new Object();
    private static volatile PostgresStatementParameterProcessor instance;

    public static PostgresStatementParameterProcessor getInstance() {
        if (instance == null) {
            synchronized (lock) {
                if (instance == null) {
                    instance = new PostgresStatementParameterProcessor();
                }
            }
        }
        return instance;
    }

    private Object[] getArrayData(Object value) throws ApplicationError {
        Type type = TypeUtils.getType(value);
        if (value == null || type.getTag() != TypeTags.ARRAY_TAG) {
            return new Object[]{null, null};
        }
        Type elementType = ((ArrayType) type).getElementType();
        int typeTag = elementType.getTag();
        Object[] arrayData;
        int arrayLength;
        switch (typeTag) {
            case TypeTags.INT_TAG:
                return getIntArrayData(value);
            case TypeTags.FLOAT_TAG:
                return getFloatArrayData(value);
            case TypeTags.DECIMAL_TAG:
                return getDecimalArrayData(value);
            case TypeTags.STRING_TAG:
                return getStringArrayData(value);
            case TypeTags.BOOLEAN_TAG:
                return getBooleanArrayData(value);
            case TypeTags.ARRAY_TAG:
                return getNestedArrayData(value);
            default:
                return getCustomArrayData(value);
        }
    }

    private Object[] getStructData(Connection conn, Object value) throws SQLException, ApplicationError {
        Type type = TypeUtils.getType(value);
        if (value == null || (type.getTag() != TypeTags.OBJECT_TYPE_TAG
                && type.getTag() != TypeTags.RECORD_TYPE_TAG)) {
            return new Object[]{null, null};
        }
        String structuredSQLType = type.getName().toUpperCase(Locale.getDefault());
        Map<String, Field> structFields = ((StructureType) type)
                .getFields();
        int fieldCount = structFields.size();
        Object[] structData = new Object[fieldCount];
        Iterator<Field> fieldIterator = structFields.values().iterator();
        for (int i = 0; i < fieldCount; ++i) {
            Field field = fieldIterator.next();
            Object bValue = ((BMap) value).get(fromString(field.getFieldName()));
            int typeTag = field.getFieldType().getTag();
            switch (typeTag) {
                case TypeTags.INT_TAG:
                case TypeTags.FLOAT_TAG:
                case TypeTags.STRING_TAG:
                case TypeTags.BOOLEAN_TAG:
                case TypeTags.DECIMAL_TAG:
                    structData[i] = bValue;
                    break;
                case TypeTags.ARRAY_TAG:
                    getArrayStructData(field, structData, structuredSQLType, i, bValue);
                    break;
                case TypeTags.RECORD_TYPE_TAG:
                    getRecordStructData(conn, structData, i, bValue);
                    break;
                default:
                    getCustomStructData(conn, value);
            }
        }
        return new Object[]{structData, structuredSQLType};
    }

    private void setBinaryAndBlob(PreparedStatement preparedStatement, String sqlType, int index, Object value)
            throws SQLException, ApplicationError, IOException {
        if (value == null) {
            preparedStatement.setBytes(index, null);
        } else if (value instanceof BArray) {
            BArray arrayValue = (BArray) value;
            if (arrayValue.getElementType().getTag() == org.wso2.ballerinalang.compiler.util.TypeTags.BYTE) {
                preparedStatement.setBytes(index, arrayValue.getBytes());
            } else {
                throw throwInvalidParameterError(value, sqlType);
            }
        } else if (value instanceof BObject) {
            BObject objectValue = (BObject) value;
            if (objectValue.getType().getName()
                   .equalsIgnoreCase(org.ballerinalang.sql.Constants.READ_BYTE_CHANNEL_STRUCT) &&
                    objectValue.getType().getPackage().toString()
                        .equalsIgnoreCase(IOUtils.getIOPackage().toString())) {
                Channel byteChannel = (Channel) objectValue.getNativeData(IOConstants.BYTE_CHANNEL_NAME);
                preparedStatement.setBinaryStream(index, byteChannel.getInputStream());
            } else {
                throw throwInvalidParameterError(value, sqlType);
            }
        } else {
            throw throwInvalidParameterError(value, sqlType);
        }
    }

    private void setDateTimeAndTimestamp(PreparedStatement preparedStatement, String sqlType, int index, Object value)
            throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setTimestamp(index, null);
        } else {
            Timestamp timestamp;
            if (value instanceof BString) {
                timestamp = Timestamp.valueOf(value.toString());
            } else if (value instanceof Long) {
                timestamp = new Timestamp((Long) value);
            } else if (value instanceof BMap) {
                BMap<BString, Object> dateTimeStruct = (BMap<BString, Object>) value;
                if (dateTimeStruct.getType().getName()
                        .equalsIgnoreCase(org.ballerinalang.stdlib.time.util.Constants.STRUCT_TYPE_TIME)) {
                    ZonedDateTime zonedDateTime = TimeUtils.getZonedDateTime(dateTimeStruct);
                    timestamp = new Timestamp(zonedDateTime.toInstant().toEpochMilli());
                } else {
                    throw throwInvalidParameterError(value, sqlType);
                }
            } else {
                throw throwInvalidParameterError(value, sqlType);
            }
            preparedStatement.setTimestamp(index, timestamp);
        }
    }

    @Override
    public int getCustomOutParameterType(BObject typedValue) throws ApplicationError {
        String sqlType = typedValue.getType().getName();
        switch (sqlType) {
            case Constants.PGTypeNames.INET:
            case Constants.PGTypeNames.CIDR:
            case Constants.PGTypeNames.MACADDR:
            case Constants.PGTypeNames.MACADDR8:
            case Constants.PGTypeNames.POINT:
            case Constants.PGTypeNames.LINE:
            case Constants.PGTypeNames.LSEG:
            case Constants.PGTypeNames.CIRCLE:
            case Constants.PGTypeNames.BOX:
            case Constants.PGTypeNames.UUID:
            case Constants.PGTypeNames.TSVECTOR:
            case Constants.PGTypeNames.TSQUERY:
            case Constants.PGTypeNames.JSON:
            case Constants.PGTypeNames.JSONB:
            case Constants.PGTypeNames.JSONPATH:
            case Constants.PGTypeNames.INTERVAL:
            case Constants.PGTypeNames.INT4RANGE:
            case Constants.PGTypeNames.INT8RANGE:
            case Constants.PGTypeNames.NUMRANGE:
            case Constants.PGTypeNames.TSRANGE:
            case Constants.PGTypeNames.TSTZRANGE:
            case Constants.PGTypeNames.DATERANGE:
            case Constants.PGTypeNames.PGBIT:
            case Constants.PGTypeNames.VARBITSTRING:
            case Constants.PGTypeNames.BITSTRING:
            case Constants.PGTypeNames.PGLSN:
            case Constants.PGTypeNames.MONEY:
            case Constants.PGTypeNames.REGCLASS:
            case Constants.PGTypeNames.REGCONFIG:
            case Constants.PGTypeNames.REGDICTIONARY:
            case Constants.PGTypeNames.REGNAMESPACE:
            case Constants.PGTypeNames.REGOPER:
            case Constants.PGTypeNames.REGOPERATOR:
            case Constants.PGTypeNames.REGPROC:
            case Constants.PGTypeNames.REGPROCEDURE:
            case Constants.PGTypeNames.REGROLE:
            case Constants.PGTypeNames.REGTYPE:
            case Constants.PGTypeNames.XML:
                return Types.OTHER;
            default:
                throw new ApplicationError("Unsupported OutParameter type: " + sqlType);
        }
    }

    @Override
    protected int getCustomSQLType(BObject typedValue) throws ApplicationError {
        String sqlType = typedValue.getType().getName();
        switch (sqlType) {
            case Constants.PGTypeNames.PGBIT:
                return Types.BIT;
            case Constants.PGTypeNames.INET:
            case Constants.PGTypeNames.CIDR:
            case Constants.PGTypeNames.MACADDR:
            case Constants.PGTypeNames.MACADDR8:
            case Constants.PGTypeNames.POINT:
            case Constants.PGTypeNames.LINE:
            case Constants.PGTypeNames.LSEG:
            case Constants.PGTypeNames.CIRCLE:
            case Constants.PGTypeNames.BOX:
            case Constants.PGTypeNames.UUID:
            case Constants.PGTypeNames.TSVECTOR:
            case Constants.PGTypeNames.TSQUERY:
            case Constants.PGTypeNames.JSON:
            case Constants.PGTypeNames.JSONB:
            case Constants.PGTypeNames.JSONPATH:
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
            case Constants.PGTypeNames.MONEY:
            case Constants.PGTypeNames.REGCLASS:
            case Constants.PGTypeNames.REGCONFIG:
            case Constants.PGTypeNames.REGDICTIONARY:
            case Constants.PGTypeNames.REGNAMESPACE:
            case Constants.PGTypeNames.REGOPER:
            case Constants.PGTypeNames.REGOPERATOR:
            case Constants.PGTypeNames.REGPROC:
            case Constants.PGTypeNames.REGPROCEDURE:
            case Constants.PGTypeNames.REGROLE:
            case Constants.PGTypeNames.REGTYPE:
            case Constants.PGTypeNames.XML:
                return Types.OTHER;
            default:
                throw new ApplicationError("Unsupported OutParameter type: " + sqlType);
        }
    }

    @Override
    protected void setCustomSqlTypedParam(Connection connection, PreparedStatement preparedStatement,
                                          int index, BObject typedValue)
            throws SQLException, ApplicationError, IOException {
        String sqlType = typedValue.getType().getName();
        Object value = typedValue.get(org.ballerinalang.sql.Constants.TypedValueFields.VALUE);
        switch (sqlType) {
            case Constants.PGTypeNames.INET:
                setInet(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.CIDR:
                setCidr(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.MACADDR:
                setMacaddr(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.MACADDR8:
                setMaacadr8(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.POINT:
                setPoint(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.LINE:
                setLine(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.LSEG:
                setLseg(preparedStatement, index, value);
                break;
            // case Constants.PGTypeNames.PATH:
            //     setPath(preparedStatement, index, value);
            //     break;
            // case Constants.PGTypeNames.POLYGON:
            //     setPolygon(preparedStatement, index, value);
            //     break;
            case Constants.PGTypeNames.CIRCLE:
                setCircle(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.BOX:
                setBox(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.UUID:
                setUuid(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.TSVECTOR:
                setTsvector(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.TSQUERY:
                setTsquery(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.JSON:
                setJson(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.JSONB:
                setJsonb(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.JSONPATH:
                setJsonpath(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.INTERVAL:
                setInterval(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.INT4RANGE:
                setInt4Range(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.INT8RANGE:
                setInt8Range(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.NUMRANGE:
                setNumRange(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.TSRANGE:
                setTsRange(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.TSTZRANGE:
                setTstzRange(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.DATERANGE:
                setDateRange(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.PGBIT:
                setPGBit(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.VARBITSTRING:
                setVarBitString(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.BITSTRING:
                setBitString(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.PGLSN:
                setPglsn(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.MONEY:
                setMoney(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.REGCLASS:
                setRegclass(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.REGCONFIG:
                setRegconfig(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.REGDICTIONARY:
                setRegdictionary(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.REGNAMESPACE:
                setRegnamespace(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.REGOPER:
                setRegoper(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.REGOPERATOR:
                setRegoperator(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.REGPROC:
                setRegproc(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.REGPROCEDURE:
                setRegprocedure(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.REGROLE:
                setRegrole(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.REGTYPE:
                setRegtype(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.XML:
                setXml(connection, preparedStatement, index, value);
                break;
            default:
                throw new ApplicationError("Unsupported SQL type: " + sqlType);
        }
    }

    private void setInet(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertInet(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setCidr(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertCidr(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setMacaddr(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertMac(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setMaacadr8(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertMac8(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setPoint(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertPoint(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setLine(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertLine(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setLseg(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertLseg(value);
            preparedStatement.setObject(index, object);
        }
    }

    // private void setPath(PreparedStatement preparedStatement, int index, Object value)
    //         throws SQLException {
    //     if (value == null) {
    //         preparedStatement.setObject(index, null);
    //     } else {
    //         Object object = ConvertorUtils.convertPath(value);
    //         preparedStatement.setObject(index, object);
    //     }
    // }

    // private void setPolygon(PreparedStatement preparedStatement, int index, Object value)
    //         throws SQLException {
    //     if (value == null) {
    //         preparedStatement.setObject(index, null);
    //     } else {
    //         Object object = ConvertorUtils.convertPolygon(value);
    //         preparedStatement.setObject(index, object);
    //     }
    // }

    private void setCircle(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertCircle(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setBox(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertBox(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setUuid(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertUuid(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setTsvector(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertTsVector(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setTsquery(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertTsQuery(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setJson(PreparedStatement preparedStatement, int index, Object value)
    throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertJson(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setJsonb(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertJsonb(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setJsonpath(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertJsonPath(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setInterval(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertInterval(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setInt4Range(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertInt4Range(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setInt8Range(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertInt8Range(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setNumRange(PreparedStatement preparedStatement, int index, Object value)
    throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertNumRange(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setTsRange(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertTsRange(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setTstzRange(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertTstzRange(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setDateRange(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertDateRange(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setPGBit(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertBit(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setVarBitString(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertVarbit(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setBitString(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertBitn(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setPglsn(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertPglsn(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setMoney(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertMoney(value);
            preparedStatement.setObject(index, object);
        }
    }  
    
    private void setRegclass(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertRegclass(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setRegconfig(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertRegconfig(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setRegdictionary(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertRegdictionary(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setRegnamespace(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertRegnamespace(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setRegoper(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertRegoper(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setRegoperator(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertRegoperator(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setRegproc(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertRegproc(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setRegprocedure(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertRegprocedure(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setRegrole(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertRegrole(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setRegtype(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertRegtype(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setXml(Connection connection, PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertXml(connection, value);
            preparedStatement.setObject(index, object);
        }
    }

    @Override
    protected Object[] getCustomArrayData(Object value) throws ApplicationError {
        throw throwInvalidParameterError(value, org.ballerinalang.sql.Constants.SqlTypes.ARRAY);
    }

    @Override
    protected Object[] getCustomStructData(Connection conn, Object value)
            throws SQLException, ApplicationError {
        Type type = TypeUtils.getType(value);
        String structuredSQLType = type.getName().toUpperCase(Locale.getDefault());
        throw new ApplicationError("unsupported data type of " + structuredSQLType
                + " specified for struct parameter");
    }

    @Override
    protected void setBit(PreparedStatement preparedStatement, String sqlType, int index, Object value)
            throws SQLException, ApplicationError {
        super.setBit(preparedStatement, sqlType, index, value);
    }

    @Override
    protected void setBinary(PreparedStatement preparedStatement, String sqlType, int index, Object value)
            throws SQLException, ApplicationError, IOException {
        setBinaryAndBlob(preparedStatement, sqlType, index, value);
    }

    @Override
    protected void setArray(Connection conn, PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        Object[] arrayData = getArrayData(value);
        if (arrayData[0] != null) {
            Array array = conn.createArrayOf((String) arrayData[1], (Object[]) arrayData[0]);
            preparedStatement.setArray(index, array);
        } else {
            preparedStatement.setArray(index, null);
        }
    }

    @Override
    protected void setDateTime(PreparedStatement preparedStatement, String sqlType, int index, Object value)
            throws SQLException, ApplicationError {
        setDateTimeAndTimestamp(preparedStatement, sqlType, index, value);
    }

    @Override
    protected void setTimestamp(PreparedStatement preparedStatement, String sqlType, int index, Object value)
            throws SQLException, ApplicationError {
        setDateTimeAndTimestamp(preparedStatement, sqlType, index, value);
    }

    @Override
    protected void setDate(PreparedStatement preparedStatement, String sqlType, int index, Object value)
            throws SQLException, ApplicationError {
        Date date;
        if (value == null) {
            preparedStatement.setDate(index, null);
        } else {
            if (value instanceof BString) {
                date = Date.valueOf(value.toString());
            } else if (value instanceof Long) {
                date = new Date((Long) value);
            } else if (value instanceof BMap) {
                BMap<BString, Object> dateTimeStruct = (BMap<BString, Object>) value;
                if (dateTimeStruct.getType().getName()
                        .equalsIgnoreCase(org.ballerinalang.stdlib.time.util.Constants.STRUCT_TYPE_TIME)) {
                    ZonedDateTime zonedDateTime = TimeUtils.getZonedDateTime(dateTimeStruct);
                    date = new Date(zonedDateTime.toInstant().toEpochMilli());
                } else {
                    throw throwInvalidParameterError(value, sqlType);
                }
            } else {
                throw throwInvalidParameterError(value, sqlType);
            }
            preparedStatement.setDate(index, date);
        }
    }

    @Override
    protected void setTime(PreparedStatement preparedStatement, String sqlType, int index, Object value)
            throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setTime(index, null);
        } else {
            Time time;
            if (value instanceof BString) {
                time = Time.valueOf(value.toString());
            } else if (value instanceof Long) {
                time = new Time((Long) value);
            } else if (value instanceof BMap) {
                BMap<BString, Object> dateTimeStruct = (BMap<BString, Object>) value;
                if (dateTimeStruct.getType().getName()
                        .equalsIgnoreCase(org.ballerinalang.stdlib.time.util.Constants.STRUCT_TYPE_TIME)) {
                    ZonedDateTime zonedDateTime = TimeUtils.getZonedDateTime(dateTimeStruct);
                    time = new Time(zonedDateTime.toInstant().toEpochMilli());
                } else {
                    throw throwInvalidParameterError(value, sqlType);
                }
            } else {
                throw throwInvalidParameterError(value, sqlType);
            }
            preparedStatement.setTime(index, time);
        }
    }

    @Override
    protected Object[] getIntArrayData(Object value) throws ApplicationError {
        int arrayLength = ((BArray) value).size();
        Object[] arrayData = new Long[arrayLength];
        for (int i = 0; i < arrayLength; i++) {
            arrayData[i] = ((BArray) value).getInt(i);
        }
        return new Object[]{arrayData, "BIGINT"};
    }

    @Override
    protected Object[] getFloatArrayData(Object value) throws ApplicationError {
        int arrayLength = ((BArray) value).size();
        Object[] arrayData = new Double[arrayLength];
        for (int i = 0; i < arrayLength; i++) {
            arrayData[i] = ((BArray) value).getFloat(i);
        }
        return new Object[]{arrayData, "DOUBLE"};
    }

    @Override
    protected Object[] getDecimalArrayData(Object value) throws ApplicationError {
        int arrayLength = ((BArray) value).size();
        Object[] arrayData = new BigDecimal[arrayLength];
        for (int i = 0; i < arrayLength; i++) {
            arrayData[i] = ((BDecimal) ((BArray) value).getRefValue(i)).value();
        }
        return new Object[]{arrayData, "DECIMAL"};
    }

    @Override
    protected Object[] getStringArrayData(Object value) throws ApplicationError {
        int arrayLength = ((BArray) value).size();
        Object[] arrayData = new String[arrayLength];
        for (int i = 0; i < arrayLength; i++) {
            arrayData[i] = ((BArray) value).getBString(i).getValue();
        }
        return new Object[]{arrayData, "VARCHAR"};
    }

    @Override
    protected Object[] getBooleanArrayData(Object value) throws ApplicationError {
        int arrayLength = ((BArray) value).size();
        Object[] arrayData = new Boolean[arrayLength];
        for (int i = 0; i < arrayLength; i++) {
            arrayData[i] = ((BArray) value).getBoolean(i);
        }
        return new Object[]{arrayData, "BOOLEAN"};
    }

    @Override
    protected Object[] getNestedArrayData(Object value) throws ApplicationError {
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
            return new Object[]{arrayData, "BINARY"};
        } else {
            throw throwInvalidParameterError(value, org.ballerinalang.sql.Constants.SqlTypes.ARRAY);
        }
    }

    @Override
    protected void getRecordStructData(Connection conn, Object[] structData, int i, Object bValue)
            throws SQLException, ApplicationError {
        Object structValue = bValue;
        Object[] internalStructData = getStructData(conn, structValue);
        Object[] dataArray = (Object[]) internalStructData[0];
        String internalStructType = (String) internalStructData[1];
        structValue = conn.createStruct(internalStructType, dataArray);
        structData[i] = structValue;
    }

    @Override
    protected void getArrayStructData(Field field, Object[] structData, String structuredSQLType, int i, Object bValue)
            throws SQLException, ApplicationError {
        Type elementType = ((ArrayType) field
                .getFieldType()).getElementType();
        if (elementType.getTag() == TypeTags.BYTE_TAG) {
            structData[i] = ((BArray) bValue).getBytes();
        } else {
            throw new ApplicationError("unsupported data type of " + structuredSQLType
                    + " specified for struct parameter");
        }
    }

}
