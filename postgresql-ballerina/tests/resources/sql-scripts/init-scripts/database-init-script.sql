CREATE TYPE complex AS (
    r numeric,
    i decimal
);

CREATE TYPE inventory_item AS (
    name   text,
    supplierId integer,
    isExpired  boolean
);

CREATE TYPE value AS ENUM ('value1', 'value2', 'value3');