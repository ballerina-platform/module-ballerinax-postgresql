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
import io.ballerina.runtime.api.types.StructureType;
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.utils.XmlUtils;
import io.ballerina.runtime.api.values.BObject;
import org.ballerinalang.postgresql.Constants;
import org.ballerinalang.postgresql.utils.ConvertorUtils;
import org.ballerinalang.postgresql.utils.ModuleUtils;
import org.ballerinalang.sql.exception.ApplicationError;
import org.ballerinalang.sql.parameterprocessor.DefaultResultParameterProcessor;
import org.ballerinalang.sql.utils.ColumnDefinition;
import org.ballerinalang.sql.utils.ErrorGenerator;
import org.ballerinalang.sql.utils.Utils;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLXML;
import java.sql.Statement;
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
            .getInstance(TimeZone.getTimeZone(org.ballerinalang.sql.Constants.TIMEZONE_UTC.getValue()));

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

    @Override
    public Object convertByteArray(byte[] value, int sqlType, Type type, String sqlTypeName) throws ApplicationError {
        if (value != null) {
            return ValueCreator.createArrayValue(value);
        } else {
            return null;
        }
    }

    @Override
    public Object convertXml(SQLXML value, int sqlType, Type type) throws ApplicationError, SQLException {
        Utils.validatedInvalidFieldAssignment(sqlType, type, "SQL XML");
        if (value != null) {
            if (type.getTag() == TypeTags.XML_TAG) {       
                return XmlUtils.parse(value.getBinaryStream());
            } else if (type.getTag() == TypeTags.STRING_TAG) {
                return fromString(value.toString());
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
        parameter.addNativeData(org.ballerinalang.sql.Constants.ParameterObject.VALUE_NATIVE_DATA,
                statement.getBoolean(paramIndex));
    }

    @Override
    public void populateBinary(CallableStatement statement, BObject parameter, int paramIndex)
            throws SQLException {
        parameter.addNativeData(org.ballerinalang.sql.Constants.ParameterObject.VALUE_NATIVE_DATA,
                statement.getBytes(paramIndex));
    }

    @Override
    public void populateArray(CallableStatement statement, BObject parameter, int paramIndex) throws SQLException {
        parameter.addNativeData(org.ballerinalang.sql.Constants.ParameterObject.VALUE_NATIVE_DATA,
                statement.getArray(paramIndex));
    }

    @Override
    public void populateBit(CallableStatement statement, BObject parameter, int paramIndex) throws SQLException {
        populateBitAndBoolean(statement, parameter, paramIndex);

    }

    @Override
    public void populateXML(CallableStatement statement, BObject parameter, int paramIndex) throws SQLException {
        parameter.addNativeData(org.ballerinalang.sql.Constants.ParameterObject.VALUE_NATIVE_DATA,
                statement.getSQLXML(paramIndex));
    }
    
    public void populateObject(CallableStatement statement, BObject parameter, int paramIndex) throws SQLException {
        parameter.addNativeData(org.ballerinalang.sql.Constants.ParameterObject.VALUE_NATIVE_DATA,
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
                case Constants.PGTypeNames.INET:
                    return convertInetType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.CIDR:
                    return convertCidrType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.MACADDR:
                    return convertMacaddrType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.MACADDR8:
                    return convertMacaddr8Type(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.POINT:
                    return convertPointType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.LINE:
                    return convertLineType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.LSEG:
                    return convertLsegType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.BOX:
                    return convertBoxType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.PATH:
                    return convertPathType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.POLYGON:
                    return convertPolygonType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.CIRCLE:
                    return convertCircleType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.UUID:
                    return convertUuidType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.TSVECTOR:
                    return convertTsvectorType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.TSQUERY:
                    return convertTsqueryType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.JSON:
                    return convertJsonType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.JSONB:
                    return convertJsonbType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.JSONPATH:
                    return convertJsonpathType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.INTERVAL:
                    return convertIntervalType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.INT4RANGE:
                    return convertInt4rangeType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.INT8RANGE:
                    return convertInt8rangeType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.NUMRANGE:
                    return convertNumrangeType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.TSRANGE:
                    return convertTsrangeType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.TSTZRANGE:
                    return convertTstzrangeType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.DATERANGE:
                    return convertDaterangeType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.PGBIT:
                    return convertPGbitType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.BITSTRING:
                    return convertBitstringType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.VARBITSTRING:
                    return convertVarbitstringType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.PGLSN:
                    return convertPglsnType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.REGCLASS:
                    return convertRegclassType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.REGCONFIG:
                    return convertRegconfigType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.REGDICTIONARY:
                    return convertRegdictionaryType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.REGNAMESPACE:
                    return convertRegnamespaceType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.REGOPER:
                    return convertRegoperType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.REGOPERATOR:
                    return convertRegoperatorType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.REGPROC:
                    return convertRegprocType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.REGPROCEDURE:
                    return convertRegprocedureType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.REGROLE:
                    return convertRegroleType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.REGTYPE:
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
            return ErrorGenerator.getSQLApplicationError("Unsupported Ballerina type " + ballerinaType);
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
            return ErrorGenerator.getSQLApplicationError("Unsupported Ballerina type " + ballerinaType);
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
            return ErrorGenerator.getSQLApplicationError("Unsupported Ballerina type " + ballerinaType);
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
            return ErrorGenerator.getSQLApplicationError("Unsupported Ballerina type " + ballerinaType);
        }
    }

    public static Object convertPathType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            try {
                return ConvertorUtils.convertPathToRecord(value, ballerinaType.getName());
            } catch (SQLException ex) {
                return ErrorGenerator.getSQLApplicationError(ex.getMessage());
            }
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported Ballerina type " + ballerinaType);
        }
    }

    public static Object convertPolygonType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            try {
                return ConvertorUtils.convertPolygonToRecord(value, ballerinaType.getName());
            } catch (SQLException ex) {
                return ErrorGenerator.getSQLApplicationError(ex.getMessage());
            }
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported Ballerina type " + ballerinaType);
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
            return ErrorGenerator.getSQLApplicationError("Unsupported Ballerina type " + ballerinaType);
        }
    }

    public static Object convertUuidType(Object value, int sqlType, Type ballerinaType) {
        return convertPGObjectTypes(value, sqlType, ballerinaType);
    }

    public static Object convertTsvectorType(Object value, int sqlType, Type ballerinaType) {
        return convertPGObjectTypes(value, sqlType, ballerinaType);
    }

    public static Object convertTsqueryType(Object value, int sqlType, Type ballerinaType) {
        return convertPGObjectTypes(value, sqlType, ballerinaType);
    }

    public static Object convertJsonType(Object value, int sqlType, Type ballerinaType) {
        return convertJsonTypes(value, sqlType, ballerinaType);
    }

    public static Object convertJsonbType(Object value, int sqlType, Type ballerinaType) {
        return convertJsonTypes(value, sqlType, ballerinaType);
    }

    public static Object convertJsonpathType(Object value, int sqlType, Type ballerinaType) {
        return convertPGObjectTypes(value, sqlType, ballerinaType);
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
            return ErrorGenerator.getSQLApplicationError("Unsupported Ballerina type " + ballerinaType);
        }
    }

    public static Object convertInt4rangeType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            try {
                return ConvertorUtils.convertInt4rangeToRecord(value, ballerinaType.getName());
            } catch (SQLException ex) {
                return ErrorGenerator.getSQLApplicationError(ex.getMessage());
            }
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported Ballerina type " + sqlType);
        }
    }

    public static Object convertInt8rangeType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            try {
                return ConvertorUtils.convertInt8rangeToRecord(value, ballerinaType.getName());
            } catch (SQLException ex) {
                return ErrorGenerator.getSQLApplicationError(ex.getMessage());
            }
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported Ballerina type " + sqlType);
        }
    }

    public static Object convertNumrangeType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            try {
                return ConvertorUtils.convertNumrangeToRecord(value, ballerinaType.getName());
            } catch (SQLException ex) {
                return ErrorGenerator.getSQLApplicationError(ex.getMessage());
            }
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported Ballerina type " + sqlType);
        }
    }

    public static Object convertTsrangeType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            try {
                return ConvertorUtils.converTsrangeToRecord(value, ballerinaType.getName());
            } catch (SQLException ex) {
                return ErrorGenerator.getSQLApplicationError("Unsupported Ballerina type " + sqlType);
            }
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported Ballerina type " + sqlType);
        }
    }

    public static Object convertTstzrangeType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            try {
                return ConvertorUtils.convertTstzrangeToRecord(value, ballerinaType.getName());
            } catch (SQLException ex) {
                return ErrorGenerator.getSQLApplicationError("Unsupported Ballerina type " + sqlType);
            }
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported Ballerina type " + sqlType);
        }
    }

    public static Object convertDaterangeType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            try {
                return ConvertorUtils.convertDaterangeToRecord(value, ballerinaType.getName());
            } catch (SQLException ex) {
                return ErrorGenerator.getSQLApplicationError("Unsupported Ballerina type " + ballerinaType);
            }
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported Ballerina type " + sqlType);
        }
    }

    public static Object convertPGbitType(Object value, int sqlType, Type ballerinaType) {
        return convertPGObjectTypes(value, sqlType, ballerinaType);
    }

    public static Object convertBitstringType(Object value, int sqlType, Type ballerinaType) {
        return convertPGObjectTypes(value, sqlType, ballerinaType);
    }

    public static Object convertVarbitstringType(Object value, int sqlType, Type ballerinaType) {
        return convertPGObjectTypes(value, sqlType, ballerinaType);
    }

    public static Object convertPglsnType(Object value, int sqlType, Type ballerinaType) {
        return convertPGObjectTypes(value, sqlType, ballerinaType);
    }


    public static Object convertRegclassType(Object value, int sqlType, Type ballerinaType) {
        return convertPGObjectTypes(value, sqlType, ballerinaType);
    }

    public static Object convertRegconfigType(Object value, int sqlType, Type ballerinaType) {
        return convertPGObjectTypes(value, sqlType, ballerinaType);
    }

    public static Object convertRegdictionaryType(Object value, int sqlType, Type ballerinaType) {
        return convertPGObjectTypes(value, sqlType, ballerinaType);
    }

    public static Object convertRegnamespaceType(Object value, int sqlType, Type ballerinaType) {
        return convertPGObjectTypes(value, sqlType, ballerinaType);
    }

    public static Object convertRegoperType(Object value, int sqlType, Type ballerinaType) {
        return convertPGObjectTypes(value, sqlType, ballerinaType);
    }

    public static Object convertRegoperatorType(Object value, int sqlType, Type ballerinaType) {
        return convertPGObjectTypes(value, sqlType, ballerinaType);
    }

    public static Object convertRegprocType(Object value, int sqlType, Type ballerinaType) {
        return convertPGObjectTypes(value, sqlType, ballerinaType);
    }

    public static Object convertRegprocedureType(Object value, int sqlType, Type ballerinaType) {
        return convertPGObjectTypes(value, sqlType, ballerinaType);
    }

    public static Object convertRegroleType(Object value, int sqlType, Type ballerinaType) {
        return convertPGObjectTypes(value, sqlType, ballerinaType);
    }

    public static Object convertRegtypeType(Object value, int sqlType, Type ballerinaType) {
        return convertPGObjectTypes(value, sqlType, ballerinaType);
    }


    public static Object convertNetworkTypes(Object value, int sqlType, Type ballerinaType) {
        return convertPGObjectTypes(value, sqlType, ballerinaType);
    }

    public static Object convertJsonTypes(Object value, int sqlType, Type ballerinaType) {
        try {
            if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
                return fromString(String.valueOf(value.toString()));
            } else if (ballerinaType.getTag() == TypeTags.JSON_TAG) {
                return ConvertorUtils.getJsonValue(value);
            } else {
                return ErrorGenerator.getSQLApplicationError("Unsupported Ballerina type " + ballerinaType);
            }
        } catch (SQLException ex) {
            return ErrorGenerator.getSQLApplicationError(ex.getMessage());
        } catch (ApplicationError ex) {
            return ErrorGenerator.getSQLApplicationError(ex.getMessage());
        }
    }

    public static Object convertPGObjectTypes(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported Ballerina type " + ballerinaType);
        }
    }

    protected BObject getIteratorObject() {
        if (iteratorObject == null) {
            synchronized (lock2) {
                if (iteratorObject == null) {
                    iteratorObject = ValueCreator.createObjectValue(
                            ModuleUtils.getModule(), "CustomResultIterator", new Object[0]);
                }
            }
        }
        return iteratorObject;
    }

    public BObject createRecordIterator(ResultSet resultSet, Statement statement, Connection connection, 
                    List<ColumnDefinition> columnDefinitions, StructureType streamConstraint) {
        BObject iteratorObject = this.getIteratorObject();
        BObject resultIterator = ValueCreator.createObjectValue(org.ballerinalang.sql.utils.ModuleUtils.getModule(),
                org.ballerinalang.sql.Constants.RESULT_ITERATOR_OBJECT, new Object[]{null, iteratorObject});
        resultIterator.addNativeData(org.ballerinalang.sql.Constants.RESULT_SET_NATIVE_DATA_FIELD, resultSet);
        resultIterator.addNativeData(org.ballerinalang.sql.Constants.STATEMENT_NATIVE_DATA_FIELD, statement);
        resultIterator.addNativeData(org.ballerinalang.sql.Constants.CONNECTION_NATIVE_DATA_FIELD, connection);
        resultIterator.addNativeData(org.ballerinalang.sql.Constants.COLUMN_DEFINITIONS_DATA_FIELD, columnDefinitions);
        resultIterator.addNativeData(org.ballerinalang.sql.Constants.RECORD_TYPE_DATA_FIELD, streamConstraint);
        return resultIterator;
    }

    public Object getCustomResult(ResultSet resultSet, int columnIndex, ColumnDefinition columnDefinition)
            throws ApplicationError {
        Type ballerinaType = columnDefinition.getBallerinaType();
        try {
            Object value = resultSet.getObject(columnIndex);
            switch (ballerinaType.getName()) {
                case Constants.TypeRecordNames.POINTRECORD:
                    return ConvertorUtils.convertPointToRecord(value, ballerinaType.getName());
                case Constants.TypeRecordNames.LINEEQUATION:
                    return ConvertorUtils.convertLineToRecord(value, ballerinaType.getName());
                case Constants.TypeRecordNames.LSEGRECORD:
                    return ConvertorUtils.convertLsegToRecord(value, ballerinaType.getName());
                case Constants.TypeRecordNames.BOXRECORD:
                    return ConvertorUtils.convertBoxToRecord(value, ballerinaType.getName());
                case Constants.TypeRecordNames.PATHRECORD:
                    return ConvertorUtils.convertPathToRecord(value, ballerinaType.getName());
                case Constants.TypeRecordNames.POLYGONRECORD:
                    return ConvertorUtils.convertPolygonToRecord(value, ballerinaType.getName());
                case Constants.TypeRecordNames.CIRCLERECORD:
                    return ConvertorUtils.convertCircleToRecord(value, ballerinaType.getName());
                case Constants.TypeRecordNames.INTERVALRECORD:
                    return ConvertorUtils.convertIntervalToRecord(value, ballerinaType.getName());
                case Constants.TypeRecordNames.INT4RANGERECORD:
                    return ConvertorUtils.convertInt4rangeToRecord(value, ballerinaType.getName());
                case Constants.TypeRecordNames.INT8RANGERECORD:
                    return ConvertorUtils.convertInt8rangeToRecord(value, ballerinaType.getName());
                case Constants.TypeRecordNames.NUMRANGERECORD:
                    return ConvertorUtils.convertNumrangeToRecord(value, ballerinaType.getName());
                case Constants.TypeRecordNames.TIMESTAMPRANGERECORD:
                    return ConvertorUtils.converTsrangeToRecord(value, ballerinaType.getName());
                case Constants.TypeRecordNames.TIMESTAMPTZRANGERECORD:
                    return ConvertorUtils.convertTstzrangeToRecord(value, ballerinaType.getName());
                case Constants.TypeRecordNames.DATERANGERECORD:
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
