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

import ballerina/crypto;
import ballerina/sql;
import ballerina/time;

# Provides a set of configurations for the PostgreSQL client to be passed internally within the module.
#
# + host - URL of the database to connect
# + port - Port of the database to connect
# + user - Username for the database connection
# + password - Password for the database connection
# + database - Name of the database
# + options - PostgreSQL datasource `Options` to be configured
# + connectionPool - Properties for the connection pool configuration. For more details, see the `sql:ConnectionPool`

type ClientConfiguration record {|
    string host;
    int port;
    string? user;
    string? password;
    string? database;
    Options? options;
    sql:ConnectionPool? connectionPool;
|};

# PostgreSQL database options.
#
# + ssl - SSL Configuration to be used
# + connectTimeout - The timeout value used for socket connect operations.
#                    If connecting to the server takes longer than this value, the connection is broken.
#                    Value of zero means that it is disabled.
# + socketTimeout - The timeout value used for socket read operations.
#                   If reading from the server takes longer than this value, the connection is closed
#                   Value of zero means that it is disabled.
# + loginTimeout - Specify how long to wait for establishment of a database connection.
#                  Value of zero means that it is infinite.
# + rowFetchSize - Determine the number of rows fetched in the `ResultSet` by one fetch with a trip to the database.
# + cachedMetadataFieldsCount - Specifies the maximum number of fields to be cached per connection.
#                           A value of 0 disables the cache.
# + cachedMetadataFieldSize - Specifies the maximum size (in megabytes) of fields to be cached per connection.
#                            A value of 0 disables the cache.
# + preparedStatementThreshold - Determine the number of `PreparedStatement` executions required before switching
#                                over to use server-side prepared statements.
# + preparedStatementCacheQueries - Determine the number of queries that are cached in each connection.
# + preparedStatementCacheSize - Determine the maximum size (in mebibytes) of the prepared queries.
# + cancelSignalTimeout - Time (in seconds) by which, the cancel command is sent out of band over its own connection
#                         so that the cancel message itself can get stuck. The default value is 10 seconds
# + keepAliveTcpProbe - Enable or disable the TCP keep-alive probe
# + binaryTransfer - Use the binary format for sending and receiving data if possible

public type Options record {|
  SecureSocket ssl = {};
  decimal connectTimeout = 0;
  decimal socketTimeout = 0;
  decimal loginTimeout = 0;
  int rowFetchSize?;
  int cachedMetadataFieldsCount?;
  int cachedMetadataFieldSize?;
  int preparedStatementThreshold?;
  int preparedStatementCacheQueries?;
  int preparedStatementCacheSize?;
  decimal cancelSignalTimeout = 10;
  boolean keepAliveTcpProbe?;
  boolean binaryTransfer?;
|};

# Possible values for the SSL mode.
#
public enum SSLMode {
   PREFER,
   REQUIRE,
   DISABLE,
   ALLOW,
   VERIFY_CA = "VERIFY-CA",
   VERIFY_FULL = "VERIFY-FULL"
}

# The SSL configuration to be used when connecting to the PostgreSQL server.
#
# + mode - The `SSLMode` to be used during the connection
# + key - Keystore configuration of the client certificates
# + rootcert - File name of the SSL root certificate. Defaults to the `defaultdir/root.crt`.
#             in which the `defaultdir` is `${user.home}/.postgresql/` in Unix systems and
#             `%appdata%/postgresql/` on Windows.
public type SecureSocket record {|
    SSLMode mode = PREFER;
    string rootcert?;
    crypto:KeyStore | CertKey key?;
|};

# Represents the combination of the certificate, private key, and private key password if encrypted
#
# + certFile - A file containing the client certificate
# + keyFile - A file containing the client private key
# + keyPassword - Password of the private key if it is encrypted
public type CertKey record {|
   string certFile;
   string keyFile;
   string keyPassword?;
|};

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
public type NumericRange record {
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
