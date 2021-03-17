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

import io.ballerina.runtime.api.values.BObject;
import org.ballerinalang.postgresql.Constants;
import org.ballerinalang.postgresql.utils.ConvertorUtils;
import org.ballerinalang.sql.exception.ApplicationError;
import org.ballerinalang.sql.parameterprocessor.DefaultStatementParameterProcessor;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Types;

/**
 * Represent the methods for process SQL statements.
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
            case Constants.PGTypeNames.PATH:
            case Constants.PGTypeNames.POLYGON:
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
            case Constants.PGTypeNames.XML:
                return Types.SQLXML;
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

    private void setPath(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertPath(value);
            preparedStatement.setObject(index, object);
        }
    }

    private void setPolygon(PreparedStatement preparedStatement, int index, Object value)
            throws SQLException, ApplicationError {
        if (value == null) {
            preparedStatement.setObject(index, null);
        } else {
            Object object = ConvertorUtils.convertPolygon(value);
            preparedStatement.setObject(index, object);
        }
    }

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
    protected void setBit(PreparedStatement preparedStatement, String sqlType, int index, Object value)
            throws SQLException, ApplicationError {
        super.setBit(preparedStatement, sqlType, index, value);
    }
}
