# Overview

The `atomic-batch-operation` project demonstrates how to use the PostgreSQL client to execute a batch of DDL/DML operations with the help of a `transaction` to achieve the atomic behaviour.

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
            url = "https://mvnrepository.com/artifact/org.postgresql/postgresql"
            groupId = "org.postgresql"
            artifactId = "postgresql"
            version = "42.2.20"
        ```

# Run the example
 
To run the example, move into the `atomic-batch-operation` folder and execute the below command.
 
```
$bal run
```
It will build the `atomic-batch-operation` Ballerina project and then run it.

# Output of the example

This gives the following output when running this project.

```ballerina
[ballerina/http] started HTTP/WS listener 192.168.1.10:55471
Error while executing batch command starting with: 'INSERT INTO Students
                (firstName, lastName, registrationID, creditLimit, country)
                VALUES ( ? ,  ? ,
                 ? ,  ? ,  ? )'.Batch entry 1 INSERT INTO Students
                (firstName, lastName, registrationID, creditLimit, country)
                VALUES ( 'Peter' ,  'Stuart' ,
                 1 ,  5000.75 ,  'USA' )
RETURNING * was aborted: ERROR: duplicate key value violates unique constraint "students_registrationid_key"
  Detail: Key (registrationid)=(1) already exists.  Call getNextException to see other errors in the batch..
[{"affectedRowCount":-3,"lastInsertId":null},{"affectedRowCount":-3,"lastInsertId":null},{"affectedRowCount":-3,"lastInsertId":null}]
Rollback transaction.

Data in Students table:
{"customerid":1,"firstname":"Peter","lastname":"Stuart","registrationid":1,"creditlimit":5000.75,"country":"USA"}
```
