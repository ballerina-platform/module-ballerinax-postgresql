# Define default username for client connections

_Owners_: @kaneeldias  
_Reviewers_: @daneshk @niveathika  
_Created_: 2022/04/25  
_Updated_: 2022/04/25  
_Edition_: Swan Lake  
_Issues_: [#2397](https://github.com/ballerina-platform/ballerina-standard-library/issues/2397)

## Summary
Define default username to be used when connecting to a PostgreSQL database on client initialization.

## History
The 1.3.x versions and below of the PostgreSQL package defaulted to connecting to the database without a username
attached (i.e. an empty string).

## Goals
- Define the default username to be used when connecting to a PostgreSQL database on client initialization.

## Motivation
The ability to connect to common databases with default credentials (as opposed to manually defining) would make the
developer experience much more quick, simple and user-friendly, especially in testing scenarios.

## Description
For PostgreSQL databases, the default username is `postgres`[[1]](https://www3.ntu.edu.sg/home/ehchua/programming/sql/PostgreSQL_GetStarted.html)

Modify the [client initialization method](https://github.com/ballerina-platform/module-ballerinax-postgresql/blob/ebe926565f151f7ebd0420e26b0771bbeac432f2/ballerina/client.bal#L37-L38)
signature to use `postgres` as the default value for the username instead of `()`.

```ballerina
    public isolated function init(string host = "localhost", string? username = "postgres", string? password = (), string? database = (),
        int port = 5432, Options? options = (), sql:ConnectionPool? connectionPool = ()) returns sql:Error? {
```

## References
[1] https://www3.ntu.edu.sg/home/ehchua/programming/sql/PostgreSQL_GetStarted.html
