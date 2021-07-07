# Overview

The `call-stored-operation` project demonstrates how to use the PostgreSQL client to execute a stored procedure.

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
 
To run the example, move into the `call-stored-operation` project and execute the below command.
 
```
$bal run
```
It will build the `call-stored-operation` Ballerina project and then run it.

# Output of the example

This gives the following output when running this project.

```ballerina
Call stored procedure `InsertStudent`.
Inserted data: {"id":1,"age":24,"name":"George"}
Call stored procedure `GetCount`.
Age of the student with id '1' : 24
Total student count: 1
```
