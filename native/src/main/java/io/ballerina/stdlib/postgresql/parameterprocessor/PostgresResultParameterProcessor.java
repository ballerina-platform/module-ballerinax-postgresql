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

import io.ballerina.runtime.api.PredefinedTypes;
import io.ballerina.runtime.api.TypeTags;
import io.ballerina.runtime.api.creators.TypeCreator;
import io.ballerina.runtime.api.creators.ValueCreator;
import io.ballerina.runtime.api.types.ArrayType;
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.utils.XmlUtils;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.stdlib.postgresql.Constants;
import io.ballerina.stdlib.postgresql.utils.ConverterUtils;
import io.ballerina.stdlib.postgresql.utils.ModuleUtils;
import io.ballerina.stdlib.sql.exception.ApplicationError;
import io.ballerina.stdlib.sql.parameterprocessor.DefaultResultParameterProcessor;
import io.ballerina.stdlib.sql.utils.ColumnDefinition;
import io.ballerina.stdlib.sql.utils.ErrorGenerator;
import io.ballerina.stdlib.sql.utils.Utils;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLXML;

import static io.ballerina.runtime.api.utils.StringUtils.fromString;

/**
 * This class implements methods required convert SQL types into ballerina types and
 * other methods that process the parameters of the result.
 *
 * @since 0.1.0
 */
public class PostgresResultParameterProcessor extends DefaultResultParameterProcessor {
    private static final PostgresResultParameterProcessor instance = new PostgresResultParameterProcessor();
    private static final BObject iteratorObject = ValueCreator.createObjectValue(
                        ModuleUtils.getModule(), "CustomResultIterator");
    private static final ArrayType stringArrayType = TypeCreator.createArrayType(PredefinedTypes.TYPE_STRING);
    private static final ArrayType jsonArrayType = TypeCreator.createArrayType(PredefinedTypes.TYPE_JSON);
    private static final String ERROR_MSG1 = "Unsupported Ballerina type ";
    
    /**
    * Singleton static method that returns an instance of `PostgresResultParameterProcessor`.
    * @return PostgresResultParameterProcessor
    */
    public static PostgresResultParameterProcessor getInstance() {
        return instance;
    }

    @Override
    protected BArray createAndPopulateCustomValueArray(Object firstNonNullElement, Type type, 
            java.sql.Array array) throws ApplicationError, SQLException {
        String sqlType = ConverterUtils.getArrayType(array);
        Object[] dataArray = (Object[]) array.getArray();
        BArray ballerinaArray;
        switch (sqlType) {
            case Constants.ArrayTypes.POINT:
                ballerinaArray = ValueCreator.createArrayValue(Constants.POINT_ARRAY_TYPE);
                return ConverterUtils.convertPointRecordArray(dataArray, ballerinaArray);
            case Constants.ArrayTypes.LINE:
                ballerinaArray = ValueCreator.createArrayValue(Constants.LINE_ARRAY_TYPE);
                return ConverterUtils.convertLineRecordArray(dataArray, ballerinaArray);
            case Constants.ArrayTypes.LSEG:
                ballerinaArray = ValueCreator.createArrayValue(Constants.LSEG_ARRAY_TYPE);
                return ConverterUtils.convertLsegRecordArray(dataArray, ballerinaArray);
            case Constants.ArrayTypes.BOX:
                ballerinaArray = ValueCreator.createArrayValue(Constants.BOX_ARRAY_TYPE);
                return ConverterUtils.convertBoxRecordArray(dataArray, ballerinaArray);
            case Constants.ArrayTypes.PATH:
                ballerinaArray = ValueCreator.createArrayValue(Constants.PATH_ARRAY_TYPE);
                return ConverterUtils.convertPathRecordArray(dataArray, ballerinaArray);
            case Constants.ArrayTypes.POLYGON:
                ballerinaArray = ValueCreator.createArrayValue(Constants.POLYGON_ARRAY_TYPE);
                return ConverterUtils.convertPolygonRecordArray(dataArray, ballerinaArray);
            case Constants.ArrayTypes.CIRCLE:
                ballerinaArray = ValueCreator.createArrayValue(Constants.CIRCLE_ARRAY_TYPE);
                return ConverterUtils.convertCircleRecordArray(dataArray, ballerinaArray);
            case Constants.ArrayTypes.INTERVAL:
                ballerinaArray = ValueCreator.createArrayValue(Constants.INTERVAL_ARRAY_TYPE);
                return ConverterUtils.convertIntervalRecordArray(dataArray, ballerinaArray);
            case Constants.ArrayTypes.INT4RANGE:
                ballerinaArray = ValueCreator.createArrayValue(Constants.INTEGER_RANGE_ARRAY_TYPE);
                return ConverterUtils.convertInt4RangeRecordArray(dataArray, ballerinaArray);
            case Constants.ArrayTypes.INT8RANGE:
                ballerinaArray = ValueCreator.createArrayValue(Constants.LONG_RANGE_ARRAY_TYPE);
                return ConverterUtils.convertInt8RangeRecordArray(dataArray, ballerinaArray);
            case Constants.ArrayTypes.NUMRANGE:
                ballerinaArray = ValueCreator.createArrayValue(Constants.NUMERICAL_RANGE_ARRAY_TYPE);
                return ConverterUtils.convertNumRangeRecordArray(dataArray, ballerinaArray);
            case Constants.ArrayTypes.TSRANGE:
                ballerinaArray = ValueCreator.createArrayValue(Constants.TS_RANGE_ARRAY_TYPE);
                return ConverterUtils.convertTsRangeRecordArray(dataArray, ballerinaArray);
            case Constants.ArrayTypes.TSTZRANGE:
                ballerinaArray = ValueCreator.createArrayValue(Constants.TS_TZ_RANGE_ARRAY_TYPE);
                return ConverterUtils.convertTstzRangeRecordArray(dataArray, ballerinaArray);
            case Constants.ArrayTypes.DATERANGE:
                ballerinaArray = ValueCreator.createArrayValue(Constants.DATE_RANGE_ARRAY_TYPE);
                return ConverterUtils.convertDateRangeRecordArray(dataArray, ballerinaArray);
            case Constants.ArrayTypes.INET:
            case Constants.ArrayTypes.CIDR:
            case Constants.ArrayTypes.MACADDR:
            case Constants.ArrayTypes.MACADDR8:
            case Constants.ArrayTypes.UUID:
            case Constants.ArrayTypes.TSVECTOR:
            case Constants.ArrayTypes.TSQUERY:
            case Constants.ArrayTypes.BITSTRING:
            case Constants.ArrayTypes.BIT_VARYING:
            case Constants.ArrayTypes.REGCLASS:
            case Constants.ArrayTypes.REGCONFIG:
            case Constants.ArrayTypes.REGDICTIONARY:
            case Constants.ArrayTypes.REGNAMESPACE:
            case Constants.ArrayTypes.REGOPER:
            case Constants.ArrayTypes.REGOPERATOR:
            case Constants.ArrayTypes.REGPROC:
            case Constants.ArrayTypes.REGPROCEDURE:
            case Constants.ArrayTypes.REGROLE:
            case Constants.ArrayTypes.REGTYPE:
            case Constants.ArrayTypes.XML:
            case Constants.ArrayTypes.JSONPATH:
            case Constants.ArrayTypes.PGLSN:
                ballerinaArray = ValueCreator.createArrayValue(stringArrayType);
                return ConverterUtils.convertStringArray(dataArray, ballerinaArray);
            case Constants.ArrayTypes.JSON:
            case Constants.ArrayTypes.JSONB:
                ballerinaArray = ValueCreator.createArrayValue(jsonArrayType);
                return ConverterUtils.convertJsonArray(dataArray, ballerinaArray);
            default:
                throw new ApplicationError("Unsupported Array type: " + sqlType);
        }
    }

    @Override
    protected BArray createAndPopulateCustomBBRefValueArray(Object firstNonNullElement,
            Type type, java.sql.Array array) throws ApplicationError, SQLException {
        String sqlType = ConverterUtils.getArrayType(array);
        Object[] dataArray = (Object[]) array.getArray();
        BArray ballerinaArray;
        switch (sqlType) {
            case Constants.ArrayTypes.POINT:
                ballerinaArray = createEmptyBBRefValueArray(Constants.POINT_RECORD_TYPE);
                return ConverterUtils.convertPointRecordArray(dataArray, ballerinaArray);
            case Constants.ArrayTypes.LINE:
                ballerinaArray = createEmptyBBRefValueArray(Constants.LINE_RECORD_TYPE);
                return ConverterUtils.convertLineRecordArray(dataArray, ballerinaArray);
            case Constants.ArrayTypes.LSEG:
                ballerinaArray = createEmptyBBRefValueArray(Constants.LSEG_RECORD_TYPE);
                return ConverterUtils.convertLsegRecordArray(dataArray, ballerinaArray);
            case Constants.ArrayTypes.BOX:
                ballerinaArray = createEmptyBBRefValueArray(Constants.BOX_RECORD_TYPE);
                return ConverterUtils.convertBoxRecordArray(dataArray, ballerinaArray);
            case Constants.ArrayTypes.PATH:
                ballerinaArray = createEmptyBBRefValueArray(Constants.PATH_RECORD_TYPE);
                return ConverterUtils.convertPathRecordArray(dataArray, ballerinaArray);
            case Constants.ArrayTypes.POLYGON:
                ballerinaArray = createEmptyBBRefValueArray(Constants.POLYGON_RECORD_TYPE);
                return ConverterUtils.convertPolygonRecordArray(dataArray, ballerinaArray);
            case Constants.ArrayTypes.CIRCLE:
                ballerinaArray = createEmptyBBRefValueArray(Constants.CIRCLE_RECORD_TYPE);
                return ConverterUtils.convertCircleRecordArray(dataArray, ballerinaArray);
            case Constants.ArrayTypes.INTERVAL:
                ballerinaArray = createEmptyBBRefValueArray(Constants.INTERVAL_RECORD_TYPE);
                return ConverterUtils.convertIntervalRecordArray(dataArray, ballerinaArray);
            case Constants.ArrayTypes.INT4RANGE:
                ballerinaArray = createEmptyBBRefValueArray(Constants.INTEGER_RANGE_RECORD_TYPE);
                return ConverterUtils.convertInt4RangeRecordArray(dataArray, ballerinaArray);
            case Constants.ArrayTypes.INT8RANGE:
                ballerinaArray = createEmptyBBRefValueArray(Constants.LONG_RANGE_RECORD_TYPE);
                return ConverterUtils.convertInt8RangeRecordArray(dataArray, ballerinaArray);
            case Constants.ArrayTypes.NUMRANGE:
                ballerinaArray = createEmptyBBRefValueArray(Constants.NUMERICAL_RANGE_RECORD_TYPE);
                return ConverterUtils.convertNumRangeRecordArray(dataArray, ballerinaArray);
            case Constants.ArrayTypes.TSRANGE:
                ballerinaArray = createEmptyBBRefValueArray(Constants.TS_RANGE_RECORD_TYPE);
                return ConverterUtils.convertTsRangeRecordArray(dataArray, ballerinaArray);
            case Constants.ArrayTypes.TSTZRANGE:
                ballerinaArray = createEmptyBBRefValueArray(Constants.TS_TZ_RANGE_RECORD_TYPE);
                return ConverterUtils.convertTstzRangeRecordArray(dataArray, ballerinaArray);
            case Constants.ArrayTypes.DATERANGE:
                ballerinaArray = createEmptyBBRefValueArray(Constants.DATE_RANGE_RECORD_TYPE);
                return ConverterUtils.convertDateRangeRecordArray(dataArray, ballerinaArray);
            case Constants.ArrayTypes.INET:
            case Constants.ArrayTypes.CIDR:
            case Constants.ArrayTypes.MACADDR:
            case Constants.ArrayTypes.MACADDR8:
            case Constants.ArrayTypes.UUID:
            case Constants.ArrayTypes.TSVECTOR:
            case Constants.ArrayTypes.TSQUERY:
            case Constants.ArrayTypes.BITSTRING:
            case Constants.ArrayTypes.BIT_VARYING:
            case Constants.ArrayTypes.REGCLASS:
            case Constants.ArrayTypes.REGCONFIG:
            case Constants.ArrayTypes.REGDICTIONARY:
            case Constants.ArrayTypes.REGNAMESPACE:
            case Constants.ArrayTypes.REGOPER:
            case Constants.ArrayTypes.REGOPERATOR:
            case Constants.ArrayTypes.REGPROC:
            case Constants.ArrayTypes.REGPROCEDURE:
            case Constants.ArrayTypes.REGROLE:
            case Constants.ArrayTypes.REGTYPE:
            case Constants.ArrayTypes.XML:
            case Constants.ArrayTypes.JSONPATH:
            case Constants.ArrayTypes.PGLSN:
                ballerinaArray = createEmptyBBRefValueArray(PredefinedTypes.TYPE_STRING);
                return ConverterUtils.convertStringArray(dataArray, ballerinaArray);
            case Constants.ArrayTypes.JSON:
            case Constants.ArrayTypes.JSONB:
            ballerinaArray = createEmptyBBRefValueArray(PredefinedTypes.TYPE_JSON);
                return ConverterUtils.convertJsonArray(dataArray, ballerinaArray);
            default:
                throw new ApplicationError("Unsupported Array type: " + sqlType);
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

    @Override
    public void populateBinary(CallableStatement statement, BObject parameter, int paramIndex)
            throws SQLException {
        parameter.addNativeData(io.ballerina.stdlib.sql.Constants.ParameterObject.VALUE_NATIVE_DATA,
                statement.getBytes(paramIndex));
    }

    public void populateObject(CallableStatement statement, BObject parameter, int paramIndex) throws SQLException {
        parameter.addNativeData(io.ballerina.stdlib.sql.Constants.ParameterObject.VALUE_NATIVE_DATA,
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

    public Object getInoutParameters(BObject result, int sqlType, Type ballerinaType) {
        Object innerObject = result.get(io.ballerina.stdlib.sql.Constants.ParameterObject.IN_VALUE_FIELD);
        Object value = result.getNativeData(io.ballerina.stdlib.sql.Constants.ParameterObject.VALUE_NATIVE_DATA);
        BObject innerBobject;
        if (innerObject instanceof BObject) {
            innerBobject = (BObject) innerObject;
            String sqlTypeName = innerBobject.getType().getName();
            switch(sqlTypeName) {
                case Constants.PGTypeNames.INET:
                    return convertInetType(value, ballerinaType);
                case Constants.PGTypeNames.CIDR:
                    return convertCidrType(value, ballerinaType);
                case Constants.PGTypeNames.MACADDR:
                    return convertMacAddrType(value, ballerinaType);
                case Constants.PGTypeNames.MACADDR8:
                    return convertMacAddr8Type(value, ballerinaType);
                case Constants.PGTypeNames.POINT:
                    return convertPointType(value, ballerinaType);
                case Constants.PGTypeNames.LINE:
                    return convertLineType(value, ballerinaType);
                case Constants.PGTypeNames.LSEG:
                    return convertLineSegType(value, ballerinaType);
                case Constants.PGTypeNames.BOX:
                    return convertBoxType(value, ballerinaType);
                case Constants.PGTypeNames.PATH:
                    return convertPathType(value, ballerinaType);
                case Constants.PGTypeNames.POLYGON:
                    return convertPolygonType(value, ballerinaType);
                case Constants.PGTypeNames.CIRCLE:
                    return convertCircleType(value, ballerinaType);
                case Constants.PGTypeNames.UUID:
                    return convertUuidType(value, ballerinaType);
                case Constants.PGTypeNames.TSVECTOR:
                    return convertTsVectorType(value, ballerinaType);
                case Constants.PGTypeNames.TSQUERY:
                    return convertTsQueryType(value, ballerinaType);
                case Constants.PGTypeNames.JSON:
                    return convertJsonType(value, ballerinaType);
                case Constants.PGTypeNames.JSONB:
                    return convertJsonbType(value, ballerinaType);
                case Constants.PGTypeNames.JSON_PATH:
                    return convertJsonPathType(value, ballerinaType);
                case Constants.PGTypeNames.INTERVAL:
                    return convertIntervalType(value, ballerinaType);
                case Constants.PGTypeNames.INT4RANGE:
                    return convertInt4rangeType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.INT8RANGE:
                    return convertInt8rangeType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.NUMRANGE:
                    return convertNumRangeType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.TSRANGE:
                    return convertTsRangeType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.TSTZRANGE:
                    return convertTstzrangeType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.DATERANGE:
                    return convertDateRangeType(value, sqlType, ballerinaType);
                case Constants.PGTypeNames.PGBIT:
                    return convertPGbitType(value, ballerinaType);
                case Constants.PGTypeNames.BITSTRING:
                    return convertBitStringType(value, ballerinaType);
                case Constants.PGTypeNames.VARBITSTRING:
                    return convertVarBitStringType(value, ballerinaType);
                case Constants.PGTypeNames.PGLSN:
                    return convertPglsnType(value, ballerinaType);
                case Constants.PGTypeNames.REGCLASS:
                    return convertRegClassType(value, ballerinaType);
                case Constants.PGTypeNames.REGCONFIG:
                    return convertRegConfigType(value, ballerinaType);
                case Constants.PGTypeNames.REGDICTIONARY:
                    return convertRegdictionaryType(value, ballerinaType);
                case Constants.PGTypeNames.REGNAMESPACE:
                    return convertRegNamespaceType(value, ballerinaType);
                case Constants.PGTypeNames.REGOPER:
                    return convertRegOperType(value, ballerinaType);
                case Constants.PGTypeNames.REG_OPERATOR:
                    return convertRegOperatorType(value, ballerinaType);
                case Constants.PGTypeNames.REG_PROC:
                    return convertRegProcType(value, ballerinaType);
                case Constants.PGTypeNames.REG_PROCEDURE:
                    return convertRegProcedureType(value, ballerinaType);
                case Constants.PGTypeNames.REG_ROLE:
                    return convertRegRoleType(value, ballerinaType);
                case Constants.PGTypeNames.REG_TYPE:
                    return convertRegTypeType(value, ballerinaType);
                default:
                    return ErrorGenerator.getSQLApplicationError("Unsupported InOutParameter type for " + sqlTypeName);
            }
        } else {
            return ErrorGenerator.getSQLApplicationError("Unsupported InOutParameter type for " + sqlType);
        }
    }

    public Object getOutParameters(BObject result, int sqlType, Type ballerinaType) {
        String outParameterName = result.getType().getName();
        Object value = result.getNativeData(io.ballerina.stdlib.sql.Constants.ParameterObject.VALUE_NATIVE_DATA);
        switch(outParameterName) {
            case Constants.OutParameterNames.INET:
                return convertInetType(value, ballerinaType);
            case Constants.OutParameterNames.CIDR:
                return convertCidrType(value, ballerinaType);
            case Constants.OutParameterNames.MACADDR:
                return convertMacAddrType(value, ballerinaType);
            case Constants.OutParameterNames.MACADDR8:
                return convertMacAddr8Type(value, ballerinaType);
            case Constants.OutParameterNames.POINT:
                return convertPointType(value, ballerinaType);
            case Constants.OutParameterNames.LINE:
                return convertLineType(value, ballerinaType);
            case Constants.OutParameterNames.LSEG:
                return convertLineSegType(value, ballerinaType);
            case Constants.OutParameterNames.BOX:
                return convertBoxType(value, ballerinaType);
            case Constants.OutParameterNames.PATH:
                return convertPathType(value, ballerinaType);
            case Constants.OutParameterNames.POLYGON:
                return convertPolygonType(value, ballerinaType);
            case Constants.OutParameterNames.CIRCLE:
                return convertCircleType(value, ballerinaType);
            case Constants.OutParameterNames.UUID:
                return convertUuidType(value, ballerinaType);
            case Constants.OutParameterNames.TSVECTOR:
                return convertTsVectorType(value, ballerinaType);
            case Constants.OutParameterNames.TSQUERY:
                return convertTsQueryType(value, ballerinaType);
            case Constants.OutParameterNames.JSON:
                return convertJsonType(value, ballerinaType);
            case Constants.OutParameterNames.JSONB:
                return convertJsonbType(value, ballerinaType);
            case Constants.OutParameterNames.JSONPATH:
                return convertJsonPathType(value, ballerinaType);
            case Constants.OutParameterNames.INTERVAL:
                return convertIntervalType(value, ballerinaType);
            case Constants.OutParameterNames.INT4RANGE:
                return convertInt4rangeType(value, sqlType, ballerinaType);
            case Constants.OutParameterNames.INT8RANGE:
                return convertInt8rangeType(value, sqlType, ballerinaType);
            case Constants.OutParameterNames.NUMRANGE:
                return convertNumRangeType(value, sqlType, ballerinaType);
            case Constants.OutParameterNames.TSRANGE:
                return convertTsRangeType(value, sqlType, ballerinaType);
            case Constants.OutParameterNames.TSTZRANGE:
                return convertTstzrangeType(value, sqlType, ballerinaType);
            case Constants.OutParameterNames.DATERANGE:
                return convertDateRangeType(value, sqlType, ballerinaType);
            case Constants.OutParameterNames.PGBIT:
                return convertPGbitType(value, ballerinaType);
            case Constants.OutParameterNames.BITSTRING:
                return convertBitStringType(value, ballerinaType);
            case Constants.OutParameterNames.VARBITSTRING:
                return convertVarBitStringType(value, ballerinaType);
            case Constants.OutParameterNames.PGLSN:
                return convertPglsnType(value, ballerinaType);
            case Constants.OutParameterNames.REGCLASS:
                return convertRegClassType(value, ballerinaType);
            case Constants.OutParameterNames.REGCONFIG:
                return convertRegConfigType(value, ballerinaType);
            case Constants.OutParameterNames.REGDICTIONARY:
                return convertRegdictionaryType(value, ballerinaType);
            case Constants.OutParameterNames.REGNAMESPACE:
                return convertRegNamespaceType(value, ballerinaType);
            case Constants.OutParameterNames.REGOPER:
                return convertRegOperType(value, ballerinaType);
            case Constants.OutParameterNames.REGOPERATOR:
                return convertRegOperatorType(value, ballerinaType);
            case Constants.OutParameterNames.REGPROC:
                return convertRegProcType(value, ballerinaType);
            case Constants.OutParameterNames.REGPROCEDURE:
                return convertRegProcedureType(value, ballerinaType);
            case Constants.OutParameterNames.REGROLE:
                return convertRegRoleType(value, ballerinaType);
            case Constants.OutParameterNames.REGTYPE:
                return convertRegTypeType(value, ballerinaType);
            case Constants.OutParameterNames.BINARY:
                try {
                    return convertBinary(value, sqlType, ballerinaType);
                } catch (ApplicationError ex) {
                    return ErrorGenerator.getSQLApplicationError(ex.getMessage());
                }
            case Constants.OutParameterNames.XML:
                try {
                    return convertXml((SQLXML) value, sqlType, ballerinaType);
                } catch (ApplicationError | SQLException ex) {
                    return ErrorGenerator.getSQLApplicationError(ex.getMessage());
                }
            default:
                return ErrorGenerator.getSQLApplicationError("Unsupported OutParameter Type " +
                        outParameterName);
            }
    }

    @Override
    public Object convertCustomOutParameters(BObject result, int sqlType, Type ballerinaType) {
        String objectType = result.getType().getName();
        if (objectType.equals(Constants.ParameterObject.INOUT_PARAMETER)) {
            return getInoutParameters(result, sqlType, ballerinaType);
        } else if (objectType.endsWith(Constants.ParameterObject.OUT_PARAMETER_SUFFIX)) {
            return getOutParameters(result, sqlType, ballerinaType);
        } else {
            return ErrorGenerator.getSQLApplicationError(ERROR_MSG1 + objectType);
        }
    }

    @Override
    public Object convertBinary(Object value, int sqlType, Type ballerinaType) throws ApplicationError {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return convertChar(value.toString(), sqlType, ballerinaType);
        } else {
            return ErrorGenerator.getSQLApplicationError(ERROR_MSG1 + ballerinaType);
        }
    }

    public static Object convertInetType(Object value, Type ballerinaType) {
        return convertNetworkTypes(value, ballerinaType);
    }

    public static Object convertCidrType(Object value, Type ballerinaType) {
        return convertNetworkTypes(value, ballerinaType);
    }

    public static Object convertMacAddrType(Object value, Type ballerinaType) {
        return convertNetworkTypes(value, ballerinaType);
    }

    public static Object convertMacAddr8Type(Object value, Type ballerinaType) {
        return convertNetworkTypes(value, ballerinaType);
    }

    public static Object convertPointType(Object value, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            try {
                return ConverterUtils.convertPointToRecord(value, ballerinaType.getName());
            } catch (SQLException ex) {
                return ErrorGenerator.getSQLApplicationError(ex.getMessage());
            }
        } else {
            return ErrorGenerator.getSQLApplicationError(ERROR_MSG1 + ballerinaType);
        }
    }

    public static Object convertLineType(Object value, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            try {
                return ConverterUtils.convertLineToRecord(value, ballerinaType.getName());
            } catch (SQLException ex) {
                return ErrorGenerator.getSQLApplicationError(ex.getMessage());
            }
        } else {
            return ErrorGenerator.getSQLApplicationError(ERROR_MSG1 + ballerinaType);
        }
    }

    public static Object convertLineSegType(Object value, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            try {
                return ConverterUtils.convertLsegToRecord(value, ballerinaType.getName());
            } catch (SQLException ex) {
                return ErrorGenerator.getSQLApplicationError(ex.getMessage());
            }
        } else {
            return ErrorGenerator.getSQLApplicationError(ERROR_MSG1 + ballerinaType);
        }
    }

    public static Object convertBoxType(Object value, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            try {
                return ConverterUtils.convertBoxToRecord(value, ballerinaType.getName());
            } catch (SQLException ex) {
                return ErrorGenerator.getSQLApplicationError(ex.getMessage());
            }
        } else {
            return ErrorGenerator.getSQLApplicationError(ERROR_MSG1 + ballerinaType);
        }
    }

    public static Object convertPathType(Object value, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            try {
                return ConverterUtils.convertPathToRecord(value, ballerinaType.getName());
            } catch (SQLException ex) {
                return ErrorGenerator.getSQLApplicationError(ex.getMessage());
            }
        } else {
            return ErrorGenerator.getSQLApplicationError(ERROR_MSG1 + ballerinaType);
        }
    }

    public static Object convertPolygonType(Object value, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            try {
                return ConverterUtils.convertPolygonToRecord(value, ballerinaType.getName());
            } catch (SQLException ex) {
                return ErrorGenerator.getSQLApplicationError(ex.getMessage());
            }
        } else {
            return ErrorGenerator.getSQLApplicationError(ERROR_MSG1 + ballerinaType);
        }
    }

    public static Object convertCircleType(Object value, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            try {
                return ConverterUtils.convertCircleToRecord(value, ballerinaType.getName());
            } catch (SQLException ex) {
                return ErrorGenerator.getSQLApplicationError(ex.getMessage());
            }
        } else {
            return ErrorGenerator.getSQLApplicationError(ERROR_MSG1 + ballerinaType);
        }
    }

    public static Object convertUuidType(Object value, Type ballerinaType) {
        return convertPGObjectTypes(value, ballerinaType);
    }

    public static Object convertTsVectorType(Object value, Type ballerinaType) {
        return convertPGObjectTypes(value, ballerinaType);
    }

    public static Object convertTsQueryType(Object value, Type ballerinaType) {
        return convertPGObjectTypes(value, ballerinaType);
    }

    public static Object convertJsonType(Object value, Type ballerinaType) {
        return convertJsonTypes(value, ballerinaType);
    }

    public static Object convertJsonbType(Object value, Type ballerinaType) {
        return convertJsonTypes(value, ballerinaType);
    }

    public static Object convertJsonPathType(Object value, Type ballerinaType) {
        return convertPGObjectTypes(value, ballerinaType);
    }

    public static Object convertIntervalType(Object value, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            try {
                return ConverterUtils.convertIntervalToRecord(value, ballerinaType.getName());
            } catch (SQLException ex) {
                return ErrorGenerator.getSQLApplicationError(ex.getMessage());
            }
        } else {
            return ErrorGenerator.getSQLApplicationError(ERROR_MSG1 + ballerinaType);
        }
    }

    public static Object convertInt4rangeType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            return ConverterUtils.convertInt4rangeToRecord(value, ballerinaType.getName());
        } else {
            return ErrorGenerator.getSQLApplicationError(ERROR_MSG1 + sqlType);
        }
    }

    public static Object convertInt8rangeType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            return ConverterUtils.convertInt8rangeToRecord(value, ballerinaType.getName());
        } else {
            return ErrorGenerator.getSQLApplicationError(ERROR_MSG1 + sqlType);
        }
    }

    public static Object convertNumRangeType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            return ConverterUtils.convertNumRangeToRecord(value, ballerinaType.getName());
        } else {
            return ErrorGenerator.getSQLApplicationError(ERROR_MSG1 + sqlType);
        }
    }

    public static Object convertTsRangeType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            try {
                return ConverterUtils.converTsrangeToRecord(value, ballerinaType.getName());
            } catch (SQLException ex) {
                return ErrorGenerator.getSQLApplicationError(ERROR_MSG1 + sqlType);
            }
        } else {
            return ErrorGenerator.getSQLApplicationError(ERROR_MSG1 + sqlType);
        }
    }

    public static Object convertTstzrangeType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            try {
                return ConverterUtils.convertTstzrangeToRecord(value, ballerinaType.getName());
            } catch (SQLException ex) {
                return ErrorGenerator.getSQLApplicationError(ERROR_MSG1 + sqlType);
            }
        } else {
            return ErrorGenerator.getSQLApplicationError(ERROR_MSG1 + sqlType);
        }
    }

    public static Object convertDateRangeType(Object value, int sqlType, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else if (ballerinaType.getTag() == TypeTags.RECORD_TYPE_TAG) {
            try {
                return ConverterUtils.convertDaterangeToRecord(value, ballerinaType.getName());
            } catch (SQLException ex) {
                return ErrorGenerator.getSQLApplicationError(ERROR_MSG1 + ballerinaType);
            }
        } else {
            return ErrorGenerator.getSQLApplicationError(ERROR_MSG1 + sqlType);
        }
    }

    public static Object convertPGbitType(Object value, Type ballerinaType) {
        return convertPGObjectTypes(value, ballerinaType);
    }

    public static Object convertBitStringType(Object value, Type ballerinaType) {
        return convertPGObjectTypes(value, ballerinaType);
    }

    public static Object convertVarBitStringType(Object value, Type ballerinaType) {
        return convertPGObjectTypes(value, ballerinaType);
    }

    public static Object convertPglsnType(Object value, Type ballerinaType) {
        return convertPGObjectTypes(value, ballerinaType);
    }

    public static Object convertRegClassType(Object value, Type ballerinaType) {
        return convertPGObjectTypes(value, ballerinaType);
    }

    public static Object convertRegConfigType(Object value, Type ballerinaType) {
        return convertPGObjectTypes(value, ballerinaType);
    }

    public static Object convertRegdictionaryType(Object value, Type ballerinaType) {
        return convertPGObjectTypes(value, ballerinaType);
    }

    public static Object convertRegNamespaceType(Object value, Type ballerinaType) {
        return convertPGObjectTypes(value, ballerinaType);
    }

    public static Object convertRegOperType(Object value, Type ballerinaType) {
        return convertPGObjectTypes(value, ballerinaType);
    }

    public static Object convertRegOperatorType(Object value, Type ballerinaType) {
        return convertPGObjectTypes(value,  ballerinaType);
    }

    public static Object convertRegProcType(Object value, Type ballerinaType) {
        return convertPGObjectTypes(value, ballerinaType);
    }

    public static Object convertRegProcedureType(Object value, Type ballerinaType) {
        return convertPGObjectTypes(value, ballerinaType);
    }

    public static Object convertRegRoleType(Object value, Type ballerinaType) {
        return convertPGObjectTypes(value, ballerinaType);
    }

    public static Object convertRegTypeType(Object value, Type ballerinaType) {
        return convertPGObjectTypes(value, ballerinaType);
    }


    public static Object convertNetworkTypes(Object value, Type ballerinaType) {
        return convertPGObjectTypes(value, ballerinaType);
    }

    public static Object convertJsonTypes(Object value, Type ballerinaType) {
        try {
            if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
                return fromString(String.valueOf(value.toString()));
            } else if (ballerinaType.getTag() == TypeTags.JSON_TAG) {
                return ConverterUtils.getJsonValue(value);
            } else {
                return ErrorGenerator.getSQLApplicationError(ERROR_MSG1 + ballerinaType);
            }
        } catch (ApplicationError ex) {
            return ErrorGenerator.getSQLApplicationError(ex.getMessage());
        }
    }

    public static Object convertPGObjectTypes(Object value, Type ballerinaType) {
        if (ballerinaType.getTag() == TypeTags.STRING_TAG) {
            return fromString(String.valueOf(value.toString()));
        } else {
            return ErrorGenerator.getSQLApplicationError(ERROR_MSG1 + ballerinaType);
        }
    }

    @Override
    public BObject getBalStreamResultIterator() {
        return iteratorObject;
    }

    public Object getCustomResult(ResultSet resultSet, int columnIndex, ColumnDefinition columnDefinition) {
        Type ballerinaType = columnDefinition.getBallerinaType();
        try {
            Object value = resultSet.getObject(columnIndex);
            switch (ballerinaType.getName()) {
                case Constants.TypeRecordNames.POINT_RECORD:
                    return ConverterUtils.convertPointToRecord(value, ballerinaType.getName());
                case Constants.TypeRecordNames.LINE_RECORD:
                    return ConverterUtils.convertLineToRecord(value, ballerinaType.getName());
                case Constants.TypeRecordNames.LINE_SEG_RECORD:
                    return ConverterUtils.convertLsegToRecord(value, ballerinaType.getName());
                case Constants.TypeRecordNames.BOX_RECORD:
                    return ConverterUtils.convertBoxToRecord(value, ballerinaType.getName());
                case Constants.TypeRecordNames.PATH_RECORD:
                    return ConverterUtils.convertPathToRecord(value, ballerinaType.getName());
                case Constants.TypeRecordNames.POLYGON_RECORD:
                    return ConverterUtils.convertPolygonToRecord(value, ballerinaType.getName());
                case Constants.TypeRecordNames.CIRCLE_RECORD:
                    return ConverterUtils.convertCircleToRecord(value, ballerinaType.getName());
                case Constants.TypeRecordNames.INTERVAL_RECORD:
                    return ConverterUtils.convertIntervalToRecord(value, ballerinaType.getName());
                case Constants.TypeRecordNames.INTEGER_RANGE_RECORD:
                    return ConverterUtils.convertInt4rangeToRecord(value, ballerinaType.getName());
                case Constants.TypeRecordNames.LONG_RANGE_RECORD:
                    return ConverterUtils.convertInt8rangeToRecord(value, ballerinaType.getName());
                case Constants.TypeRecordNames.NUMERICAL_RANGE_RECORD:
                    return ConverterUtils.convertNumRangeToRecord(value, ballerinaType.getName());
                case Constants.TypeRecordNames.TIMESTAMPRANGERECORD:
                case Constants.TypeRecordNames.TIMESTAMP_RANGE_RECORD_CIVIL:
                    return ConverterUtils.converTsrangeToRecord(value, ballerinaType.getName());
                case Constants.TypeRecordNames.TIMESTAMPTZRANGERECORD:
                case Constants.TypeRecordNames.TIMESTAMPTZ_RANGE_RECORD_CIVIL:
                    return ConverterUtils.convertTstzrangeToRecord(value, ballerinaType.getName());
                case Constants.TypeRecordNames.DATERANGERECORD:
                case Constants.TypeRecordNames.DATERANGE_RECORD_TYPE:
                    return ConverterUtils.convertDaterangeToRecord(value, ballerinaType.getName());
                default:
                    return ErrorGenerator.getSQLApplicationError("Unsupported type : " +
                            ballerinaType.getName());
            }
        } catch (SQLException ex) {
            return ErrorGenerator.getSQLApplicationError(ex.getMessage());
        }
    }

}
