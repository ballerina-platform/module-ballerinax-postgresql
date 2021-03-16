        DROP TABLE IF EXISTS NumericTypes;
        CREATE TABLE IF NOT EXISTS NumericTypes(
            row_id SERIAL,
            smallint_type smallint,
            int_type integer,
            bigint_type bigint,
            decimal_type decimal,
            numeric_type numeric,
            real_type real,
            double_type double precision,
            smallserial_type smallserial,
            serial_type serial,
            bigserial_type bigserial,
            PRIMARY KEY(row_id)
        );

            INSERT INTO NumericTypes(
                smallint_type,
                int_type,
                bigint_type,
                decimal_type,
                numeric_type,
                real_type,
                double_type,
                smallserial_type,
                serial_type,
                bigserial_type
                ) 
            VALUES (
                1,
                123,
                123456,
                123.456,
                123.456,
                234.567,
                234.567,
                1,
                123,
                123456
                );

        DROP TABLE IF EXISTS NumericTypes2;
        CREATE TABLE IF NOT EXISTS NumericTypes2(
            row_id SERIAL,
            smallint_type smallint,
            int_type integer,
            bigint_type bigint,
            decimal_type decimal,
            numeric_type numeric,
            real_type real,
            double_type double precision,
            PRIMARY KEY(row_id)
        );

            INSERT INTO NumericTypes2(
                smallint_type,
                int_type,
                bigint_type,
                decimal_type,
                numeric_type,
                real_type,
                double_type
                ) 
            VALUES (
                1,
                123,
                123456,
                123.456,
                123.456,
                234.567,
                234.567
                );
            
            INSERT INTO NumericTypes2(
            smallint_type,
            int_type,
            bigint_type,
            decimal_type,
            numeric_type,
            real_type,
            double_type
            ) 
            VALUES (
                null,
                null,
                null,
                null,
                null,
                null,
                null
            );

        DROP TABLE IF EXISTS CharacterTypes;
        CREATE TABLE IF NOT EXISTS CharacterTypes(
            row_id SERIAL,
            char_type char(15),
            varchar_type varchar(20),
            text_type text,
            name_type name,
            PRIMARY KEY(row_id)
        );

            INSERT INTO CharacterTypes(
                char_type,
                varchar_type,
                text_type,
                name_type
                ) 
            VALUES (
                'This is a char1',
                'This is a varchar1',
                'This is a text1',
                'This is a name1'
                );
    
            INSERT INTO CharacterTypes(
                char_type,
                varchar_type,
                text_type,
                name_type
                ) 
            VALUES (
                'This is a char2',
                'This is a varchar2',
                'This is a text2',
                'This is a name2'
                );
            INSERT INTO CharacterTypes(
                char_type,
                varchar_type,
                text_type,
                name_type
                ) 
            VALUES (
                null,
                null,
                null,
                null
                );


        DROP TABLE IF EXISTS BooleanTypes;
        CREATE TABLE IF NOT EXISTS BooleanTypes(
            row_id SERIAL,
            boolean_type boolean,
            PRIMARY KEY(row_id)
        );

            INSERT INTO BooleanTypes(
                boolean_type
                ) 
            VALUES (
                true
                );
            INSERT INTO BooleanTypes(
                boolean_type
                ) 
            VALUES (
                null
                );

        DROP TABLE IF EXISTS NetworkTypes;
        CREATE TABLE IF NOT EXISTS NetworkTypes(
            row_id SERIAL,
            inet_type inet,
            cidr_type cidr,
            macaddr_type macaddr,
            macaddr8_type macaddr8,
            PRIMARY KEY(row_id)
        );

            INSERT INTO NetworkTypes(
                inet_type,
                cidr_type,
                macaddr_type,
                macaddr8_type
                ) 
            VALUES (
                '192.168.0.1/24',
                '::ffff:1.2.3.0/120',
                '08:00:2b:01:02:03',
                '08-00-2b-01-02-03-04-05'
                );
            INSERT INTO NetworkTypes(
                inet_type,
                cidr_type,
                macaddr_type,
                macaddr8_type
                ) 
            VALUES (
                null,
                null,
                null,
                null
                );

        DROP TABLE IF EXISTS GeometricTypes;
        CREATE TABLE IF NOT EXISTS GeometricTypes(
            row_id SERIAL,
            point_type POINT,
            line_type LINE,
            lseg_type LSEG,
            path_type PATH,
            circle_type CIRCLE,
            box_type BOX,
            polygon_type POLYGON,
            PRIMARY KEY(row_id)
        );

            INSERT INTO GeometricTypes(
                point_type,
                line_type,
                lseg_type,
                box_type,
                path_type,
                polygon_type,
                circle_type
                ) 
            VALUES (
                '(1,2)',
                '{1,2,3}',
                '((1,1),(2,2))',
                '((1,1),(2,2))',
                '[(1,1),(2,2)]',
                '((1,1),(2,2))',
                '<1,1,1>'
                );
            
            INSERT INTO GeometricTypes(
                point_type,
                line_type,
                lseg_type,
                box_type,
                path_type,
                polygon_type,
                circle_type
                ) 
            VALUES (
                null,
                null,
                null,
                null,
                null,
                null,
                null
                );

        DROP TABLE IF EXISTS UuidTypes;
        CREATE TABLE IF NOT EXISTS UuidTypes(
            row_id SERIAL,
            uuid_type UUID,
            PRIMARY KEY(row_id)
        );

            INSERT INTO UuidTypes(
                uuid_type
                ) 
            VALUES (
                'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'
                );

            INSERT INTO UuidTypes(
                uuid_type
                ) 
            VALUES (
                null
                );

        DROP TABLE IF EXISTS TextSearchTypes;
        CREATE TABLE IF NOT EXISTS TextSearchTypes(
            row_id SERIAL,
            tsvector_type TSVECTOR,
            tsquery_type TSQUERY,
            PRIMARY KEY(row_id)
        );

            INSERT INTO TextSearchTypes(
                tsvector_type,
                tsquery_type
                ) 
            VALUES (
                'a fat cat sat on a mat and ate a fat rat',
                'fat & rat'
                );

            INSERT INTO TextSearchTypes(
                tsvector_type,
                tsquery_type
                ) 
            VALUES (
                null,
                null
                );

        DROP TABLE IF EXISTS JsonTypes;
        CREATE TABLE IF NOT EXISTS JsonTypes(
            row_id SERIAL,
            json_type JSON,
            jsonb_type JSONB,
            jsonpath_type JSONPATH,
            PRIMARY KEY(row_id)
        );

            INSERT INTO JsonTypes(
                json_type,
                jsonb_type,
                jsonpath_type
                ) 
            VALUES (
                '{"key1": "value", "key2": 2}',
                '{"key1": "value", "key2": 2}',
                '$."floor"[*]."apt"[*]?(@."area" > 40 && @."area" < 90)?(@."rooms" > 1)'
                );

            INSERT INTO JsonTypes(
                json_type,
                jsonb_type,
                jsonpath_type
                ) 
            VALUES (
                null,
                null,
                null
                );

        DROP TABLE IF EXISTS DateTimeTypes;
        CREATE TABLE IF NOT EXISTS DateTimeTypes(
            row_id SERIAL,
            time_type TIME,
            timetz_type TIMETZ,
            timestamp_type TIMESTAMP,
            timestamptz_type TIMESTAMPTZ,
            date_type DATE,
            interval_type INTERVAL,
            PRIMARY KEY(row_id)
        );

            INSERT INTO DateTimeTypes(
                time_type,
                timetz_type,
                timestamp_type,
                timestamptz_type,
                date_type,
                interval_type
                ) 
            VALUES (
                '04:05:06',
                '2003-04-12 04:05:06 America/New_York',
                '1999-01-08 04:05:06',
                '2004-10-19 10:23:54+02',
                '1999-01-08',
                'P1Y2M3DT4H5M6S'
                );
            
            INSERT INTO DateTimeTypes(
                time_type,
                timetz_type,
                timestamp_type,
                timestamptz_type,
                date_type,
                interval_type
                ) 
            VALUES (
                null,
                null,
                null,
                null,
                null,
                null
                );

        DROP TABLE IF EXISTS RangeTypes;
        CREATE TABLE IF NOT EXISTS RangeTypes(
            row_id SERIAL,
            int4range_type INT4RANGE,
            int8range_type INT8RANGE,
            numrange_type NUMRANGE,
            tsrange_type TSRANGE,
            tstzrange_type TSTZRANGE,
            daterange_type DATERANGE,
            PRIMARY KEY(row_id)
        );
            
            INSERT INTO RangeTypes(
                int4range_type,
                int8range_type,
                numrange_type,
                tsrange_type,
                tstzrange_type,
                daterange_type
                ) 
            VALUES (
                '(2,50)', 
                '(10,100)','(0,24)', 
                '(2010-01-01 14:30, 2010-01-01 15:30)', 
                '(2010-01-01 14:30, 2010-01-01 15:30)', 
                '(2010-01-01 14:30, 2010-01-03 )'
                );
        
            INSERT INTO RangeTypes(
                int4range_type,
                int8range_type,
                numrange_type,
                tsrange_type,
                tstzrange_type,
                daterange_type
                ) 
            VALUES (
                null,
                null,
                null,
                null,
                null,
                null
            );

        DROP TABLE IF EXISTS BitTypes;
        CREATE TABLE IF NOT EXISTS BitTypes(
            row_id SERIAL,
            bitstring_type BIT(10),
            varbitstring_type BIT VARYING(10),
            bit_type BIT,
            PRIMARY KEY(row_id)
        );

            INSERT INTO BitTypes(
                bitstring_type,
                varbitstring_type,
                bit_type
                ) 
            VALUES (
                '1110000111', 
                '1101', 
                '1'
                );

            INSERT INTO BitTypes(
                bitstring_type,
                varbitstring_type,
                bit_type
                ) 
            VALUES (
                null,
                null,
                null
                );

        DROP TABLE IF EXISTS PGLSNTypes;
        CREATE TABLE IF NOT EXISTS PglsnTypes(
            row_id SERIAL,
            pglsn_type PG_LSN,
            PRIMARY KEY(row_id)
        );

            INSERT INTO PglsnTypes(
                pglsn_type
                ) 
            VALUES (
                '16/B374D848'
                );

            INSERT INTO PglsnTypes(
                pglsn_type
                ) 
            VALUES (
                null
                );


        set lc_monetary to "en_US.utf8";

        DROP TABLE IF EXISTS MoneyTypes;
        CREATE TABLE IF NOT EXISTS MoneyTypes(
            row_id SERIAL,
            money_type MONEY,
            PRIMARY KEY(row_id)
        );
            INSERT INTO MoneyTypes(
                money_type
                ) 
            VALUES (
                '124.56'::money
                );
            
            INSERT INTO MoneyTypes(
                money_type
                ) 
            VALUES (
                null
                );

        DROP TABLE IF EXISTS objectidentifiertypes;
        CREATE TABLE IF NOT EXISTS objectIdentifiertypes(
            row_id SERIAL,
            oid_type OID,
            regclass_type REGCLASS,
            regconfig_type REGCONFIG,
            regdictionary_type REGDICTIONARY,
            regnamespace_type REGNAMESPACE,
            regoper_type REGOPER,
            regoperator_type REGOPERATOR,
            regproc_type REGPROC,
            regprocedure_type REGPROCEDURE,
            regrole_type REGROLE,
            regtype_type REGTYPE,
            PRIMARY KEY(row_id)
        );

            INSERT INTO objectidentIfiertypes(
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
                ) 
            VALUES (
                '12',
                'pg_type',
                'english',
                'simple',
                'pg_catalog',
                '!',
                '*(integer,integer)',
                'now',
                'sum(integer)',
                'postgres',
                'integer'
                );

            INSERT INTO objectidentIfiertypes(
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
                ) 
            VALUES (
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

        DROP TABLE IF EXISTS XmlTypes;
        CREATE TABLE IF NOT EXISTS XmlTypes(
            row_id SERIAL,
            xml_type XML,
            PRIMARY KEY(row_id)
        );

            INSERT INTO XmlTypes(
                xml_type
                ) 
            VALUES (
                '<foo><tag>bar</tag><tag>tag</tag></foo>'
                );
            
            INSERT INTO XmlTypes(
                xml_type
                ) 
            VALUES (
                null
                );

        DROP TABLE IF EXISTS XmlTypes;
        CREATE TABLE IF NOT EXISTS XmlTypes(
            row_id SERIAL,
            xml_type XML,
            PRIMARY KEY(row_id)
        );

            INSERT INTO XmlTypes(
                xml_type
                ) 
            VALUES (
                '<foo><tag>bar</tag><tag>tag</tag></foo>'
                );
        
            INSERT INTO XmlTypes(
                xml_type
                ) 
            VALUES (
                null
                );
    
        DROP TABLE IF EXISTS BinaryTypes;
        CREATE TABLE IF NOT EXISTS BinaryTypes(
                row_id SERIAL,
                bytea_type bytea,
                bytea_escape_type bytea,
                PRIMARY KEY(row_id)
            );

                INSERT INTO BinaryTypes(
                    bytea_type,
                    bytea_escape_type
                    ) 
                VALUES (
                    '\xDEADBEEF',
                    'abc \153\154\155 \052\251\124'
                    );

                INSERT INTO BinaryTypes(
                    bytea_type,
                    bytea_escape_type
                    ) 
                VALUES (
                    null,
                    null
                    );