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

import ballerina/time;

# Represents the Point datatype in PostgreSQL.
#
# + x - The x coordinate of the point
# + y - The y coordinate of the point
public type Point record {
    decimal x;
    decimal y;
};

# Represents the Line Segment datatype in PostgreSQL.
#
# + x1 - The x coordinate of the first point of the line segment
# + y1 - The y coordinate of the first point of the line segment
# + x2 - The x coordinate of the second point of the line segment
# + y2 - The y coordinate of the second point of the line segment
public type LineSegment record {
    decimal x1;
    decimal y1;
    decimal x2;
    decimal y2;
};

# Represents the Box datatype in PostgreSQL.
#
# + x1 - The x ccordinate of a corner of the box
# + y1 - The y ccordinate of a corner of the box
# + x2 - The x cocrdinate of the opposite corner of the box
# + y2 - The y cocrdinate of the opposite corner of the box
public type Box record {
    decimal x1;
    decimal y1;
    decimal x2;
    decimal y2;
};

# Represents the Path datatype in PostgreSQL.
#
# + open - True if the path is open, false if closed
# + points - The points defining this path
public type Path record {
    boolean open = false;
    Point[] points;
};

# Represents the Polygon datatype in PostgreSQL.
#
# + points - The points defining the polygon
public type Polygon record {
    Point[] points;
};

# Represents the Circle datatype in PostgreSQL.
#
# + x - The x coordinate of the center
# + y - The y coordinate of the center
# + r - The radius of the circle
public type Circle record {
    decimal x;
    decimal y;
    decimal r;
};

# Represents the Line satatype in PostgreSQL.
#
# + a - The a value in the standard line equation ax + by + c = 0  
# + b - The b value in the standard line equation ax + by + c = 0  
# + c - The c value in the standard line equation ax + by + c = 0 
public type Line record {
    decimal a;
    decimal b;
    decimal c;
};

# Represents the Interval datatype in PostgreSQL.
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

# Represents the Int4Range datatype in PostgreSQL.
#
# + upper - Upper value in the range
# + lower - Lower value in the range
# + upperboundInclusive - True if upper value is included in the range
# + lowerboundInclusive - True if lower value is included in the range
public type Range record {
    anydata upper;
    anydata lower;
    boolean upperboundInclusive = false;
    boolean lowerboundInclusive = false;
};

# Represents the Int4Range datatype in PostgreSQL.
#
# + upper - Upper value in the range
# + lower - Lower value in the range
public type IntegerRange record {
    *Range;
    int upper;
    int lower;
};

# Represents the Int8Range datatype in PostgreSQL.
#
# + upper - Upper value in the range
# + lower - Lower value in the range
public type LongRange record {
    *Range;
    int upper;
    int lower;
};

# Represents the NumRange Datatype in PostgreSQL.
#
# + upper - Upper value in the range
# + lower - Lower value in the range
public type NumericRange record {
    *Range;
    decimal upper;
    decimal lower;
};

# Represents the Timestamp Range datatype in PostgreSQL.
#
# + upper - Upper value in the range
# + lower - Lower value in the range
public type TimestampRange record {
    *Range;
    string upper;
    string lower;
};

# Represents the Timestamp with Timezone Range datatype in PostgreSQL.
#
# + upper - Upper value in the range
# + lower - Lower value in the range
public type TimestamptzRange record {
    *Range;
    string upper;
    string lower;
};

# Represents the Date Range datatype in PostgreSQL.
#
# + upper - Upper value in the range
# + lower - Lower value in the range
public type DateRange record {
    *Range;
    string upper;
    string lower;
};

# Represents the values for user-defined datatypes in PostgreSQL.
#
# + values - List of values in the user-defined type
public type CustomValues record {
    anydata[]? values;
};

# Represents a value for Enum datatypes in PostgreSQL.
#
# + value - Value for the Enum
public type Enum record {
    string value?;
};

# Represents a user-defined datatype in PostgreSQL.
#
# + sqlTypeName - SQL type name
# + values - List of values in the user-defined type
public type CustomValueRecord record {
    string sqlTypeName;
    CustomValues? values;
};

# Represents the Enum datatype in PostgreSQL.
#
# + sqlTypeName - SQL type name
# + value - Value for the Enum
public type EnumRecord record {
    string sqlTypeName;
    Enum? value;
};

# Represents the Timestamp (Civil) Range datatype in PostgreSQL.
#
# + upper - Upper value in the range
# + lower - Lower value in the range
public type TimestampCivilRange record {
    *Range;
    time:Civil upper;
    time:Civil lower;
};

# Represents the Timestamp (Civil) with Timezone Range Datatype in PostgreSQL.
#
# + upper - Upper value in the range
# + lower - Lower value in the range
public type TimestamptzCivilRange record {
    *Range;
    time:Civil upper;
    time:Civil lower;
};

# Represents the Date (Record) Range datatype in PostgreSQL.
#
# + upper - Upper value in the range
# + lower - Lower value in the range
public type DateRecordRange record {
    *Range;
    time:Date upper;
    time:Date lower;
};
