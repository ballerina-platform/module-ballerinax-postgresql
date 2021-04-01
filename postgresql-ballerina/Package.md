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
```
  sql:ConnectionPool connectionPool = {
          maxOpenConnections: 25,
          maxConnectionLifeTime : 15,
          minIdleConnections : 15
      };
  postgresql:Client|sql:Error dbClient1 = new (host = "localhost", username = "postgres", password = "postgres",      
        database = "connectDB", port = 5432, connectionPool = connectionPool);
  sql:Error? e = dbClient1.close();

  postgresql:Client|sql:Error dbClient2 = new (host = "localhost", username = "postgres", password = "postgres",
        database = "connectDB", port = 5432, connectionPool = connectionPool);
  sql:Error? e = dbClient2.close();
```
2. Querying data
```
  string varcharValue = "This is a varchar1";
  sql:ParameterizedQuery sqlQuery1 = `SELECT * from CharacterTypes WHERE varchar_type = ${varcharValue}`;
  postgresql:Client|sql:Error dbClient = new ("localhost", "postgres", "postgres", "queryDb", 5432);
  stream<record {}, error> streamData = dbClient->query(sqlQuery);
  sql:Error? e = dbClient.close();
```
3. Inserting data
```
  postgresql:Client|sql:Error dbClient = new ("localhost", "postgres", "postgres", "executeDb", 5432);
  sql:ExecutionResult|sql:Error result = dbClient->execute("Insert into Student (student_id) values (20)");
  sql:Error? e = dbClient.close();
```
4. Updating data
```
  postgresql:Client|sql:Error dbClient = new ("localhost", "postgres", "postgres", "executeDb", 5432);
  sql:ExecutionResult|sql:Error result = dbClient->execute("Update CharacterTypes set varchar_type = 'updatedstring' 
        where varchar_type = 'str1'");
  sql:Error? e = dbClient.close();
```
5. Deleting data
```
  postgresql:Client|sql:Error dbClient = new ("localhost", "postgres", "postgres", "executeDb", 5432);
  sql:ExecutionResult|sql:Error result = ddbClient->execute("Delete from NumericTypes2 where int_type = 1451");
  sql:Error? e = dbClient.close();
```
6. Batch insert and update data
```
  var data = [
    {row_id: 12, longValue: 9223372036854774807, doubleValue: 123.34},
    {row_id: 13, longValue: 9223372036854774807, doubleValue: 123.34},
    {row_id: 14, longValue: 9223372036854774807, doubleValue: 123.34}
  ];
  sql:ParameterizedQuery[] sqlQueries =
      from var row in data
      select `INSERT INTO NumericTypes (row_id) VALUES (${row.row_id})`;
  postgresql:Client|sql:Error dbClient = new ("localhost", "postgres", "postgres", "batchExecuteDb", 5432);
  sql:ExecutionResult[]|sql:Error result = dbClient->batchExecute(sqlQueries);
  sql:Error? e = dbClient.close();

```
7. Execute stored procedures
```
  string name = "John";
  string department = "Computer Science And Engineering";
  decimal score = 53.75;
  
  result = postgresClient->execute(
    "Create procedure insertStudent "+
    "(studentName varchar, studentDepartment varchar, studentScore decimal)"+
    "language plpgsql as $$ "+
    "begin Insert into Student(name,department,score)"+
    " Values(studentName,studentDepartment,studentScore); end; $$;"
  );
  
  if(result is sql:Error){
    io:println("Error Occurred while creating the insertStudent procedure");
  }
  
  sql:ParameterizedCallQuery sqlQuery = `call insertStudent(${name}, ${department}, ${score})`;
  postgresql:Client|sql:Error dbClient = new ("localhost", "postgres", "postgres", "procedureDb", 5432);
  sql:ProcedureCallResult|sql:Error result = dbClient->call(sqlQuery);
  sql:Error? e = dbClient.close();
```
8. Closing client
```
  postgresql:Client|sql:Error dbClient = new ("localhost", "postgres", "postgres", "executeDb", 5432);
  sql:Error? e = dbClient.close();
```
