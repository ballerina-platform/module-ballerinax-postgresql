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

import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BDecimal;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.stdlib.postgresql.Constants;
import io.ballerina.stdlib.postgresql.utils.ConverterUtils;
import org.ballerinalang.sql.exception.ApplicationError;
import org.ballerinalang.stdlib.time.util.TimeValueHandler;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Array;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Time;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.OffsetDateTime;
import java.time.OffsetTime;
import java.time.ZoneOffset;
import java.time.ZonedDateTime;

/**
 * This class includes utility functions for parameter processor.
 */
public class StatementParameterUtils {
    
    private StatementParameterUtils() {}
    
    protected static void getTimeFromString(Object[] arrayData, Object innerValue, int i) throws ApplicationError {
        try {
            arrayData[i] = Time.valueOf(innerValue.toString());
        } catch (java.lang.NumberFormatException ex) {
            throw new ApplicationError("Unsupported String Value " + innerValue.toString() + " for Time Array");
        }
    }
    
    protected static boolean getTimeFromMap(Object[] arrayData, Object innerValue, int i) {
        BMap timeMap = (BMap) innerValue;
        boolean containsTimeZone = false;
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
            containsTimeZone = true;
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
            arrayData[i] = offsetTime;
        } else {
            arrayData[i] = Time.valueOf(localTime);
        }
        return containsTimeZone;
    }

    public static Object[] getDateTimeAndTimestampValueArrayData(Object value) throws ApplicationError {
        BArray array = (BArray) value;
        int arrayLength = array.size();
        Object innerValue;
        boolean containsTimeZone = false;
        Object[] arrayData = new Object[arrayLength];
        for (int i = 0; i < arrayLength; i++) {
            innerValue = array.get(i);
            if (innerValue == null) {
                arrayData[i] = null;
            } else if (innerValue instanceof BString) {
                getDateTimeAndTimestampValueFromString(arrayData, innerValue, i);
            } else if (innerValue instanceof BArray) {
                getDateTimeAndTimestampValueFromArray(arrayData, innerValue, i);
            } else if (innerValue instanceof BMap) {
                containsTimeZone = getDateTimeAndTimestampValueFromMap(arrayData, innerValue, i);
            } else {
                throw org.ballerinalang.sql.utils.Utils.throwInvalidParameterError(value, "TIMESTAMP ARRAY");
            }
        }
        if (containsTimeZone) {
            return new Object[]{arrayData, Constants.ArrayTypes.TIMESTAMPTZ};
        } else {
            return new Object[]{arrayData, Constants.ArrayTypes.TIMESTAMP};
        }
    }
    
    protected static void getDateTimeAndTimestampValueFromString(Object[] arrayData, Object innerValue, int i) 
            throws ApplicationError {
        try {
            java.time.format.DateTimeFormatter formatter =
                    java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            arrayData[i] = LocalDateTime.parse(innerValue.toString(), formatter);
        } catch (java.time.format.DateTimeParseException ex) {
            throw new ApplicationError("Unsupported String Value " + innerValue.toString() + " for DateTime Array");
        }
    }
    
    protected static void getDateTimeAndTimestampValueFromArray(Object[] arrayData, Object innerValue, int i) {
        //this is mapped to time:Utc
        BArray dateTimeStruct = (BArray) innerValue;
        ZonedDateTime zonedDt = TimeValueHandler.createZonedDateTimeFromUtc(dateTimeStruct);
        Timestamp timestamp = new Timestamp(zonedDt.toInstant().toEpochMilli());
        arrayData[i] = timestamp;
    }
    
    private static boolean getDateTimeAndTimestampValueFromMap(Object[] arrayData, Object innerValue, int i) {
        //this is mapped to time:Civil
        BMap dateMap = (BMap) innerValue;
        boolean containsTimeZone = false;
        int year = Math.toIntExact(dateMap.getIntValue(StringUtils
                .fromString(org.ballerinalang.stdlib.time.util.Constants.DATE_RECORD_YEAR)));
        int month = Math.toIntExact(dateMap.getIntValue(StringUtils
                .fromString(org.ballerinalang.stdlib.time.util.Constants.DATE_RECORD_MONTH)));
        int day = Math.toIntExact(dateMap.getIntValue(StringUtils
                .fromString(org.ballerinalang.stdlib.time.util.Constants.DATE_RECORD_DAY)));
        int hour = Math.toIntExact(dateMap.getIntValue(StringUtils
                .fromString(org.ballerinalang.stdlib.time.util.Constants.TIME_OF_DAY_RECORD_HOUR)));
        int minute = Math.toIntExact(dateMap.getIntValue(StringUtils.
                fromString(org.ballerinalang.stdlib.time.util.Constants.TIME_OF_DAY_RECORD_MINUTE)));
        BDecimal second = BDecimal.valueOf(0);
        if (dateMap.containsKey(StringUtils
                .fromString(org.ballerinalang.stdlib.time.util.Constants.TIME_OF_DAY_RECORD_SECOND))) {
            second = ((BDecimal) dateMap.get(StringUtils.
                    fromString(org.ballerinalang.stdlib.time.util.Constants.TIME_OF_DAY_RECORD_SECOND)));
        }
        int zoneHours = 0;
        int zoneMinutes = 0;
        BDecimal zoneSeconds = BDecimal.valueOf(0);
        boolean timeZone = false;
        if (dateMap.containsKey(StringUtils.
                fromString(org.ballerinalang.stdlib.time.util.Constants.CIVIL_RECORD_UTC_OFFSET))) {
            timeZone = true;
            containsTimeZone = true;
            BMap zoneMap = (BMap) dateMap.get(StringUtils.
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
        LocalDateTime localDateTime = LocalDateTime
                .of(year, month, day, hour, minute, intSecond, intNanoSecond);
        if (timeZone) {
            int intZoneSecond = zoneSeconds.decimalValue().setScale(0, RoundingMode.HALF_UP)
                    .intValue();
            OffsetDateTime offsetDateTime = OffsetDateTime.of(localDateTime,
                    ZoneOffset.ofHoursMinutesSeconds(zoneHours, zoneMinutes, intZoneSecond));
            arrayData[i] =  offsetDateTime;
        } else {
            arrayData[i] = Timestamp.valueOf(localDateTime);
        }
        return containsTimeZone;
    }
    
    public static Object[] convertObjectToArray(Type elementType, Object value) throws ApplicationError {
        switch (elementType.getName()) {
            case Constants.PGTypeNames.POINT:
                return ConverterUtils.convertPointArray(value);
            case Constants.PGTypeNames.LINE:
                return ConverterUtils.convertLineArray(value);
            case Constants.PGTypeNames.LSEG:
                return ConverterUtils.convertLineSegArray(value);
            case Constants.PGTypeNames.BOX:
                return ConverterUtils.convertBoxArray(value);
            case Constants.PGTypeNames.PATH:
                return ConverterUtils.convertPathArray(value);
            case Constants.PGTypeNames.POLYGON:
                return ConverterUtils.convertPolygonArray(value);
            case Constants.PGTypeNames.CIRCLE:
                return ConverterUtils.convertCircleArray(value);
            case Constants.PGTypeNames.INTERVAL:
                return ConverterUtils.convertIntervalArray(value);
            case Constants.PGTypeNames.INT4RANGE:
                return ConverterUtils.convertInt4RangeArray(value);
            case Constants.PGTypeNames.INT8RANGE:
                return ConverterUtils.convertInt8RangeArray(value);
            case Constants.PGTypeNames.NUMRANGE:
                return ConverterUtils.convertNumRangeArray(value);
            case Constants.PGTypeNames.TSTZRANGE:
                return ConverterUtils.convertTsTzRangeArray(value);
            case Constants.PGTypeNames.TSRANGE:
                return ConverterUtils.convertTsRangeArray(value);
            case Constants.PGTypeNames.DATERANGE:
                return ConverterUtils.convertDateRangeArray(value);
            case Constants.PGTypeNames.INET:
                return ConverterUtils.convertInetArray(value);
            case Constants.PGTypeNames.CIDR:
                return ConverterUtils.convertCidrArray(value);
            case Constants.PGTypeNames.MACADDR:
                return ConverterUtils.convertMacAddrArray(value);
            case Constants.PGTypeNames.MACADDR8:
                return ConverterUtils.convertMacAddr8Array(value);
            case Constants.PGTypeNames.UUID:
                return ConverterUtils.convertUuidArray(value);
            case Constants.PGTypeNames.TSVECTOR:
                return ConverterUtils.convertTsVectotArray(value);
            case Constants.PGTypeNames.TSQUERY:
                return ConverterUtils.convertTsQueryArray(value);
            case Constants.PGTypeNames.BITSTRING:
                return ConverterUtils.convertBitStringArray(value);
            case Constants.PGTypeNames.PGBIT:
                return ConverterUtils.convertBitArray(value);
            case Constants.PGTypeNames.VARBITSTRING:
                return ConverterUtils.convertVarBitStringArray(value);
            case Constants.PGTypeNames.XML:
                return ConverterUtils.convertXmlArray(value);
            case Constants.PGTypeNames.REGCLASS:
                return ConverterUtils.convertRegClassArray(value);
            case Constants.PGTypeNames.REGCONFIG:
                return ConverterUtils.convertRegConfigArray(value);
            case Constants.PGTypeNames.REGDICTIONARY:
                return ConverterUtils.convertRegDictionaryArray(value);
            case Constants.PGTypeNames.REGNAMESPACE:
                return ConverterUtils.convertRegNamespaceArray(value);
            case Constants.PGTypeNames.REGOPER:
                return ConverterUtils.convertRegOperArray(value);
            case Constants.PGTypeNames.REG_OPERATOR:
                return ConverterUtils.convertRegOperatorArray(value);
            case Constants.PGTypeNames.REG_PROC:
                return ConverterUtils.convertRegProcArray(value);
            case Constants.PGTypeNames.REG_PROCEDURE:
                return ConverterUtils.convertRegProcedureArray(value);
            case Constants.PGTypeNames.REG_ROLE:
                return ConverterUtils.convertRegRoleArray(value);
            case Constants.PGTypeNames.REG_TYPE:
                return ConverterUtils.convertRegTypeArray(value);
            case Constants.PGTypeNames.JSON:
                return ConverterUtils.convertJsonArray(value);
            case Constants.PGTypeNames.JSONB:
                return ConverterUtils.convertJsonbArray(value);
            case Constants.PGTypeNames.JSON_PATH:
                return ConverterUtils.convertJsonPathArray(value);
            case Constants.PGTypeNames.MONEY:
                return ConverterUtils.convertMoneyArray(value);
            case Constants.PGTypeNames.PGLSN:
                return ConverterUtils.convertPglsnArray(value);
            default:
                throw new ApplicationError("Unsupported Array type: " + elementType.getName());
        }
    }
    
    public static Object[] convertRecordToArray(Type elementType, Object value) throws ApplicationError {
        switch (elementType.getName()) {
            case Constants.TypeRecordNames.POINT_RECORD:
                return ConverterUtils.convertPointArray(value);
            case Constants.TypeRecordNames.LINE_RECORD:
                return ConverterUtils.convertLineArray(value);
            case Constants.TypeRecordNames.LINE_SEG_RECORD:
                return ConverterUtils.convertLineSegArray(value);
            case Constants.TypeRecordNames.BOX_RECORD:
                return ConverterUtils.convertBoxArray(value);
            case Constants.TypeRecordNames.PATH_RECORD:
                return ConverterUtils.convertPathArray(value);
            case Constants.TypeRecordNames.POLYGON_RECORD:
                return ConverterUtils.convertPolygonArray(value);
            case Constants.TypeRecordNames.CIRCLE_RECORD:
                return ConverterUtils.convertCircleArray(value);
            case Constants.TypeRecordNames.INTERVAL_RECORD:
                return ConverterUtils.convertIntervalArray(value);
            case Constants.TypeRecordNames.INTEGER_RANGE_RECORD:
                return ConverterUtils.convertInt4RangeArray(value);
            case Constants.TypeRecordNames.LONG_RANGE_RECORD:
                return ConverterUtils.convertInt8RangeArray(value);
            case Constants.TypeRecordNames.NUMERICAL_RANGE_RECORD:
                return ConverterUtils.convertNumRangeArray(value);
            case Constants.TypeRecordNames.TIMESTAMPTZRANGERECORD:
            case Constants.TypeRecordNames.TIMESTAMPTZ_RANGE_RECORD_CIVIL:
                return ConverterUtils.convertTsTzRangeArray(value);
            case Constants.TypeRecordNames.TIMESTAMPRANGERECORD:
            case Constants.TypeRecordNames.TIMESTAMP_RANGE_RECORD_CIVIL:
                return ConverterUtils.convertTsRangeArray(value);
            case Constants.TypeRecordNames.DATERANGERECORD:
            case Constants.TypeRecordNames.DATERANGE_RECORD_TYPE:
                return ConverterUtils.convertDateRangeArray(value);
            default:
                throw new ApplicationError("Unsupported Array type: " + elementType.getName());
        }
    }

    public static void setInet(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertInet(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setCidr(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertCidr(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setMacAddr(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertMac(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setMacAddr8(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertMac8(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setPoint(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertPoint(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setLine(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertLine(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setLineSeg(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertLseg(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setPath(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertPath(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setPolygon(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertPolygon(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setCircle(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertCircle(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setBox(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertBox(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setUuid(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertUuid(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setTsVector(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertTsVector(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setTsQuery(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertTsQuery(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setJson(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertJson(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setJsonb(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertJsonb(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setJsonPath(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertJsonPath(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setInterval(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertInterval(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setInt4Range(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertInt4Range(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setInt8Range(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertInt8Range(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setNumRange(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertNumRange(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setTsRange(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertTsRange(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setTsTzRange(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertTsTzRange(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setDateRange(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertDateRange(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setPGBit(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertBit(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setVarBitString(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertVarBit(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setBitString(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertBitn(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setPglsn(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertPglsn(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setMoney(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertMoney(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setRegClass(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertRegClass(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setRegConfig(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertRegConfig(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setRegDictionary(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertRegDictionary(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setRegNamespace(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertRegNamespace(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setRegOper(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertRegOper(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setRegOperator(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertRegOperator(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setRegProc(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertRegProc(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setRegProcedure(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertRegProcedure(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setRegRole(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertRegRole(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setRegType(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertRegType(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setXmlValue(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertXml(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setEnum(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConverterUtils.convertEnum(value);
            preparedStatement.setObject(index, object);
        }
    }

    protected static void setPointArray(Connection conn, PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertPointArray(value));
    }

    protected static void setLineArray(Connection conn, PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertLineArray(value));
    }

    protected static void setLineSegArray(Connection conn, PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertLineSegArray(value));
    }

    protected static void setPathArray(Connection conn, PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertPathArray(value));
    }

    protected static void setLPolygonArray(Connection conn, PreparedStatement preparedStatement, int index,
                                           Object value) throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertPolygonArray(value));
    }

    protected static void setBoxArray(Connection conn, PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertBoxArray(value));
    }

    protected static void setCircleArray(Connection conn, PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertCircleArray(value));
    }

    protected static void setIntervalArray(Connection conn, PreparedStatement preparedStatement, int index,
                                           Object value) throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertIntervalArray(value));
    }

    protected static void setIntegerRangeArray(Connection conn, PreparedStatement preparedStatement, int index,
                                               Object value) throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertInt4RangeArray(value));
    }

    protected static void setLongRangeArray(Connection conn, PreparedStatement preparedStatement, int index,
                                            Object value) throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertInt8RangeArray(value));
    }

    protected static void setNumRangeArray(Connection conn, PreparedStatement preparedStatement, int index,
                                           Object value) throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertNumRangeArray(value));
    }

    protected static void setTimeStampZRangeArray(Connection conn, PreparedStatement preparedStatement, int index,
                                                  Object value) throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertTsTzRangeArray(value));
    }

    protected static void setTimeStampRangeArray(Connection conn, PreparedStatement preparedStatement, int index,
                                                 Object value) throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertTsRangeArray(value));
    }

    protected static void setDateRangeArray(Connection conn, PreparedStatement preparedStatement, int index,
                                            Object value) throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertDateRangeArray(value));
    }

    protected static void setInetArray(Connection conn, PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertInetArray(value));
    }

    protected static void setCidrArray(Connection conn, PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertCidrArray(value));
    }

    protected static void setMacAddrArray(Connection conn, PreparedStatement preparedStatement, int index,
                                          Object value) throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertMacAddrArray(value));
    }

    protected static void setMacAddr8Array(Connection conn, PreparedStatement preparedStatement, int index,
                                           Object value) throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertMacAddr8Array(value));
    }

    protected static void setUuidArray(Connection conn, PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertUuidArray(value));
    }

    protected static void setTsVectorArray(Connection conn, PreparedStatement preparedStatement, int index,
                                           Object value) throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertTsVectotArray(value));
    }

    protected static void setTsQueryArray(Connection conn, PreparedStatement preparedStatement, int index,
                                          Object value) throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertTsQueryArray(value));
    }

    protected static void setVarBitStringArray(Connection conn, PreparedStatement preparedStatement, int index,
                                               Object value) throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertVarBitStringArray(value));
    }

    protected static void setBitStringArray(Connection conn, PreparedStatement preparedStatement, int index,
                                            Object value) throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertBitStringArray(value));
    }

    protected static void setPGBitArray(Connection conn, PreparedStatement preparedStatement, int index,
                                        Object value) throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertBitArray(value));
    }

    protected static void setRegClassArray(Connection conn, PreparedStatement preparedStatement, int index,
                                           Object value) throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertRegClassArray(value));
    }

    protected static void setRegConfigArray(Connection conn, PreparedStatement preparedStatement, int index,
                                            Object value) throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertRegConfigArray(value));
    }

    protected static void setRegDictionaryArray(Connection conn, PreparedStatement preparedStatement, int index,
                                                Object value) throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertRegDictionaryArray(value));
    }

    protected static void setRegNamespaceArray(Connection conn, PreparedStatement preparedStatement, int index,
                                               Object value) throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertRegNamespaceArray(value));
    }

    protected static void setRegOperArray(Connection conn, PreparedStatement preparedStatement, int index,
                                          Object value) throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertRegOperArray(value));
    }

    protected static void setRegOperatorArray(Connection conn, PreparedStatement preparedStatement, int index,
                                              Object value) throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertRegOperatorArray(value));
    }

    protected static void setRegProcArray(Connection conn, PreparedStatement preparedStatement, int index,
                                          Object value) throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertRegProcArray(value));
    }

    protected static void setRegProcedureArray(Connection conn, PreparedStatement preparedStatement, int index,
                                               Object value) throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertRegProcedureArray(value));
    }

    protected static void setRegRoleArray(Connection conn, PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertRegRoleArray(value));
    }

    protected static void setRegTypeArray(Connection conn, PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertRegTypeArray(value));
    }

    protected static void setXmlValueArray(Connection conn, PreparedStatement preparedStatement, int index,
                                           Object value) throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertXmlArray(value));
    }

    protected static void setJsonArray(Connection conn, PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertJsonArray(value));
    }

    protected static void setJsonBArray(Connection conn, PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertJsonbArray(value));
    }

    protected static void setJsonPathArray(Connection conn, PreparedStatement preparedStatement, int index,
                                           Object value) throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertJsonPathArray(value));
    }

    protected static void setPglsnArray(Connection conn, PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertPglsnArray(value));
    }

    protected static void setMoneyArray(Connection conn, PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        setPreparedStatement(conn, preparedStatement, index, ConverterUtils.convertMoneyArray(value));
    }

    protected static void setPreparedStatement(Connection conn, PreparedStatement preparedStatement, int index,
                                      Object[] arrayData) throws SQLException {
        if (arrayData[0] != null) {
            Array array = conn.createArrayOf((String) arrayData[1], (Object[]) arrayData[0]);
            preparedStatement.setArray(index, array);
        } else {
            preparedStatement.setArray(index, null);
        }
    }
}
