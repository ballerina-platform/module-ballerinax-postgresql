// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/sql;

# Represents Inet PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class InetValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents Inet array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class InetArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents Cidr PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class CidrValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents Cidr array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class CidrArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents Macaddress PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class MacAddrValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents Macaddress array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class MacAddrArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents Macaddress8 PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class MacAddr8Value {
    *sql:TypedValue;
    public string? value;

    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents Macaddress8 array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class MacAddr8ArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents Point PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class PointValue {
    *sql:TypedValue;
    public Point|string? value;

    public isolated function init(Point|string? value = ()) {
        self.value = value;
    }
}

# Represents Point array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class PointArrayValue {
    *sql:TypedValue;
    public Point?[]|string?[] value;

    public isolated function init(Point[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents Line PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class LineValue {
    *sql:TypedValue;
    public Line|string? value;

    public isolated function init(Line|string? value = ()) {
        self.value = value;
    }
}

# Represents Line array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class LineArrayValue {
    *sql:TypedValue;
    public Line?[]|string?[] value;

    public isolated function init(Line?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents Line segment PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class LineSegmentValue {
    *sql:TypedValue;
    public LineSegment|string? value;

    public isolated function init(LineSegment|string? value = ()) {
        self.value = value;
    }
}

# Represents Line segment array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class LineSegmentArrayValue {
    *sql:TypedValue;
    public LineSegment?[]|string?[] value;

    public isolated function init(LineSegment?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents Box PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class BoxValue {
    *sql:TypedValue;
    public Box|string? value;

    public isolated function init(Box|string? value = ()) {
        self.value = value;
    }
}

# Represents Box array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class BoxArrayValue {
    *sql:TypedValue;
    public Box?[]|string?[] value;

    public isolated function init(Box?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents Path PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class PathValue {
    *sql:TypedValue;
    public Path|Point[]|string? value;

    public isolated function init(Path|Point[]|string? value = ()) {
        self.value = value;
    }
}

# Represents Path array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class PathArrayValue {
    *sql:TypedValue;
    public Path?[]|Point[]?[]|string?[] value;

    public isolated function init(Path?[]|Point[]?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents Polygon PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class PolygonValue {
    *sql:TypedValue;
    public Point[]|string? value;

    public isolated function init(Point[]|string? value = ()) {
        self.value = value;
    }
}

# Represents Polygon array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class PolygonArrayValue {
    *sql:TypedValue;
    public Point[]?[]|string?[] value;

    public isolated function init(Point[]?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents Circle PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class CircleValue {
    *sql:TypedValue;
    public Circle|string? value;

    public isolated function init(Circle|string? value = ()) {
        self.value = value;
    }
}

# Represents Circle array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class CircleArrayValue {
    *sql:TypedValue;
    public Circle?[]|string?[] value;

    public isolated function init(Circle?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents UUID PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class UuidValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents UUID array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class UuidArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents Text vector PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class TsVectorValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents Text vector array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class TsVectorArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents Text query PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class TsQueryValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents Text query array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class TsQueryArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents Json PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class JsonValue {
    *sql:TypedValue;
    public json|string? value;
    public isolated function init(json|string? value = ()) {
        self.value = value;
    }
}

# Represents Json array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class JsonArrayValue {
    *sql:TypedValue;
    public json[]|string?[] value;

    public isolated function init(json[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents Jsonb PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class JsonBinaryValue {
    *sql:TypedValue;
    public json|string? value;
    public isolated function init(json|string? value = ()) {
        self.value = value;
    }
}

# Represents Jsonb array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class JsonBinaryArrayValue {
    *sql:TypedValue;
    public json[]|string?[] value;

    public isolated function init(json[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents Jsonpath PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class JsonPathValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents Jsonpath array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class JsonPathArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents Time interval PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class IntervalValue {
    *sql:TypedValue;
    public Interval|string? value;

    public isolated function init(Interval|string? value = ()) {
        self.value = (value);
    }
}

# Represents Time interval array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class IntervalArrayValue {
    *sql:TypedValue;
    public Interval?[]|string?[] value;

    public isolated function init(Interval?[]|string?[] value = <string?[]>[]) {
        self.value = (value);
    }
}

# Represents Int4 range PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class IntegerRangeValue {
    *sql:TypedValue;
    public IntegerRange|string? value;

    public isolated function init(IntegerRange|string? value = ()) {
        self.value = value;
    }
}

# Represents Int4 range array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class IntegerRangeArrayValue {
    *sql:TypedValue;
    public IntegerRange?[]|string?[] value;

    public isolated function init(IntegerRange?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents Int8 range PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class LongRangeValue {
    *sql:TypedValue;
    public LongRange|string? value;

    public isolated function init(LongRange|string? value = ()) {
        self.value = value;
    }
}

# Represents Int8 range array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class LongRangeArrayValue {
    *sql:TypedValue;
    public LongRange?[]|string?[] value;

    public isolated function init(LongRange?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents Numerical range PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class NumericRangeValue {
    *sql:TypedValue;
    public NumericRange|string? value;

    public isolated function init(NumericRange|string? value = ()) {
        self.value = value;
    }
}

# Represents Numerical range array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class NumericRangeArrayValue {
    *sql:TypedValue;
    public NumericRange?[]|string?[] value;

    public isolated function init(NumericRange?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents Timestamp range PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class TsRangeValue {
    *sql:TypedValue;
    public TimestampRange|TimestampCivilRange|string? value;

    public isolated function init(TimestampRange|TimestampCivilRange|string? value = ()) {
        self.value = value;
    }
}

# Represents Timestamp range array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class TsRangeArrayValue {
    *sql:TypedValue;
    public TimestampRange?[]|TimestampCivilRange?[]|string?[] value;

    public isolated function init(TimestampRange?[]|TimestampCivilRange?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents Timestamp with timezone range PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class TsTzRangeValue {
    *sql:TypedValue;
    public TimestamptzRange|TimestamptzCivilRange|string? value;

    public isolated function init(TimestamptzRange|TimestamptzCivilRange|string? value = ()) {
        self.value = value;
    }
}

# Represents Timestamp with timezone range array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class TsTzRangeArrayValue {
    *sql:TypedValue;
    public TimestamptzRange?[]|TimestamptzCivilRange?[]|string?[] value;

    public isolated function init(TimestamptzRange?[]|TimestamptzCivilRange?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents Date range PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class DateRangeValue {
    *sql:TypedValue;
    public DateRange|DateRecordRange|string? value;

    public isolated function init(DateRange|DateRecordRange|string? value = ()) {
        self.value = value;
    }
}

# Represents Date range array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class DateRangeArrayValue {
    *sql:TypedValue;
    public DateRange?[]|DateRecordRange?[]|string?[] value;

    public isolated function init(DateRange?[]|DateRecordRange?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents Pg_lsn PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class PglsnValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents Pg_lsn array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class PglsnArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents Bit(n) PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class BitStringValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents Bit(n) array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class BitStringArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents Bit vary(n) PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class VarBitStringValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents Bit vary(n) array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class VarBitStringArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents Bit PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class PGBitValue {
    *sql:TypedValue;
    public boolean|string? value;
    public isolated function init(boolean|string? value = ()) {
        self.value = value;
    }
}

# Represents Bit array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class PGBitArrayValue {
    *sql:TypedValue;
    public boolean?[]|string?[] value;

    public isolated function init(boolean?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents Money PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class MoneyValue {
    *sql:TypedValue;
    public decimal|float|string? value;
    public isolated function init(decimal|float|string? value = ()) {
        self.value = value;
    }
}

# Represents Money array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class MoneyArrayValue {
    *sql:TypedValue;
    public decimal?[]|float?[]|string?[] value;

    public isolated function init(decimal?[]|float?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents regclass PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegClassValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents regclass array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegClassArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents regconfig PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegConfigValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents regconfig array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegConfigArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents regdictionary PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegDictionaryValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents regdictionary array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegDictionaryArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents regnamespace PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegNamespaceValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents regnamespace array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegNamespaceArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents regoper PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegOperValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents regoper array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegOperArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents regoperator PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegOperatorValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents regoperator array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegOperatorArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents regproc PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegProcValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents regproc array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegProcArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents regprocedure PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegProcedureValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents regprocedure array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegProcedureArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents regrole PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegRoleValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents regrole array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegRoleArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents regtype PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegTypeValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents regtype array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegTypeArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents regtype PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class PGXmlValue {
    *sql:TypedValue;
    public string|xml? value;
    public isolated function init(string|xml? value = ()) {
        self.value = value;
    }
}

# Represents regtype array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class PGXmlArrayValue {
    *sql:TypedValue;
    public string?[]|xml?[] value;

    public isolated function init(string?[]|xml?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents User Define PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class CustomTypeValue {
    *sql:TypedValue;
    public CustomValueRecord value;

    public isolated function init(string sqlTypeName, CustomValues? value = ()) {
        CustomValueRecord customValueRecord = {sqlTypeName: sqlTypeName, values: value};
        self.value = customValueRecord;
    }
}

# Represents Enum PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class EnumValue {
    *sql:TypedValue;
    public EnumRecord value;

    public isolated function init(string sqlTypeName, Enum? value = ()) {
        EnumRecord enumRecord = {sqlTypeName: sqlTypeName, value: value};
        self.value = enumRecord;
    }
}
