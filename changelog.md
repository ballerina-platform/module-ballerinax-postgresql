# Change Log
This file contains all the notable changes done to the Ballerina postgresql package through the releases.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- [Improve DB columns to Ballerina record Mapping through Annotation](https://github.com/ballerina-platform/ballerina-standard-library/issues/2652)

### Changed
- [Fixed compiler plugin validation for `time` module constructs](https://github.com/ballerina-platform/ballerina-standard-library/issues/2893)
  [Fix incorrect code snippet in SQL api docs](https://github.com/ballerina-platform/ballerina-standard-library/issues/2931)

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
