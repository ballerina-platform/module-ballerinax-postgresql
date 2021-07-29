create 
or replace procedure NumericProcedure( row_id_in bigint, smallint_in smallint, int_in int, bigint_in bigint, decimal_in decimal, numeric_in numeric, real_in real, double_in double precision ) language plpgsql as $$ 
begin
   INSERT INTO
      NumericTypes2( row_id, smallint_type, int_type, bigint_type, decimal_type, numeric_type, double_type, real_type ) 
   VALUES
      (
         row_id_in, smallint_in, int_in, bigint_in, decimal_in, numeric_in, double_in, real_in 
      )
;
end
;
 $$ ;
create 
or replace procedure CharacterProcedure( row_id bigint, char_in char(15), varchar_in varchar(15), text_in text, name_in name ) language plpgsql as $$ 
begin
   INSERT INTO
      CharacterTypes (row_id, char_type, varchar_type, text_type, name_type) 
   VALUES
      (
         row_id, char_in, varchar_in, text_in, name_in
      )
;
end
;
 $$ ;
create 
or replace procedure BooleanProcedure( row_id bigint, boolean_in boolean ) language plpgsql as $$ 
begin
   INSERT INTO
      BooleanTypes( row_id, boolean_type ) 
   VALUES
      (
         row_id, boolean_in 
      )
;
end
;
 $$ ;
create 
or replace procedure NetworkProcedure( row_id bigint, inet_in inet, cidr_in cidr, macaddr_in macaddr, macaddr8_in macaddr8 ) language plpgsql as $$ 
begin
   INSERT INTO
      NetworkTypes (row_id, inet_type, cidr_type, macaddr_type, macaddr8_type) 
   VALUES
      (
         row_id, inet_in, cidr_in, macaddr_in, macaddr8_in
      )
;
end
;
 $$ ;
create 
or replace procedure GeometricProcedure( row_id bigint, point_in point, line_in line, lseg_in lseg, box_in box, path_in path, polygon_in polygon, circle_in circle ) language plpgsql as $$
begin
   INSERT INTO
      GeometricTypes( row_id, point_type, line_type, lseg_type, box_type, path_type, polygon_type, circle_type ) 
   VALUES
      (
         row_id, point_in, line_in, lseg_in, box_in, path_in, polygon_in, circle_in 
      )
;
end
;
 $$ ;
create 
or replace procedure UuidProcedure( row_id bigint, uuid_in UUID ) language plpgsql as $$ 
begin
   INSERT INTO
      UuidTypes( row_id, uuid_type ) 
   VALUES
      (
         row_id, uuid_in 
      )
;
end
;
 $$ ;
create 
or replace procedure PglsnProcedure( row_id bigint, pglsn_in pg_lsn ) language plpgsql as $$ 
begin
   INSERT INTO
      PglsnTypes( row_id, pglsn_type ) 
   VALUES
      (
         row_id, pglsn_in 
      )
;
end
;
 $$ ;
create 
or replace procedure JsonProcedure( row_id bigint, json_in json, jsonb_in jsonb, jsonpath_in jsonpath ) language plpgsql as $$ 
begin
   INSERT INTO
      JsonTypes (row_id, json_type, jsonb_type, jsonpath_type) 
   VALUES
      (
         row_id, json_in, jsonb_in, jsonpath_in
      )
;
end
;
 $$ ;
create 
or replace procedure BitProcedure( row_id bigint, bitvarying_in bit varying(10), bit_in bit ) language plpgsql as $$ 
begin
   INSERT INTO
      BitTypes (row_id, varbitstring_type, bit_type) 
   VALUES
      (
         row_id, bitvarying_in, bit_in
      )
;
end
;
 $$ ;
create 
or replace procedure DatetimeProcedure( row_id bigint, date_in date, time_in time, timetz_in timetz, timestamp_in timestamp, timestamptz_in timestamptz, interval_in interval ) language plpgsql as $$ 
begin
   INSERT INTO
      DatetimeTypes( row_id, date_type, time_type, timetz_type, timestamp_type, timestamptz_type, interval_type ) 
   VALUES
      (
         row_id, date_in, time_in, timetz_in, timestamp_in, timestamptz_in, interval_in 
      )
;
end
;
 $$ ;
create 
or replace procedure RangeProcedure( row_id bigint, int4range_in int4range, int8range_in int8range, numrange_in numrange, tsrange_in tsrange, tstzrange_in tstzrange, daterange_in daterange ) language plpgsql as $$ 
begin
   INSERT INTO
      RangeTypes( row_id, int4range_type, int8range_type, numrange_type, tsrange_type, tstzrange_type, daterange_type ) 
   VALUES
      (
         row_id, int4range_in, int8range_in, numrange_in, tsrange_in, tstzrange_in, daterange_in 
      )
;
end
;
 $$ ;
create 
or replace procedure TextsearchProcedure( row_id bigint, tsvector_in tsvector, tsquery_in tsquery ) language plpgsql as $$ 
begin
   INSERT INTO
      TextsearchTypes( row_id, tsvector_type, tsquery_type ) 
   VALUES
      (
         row_id, tsvector_in, tsquery_in 
      )
;
end
;
 $$ ;
create 
or replace procedure ObjectidentifierProcedure( row_id bigint, oid_in oid, regclass_in regclass, regconfig_in regconfig, regdictionary_in regdictionary, regnamespace_in regnamespace, regoper_in regoper, regoperator_in regoperator, regproc_in regproc, regprocedure_in regprocedure, regrole_in regrole, regtype_in regtype ) language plpgsql as $$ 
begin
   INSERT INTO
      ObjectidentifierTypes( row_id, oid_type, regclass_type, regconfig_type, regdictionary_type, regnamespace_type, regoper_type, regoperator_type, regproc_type, regprocedure_type, regrole_type, regtype_type ) 
   VALUES
      (
         row_id, oid_in, regclass_in, regconfig_in, regdictionary_in, regnamespace_in, regoper_in, regoperator_in, regproc_in, regprocedure_in, regrole_in, regtype_in 
      )
;
end
;
 $$ ;
create 
or replace procedure BinaryProcedure( row_id bigint, bytea_in bytea, bytea_escape_in bytea ) language plpgsql as $$ 
begin
   INSERT INTO
      BinaryTypes( row_id, bytea_type, bytea_escape_type ) 
   VALUES
      (
         row_id, bytea_in, bytea_escape_in 
      )
;
end
;
 $$ ;
create 
or replace procedure XmlProcedure( row_id bigint, xml_in xml ) language plpgsql as $$ 
begin
   INSERT INTO
      XmlTypes( row_id, xml_type ) 
   VALUES
      (
         row_id, xml_in 
      )
;
end
;
 $$ ;
create 
or replace procedure MoneyProcedure( row_id bigint, money_in money ) language plpgsql as $$ 
begin
   INSERT INTO
      MoneyTypes( row_id, money_type ) 
   VALUES
      (
         row_id, money_in 
      )
;
end
;
 $$ ;
create 
or replace procedure ArrayProcedure( row_id_in bigint, bigintarray_in bigint[], numericarray_in numeric[], varchararray_in varchar(15)[], textarray_in text[], booleanarray_in boolean[], byteaarray_in bytea[] ) language plpgsql as $$ 
begin
   INSERT INTO
      ArrayTypes( row_id, bigintarray_type, numericarray_type, varchararray_type, textarray_type, booleanarray_type, byteaarray_type ) 
   VALUES
      (
         row_id_in, bigintarray_in, numericarray_in, varchararray_in, textarray_in, booleanarray_in, byteaarray_in 
      )
;
end
;
 $$ ;
create 
or replace procedure ArrayProcedure2( row_id_in bigint, smallintarray_in smallint array, intarray_in integer array, bigintarray_in bigint array, decimalarray_in decimal array, numericarray_in numeric array, realarray_in real array, doublearray_in double precision array, varchararray_in varchar(15) array, stringarray_in varchar(1000) array, booleanarray_in boolean array, datearray_in date array, timearray_in time array, timestamparray_in timestamp array, byteaarray_in bytea array) language plpgsql as $$ 
begin
   INSERT INTO ArrayTypes2 (row_id, smallint_array, int_array, bigint_array, decimal_array, numeric_array, real_array, double_array, varchar_array, string_array, boolean_array, date_array, time_array, timestamp_array, bytea_array) 
   VALUES
      (
         row_id_in, smallintarray_in, intarray_in, bigintarray_in, decimalarray_in, numericarray_in, realarray_in, doublearray_in, varchararray_in, stringarray_in, booleanarray_in, datearray_in, timearray_in, timestamparray_in, byteaarray_in 
      )
;
end
;
$$ ;

create 
or replace procedure ArrayProcedure3( row_id bigint, point_in point[], line_in line[], lseg_in lseg[], box_in box[], path_in path[], polygon_in polygon[], circle_in circle[], interval_in interval[], int4range_in int4range[], int8range_in int8range[], numrange_in numrange[], tstzrange_in tstzrange[], tsrange_in tsrange[], daterange_in daterange[]) language plpgsql as $$ 
begin
   INSERT INTO
      ArrayTypes3( row_id, point_array, line_array, lseg_array, box_array, path_array, polygon_array, circle_array, interval_array, int4range_array, int8range_array, numrange_array, tsrange_array, tstzrange_array, daterange_array) 
   VALUES
      (
         row_id, point_in, line_in, lseg_in, box_in, path_in, polygon_in, circle_in, interval_in, int4range_in, int8range_in, numrange_in, tsrange_in, tstzrange_in, daterange_in  
      )
;
end
;
 $$ ;

create 
or replace procedure ArrayProcedure4( row_id bigint, inet_in inet[], cidr_in cidr[], macaddr_in macaddr[], macaddr8_in macaddr8[], uuid_in uuid[], tsvector_in tsvector[], tsquery_in tsquery[], bitstring_in bit(3)[], varbitstring_in bit varying(100)[], bit_in bit[], xml_in xml[], oid_in oid[], regclass_in regclass[], regconfig_in regconfig[], regdictionary_in regdictionary[], regnamespace_in regnamespace[], regoper_in regoper[], regoperator_in regoperator[], regproc_in regproc[], regprocedure_in regprocedure[], regrole_in regrole[], regtype_in regtype[]) language plpgsql as $$ 
begin
   INSERT INTO
      ArrayTypes4( row_id, inet_array, cidr_array, macaddr_array, macaddr8_array, uuid_array, tsvector_array, tsquery_array, bitstring_array, varbitstring_array, bit_array, xml_array, oid_array, regclass_array, regconfig_array, regdictionary_array, regnamespace_array, regoper_array, regoperator_array, regproc_array, regprocedure_array, regrole_array, regtype_array) 
   VALUES
      (
         row_id, inet_in, cidr_in, macaddr_in, macaddr8_in, uuid_in, tsvector_in, tsquery_in, bitstring_in, varbitstring_in, bit_in, xml_in, oid_in, regclass_in, regconfig_in, regdictionary_in, regnamespace_in, regoper_in, regoperator_in, regproc_in, regprocedure_in, regrole_in, regtype_in
      )
;
end
;
 $$ ;

create 
or replace procedure ArrayProcedure5( row_id bigint, json_in json[], jsonb_in jsonb[], jsonpath_in jsonpath[], money_in money[], pglsn_in pg_lsn[]) language plpgsql as $$ 
begin
   INSERT INTO
      ArrayTypes5( row_id, json_array, jsonb_array, jsonpath_array, money_array, pglsn_array)
   VALUES
      (
         row_id, json_in, jsonb_in, jsonpath_in, money_in, pglsn_in
      )
;
end
;
 $$ ;

create 
or replace procedure CustomProcedure( row_id bigint, complex_in complex, inventory_in inventory_item ) language plpgsql as $$ 
begin
   INSERT INTO
      CustomTypes( row_id, complex_type, inventory_type ) 
   VALUES
      (
         row_id, complex_in, inventory_in 
      )
;
end
;
 $$ ;
create 
or replace procedure EnumProcedure( row_id bigint, enum_in value ) language plpgsql as $$ 
begin
   INSERT INTO
      EnumTypes( row_id, value_type ) 
   VALUES
      (
         row_id, enum_in 
      )
;
end
;
 $$ ;
create 
or replace procedure NumericOutProcedure( inout row_id_inout bigint, inout smallint_inout smallint, inout int_inout integer, inout bigint_inout bigint, inout decimal_inout decimal, inout numeric_inout numeric, inout real_inout real, inout double_precision_inout double precision ) language plpgsql as $$ 
begin
   SELECT
      row_id,
      smallint_type,
      int_type,
      bigint_type,
      decimal_type,
      numeric_type,
      real_type,
      double_type 
   from
      NumericTypes2 into row_id_inout,
      smallint_inout,
      int_inout,
      bigint_inout,
      decimal_inout,
      numeric_inout,
      real_inout,
      double_precision_inout 
   where
      NumericTypes2.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure CharacterOutProcedure( inout row_id_inout bigint, inout char_inout char(15), inout varchar_inout varchar(15), inout text_inout text, inout name_inout name ) language plpgsql as $$ 
begin
   Select
      row_id,
      char_type,
      varchar_type,
      text_type,
      name_type into row_id_inout,
      char_inout,
      varchar_inout,
      text_inout,
      name_inout 
   from
      CharacterTypes 
   where
      CharacterTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure BooleanOutProcedure( inout row_id_inout bigint, inout boolean_inout boolean ) language plpgsql as $$ 
begin
   SELECT
      row_id,
      boolean_type 
   from
      BooleanTypes into row_id_inout,
      boolean_inout 
   where
      BooleanTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure NetworkOutProcedure( inout row_id_inout bigint, inout inet_inout inet, inout cidr_inout cidr, inout macaddr_inout macaddr, inout macaddr8_inout macaddr8 ) language plpgsql as $$ 
begin
   Select
      row_id,
      inet_type,
      cidr_type,
      macaddr_type,
      macaddr8_type into row_id_inout,
      inet_inout,
      cidr_inout,
      macaddr_inout,
      macaddr8_inout 
   from
      NetworkTypes 
   where
      NetworkTypes.row_id = 1;
end
;
 $$ ;
create 
or replace procedure GeometricOutProcedure( inout row_id_inout bigint, inout point_inout point, inout line_inout line, inout lseg_inout lseg, inout box_inout box, inout path_inout path, inout polygon_inout polygon, inout circle_inout circle ) language plpgsql as $$ 
begin
   SELECT
      row_id,
      point_type,
      line_type,
      lseg_type,
      box_type,
      path_type,
      polygon_type,
      circle_type into row_id_inout,
      point_inout,
      line_inout,
      lseg_inout,
      box_inout,
      path_inout,
      polygon_inout,
      circle_inout 
   from
      GeometricTypes 
   where
      GeometricTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure UuidOutProcedure( inout row_id_inout bigint, inout uuid_inout uuid ) language plpgsql as $$ 
begin
   SELECT
      row_id,
      uuid_type 
   from
      UuidTypes into row_id_inout,
      uuid_inout 
   where
      UuidTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure PglsnOutProcedure( inout row_id_inout bigint, inout pglsn_inout pg_lsn ) language plpgsql as $$ 
begin
   SELECT
      row_id,
      pglsn_type 
   from
      PglsnTypes into row_id_inout,
      pglsn_inout 
   where
      PglsnTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure JsonOutProcedure( inout row_id_inout bigint, inout json_inout json, inout jsonb_inout jsonb, inout jsonpath_inout jsonpath ) language plpgsql as $$ 
begin
   SELECT
      row_id,
      json_type,
      jsonb_type,
      jsonpath_type into row_id_inout,
      json_inout,
      jsonb_inout,
      jsonpath_inout 
   from
      JsonTypes 
   where
      JsonTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure BitOutProcedure( inout row_id_inout bigint, inout bitvarying_inout bit varying(10), inout bit_inout bit(1) ) language plpgsql as $$ 
begin
   SELECT
      row_id,
      varbitstring_type,
      bit_type into row_id_inout,
      bitvarying_inout,
      bit_inout 
   from
      BitTypes 
   where
      BitTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure DatetimeOutProcedure( inout row_id_inout bigint, inout date_inout date, inout time_inout time, inout timetz_inout timetz, inout timestamp_inout timestamp, inout timestamptz_inout timestamptz, inout interval_inout interval ) language plpgsql as $$ 
begin
   SELECT
      row_id,
      date_type,
      time_type,
      timetz_type,
      timestamp_type,
      timestamptz_type,
      interval_type 
   from
      DatetimeTypes into row_id_inout,
      date_inout,
      time_inout,
      timetz_inout,
      timestamp_inout,
      timestamptz_inout,
      interval_inout 
   where
      DatetimeTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure RangeOutProcedure( inout row_id_inout bigint, inout int4range_inout int4range, inout int8range_inout int8range, inout numrange_inout numrange, inout tsrange_inout tsrange, inout tstzrange_inout tstzrange, inout daterange_inout daterange ) language plpgsql as $$ 
begin
   SELECT
      row_id,
      int4range_type,
      int8range_type,
      numrange_type,
      tsrange_type,
      tstzrange_type,
      daterange_type 
   from
      RangeTypes into row_id_inout,
      int4range_inout,
      int8range_inout,
      numrange_inout,
      tsrange_inout,
      tstzrange_inout,
      daterange_inout 
   where
      RangeTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure TextsearchOutProcedure( inout row_id_inout bigint, inout tsvector_inout tsvector, inout tsquery_inout tsquery ) language plpgsql as $$ 
begin
   SELECT
      row_id,
      tsvector_type,
      tsquery_type into row_id_inout,
      tsvector_inout,
      tsquery_inout 
   from
      TextsearchTypes 
   where
      TextsearchTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure ObjectidentifierOutProcedure( inout row_id_inout bigint, inout oid_inout oid, inout regclass_inout regclass, inout regconfig_inout regconfig, inout regdictionary_inout regdictionary, inout regnamespace_inout regnamespace, inout regoper_inout regoper, inout regoperator_inout regoperator, inout regproc_inout regproc, inout regprocedure_inout regprocedure, inout regrole_inout regrole, inout regtype_inout regtype ) language plpgsql as $$ 
begin
   SELECT
      row_id,
      oid_type,
      regclass_type,
      regconfig_type,
      regdictionary_type,
      regnamespace_type,
      regoper_type,
      regoperator_type,
      regproc_type,
      regprocedure_type,
      regrole_type,
      regtype_type 
   from
      ObjectidentifierTypes into row_id_inout,
      oid_inout,
      regclass_inout,
      regconfig_inout,
      regdictionary_inout,
      regnamespace_inout,
      regoper_inout,
      regoperator_inout,
      regproc_inout,
      regprocedure_inout,
      regrole_inout,
      regtype_inout 
   where
      ObjectidentifierTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure BinaryOutProcedure( inout row_id_inout bigint, inout bytea_inout bytea, inout bytea_escape_inout bytea ) language plpgsql as $$ 
begin
   SELECT
      row_id,
      bytea_type,
      bytea_escape_type into row_id_inout,
      bytea_inout,
      bytea_escape_inout 
   from
      BinaryTypes 
   where
      BinaryTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure XmlOutProcedure( inout row_id_inout bigint, inout xml_inout xml ) language plpgsql as $$ 
begin
   SELECT
      row_id,
      xml_type 
   from
      XmlTypes into row_id_inout,
      xml_inout 
   where
      XmlTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure MoneyOutProcedure( inout row_id_inout bigint, inout money_inout money ) language plpgsql as $$ 
begin
   SELECT
      row_id,
      money_type 
   from
      MoneyTypes into row_id_inout,
      money_inout 
   where
      MoneyTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure ArrayOutProcedure( inout row_id_inout bigint, inout smallintarray_inout smallint[], inout intarray_inout int[], inout bigintarray_inout bigint[], inout decimalarray_inout decimal[], inout numericarray_inout numeric[], inout realarray_inout real[], inout doublearray_inout double precision[], inout chararray_inout char(15)[], inout varchararray_inout varchar(15)[], inout textarray_inout text[], inout booleanarray_inout boolean[], inout byteaarray_inout bytea[] ) language plpgsql as $$ 
begin
   SELECT
      row_id,
      smallintarray_type,
      intarray_type,
      bigintarray_type,
      decimalarray_type,
      numericarray_type,
      realarray_type,
      doublearray_type,
      chararray_type,
      varchararray_type,
      textarray_type,
      booleanarray_type,
      byteaarray_type 
   from
      ArrayTypes into row_id_inout,
      byteaarray_inout,
      byteaarray_inout,
      byteaarray_inout,
      byteaarray_inout,
      byteaarray_inout,
      byteaarray_inout,
      byteaarray_inout,
      byteaarray_inout,
      byteaarray_inout,
      byteaarray_inout,
      byteaarray_inout,
      byteaarray_inout 
   where
      ArrayTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure ArrayOutProcedure( inout row_id_inout bigint, inout bigintarray_inout bigint[], inout numericarray_inout numeric[], inout varchararray_inout varchar[], inout textarray_inout text[], inout booleanarray_inout boolean[] ) language plpgsql as $$ 
begin
   SELECT
      row_id,
      bigintarray_type,
      numericarray_type,
      varchararray_type,
      textarray_type,
      booleanarray_type 
   from
      ArrayTypes into row_id_inout,
      bigintarray_inout,
      numericarray_inout,
      varchararray_inout,
      textarray_inout,
      booleanarray_inout 
   where
      ArrayTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure EnumOutProcedure( inout row_id_inout bigint, inout enum_inout value ) language plpgsql as $$ 
begin
   SELECT
      row_id,
      value_type 
   from
      EnumTypes into row_id_inout,
      enum_inout 
   where
      EnumTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure NumericInoutProcedure( inout row_id_inout bigint, inout smallint_inout smallint, inout int_inout int, inout bigint_inout bigint, inout decimal_inout decimal, inout numeric_inout numeric, inout real_inout real, inout double_precision_inout double precision ) language plpgsql as $$ 
begin
   INSERT INTO
      NumericTypes2( row_id, smallint_type, int_type, bigint_type, decimal_type, numeric_type, double_type, real_type ) 
   VALUES
      (
         row_id_inout,
         smallint_inout,
         int_inout,
         bigint_inout,
         decimal_inout,
         numeric_inout,
         double_precision_inout,
         real_inout 
      )
;
SELECT
   row_id,
   smallint_type,
   int_type,
   bigint_type,
   decimal_type,
   numeric_type,
   double_type,
   real_type 
from
   NumericTypes2 into row_id_inout,
   smallint_inout,
   int_inout,
   bigint_inout,
   decimal_inout,
   numeric_inout,
   double_precision_inout,
   real_inout 
where
   NumericTypes2.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure CharacterInoutProcedure( inout row_id_inout bigint, inout char_inout char(15), inout varchar_inout varchar(15), inout text_inout text, inout name_inout name ) language plpgsql as $$ 
begin
   INSERT INTO
      CharacterTypes (row_id, char_type, varchar_type, text_type, name_type) 
   VALUES
      (
         row_id_inout,
         char_inout,
         varchar_inout,
         text_inout,
         name_inout
      )
;
Select
   row_id,
   char_type,
   varchar_type,
   text_type,
   name_type into row_id_inout,
   char_inout,
   varchar_inout,
   text_inout,
   name_inout 
from
   CharacterTypes 
where
   CharacterTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure BooleanInoutProcedure( inout row_id_inout bigint, inout boolean_inout boolean ) language plpgsql as $$ 
begin
   INSERT INTO
      BooleanTypes( row_id, boolean_type ) 
   VALUES
      (
         row_id_inout,
         boolean_inout 
      )
;
SELECT
   row_id,
   boolean_type 
from
   BooleanTypes into row_id_inout,
   boolean_inout 
where
   BooleanTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure NetworkInoutProcedure( inout row_id_inout bigint, inout inet_inout inet, inout cidr_inout cidr, inout macaddr_inout macaddr, inout macaddr8_inout macaddr8 ) language plpgsql as $$ 
begin
   INSERT INTO
      NetworkTypes (row_id, inet_type, cidr_type, macaddr_type, macaddr8_type) 
   VALUES
      (
         row_id_inout,
         inet_inout,
         cidr_inout,
         macaddr_inout,
         macaddr8_inout
      )
;
Select
   row_id,
   inet_type,
   cidr_type,
   macaddr_type,
   macaddr8_type into row_id_inout,
   inet_inout,
   cidr_inout,
   macaddr_inout,
   macaddr8_inout 
from
   NetworkTypes 
where
   NetworkTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure GeometricInoutProcedure( inout row_id_inout bigint, inout point_inout point, inout line_inout line, inout lseg_inout lseg, inout box_inout box, inout path_inout path, inout polygon_inout polygon, inout circle_inout circle ) language plpgsql as $$ 
begin
   INSERT INTO
      GeometricTypes( row_id, point_type, line_type, lseg_type, box_type, path_type, polygon_type, circle_type ) 
   VALUES
      (
         row_id_inout,
         point_inout,
         line_inout,
         lseg_inout,
         box_inout,
         path_inout,
         polygon_inout,
         circle_inout 
      )
;
SELECT
   row_id,
   point_type,
   line_type,
   lseg_type,
   box_type,
   path_type,
   polygon_type,
   circle_type into row_id_inout,
   point_inout,
   line_inout,
   lseg_inout,
   box_inout,
   path_inout,
   polygon_inout,
   circle_inout 
from
   GeometricTypes 
where
   GeometricTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure UuidInoutProcedure( inout row_id_inout bigint, inout uuid_inout uuid ) language plpgsql as $$ 
begin
   INSERT INTO
      UuidTypes( row_id, uuid_type ) 
   VALUES
      (
         row_id_inout,
         uuid_inout 
      )
;
SELECT
   row_id,
   uuid_type 
from
   UuidTypes into row_id_inout,
   uuid_inout 
where
   UuidTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure PglsnInoutProcedure( inout row_id_inout bigint, inout pglsn_inout pg_lsn ) language plpgsql as $$ 
begin
   INSERT INTO
      PglsnTypes( row_id, pglsn_type ) 
   VALUES
      (
         row_id_inout,
         pglsn_inout 
      )
;
SELECT
   row_id,
   pglsn_type 
from
   PglsnTypes into row_id_inout,
   pglsn_inout 
where
   PglsnTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure JsonInoutProcedure( inout row_id_inout bigint, inout json_inout json, inout jsonb_inout jsonb, inout jsonpath_inout jsonpath ) language plpgsql as $$ 
begin
   INSERT INTO
      JsonTypes (row_id, json_type, jsonb_type, jsonpath_type) 
   VALUES
      (
         row_id_inout,
         json_inout,
         jsonb_inout,
         jsonpath_inout
      )
;
SELECT
   row_id,
   json_type,
   jsonb_type,
   jsonpath_type into row_id_inout,
   json_inout,
   jsonb_inout,
   jsonpath_inout 
from
   JsonTypes 
where
   JsonTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure BitInoutProcedure( inout row_id_inout bigint, inout bitvarying_inout bit varying(10), inout bit_inout bit(1) ) language plpgsql as $$ 
begin
   INSERT INTO
      BitTypes (row_id, varbitstring_type, bit_type) 
   VALUES
      (
         row_id_inout,
         bitvarying_inout,
         bit_inout
      )
;
SELECT
   row_id,
   varbitstring_type,
   bit_type into row_id_inout,
   bitvarying_inout,
   bit_inout 
from
   BitTypes 
where
   BitTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure DatetimeInoutProcedure( inout row_id_inout bigint, inout date_inout date, inout time_inout time, inout timetz_inout timetz, inout timestamp_inout timestamp, inout timestamptz_inout timestamptz, inout interval_inout interval ) language plpgsql as $$ 
begin
   INSERT INTO
      DatetimeTypes( row_id, date_type, time_type, timetz_type, timestamp_type, timestamptz_type, interval_type ) 
   VALUES
      (
         row_id_inout,
         date_inout,
         time_inout,
         timetz_inout,
         timestamp_inout,
         timestamptz_inout,
         interval_inout 
      )
;
SELECT
   row_id,
   date_type,
   time_type,
   timetz_type,
   timestamp_type,
   timestamptz_type,
   interval_type 
from
   DatetimeTypes into row_id_inout,
   date_inout,
   time_inout,
   timetz_inout,
   timestamp_inout,
   timestamptz_inout,
   interval_inout 
where
   DatetimeTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure RangeInoutProcedure( inout row_id_inout bigint, inout int4range_inout int4range, inout int8range_inout int8range, inout numrange_inout numrange, inout tsrange_inout tsrange, inout tstzrange_inout tstzrange, inout daterange_inout daterange ) language plpgsql as $$ 
begin
   INSERT INTO
      RangeTypes( row_id, int4range_type, int8range_type, numrange_type, tsrange_type, tstzrange_type, daterange_type ) 
   VALUES
      (
         row_id_inout,
         int4range_inout,
         int8range_inout,
         numrange_inout,
         tsrange_inout,
         tstzrange_inout,
         daterange_inout 
      )
;
SELECT
   row_id,
   int4range_type,
   int8range_type,
   numrange_type,
   tsrange_type,
   tstzrange_type,
   daterange_type 
from
   RangeTypes into row_id_inout,
   int4range_inout,
   int8range_inout,
   numrange_inout,
   tsrange_inout,
   tstzrange_inout,
   daterange_inout 
where
   RangeTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure TextsearchInoutProcedure( inout row_id_inout bigint, inout tsvector_inout tsvector, inout tsquery_inout tsquery ) language plpgsql as $$ 
begin
   INSERT INTO
      TextsearchTypes( row_id, tsvector_type, tsquery_type ) 
   VALUES
      (
         row_id_inout,
         tsvector_inout,
         tsquery_inout 
      )
;
SELECT
   row_id,
   tsvector_type,
   tsquery_type into row_id_inout,
   tsvector_inout,
   tsquery_inout 
from
   TextsearchTypes 
where
   TextsearchTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure ObjectidentifierInoutProcedure( inout row_id_inout bigint, inout oid_inout oid, inout regclass_inout regclass, inout regconfig_inout regconfig, inout regdictionary_inout regdictionary, inout regnamespace_inout regnamespace, inout regoper_inout regoper, inout regoperator_inout regoperator, inout regproc_inout regproc, inout regprocedure_inout regprocedure, inout regrole_inout regrole, inout regtype_inout regtype ) language plpgsql as $$ 
begin
   INSERT INTO
      ObjectidentifierTypes( row_id, oid_type, regclass_type, regconfig_type, regdictionary_type, regnamespace_type, regoper_type, regoperator_type, regproc_type, regprocedure_type, regrole_type, regtype_type ) 
   VALUES
      (
         row_id_inout,
         oid_inout,
         regclass_inout,
         regconfig_inout,
         regdictionary_inout,
         regnamespace_inout,
         regoper_inout,
         regoperator_inout,
         regproc_inout,
         regprocedure_inout,
         regrole_inout,
         regtype_inout 
      )
;
SELECT
   row_id,
   oid_type,
   regclass_type,
   regconfig_type,
   regdictionary_type,
   regnamespace_type,
   regoper_type,
   regoperator_type,
   regproc_type,
   regprocedure_type,
   regrole_type,
   regtype_type 
from
   ObjectidentifierTypes into row_id_inout,
   oid_inout,
   regclass_inout,
   regconfig_inout,
   regdictionary_inout,
   regnamespace_inout,
   regoper_inout,
   regoperator_inout,
   regproc_inout,
   regprocedure_inout,
   regrole_inout,
   regtype_inout 
where
   ObjectidentifierTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace function singleSelectProcedure( row_id_in bigint ) returns table(char_type char(15), varchar_type varchar(30), text_type text, name_type name) language plpgsql as $$ 
begin
   return QUERY 
   SELECT
      CharacterTypes.char_type,
      CharacterTypes.varchar_type,
      CharacterTypes.text_type,
      CharacterTypes.name_type 
   from
      CharacterTypes 
   where
      CharacterTypes.row_id = row_id_in;
end
;
 $$ ;
create 
or replace function multipleSelectProcedure() RETURNS table(char_type char(15), varchar_type varchar(30), text_type text, name_type name) as $$ 
begin
   return QUERY 
   SELECT
      CharacterTypes.char_type,
      CharacterTypes.varchar_type,
      CharacterTypes.text_type,
      CharacterTypes.name_type 
   from
      CharacterTypes;
end
;
$$ language plpgsql ;
create 
or replace procedure BinaryInoutProcedure( inout row_id_inout bigint, inout bytea_inout bytea, inout bytea_escape_inout bytea ) language plpgsql as $$ 
begin
   INSERT INTO
      BinaryTypes( row_id, bytea_type, bytea_escape_type ) 
   VALUES
      (
         row_id_inout,
         bytea_inout,
         bytea_escape_inout 
      )
;
SELECT
   row_id,
   bytea_type,
   bytea_escape_type into row_id_inout,
   bytea_inout,
   bytea_escape_inout 
from
   BinaryTypes 
where
   BinaryTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure XmlInoutProcedure( inout row_id_inout bigint, inout xml_inout xml ) language plpgsql as $$ 
begin
   INSERT INTO
      XmlTypes( row_id, xml_type ) 
   VALUES
      (
         row_id_inout,
         xml_inout 
      )
;
SELECT
   row_id,
   xml_type 
from
   XmlTypes into row_id_inout,
   xml_inout 
where
   XmlTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure MoneyInoutProcedure( inout row_id_inout bigint, inout money_inout money ) language plpgsql as $$ 
begin
   INSERT INTO
      MoneyTypes( row_id, money_type ) 
   VALUES
      (
         row_id_inout,
         money_inout 
      )
;
SELECT
   row_id,
   money_type 
from
   MoneyTypes into row_id_inout,
   money_inout 
where
   MoneyTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure ArrayInoutProcedure( inout row_id_inout bigint, inout smallintarray_inout smallint[], inout intarray_inout int[], inout bigintarray_inout bigint[], inout decimalarray_inout decimal[], inout numericarray_inout numeric[], inout realarray_inout real[], inout doublearray_inout double precision[], inout chararray_inout char(15)[], inout varchararray_inout varchar(15)[], inout textarray_inout text[], inout booleanarray_inout boolean[], inout byteaarray_inout bytea[] ) language plpgsql as $$ 
begin
   INSERT INTO
      ArrayTypes( row_id, smallintarray_type, intarray_type, bigintarray_type, decimalarray_type, numericarray_type, realarray_type, doublearray_type, chararray_type, varchararray_type, textarray_type, booleanarray_type, byteaarray_type ) 
   VALUES
      (
         row_id_inout,
         byteaarray_inout,
         byteaarray_inout,
         byteaarray_inout,
         byteaarray_inout,
         byteaarray_inout,
         byteaarray_inout,
         byteaarray_inout,
         byteaarray_inout,
         byteaarray_inout,
         byteaarray_inout,
         byteaarray_inout,
         byteaarray_inout 
      )
;
SELECT
   row_id,
   smallintarray_type,
   intarray_type,
   bigintarray_type,
   decimalarray_type,
   numericarray_type,
   realarray_type,
   doublearray_type,
   chararray_type,
   varchararray_type,
   textarray_type,
   booleanarray_type,
   byteaarray_type 
from
   ArrayTypes into row_id_inout,
   byteaarray_inout,
   byteaarray_inout,
   byteaarray_inout,
   byteaarray_inout,
   byteaarray_inout,
   byteaarray_inout,
   byteaarray_inout,
   byteaarray_inout,
   byteaarray_inout,
   byteaarray_inout,
   byteaarray_inout,
   byteaarray_inout 
where
   ArrayTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace procedure EnumInoutProcedure( inout row_id_inout bigint, inout value_inout value ) language plpgsql as $$ 
begin
   INSERT INTO
      EnumTypes( row_id, value_type ) 
   VALUES
      (
         row_id_inout,
         value_inout 
      )
;
SELECT
   row_id,
   value_type 
from
   EnumTypes into row_id_inout,
   value_inout 
where
   EnumTypes.row_id = row_id_inout;
end
;
 $$ ;
create 
or replace function multipleQuerySelectProcedure() Returns setof CharacterTypes as $$ 
DECLARE rec1 CharacterTypes;
rec2 CharacterTypes;
begin
   SELECT
      CharacterTypes.row_id,
      CharacterTypes.char_type,
      CharacterTypes.varchar_type,
      CharacterTypes.text_type,
      CharacterTypes.name_type 
   from
      CharacterTypes into rec1 
   where
      CharacterTypes.row_id = 1;
return next rec1;
SELECT
   * 
from
   CharacterTypes into rec2 
where
   CharacterTypes.row_id = 2;
return next rec2;
end
;
$$ language plpgsql;
create 
or replace function singleSelectProcedure( row_id_in bigint ) returns table(char_type char(15), varchar_type varchar(30), text_type text, name_type name) language plpgsql as $$ 
begin
   return QUERY 
   SELECT
      CharacterTypes.char_type,
      CharacterTypes.varchar_type,
      CharacterTypes.text_type,
      CharacterTypes.name_type 
   from
      CharacterTypes 
   where
      CharacterTypes.row_id = row_id_in;
end
;
 $$ ;
create 
or replace function multipleSelectProcedure() RETURNS table(char_type char(15), varchar_type varchar(30), text_type text, name_type name) as $$ 
begin
   return QUERY 
   SELECT
      CharacterTypes.char_type,
      CharacterTypes.varchar_type,
      CharacterTypes.text_type,
      CharacterTypes.name_type 
   from
      CharacterTypes;
end
;
$$ language plpgsql;
create 
or replace function multipleQuerySelectProcedure() Returns setof CharacterTypes as $$
DECLARE rec1 CharacterTypes;
rec2 CharacterTypes;
begin
   SELECT
      CharacterTypes.row_id,
      CharacterTypes.char_type,
      CharacterTypes.varchar_type,
      CharacterTypes.text_type,
      CharacterTypes.name_type 
   from
      CharacterTypes into rec1 
   where
      CharacterTypes.row_id = 1;
return next rec1;
SELECT
   * 
from
   CharacterTypes into rec2 
where
   CharacterTypes.row_id = 2;
return next rec2;
end
;
$$ language plpgsql;
create
OR replace procedure TimestampSelectProcedure(inout id bigint, inout datetimetzOut timestamptz) language plpgsql as $$
begin
   SELECT
      row_id,
      timestamptz_type
   from
      DatetimeTypes
   into
      id,
      datetimetzOut
   where
      DatetimeTypes.row_id = id;
end
;
 $$ ;

CREATE TABLE IF NOT EXISTS ArrayTypesInOut (
  row_id        INTEGER NOT NULL,
  inet_array INET ARRAY,
  cidr_array CIDR ARRAY,
  macaddr_array MACADDR ARRAY,
  macaddr8_array MACADDR8 ARRAY,
  uuid_array UUID ARRAY,
  tsvector_array TSVECTOR ARRAY,
  tsquery_array TSQUERY ARRAY,
  bitstring_array BIT(1) ARRAY,
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
  point_array POINT ARRAY,
  line_array LINE ARRAY,
  lseg_array LSEG ARRAY,
  path_array PATH ARRAY,
  box_array BOX ARRAY,
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

INSERT INTO ArrayTypesInOut (
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
   regtype_array,
   point_array,
   line_array,
   lseg_array,
   path_array,
   circle_array,
   polygon_array,
   box_array,
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
    '{"192.168.0.1/24","192.168.0.1/24"}',
    '{"::ffff:1.2.3.0/120","::ffff:1.2.3.0/120"}',
    '{"08:00:2b:01:02:03","08:00:2b:01:02:03"}',
    '{"08-00-2b-01-02-03-04-05","08-00-2b-01-02-03-04-05"}',
    '{"a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11","a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11"}',
    '{"a fat cat sat on a mat and ate a fat rat","a fat cat sat on a mat and ate a fat rat"}',
    '{"fat & rat","fat & rat"}',
    '{"1","0"}',
    '{"1001","1110"}',
    '{"1","0"}',
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
    '{"integer","integer"}',
    '{"(1,2)", "(3,4)"}',
    '{"{1, 2, 3}", "{1, 2, 3}"}',
    '{"((1, 2), (3, 4))", "((1, 2), (3, 4))"}',
    '{"(1,2)", "(3,4)"}',
    '{"((0,0),2)", "((0,0),2)"}',
    '{"((1, 2), (3, 4))", "((1, 2), (3, 4))"}',
    ARRAY['((1,2),(2,2))','((1,2),(2,2))'] :: BOX ARRAY,
    '{"P1Y2M3DT4H5M6S","P1Y2M3DT4H5M6S"}',
    '{"(1,3]"}',
    '{"(10000,30000)"}',
    '{"(1.11,3.33]"}',
    '{"(2010-01-01 14:30, 2010-01-01 15:30]"}',
    '{"(2010-01-01 14:30+02:30, 2010-01-01 15:30+01:30]"}',
    '{"(2010-01-01, 2010-01-03]"}'
    );

create OR replace procedure InOutArrayProcedure(_row_id bigint, inout _inet_array inet[], inout _cidr_array cidr[],
inout _macaddr_array macaddr[], inout _macaddr8_array macaddr8[], inout _uuid_array uuid[], inout _tsvector_array tsvector[],
inout _tsquery_array tsquery[], inout _bitstring_array bit(3)[], inout _varbitstring_array bit varying(100)[],
inout _bit_array bit[], inout _xml_array xml[], inout _oid_array oid[],
inout _regclass_array regclass[], inout _regconfig_array regconfig[], inout _regdictionary_array regdictionary[],
inout _regnamespace_array regnamespace[], inout _regoper_array regoper[], inout _regoperator_array regoperator[],
inout _regproc_array regproc[], inout _regprocedure_array regprocedure[], inout _regrole_array regrole[],
inout _regtype_array regtype[], inout _point_array point[], inout _line_array line[], inout _lseg_array lseg[],
inout _box_array box[], inout _path_array path[], inout _polygon_array polygon[], inout _circle_array circle[],
inout _interval_array interval[], inout _int4range_array int4range[], inout _int8range_array int8range[],
inout _numrange_array numrange[], inout _tstzrange_array tstzrange[], inout _tsrange_array tsrange[],
inout _daterange_array daterange[]) language plpgsql as $$
begin
SELECT
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
   regtype_array,
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
   int8range_array,
   numrange_array,
   tstzrange_array,
   tsrange_array,
   daterange_array
from
   ArrayTypesInOut
into
    _inet_array,
    _cidr_array,
    _macaddr_array,
    _macaddr8_array,
    _uuid_array,
    _tsvector_array,
    _tsquery_array,
    _bitstring_array,
    _varbitstring_array,
    _bit_array,
    _xml_array,
    _oid_array,
    _regclass_array,
    _regconfig_array,
    _regdictionary_array,
    _regnamespace_array,
    _regoper_array,
    _regoperator_array,
    _regproc_array,
    _regprocedure_array,
    _regrole_array,
    _regtype_array,
    _point_array,
    _line_array,
    _lseg_array,
    _box_array,
    _path_array,
    _polygon_array,
    _circle_array,
    _interval_array,
    _int4range_array,
    _int8range_array,
    _int8range_array,
    _numrange_array,
    _tstzrange_array,
    _tsrange_array,
    _daterange_array
where
   ArrayTypesInOut.row_id = _row_id;
end
;
 $$ ;
