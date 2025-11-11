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

# Represents the `Interval` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class IntervalOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `Inet` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class InetOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `Cidr` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class CidrOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `MacAddr` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class MacAddrOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `MacAddr8` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class MacAddr8OutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `Point` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class PointOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `Line` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class LineOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `Lseg` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class LsegOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `Path` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class PathOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `Polygon` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class PolygonOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `Box` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class BoxOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `Circle` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class CircleOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `UUID` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class UuidOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `Pglsn` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class PglsnOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `JSON` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class JsonOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `JSONB` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class JsonbOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `JSONPath` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class JsonPathOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `Int4 range` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class IntegerRangeOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `Int8 Range` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class LongRangeOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `Numeric range` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class NumericRangeOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `Timestamp Range` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class TimestampRangeOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `Timestamp with Timezone Range` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class TimestampTzRangeOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `Date Range` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class DateRangeOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `Varbitstring` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class VarBitStringOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `PGBit` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class PGBitOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `Bytea range` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class ByteaOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `XML range` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class PGXmlOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `Text Vector` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class TsVectorOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `Text Query` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class TsQueryOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `Regclass` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class RegClassOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `Regnamespace` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class RegNamespaceOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `Regconfig` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class RegConfigOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `Regdictionary` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class RegDictionaryOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `Regoper` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class RegOperOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `Regoperator` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class RegOperatorOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `Regproc` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class RegProcOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `Regprocedure` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class RegProcedureOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `Regrole` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class RegRoleOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `Regtype` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class RegTypeOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `Money` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class MoneyOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the `Enum` `OutParameter` in `sql:ParameterizedCallQuery`.
public distinct class EnumOutParameter {
    *sql:OutParameter;

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getOutParameterValue"
    } external;
}

# Represents the PostgreSQL `InOutParameter` in `sql:ParameterizedCallQuery`.
#
# + in - Value of parameter passed into the SQL statement
public class InOutParameter {
    public sql:Value 'in;

    public isolated function init(sql:Value 'in) {
        self.'in = 'in;
    }

    # Parses the returned SQL value to a Ballerina value.
    #
    # + typeDesc - The `typedesc` of the type to which the result needs to be returned
    # + return - The result in the `typeDesc` type, or an `sql:Error`
    public isolated function get(typedesc<anydata> typeDesc = <>) returns typeDesc|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.nativeimpl.OutParameterProcessorUtils",
        name: "getInOutParameterValue"
    } external;
}

# The iterator for the stream returned in `query` function to be used in overriding the default behaviour of `sql:ResultIterator`.
public class CustomResultIterator {

    # Retrieves the next result from the `sql:ResultIterator`.
    #
    # + iterator - The `sql:ResultIterator` to fetch the next result from.
    # + return - A record containing the next result, or an `sql:Error` if an error occurs.
    public isolated function nextResult(sql:ResultIterator iterator) returns record {}|sql:Error? = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.utils.RecordIteratorUtils",
        paramTypes: ["io.ballerina.runtime.api.values.BObject", "io.ballerina.runtime.api.values.BObject"]
    } external;

    # Retrieves the next query result from the `sql:ProcedureCallResult`.
    #
    # + callResult - The `sql:ProcedureCallResult` to fetch the next query result from.
    # + return - `true` if there is a next query result, `false` if there are no more results, or an `sql:Error` if an error occurs.
    public isolated function getNextQueryResult(sql:ProcedureCallResult callResult) returns boolean|sql:Error = @java:Method {
        'class: "io.ballerina.stdlib.postgresql.utils.ProcedureCallResultUtils",
        paramTypes: ["io.ballerina.runtime.api.values.BObject", "io.ballerina.runtime.api.values.BObject"]
    } external;
}

