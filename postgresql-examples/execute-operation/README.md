# Overview

// This example demonstrates how to use the PostgreSQL client with the DDL and DML operations.

# Prerequisite

* Install the PostgreSQL server and create a database 

* Add required configurations in the `config.toml` file 

* Follow one of the following ways to add PostgreSQL database driver JAR in the `Ballerina.toml` file:
    * Download the JAR and update the path
        ```
            [[platform.java11.dependency]]
            path = "PATH"
        ```
     
    * Replace the above path with a maven dependency param
        ```
            [platform.java11.dependency]]
            groupId = "org.postgresql"
            artifactId = "postgresql"
            version = "42.2.20"
        ```
# Run the example
 
To run the example, move into the `execute-batch-operation` project and execute the below command.
 
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
