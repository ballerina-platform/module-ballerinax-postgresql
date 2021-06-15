# Overview

This example demonstrates how to use the PostgreSQL client with complex data types such as JSON, range and date/time fields.

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
 
To run the example, move into the `complex-queries-operation` folder and execute the below command.
```
$bal run
```
It will build the `complex-queries-operation` Ballerina project and then run it.

# Output of the example

This gives the following output when running this project.

```ballerina
Json types Result :
{"row_id":1,"json_type":{"key1":"value","key2":2},"jsonb_type":{"key1":"value","key2":2},"jsonpath_type":"$."floor"[*]."apt"[*]?(@."area" > 40 && @."area" < 90)?(@."rooms" > 1)"}
Range type Result :
{"row_id":1,"int4range_type":{"upper":50,"lower":3,"upperboundInclusive":false,"lowerboundInclusive":true},"int8range_type":{"upper":100,"lower":11,"upperboundInclusive":false,"lowerboundInclusive":true},"numrange_type":{"upper":24,"lower":0,"upperboundInclusive":false,"lowerboundInclusive":false},"tsrange_type":{"upper":"2010-01-01 15:30:00","lower":"2010-01-01 14:30:00","upperboundInclusive":false,"lowerboundInclusive":false},"tstzrange_type":{"upper":"2010-01-01 15:30:00+05:30","lower":"2010-01-01 14:30:00+05:30","upperboundInclusive":false,"lowerboundInclusive":false},"daterange_type":{"upper":"2010-01-03","lower":"2010-01-02","upperboundInclusive":false,"lowerboundInclusive":true}}
DateTime types Result :
{"row_id":1,"time_type":{"hour":4,"minute":5,"second":6},"timetz_type":{"hour":13,"minute":35,"second":6},"timestamp_type":{"year":1999,"month":1,"day":8,"hour":4,"minute":5,"second":6},"timestamptz_type":{"year":2004,"month":10,"day":19,"hour":14,"minute":23,"second":54},"date_type":{"year":1999,"month":1,"day":8},"interval_type":{"years":1,"months":2,"days":3,"hours":4,"minutes":5,"seconds":6.0}}
```
