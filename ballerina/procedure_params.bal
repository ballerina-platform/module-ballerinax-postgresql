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

# Represents Interval OutParameter in `sql:ParameterizedCallQuery`.
public distinct class IntervalOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Inet OutParameter in `sql:ParameterizedCallQuery`.
public distinct class InetOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Cidr OutParameter in `sql:ParameterizedCallQuery`.
public distinct class CidrOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents MacAddr OutParameter in `sql:ParameterizedCallQuery`.
public distinct class MacAddrOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents MacAddr8 OutParameter in `sql:ParameterizedCallQuery`.
public distinct class MacAddr8OutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Point OutParameter in `sql:ParameterizedCallQuery`.
public distinct class PointOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Line OutParameter in `sql:ParameterizedCallQuery`.
public distinct class LineOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Lseg OutParameter in `sql:ParameterizedCallQuery`.
public distinct class LsegOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Path OutParameter in `sql:ParameterizedCallQuery`.
public distinct class PathOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Polygon OutParameter in `sql:ParameterizedCallQuery`.
public distinct class PolygonOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Box OutParameter in `sql:ParameterizedCallQuery`.
public distinct class BoxOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Circle OutParameter in `sql:ParameterizedCallQuery`.
public distinct class CircleOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Uuid OutParameter in `sql:ParameterizedCallQuery`.
public distinct class UuidOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Pglsn OutParameter in `sql:ParameterizedCallQuery`.
public distinct class PglsnOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Json OutParameter in `sql:ParameterizedCallQuery`.
public distinct class JsonOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Jsonb OutParameter in `sql:ParameterizedCallQuery`.
public distinct class JsonbOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Jsonpath OutParameter in `sql:ParameterizedCallQuery`.
public distinct class JsonPathOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Int4 range OutParameter in `sql:ParameterizedCallQuery`.
public distinct class IntegerRangeOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Int8 Range OutParameter in `sql:ParameterizedCallQuery`.
public distinct class LongRangeOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Numeric range OutParameter in `sql:ParameterizedCallQuery`.
public distinct class NumericRangeOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Timestamp Range OutParameter in `sql:ParameterizedCallQuery`.
public distinct class TimestampRangeOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Timestamptz Range OutParameter in `sql:ParameterizedCallQuery`.
public distinct class TimestampTzRangeOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Date Range OutParameter in `sql:ParameterizedCallQuery`.
public distinct class DateRangeOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Varbitstring OutParameter in `sql:ParameterizedCallQuery`.
public distinct class VarBitStringOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents PGBit OutParameter in `sql:ParameterizedCallQuery`.
public distinct class PGBitOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Bytea range OutParameter in `sql:ParameterizedCallQuery`.
public distinct class ByteaOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Xml range OutParameter in `sql:ParameterizedCallQuery`.
public distinct class PGXmlOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Tsvector OutParameter in `sql:ParameterizedCallQuery`.
public distinct class TsVectorOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Tsquery OutParameter in `sql:ParameterizedCallQuery`.
public distinct class TsQueryOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Regclass OutParameter in `sql:ParameterizedCallQuery`.
public distinct class RegClassOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Regnamespace OutParameter in `sql:ParameterizedCallQuery`.
public distinct class RegNamespaceOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Regconfig OutParameter in `sql:ParameterizedCallQuery`.
public distinct class RegConfigOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Regdictionary OutParameter in `sql:ParameterizedCallQuery`.
public distinct class RegDictionaryOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Regoper OutParameter in `sql:ParameterizedCallQuery`.
public distinct class RegOperOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Regoperator OutParameter in `sql:ParameterizedCallQuery`.
public distinct class RegOperatorOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Regproc OutParameter in `sql:ParameterizedCallQuery`.
public distinct class RegProcOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Regprocedure OutParameter in `sql:ParameterizedCallQuery`.
public distinct class RegProcedureOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Regrole OutParameter in `sql:ParameterizedCallQuery`.
public distinct class RegRoleOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Regtype OutParameter in `sql:ParameterizedCallQuery`.
public distinct class RegTypeOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Money OutParameter in `sql:ParameterizedCallQuery`.
public distinct class MoneyOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents Enum OutParameter in `sql:ParameterizedCallQuery`.
public distinct class EnumOutParameter {
    *sql:OutParameter;

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents PostgreSQL InOutParameter in `sql:ParameterizedCallQuery`.
#
# + in - Value of parameter passed into the SQL statement
public class InOutParameter {
    public sql:Value 'in;

    public isolated function init(sql:Value 'in) {
        self.'in = 'in;
    }

    # Parses returned SQL value to a ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getInOutParameterValue"
    } external;
}

# The iterator for the stream returned in `query` function to be used overriding the default behaviour of `sql:ResultIterator`.
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

