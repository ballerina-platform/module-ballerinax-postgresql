## Package overview

This Package provides the functionality required to access and manipulate data stored in a PostgreSQL database.  

**Prerequisite:** Add the PostgreSQL driver JAR as a native library dependency in your Ballerina project. 
This Package uses database properties from the PostgreSQL version 42.2.18. Therefore, it is recommended to use a 
PostgreSQL driver version 42.2.18. Then, once you build the project by executing the `bal build`
command, you should be able to run the resultant by executing the `bal run` command.

E.g., The `Ballerina.toml` content.
Change the path to the JDBC driver appropriately.

```toml
[package]
org = "sample"
name = "postgresql"
version= "0.1.0"

[[platform.java11.dependency]]
artifactId = "postgresql-connector-java"
version = "42.2.18"
path = "/path/to/postgresql-connector-java-42.2.18.jar"
groupId = "postgresql"
``` 

### Client
To access a database, you must first create a 
[postgresql:Client] object. 

#### Creating a client
This example shows different ways of creating the `postgresql:Client`. 

The client can be created with an empty constructor and hence, the client will be initialized with the default properties. 
The first example with the `dbClient1` demonstrates this.

The `dbClient2` receives the host, username, and password. Since the properties are passed in the same order as it is defined 

The `dbClient3` uses the named params to pass the attributes since it is skipping some params in the constructor. 


Similarly, the `dbClient4` uses the named params and it provides an unshared connection pool in the type of 
[sql:ConnectionPool](https://ballerina.io/learn/api-docs/ballerina/#/sql/records/ConnectionPool) 
to be used within the client. 
For more details about connection pooling, see the [SQL Package](https://ballerina.io/learn/api-docs/ballerina/#/sql).

```ballerina
postgresql:Client|sql:Error dbClient1 = new ();
postgresql:Client|sql:Error dbClient2 = new ("localhost", "postgres", "postgres", 
                              "postgres", 5432);
postgresql:Options postgresqlOptions = {
  connectTimeout: 10
};
postgresql:Client|sql:Error dbClient3 = new (user = "postgres", password = "postgres",
                              options = postgresqlOptions);
                              
postgresql:Client|sql:Error dbClient4 = new (user = "postgres", password = "postgres",
                              connectionPool = {maxOpenConnections: 5});
```
Following Operations can be handled by postgresql:Client

1. Connection Pooling
2. Querying data
3. Inserting data
4. Updating data
5. Deleting data
6. Batch insert and update data
7. Execute stored procedures
8. Closing client