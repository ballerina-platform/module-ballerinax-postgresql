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
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.utils.TypeUtils;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BDecimal;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.api.values.BXml;
import org.ballerinalang.postgresql.Constants;
import org.ballerinalang.postgresql.utils.ConverterUtils;
import org.ballerinalang.sql.exception.ApplicationError;
import org.ballerinalang.sql.parameterprocessor.DefaultStatementParameterProcessor;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Types;
import java.time.LocalTime;
import java.time.OffsetTime;
import java.time.ZoneOffset;

import static org.ballerinalang.sql.utils.Utils.throwInvalidParameterError;

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
            return new Object[]{arrayData, "BYTEA"};
        } else {
            throw throwInvalidParameterError(value, org.ballerinalang.sql.Constants.SqlTypes.ARRAY);
        }
    }

    @Override
    public int getCustomOutParameterType(BObject typedValue) throws ApplicationError { 
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
                throw new ApplicationError("Unsupported OutParameter type: " + sqlType);
        }
    }

    @Override
    protected int getCustomSQLType(BObject typedValue) throws ApplicationError {
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
            case Constants.PGTypeNames.CUSTOM_TYPES:
                return Types.OTHER;
            default:
                throw new ApplicationError("Unsupported OutParameter type: " + sqlType);
        }
    }

    @Override
    protected void setCustomSqlTypedParam(Connection connection, PreparedStatement preparedStatement,
                    int index, BObject typedValue) throws SQLException, ApplicationError, IOException {
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
            case Constants.PGTypeNames.PATH:
                setPath(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.POLYGON:
                setPolygon(preparedStatement, index, value);
                break;
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
                setXmlValue(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.CUSTOM_TYPES:
                setCustomType(preparedStatement, index, value);
                break;
            case Constants.PGTypeNames.ENUM:
                setEnum(preparedStatement, index, value);
                break;
            default:
                throw new ApplicationError("Unsupported SQL type: " + sqlType);
        }
    }

    @Override
    protected void setTime(PreparedStatement preparedStatement, String sqlType, int index, Object value)
            throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setTime(index, null);
        } else {
            if (value instanceof BString) {
                preparedStatement.setString(index, value.toString());
            } else if (value instanceof BMap) {
                BMap timeMap = (BMap) value;
                int hour = Math.toIntExact(timeMap.getIntValue(StringUtils.
                        fromString(org.ballerinalang.stdlib.time.util.Constants.TIME_OF_DAY_RECORD_HOUR)));
                int minute = Math.toIntExact(timeMap.getIntValue(StringUtils.
                        fromString(org.ballerinalang.stdlib.time.util.Constants.TIME_OF_DAY_RECORD_MINUTE)));
                BDecimal second = BDecimal.valueOf(0);
                if (timeMap.containsKey(StringUtils
                        .fromString(org.ballerinalang.stdlib.time.util.Constants.TIME_OF_DAY_RECORD_SECOND))) {
                    second = ((BDecimal) timeMap.get(StringUtils
                            .fromString(org.ballerinalang.stdlib.time.util.Constants.TIME_OF_DAY_RECORD_SECOND)));
                }
                int zoneHours = 0;
                int zoneMinutes = 0;
                BDecimal zoneSeconds = BDecimal.valueOf(0);
                boolean timeZone = false;
                if (timeMap.containsKey(StringUtils.
                        fromString(org.ballerinalang.stdlib.time.util.Constants.CIVIL_RECORD_UTC_OFFSET))) {
                    timeZone = true;
                    BMap zoneMap = (BMap) timeMap.get(StringUtils.
                            fromString(org.ballerinalang.stdlib.time.util.Constants.CIVIL_RECORD_UTC_OFFSET));
                    zoneHours = Math.toIntExact(zoneMap.getIntValue(StringUtils.
                            fromString(org.ballerinalang.stdlib.time.util.Constants.ZONE_OFFSET_RECORD_HOUR)));
                    zoneMinutes = Math.toIntExact(zoneMap.getIntValue(StringUtils.
                            fromString(org.ballerinalang.stdlib.time.util.Constants.ZONE_OFFSET_RECORD_MINUTE)));
                    if (zoneMap.containsKey(StringUtils.
                            fromString(org.ballerinalang.stdlib.time.util.Constants.ZONE_OFFSET_RECORD_SECOND))) {
                        zoneSeconds = ((BDecimal) zoneMap.get(StringUtils.
                                fromString(org.ballerinalang.stdlib.time.util.Constants.ZONE_OFFSET_RECORD_SECOND)));
                    }
                }
                int intSecond = second.decimalValue().setScale(0, RoundingMode.FLOOR).intValue();
                int intNanoSecond = second.decimalValue().subtract(new BigDecimal(intSecond))
                        .multiply(org.ballerinalang.stdlib.time.util.Constants.ANALOG_GIGA)
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
                throw throwInvalidParameterError(value, sqlType);
            }
        }
    }
    
    @Override
    protected void setReal(PreparedStatement preparedStatement, String sqlType, int index, Object value)
            throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setNull(index, Types.REAL);
        } else if (value instanceof Double || value instanceof Long ||
                value instanceof Float || value instanceof Integer) {
            preparedStatement.setFloat(index, ((Number) value).floatValue());
        } else if (value instanceof BDecimal) {
            preparedStatement.setFloat(index, ((BDecimal) value).decimalValue().floatValue());
        } else {
            throw throwInvalidParameterError(value, sqlType);
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

    private void setInet(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertInet(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setCidr(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertCidr(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setMacaddr(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertMac(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setMaacadr8(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertMac8(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setPoint(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertPoint(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setLine(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertLine(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setLseg(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertLseg(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setPath(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertPath(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setPolygon(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertPolygon(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setCircle(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertCircle(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setBox(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertBox(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setUuid(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertUuid(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setTsvector(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertTsVector(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setTsquery(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertTsQuery(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setJson(PreparedStatement preparedStatement, int index, Object value)
    throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertJson(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setJsonb(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertJsonb(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setJsonpath(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertJsonPath(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setInterval(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertInterval(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setInt4Range(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertInt4Range(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setInt8Range(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertInt8Range(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setNumRange(PreparedStatement preparedStatement, int index, Object value)
    throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertNumRange(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setTsRange(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertTsRange(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setTstzRange(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertTstzRange(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setDateRange(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertDateRange(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setPGBit(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertBit(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setVarBitString(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertVarbit(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setBitString(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertBitn(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setPglsn(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertPglsn(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setMoney(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertMoney(value);
            preparedStatement.setObject(index, object);
        }
    }  
    
    private void setRegclass(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertRegclass(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setRegconfig(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertRegconfig(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setRegdictionary(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertRegdictionary(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setRegnamespace(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertRegnamespace(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setRegoper(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertRegoper(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setRegoperator(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertRegoperator(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setRegproc(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertRegproc(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setRegprocedure(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertRegprocedure(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setRegrole(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertRegrole(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setRegtype(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertRegtype(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setXmlValue(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertXml(value);
            preparedStatement.setObject(index, object);
        }
    }

    @Override
    protected void setBit(PreparedStatement preparedStatement, String sqlType, int index, Object value)
            throws SQLException, ApplicationError {
        super.setBit(preparedStatement, sqlType, index, value);
    }

    private void setCustomType(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertCustomType(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setEnum(PreparedStatement preparedStatement, int index, Object value)
        throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertEnum(value);
            preparedStatement.setObject(index, object);
        }
    }

    @Override
    protected void setXml(PreparedStatement preparedStatement, int index, BXml value) throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertXml(value);
            preparedStatement.setObject(index, object);
        }
    }
}
