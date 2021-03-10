import ballerina/sql;
import ballerina/test;

public type NumericRecord record {
    int row_id;
    int smallint_type;
    int int_type;
    int bigint_type;
    decimal decimal_type;
    decimal numeric_type;
    float real_type;
    float double_type;
    int smallserial_type;
    int serial_type;
    int bigserial_type;
};

@test:Config {
    groups: ["datatypes"]
}
function testSelectFromNumericDataTable() {
    int rowId = 1;
    
    sql:ParameterizedQuery sqlQuery = `select * from Numerictypes where row_id = ${rowId}`;

    _ = validateNumericTableResult(simpleQueryPostgresqlClient(sqlQuery, NumericRecord, database = "query_db"));
}

public function validateNumericTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        decimal decimalVal = 123.456;
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["smallint_type"], 1);
        test:assertEquals(returnData["int_type"], 123);
        test:assertEquals(returnData["bigint_type"], 123456);
        test:assertEquals(returnData["decimal_type"], decimalVal);
        test:assertEquals(returnData["numeric_type"], decimalVal);
        test:assertTrue(returnData["real_type"] is float);
        test:assertTrue(returnData["double_type"] is float);
        test:assertEquals(returnData["smallserial_type"], 1);
        test:assertEquals(returnData["serial_type"], 123);
        test:assertEquals(returnData["bigserial_type"], 123456);
    } 
}

public type CharacterRecord record {
    int row_id;
    string char_type;
    string varchar_type;
    string text_type;
    string name_type;
};

@test:Config {
    groups: ["datatypes"]
}
function testSelectFromCharacterDataTable() {
    int rowId = 1;
    
    sql:ParameterizedQuery sqlQuery = `select * from charactertypes where row_id = ${rowId}`;

    _ = validateCharacterTableResult(simpleQueryPostgresqlClient(sqlQuery, CharacterRecord, database = "query_db"));
}

public function validateCharacterTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["char_type"], "This is a char1");
        test:assertEquals(returnData["varchar_type"], "This is a varchar1");
        test:assertEquals(returnData["text_type"], "This is a text1");   
        test:assertEquals(returnData["name_type"], "This is a name1");
    } 
}

public type BooleanRecord record {
  int row_id;
  boolean boolean_type;
};

@test:Config {
    groups: ["datatypes"]
}
function testSelectFromBooleanDataTable() {
    int rowId = 1;
    
    sql:ParameterizedQuery sqlQuery = `select * from booleantypes where row_id = ${rowId}`;

    _ = validateBooleanTableResult(simpleQueryPostgresqlClient(sqlQuery, BooleanRecord, database = "query_db"));
}

public function validateBooleanTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["boolean_type"], true);
    } 
}

public type NetworkRecord record {
    
    int row_id;
    string inet_type;
    string cidr_type;
    string macaddr_type;
    string macaddr8_type;
};

@test:Config {
    groups: ["datatypes"]
}
function testSelectFromNetworkDataTable() {
    int rowId = 1;
    
    sql:ParameterizedQuery sqlQuery = `select * from networktypes where row_id = ${rowId}`;

    _ = validateNetworkTableResult(simpleQueryPostgresqlClient(sqlQuery, NetworkRecord, database = "query_db"));
}

public function validateNetworkTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["inet_type"], "192.168.0.1/24");
        test:assertEquals(returnData["cidr_type"], "::ffff:1.2.3.0/120");
        test:assertEquals(returnData["macaddr_type"], "08:00:2b:01:02:03");   
        test:assertEquals(returnData["macaddr8_type"], "08:00:2b:01:02:03:04:05");
    } 
}

public type GeometricRecord record {
    int row_id;
    string point_type;
    string line_type;
    string lseg_type;
    string box_type;
    string circle_type;
    string? path_type;
    string? polygon_type;
};

// public type GeometricRecord record {
//     int row_id;
//     string point_type;
//     string line_type;
//     string lseg_type;
//     string box_type;
//     string circle_type;
//     string? path_type;
//     string? polygon_type;
// };

@test:Config {
    groups: ["datatypes"]
}
function testSelectFromGeometricDataTable() {
    int rowId = 1;

    sql:ParameterizedQuery sqlQuery = `select * from geometrictypes where row_id = ${rowId}`;

     _ = validateGeometricTableResult(simpleQueryPostgresqlClient(sqlQuery, GeometricRecord, database = "query_db"));
}

public function validateGeometricTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["point_type"], "(1,2)");
        test:assertEquals(returnData["line_type"], "{1,2,3}");
        test:assertEquals(returnData["lseg_type"], "[(1,1),(2,2)]");   
        test:assertEquals(returnData["box_type"], "(2,2),(1,1)"); 
        test:assertEquals(returnData["circle_type"], "<(1,1),1>");
    } 
}

public type UuidRecord record {
  int row_id;
  string uuid_type;
};

@test:Config {
    groups: ["datatypes"]
}
function testSelectFromUuidDataTable() {
    int rowId = 1;
    UuidValue uuidType = new ("a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11");
    
    sql:ParameterizedQuery sqlQuery = `select * from uuidtypes where row_id = ${rowId}`;

    _ = validateUuidTableResult(simpleQueryPostgresqlClient(sqlQuery, UuidRecord, database = "query_db"));
}

public function validateUuidTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["uuid_type"], "a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11");
    } 
}

public type TextSearchRecord record {
  int row_id;
  string tsvector_type;
  string tsquery_type;
};

@test:Config {
    groups: ["datatypes"]
}
function testSelectFromTextSearchDataTable() {
    int rowId = 1;
    
    sql:ParameterizedQuery sqlQuery = `select * from TextSearchTypes where row_id = ${rowId}`;

    _ = validateTextSearchTableResult(simpleQueryPostgresqlClient(sqlQuery, TextSearchRecord, database = "query_db"));
}

public function validateTextSearchTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["tsvector_type"], "'a' 'and' 'ate' 'cat' 'fat' 'mat' 'on' 'rat' 'sat'");
        test:assertEquals(returnData["tsquery_type"], "'fat' & 'rat'");
    } 
}

public type JsonRecord record {
  int row_id;
  json json_type;
  json jsonb_type;
  string jsonpath_type;
};

@test:Config {
    groups: ["datatypes"]
}
function testSelectFromJsonDataTable() {
    int rowId = 1;
    
    sql:ParameterizedQuery sqlQuery = `select * from JsonTypes where row_id = ${rowId}`;

    _ = validateJsonTableResult(simpleQueryPostgresqlClient(sqlQuery, JsonRecord, database = "query_db"));
}

public function validateJsonTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["json_type"], {"key1": "value", "key2": 2});
        test:assertEquals(returnData["jsonb_type"], {"key1": "value", "key2": 2});
        test:assertEquals(returnData["jsonpath_type"], "$.\"floor\"[*].\"apt\"[*]?(@.\"area\" > 40 && @.\"area\" < 90)?(@.\"rooms\" > 1)");
    } 
}

// public type DateTimeRecord record {
//   int row_id;
//   time:Time date_type;
//   time:Time time_type;
//   time:Time timetz_type;
//   time:Time timestamp_type;
//   time:Time timestamptz_type;
//   IntervalValue interval_type;
// };

public type DateTimeRecord record {
  int row_id;
  string date_type;
  string time_type;
  string timetz_type;
  string timestamp_type;
  string timestamptz_type;
  string interval_type;
};

@test:Config {
    groups: ["datatypes"]
}
function testSelectFromDateDataTable() {
    int rowId = 1;
    
    sql:ParameterizedQuery sqlQuery = `select * from DateTimeTypes where row_id = ${rowId}`;

    _ = validateDateTableResult(simpleQueryPostgresqlClient(sqlQuery, DateTimeRecord, database = "query_db"));
}

public function validateDateTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["time_type"], "09:35:06.000+05:30");
        test:assertEquals(returnData["timetz_type"], "13:35:06.000+05:30");
        test:assertEquals(returnData["timestamp_type"], "1999-01-08T10:05:06.000+06:00");
        test:assertEquals(returnData["timestamptz_type"], "2004-10-19T14:23:54.000+06:00");
        test:assertEquals(returnData["date_type"], "1999-01-08+06:00");
        test:assertEquals(returnData["interval_type"], "1 year 2 mons 3 days 04:05:06");
    } 
}

// public type RangeRecord record {
//   int row_id;
//   record{} int4range_type;
//   record{} int8range_type;
//   record{} numrange_type;
//   record{} tsrange_type;
//   record{} tstzrange_type;
//   record{} daterange_type;
// };

public type RangeRecord record {
  int row_id;
  string int4range_type;
  string int8range_type;
  string numrange_type;
  string tsrange_type;
  string tstzrange_type;
  string daterange_type;
};

@test:Config {
    groups: ["datatypes"]
}
function testSelectFromRangeDataTable() {
    int rowId = 1;
    
    sql:ParameterizedQuery sqlQuery = `select * from RangeTypes where row_id = ${rowId}`;

    _ = validateRangeTableResult(simpleQueryPostgresqlClient(sqlQuery, RangeRecord, database = "query_db"));
}

public function validateRangeTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["int4range_type"], "[3,50)");
        test:assertEquals(returnData["int8range_type"], "[11,100)");
        test:assertEquals(returnData["numrange_type"], "(0,24)");
        test:assertEquals(returnData["tsrange_type"], "(\"2010-01-01 14:30:00\",\"2010-01-01 15:30:00\")");
        test:assertEquals(returnData["tstzrange_type"], "(\"2010-01-01 14:30:00+05:30\",\"2010-01-01 15:30:00+05:30\")");
        test:assertEquals(returnData["daterange_type"], "[2010-01-02,2010-01-03)");
    } 
}

public type BitRecord record {
  int row_id;
//   string bitstring_type;
  string varbitstring_type;
  boolean bit_type;
};

@test:Config {
    groups: ["datatypes"]
}
function testSelectFromBitDataTable() {
    int rowId = 1;
    
    sql:ParameterizedQuery sqlQuery = `select row_id, varbitstring_type, bit_type from BitTypes where row_id = ${rowId}`;

    _ = validateBitTableResult(simpleQueryPostgresqlClient(sqlQuery, BitRecord, database = "query_db"));
}

public function validateBitTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        // test:assertEquals(returnData["bitstring_type"], "1110001100");
        test:assertEquals(returnData["varbitstring_type"], "1101");
        test:assertEquals(returnData["bit_type"], true);
    } 
}

public type PglsnRecord record {
  int row_id;
  string pglsn_type;
};

@test:Config {
    groups: ["datatypes"]
}
function testSelectFromPglsnDataTable() {
    int rowId = 1;
    
    sql:ParameterizedQuery sqlQuery = `select * from Pglsntypes where row_id = ${rowId}`;

    _ = validatePglsnTableResult(simpleQueryPostgresqlClient(sqlQuery, PglsnRecord, database = "query_db"));
}

public function validatePglsnTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["pglsn_type"], "16/B374D848");
    } 
}

public type ObjectidentifierRecord record {
  int row_id;
  string oid_type;
  string regclass_type;
  string regconfig_type;
  string regdictionary_type;
  string regnamespace_type;
  string regoper_type;
  string regoperator_type;
  string regproc_type;
  string regprocedure_type;
  string regrole_type;
  string regtype_type;
};

@test:Config {
    groups: ["datatypes"]
}
function testSelectFromObjectidentifierDataTable() {
    int rowId = 1;
    
    sql:ParameterizedQuery sqlQuery = `select * from Objectidentifiertypes where row_id = ${rowId}`;

    _ = validateObjectidentifierTableResult(simpleQueryPostgresqlClient(sqlQuery, ObjectidentifierRecord, database = "query_db"));
}

public function validateObjectidentifierTableResult(record{}? returnData) {
    if (returnData is ()) {
        test:assertFail("Empty row returned.");
    } else {
        test:assertEquals(returnData["row_id"], 1);
        test:assertEquals(returnData["oid_type"], "12");
        test:assertEquals(returnData["regclass_type"], "pg_type");
        test:assertEquals(returnData["regconfig_type"], "english");
        test:assertEquals(returnData["regdictionary_type"], "simple");
        test:assertEquals(returnData["regnamespace_type"], "pg_catalog");
        test:assertEquals(returnData["regoper_type"], "!");
        test:assertEquals(returnData["regoperator_type"], "*(integer,integer)");
        test:assertEquals(returnData["regproc_type"], "now");
        test:assertEquals(returnData["regprocedure_type"], "sum(integer)");
        test:assertEquals(returnData["regrole_type"], "postgres");
        test:assertEquals(returnData["regtype_type"], "integer");
    } 
}

function simpleQueryPostgresqlClient(@untainted string|sql:ParameterizedQuery sqlQuery, typedesc<record {}>? resultType = (), string database = simpleParamsDb)
returns @tainted record {}? {
    Client dbClient = checkpanic new (host, user, password, database, port);
    stream<record {}, error> streamData = dbClient->query(sqlQuery, resultType);
    record {|record {} value;|}? data = checkpanic streamData.next();
    checkpanic streamData.close();
    record {}? value = data?.value;
    checkpanic dbClient.close();
    return value;
}
