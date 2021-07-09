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

import io.ballerina.runtime.api.PredefinedTypes;
import io.ballerina.runtime.api.TypeTags;
import io.ballerina.runtime.api.creators.TypeCreator;
import io.ballerina.runtime.api.creators.ValueCreator;
import io.ballerina.runtime.api.types.ArrayType;
import io.ballerina.runtime.api.types.Field;
import io.ballerina.runtime.api.types.StructureType;
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.utils.JsonUtils;
import io.ballerina.runtime.api.utils.TypeUtils;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BDecimal;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.stdlib.postgresql.Constants;
import org.ballerinalang.sql.exception.ApplicationError;
import org.ballerinalang.stdlib.time.util.TimeValueHandler;

import java.io.Reader;
import java.io.StringReader;
import java.time.DateTimeException;
import java.time.LocalDate;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import static io.ballerina.runtime.api.utils.StringUtils.fromString;

/**
 * This class includes helper functions for custom PostgreSQL-Ballerina datatypes.
 *
 */
public class ConversionHelperUtils {
    private static final ArrayType stringArrayType = TypeCreator.createArrayType(PredefinedTypes.TYPE_STRING);

    private ConversionHelperUtils() {

    }

    public static Map<String, Object> getRecordType(Object value) {
        Map<String, Object> result = new HashMap<>();
        String key;
        Object bValue;
        Type type = TypeUtils.getType(value);
        Map<String, Field> structFields = ((StructureType) type).getFields();
        int fieldCount = structFields.size();
        Iterator<Field> fieldIterator = structFields.values().iterator();
        for (int i = 0; i < fieldCount; ++i) {
            Field field = fieldIterator.next();
            key = field.getFieldName();
            bValue = ((BMap) value).get(fromString(key));
            result.put(key, bValue);
        }
        return result;
    }

    public static ArrayList<Object> getArrayType(BArray value) {
        ArrayList<Object> elements = new ArrayList<>();
        long length = value.getLength();
        for (int i = 0; i < length; i++) {
            elements.add(value.get(i));
        }
        return elements;
    }

    public static String setRange(String upper, String lower, boolean upperInclusive, boolean lowerInclusive) {
        String rangeValue = "";
        if (lowerInclusive) {
            rangeValue += "[";
        } else {
            rangeValue += "(";
        }
        rangeValue += lower;
        rangeValue += ",";
        rangeValue += upper;

        if (upperInclusive) {
            rangeValue += "]";
        } else {
            rangeValue += ")";
        }
        return rangeValue;
    }

    public static HashMap<String, Object> convertRangeToMap(Object value) {
        HashMap<String, Object> rangeMap;
        if (value == null) {
            return null;
        } else {
            rangeMap = new HashMap<>(); 
            String objectValue = value.toString();
            if (objectValue.length() < 1) {
                return rangeMap;
            }
            if (objectValue.startsWith("[")) {
                rangeMap.put(Constants.Range.LOWERINCLUSIVE, true);
            } else {
                rangeMap.put(Constants.Range.LOWERINCLUSIVE, false);
            }
            objectValue = objectValue.substring(1);
            if (objectValue.endsWith("]")) {
                rangeMap.put(Constants.Range.UPPERINCLUSIVE, true);
            } else {
                rangeMap.put(Constants.Range.UPPERINCLUSIVE, false);
            }
            objectValue = objectValue.substring(0, objectValue.length() - 1);
            String[] rangeElements = objectValue.split(",");            
            rangeMap.put(Constants.Range.UPPER, rangeElements[1]);
            rangeMap.put(Constants.Range.LOWER, rangeElements[0]);
        }
        return rangeMap;
    }

         
    public static String convertCustomType(ArrayList<Object> objectArray) {
        Object object;
        Type type;
        String stringValue = "(";
        for (Object o : objectArray) {
            object = o;
            type = TypeUtils.getType(object);
            if (type.getTag() == TypeTags.RECORD_TYPE_TAG) {
                stringValue += setCustomRecordType(getRecordType(object));
            } else {
                stringValue += object.toString() + ",";
            }
        }
        stringValue = stringValue.substring(0, stringValue.length() - 1);
        stringValue += ")";
        return stringValue;
    }

    public static String setCustomRecordType(Map<String, Object> record) {
        String customValue = "";
        customValue += "(";
        for (Map.Entry<String, Object> entry : record.entrySet()) {
            customValue += entry.getValue().toString();
            customValue += ", ";
        } 
        int length = customValue.length();
        customValue = customValue.substring(0, length);
        customValue += ")";

        return customValue;
    }
    
    public static Object getJson(String jsonString) throws ApplicationError {
        Reader reader = new StringReader(jsonString);
        try {
            return JsonUtils.parse(reader, JsonUtils.NonStringValueProcessingMode.FROM_JSON_STRING);
        } catch (BError e) {
            throw new ApplicationError("Error while converting to JSON type. " + e.getDetails());
        }
    }

    public static BArray convertCustomTypeToString(String value) {
        String character;
        String element = "";
        int index = 0;
        int lastIndex = 0;
        BArray stringArray = ValueCreator.createArrayValue(stringArrayType);
//        boolean nested = false;
        if (value.startsWith("(") && value.endsWith(")")) {
            value = value.substring(1, value.length() - 1);
        }
        value = value.replaceAll("\"", "");
        for (int i = 0; i < value.length(); i++) {
            character = Character.toString(value.charAt(i));
            if (i == value.length() - 1 && !character.equals(")") && !character.equals("]")) {  
                element = value.substring(lastIndex, i + 1);
                stringArray.add(index, fromString(element));
                lastIndex = i + 1;
                index++;
            } else if (character.equals(",")) {
                element = value.substring(lastIndex, i);
                stringArray.add(index, fromString(element));
                lastIndex = i + 1;
                index++;
            }
        }
        return stringArray;
    }

    public static BMap<BString, Object> convertISOStringToCivil(String value) throws DateTimeException {
        if (value.startsWith("\"")) {
            value = value.substring(1);
        }
        if (value.endsWith("\"")) {
            value = value.substring(0, value.length() - 1);
        }
        if (!value.contains("+")) {
            java.util.Calendar now = java.util.Calendar.getInstance();
            java.util.TimeZone timeZone = now.getTimeZone();
            int offset = timeZone.getRawOffset() / 1000;
            value = value + "+" + String.format("%02d", offset / 3600) + ":" 
                    + String.format("%02d", (offset % 3600) / 60) + ":" 
                    + String.format("%02d", (offset % 3600) % 60);
        }
        value = value.replaceFirst(" ", "T");
        return TimeValueHandler.createCivilFromZoneDateTimeString(value);
    }

    public static BMap convertISOStringToDate(String value) throws DateTimeException {
        if (value.startsWith("\"")) {
            value = value.substring(1);
        }
        if (value.endsWith("\"")) {
            value = value.substring(0, value.length() - 1);
        }
        java.sql.Date date = java.sql.Date.valueOf(value);
        LocalDate dateObj = date.toLocalDate();
        BMap<BString, Object> dateMap = ValueCreator.createRecordValue(
                org.ballerinalang.stdlib.time.util.ModuleUtils.getModule(),
                org.ballerinalang.stdlib.time.util.Constants.DATE_RECORD);
        dateMap.put(fromString(
                org.ballerinalang.stdlib.time.util.Constants.DATE_RECORD_YEAR), dateObj.getYear());
        dateMap.put(fromString(
                org.ballerinalang.stdlib.time.util.Constants.DATE_RECORD_MONTH), dateObj.getMonthValue());
        dateMap.put(fromString(
                org.ballerinalang.stdlib.time.util.Constants.DATE_RECORD_DAY), dateObj.getDayOfMonth());
        return dateMap;
    }

    public static String convertCivilToString(Object civilObject, boolean timezone) throws DateTimeException {
        BMap civilMap = (BMap) civilObject;

        int year = Math.toIntExact(civilMap.getIntValue(fromString(org.ballerinalang.stdlib
            .time.util.Constants.DATE_RECORD_YEAR)));
        int month = Math.toIntExact(civilMap.getIntValue(fromString(org.ballerinalang.stdlib
            .time.util.Constants.DATE_RECORD_MONTH)));
        int day = Math.toIntExact(civilMap.getIntValue(fromString(org.ballerinalang.stdlib
            .time.util.Constants.DATE_RECORD_DAY)));
        int hour = Math.toIntExact(civilMap.getIntValue(fromString(org.ballerinalang.stdlib
            .time.util.Constants.TIME_OF_DAY_RECORD_HOUR)));
        int minute = Math.toIntExact(civilMap.getIntValue(fromString(org.ballerinalang.stdlib
            .time.util.Constants.TIME_OF_DAY_RECORD_MINUTE)));
        BDecimal second = BDecimal.valueOf(0);
        if (civilMap.containsKey(fromString(org.ballerinalang.stdlib
            .time.util.Constants.TIME_OF_DAY_RECORD_SECOND))) {
            second = ((BDecimal) civilMap.get(
                    fromString(org.ballerinalang.stdlib.time.util.Constants.TIME_OF_DAY_RECORD_SECOND)));
        }
        int zoneHours = 0;
        int zoneMinutes = 0;
        BDecimal zoneSeconds = BDecimal.valueOf(0);
        if (timezone && civilMap.containsKey(
                fromString(org.ballerinalang.stdlib.time.util.Constants.CIVIL_RECORD_UTC_OFFSET))) {
            
            BMap zoneMap = (BMap) civilMap.get(fromString(org.ballerinalang.stdlib
                .time.util.Constants.CIVIL_RECORD_UTC_OFFSET));
            zoneHours = Math.toIntExact(zoneMap.getIntValue(fromString(org.ballerinalang.stdlib.
                time.util.Constants.ZONE_OFFSET_RECORD_HOUR)));
            zoneMinutes = Math.toIntExact(zoneMap.getIntValue(fromString(org.ballerinalang.stdlib.
                time.util.Constants.ZONE_OFFSET_RECORD_MINUTE)));
            if (zoneMap.containsKey(fromString(org.ballerinalang.stdlib.
                time.util.Constants.ZONE_OFFSET_RECORD_SECOND))) {
                zoneSeconds = ((BDecimal) zoneMap.get(fromString(org.ballerinalang.stdlib.
                    time.util.Constants.ZONE_OFFSET_RECORD_SECOND)));
            }
        }
        ZonedDateTime dateTime = TimeValueHandler.createZoneDateTimeFromCivilValues(year, month, day, hour,
                minute, second, zoneHours, zoneMinutes, zoneSeconds, null,
                org.ballerinalang.stdlib.time.util.Constants.HeaderZoneHandling.PREFER_ZONE_OFFSET.toString());
        return dateTime.toInstant().toString();
    }

    public static String convertDateToString(Object civilObject) throws DateTimeException {
        BMap dateMap = (BMap) civilObject;

        int year = Math.toIntExact(dateMap.getIntValue(fromString(org.ballerinalang.stdlib
            .time.util.Constants.DATE_RECORD_YEAR)));
        int month = Math.toIntExact(dateMap.getIntValue(fromString(org.ballerinalang.stdlib
            .time.util.Constants.DATE_RECORD_MONTH)));
        int day = Math.toIntExact(dateMap.getIntValue(fromString(org.ballerinalang.stdlib
            .time.util.Constants.DATE_RECORD_DAY)));
        return year + "-" + month + "-" + day;
    }
}
