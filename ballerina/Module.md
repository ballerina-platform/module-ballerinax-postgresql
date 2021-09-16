## Overview

This module provides the functionality required to access and manipulate data stored in a PostgreSQL database.

### Prerequisite
Add the PostgreSQL driver JAR as a native library dependency in your Ballerina project's `Ballerina.toml` file.
It is recommended to use a PostgreSQL driver version greater than 42.2.18 as this module uses the database properties
from the PostgreSQL driver version 42.2.18 onwards.

Follow one of the following ways to add the JAR in the file:

* Download the JAR and update the path
    ```
    [[platform.java11.dependency]]
    path = "PATH"
    ```

* Add JAR with a maven dependency params
    ```
    [[platform.java11.dependency]]
    groupId = "org.postgresql"
    artifactId = "postgresql"
    version = "42.2.20"
    ```
  
### Client
To access a database, you must first create a
[postgresql:Client](https://docs.central.ballerina.io/ballerinax/postgresql/latest/clients/Client) object.
The examples for creating a PostgreSQL client can be found below.

#### Creating a Client
This example shows the different ways of creating the `postgresql:Client`.

When database is in the default user name, the client can be created with an empty constructor, and thereby, the client will be initialized the connection with PostgreSQL.

```ballerina
postgresql:Client|sql:Error dbClient = new ();
```

The `dbClient` receives the host, username, password, database and port. Since the properties are passed in the same order as they are defined
in the `postgresql:Client`, you can pass them without named params.

```ballerina
postgresql:Client|sql:Error dbClient2 = new ("localhost", "postgres", "postgres", "postgres", 5432);
```

The `dbClient` uses the named params to pass the attributes since it is skipping some params in the constructor.
Further, the [`postgresql:Options`](https://docs.central.ballerina.io/ballerinax/postgresql/latest/records/Options)
property is passed to configure the SSL and connection timeout in the PostgreSQL client.

```ballerina
postgresql:Options postgresqlOptions = {
  connectTimeout: 10
};
postgresql:Client|sql:Error dbClient = new (username = "postgres", password = "postgres", database = "test",
                              options = postgresqlOptions);
```

Similarly, the `dbClient` uses the named params and it provides an unshared connection pool of the type of
[sql:ConnectionPool](https://docs.central.ballerina.io/ballerina/sql/latest/records/ConnectionPool)
to be used within the client.
For more details about connection pooling, see the [`sql` Module](https://docs.central.ballerina.io/ballerina/sql/latest).

```ballerina
postgresql:Client|sql:Error dbClient4 = new (username = "postgres", password = "postgres",
                              connectionPool = {maxOpenConnections: 5});
```

#### Using SSL
To connect the PostgreSQL database using an SSL connection, you must add the SSL configurations to the `postgresql:Options` when creating the `dbClient`.
For the SSL Mode, you can select one of the modes: `postgresql:PREFERRED`, `postgresql:REQUIRED`,  `postgresql:DISABLE`, or `postgresql:ALLOW`, `postgresql:VERIFY_CA`, or `postgresql:VERIFY_IDENTITY` according to the requirement.
For the key files, you must provide the files in the `.p12` format.

```ballerina
string clientStorePath = "/path/to/keystore.p12";

postgresql:Options postgresqlOptions = {
    ssl: {
        mode: postgresql:ALLOW,
        key: {
            path: clientStorePath,
            password: "ballerina"
        }
    }
};
```
#### Connection Pool Handling

All database modules share the same connection pooling concept and there are three possible scenarios for 
connection pool handling.  For its properties and possible values, see the [`sql:ConnectionPool`](https://docs.central.ballerina.io/ballerina/sql/latest/records/ConnectionPool).

1. Global, shareable, default connection pool

    If you do not provide the `poolOptions` field when creating the database client, a globally-shareable pool will be 
    created for your database unless a connection pool matching with the properties you provided already exists. 

    ```ballerina
    postgresql:Client|sql:Error dbClient = 
                               new (username = "postgres", password = "postgres", database = "test");
    ```

2. Client owned, unsharable connection pool

    If you define the `connectionPool` field inline when creating the database client with the `sql:ConnectionPool` type, 
    an unsharable connection pool will be created. The JDBC module example below shows how the global 
    connection pool is used.

    ```ballerina
    postgresql:Client|sql:Error dbClient = 
                               new (username = "postgres", password = "postgres", database = "test", 
                               connectionPool = { maxOpenConnections: 5 });
    ```

3. Local, shareable connection pool

    If you create a record of type `sql:ConnectionPool` and reuse that in the configuration of multiple clients, 
    for each set of clients that connects to the same database instance with the same set of properties, a shared 
    connection pool will be created.

    ```ballerina
    sql:ConnectionPool connPool = {maxOpenConnections: 5};
    
    postgresql:Client|sql:Error dbClient1 =       
                               new (username = "postgres", password = "postgres", database = "test",
                               connectionPool = connPool);
    postgresql:Client|sql:Error dbClient2 = 
                               new (username = "postgres", password = "postgres", database = "test",
                               connectionPool = connPool);
    postgresql:Client|sql:Error dbClient3 = 
                               new (username = "postgres", password = "postgres", database = "example",
                               connectionPool = connPool);
    ```
   
For more details about each property, see the [`postgresql:Client`](https://docs.central.ballerina.io/ballerinax/postgresql/latest/clients/Client).

The [postgresql:Client](https://docs.central.ballerina.io/ballerinax/postgresql/latest/clients/Client) references
[sql:Client](https://docs.central.ballerina.io/ballerina/sql/latest/clients/Client) and all the operations
defined by the `sql:Client` will be supported by the `postgresql:Client` as well.
 
#### Closing the Client

Once all the database operations are performed, you can close the database client you have created by invoking the `close()`
operation. This will close the corresponding connection pool if it is not shared by any other database clients. 

```ballerina
error? e = dbClient.close();
```
or
```ballerina
check dbClient.close();
```

### Database Operations

Once the client is created, database operations can be executed through that client. This module defines the interface 
and common properties that are shared among multiple database clients.  It also supports querying, inserting, deleting, 
updating, and batch updating data.  

#### Creating Tables

This sample creates a table with two columns. One column is of type `int` and the other is of type `varchar`.
The `CREATE` statement is executed via the `execute` remote function of the client.

```ballerina
// Create the ‘Students’ table with the  ‘id’, 'name', and ‘age’ fields.
sql:ExecutionResult ret = check dbClient->execute("CREATE TABLE student(id INT SERIAL, " +
                         "age INT, name VARCHAR(255), PRIMARY KEY (id))");
```

#### Inserting Data

This sample shows four examples of data insertion by executing an `INSERT` statement using the `execute` remote function 
of the client.

In the first example, the query parameter values are passed directly into the query statement of the `execute` 
remote function.

```ballerina
sql:ExecutionResult ret = check dbClient->execute("INSERT INTO student(age, name) " +
                         "values (23, 'john')");
```

In the second example, the parameter values, which are in local variables are used to parameterize the SQL query in 
the `execute` remote function. This type of a parameterized SQL query can be used with any Ballerina primitive type 
like `string`, `int`, `float`, or `boolean` and in that case, the corresponding SQL type of the parameter is derived 
from the type of the Ballerina variable that is passed in. 

```ballerina
string name = "Anne";
int age = 8;

sql:ParameterizedQuery query = `INSERT INTO student(age, name)
                                values (${age}, ${name})`;
sql:ExecutionResult ret = check dbClient->execute(query);
```

In the third example, the values of the special type(Other than Ballerina primitive type) are passed as parameter values to the `execute` remote function. 
To find all the special types, see [`sql:Classes`](https://docs.central.ballerina.io/ballerina/sql/latest#classes) and [`postgresql:Classes`](https://docs.central.ballerina.io/ballerina/postgresql/latest#classes).

```ballerina
sql:VarcharValue name = new ("James");
sql:IntegerValue age = new (10);

sql:ParameterizedQuery query = `INSERT INTO student(age, name)
                                values (${age}, ${name})`;
sql:ExecutionResult ret = check dbClient->execute(query);
```

In the fourth example, the array types values are passed as parameter values to the `execute` remote function.
```ballerina
sql:VarcharArrayValue name = new (["James", "Sam"]);
sql:IntegerArrayValue age = new ([10, 12]);

sql:ParameterizedQuery query = `INSERT INTO customer(age, name)
                                values (${age}, ${name})`;
sql:ExecutionResult ret = check dbClient->execute(query);
```
#### Inserting Data With Auto-generated Keys

This example demonstrates inserting data while returning the auto-generated keys. It achieves this by using the 
`execute` remote function to execute the `INSERT` statement.

```ballerina
int age = 31;
string name = "Kate";

sql:ParameterizedQuery query = `INSERT INTO student(age, name)
                                values (${age}, ${name})`;
sql:ExecutionResult  ret = check dbClient->execute(query);
// Number of rows affected by the execution of the query.
int? count = ret.affectedRowCount;
// The integer or string generated by the database in response to a query execution.
string|int? generatedKey = ret.lastInsertId;
```

#### Querying Data

This sample shows three examples to demonstrate the different usages of the `query` operation to query the
database table and obtain the results. 

This example demonstrates querying data from a table in a database. 
First, a type is created to represent the returned result set. Note the mapping of the database column 
to the returned record's property is case-insensitive (i.e., the `ID` column in the result can be mapped to the `id` 
property in the record). Next, the `SELECT` query is executed via the `query` remote function of the client. 
Once the query is executed, each data record can be retrieved by looping the result set. The `stream`  
returned by the `SELECT` operation holds a pointer to the actual data in the database and it loads data from the table 
only when it is accessed. This stream can be iterated only once. 

```ballerina
// Define a type to represent the results.
type Student record {
    int id;
    int age;
    string name;
};

// Select the data from the database table. The query parameters are passed 
// directly. Similar to the `execute` examples, parameters can be passed as
// sub types of `sql:TypedValue` as well.
int id = 10;
int age = 12;
sql:ParameterizedQuery query = `SELECT * FROM students
                                WHERE id < ${id} AND age > ${age}`;
stream<Student, sql:Error?> resultStream = dbClient->query(query);

// Iterating the returned table.
error? e = resultStream.forEach(function(Student student) {
   //Can perform any operations using 'student' and can access any fields in the returned record of type `Student`.
});
```

Defining the return type is optional. Hence, the above example can be modified as follows with an open record 
type as the return type. The field name in the open record type will be the same as how the column is defined 
in the database.

```ballerina
// Select the data from the database table. The query parameters are passed 
// directly. Similar to the `execute` examples, parameters can be passed as 
// sub types of `sql:TypedValue` as well.
int id = 10;
int age = 12;
sql:ParameterizedQuery query = `SELECT * FROM students
                                WHERE id < ${id} AND age > ${age}`;
stream<record{}, sql:Error?> resultStream = dbClient->query(query);

// Iterating the returned table.
error? e = resultStream.forEach(function(record{} student) {
    //Can perform any operations using 'student' and can access any fields in the returned record.
});
```

#### Updating Data

This example demonstrates modifying data by executing an `UPDATE` statement via the `execute` remote function of 
the client.

```ballerina
int age = 23;
sql:ParameterizedQuery query = `UPDATE students SET name = 'John' 
                                WHERE age = ${age}`;
sql:ExecutionResult ret = check dbClient->execute(query);
```

#### Deleting Data

This example demonstrates deleting data by executing a `DELETE` statement via the `execute` remote function of 
the client.

```ballerina
string name = "John";
sql:ParameterizedQuery query = `DELETE from students WHERE name = ${name}`;
sql:ExecutionResult ret = check dbClient->execute(query);
```

#### Batch Updating Data

This example demonstrates how to insert multiple records with a single `INSERT` statement that is executed via the 
`batchExecute` remote function of the client. This is done by creating a `table` with multiple records and 
parameterized SQL query as same as the  above `execute` operations.

```ballerina
// Create the table with the records that need to be inserted.
var data = [
  { name: "John", age: 25  },
  { name: "Peter", age: 24 },
  { name: "jane", age: 22 }
];

// Do the batch update by passing the batches.
sql:ParameterizedQuery[] batch = from var row in data
                                 select `INSERT INTO students ('name', 'age')
                                 VALUES (${row.name}, ${row.age})`;
sql:ExecutionResult[] ret = check dbClient->batchExecute(batch);
```

#### Execute Stored Procedures

This example demonstrates how to execute a stored procedure with a single `INSERT` statement that is executed via the 
`call` remote function of the client.

```ballerina
int uid = 10;
sql:IntegerOutParameter insertId = new;

sql:ProcedureCallResult|sql:Error ret = dbClient->call(`call InsertPerson(${uid}, ${insertId})`);
if ret is error {
    //An error returned
} else {
    stream<record{}, sql:Error?>? resultStr = ret.queryResult;
    if resultStr is stream<record{}, sql:Error?> {
        sql:Error? e = resultStr.forEach(function(record{} result) {
        //can perform operations using 'result'.
      });
    }
    check ret.close();
}
```

Note that you have to invoke the close operation on the `sql:ProcedureCallResult` explicitly to release the connection resources and avoid a connection leak as shown above.

>**Note:** The default thread pool size used in Ballerina is: `the number of processors available * 2`. You can configure the thread pool size by using the `BALLERINA_MAX_POOL_SIZE` environment variable.
