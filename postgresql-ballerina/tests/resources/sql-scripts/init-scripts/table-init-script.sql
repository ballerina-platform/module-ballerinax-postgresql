DROP TABLE IF EXISTS NumericTypes;
CREATE TABLE IF NOT EXISTS NumericTypes( row_id SERIAL, smallint_type smallint, int_type integer, bigint_type bigint, decimal_type decimal, numeric_type numeric, real_type real, double_type double precision, smallserial_type smallserial, serial_type serial, bigserial_type bigserial, PRIMARY KEY(row_id) );
INSERT INTO
   NumericTypes( smallint_type, int_type, bigint_type, decimal_type, numeric_type, real_type, double_type, smallserial_type, serial_type, bigserial_type ) 
VALUES
   (
      1, 123, 123456, 123.456, 123.456, 234.567, 234.567, 1, 123, 123456 
   )
;
DROP TABLE IF EXISTS NumericTypes2;
CREATE TABLE IF NOT EXISTS NumericTypes2( row_id SERIAL, smallint_type smallint, int_type integer, bigint_type bigint, decimal_type decimal, numeric_type numeric, real_type real, double_type double precision, PRIMARY KEY(row_id) );
INSERT INTO
   NumericTypes2( smallint_type, int_type, bigint_type, decimal_type, numeric_type, real_type, double_type ) 
VALUES
   (
      1, 123, 123456, 123.456, 123.456, 234.567, 234.567 
   )
;
INSERT INTO
   NumericTypes2( smallint_type, int_type, bigint_type, decimal_type, numeric_type, real_type, double_type ) 
VALUES
   (
      null, null, null, null, null, null, null 
   )
;
DROP TABLE IF EXISTS CharacterTypes;
CREATE TABLE IF NOT EXISTS CharacterTypes( row_id SERIAL, char_type char(15), varchar_type varchar(20), text_type text, name_type name, PRIMARY KEY(row_id) );
INSERT INTO
   CharacterTypes( char_type, varchar_type, text_type, name_type ) 
VALUES
   (
      'This is a char1', 'This is a varchar1', 'This is a text1', 'This is a name1' 
   )
;
INSERT INTO
   CharacterTypes( char_type, varchar_type, text_type, name_type ) 
VALUES
   (
      'This is a char2', 'This is a varchar2', 'This is a text2', 'This is a name2' 
   )
;
INSERT INTO
   CharacterTypes( char_type, varchar_type, text_type, name_type ) 
VALUES
   (
      null, null, null, null 
   )
;
DROP TABLE IF EXISTS BooleanTypes;
CREATE TABLE IF NOT EXISTS BooleanTypes( row_id SERIAL, boolean_type boolean, PRIMARY KEY(row_id) );
INSERT INTO
   BooleanTypes( boolean_type ) 
VALUES
   (
      true 
   )
;
INSERT INTO
   BooleanTypes( boolean_type ) 
VALUES
   (
      null 
   )
;
DROP TABLE IF EXISTS NetworkTypes;
CREATE TABLE IF NOT EXISTS NetworkTypes( row_id SERIAL, inet_type inet, cidr_type cidr, macaddr_type macaddr, macaddr8_type macaddr8, PRIMARY KEY(row_id) );
INSERT INTO
   NetworkTypes( inet_type, cidr_type, macaddr_type, macaddr8_type ) 
VALUES
   (
      '192.168.0.1/24', '::ffff:1.2.3.0/120', '08:00:2b:01:02:03', '08-00-2b-01-02-03-04-05' 
   )
;
INSERT INTO
   NetworkTypes( inet_type, cidr_type, macaddr_type, macaddr8_type ) 
VALUES
   (
      null, null, null, null 
   )
;
DROP TABLE IF EXISTS GeometricTypes;
CREATE TABLE IF NOT EXISTS GeometricTypes( row_id SERIAL, point_type POINT, line_type LINE, lseg_type LSEG, path_type PATH, circle_type CIRCLE, box_type BOX, polygon_type POLYGON, PRIMARY KEY(row_id) );
INSERT INTO
   GeometricTypes( point_type, line_type, lseg_type, box_type, path_type, polygon_type, circle_type ) 
VALUES
   (
      '(1,2)', '{1,2,3}', '((1,1),(2,2))', '((1,1),(2,2))', '[(1,1),(2,2)]', '((1,1),(2,2))', '<1,1,1>' 
   )
;
INSERT INTO
   GeometricTypes( point_type, line_type, lseg_type, box_type, path_type, polygon_type, circle_type ) 
VALUES
   (
      null, null, null, null, null, null, null 
   )
;
DROP TABLE IF EXISTS UuidTypes;
CREATE TABLE IF NOT EXISTS UuidTypes( row_id SERIAL, uuid_type UUID, PRIMARY KEY(row_id) );
INSERT INTO
   UuidTypes( uuid_type ) 
VALUES
   (
      'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11' 
   )
;
INSERT INTO
   UuidTypes( uuid_type ) 
VALUES
   (
      null 
   )
;
DROP TABLE IF EXISTS TextSearchTypes;
CREATE TABLE IF NOT EXISTS TextSearchTypes( row_id SERIAL, tsvector_type TSVECTOR, tsquery_type TSQUERY, PRIMARY KEY(row_id) );
INSERT INTO
   TextSearchTypes( tsvector_type, tsquery_type ) 
VALUES
   (
      'a fat cat sat on a mat and ate a fat rat', 'fat & rat' 
   )
;
INSERT INTO
   TextSearchTypes( tsvector_type, tsquery_type ) 
VALUES
   (
      null, null 
   )
;
DROP TABLE IF EXISTS JsonTypes;
CREATE TABLE IF NOT EXISTS JsonTypes( row_id SERIAL, json_type JSON, jsonb_type JSONB, jsonpath_type JSONPATH, PRIMARY KEY(row_id) );
INSERT INTO
   JsonTypes( json_type, jsonb_type, jsonpath_type ) 
VALUES
   (
      '{"key1": "value", "key2": 2}', '{"key1": "value", "key2": 2}', '$."floor"[*]."apt"[*]?(@."area" > 40 && @."area" < 90)?(@."rooms" > 1)' 
   )
;
INSERT INTO
   JsonTypes( json_type, jsonb_type, jsonpath_type ) 
VALUES
   (
      null, null, null 
   )
;
DROP TABLE IF EXISTS DateTimeTypes;
CREATE TABLE IF NOT EXISTS DateTimeTypes( row_id SERIAL, time_type TIME, timetz_type TIMETZ, timestamp_type TIMESTAMP, timestamptz_type TIMESTAMPTZ, date_type DATE, interval_type INTERVAL, PRIMARY KEY(row_id) );
INSERT INTO
   DateTimeTypes( time_type, timetz_type, timestamp_type, timestamptz_type, date_type, interval_type ) 
VALUES
   (
      '04:05:06', '2003-04-12 04:05:06 America/New_York', '1999-01-08 04:05:06', '2004-10-19 10:23:54+02', '1999-01-08', 'P1Y2M3DT4H5M6S' 
   )
;
INSERT INTO
   DateTimeTypes( time_type, timetz_type, timestamp_type, timestamptz_type, date_type, interval_type ) 
VALUES
   (
      null, null, null, null, null, null 
   )
;
DROP TABLE IF EXISTS RangeTypes;
CREATE TABLE IF NOT EXISTS RangeTypes( row_id SERIAL, int4range_type INT4RANGE, int8range_type INT8RANGE, numrange_type NUMRANGE, tsrange_type TSRANGE, tstzrange_type TSTZRANGE, daterange_type DATERANGE, PRIMARY KEY(row_id) );
INSERT INTO
   RangeTypes( int4range_type, int8range_type, numrange_type, tsrange_type, tstzrange_type, daterange_type ) 
VALUES
   (
      '(2,50)', '(10,100)', '(0,24)', '(2010-01-01 14:30, 2010-01-01 15:30)', '(2010-01-01 14:30, 2010-01-01 15:30)', '(2010-01-01 14:30, 2010-01-03 )' 
   )
;
INSERT INTO
   RangeTypes( int4range_type, int8range_type, numrange_type, tsrange_type, tstzrange_type, daterange_type ) 
VALUES
   (
      null, null, null, null, null, null 
   )
;
DROP TABLE IF EXISTS BitTypes;
CREATE TABLE IF NOT EXISTS BitTypes( row_id SERIAL, bitstring_type BIT(10), varbitstring_type BIT VARYING(10), bit_type BIT, PRIMARY KEY(row_id) );
INSERT INTO
   BitTypes( bitstring_type, varbitstring_type, bit_type ) 
VALUES
   (
      '1110000111', '1101', '1' 
   )
;
INSERT INTO
   BitTypes( bitstring_type, varbitstring_type, bit_type ) 
VALUES
   (
      null, null, null 
   )
;
DROP TABLE IF EXISTS PGLSNTypes;
CREATE TABLE IF NOT EXISTS PglsnTypes( row_id SERIAL, pglsn_type PG_LSN, PRIMARY KEY(row_id) );
INSERT INTO
   PglsnTypes( pglsn_type ) 
VALUES
   (
      '16/B374D848' 
   )
;
INSERT INTO
   PglsnTypes( pglsn_type ) 
VALUES
   (
      null 
   )
;
set
   lc_monetary to "en_US.utf8";
DROP TABLE IF EXISTS MoneyTypes;
CREATE TABLE IF NOT EXISTS MoneyTypes( row_id SERIAL, money_type MONEY, PRIMARY KEY(row_id) );
INSERT INTO
   MoneyTypes( money_type ) 
VALUES
   (
      '124.56'::money 
   )
;
INSERT INTO
   MoneyTypes( money_type ) 
VALUES
   (
      null 
   )
;
DROP TABLE IF EXISTS objectidentifiertypes;
CREATE TABLE IF NOT EXISTS objectIdentifiertypes( row_id SERIAL, oid_type OID, regclass_type REGCLASS, regconfig_type REGCONFIG, regdictionary_type REGDICTIONARY, regnamespace_type REGNAMESPACE, regoper_type REGOPER, regoperator_type REGOPERATOR, regproc_type REGPROC, regprocedure_type REGPROCEDURE, regrole_type REGROLE, regtype_type REGTYPE, PRIMARY KEY(row_id) );
INSERT INTO
   objectidentIfiertypes( oid_type, regclass_type, regconfig_type, regdictionary_type, regnamespace_type, regoper_type, regoperator_type, regproc_type, regprocedure_type, regrole_type, regtype_type ) 
VALUES
   (
      '12', 'pg_type', 'english', 'simple', 'pg_catalog', '!', '*(integer,integer)', 'now', 'sum(integer)', 'postgres', 'integer' 
   )
;
INSERT INTO
   objectidentIfiertypes( oid_type, regclass_type, regconfig_type, regdictionary_type, regnamespace_type, regoper_type, regoperator_type, regproc_type, regprocedure_type, regrole_type, regtype_type ) 
VALUES
   (
      null, null, null, null, null, null, null, null, null, null, null 
   )
;
DROP TABLE IF EXISTS XmlTypes;
CREATE TABLE IF NOT EXISTS XmlTypes( row_id SERIAL, xml_type XML, PRIMARY KEY(row_id) );
INSERT INTO
   XmlTypes( xml_type ) 
VALUES
   (
      '<foo><tag>bar</tag><tag>tag</tag></foo>' 
   )
;
INSERT INTO
   XmlTypes( xml_type ) 
VALUES
   (
      null 
   )
;
DROP TABLE IF EXISTS XmlTypes;
CREATE TABLE IF NOT EXISTS XmlTypes( row_id SERIAL, xml_type XML, PRIMARY KEY(row_id) );
INSERT INTO
   XmlTypes( xml_type ) 
VALUES
   (
      '<foo><tag>bar</tag><tag>tag</tag></foo>' 
   )
;
INSERT INTO
   XmlTypes( xml_type ) 
VALUES
   (
      null 
   )
;
DROP TABLE IF EXISTS BinaryTypes;
CREATE TABLE IF NOT EXISTS BinaryTypes( row_id SERIAL, bytea_type bytea, bytea_escape_type bytea, PRIMARY KEY(row_id) );
INSERT INTO
   BinaryTypes( bytea_type, bytea_escape_type ) 
VALUES
   (
      '\xDEADBEEF', 'abc \153\154\155 \052\251\124' 
   )
;
INSERT INTO
   BinaryTypes( bytea_type, bytea_escape_type ) 
VALUES
   (
      null, null 
   )
;
DROP TABLE IF EXISTS ArrayTypes;
CREATE TABLE IF NOT EXISTS ArrayTypes( row_id SERIAL, smallintarray_type smallint[], intarray_type int[], bigintarray_type bigint[], decimalarray_type decimal[], numericarray_type numeric[], realarray_type real[], doublearray_type double precision[], chararray_type char(15)[], varchararray_type varchar(20)[], textarray_type text[], booleanarray_type boolean[], byteaarray_type bytea[], PRIMARY KEY(row_id) );
INSERT INTO
   ArrayTypes( smallintarray_type, intarray_type, bigintarray_type, decimalarray_type, numericarray_type, realarray_type, doublearray_type, chararray_type, varchararray_type, textarray_type, booleanarray_type, byteaarray_type ) 
VALUES
   (
      '{1,2,3}', '{1000,2000,3000}', '{10000,20000,30000}', '{1.1,2.2,3.3,4.4}', '{1.1,2.2,3.3,4.4}', '{1.23,2.34,3.45,4.56}', '{1.23,2.34,3.45,4.56}', '{"This is a Char1","This is a Char2"}', '{"This is a VarChar1","This is a VarChar2"}', '{"This is a Text1","This is a Text2"}', '{true,false,true}', '{"\XACDE","\XAACCE"}' 
   )
;
INSERT INTO
   ArrayTypes( smallintarray_type, intarray_type, bigintarray_type, decimalarray_type, numericarray_type, realarray_type, doublearray_type, chararray_type, varchararray_type, textarray_type, booleanarray_type, byteaarray_type ) 
VALUES
   (
      null, null, null, null, null, null, null, null, null, null, null, null 
   )
;
DROP TABLE IF EXISTS CustomTypes;
CREATE TABLE IF NOT EXISTS CustomTypes ( row_id serial, complex_type complex, inventory_type inventory_item, primary key(row_id) );
Insert into
   CustomTypes (complex_type, inventory_type) 
Values
   (
      '(1.1, 2.2)', '("Supplier Name", 12332, true)'
   )
;
Insert into
   CustomTypes (complex_type, inventory_type) 
Values
   (
      null, null
   )
;
DROP TABLE IF EXISTS EnumTypes;
CREATE TABLE IF NOT EXISTS EnumTypes ( row_id serial, value_type value, primary key(row_id) );
Insert into
   EnumTypes (value_type) 
Values
   (
      'value1'
   )
;
Insert into
   EnumTypes (value_type) 
Values
   (
      null
   )
;
CREATE TABLE IF NOT EXISTS ArrayTypes2 (
  row_id        INTEGER NOT NULL,
  smallint_array SMALLINT ARRAY,
  int_array     INTEGER ARRAY,
  bigint_array    BIGINT ARRAY,
  decimal_array  DECIMAL ARRAY,
  numeric_array    NUMERIC ARRAY,
  real_array  REAL ARRAY,
  double_array  DOUBLE PRECISION ARRAY,
  boolean_array BOOLEAN ARRAY,
  char_array CHAR(15) ARRAY,
  varchar_array VARCHAR(15) ARRAY,
  string_array  VARCHAR(20) ARRAY,
  date_array DATE ARRAY,
  time_array TIME ARRAY,
  timetz_array TIMETZ ARRAY,
  timestamp_array TIMESTAMP ARRAY,
  timestamptz_array TIMESTAMPTZ ARRAY,
  bytea_array BYTEA ARRAY,
  bit_array BIT ARRAY,
  PRIMARY KEY (row_id)
);

INSERT INTO ArrayTypes2 (
   row_id, 
   smallint_array, 
   int_array, 
   bigint_array, 
   decimal_array, 
   numeric_array, 
   real_array, 
   double_array, 
   char_array, 
   varchar_array, 
   boolean_array, 
   string_array, 
   date_array, 
   time_array, 
   timestamp_array,
   timetz_array, 
   timestamptz_array,
   bytea_array,
   bit_array
   )
  VALUES (
   1, 
   '{12, 232}',
   '{1, 2, 3}',
   '{100000000, 200000000, 300000000}',
   '{245.12, 5559.12, 8796.12}',
   '{12.323, 232.21}',
   '{199.33, 2399.1}',
   '{245.23, 5559.49, 8796.123}',
   '{"Hello", "Ballerina"}',
   '{"Hello", "Ballerina"}',
   '{TRUE, FALSE, TRUE}',
   '{"Hello", "Ballerina"}',
   '{"2017-02-03", "2017-02-03"}',
   '{"11:53:00", "11:53:02"}',
   '{"2017-02-03 11:53:00", "2019-04-05 12:33:10"}',
   '{"11:53:00+02:30", "11:53:02+02:30"}',
   '{"2017-02-03 11:53:00+02:30", "2019-04-05 12:33:10+02:30"}',
   '{"Bytea Value"}',
   '{NULL,"0"}');

INSERT INTO ArrayTypes2 (
   row_id, 
   smallint_array, 
   int_array, 
   bigint_array, 
   decimal_array, 
   numeric_array, 
   real_array, 
   double_array, 
   char_array, 
   varchar_array, 
   boolean_array, 
   string_array, 
   date_array, 
   time_array, 
   timestamp_array,
   timetz_array, 
   timestamptz_array,
   bytea_array,
   bit_array
   )
  VALUES (
   2, 
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   null);

CREATE TABLE IF NOT EXISTS ArrayTypes3 (
  row_id        INTEGER NOT NULL,
  point_array POINT ARRAY,
  line_array LINE ARRAY,
  lseg_array LSEG ARRAY,
  box_array BOX ARRAY,
  path_array PATH ARRAY,
  polygon_array POLYGON ARRAY,
  circle_array CIRCLE ARRAY,
  interval_array INTERVAL ARRAY,
  int4range_array INT4RANGE ARRAY,
  int8range_array INT8RANGE ARRAY,
  numrange_array NUMRANGE ARRAY,
  tsrange_array TSRANGE ARRAY,
  tstzrange_array TSTZRANGE ARRAY,
  daterange_array DATERANGE ARRAY,
  PRIMARY KEY (row_id)
);

INSERT INTO ArrayTypes3 (
   row_id, 
   point_array,
   line_array,
   lseg_array,
   box_array,
   path_array,
   polygon_array,
   circle_array,
   interval_array,
   int4range_array,
   int8range_array,
   numrange_array,
   tsrange_array,
   tstzrange_array,
   daterange_array
    )
   VALUES (
    1, 
    '{"(1,2)","(2,3)"}',
    '{"{1,2,3}","{1,2,3}"}',
    '{"((1,1),(2,2))"}',
    '{"((1,2),(2,2))"}',
    '{"[(1,3),(2,2)]"}',
    '{"((1,4),(2,2))"}',
    '{"<1,1,1>","<1,1,1>"}',
    '{"P1Y2M3DT4H5M6S","P1Y2M3DT4H5M6S"}',
    '{"[1,3)","(1,3]"}',
    '{"[10000,30000]","(10000,30000)"}',
    '{"[1.11,3.33)","(1.11,3.33]"}',
    '{"[2010-01-01 14:30, 2010-01-01 15:30)","(2010-01-01 14:30, 2010-01-01 15:30]"}',
    '{"[2010-01-01 14:30+02:30, 2010-01-01 15:30+01:30)","(2010-01-01 14:30+02:30, 2010-01-01 15:30+01:30]"}',
    '{"[2010-01-01, 2010-01-04)","(2010-01-01, 2010-01-10]"}'
    );

INSERT INTO ArrayTypes3 (
   row_id, 
   point_array,
   line_array,
   lseg_array,
   box_array,
   path_array,
   polygon_array,
   circle_array,
   interval_array,
   int4range_array,
   int8range_array,
   numrange_array,
   tsrange_array,
   tstzrange_array,
   daterange_array
   )
  VALUES (
   2, 
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   null
   );

INSERT INTO ArrayTypes3 (
   row_id, 
   point_array,
   line_array,
   lseg_array,
   box_array,
   path_array,
   polygon_array,
   circle_array,
   interval_array,
   int4range_array,
   int8range_array,
   numrange_array,
   tsrange_array,
   tstzrange_array,
   daterange_array
    )
   VALUES (
    3, 
    '{NULL,"(2,3)"}',
    '{NULL,"{1,2,3}"}',
    '{NULL,"((1,1),(2,2))"}',
    ARRAY[NULL,'((1,2),(2,2))'] :: BOX ARRAY,
    '{NULL,"[(1,3),(2,2)]"}',
    '{NULL,"((1,4),(2,2))"}',
    '{NULL,"<1,1,1>","<1,1,1>"}',
    '{NULL,"P1Y2M3DT4H5M6S","P1Y2M3DT4H5M6S"}',
    '{NULL,"(1,3]"}',
    '{NULL,"(10000,30000)"}',
    '{NULL,"(1.11,3.33]"}',
    '{NULL,"(2010-01-01 14:30, 2010-01-01 15:30]"}',
    '{NULL,"(2010-01-01 14:30+02:30, 2010-01-01 15:30+01:30]"}',
    '{NULL,"(2010-01-01, 2010-01-03]"}'
    );

INSERT INTO ArrayTypes3 (
   row_id, 
   point_array,
   line_array,
   lseg_array,
   box_array,
   path_array,
   polygon_array,
   circle_array,
   interval_array,
   int4range_array,
   int8range_array,
   numrange_array,
   tsrange_array,
   tstzrange_array,
   daterange_array
   )
  VALUES (
   4, 
   ARRAY[Null, Null] :: POINT ARRAY,
   ARRAY[Null, Null] :: LINE ARRAY,
   ARRAY[Null, Null] :: LSEG ARRAY,
   ARRAY[Null, Null] :: BOX ARRAY,
   ARRAY[Null, Null] :: PATH ARRAY,
   ARRAY[Null, Null] :: POLYGON ARRAY,
   ARRAY[Null, Null] :: CIRCLE ARRAY,
   ARRAY[Null, Null] :: INTERVAL ARRAY,
   ARRAY[Null, Null] :: INT4RANGE ARRAY,
   ARRAY[Null, Null] :: INT8RANGE ARRAY,
   ARRAY[Null, Null] :: NUMRANGE ARRAY,
   ARRAY[Null, Null] :: TSRANGE ARRAY,
   ARRAY[Null, Null] :: TSTZRANGE ARRAY,
   ARRAY[Null, Null] :: DATERANGE ARRAY
   );

CREATE TABLE IF NOT EXISTS ArrayTypes4 (
  row_id        INTEGER NOT NULL,
  inet_array INET ARRAY,
  cidr_array CIDR ARRAY,
  macaddr_array MACADDR ARRAY,
  macaddr8_array MACADDR8 ARRAY,
  uuid_array UUID ARRAY,
  tsvector_array TSVECTOR ARRAY,
  tsquery_array TSQUERY ARRAY,
  bitstring_array BIT(10) ARRAY,
  varbitstring_array BIT VARYING(100) ARRAY,
  bit_array BIT ARRAY,
  xml_array XML ARRAY,
  oid_array OID ARRAY,
  regclass_array REGCLASS ARRAY,
  regconfig_array REGCONFIG ARRAY,
  regdictionary_array REGDICTIONARY ARRAY,
  regnamespace_array REGNAMESPACE ARRAY,
  regoper_array REGOPER ARRAY,
  regoperator_array REGOPERATOR ARRAY,
  regproc_array REGPROC ARRAY,
  regprocedure_array REGPROCEDURE ARRAY,
  regrole_array REGROLE ARRAY,
  regtype_array REGTYPE ARRAY,
  PRIMARY KEY (row_id)
);

INSERT INTO ArrayTypes4 (
   row_id, 
   inet_array,
   cidr_array,
   macaddr_array,
   macaddr8_array,
   uuid_array,
   tsvector_array,
   tsquery_array,
   bitstring_array,
   varbitstring_array,
   bit_array,
   xml_array,
   oid_array,
   regclass_array,
   regconfig_array,
   regdictionary_array,
   regnamespace_array,
   regoper_array,
   regoperator_array,
   regproc_array,
   regprocedure_array,
   regrole_array,
   regtype_array
    )
   VALUES (
    1, 
    '{"192.168.0.1/24","192.168.0.1/24"}',
    '{"::ffff:1.2.3.0/120","::ffff:1.2.3.0/120"}',
    '{"08:00:2b:01:02:03","08:00:2b:01:02:03"}',
    '{"08-00-2b-01-02-03-04-05","08-00-2b-01-02-03-04-05"}',
    '{"a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11","a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11"}',
    '{"a fat cat sat on a mat and ate a fat rat","a fat cat sat on a mat and ate a fat rat"}',
    '{"fat & rat","fat & rat"}',
    '{"1110000111","1110000111"}',
    '{"1101","1101"}',
    '{"1","1"}',
    '{"<foo><tag>bar</tag><tag>tag</tag></foo>","<foo><tag>bar</tag><tag>tag</tag></foo>"}',
    '{"12","12"}',
    '{"pg_type","pg_type"}',
    '{"english","english"}',
    '{"simple","simple"}',
    '{"pg_catalog","pg_catalog"}',
    '{"!","!"}',
    '{"*(integer,integer)","*(integer,integer)"}',
    '{"now","now"}',
    '{"sum(integer)","sum(integer)"}',
    '{"postgres","postgres"}',
    '{"integer","integer"}'
    );

INSERT INTO ArrayTypes4 (
   row_id, 
   inet_array,
   cidr_array,
   macaddr_array,
   macaddr8_array,
   uuid_array,
   tsvector_array,
   tsquery_array,
   bitstring_array,
   varbitstring_array,
   bit_array,
   xml_array,
   oid_array,
   regclass_array,
   regconfig_array,
   regdictionary_array,
   regnamespace_array,
   regoper_array,
   regoperator_array,
   regproc_array,
   regprocedure_array,
   regrole_array,
   regtype_array
   )
  VALUES (
   2, 
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   null,
   null
   );

INSERT INTO ArrayTypes4 (
   row_id, 
   inet_array,
   cidr_array,
   macaddr_array,
   macaddr8_array,
   uuid_array,
   tsvector_array,
   tsquery_array,
   bitstring_array,
   varbitstring_array,
   bit_array,
   xml_array,
   oid_array,
   regclass_array,
   regconfig_array,
   regdictionary_array,
   regnamespace_array,
   regoper_array,
   regoperator_array,
   regproc_array,
   regprocedure_array,
   regrole_array,
   regtype_array
    )
   VALUES (
    3, 
    '{NULL,"192.168.0.1/24"}',
    '{NULL,"::ffff:1.2.3.0/120"}',
    '{NULL,"08:00:2b:01:02:03"}',
    '{NULL,"08-00-2b-01-02-03-04-05"}',
    '{NULL,"a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11"}',
    '{NULL,"a fat cat sat on a mat and ate a fat rat"}',
    '{NULL,"fat & rat"}',
    '{NULL,"1110000111"}',
    '{NULL,"1101"}',
    '{NULL,"1"}',
    '{NULL,"<foo><tag>bar</tag><tag>tag</tag></foo>"}',
    '{NULL,"12"}',
    '{NULL,"pg_type"}',
    '{NULL,"english"}',
    '{NULL,"simple"}',
    '{NULL,"pg_catalog"}',
    '{NULL,"!"}',
    '{NULL,"*(integer,integer)"}',
    '{NULL,"now"}',
    '{NULL,"sum(integer)"}',
    '{NULL,"postgres"}',
    '{NULL,"integer"}'
    );

INSERT INTO ArrayTypes4 (
   row_id, 
   inet_array,
   cidr_array,
   macaddr_array,
   macaddr8_array,
   uuid_array,
   tsvector_array,
   tsquery_array,
   bitstring_array,
   varbitstring_array,
   bit_array,
   xml_array,
   oid_array,
   regclass_array,
   regconfig_array,
   regdictionary_array,
   regnamespace_array,
   regoper_array,
   regoperator_array,
   regproc_array,
   regprocedure_array,
   regrole_array,
   regtype_array
   )
  VALUES (
   4, 
   ARRAY[Null, Null] :: INET ARRAY,
   ARRAY[Null, Null] :: CIDR ARRAY,
   ARRAY[Null, Null] :: MACADDR ARRAY,
   ARRAY[Null, Null] :: MACADDR8 ARRAY,
   ARRAY[Null, Null] :: UUID ARRAY,
   ARRAY[Null, Null] :: TSVECTOR ARRAY,
   ARRAY[Null, Null] :: TSQUERY ARRAY,
   ARRAY[Null, Null] :: BIT(3) ARRAY,
   ARRAY[Null, Null] :: BIT VARYING(100) ARRAY,
   ARRAY[Null, Null] :: BIT ARRAY,
   ARRAY[Null, Null] :: XML ARRAY,
   ARRAY[Null, Null] :: OID ARRAY,
   ARRAY[Null, Null] :: REGCLASS ARRAY,
   ARRAY[Null, Null] :: REGCONFIG ARRAY,
   ARRAY[Null, Null] :: REGDICTIONARY ARRAY,
   ARRAY[Null, Null] :: REGNAMESPACE ARRAY,
   ARRAY[Null, Null] :: REGOPER ARRAY,
   ARRAY[Null, Null] :: REGOPERATOR ARRAY,
   ARRAY[Null, Null] :: REGPROC ARRAY,
   ARRAY[Null, Null] :: REGPROCEDURE ARRAY,
   ARRAY[Null, Null] :: REGROLE ARRAY,
   ARRAY[Null, Null] :: REGTYPE ARRAY
   );
