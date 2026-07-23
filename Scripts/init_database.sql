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




