/*
================================================================================
Data Warehouse Initialization Script
================================================================================
Purpose:
    This script initializes the DataWarehouse database and creates the
    three-layer data warehouse architecture:

        1. Bronze Layer - Raw data ingestion
        2. Silver Layer - Cleaned and transformed data
        3. Gold Layer   - Business-ready and aggregated data

Process:
    1. Checks if the DataWarehouse database already exists.
    2. Drops the existing database to allow a clean re-creation.
    3. Creates a new DataWarehouse database.
    4. Creates the Bronze, Silver, and Gold schemas.
    5. Verifies that each schema was successfully created.

Warning:
    This script DROPS the existing DataWarehouse database and all its data.
    Use with caution and only in development or testing environments.

================================================================================
*/
-- Create database
-- GO: separates batches when working with multiple SQL statements
USE master;
GO

  --Drop and recreate the 'Daatawarehouse' database
  IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
  BEGIN
  ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACL IMMEDIATE;
DROP DATABASE DataWarehouse;
END;
GO
CREATE DATABASE DataWarehouse;


USE DataWarehouse;
GO

CREATE SCHEMA bronze;
GO

SELECT name
FROM sys.schemas
WHERE name = 'bronze';
GO

USE DataWarehouse;
GO

CREATE SCHEMA silver;
GO

SELECT name
FROM sys.schemas
WHERE name = 'silver';
GO


USE DataWarehouse;
GO

CREATE SCHEMA gold;
GO

SELECT name
FROM sys.schemas
WHERE name = 'gold';
GO




