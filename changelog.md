# Change Log
This file contains all the notable changes done to the Ballerina postgresql package through the releases.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- [Provide a way to set the current schema when initializing the db connection](https://github.com/ballerina-platform/ballerina-library/issues/7517)

## [1.13.2] - 2024-11-11

### Added
- [Allow prepareThreshold, preparedStatementCacheQueries and preparedStatementCacheSizeMiB to pass 0 values](https://github.com/ballerina-platform/ballerina-standard-library/issues/7345)

## [1.10.0] - 2023-06-30

### Added
- [Add compiler plugin validation to validate spread-field config initialization](https://github.com/ballerina-platform/ballerina-standard-library/issues/4594)

### Changed
- [Support retrieval of enum types](https://github.com/ballerina-platform/ballerina-standard-library/issues/4588)

## [1.7.0] - 2023-02-20

### Changed
- [Remove SQL_901 diagnostic hint](https://github.com/ballerina-platform/ballerina-standard-library/issues/3609)
- [Enable non-Hikari logs](https://github.com/ballerina-platform/ballerina-standard-library/issues/3763)
- [Improve API docs based on Best practices](https://github.com/ballerina-platform/ballerina-standard-library/issues/3857)

## [1.6.2] - 2023-02-09

### Changed
- [Improve API docs based on Best practices](https://github.com/ballerina-platform/ballerina-standard-library/issues/3857)
- [Fix compiler plugin failure when the diagnostic code is null](https://github.com/ballerina-platform/ballerina-standard-library/issues/4054)

## [1.6.1] - 2022-12-01

### Changed
- [Updated API Docs on `posgresql.driver` usages](https://github.com/ballerina-platform/ballerina-standard-library/issues/3710)

## [1.6.0] - 2022-11-29

### Changed
- [Updated API Docs](https://github.com/ballerina-platform/ballerina-standard-library/issues/3463)

## [1.5.0] - 2022-09-08

### Changed
- [Change default username for client initialization to `postgres`](https://github.com/ballerina-platform/ballerina-standard-library/issues/2397)

## [1.4.1] - 2022-06-27

### Changed
- [Fix NullPointerException when retrieving record with default value](https://github.com/ballerina-platform/ballerina-standard-library/issues/2985)

## [1.4.0] - 2022-05-30

### Added
- [Improve DB columns to Ballerina record Mapping through Annotation](https://github.com/ballerina-platform/ballerina-standard-library/issues/2652)

### Changed
- [Fixed compiler plugin validation for `time` module constructs](https://github.com/ballerina-platform/ballerina-standard-library/issues/2893)
- [Fix incorrect code snippet in SQL api docs](https://github.com/ballerina-platform/ballerina-standard-library/issues/2931)

## [1.3.1] - 2022-03-01

### Changed
- [Improve API documentation to reflect query usages](https://github.com/ballerina-platform/ballerina-standard-library/issues/2524)

## [1.3.0] - 2022-01-29

### Changed
- [Fix Compiler plugin crash when variable is passed for `sql:ConnectionPool` and `postgresql:Options`](https://github.com/ballerina-platform/ballerina-standard-library/issues/2536)

## [1.2.1] - 2022-02-03

### Changed
- [Fix Compiler plugin crash when variable is passed for `sql:ConnectionPool` and `postgresql:Options`](https://github.com/ballerina-platform/ballerina-standard-library/issues/2536)

## [1.2.0] - 2021-12-13

### Added
- [Tooling support for Postgresql module](https://github.com/ballerina-platform/ballerina-standard-library/issues/2281)

## [1.1.0] - 2021-11-20

### Changed
- [Change queryRow return type to anydata](https://github.com/ballerina-platform/ballerina-standard-library/issues/2390)
- [Make OutParameter get function parameter optional](https://github.com/ballerina-platform/ballerina-standard-library/issues/2388)

## [1.0.0] - 2021-10-09

### Changed 
- [Improve inout parameter which supports array types for call procedure](https://github.com/ballerina-platform/ballerina-standard-library/issues/1516)
- [Add completion type as nil in SQL query return stream type](https://github.com/ballerina-platform/ballerina-standard-library/issues/1654)

### Added
- [Add support for queryRow](https://github.com/ballerina-platform/ballerina-standard-library/issues/1604)
- [Remove support for string parameter in APIs](https://github.com/ballerina-platform/ballerina-standard-library/issues/2010)

[0.6.0-beta.2] - 2021-06-02

### Added
- Basic CRUD functionalities with an PostgreSQL database.
- Insert functionality for PostgreSQL specific data types.
- Select functionality for PostgreSQL specific data types.
- Procedure and Function Operations for PostgreSQL specific data types.
- Add array data types.
- Make the Client class to isolated.
