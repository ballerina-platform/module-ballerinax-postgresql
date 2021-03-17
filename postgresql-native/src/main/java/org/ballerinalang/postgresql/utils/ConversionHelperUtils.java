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
package org.ballerinalang.postgresql.utils;

import io.ballerina.runtime.api.types.Field;
import io.ballerina.runtime.api.types.StructureType;
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.utils.JsonUtils;
import io.ballerina.runtime.api.utils.TypeUtils;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BString;
import org.ballerinalang.postgresql.Constants;
import org.ballerinalang.sql.exception.ApplicationError;
import org.ballerinalang.stdlib.time.util.TimeUtils;

import java.io.Reader;
import java.io.StringReader;
import java.sql.SQLException;
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

    public static String setCustomType(Map<String, Object> record) {
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

    public static Object toTimeString(Object timeObject) {
        try {
            BMap<BString, Object> timeRecord = (BMap<BString, Object>) timeObject;
            return TimeUtils.getDefaultString(timeRecord);
        } catch (BError e) {
            return TimeUtils.getTimeError(e.getMessage());
        }
    }
    
    public static Object getJson(String jsonString) throws ApplicationError, SQLException {
        Reader reader = new StringReader(jsonString);
        try {
            return JsonUtils.parse(reader, JsonUtils.NonStringValueProcessingMode.FROM_JSON_STRING);
        } catch (BError e) {
            throw new ApplicationError("Error while converting to JSON type. " + e.getDetails());
        }
    }
}
