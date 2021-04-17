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

 
import ballerina/jballerina.java;
import ballerina/sql;
import ballerina/time;

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

# Represents Line segment PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class LsegValue {
    *sql:TypedValue;
    public LineSegment | string? value;

    public isolated function init(LineSegment |string? value = ()) {
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

# PostgreSQL Text search Data types.

# Represents Text vector PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class TsvectorValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents Text query PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class TsqueryValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
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

# Represents Jsonb PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class JsonbValue {
    *sql:TypedValue;
    public json|string? value;
    public isolated function init(json|string? value = ()) {
        self.value = value;
    }  
}

# Represents Jsonpath PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class JsonpathValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
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

# Represents Numerical range PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class NumericRangeValue {
    *sql:TypedValue;
    public NumericalRange |string? value;

    public isolated function init(NumericalRange |string? value = ()) {
        self.value = value;
    }
}

# Represents Timestamp range PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class TsrangeValue {
    *sql:TypedValue;
    public TimestampRange | TimestampCivilRange | string? value;

    public isolated function init(TimestampRange | TimestampCivilRange | string? value = ()) {
        self.value = value;
    }
}

# Represents Timestamp with timezone range PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class TstzrangeValue {
    *sql:TypedValue;
    public TimestamptzRange | TimestamptzCivilRange | string? value;

    public isolated function init(TimestamptzRange | TimestamptzCivilRange | string? value = ()) {
        self.value = value;
    }
}

# Represents Date range PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class DaterangeValue {
    *sql:TypedValue;
    public DateRange | DateRecordRange | string? value;

    public isolated function init(DateRange | DateRecordRange | string? value = ()) {
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


# PostgreSQL Bit String Data types.

# Represents Bit(n) PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class BitstringValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents Bit vary(n) PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class VarbitstringValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
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

# PostgreSQL Object identifier Data types.
# Represents regclass PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class RegclassValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents regconfig PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class RegconfigValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents regdictionary PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class RegdictionaryValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents regnamespace PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class RegnamespaceValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents regoper PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class RegoperValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents regoperator PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class RegoperatorValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents regproc PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class RegprocValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents regprocedure PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class RegprocedureValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents regrole PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class RegroleValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents regtype PostgreSQL Field
#
# + value - Value of parameter passed into the SQL statement
public distinct class RegtypeValue {
    *sql:TypedValue;
    public string? value;
    public isolated function init(string? value = ()) {
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

# Represents OutParameters for PostgreSQL 

# Represents Interval OutParameter used in procedure calls
public distinct class IntervalOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Inet OutParameter used in procedure calls
public distinct class InetOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Cidr OutParameter used in procedure calls
public distinct class CidrOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents MacAddr OutParameter used in procedure calls
public distinct class MacAddrOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents MacAddr8 OutParameter used in procedure calls
public distinct class MacAddr8OutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Point OutParameter used in procedure calls
public distinct class PointOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Line OutParameter used in procedure calls
public distinct class LineOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Lseg OutParameter used in procedure calls
public distinct class LsegOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Path OutParameter used in procedure calls
public distinct class PathOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Polygon OutParameter used in procedure calls
public distinct class PolygonOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Box OutParameter used in procedure calls
public distinct class BoxOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Circle OutParameter used in procedure calls
public distinct class CircleOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Uuid OutParameter used in procedure calls
public distinct class UuidOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Pglsn OutParameter used in procedure calls
public distinct class PglsnOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Json OutParameter used in procedure calls
public distinct class JsonOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Jsonb OutParameter used in procedure calls
public distinct class JsonbOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Jsonpath OutParameter used in procedure calls
public distinct class JsonpathOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Int4 range OutParameter used in procedure calls
public distinct class IntegerRangeOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Int8 Range OutParameter used in procedure calls
public distinct class LongRangeOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Numeric range OutParameter used in procedure calls
public distinct class NumericRangeOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Timestamp Range OutParameter used in procedure calls
public distinct class TimestampRangeOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Timestamptz Range OutParameter used in procedure calls
public distinct class TimestamptzRangeOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Date Range OutParameter used in procedure calls
public distinct class DateRangeOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Varbitstring OutParameter used in procedure calls
public distinct class VarbitStringOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents PGBit OutParameter used in procedure calls
public distinct class PGBitOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Bytea range OutParameter used in procedure calls
public distinct class ByteaOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Xml range OutParameter used in procedure calls
public distinct class PGXmlOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Tsvector OutParameter used in procedure calls
public distinct class TsvectorOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Tsquery OutParameter used in procedure calls
public distinct class TsqueryOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Regclass OutParameter used in procedure calls
public distinct class RegclassOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Regnamespace OutParameter used in procedure calls
public distinct class RegnamespaceOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Regconfig OutParameter used in procedure calls
public distinct class RegconfigOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Regdictionary OutParameter used in procedure calls
public distinct class RegdictionaryOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Regoper OutParameter used in procedure calls
public distinct class RegoperOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Regoperator OutParameter used in procedure calls
public distinct class RegoperatorOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Regproc OutParameter used in procedure calls
public distinct class RegprocOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Regprocedure OutParameter used in procedure calls
public distinct class RegprocedureOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Regrole OutParameter used in procedure calls
public distinct class RegroleOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Regtype OutParameter used in procedure calls
public distinct class RegtypeOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Money OutParameter used in procedure calls
public distinct class MoneyOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents Enum OutParameter used in procedure calls
public distinct class EnumOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# Represents PostgreSQL InOutParameter used in procedure calls which handles all PostgreSQL Data types.
#
# + in - Value of parameter passed into the SQL statement
public class InOutParameter {
    public sql:Value 'in;

    public isolated function init(sql:Value 'in) {
        self.'in = 'in;
    }

    # Parses returned PostgreSQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc) returns typeDesc|sql:Error = @java:Method {
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessorUtils"
    } external;
}

# The object type that is used as a structure to define a custom class with custom
# implementations for nextResult and getNextQueryResult in the PostgreSQL module.

public class CustomResultIterator {

    public isolated function nextResult(sql:ResultIterator iterator) returns record {}|sql:Error? = @java:Method {
        'class: "org.ballerinalang.postgresql.utils.RecordIteratorUtils",
        paramTypes: ["io.ballerina.runtime.api.values.BObject", "io.ballerina.runtime.api.values.BObject"]
    } external; 

    public isolated function getNextQueryResult(sql:ProcedureCallResult callResult) returns boolean|sql:Error = @java:Method {
    'class: "org.ballerinalang.postgresql.utils.ProcedureCallResultUtils",
    paramTypes: ["io.ballerina.runtime.api.values.BObject", "io.ballerina.runtime.api.values.BObject"]
    } external;
}

# Represents Point Datatype in PostgreSQL.
#
# + x - The x Cordinate of the Point
# + y - The y Cordinate of the Point
public type Point record {
    decimal x;
    decimal y;
};

# Represents Line Segment Datatype in PostgreSQL.
#
# + x1 - The x cordinate of the first point of the line segment
# + y1 - The y cordinate of the first point of the line segment
# + x2 - The x cordinate of the second point of the line segment
# + y2 - The y cordinate of the second point of the line segment
public type LineSegment record {
    decimal x1; 
    decimal y1;
    decimal x2; 
    decimal y2;
};

# Represents Box Datatype in PostgreSQL.
#
# + x1 - The x cordinate of a corner of the box
# + y1 - The y cordinate of a corner of the box
# + x2 - The x cordinate of the opposite corner of the box
# + y2 - The y cordinate of the opposite corner of the box
public type Box record {
    decimal x1; 
    decimal y1;
    decimal x2; 
    decimal y2;
};

# Represents Path Datatype in PostgreSQL.
#
# + open - True if the path is open, false if closed
# + points - The points defining this path
public type Path record {
    boolean open = false;
    Point[] points;
};

# Represents Path Datatype in PostgreSQL.
#
# + points - The points defining the polygon
public type Polygon record {
    Point[] points;
};

# Represents Box Datatype in PostgreSQL.
#
# + x - The x cordinate of the center
# + y - The y cordinate of the center
# + r - The radius of the circle
public type Circle record {
    decimal x;
    decimal y;
    decimal r;
};

# Represents Line Datatype in PostgreSQL.
#
# + a - The a value in the standard line equation ax + by + c = 0  
# + b - The b value in the standard line equation ax + by + c = 0  
# + c - The c value in the standard line equation ax + by + c = 0 
public type Line record {
    decimal a; 
    decimal b;
    decimal c;
};

# Represents Interval Datatype in PostgreSQL.
#
# + years - Number of years in the interval 
# + months - Number of months in the interval  
# + days - Number of days in the interval 
# + hours - Number of hours in the interval 
# + minutes - Number of minutes in the interval  
# + seconds - Number of seconds in the interval 
public type Interval record {
    int years = 0;
    int months = 0;
    int days = 0;
    int hours = 0;
    int minutes = 0;
    decimal seconds = 0;
};

# Represents Int4Range Datatype in PostgreSQL.
#
# + upper - Upper value in the Range 
# + lower - Lower value in the Range  
# + upperboundInclusive - True if upper value is include to the range 
# + lowerboundInclusive - True if lower value is include to the range 
public type Range record {
    anydata upper;
    anydata lower;
    boolean upperboundInclusive = false;
    boolean lowerboundInclusive = false;
};

# Represents Int4Range Datatype in PostgreSQL.
#
# + upper - Upper value in the Range 
# + lower - Lower value in the Range
public type IntegerRange record {
    *Range;
    int upper;
    int lower;
};

# Represents Int8Range Datatype in PostgreSQL.
#
# + upper - Upper value in the Range 
# + lower - Lower value in the Range 
public type LongRange record {
    *Range;
    int upper;
    int lower;
};

# Represents NumRange Datatype in PostgreSQL.
#
# + upper - Upper value in the Range 
# + lower - Lower value in the Range
public type NumericalRange record {
    *Range; 
    decimal upper; 
    decimal lower;
};

# Represents Timestamp Range Datatype in PostgreSQL.
#
# + upper - Upper value in the Range 
# + lower - Lower value in the Range
public type TimestampRange record {
    *Range;
    string upper; 
    string lower;
};

# Represents Timestamp with Timezone Range Datatype in PostgreSQL.
#
# + upper - Upper value in the Range 
# + lower - Lower value in the Range 
public type TimestamptzRange record {
    *Range;
    string upper; 
    string lower;
};

# Represents Date Range Datatype in PostgreSQL.
#
# + upper - Upper value in the Range 
# + lower - Lower value in the Range 
public type DateRange record {
    *Range;
    string upper; 
    string lower;
};

# Represents Values for User Defined Datatype in PostgreSQL.
#
# + values - List of values in the User Defined type
public type CustomValues record {
    anydata[]? values;
};

# Represents Value for Enum Datatype in PostgreSQL.
#
# + value - Value for Enum
public type Enum record {
    string value?;
};

# Represents User Defined Datatype in PostgreSQL.
#
# + sqlTypeName - SQL Type Name
# + values -  List of values in the User Defined type 
public type CustomValueRecord record {
    string sqlTypeName;
    CustomValues? values;
};

# Represents Enum Datatype in PostgreSQL.
#
# + sqlTypeName - SQL Type Name
# + value -  Value for Enum 
public type EnumRecord record {
    string sqlTypeName;
    Enum? value;
};


# Represents Timestamp Range Datatype in PostgreSQL.
#
# + upper - Upper value in the Range 
# + lower - Lower value in the Range
public type TimestampCivilRange record {
    *Range;
    time:Civil upper; 
    time:Civil lower;
};

# Represents Timestamp with Timezone Range Datatype in PostgreSQL.
#
# + upper - Upper value in the Range 
# + lower - Lower value in the Range 
public type TimestamptzCivilRange record {
    *Range;
    time:Civil upper; 
    time:Civil lower;
};

# Represents Date Range Datatype in PostgreSQL.
#
# + upper - Upper value in the Range 
# + lower - Lower value in the Range 
public type DateRecordRange record {
    *Range;
    time:Date upper; 
    time:Date lower;
};
