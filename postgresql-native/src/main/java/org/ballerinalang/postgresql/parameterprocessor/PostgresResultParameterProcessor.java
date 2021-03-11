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

import io.ballerina.runtime.api.PredefinedTypes;
import io.ballerina.runtime.api.TypeTags;
import io.ballerina.runtime.api.creators.TypeCreator;
import io.ballerina.runtime.api.creators.ValueCreator;
import io.ballerina.runtime.api.types.ArrayType;
import io.ballerina.runtime.api.types.Field;
import io.ballerina.runtime.api.types.RecordType;
import io.ballerina.runtime.api.types.StructureType;
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.utils.XmlUtils;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.api.values.BXml;
import org.ballerinalang.postgresql.utils.ConvertorUtils;
import org.ballerinalang.sql.Constants;
import org.ballerinalang.sql.exception.ApplicationError;
import org.ballerinalang.sql.parameterprocessor.DefaultResultParameterProcessor;
import org.ballerinalang.sql.utils.ColumnDefinition;
import org.ballerinalang.sql.utils.ErrorGenerator;
import org.ballerinalang.sql.utils.ModuleUtils;
import org.ballerinalang.sql.utils.Utils;

import java.math.BigDecimal;
import java.sql.Array;
import java.sql.Blob;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLXML;
import java.sql.Statement;
import java.sql.Struct;
import java.sql.Time;
import java.sql.Timestamp;
import java.time.OffsetDateTime;
import java.time.OffsetTime;
import java.util.Calendar;
import java.util.List;
import java.util.TimeZone;

import static io.ballerina.runtime.api.utils.StringUtils.fromString;

/**
 * This class implements methods required convert SQL types into ballerina types and
 * other methods that process the parameters of the result.
 *
 * @since 0.5.6
 */
public class PostgresResultParameterProcessor extends DefaultResultParameterProcessor {
    private static final Object lock = new Object();
    private static volatile PostgresResultParameterProcessor instance;
    private static volatile BObject iteratorObject;
    private static final Object lock2 = new Object();


    private static final ArrayType stringArrayType = TypeCreator.createArrayType(PredefinedTypes.TYPE_STRING);
    private static final ArrayType booleanArrayType = TypeCreator.createArrayType(PredefinedTypes.TYPE_BOOLEAN);
    private static final ArrayType intArrayType = TypeCreator.createArrayType(PredefinedTypes.TYPE_INT);
    private static final ArrayType floatArrayType = TypeCreator.createArrayType(PredefinedTypes.TYPE_FLOAT);
    private static final ArrayType decimalArrayType = TypeCreator.createArrayType(PredefinedTypes.TYPE_DECIMAL);

    private static final Calendar calendar = Calendar
            .getInstance(TimeZone.getTimeZone(Constants.TIMEZONE_UTC.getValue()));


    public static PostgresResultParameterProcessor getInstance() {
        if (instance == null) {
            synchronized (lock) {
                if (instance == null) {
                    instance = new PostgresResultParameterProcessor();
                }
            }
        }
        return instance;
    }

    // protected BArray createAndPopulateBBRefValueArray(Object firstNonNullElement, Object[] dataArray,
    //                                                   Type type) throws ApplicationError {
    //     BArray refValueArray = null;
    //     int length = dataArray.length;
    //     if (firstNonNullElement instanceof String) {
    //         refValueArray = createEmptyBBRefValueArray(PredefinedTypes.TYPE_STRING);
    //         for (int i = 0; i < length; i++) {
    //             refValueArray.add(i, dataArray[i]);
    //         }
    //     } else if (firstNonNullElement instanceof Boolean) {
    //         refValueArray = createEmptyBBRefValueArray(PredefinedTypes.TYPE_BOOLEAN);
    //         for (int i = 0; i < length; i++) {
    //             refValueArray.add(i, dataArray[i]);
    //         }
    //     } else if (firstNonNullElement instanceof Integer) {
    //         refValueArray = createEmptyBBRefValueArray(PredefinedTypes.TYPE_INT);
    //         for (int i = 0; i < length; i++) {
    //             refValueArray.add(i, dataArray[i]);
    //         }
    //     } else if (firstNonNullElement instanceof Long) {
    //         refValueArray = createEmptyBBRefValueArray(PredefinedTypes.TYPE_INT);
    //         for (int i = 0; i < length; i++) {
    //             refValueArray.add(i, dataArray[i]);
    //         }
    //     } else if (firstNonNullElement instanceof Float) {
    //         refValueArray = createEmptyBBRefValueArray(PredefinedTypes.TYPE_FLOAT);
    //         for (int i = 0; i < length; i++) {
    //             refValueArray.add(i, dataArray[i]);
    //         }
    //     } else if (firstNonNullElement instanceof Double) {
    //         refValueArray = createEmptyBBRefValueArray(PredefinedTypes.TYPE_FLOAT);
    //         for (int i = 0; i < length; i++) {
    //             refValueArray.add(i, dataArray[i]);
    //         }
    //     } else if (firstNonNullElement instanceof BigDecimal) {
    //         refValueArray = createEmptyBBRefValueArray(PredefinedTypes.TYPE_DECIMAL);
    //         for (int i = 0; i < length; i++) {
    //             refValueArray.add(i,
    //                     dataArray[i] != null ? ValueCreator.createDecimalValue((BigDecimal) dataArray[i]) : null);
    //         }
    //     } else if (firstNonNullElement == null) {
    //         refValueArray = createEmptyBBRefValueArray(type);
    //         for (int i = 0; i < length; i++) {
    //             refValueArray.add(i, firstNonNullElement);
    //         }
    //     } else {
    //         createAndPopulateCustomBBRefValueArray(firstNonNullElement, dataArray, type);
    //     }
    //     return refValueArray;
    // }

    // protected BArray createEmptyBBRefValueArray(Type type) {
    //     List<Type> memberTypes = new ArrayList<>(2);
    //     memberTypes.add(type);
    //     memberTypes.add(PredefinedTypes.TYPE_NULL);
    //     UnionType unionType = TypeCreator.createUnionType(memberTypes);
    //     return ValueCreator.createArrayValue(TypeCreator.createArrayType(unionType));
    // }

    // @Override
    // protected BArray createAndPopulateCustomBBRefValueArray(Object firstNonNullElement, Object[] dataArray,
    //                                                         Type type) {
    //     return null;
    // }

    protected BArray createAndPopulatePrimitiveValueArray(Object firstNonNullElement, Object[] dataArray)
            throws ApplicationError {
        int length = dataArray.length;
        if (firstNonNullElement instanceof String) {
            BArray stringDataArray = ValueCreator.createArrayValue(stringArrayType);
            for (int i = 0; i < length; i++) {
                stringDataArray.add(i, StringUtils.fromString((String) dataArray[i]));
            }
            return stringDataArray;
        } else if (firstNonNullElement instanceof Boolean) {
            BArray boolDataArray = ValueCreator.createArrayValue(booleanArrayType);
            for (int i = 0; i < length; i++) {
                boolDataArray.add(i, ((Boolean) dataArray[i]).booleanValue());
            }
            return boolDataArray;
        } else if (firstNonNullElement instanceof Integer) {
            BArray intDataArray = ValueCreator.createArrayValue(intArrayType);
            for (int i = 0; i < length; i++) {
                intDataArray.add(i, ((Integer) dataArray[i]).intValue());
            }
            return intDataArray;
        } else if (firstNonNullElement instanceof Long) {
            BArray longDataArray = ValueCreator.createArrayValue(intArrayType);
            for (int i = 0; i < length; i++) {
                longDataArray.add(i, ((Long) dataArray[i]).longValue());
            }
            return longDataArray;
        } else if (firstNonNullElement instanceof Float) {
            BArray floatDataArray = ValueCreator.createArrayValue(floatArrayType);
            for (int i = 0; i < length; i++) {
                floatDataArray.add(i, ((Float) dataArray[i]).floatValue());
            }
            return floatDataArray;
        } else if (firstNonNullElement instanceof Double) {
            BArray doubleDataArray = ValueCreator.createArrayValue(floatArrayType);
            for (int i = 0; i < dataArray.length; i++) {
                doubleDataArray.add(i, ((Double) dataArray[i]).doubleValue());
            }
            return doubleDataArray;
        } else if ((firstNonNullElement instanceof BigDecimal)) {
            BArray decimalDataArray = ValueCreator.createArrayValue(decimalArrayType);
            for (int i = 0; i < dataArray.length; i++) {
                decimalDataArray.add(i, ValueCreator.createDecimalValue((BigDecimal) dataArray[i]));
            }
            return decimalDataArray;
        } else {
            return createAndPopulateCustomValueArray(firstNonNullElement, dataArray);
        }
    }

    @Override
    protected BArray createAndPopulateCustomValueArray(Object firstNonNullElement, Object[] dataArray) {
        return null;
    }

    protected BMap<BString, Object> createUserDefinedType(Struct structValue, StructureType structType)
            throws ApplicationError {
        if (structValue == null) {
            return null;
        }
        Field[] internalStructFields = structType.getFields().values().toArray(new Field[0]);
        BMap<BString, Object> struct = ValueCreator.createMapValue(structType);
        try {
            Object[] dataArray = structValue.getAttributes();
            if (dataArray != null) {
                if (dataArray.length != internalStructFields.length) {
                    throw new ApplicationError("specified record and the returned SQL Struct field counts " +
                            "are different, and hence not compatible");
                }
                int index = 0;
                for (Field internalField : internalStructFields) {
                    int type = internalField.getFieldType().getTag();
                    BString fieldName = fromString(internalField.getFieldName());
                    Object value = dataArray[index];
                    switch (type) {
                        case TypeTags.INT_TAG:
                            if (value instanceof BigDecimal) {
                                struct.put(fieldName, ((BigDecimal) value).intValue());
                            } else {
                                struct.put(fieldName, value);
                            }
                            break;
                        case TypeTags.FLOAT_TAG:
                            if (value instanceof BigDecimal) {
                                struct.put(fieldName, ((BigDecimal) value).doubleValue());
                            } else {
                                struct.put(fieldName, value);
                            }
                            break;
                        case TypeTags.DECIMAL_TAG:
                            if (value instanceof BigDecimal) {
                                struct.put(fieldName, value);
                            } else {
                                struct.put(fieldName, ValueCreator.createDecimalValue((BigDecimal) value));
                            }
                            break;
                        case TypeTags.STRING_TAG:
                            struct.put(fieldName, value);
                            break;
                        case TypeTags.BOOLEAN_TAG:
                            struct.put(fieldName, ((int) value) == 1);
                            break;
                        case TypeTags.OBJECT_TYPE_TAG:
                        case TypeTags.RECORD_TYPE_TAG:
                            struct.put(fieldName,
                                    createUserDefinedType((Struct) value,
                                            (StructureType) internalField.getFieldType()));
                            break;
                        default:
                            createUserDefinedTypeSubtype(internalField, structType);
                    }
                    ++index;
                }
            }
        } catch (SQLException e) {
            throw new ApplicationError("Error while retrieving data to create " + structType.getName()
                    + " record. ", e);
        }
        return struct;
    }

    @Override
    protected void createUserDefinedTypeSubtype(Field internalField, StructureType structType)
            throws ApplicationError {
        throw new ApplicationError("Error while retrieving data for unsupported type " +
                internalField.getFieldType().getName() + " to create "
                + structType.getName() + " record.");
    }

    protected static Object[] validateNullable(Object[] objects) {
        Object[] returnResult = new Object[2];
        boolean foundNull = false;
        Object nonNullObject = null;
        for (Object object : objects) {
            if (object != null) {
                if (nonNullObject == null) {
                    nonNullObject = object;
                }
                if (foundNull) {
                    break;
                }
            } else {
                foundNull = true;
                if (nonNullObject != null) {
                    break;
                }
            }
        }
        returnResult[0] = nonNullObject;
        returnResult[1] = foundNull;
        return returnResult;
    }

    @Override
    public BArray convertArray(Array array, int sqlType, Type type) throws SQLException, ApplicationError {
        if (array != null) {
            Utils.validatedInvalidFieldAssignment(sqlType, type, "SQL Array");
            Object[] dataArray = (Object[]) array.getArray();
            if (dataArray == null || dataArray.length == 0) {
                return null;
            }

            Object[] result = validateNullable(dataArray);
            Object firstNonNullElement = result[0];
            boolean containsNull = (boolean) result[1];

            if (containsNull) {
                // If there are some null elements, return a union-type element array
                return createAndPopulateBBRefValueArray(firstNonNullElement, dataArray, type);
            } else {
                // If there are no null elements, return a ballerina primitive-type array
                return createAndPopulatePrimitiveValueArray(firstNonNullElement, dataArray);
            }

        } else {
            return null;
        }
    }

    @Override
    public BString convertChar(String value, int sqlType, Type type) throws ApplicationError {
        Utils.validatedInvalidFieldAssignment(sqlType, type, "SQL String");
        return fromString(value);
    }

    @Override
    public Object convertChar(
            String value, int sqlType, Type type, String sqlTypeName) throws ApplicationError {
        Utils.validatedInvalidFieldAssignment(sqlType, type, sqlTypeName);
        return fromString(value);
    }

    @Override
    public Object convertByteArray(byte[] value, int sqlType, Type type, String sqlTypeName) throws ApplicationError {
        if (value != null) {
            return ValueCreator.createArrayValue(value);
        } else {
            return null;
        }
    }

    @Override
    public Object convertInteger(long value, int sqlType, Type type, boolean isNull) throws ApplicationError {
        Utils.validatedInvalidFieldAssignment(sqlType, type, "SQL long or integer");
        if (isNull) {
            return null;
        } else {
            if (type.getTag() == TypeTags.STRING_TAG) {
                return fromString(String.valueOf(value));
            }
            return value;
        }
    }

    @Override
    public Object convertDouble(double value, int sqlType, Type type, boolean isNull) throws ApplicationError {
        Utils.validatedInvalidFieldAssignment(sqlType, type, "SQL double or float");
        if (isNull) {
            return null;
        } else {
            if (type.getTag() == TypeTags.STRING_TAG) {
                return fromString(String.valueOf(value));
            }
            return value;
        }
    }

    @Override
    public Object convertDecimal(BigDecimal value, int sqlType, Type type, boolean isNull) throws ApplicationError {
        Utils.validatedInvalidFieldAssignment(sqlType, type, "SQL decimal or real");
        if (isNull) {
            return null;
        } else {
            if (type.getTag() == TypeTags.STRING_TAG) {
                return fromString(String.valueOf(value));
            }
            return ValueCreator.createDecimalValue(value);
        }
    }

    @Override
    public Object convertBlob(Blob value, int sqlType, Type type) throws ApplicationError, SQLException {
        Utils.validatedInvalidFieldAssignment(sqlType, type, "SQL Blob");
        if (value != null) {
            return ValueCreator.createArrayValue(value.getBytes(1L, (int) value.length()));
        } else {
            return null;
        }
    }

    @Override
    public Object convertDate(java.util.Date date, int sqlType, Type type) throws ApplicationError {
        Utils.validatedInvalidFieldAssignment(sqlType, type, "SQL Date/Time");
        if (date != null) {
            switch (type.getTag()) {
                case TypeTags.STRING_TAG:
                    return fromString(Utils.getString(date));
                case TypeTags.OBJECT_TYPE_TAG:
                case TypeTags.RECORD_TYPE_TAG:
                    return Utils.createTimeStruct(date.getTime());
                case TypeTags.INT_TAG:
                    return date.getTime();
            }
        }
        return null;
    }

    @Override
    public Object convertBoolean(boolean value, int sqlType, Type type, boolean isNull) throws ApplicationError {
        Utils.validatedInvalidFieldAssignment(sqlType, type, "SQL Boolean");
        if (!isNull) {
            switch (type.getTag()) {
                case TypeTags.BOOLEAN_TAG:
                    return value;
                case TypeTags.INT_TAG:
                    if (value) {
                        return 1L;
                    } else {
                        return 0L;
                    }
                case TypeTags.STRING_TAG:
                    return fromString(String.valueOf(value));
            }
        }
        return null;
    }

    @Override
    public Object convertStruct(Struct value, int sqlType, Type type) throws ApplicationError {
        Utils.validatedInvalidFieldAssignment(sqlType, type, "SQL Struct");
        if (value != null) {
            if (type instanceof RecordType) {
                return createUserDefinedType(value, (RecordType) type);
            } else {
                throw new ApplicationError("The ballerina type that can be used for SQL struct should be record type," +
                        " but found " + type.getName() + " .");
            }
        } else {
            return null;
        }
    }

    @Override
    public Object convertXml(SQLXML value, int sqlType, Type type) throws ApplicationError, SQLException {
        Utils.validatedInvalidFieldAssignment(sqlType, type, "SQL XML");
        if (value != null) {
            if (type instanceof BXml) {
                return XmlUtils.parse(value.getBinaryStream());
            } else {
                throw new ApplicationError("The ballerina type that can be used for SQL struct should be record type," +
                        " but found " + type.getName() + " .");
            }
        } else {
            return null;
        }
    }

    private void populateBitAndBoolean(CallableStatement statement, BObject parameter, int paramIndex)
            throws SQLException {
        parameter.addNativeData(Constants.ParameterObject.VALUE_NATIVE_DATA,
                statement.getBoolean(paramIndex));
    }

    @Override
    public void populateBinary(CallableStatement statement, BObject parameter, int paramIndex)
            throws SQLException {
        // populateCharacterTypes(statement, parameter, paramIndex);
    }

    @Override
    public void populateDate(CallableStatement statement, BObject parameter, int paramIndex) throws SQLException {
        parameter.addNativeData(Constants.ParameterObject.VALUE_NATIVE_DATA,
                statement.getDate(paramIndex, calendar));
    }

    @Override
    public void populateTime(CallableStatement statement, BObject parameter, int paramIndex) throws SQLException {
        parameter.addNativeData(Constants.ParameterObject.VALUE_NATIVE_DATA,
                statement.getTime(paramIndex, calendar));
    }

    @Override
    public void populateTimeWithTimeZone(CallableStatement statement, BObject parameter, int paramIndex)
            throws SQLException {
        try {
            Time time = statement.getTime(paramIndex, calendar);
            parameter.addNativeData(Constants.ParameterObject.VALUE_NATIVE_DATA, time);
        } catch (SQLException ex) {
            //Some database drivers do not support getTime operation,
            // therefore falling back to getObject method.
            OffsetTime offsetTime = statement.getObject(paramIndex, OffsetTime.class);
            parameter.addNativeData(Constants.ParameterObject.VALUE_NATIVE_DATA,
                    Time.valueOf(offsetTime.toLocalTime()));
        }
    }

    @Override
    public void populateTimestamp(CallableStatement statement, BObject parameter, int paramIndex)
            throws SQLException {
        parameter.addNativeData(Constants.ParameterObject.VALUE_NATIVE_DATA,
                statement.getTimestamp(paramIndex, calendar));
    }

    @Override
    public void populateTimestampWithTimeZone(CallableStatement statement, BObject parameter, int paramIndex)
            throws SQLException {
        try {
            parameter.addNativeData(Constants.ParameterObject.VALUE_NATIVE_DATA,
                    statement.getTimestamp(paramIndex, calendar));
        } catch (SQLException ex) {
            //Some database drivers do not support getTimestamp operation,
            // therefore falling back to getObject method.
            OffsetDateTime offsetDateTime = statement.getObject(paramIndex, OffsetDateTime.class);
            parameter.addNativeData(Constants.ParameterObject.VALUE_NATIVE_DATA,
                    Timestamp.valueOf(offsetDateTime.toLocalDateTime()));
        }
    }

    @Override
    public void populateArray(CallableStatement statement, BObject parameter, int paramIndex) throws SQLException {
        parameter.addNativeData(Constants.ParameterObject.VALUE_NATIVE_DATA,
                statement.getArray(paramIndex));
    }

    @Override
    public void populateBit(CallableStatement statement, BObject parameter, int paramIndex) throws SQLException {
        populateBitAndBoolean(statement, parameter, paramIndex);

    }

    @Override
    public void populateXML(CallableStatement statement, BObject parameter, int paramIndex) throws SQLException {
        parameter.addNativeData(Constants.ParameterObject.VALUE_NATIVE_DATA,
                statement.getSQLXML(paramIndex));
    }
    
    public void populateObject(CallableStatement statement, BObject parameter, int paramIndex) throws SQLException {
        parameter.addNativeData(Constants.ParameterObject.VALUE_NATIVE_DATA,
                statement.getObject(paramIndex));
    }

    @Override
    public void populateCustomOutParameters(CallableStatement statement, BObject parameter, int paramIndex, int sqlType)
            throws ApplicationError {
        try {
            populateObject(statement, parameter, paramIndex);
        } catch (SQLException ex) {
            throw new ApplicationError("Unsupported SQL type '" + sqlType + "' when reading Procedure call " +
                "Out parameter of index '" + paramIndex + "'.");
        }
    }

    @Override
    public Object getCustomOutParameters(BObject result, int sqlType, Type ballerinaType) {
        Object innerObject = result.get(org.ballerinalang.sql.Constants.ParameterObject.IN_VALUE_FIELD);
        Object value = result.getNativeData(org.ballerinalang.sql.Constants.ParameterObject.VALUE_NATIVE_DATA);
        BObject innerBobject;
        if (innerObject instanceof BObject) {
            innerBobject = (BObject) innerObject;
            String sqlTypeName = innerBobject.getType().getName();
            switch(sqlTypeName) {
                case org.ballerinalang.postgresql.Constants.PGTypeNames.INET:
                    return convertInetType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.CIDR:
                    return convertCidrType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.MACADDR:
                    return convertMacaddrType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.MACADDR8:
                    return convertMacaddr8Type(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.POINT:
                    return convertPointType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.LINE:
                    return convertLineType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.LSEG:
                    return convertLsegType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.BOX:
                    return convertBoxType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.CIRCLE:
                    return convertCircleType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.UUID:
                    return convertUuidType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.TSVECTOR:
                    return convertTsvectorType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.TSQUERY:
                    return convertTsqueryType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.JSON:
                    return convertJsonType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.JSONB:
                    return convertJsonbType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.JSONPATH:
                    return convertJsonpathType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.INTERVAL:
                    return convertIntervalType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.INT4RANGE:
                    return convertInt4rangeType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.INT8RANGE:
                    return convertInt8rangeType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.NUMRANGE:
                    return convertNumrangeType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.TSRANGE:
                    return convertTsrangeType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.TSTZRANGE:
                    return convertTstzrangeType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.DATERANGE:
                    return convertDaterangeType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.PGBIT:
                    return convertPGbitType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.BITSTRING:
                    return convertBitstringType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.VARBITSTRING:
                    return convertVarbitstringType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.PGLSN:
                    return convertPglsnType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.REGCLASS:
                    return convertRegclassType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.REGCONFIG:
                    return convertRegconfigType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.REGDICTIONARY:
                    return convertRegdictionaryType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.REGNAMESPACE:
                    return convertRegnamespaceType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.REGOPER:
                    return convertRegoperType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.REGOPERATOR:
                    return convertRegoperatorType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.REGPROC:
                    return convertRegprocType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.REGPROCEDURE:
                    return convertRegprocedureType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.REGROLE:
                    return convertRegroleType(value, sqlType, ballerinaType);
                case org.ballerinalang.postgresql.Constants.PGTypeNames.REGTYPE:
                    return convertRegtypeType(value, sqlType, ballerinaType);
                default:
                    return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
            }
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
    }
    }

    public static Object convertInetType(Object value, int sqlType, Type ballerinaType) {
        return convertNetworkTypes(value, sqlType, ballerinaType);
    }

    public static Object convertCidrType(Object value, int sqlType, Type ballerinaType) {
        return convertNetworkTypes(value, sqlType, ballerinaType);
    }

    public static Object convertMacaddrType(Object value, int sqlType, Type ballerinaType) {
        return convertNetworkTypes(value, sqlType, ballerinaType);
    }

    public static Object convertMacaddr8Type(Object value, int sqlType, Type ballerinaType) {
        return convertNetworkTypes(value, sqlType, ballerinaType);
    }

    public static Object convertPointType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            try {
                return ConvertorUtils.convertPointToRecord(value, ballerinaType.getName());
            } catch (SQLException ex) {
                return ErrorGenerator.getSQLApplicationError(ex.getMessage());
            }
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
        }
    }

    public static Object convertLineType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            try {
                return ConvertorUtils.convertLineToRecord(value, ballerinaType.getName());
            } catch (SQLException ex) {
                return ErrorGenerator.getSQLApplicationError(ex.getMessage());
            }
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
        }
    }

    public static Object convertLsegType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            try {
                return ConvertorUtils.convertLsegToRecord(value, ballerinaType.getName());
            } catch (SQLException ex) {
                return ErrorGenerator.getSQLApplicationError(ex.getMessage());
            }
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
        }
    }

    public static Object convertBoxType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            try {
                return ConvertorUtils.convertBoxToRecord(value, ballerinaType.getName());
            } catch (SQLException ex) {
                return ErrorGenerator.getSQLApplicationError(ex.getMessage());
            }
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
        }
    }

    public static Object convertCircleType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            try {
                return ConvertorUtils.convertCircleToRecord(value, ballerinaType.getName());
            } catch (SQLException ex) {
                return ErrorGenerator.getSQLApplicationError(ex.getMessage());
            }
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
        }
    }

    public static Object convertUuidType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
        }
    }

    public static Object convertTsvectorType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
        }
    }

    public static Object convertTsqueryType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
        }
    }

    public static Object convertJsonType(Object value, int sqlType, Type ballerinaType) {
        return convertJsonTypes(value, sqlType, ballerinaType);
    }

    public static Object convertJsonbType(Object value, int sqlType, Type ballerinaType) {
        return convertJsonTypes(value, sqlType, ballerinaType);
    }

    public static Object convertJsonpathType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
        }
    }

    public static Object convertIntervalType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            try {
                return ConvertorUtils.convertIntervalToRecord(value, ballerinaType.getName());
            } catch (SQLException ex) {
                return ErrorGenerator.getSQLApplicationError(ex.getMessage());
            }
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
        }
    }

    public static Object convertInt4rangeType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            return ConvertorUtils.convertInt4rangeToRecord(value, ballerinaType.getName());
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
        }
    }

    public static Object convertInt8rangeType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            return ConvertorUtils.convertInt8rangeToRecord(value, ballerinaType.getName());
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
        }
    }

    public static Object convertNumrangeType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            return ConvertorUtils.convertNumrangeToRecord(value, ballerinaType.getName());
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
        }
    }

    public static Object convertTsrangeType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            return ConvertorUtils.converTsrangeToRecord(value, ballerinaType.getName());
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
        }
    }

    public static Object convertTstzrangeType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            return ConvertorUtils.convertTstzrangeToRecord(value, ballerinaType.getName());
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
        }
    }

    public static Object convertDaterangeType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            return ConvertorUtils.convertDaterangeToRecord(value, ballerinaType.getName());
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
        }
    }

    public static Object convertPGbitType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
        }
    }

    public static Object convertBitstringType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
        }
    }

    public static Object convertVarbitstringType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
        }
    }

    public static Object convertPglsnType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
        }
    }


    public static Object convertRegclassType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
        }
    }

    public static Object convertRegconfigType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
        }
    }

    public static Object convertRegdictionaryType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
        }
    }

    public static Object convertRegnamespaceType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
        }
    }

    public static Object convertRegoperType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
        }
    }

    public static Object convertRegoperatorType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
        }
    }

    public static Object convertRegprocType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
        }
    }

    public static Object convertRegprocedureType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
        }
    }

    public static Object convertRegroleType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
        }
    }

    public static Object convertRegtypeType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
        }
    }


    public static Object convertNetworkTypes(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
        }
    }

    public static Object convertJsonTypes(Object value, int sqlType, Type ballerinaType) {
        
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.JSON_TAG) {
            return ConvertorUtils.getJsonValue(value);
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported SQL type " + sqlType);
        }
    }

    public Object convertypes(String value, int sqlType, Type type, boolean isNull) throws ApplicationError {
        Utils.validatedInvalidFieldAssignment(sqlType, type, "SQL long or integer");
        if (isNull) {
            return null;
        } else {
            if (type.getTag() == TypeTags.STRING_TAG) {
                return fromString(String.valueOf(value));
            }
            return value;
        }
    }

    protected BObject getIteratorObject() {
        if (iteratorObject == null) {
            synchronized (lock2) {
                if (iteratorObject == null) {
                    iteratorObject = ValueCreator.createObjectValue(
                            org.ballerinalang.postgresql.utils.ModuleUtils.getModule(),
                                  "CustomResultIterator", new Object[0]);
                }
            }
        }
        return iteratorObject;
        // return null;
    }

    public BObject createRecordIterator(ResultSet resultSet,
                                        Statement statement,
                                        Connection connection, List<ColumnDefinition> columnDefinitions,
                                        StructureType streamConstraint) {
        BObject iteratorObject = this.getIteratorObject();
        BObject resultIterator = ValueCreator.createObjectValue(ModuleUtils.getModule(),
                Constants.RESULT_ITERATOR_OBJECT, new Object[]{null, iteratorObject});
        resultIterator.addNativeData(Constants.RESULT_SET_NATIVE_DATA_FIELD, resultSet);
        resultIterator.addNativeData(Constants.STATEMENT_NATIVE_DATA_FIELD, statement);
        resultIterator.addNativeData(Constants.CONNECTION_NATIVE_DATA_FIELD, connection);
        resultIterator.addNativeData(Constants.COLUMN_DEFINITIONS_DATA_FIELD, columnDefinitions);
        resultIterator.addNativeData(Constants.RECORD_TYPE_DATA_FIELD, streamConstraint);
        return resultIterator;
    }

    public Object getCustomResult(ResultSet resultSet, int columnIndex, ColumnDefinition columnDefinition)
            throws ApplicationError {
        Type ballerinaType = columnDefinition.getBallerinaType();
        try {
            Object value = resultSet.getObject(columnIndex);
            switch (ballerinaType.getName()) {
                case org.ballerinalang.postgresql.Constants.TypeRecordNames.POINTRECORD:
                    return ConvertorUtils.convertPointToRecord(value, ballerinaType.getName());
                case org.ballerinalang.postgresql.Constants.TypeRecordNames.LINERECOORDINATE:
                case org.ballerinalang.postgresql.Constants.TypeRecordNames.LINEEQUATION:
                    return ConvertorUtils.convertLineToRecord(value, ballerinaType.getName());
                case org.ballerinalang.postgresql.Constants.TypeRecordNames.LSEGRECORD:
                    return ConvertorUtils.convertLsegToRecord(value, ballerinaType.getName());
                case org.ballerinalang.postgresql.Constants.TypeRecordNames.BOXRECORD:
                    return ConvertorUtils.convertBoxToRecord(value, ballerinaType.getName());
                case org.ballerinalang.postgresql.Constants.TypeRecordNames.CIRCLERECORD:
                    return ConvertorUtils.convertCircleToRecord(value, ballerinaType.getName());
                case org.ballerinalang.postgresql.Constants.TypeRecordNames.INTERVALRECORD:
                    return ConvertorUtils.convertIntervalToRecord(value, ballerinaType.getName());
                case org.ballerinalang.postgresql.Constants.TypeRecordNames.INT4RANGERECORD:
                    return ConvertorUtils.convertInt4rangeToRecord(value, ballerinaType.getName());
                case org.ballerinalang.postgresql.Constants.TypeRecordNames.INT8RANGERECORD:
                    return ConvertorUtils.convertInt8rangeToRecord(value, ballerinaType.getName());
                case org.ballerinalang.postgresql.Constants.TypeRecordNames.NUMRANGERECORD:
                    return ConvertorUtils.convertNumrangeToRecord(value, ballerinaType.getName());
                case org.ballerinalang.postgresql.Constants.TypeRecordNames.TIMESTAMPRANGERECORD:
                    return ConvertorUtils.converTsrangeToRecord(value, ballerinaType.getName());
                case org.ballerinalang.postgresql.Constants.TypeRecordNames.TIMESTAMPTZRANGERECORD:
                    return ConvertorUtils.convertTstzrangeToRecord(value, ballerinaType.getName());
                case org.ballerinalang.postgresql.Constants.TypeRecordNames.DATERANGERECORD:
                    return ConvertorUtils.convertDaterangeToRecord(value, ballerinaType.getName());
                default:
                    return ErrorGenerator.getSQLApplicationError("Unsupported type : " + ballerinaType.getName());
            }
        } catch (SQLException ex) {
            return ErrorGenerator.getSQLApplicationError(ex.getMessage());
        }
    }

    public BObject getCustomProcedureCallObject() {
        return this.getIteratorObject();
    }
}
