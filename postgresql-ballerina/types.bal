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

# PostgreSQL Network Data types.

# Represents Inet PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class InetValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents Inet array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class InetArray {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents Cidr PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class CidrValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents Cidr array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class CidrArray {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents Macaddress PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class MacAddrValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents Macaddress array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class MacAddrArray {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value =[]) {
        self.value = value;
    }
}

# Represents Macaddress8 PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class MacAddr8Value {
    *sql:TypedValue;
    public string? value;

    public isolated function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents Macaddress8 array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class MacAddr8Array {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# PostgreSQL Geometric Data types.

## Represents Point PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class PointValue {
    *sql:TypedValue;
    public Point | string? value;

    public isolated function init(Point | string? value = ()) {
        self.value =value;
    }
}

## Represents Point array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class PointArray {
    *sql:TypedValue;
    public Point?[]|string?[] value;

    public isolated function init(Point[]|string?[] value = <string?[]>[]) {
        self.value =value;
    }
}

# Represents Line PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class LineValue {
    *sql:TypedValue;
    public Line|string? value;

    public isolated function init(Line | string? value = ()) {
        self.value = value;
    }  
}

# Represents Line array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class LineArray {
    *sql:TypedValue;
    public Line?[]|string?[] value;

    public isolated function init(Line?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents Line segment PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class LineSegmentValue {
    *sql:TypedValue;
    public LineSegment | string? value;

    public isolated function init(LineSegment |string? value = ()) {
        self.value = value;
    }  
}

# Represents Line segment array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class LineSegmentArray {
    *sql:TypedValue;
    public LineSegment?[]|string?[] value;

    public isolated function init(LineSegment?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents Box PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class BoxValue {
    *sql:TypedValue;
    public Box | string? value;

    public isolated function init(Box | string? value = ()) {
        self.value = value;
    }  
}

# Represents Box array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class BoxArray {
    *sql:TypedValue;
    public Box?[]| string?[] value;

    public isolated function init(Box?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents Path PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class PathValue {
    *sql:TypedValue;
    public Path | Point[] | string? value;

    public isolated function init(Path | Point[] | string? value = ()) {
        self.value = value;
    }  
}

# Represents Path array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class PathArray {
    *sql:TypedValue;
    public Path?[]|Point[]?[]|string?[] value;

    public isolated function init(Path?[]|Point[]?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents Polygon PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class PolygonValue {
    *sql:TypedValue;
    public Point[] | string? value;

    public isolated function init(Point[] | string? value = ()) {
        self.value = value;
    } 
}

# Represents Polygon array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class PolygonArray {
    *sql:TypedValue;
    public Point[]?[]|string?[] value;

    public isolated function init(Point[]?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents Circle PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class CircleValue {
    *sql:TypedValue;
    public Circle | string? value;

    public isolated function init(Circle | string? value = ()) {
        self.value = value;
    }  
}

# Represents Circle array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class CircleArray {
    *sql:TypedValue;
    public Circle?[]|string?[] value;

    public isolated function init(Circle?[]| string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents UUID PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class UuidValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents UUID array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class UuidArray {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# PostgreSQL Text search Data types.

# Represents Text vector PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class TsVectorValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents Text vector array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class TsVectorArray {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents Text query PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class TsQueryValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents Text query array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class TsQueryArray {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# PostgreSQL Json Data types.

# Represents Json PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class JsonValue {
    *sql:TypedValue;
    public json|string? value;
    public isolated function init(json|string? value = ()) {
        self.value = value;
    }  
}

# Represents Json array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class JsonArray {
    *sql:TypedValue;
    public json[]|string?[] value;

    public isolated function init(json[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents Jsonb PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class JsonBinaryValue {
    *sql:TypedValue;
    public json|string? value;
    public isolated function init(json|string? value = ()) {
        self.value = value;
    }  
}

# Represents Jsonb array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class JsonBinaryArray {
    *sql:TypedValue;
    public json[]|string?[] value;

    public isolated function init(json[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents Jsonpath PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class JsonPathValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents Jsonpath array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class JsonPathArray {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents Time interval PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class IntervalValue {
    *sql:TypedValue;
    public Interval |string? value;

    public isolated function init(Interval |string? value = ()) {
        self.value = (value);
    }
}

# Represents Time interval array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class IntervalArray {
    *sql:TypedValue;
    public Interval?[]|string?[] value;

    public isolated function init(Interval?[]|string?[] value = <string?[]>[]) {
        self.value = (value);
    }
}

# PostgreSQL Range Data types.

# Represents Int4 range PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class IntegerRangeValue {
    *sql:TypedValue;
    public IntegerRange | string? value;

    public isolated function init(IntegerRange | string? value = ()) {
        self.value = value;
    }
}

# PostgreSQL Range Data types.

# Represents Int4 range array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class IntegerRangeArray {
    *sql:TypedValue;
    public IntegerRange?[]|string?[] value;

    public isolated function init(IntegerRange?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents Int8 range PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class LongRangeValue {
    *sql:TypedValue;
    public LongRange | string? value;

    public isolated function init(LongRange | string? value = ()) {
        self.value = value;
    }
}

# Represents Int8 range array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class LongRangeArray {
    *sql:TypedValue;
    public LongRange?[]|string?[] value;

    public isolated function init(LongRange?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents Numerical range PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class NumericRangeValue {
    *sql:TypedValue;
    public NumericRange |string? value;

    public isolated function init(NumericRange |string? value = ()) {
        self.value = value;
    }
}

# Represents Numerical range array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class NumericRangeArray {
    *sql:TypedValue;
    public NumericRange?[]|string?[] value;

    public isolated function init(NumericRange?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents Timestamp range PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class TsRangeValue {
    *sql:TypedValue;
    public TimestampRange | TimestampCivilRange | string? value;

    public isolated function init(TimestampRange | TimestampCivilRange | string? value = ()) {
        self.value = value;
    }
}

# Represents Timestamp range array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class TsRangeArray {
    *sql:TypedValue;
    public TimestampRange?[]|TimestampCivilRange?[]|string?[] value;

    public isolated function init(TimestampRange?[]|TimestampCivilRange?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents Timestamp with timezone range PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class TsTzRangeValue {
    *sql:TypedValue;
    public TimestamptzRange | TimestamptzCivilRange | string? value;

    public isolated function init(TimestamptzRange | TimestamptzCivilRange | string? value = ()) {
        self.value = value;
    }
}

# Represents Timestamp with timezone range array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class TsTzRangeArray {
    *sql:TypedValue;
    public TimestamptzRange?[]| TimestamptzCivilRange?[]|string?[] value;

    public isolated function init(TimestamptzRange?[]| TimestamptzCivilRange?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents Date range PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class DateRangeValue {
    *sql:TypedValue;
    public DateRange | DateRecordRange | string? value;

    public isolated function init(DateRange | DateRecordRange | string? value = ()) {
        self.value = value;
    }
}

# Represents Date range array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class DateRangeArray {
    *sql:TypedValue;
    public DateRange?[]|DateRecordRange?[]|string?[] value;

    public isolated function init(DateRange?[]|DateRecordRange?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents Pg_lsn PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class PglsnValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents Pg_lsn array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class PglsnArray {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# PostgreSQL Bit String Data types.

# Represents Bit(n) PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class BitStringValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents Bit(n) array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class BitStringArray {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents Bit vary(n) PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class VarBitStringValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents Bit vary(n) array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class VarBitStringArray {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents Bit PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class PGBitValue {
    *sql:TypedValue;
    public boolean|string? value;
    public isolated function init(boolean|string? value = ()) {
        self.value = value;
    }  
}

# Represents Bit array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class PGBitArray {
    *sql:TypedValue;
    public boolean?[]|string?[] value;

    public isolated function init(boolean?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents Money PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class MoneyValue {
    *sql:TypedValue;
    public decimal|float|string? value;
    public isolated function init(decimal|float|string? value = ()) {
        self.value = value;
    }  
}

# Represents Money array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class MoneyArray {
    *sql:TypedValue;
    public decimal?[]|float?[]|string?[] value;

    public isolated function init(decimal?[]|float?[]|string?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# PostgreSQL Object identifier Data types.

# Represents regclass PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class RegClassValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }
}

# Represents regclass array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class RegClassArray {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents regconfig PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class RegConfigValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents regconfig array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class RegConfigArray {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents regdictionary PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class RegDictionaryValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents regdictionary array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class RegDictionaryArray {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents regnamespace PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class RegNamespaceValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents regnamespace array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class RegNamespaceArray {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents regoper PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class RegOperValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents regoper array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class RegOperArray {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents regoperator PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class RegOperatorValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents regoperator array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class RegOperatorArray {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents regproc PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class RegProcValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents regproc array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class RegProcArray {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents regprocedure PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class RegProcedureValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents regprocedure array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class RegProcedureArray {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents regrole PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class RegRoleValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents regrole array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class RegRoleArray {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents regtype PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class RegTypeValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents regtype array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class RegTypeArray {
    *sql:TypedValue;
    public string?[] value;

    public isolated function init(string?[] value = []) {
        self.value = value;
    }
}

# Represents regtype PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class PGXmlValue {
    *sql:TypedValue;
    public string|xml? value;
    public isolated function init(string|xml? value = ()) {
        self.value = value;
    }  
}

# Represents regtype array PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class PGXmlArray {
    *sql:TypedValue;
    public string?[]|xml?[] value;

    public isolated function init(string?[]|xml?[] value = <string?[]>[]) {
        self.value = value;
    }
}

# Represents User Define PostgreSQL Fields
#
# + value - Value of parameter passed into the SQL statement
public distinct class CustomTypeValue {
    *sql:TypedValue;
    public CustomValueRecord value;

    public isolated function init(string sqlTypeName, CustomValues? value = ()) {
        CustomValueRecord customValueRecord = {sqlTypeName: sqlTypeName, values: value};
        self.value = customValueRecord;
    } 
}

# Represents Enum PostgreSQL Fields
#
# + value - Value of parameter passed into the SQL statement
public distinct class EnumValue {
    *sql:TypedValue;
    public EnumRecord value;

    public isolated function init(string sqlTypeName, Enum? value = ()) {
        EnumRecord enumRecord = {sqlTypeName: sqlTypeName, value: value};
        self.value = enumRecord;
    }
}
