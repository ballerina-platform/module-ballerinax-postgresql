# Fraud Detection 

This example demonstrates how to use the `postgresql:CdcListener` to implement a fraud detection system. The system listens to table changes and processes them to identify potential fraudulent activities.

## Setup Guide

### 1. Postgres Database

1. Refer to the [Setup Guide](https://central.ballerina.io/ballerinax/postgresql/latest#setup-guide) for the necessary steps to enable CDC in the Postgresql server.

2. Add the necessary schema and data using the `setup.sql` script:
   ```bash
   psql -U <username> -p < db_scripts/setup.sql
   ```

### 2. Configuration

Configure Postgres Database credentials in the `Config.toml` file located in the example directory:

```toml
username = "<DB Username>"
password = "<DB Password>"
```

## Setup Guide: Using Docker Compose

You can use Docker Compose to set up Postgres for this example. Follow these steps:

### 1. Start the service

Run the following command to start the Postgres service:

```bash
docker-compose up -d
```

### 2. Verify the service

Ensure `postgresql` service is in a healthy state:

```bash
docker-compose ps
```

### 3. Configuration

Ensure the `Config.toml` file is updated with the following credentials:

```toml
username = "cdc_user"
password = "cdc_password"
```

## Run the Example

1. Execute the following command to run the example:

   ```bash
   bal run
   ```

2. Use the provided `test.sql` script to insert sample transactions into the `transactions` table to test the fraud detection system. Use the following SQL command:
   ```bash
   psql -U <username> -d <database> -f db_scripts/test.sql
   ```

   If using docker services,

   ```bash
   docker exec -i postgresql-cdc psql -U cdc_user -d <database> -f /db-scripts/test.sql
   ```