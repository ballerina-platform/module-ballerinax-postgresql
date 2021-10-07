# Change Log
This file contains all the notable changes done to the Ballerina postgresql package through the releases.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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