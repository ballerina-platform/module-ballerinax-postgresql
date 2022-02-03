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

# Represents the `Inet` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class InetValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents the `Inet` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class InetArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents the `Cidr` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class CidrValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents the `Cidr` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class CidrArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents the `Macaddress` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class MacAddrValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents the `Macaddress` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class MacAddrArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents the `Macaddress8` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class MacAddr8Value {
    *sql:TypedValue;
    public string? value;

    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents the `Macaddress8` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class MacAddr8ArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents the `Point` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class PointValue {
    *sql:TypedValue;
    public Point|string? value;

    public isolated function init(Point|string? value = ()) {
        self.value = value;
    }
}

# Represents the `Point` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class PointArrayValue {
    *sql:TypedValue;
    public Point?[]|string?[] value;

    public isolated function init(Point[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents the `Line` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class LineValue {
    *sql:TypedValue;
    public Line|string? value;

    public isolated function init(Line|string? value = ()) {
        self.value = value;
    }
}

# Represents the `Line` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class LineArrayValue {
    *sql:TypedValue;
    public Line?[]|string?[] value;

    public isolated function init(Line?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents the `Line` segment PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class LineSegmentValue {
    *sql:TypedValue;
    public LineSegment|string? value;

    public isolated function init(LineSegment|string? value = ()) {
        self.value = value;
    }
}

# Represents the `Line` segment array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class LineSegmentArrayValue {
    *sql:TypedValue;
    public LineSegment?[]|string?[] value;

    public isolated function init(LineSegment?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents the `Box` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class BoxValue {
    *sql:TypedValue;
    public Box|string? value;

    public isolated function init(Box|string? value = ()) {
        self.value = value;
    }
}

# Represents the `Box` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class BoxArrayValue {
    *sql:TypedValue;
    public Box?[]|string?[] value;

    public isolated function init(Box?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents the `Path` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class PathValue {
    *sql:TypedValue;
    public Path|Point[]|string? value;

    public isolated function init(Path|Point[]|string? value = ()) {
        self.value = value;
    }
}

# Represents the `Path` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class PathArrayValue {
    *sql:TypedValue;
    public Path?[]|Point[]?[]|string?[] value;

    public isolated function init(Path?[]|Point[]?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents the `Polygon` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class PolygonValue {
    *sql:TypedValue;
    public Point[]|string? value;

    public isolated function init(Point[]|string? value = ()) {
        self.value = value;
    }
}

# Represents the `Polygon` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class PolygonArrayValue {
    *sql:TypedValue;
    public Point[]?[]|string?[] value;

    public isolated function init(Point[]?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents the `Circle` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class CircleValue {
    *sql:TypedValue;
    public Circle|string? value;

    public isolated function init(Circle|string? value = ()) {
        self.value = value;
    }
}

# Represents the `Circle` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class CircleArrayValue {
    *sql:TypedValue;
    public Circle?[]|string?[] value;

    public isolated function init(Circle?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents the `UUID` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class UuidValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents the `UUID` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class UuidArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents the `Text vector` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class TsVectorValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents the `Text vector` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class TsVectorArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents the `Text query` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class TsQueryValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents the `Text query` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class TsQueryArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents the `JSON` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class JsonValue {
    *sql:TypedValue;
    public json|string? value;
    public isolated function init(json|string? value = ()) {
        self.value = value;
    }
}

# Represents the `JSON` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class JsonArrayValue {
    *sql:TypedValue;
    public json[]|string?[] value;

    public isolated function init(json[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents the `JSONB` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class JsonBinaryValue {
    *sql:TypedValue;
    public json|string? value;
    public isolated function init(json|string? value = ()) {
        self.value = value;
    }
}

# Represents the `JSONB` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class JsonBinaryArrayValue {
    *sql:TypedValue;
    public json[]|string?[] value;

    public isolated function init(json[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents the `JSONPath` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class JsonPathValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents the `JSONPath` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class JsonPathArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents the `Time interval` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class IntervalValue {
    *sql:TypedValue;
    public Interval|string? value;

    public isolated function init(Interval|string? value = ()) {
        self.value = (value);
    }
}

# Represents the `Time interval` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class IntervalArrayValue {
    *sql:TypedValue;
    public Interval?[]|string?[] value;

    public isolated function init(Interval?[]|string?[] value = <string?[]>[]) {
        self.value = (value);
    }
}

# Represents the `Int4 range` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class IntegerRangeValue {
    *sql:TypedValue;
    public IntegerRange|string? value;

    public isolated function init(IntegerRange|string? value = ()) {
        self.value = value;
    }
}

# Represents the `Int4 range` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class IntegerRangeArrayValue {
    *sql:TypedValue;
    public IntegerRange?[]|string?[] value;

    public isolated function init(IntegerRange?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents the `Int8 range` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class LongRangeValue {
    *sql:TypedValue;
    public LongRange|string? value;

    public isolated function init(LongRange|string? value = ()) {
        self.value = value;
    }
}

# Represents the `Int8 range` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class LongRangeArrayValue {
    *sql:TypedValue;
    public LongRange?[]|string?[] value;

    public isolated function init(LongRange?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents the `Numerical range` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class NumericRangeValue {
    *sql:TypedValue;
    public NumericRange|string? value;

    public isolated function init(NumericRange|string? value = ()) {
        self.value = value;
    }
}

# Represents the `Numerical range` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class NumericRangeArrayValue {
    *sql:TypedValue;
    public NumericRange?[]|string?[] value;

    public isolated function init(NumericRange?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents the `Timestamp range` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class TsRangeValue {
    *sql:TypedValue;
    public TimestampRange|TimestampCivilRange|string? value;

    public isolated function init(TimestampRange|TimestampCivilRange|string? value = ()) {
        self.value = value;
    }
}

# Represents the `Timestamp range` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class TsRangeArrayValue {
    *sql:TypedValue;
    public TimestampRange?[]|TimestampCivilRange?[]|string?[] value;

    public isolated function init(TimestampRange?[]|TimestampCivilRange?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents the `Timestamp with timezone range` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class TsTzRangeValue {
    *sql:TypedValue;
    public TimestamptzRange|TimestamptzCivilRange|string? value;

    public isolated function init(TimestamptzRange|TimestamptzCivilRange|string? value = ()) {
        self.value = value;
    }
}

# Represents the `Timestamp with timezone range` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class TsTzRangeArrayValue {
    *sql:TypedValue;
    public TimestamptzRange?[]|TimestamptzCivilRange?[]|string?[] value;

    public isolated function init(TimestamptzRange?[]|TimestamptzCivilRange?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents the `Date range` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class DateRangeValue {
    *sql:TypedValue;
    public DateRange|DateRecordRange|string? value;

    public isolated function init(DateRange|DateRecordRange|string? value = ()) {
        self.value = value;
    }
}

# Represents the `Date range` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class DateRangeArrayValue {
    *sql:TypedValue;
    public DateRange?[]|DateRecordRange?[]|string?[] value;

    public isolated function init(DateRange?[]|DateRecordRange?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents the `Pg_lsn` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class PglsnValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents the `pg_lsn` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class PglsnArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents the `Bit(n)` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class BitStringValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents the `Bit(n)` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class BitStringArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents the `Bit vary(n) PostgreSQL` type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class VarBitStringValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents the `Bit vary(n)` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class VarBitStringArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents the `Bit` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class PGBitValue {
    *sql:TypedValue;
    public boolean|string? value;
    public isolated function init(boolean|string? value = ()) {
        self.value = value;
    }
}

# Represents the `Bit` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class PGBitArrayValue {
    *sql:TypedValue;
    public boolean?[]|string?[] value;

    public isolated function init(boolean?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents the `Money` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class MoneyValue {
    *sql:TypedValue;
    public decimal|float|string? value;
    public isolated function init(decimal|float|string? value = ()) {
        self.value = value;
    }
}

# Represents the `Money` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class MoneyArrayValue {
    *sql:TypedValue;
    public decimal?[]|float?[]|string?[] value;

    public isolated function init(decimal?[]|float?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents the `regclass` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegClassValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents the `regclass` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegClassArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents the `regconfig` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegConfigValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents the `regconfig` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegConfigArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents the `regdictionary` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegDictionaryValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents the `regdictionary` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegDictionaryArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents the `regnamespace` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegNamespaceValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents the `regnamespace` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegNamespaceArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents the `regoper` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegOperValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents the `regoper` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegOperArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents the `regoperator` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegOperatorValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents the `regoperator` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegOperatorArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents the `regproc` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegProcValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents the `regproc` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegProcArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents the `regprocedure` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegProcedureValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents the `regprocedure` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegProcedureArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents the `regrole` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegRoleValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents the `regrole` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegRoleArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents the `regtype` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegTypeValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents the `regtype` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class RegTypeArrayValue {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents the `regtype` PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class PGXmlValue {
    *sql:TypedValue;
    public string|xml? value;
    public isolated function init(string|xml? value = ()) {
        self.value = value;
    }
}

# Represents the `regtype` array PostgreSQL type parameter in `sql:ParameterizedQuery`.
#
# + value - Value of the parameter
public distinct class PGXmlArrayValue {
    *sql:TypedValue;
    public string?[]|xml?[] value;

    public isolated function init(string?[]|xml?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents the user-defined PostgreSQL type parameter in `sql:ParameterizedQuery`.
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

# Represents the `Enum` PostgreSQL type parameter in `sql:ParameterizedQuery`.
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
