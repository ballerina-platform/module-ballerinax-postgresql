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

# Represents OutParameters for PostgreSQL

# Represents Interval OutParameter used in procedure calls
public distinct class IntervalOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Inet OutParameter used in procedure calls
public distinct class InetOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Cidr OutParameter used in procedure calls
public distinct class CidrOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents MacAddr OutParameter used in procedure calls
public distinct class MacAddrOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents MacAddr8 OutParameter used in procedure calls
public distinct class MacAddr8OutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Point OutParameter used in procedure calls
public distinct class PointOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Line OutParameter used in procedure calls
public distinct class LineOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Lseg OutParameter used in procedure calls
public distinct class LsegOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Path OutParameter used in procedure calls
public distinct class PathOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Polygon OutParameter used in procedure calls
public distinct class PolygonOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Box OutParameter used in procedure calls
public distinct class BoxOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Circle OutParameter used in procedure calls
public distinct class CircleOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Uuid OutParameter used in procedure calls
public distinct class UuidOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Pglsn OutParameter used in procedure calls
public distinct class PglsnOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Json OutParameter used in procedure calls
public distinct class JsonOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Jsonb OutParameter used in procedure calls
public distinct class JsonbOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Jsonpath OutParameter used in procedure calls
public distinct class JsonPathOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Int4 range OutParameter used in procedure calls
public distinct class IntegerRangeOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Int8 Range OutParameter used in procedure calls
public distinct class LongRangeOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Numeric range OutParameter used in procedure calls
public distinct class NumericRangeOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Timestamp Range OutParameter used in procedure calls
public distinct class TimestampRangeOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Timestamptz Range OutParameter used in procedure calls
public distinct class TimestampTzRangeOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Date Range OutParameter used in procedure calls
public distinct class DateRangeOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Varbitstring OutParameter used in procedure calls
public distinct class VarBitStringOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents PGBit OutParameter used in procedure calls
public distinct class PGBitOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Bytea range OutParameter used in procedure calls
public distinct class ByteaOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Xml range OutParameter used in procedure calls
public distinct class PGXmlOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Tsvector OutParameter used in procedure calls
public distinct class TsVectorOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Tsquery OutParameter used in procedure calls
public distinct class TsQueryOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Regclass OutParameter used in procedure calls
public distinct class RegClassOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Regnamespace OutParameter used in procedure calls
public distinct class RegNamespaceOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Regconfig OutParameter used in procedure calls
public distinct class RegConfigOutParameter {
    *sql:OutParameter;
    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Regdictionary OutParameter used in procedure calls
public distinct class RegDictionaryOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Regoper OutParameter used in procedure calls
public distinct class RegOperOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Regoperator OutParameter used in procedure calls
public distinct class RegOperatorOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Regproc OutParameter used in procedure calls
public distinct class RegProcOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Regprocedure OutParameter used in procedure calls
public distinct class RegProcedureOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Regrole OutParameter used in procedure calls
public distinct class RegRoleOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Regtype OutParameter used in procedure calls
public distinct class RegTypeOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Money OutParameter used in procedure calls
public distinct class MoneyOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Enum OutParameter used in procedure calls
public distinct class EnumOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to ballerina value.
    #
    # + typeDesc - Type description of the data that need to be converted
    # + return - The converted ballerina value or Error
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
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
    public isolated function get(typedesc<anydata>  typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getInOutParameterValue"
    } external;
}

# The object type that is used as a structure to define a custom class with custom
# implementations for nextResult and getNextQueryResult in the PostgreSQL module.

public class CustomResultIterator {

    public isolated function nextResult(sql:ResultIterator iterator) returns record {}|sql:Error? = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.utils.RecordIteratorUtils",
        paramTypes: ["io.ballerina.runtime.api.values.BObject", "io.ballerina.runtime.api.values.BObject"]
    } external;

    public isolated function getNextQueryResult(sql:ProcedureCallResult callResult) returns boolean|sql:Error = @java:Method {
    'class: "io.ballerina.stdlib.postgresql.utils.ProcedureCallResultUtils",
    paramTypes: ["io.ballerina.runtime.api.values.BObject", "io.ballerina.runtime.api.values.BObject"]
    } external;
}

