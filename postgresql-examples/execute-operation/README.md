# Overview

// This example demonstrates how to use the PostgreSQL client with the DDL and DML operations.

# Prerequisite

* Install the PostgreSQL server and create a database 

* Add required configurations in the `config.toml` file 

* Download the PostgreSQL database driver JAR and update the path and version of the jar in the `Ballerina.toml` file

# Run the example
 
To run the example, move into the `execute-batch-operation` folder and execute the below command.
 
```
$bal run
```
It will build the `execute-operation` Ballerina project and then run it.

# Output of the example

This gives the following output when running this project.

```ballerina
Rows affected: 1
Generated Customer ID: 2
Updated Row count: 1
Deleted Row count: 1
```
