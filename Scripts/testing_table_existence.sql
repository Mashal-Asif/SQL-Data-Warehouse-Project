SELECT
    DB_NAME() AS CurrentDatabase;
GO

SELECT
    TABLE_CATALOG AS DatabaseName,
    TABLE_SCHEMA AS SchemaName,
    TABLE_NAME AS TableName
FROM DataWarehouse.INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'silver';
GO
USE DataWarehouse;
GO

SELECT
    name AS SchemaName
FROM sys.schemas
WHERE name IN ('bronze', 'silver', 'gold');
GO
USE DataWarehouse;
GO

SELECT
    s.name AS SchemaName,
    t.name AS TableName
FROM sys.tables AS t
INNER JOIN sys.schemas AS s
    ON t.schema_id = s.schema_id
WHERE s.name IN ('bronze', 'silver')
ORDER BY
    s.name,
    t.name;
GO

USE DataWarehouse;
GO

EXEC silver.load_silver;
GO

SELECT DB_NAME();

SELECT *
FROM DataWarehouse.silver.crm_cust_info;

SELECT
    TABLE_CATALOG,
    TABLE_SCHEMA,
    TABLE_NAME
FROM DataWarehouse.INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'silver';

