# Overview

The `batch-operation` project demonstrates how to use the PostgreSQL client to execute a batch of DDL/DML operations.

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
 
To run the example, move into the `batch-operation` project and execute the below command.
 
```
$bal run
```
It will build the `batch-operation` Ballerina project and then run it.

# Output of the example

This gives the following output when running this project.

```ballerina
Insert success, generated IDs are: [1,2,3]

Data in Customers table:
{"customerid":1,"firstname":"Peter","lastname":"Stuart","registrationid":1,"creditlimit":5000.75,"country":"USA"}
{"customerid":2,"firstname":"Stephanie","lastname":"Mike","registrationid":2,"creditlimit":8000.0,"country":"USA"}
{"customerid":3,"firstname":"Bill","lastname":"John","registrationid":3,"creditlimit":3000.25,"country":"USA"}
```
