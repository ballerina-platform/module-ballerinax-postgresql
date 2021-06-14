# Overview

The `batch-operation` project demonstrates how to use the PostgreSQL client to execute a batch of DDL/DML operations.

# Prerequisite

* Install the PostgreSQL server and create a database 

* Add required configurations in the `config.toml` file 

* Download the PostgreSQL database driver JAR and update the path and version of the jar in the `Ballerina.toml` file

# Run the example
 
To run the example, move into the `batch-operation` folder and execute the below command.
 
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
