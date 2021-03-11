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


import io.ballerina.runtime.api.TypeTags;
import io.ballerina.runtime.api.creators.ValueCreator;
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.utils.TypeUtils;
import io.ballerina.runtime.api.values.BDecimal;
import io.ballerina.runtime.api.values.BMap;
import io.ballerina.runtime.api.values.BString;
import org.ballerinalang.postgresql.Constants;
import org.ballerinalang.sql.exception.ApplicationError;
import org.postgresql.core.BaseConnection;
import org.postgresql.geometric.PGbox;
import org.postgresql.geometric.PGcircle;
import org.postgresql.geometric.PGline;
import org.postgresql.geometric.PGlseg;
import org.postgresql.geometric.PGpoint;
import org.postgresql.jdbc.PgSQLXML;
import org.postgresql.util.PGInterval;
import org.postgresql.util.PGmoney;
import org.postgresql.util.PGobject;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.SQLXML;
import java.util.HashMap;
import java.util.Map;

/**
 * This class implements the utils methods for the clients to be used.
 */

public class ConvertorUtils {

        private ConvertorUtils() {

        }
        public static PGobject convertInet(Object value) {
            String stringValue = value.toString();
            PGobject inet = setPGobject(Constants.PGtypes.INET, stringValue);
            return inet;
        }

        public static PGobject convertCidr(Object value) {
            String stringValue = value.toString();
            PGobject cidr = setPGobject(Constants.PGtypes.CIDR, stringValue);
            return cidr;
        }

        public static PGobject convertMac(Object value) {
            String stringValue = value.toString();
            PGobject macaddr = setPGobject(Constants.PGtypes.MACADDR, stringValue);
            return macaddr;
        }

        public static PGobject convertMac8(Object value) {
            String stringValue = value.toString();
            PGobject macaddr8 = setPGobject(Constants.PGtypes.MACADDR8, stringValue);
            return macaddr8;
        }

        public static PGpoint convertPoint(Object value) {
            PGpoint point; 
            if (value instanceof BString) {
                try {
                    point = new PGpoint(value.toString());
                } catch (Exception ex) {
                    throw new Error("Error");
                }
            } else {
                Map<String, Object> pointValue = ConversionHelperUtils.getRecordType(value);

                point = new PGpoint(
                    ((BDecimal) (pointValue.get(Constants.Geometric.X))).decimalValue().doubleValue(),
                    ((BDecimal) (pointValue.get(Constants.Geometric.Y))).decimalValue().doubleValue()
                );                
            }
            return point;
        }

        public static PGline convertLine(Object value) {
            PGline line;
            Type type = TypeUtils.getType(value);
            if (value instanceof BString) {
                try {
                    line = new PGline(value.toString());
                } catch (Exception ex) {
                    throw new Error("Error");
                }
            } else if (type.getTag() == TypeTags.RECORD_TYPE_TAG) {
                Map<String, Object> lineValue = ConversionHelperUtils.getRecordType(value);

                if (lineValue.containsKey(Constants.Geometric.A) && lineValue
                            .containsKey(Constants.Geometric.B)
                            && lineValue.containsKey(Constants.Geometric.C)) {
                        line = new PGline(
                            ((BDecimal) (lineValue.get(Constants.Geometric.A))).decimalValue().doubleValue(),
                            ((BDecimal) (lineValue.get(Constants.Geometric.B))).decimalValue().doubleValue(),
                            ((BDecimal) (lineValue.get(Constants.Geometric.C))).decimalValue().doubleValue()
                        );    
                } else if (lineValue.containsKey(Constants.Geometric.X1) && lineValue
                            .containsKey(Constants.Geometric.Y1)
                && lineValue.containsKey(Constants.Geometric.X2) && lineValue
                            .containsKey(Constants.Geometric.Y2)) {
                    line = new PGline(
                        ((BDecimal) (lineValue.get(Constants.Geometric.X1))).decimalValue().doubleValue(),
                        ((BDecimal) (lineValue.get(Constants.Geometric.Y1))).decimalValue().doubleValue(),
                        ((BDecimal) (lineValue.get(Constants.Geometric.X2))).decimalValue().doubleValue(),
                        ((BDecimal) (lineValue.get(Constants.Geometric.Y2))).decimalValue().doubleValue()
                    );  
                } else {
                   throw new Error("Error");
                }
            } else {
                throw new Error("Error");
            }
            return line;
        }

        public static PGlseg convertLseg(Object value) {
            PGlseg lseg;
            Type type = TypeUtils.getType(value);
            if (value instanceof BString) {
                try {
                    lseg = new PGlseg(value.toString());
                } catch (Exception ex) {
                    throw new Error("Error");
                }
            } else if (type.getTag() == TypeTags.RECORD_TYPE_TAG) {
                Map<String, Object> lsegValue = ConversionHelperUtils.getRecordType(value);

                if (lsegValue.containsKey(Constants.Geometric.X1) && lsegValue
                        .containsKey(Constants.Geometric.Y1)
                && lsegValue.containsKey(Constants.Geometric.X2) && lsegValue
                        .containsKey(Constants.Geometric.Y2)) {
                    lseg = new PGlseg(
                        ((BDecimal) (lsegValue.get(Constants.Geometric.X1))).decimalValue().doubleValue(),
                        ((BDecimal) (lsegValue.get(Constants.Geometric.Y1))).decimalValue().doubleValue(),
                        ((BDecimal) (lsegValue.get(Constants.Geometric.X2))).decimalValue().doubleValue(),
                        ((BDecimal) (lsegValue.get(Constants.Geometric.Y2))).decimalValue().doubleValue()
                    );  
                } else {
                    throw new Error("Error");
                }
            } else {
                throw new Error("Error");
            }
            return lseg;
        }

        public static PGbox convertBox(Object value) {
            PGbox box;
            Type type = TypeUtils.getType(value);
            if (value instanceof BString) {
                try {
                    box = new PGbox(value.toString());
                } catch (Exception ex) {
                    throw new Error("Error");
                }
            } else if (type.getTag() == TypeTags.RECORD_TYPE_TAG) {
                Map<String, Object> boxValue = ConversionHelperUtils.getRecordType(value);

                if (boxValue.containsKey(Constants.Geometric.X1) && boxValue
                        .containsKey(Constants.Geometric.Y1)
                && boxValue.containsKey(Constants.Geometric.X2) && boxValue
                        .containsKey(Constants.Geometric.Y2)) {
                    box = new PGbox(
                        ((BDecimal) (boxValue.get(Constants.Geometric.X1))).decimalValue().doubleValue(),
                        ((BDecimal) (boxValue.get(Constants.Geometric.Y1))).decimalValue().doubleValue(),
                        ((BDecimal) (boxValue.get(Constants.Geometric.X2))).decimalValue().doubleValue(),
                        ((BDecimal) (boxValue.get(Constants.Geometric.Y2))).decimalValue().doubleValue()
                    );  
                } else {
                    throw new Error("Error");
                }
            } else {
                throw new Error("Error");
            }
            return box;
        }

        public static PGcircle convertCircle(Object value) {
            PGcircle circle;
            Type type = TypeUtils.getType(value);
            if (value instanceof BString) {
                try {
                    circle = new PGcircle(value.toString());
                } catch (Exception ex) {
                    throw new Error("Error");
                }
            } else if (type.getTag() == TypeTags.RECORD_TYPE_TAG) {
                Map<String, Object> circleValue = ConversionHelperUtils.getRecordType(value);
                if (circleValue.containsKey(Constants.Geometric.X) && circleValue
                        .containsKey(Constants.Geometric.Y)
                    && circleValue.containsKey(Constants.Geometric.R)) {
                    circle = new PGcircle(
                        ((BDecimal)  (circleValue.get(Constants.Geometric.X))).decimalValue().doubleValue(),
                        ((BDecimal)  (circleValue.get(Constants.Geometric.Y))).decimalValue().doubleValue(),
                        ((BDecimal)  (circleValue.get(Constants.Geometric.R))).decimalValue().doubleValue()
                    );  
                } else {
                        throw new Error("Error");
                }
            } else {
                throw new Error("Error");
            }
            return circle;
        }

        public static PGobject convertUuid(Object value) {
            String stringValue = value.toString();

            PGobject uuid = setPGobject(Constants.PGtypes.UUID, stringValue);
            return uuid;
        }

        public static PGobject convertTsVector(Object value) {
            String stringValue = value.toString();

            PGobject tsvector = setPGobject(Constants.PGtypes.TSVECTOR, stringValue);
            return tsvector;
        }

        public static PGobject convertTsQuery(Object value) {
            String stringValue = value.toString();

            PGobject tsquery = setPGobject(Constants.PGtypes.TSQUERY, stringValue);
            return tsquery;
        }

        public static PGobject convertJson(Object value) {
            String stringValue = value.toString();
            PGobject json = setPGobject(Constants.PGtypes.JSON, stringValue);
            return json;
        }

        public static PGobject convertJsonb(Object value) {
            String stringValue = value.toString();
            PGobject jsonb = setPGobject(Constants.PGtypes.JSONB, stringValue);
            return jsonb;
        }

        public static PGobject convertJsonPath(Object value) {
            String stringValue = value.toString();
            PGobject jsonpath = setPGobject(Constants.PGtypes.JSONPATH, stringValue);
            return jsonpath;
        }


        public static PGInterval convertInterval(Object value) {
            Type type = TypeUtils.getType(value);
            PGInterval interval; 
            if (value instanceof BString) {
                try {
                    interval = new PGInterval(value.toString());
                } catch (Exception ex) {
                    throw new Error("Error");
                }
            } else if (type.getTag() == TypeTags.RECORD_TYPE_TAG) {
                Map<String, Object> intervalValue = ConversionHelperUtils.getRecordType(value);

                if (intervalValue.containsKey(Constants.Interval.YEARS) && intervalValue
                        .containsKey(Constants.Interval.MONTHS)
                    && intervalValue.containsKey(Constants.Interval.DAYS) && intervalValue
                            .containsKey(Constants.Interval.HOURS)
                    && intervalValue.containsKey(Constants.Interval.MINUTES) && intervalValue
                            .containsKey(Constants.Interval.SECONDS)) {

                    interval = new PGInterval(
                        ((Number) (intervalValue.get(Constants.Interval.YEARS))).intValue(),
                        ((Number) (intervalValue.get(Constants.Interval.MONTHS))).intValue(),
                        ((Number) (intervalValue.get(Constants.Interval.DAYS))).intValue(),
                        ((Number) (intervalValue.get(Constants.Interval.HOURS))).intValue(),
                        ((Number) (intervalValue.get(Constants.Interval.MINUTES))).intValue(),
                        ((BDecimal) (intervalValue.get(Constants.Interval.SECONDS))).decimalValue().doubleValue()
                    );
                } else {
                    throw new Error("Error");
                }

            } else {
                throw new Error("Error");
            }
            return interval;
        }

        public static PGobject convertInt4Range(Object value) {
            Type type = TypeUtils.getType(value);
            PGobject int4rangeObject; 
            if (value instanceof BString) {
                String stringValue = value.toString();
                int4rangeObject = setPGobject(Constants.PGtypes.INT4RANGE, stringValue);
            } else if (type.getTag() == TypeTags.RECORD_TYPE_TAG) {
                Map<String, Object> rangeValue = ConversionHelperUtils.getRecordType(value);

                if (rangeValue.containsKey(Constants.Range.UPPER) && rangeValue
                        .containsKey(Constants.Range.LOWER)
                    && rangeValue.containsKey(Constants.Range.UPPERINCLUSIVE) && rangeValue
                        .containsKey(Constants.Range.LOWERINCLUSIVE)) {

                    String upperValue = rangeValue.get(Constants.Range.UPPER).toString();
                    String lowerValue = rangeValue.get(Constants.Range.LOWER).toString();
                    boolean upperInclusive = ((Boolean) (rangeValue
                        .get(Constants.Range.UPPERINCLUSIVE))).booleanValue();
                    boolean lowerInclusive = ((Boolean) (rangeValue
                        .get(Constants.Range.LOWERINCLUSIVE))).booleanValue();

                    String range = ConversionHelperUtils
                        .setRange(upperValue, lowerValue, upperInclusive, lowerInclusive);

                    int4rangeObject = setPGobject(Constants.PGtypes.INT4RANGE, range);
                } else {
                    throw new Error("Error");
                }

            } else {
                throw new Error("Error");
            }
            return int4rangeObject;
        }

        public static PGobject convertInt8Range(Object value) {
            Type type = TypeUtils.getType(value);
            PGobject int8rangeObject; 
            if (value instanceof BString) {
                String stringValue = value.toString();
                int8rangeObject = setPGobject(Constants.PGtypes.INT8RANGE, stringValue);
            } else if (type.getTag() == TypeTags.RECORD_TYPE_TAG) {
                Map<String, Object> rangeValue = ConversionHelperUtils.getRecordType(value);
                if (rangeValue.containsKey(Constants.Range.UPPER) && rangeValue
                        .containsKey(Constants.Range.LOWER)
                    && rangeValue.containsKey(Constants.Range.UPPERINCLUSIVE) && rangeValue
                            .containsKey(Constants.Range.LOWERINCLUSIVE)) {
                    String upperValue = rangeValue.get(Constants.Range.UPPER).toString();
                    String lowerValue = rangeValue.get(Constants.Range.LOWER).toString();
                    boolean upperInclusive = ((Boolean) (rangeValue
                            .get(Constants.Range.UPPERINCLUSIVE))).booleanValue();
                    boolean lowerInclusive = ((Boolean) (rangeValue
                            .get(Constants.Range.LOWERINCLUSIVE))).booleanValue();

                    String range = ConversionHelperUtils
                          .setRange(upperValue, lowerValue, upperInclusive, lowerInclusive);

                    int8rangeObject = setPGobject(Constants.PGtypes.INT8RANGE, range);
                } else {
                    throw new Error("Error");
                }

            } else {
                throw new Error("Error");
            }
            return int8rangeObject;
        }

        public static PGobject convertNumRange(Object value) {
            Type type = TypeUtils.getType(value);
            PGobject numrangeObject; 
            if (value instanceof BString) {
                String stringValue = value.toString();
                numrangeObject = setPGobject(Constants.PGtypes.NUMRANGE, stringValue);
            } else if (type.getTag() == TypeTags.RECORD_TYPE_TAG) {
                Map<String, Object> rangeValue = ConversionHelperUtils.getRecordType(value);

                if (rangeValue.containsKey(Constants.Range.UPPER) && rangeValue
                            .containsKey(Constants.Range.LOWER)
                    && rangeValue.containsKey(Constants.Range.UPPERINCLUSIVE) && rangeValue
                            .containsKey(Constants.Range.LOWERINCLUSIVE)) {

                    String upperValue = rangeValue.get(Constants.Range.UPPER).toString();
                    String lowerValue = rangeValue.get(Constants.Range.LOWER).toString();
                    boolean upperInclusive = ((Boolean) (rangeValue
                            .get(Constants.Range.UPPERINCLUSIVE))).booleanValue();
                    boolean lowerInclusive = ((Boolean) (rangeValue
                            .get(Constants.Range.LOWERINCLUSIVE))).booleanValue();

                    String range = ConversionHelperUtils
                            .setRange(upperValue, lowerValue, upperInclusive, lowerInclusive);

                    numrangeObject = setPGobject(Constants.PGtypes.NUMRANGE, range);
                } else {
                    throw new Error("Error");
                }

            } else {
                throw new Error("Error");
            }
            return numrangeObject;

        }

        public static PGobject convertTsRange(Object value) {
            Type type = TypeUtils.getType(value);
            PGobject tsrangeObject; 
            if (value instanceof BString) {
                String stringValue = value.toString();
                tsrangeObject = setPGobject(Constants.PGtypes.TSRANGE, stringValue);
            } else if (type.getTag() == TypeTags.RECORD_TYPE_TAG) {
                Map<String, Object> rangeValue = ConversionHelperUtils.getRecordType(value);

                if (rangeValue.containsKey(Constants.Range.UPPER) && rangeValue.containsKey(Constants.Range.LOWER)
                    && rangeValue.containsKey(Constants.Range.UPPERINCLUSIVE) && rangeValue
                            .containsKey(Constants.Range.LOWERINCLUSIVE)) {
                    String upperValue;
                    String lowerValue;
                    Object upperObject = rangeValue.get(Constants.Range.UPPER);
                    Object lowerObject = rangeValue.get(Constants.Range.LOWER);
                    if (upperObject instanceof BString) {
                        upperValue = upperObject.toString();
                    } else {
                        upperValue = ConversionHelperUtils.toTimeString(upperObject).toString();
                    }
                    if (lowerObject instanceof BString) {
                        lowerValue = lowerObject.toString();
                    } else {
                        lowerValue = ConversionHelperUtils.toTimeString(lowerObject).toString();
                    }
                    boolean upperInclusive = ((Boolean) (rangeValue
                            .get(Constants.Range.UPPERINCLUSIVE))).booleanValue();
                    boolean lowerInclusive = ((Boolean) (rangeValue
                            .get(Constants.Range.LOWERINCLUSIVE))).booleanValue();

                    String range = ConversionHelperUtils
                            .setRange(upperValue, lowerValue, upperInclusive, lowerInclusive);

                    tsrangeObject = setPGobject(Constants.PGtypes.TSRANGE, range);
                } else {
                    throw new Error("Error");
                }

            } else {
                throw new Error("Error");
            }
            return tsrangeObject;
        }

        public static PGobject convertTstzRange(Object value) {
            Type type = TypeUtils.getType(value);
            PGobject tstzrangeObject; 
            if (value instanceof BString) {
                String stringValue = value.toString();
                tstzrangeObject = setPGobject(Constants.PGtypes.TSTZRANGE, stringValue);
            } else if (type.getTag() == TypeTags.RECORD_TYPE_TAG) {
                Map<String, Object> rangeValue = ConversionHelperUtils.getRecordType(value);

                if (rangeValue.containsKey(Constants.Range.UPPER) && rangeValue.containsKey(Constants.Range.LOWER)
                    && rangeValue.containsKey(Constants.Range.UPPERINCLUSIVE) && rangeValue
                            .containsKey(Constants.Range.LOWERINCLUSIVE)) {
                    String upperValue;
                    String lowerValue;
                    Object upperObject = rangeValue.get(Constants.Range.UPPER);
                    Object lowerObject = rangeValue.get(Constants.Range.LOWER);
                    if (upperObject instanceof BString) {
                        upperValue = upperObject.toString();
                    } else {
                        upperValue = ConversionHelperUtils.toTimeString(upperObject).toString();
                    }
                    if (lowerObject instanceof BString) {
                        lowerValue = lowerObject.toString();
                    } else {
                        lowerValue = ConversionHelperUtils.toTimeString(lowerObject).toString();
                    }
                    boolean upperInclusive = ((Boolean) (rangeValue
                            .get(Constants.Range.UPPERINCLUSIVE))).booleanValue();
                    boolean lowerInclusive = ((Boolean) (rangeValue
                            .get(Constants.Range.LOWERINCLUSIVE))).booleanValue();

                    String range = ConversionHelperUtils
                            .setRange(upperValue, lowerValue, upperInclusive, lowerInclusive);

                    tstzrangeObject = setPGobject(Constants.PGtypes.TSTZRANGE, range);
                } else {
                    throw new Error("Error");
                }

            } else {
                throw new Error("Error");
            }
            return tstzrangeObject;

        }

        public static PGobject convertDateRange(Object value) {
            Type type = TypeUtils.getType(value);
            PGobject daterangeObject; 
            if (value instanceof BString) {
                String stringValue = value.toString();
                daterangeObject = setPGobject(Constants.PGtypes.DATERANGE, stringValue);
            } else if (type.getTag() == TypeTags.RECORD_TYPE_TAG) {
                Map<String, Object> rangeValue = ConversionHelperUtils.getRecordType(value);

                if (rangeValue.containsKey(Constants.Range.UPPER) && rangeValue.containsKey(Constants.Range.LOWER)
                    && rangeValue.containsKey(Constants.Range.UPPERINCLUSIVE) && 
                            rangeValue.containsKey(Constants.Range.LOWERINCLUSIVE)) {
                    String upperValue;
                    String lowerValue;
                    Object upperObject = rangeValue.get(Constants.Range.UPPER);
                    Object lowerObject = rangeValue.get(Constants.Range.LOWER);
                    if (upperObject instanceof BString) {
                        upperValue = upperObject.toString();
                    } else {
                        upperValue = ConversionHelperUtils.toTimeString(upperObject).toString();
                    }
                    if (lowerObject instanceof BString) {
                        lowerValue = lowerObject.toString();
                    } else {
                        lowerValue = ConversionHelperUtils.toTimeString(lowerObject).toString();
                    }
                    boolean upperInclusive = ((Boolean) (rangeValue
                            .get(Constants.Range.UPPERINCLUSIVE))).booleanValue();
                    boolean lowerInclusive = ((Boolean) (rangeValue
                            .get(Constants.Range.LOWERINCLUSIVE))).booleanValue();

                    String range = ConversionHelperUtils
                            .setRange(upperValue, lowerValue, upperInclusive, lowerInclusive);

                    daterangeObject = setPGobject(Constants.PGtypes.DATERANGE, range);
                } else {
                    throw new Error("Error");
                }

            } else {
                throw new Error("Error");
            }
            return daterangeObject;
        }

        public static PGobject convertPglsn(Object value) {
            String stringValue = value.toString();
            PGobject pglsn = setPGobject(Constants.PGtypes.PGLSN, stringValue);
            return pglsn;
        }



        public static PGobject convertBitn(Object value) {
            String stringValue = value.toString();
            PGobject bitn = setPGobject(Constants.PGtypes.BITSTRING, stringValue);
            return bitn;
        }

        public static PGobject convertVarbit(Object value) {
            String stringValue = value.toString();
            PGobject varbit = setPGobject(Constants.PGtypes.VARBITSTRING, stringValue);
            return varbit;
        }

        public static PGobject convertBit(Object value) {
            String stringValue;
            if (value instanceof Boolean) {
                Boolean booleanValue = (Boolean) value;
                stringValue = booleanValue ? "1" : "0";
            } else {
                stringValue = value.toString();
            }
            PGobject bit = setPGobject(Constants.PGtypes.PGBIT, stringValue);
            return bit;
        }


        public static PGmoney convertMoney(Object value) {

            PGmoney money;
            if (value instanceof BString) {
                String stringValue = value.toString();
                money = setPGmoney(stringValue);
            } else if (value instanceof BDecimal) {
                double decimalValue = ((BDecimal) value).decimalValue().doubleValue();
                money = setPGmoney(decimalValue);
            } else {
                throw new Error("Error");
            }
            return money;
        }

        public static PGobject convertCustomType(BString datatype, Object value) {
            String stringValue;
            Type type = TypeUtils.getType(value);
            String typeName = datatype.toString();
            if (value instanceof BString) {
                stringValue = value.toString();
            } else if (type.getTag() == TypeTags.RECORD_TYPE_TAG) {
                Map<String, Object> customValue = ConversionHelperUtils.getRecordType(value);
                stringValue = ConversionHelperUtils.setCustomType(customValue);
            } else {
                throw new Error("Error");
            }
            PGobject customObject = setPGobject(typeName, stringValue);
            return customObject;
        }


        public static PGobject convertRegclass(Object value) {
            String stringValue = value.toString();
            PGobject regclass = setPGobject(Constants.PGtypes.REGCLASS, stringValue);
            return regclass;
        }

        public static PGobject convertRegconfig(Object value) {
            String stringValue = value.toString();
            PGobject regconfig = setPGobject(Constants.PGtypes.REGCONFIG, stringValue);
            return regconfig;
        }


        public static PGobject convertRegdictionary(Object value) {
            String stringValue = value.toString();
            PGobject regdictionary = setPGobject(Constants.PGtypes.REGDICTIONARY, stringValue);
            return regdictionary;
        }


        public static PGobject convertRegnamespace(Object value) {
            String stringValue = value.toString();
            PGobject regnamespace = setPGobject(Constants.PGtypes.REGNAMESPACE, stringValue);
            return regnamespace;
        }


        public static PGobject convertRegoper(Object value) {
            String stringValue = value.toString();
            PGobject regoper = setPGobject(Constants.PGtypes.REGOPER, stringValue);
            return regoper;
        }


        public static PGobject convertRegoperator(Object value) {
            String stringValue = value.toString();
            PGobject regoperator = setPGobject(Constants.PGtypes.REGOPERATOR, stringValue);
            return regoperator;
        }


        public static PGobject convertRegproc(Object value) {
            String stringValue = value.toString();
            PGobject regproc = setPGobject(Constants.PGtypes.REGPROC, stringValue);
            return regproc;
        }


        public static PGobject convertRegprocedure(Object value) {
            String stringValue = value.toString();
            PGobject regprocedure = setPGobject(Constants.PGtypes.REGPROCEDURE, stringValue);
            return regprocedure;
        }


        public static PGobject convertRegrole(Object value) {
            String stringValue = value.toString();
            PGobject regrole = setPGobject(Constants.PGtypes.REGROLE, stringValue);
            return regrole;
        }


        public static PGobject convertRegtype(Object value) {
            String stringValue = value.toString();
            PGobject regtype = setPGobject(Constants.PGtypes.REGTYPE, stringValue);
            return regtype;
        }

        public static Object convertXml(Connection connection, Object value) {
            String xmlValue = value.toString();
            SQLXML xml = new PgSQLXML((BaseConnection) connection, xmlValue);
            return xml;
        }

        public static BMap convertIntervalToRecord(Object value, String typeName) throws SQLException {
            Map<String, Object> valueMap = new HashMap<>();
            if (value == null) {
                return null;
            }
            try {
                PGInterval interval = new PGInterval(value.toString());
                valueMap.put(Constants.Interval.YEARS, interval.getYears());
                valueMap.put(Constants.Interval.MONTHS, interval.getMonths());
                valueMap.put(Constants.Interval.DAYS, interval.getDays());
                valueMap.put(Constants.Interval.HOURS, interval.getHours());
                valueMap.put(Constants.Interval.MINUTES, interval.getMinutes());
                valueMap.put(Constants.Interval.SECONDS, interval.getSeconds());

                return ValueCreator.createRecordValue(ModuleUtils.getModule(),
                    typeName, valueMap);
            } catch (SQLException  ex) {
                throw new SQLException("Error");
            }
        }

        public static BMap convertPointToRecord(Object value, String typeName) throws SQLException {
            Map<String, Object> valueMap = new HashMap<>();
            if (value == null) {
                return null;
            }
            try {
                PGpoint point = new PGpoint(value.toString());
                valueMap.put(Constants.Geometric.X, point.x);
                valueMap.put(Constants.Geometric.Y, point.y);
                return ValueCreator.createRecordValue(ModuleUtils.getModule(),
                typeName, valueMap);
            } catch (SQLException  ex) {
                throw new SQLException("Error");
            }
        }

        public static BMap convertLineToRecord(Object value, String typeName) throws SQLException {
            Map<String, Object> valueMap = new HashMap<>();
            if (value == null) {
                return null;
            }
            try {
                PGline line = new PGline(value.toString());
                valueMap.put(Constants.Geometric.A, line.a);
                valueMap.put(Constants.Geometric.B, line.b);
                valueMap.put(Constants.Geometric.C, line.c);

            return ValueCreator.createRecordValue(ModuleUtils.getModule(),
                typeName, valueMap);
            } catch (SQLException  ex) {
                throw new SQLException(ex.getMessage());
            }
        }

        public static BMap convertLsegToRecord(Object value, String typeName) throws SQLException {
            Map<String, Object> valueMap = new HashMap<>();
            if (value == null) {
                return null;
            }
            try {
                PGlseg lseg = new PGlseg(value.toString());
                PGpoint[] points = lseg.point;
                PGpoint point1 = points[0];
                PGpoint point2 = points[1];
                valueMap.put(Constants.Geometric.X1, point1.x);
                valueMap.put(Constants.Geometric.Y1, point1.y);
                valueMap.put(Constants.Geometric.X2, point2.x);
                valueMap.put(Constants.Geometric.Y2, point2.y);

                return ValueCreator.createRecordValue(ModuleUtils.getModule(),
                    typeName, valueMap);
            } catch (SQLException  ex) {
                throw new SQLException("Error");
            }
        }

        public static BMap convertBoxToRecord(Object value, String typeName) throws SQLException {
            Map<String, Object> valueMap = new HashMap<>();
            if (value == null) {
                return null;
            }
            try {
                PGbox box = new PGbox(value.toString());
                PGpoint[] points = box.point;
                PGpoint point1 = points[1];
                PGpoint point2 = points[0];
                valueMap.put(Constants.Geometric.X1, point1.x);
                valueMap.put(Constants.Geometric.Y1, point1.y);
                valueMap.put(Constants.Geometric.X2, point2.x);
                valueMap.put(Constants.Geometric.Y2, point2.y);

                return ValueCreator.createRecordValue(ModuleUtils.getModule(),
                    typeName, valueMap);
            } catch (SQLException  ex) {
                throw new SQLException("Error");
            }
        }

        public static BMap convertCircleToRecord(Object value, String typeName) throws SQLException {
            Map<String, Object> valueMap = new HashMap<>();
            if (value == null) {
                return null;
            }
            try {
                PGcircle circle = new PGcircle(value.toString());
                PGpoint center = circle.center;
                valueMap.put(Constants.Geometric.X, center.x);
                valueMap.put(Constants.Geometric.Y, center.y);
                valueMap.put(Constants.Geometric.R, circle.radius);

                return ValueCreator.createRecordValue(ModuleUtils.getModule(),
                    typeName, valueMap);
            } catch (SQLException  ex) {
                throw new SQLException("Error");
            }
        }

        public static BMap convertInt4rangeToRecord(Object value, String typeName) {
            Map<String, Object> valueMap;
            if (value == null) {
                return null;
            }
            valueMap = ConversionHelperUtils.convertRangeToMap(value);

            int upperValue = Integer.parseInt(valueMap.get(Constants.Range.UPPER).toString());
            valueMap.put(Constants.Range.UPPER, upperValue);

            int lowerValue = Integer.parseInt(valueMap.get(Constants.Range.LOWER).toString());
            valueMap.put(Constants.Range.LOWER, lowerValue);

            return ValueCreator.createRecordValue(ModuleUtils.getModule(),
                typeName, valueMap);
        }

        public static BMap convertInt8rangeToRecord(Object value, String typeName) {
            Map<String, Object> valueMap;
            if (value == null) {
                return null;
            }
            valueMap = ConversionHelperUtils.convertRangeToMap(value);

            long upperValue = Long.parseLong(valueMap.get(Constants.Range.UPPER).toString());
            valueMap.put(Constants.Range.UPPER, upperValue);

            long lowerValue = Long.parseLong(valueMap.get(Constants.Range.LOWER).toString());
            valueMap.put(Constants.Range.LOWER, lowerValue);

            return ValueCreator.createRecordValue(ModuleUtils.getModule(),
                typeName, valueMap);
        }

        public static BMap convertNumrangeToRecord(Object value, String typeName) {
            Map<String, Object> valueMap;
            if (value == null) {
                return null;
            }
            valueMap = ConversionHelperUtils.convertRangeToMap(value);

            double upperValue = Double.parseDouble(valueMap.get(Constants.Range.UPPER).toString());
            valueMap.put(Constants.Range.UPPER, upperValue);

            double lowerValue = Double.parseDouble(valueMap.get(Constants.Range.LOWER).toString());
            valueMap.put(Constants.Range.LOWER, lowerValue);

            return ValueCreator.createRecordValue(ModuleUtils.getModule(),
                typeName, valueMap);
        }

        public static BMap converTsrangeToRecord(Object value, String typeName) {
            return convertTimestampRangeToRecord(value, typeName);
        }

        public static BMap convertTstzrangeToRecord(Object value, String typeName) {
            return convertTimestampRangeToRecord(value, typeName);
        }

        public static BMap convertDaterangeToRecord(Object value, String typeName) {
            Map<String, Object> valueMap;
            if (value == null) {
                return null;
            }
            valueMap = ConversionHelperUtils.convertRangeToMap(value);
            return ValueCreator.createRecordValue(ModuleUtils.getModule(),
                typeName, valueMap);
        }

        private static BMap convertTimestampRangeToRecord(Object value, String typeName) {
            Map<String, Object> valueMap;
            if (value == null) {
                return null;
            }
            valueMap = ConversionHelperUtils.convertRangeToMap(value);
            String upperValue = valueMap.get(Constants.Range.UPPER).toString();
            valueMap.put(Constants.Range.UPPER, upperValue.substring(1, upperValue.length() - 1));
            String lowerValue = valueMap.get(Constants.Range.LOWER).toString();
            valueMap.put(Constants.Range.LOWER, lowerValue.substring(1, lowerValue.length() - 1));
            return ValueCreator.createRecordValue(ModuleUtils.getModule(),
                typeName, valueMap);
        }

        public static Object getJsonValue(Object value) {
            if (value == null) {
                return null;
            }
            try {
                String jsonString = value.toString();
                return ConversionHelperUtils.getJson(jsonString);
            } catch (SQLException ex) {
                throw new Error("SQLException Error");
            } catch (ApplicationError ex) {
                throw new Error("ApplicationError Error");
            }
        } 

        private static PGobject setPGobject(String type, String value) {
            PGobject pgobject =  new PGobject();
            pgobject.setType(type);
            try {
                pgobject.setValue(value);

            } catch (Exception ex) {
                throw new Error("Error");
            }
            return pgobject;
        }

        private static PGmoney setPGmoney(double value) {
            PGmoney money;
            try {
                money = new PGmoney(value);

            } catch (Exception ex) {
                throw new Error("Error");
            }
            return money;
        }

        private static PGmoney setPGmoney(String value) {
            PGmoney money;
            try {
                money = new PGmoney(value);

            } catch (Exception ex) {
                throw new Error("Error");
            }
            return money;
        }
} 
