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
# PostgreSQL Network Data types.

# Represents Inet PostgreSQL Field
public class InetValue {
    public string? value;
    public function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents Cidr PostgreSQL Field
public class CidrValue {
    public string? value;
    public function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents Macaddress PostgreSQL Field
public class MacaddrValue {
    public string? value;
    public function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents Macaddress8 PostgreSQL Field
public class Macaddr8Value {
    public string? value;
    public function init(string? value = ()) {
        self.value = value;
    }  
} 

# PostgreSQL Geometric Data types.


## Represents Point PostgreSQL Field
public class PointValue {
    public PointRecord | string? value;

    public function init(PointRecord | string? value = ()) {
        self.value =value;
    }
}

# Represents Line PostgreSQL Field
public class LineValue {
    public LineRecord|string? value;

    public function init(LineRecord | string? value = ()) {
        self.value = value;
    }  
}

# Represents Line segment PostgreSQL Field
public class LsegValue {
    public LsegRecord | string? value;

    public function init(LsegRecord |string? value = ()) {
        self.value = value;
    }  
}

# Represents Box PostgreSQL Field
public class BoxValue {
    public BoxRecord | string? value;

    public function init(BoxRecord | string? value = ()) {
        self.value = value;
    }  
}

public class PathValue {
    public PathRecord | PointRecord[] | string? value;

    public function init(PathRecord | PointRecord[] | string? value = ()) {
        self.value = value;
    }  
}

public class PolygonValue {
    public PointRecord[] | string? value;

    public function init(PointRecord[] | string? value = ()) {
        self.value = value;
    } 
}

# Represents Circle PostgreSQL Field
public class CircleValue {
    public CircleRecord | string? value;

    public function init(CircleRecord | string? value = ()) {
        self.value = value;
    }  
}

# Represents UUID PostgreSQL Field
public class UuidValue {
    public string? value;
    public function init(string? value = ()) {
        self.value = value;
    }  
}

# PostgreSQL Text search Data types.

# Represents Text vector PostgreSQL Field
public class TsvectorValue {
    public string? value;
    public function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents Text query PostgreSQL Field
public class TsqueryValue {
    public string? value;
    public function init(string? value = ()) {
        self.value = value;
    }  
}

# PostgreSQL Json Data types.

# Represents Json PostgreSQL Field
public class JsonValue {
    public json|string? value;
    public function init(json|string? value = ()) {
        self.value = value;
    }  
}

# Represents Jsonb PostgreSQL Field
public class JsonbValue {
    public json|string? value;
    public function init(json|string? value = ()) {
        self.value = value;
    }  
}

# Represents Jsonpath PostgreSQL Field
public class JsonpathValue {
    public string? value;
    public function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents Time interval PostgreSQL Field
public class IntervalValue {
    public IntervalRecord |string? value;

    public function init(IntervalRecord |string? value = ()) {
        self.value = (value);
    }
}

# PostgreSQL Range Data types.

# Represents Int4 range PostgreSQL Field
public class Int4rangeValue {
    public Int4rangeRecord | string? value;

    public function init(Int4rangeRecord | string? value = ()) {
        self.value = value;
    }
}

# Represents Int8 range PostgreSQL Field
public class Int8rangeValue {
    public Int8rangeRecord | string? value;

    public function init(Int8rangeRecord | string? value = ()) {
        self.value = value;
    }
}

# Represents Numerical range PostgreSQL Field
public class NumrangeValue {
    public NumrangeRecord |string? value;

    public function init(NumrangeRecord |string? value = ()) {
        self.value = value;
    }
}

# Represents Timestamp range PostgreSQL Field
public class TsrangeValue {
    public TsrangeRecord | string? value;

    public function init(TsrangeRecord | string? value = ()) {
        self.value = value;
    }
}

# Represents Timestamp with timezone range PostgreSQL Field
public class TstzrangeValue {
    public TstzrangeRecord | string? value;

    public function init(TstzrangeRecord | string? value = ()) {
        self.value = value;
    }
}

# Represents Date range PostgreSQL Field
public class DaterangeValue {
    public DaterangeRecord | string? value;

    public function init(DaterangeRecord | string? value = ()) {
        self.value = value;
    }
}


# Represents Pg_lsn PostgreSQL Field
public class PglsnValue {
    public string? value;
    public function init(string? value = ()) {
        self.value = value;
    }  
}


# PostgreSQL Bit String Data types.

# Represents Bit(n) PostgreSQL Field
public class BitstringValue {
    public string? value;
    public function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents Bit vary(n) PostgreSQL Field
public class VarbitstringValue {
    public string? value;
    public function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents Bit PostgreSQL Field
public class PGBitValue {
    public boolean|string? value;
    public function init(boolean|string? value = ()) {
        self.value = value;
    }  
}
   

# Represents Money PostgreSQL Field
public class MoneyValue {
    public decimal|string? value;
    public function init(decimal|string? value = ()) {
        self.value = value;
    }  
}

# PostgreSQL Object identifier Data types.
# Represents regclass PostgreSQL Field
public class RegclassValue {
    public string? value;
    public function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents regconfig PostgreSQL Field
public class RegconfigValue {
    public string? value;
    public function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents regdictionary PostgreSQL Field
public class RegdictionaryValue {
    public string? value;
    public function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents regnamespace PostgreSQL Field
public class RegnamespaceValue {
    public string? value;
    public function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents regoper PostgreSQL Field
public class RegoperValue {
    public string? value;
    public function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents regoperator PostgreSQL Field
public class RegoperatorValue {
    public string? value;
    public function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents regproc PostgreSQL Field
public class RegprocValue {
    public string? value;
    public function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents regprocedure PostgreSQL Field
public class RegprocedureValue {
    public string? value;
    public function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents regrole PostgreSQL Field
public class RegroleValue {
    public string? value;
    public function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents regtype PostgreSQL Field
public class RegtypeValue {
    public string? value;
    public function init(string? value = ()) {
        self.value = value;
    }  
}

# Represents regtype PostgreSQL Field
public class PGXmlValue {
    public string|xml? value;
    public function init(string|xml? value = ()) {
        self.value = value;
    }  
}

# Represents PostgreSQL InOutParameter used in procedure calls.
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
        'class: "org.ballerinalang.postgresql.nativeimpl.OutParameterProcessor"
    } external;
}

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

//TODO: Need to fix names

// These Geometric Types are use for Both Execute and Query Operation

public type PointRecord record {
    decimal x;
    decimal y;
};


public type LsegRecord record {
    decimal x1; 
    decimal y1;
    decimal x2; 
    decimal y2;
};


public type BoxRecord record {
    decimal x1; 
    decimal y1;
    decimal x2; 
    decimal y2;
};

public type PathRecord record {
    boolean isOpen = false;
    PointRecord[] points;
};

public type PolygonRecord record {
    PointRecord[] points;
};

public type CircleRecord record {
    decimal x;
    decimal y;
    decimal r;
};

public type LineRecord record {
    decimal a; 
    decimal b;
    decimal c;
};

// This Interval Type is use for Both Execute and Query Operations

public type IntervalRecord record {
    int years = 0;
    int months = 0;
    int days = 0;
    int hours = 0;
    int minutes = 0;
    decimal seconds = 0;
};

// These Range Types are use for Both Execute and Query Operations
public type Int4rangeRecord record {
    int upper;
    int lower;
    boolean isUpperboundInclusive = false;
    boolean isLowerboundInclusive = false;
};

public type Int8rangeRecord record {
    int upper;
    int lower;
    boolean isUpperboundInclusive = false;
    boolean isLowerboundInclusive = false;
};

public type NumrangeRecord record {
    decimal upper; 
    decimal lower; 
    boolean isUpperboundInclusive = false; 
    boolean isLowerboundInclusive = false;
};

public type TsrangeRecord record {
    string upper; 
    string lower; 
    boolean isUpperboundInclusive = false; 
    boolean isLowerboundInclusive = false;
};

public type TstzrangeRecord record {
    string upper; 
    string lower; 
    boolean isUpperboundInclusive = false; 
    boolean isLowerboundInclusive = false;
};

public type DaterangeRecord record {
    string upper; 
    string lower; 
    boolean isUpperboundInclusive = false; 
    boolean isLowerboundInclusive = false;
};
