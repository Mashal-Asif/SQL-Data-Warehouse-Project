/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates the Gold layer views for the DataWarehouse.

    Gold Layer:
        - gold.dim_customers
        - gold.dim_products
        - gold.fact_sales

    The Gold layer represents the final business-ready data model
    following a Star Schema design.

    Data Flow:
        Bronze -> Silver -> Gold

    Bronze:
        Raw data loaded from source systems.

    Silver:
        Cleaned, transformed, and standardized data.

    Gold:
        Business-ready dimensions and fact data for analytics and reporting.

===============================================================================
*/


-- =============================================================================
-- STEP 1: Select DataWarehouse Database
-- =============================================================================

USE DataWarehouse;
GO


-- =============================================================================
-- STEP 2: Create Gold Schema
-- =============================================================================

IF NOT EXISTS
(
    SELECT 1
    FROM sys.schemas
    WHERE name = 'gold'
)
BEGIN
    EXEC('CREATE SCHEMA gold');
END;
GO


-- =============================================================================
-- STEP 3: Create Customer Dimension
-- =============================================================================
-- Source Tables:
--     silver.crm_cust_info
--     silver.erp_cust_az12
--     silver.erp_loc_a101
--
-- Output:
--     gold.dim_customers
-- =============================================================================

CREATE OR ALTER VIEW gold.dim_customers
AS
SELECT
    ROW_NUMBER() OVER
    (
        ORDER BY ci.cst_id
    ) AS customer_key,

    ci.cst_id AS customer_id,

    ci.cst_key AS customer_number,

    ci.cst_firstname AS first_name,

    ci.cst_lastname AS last_name,

    la.cntry AS country,

    ci.cst_marital_status AS marital_status,

    CASE
        WHEN ci.cst_gndr <> 'n/a'
            THEN ci.cst_gndr

        WHEN ca.gen IS NOT NULL
            THEN ca.gen

        ELSE 'n/a'
    END AS gender,

    ca.bdate AS birthdate,

    ci.cst_create_date AS create_date

FROM silver.crm_cust_info AS ci

LEFT JOIN silver.erp_cust_az12 AS ca
    ON ci.cst_key = ca.cid

LEFT JOIN silver.erp_loc_a101 AS la
    ON ci.cst_key = la.cid;
GO


-- =============================================================================
-- STEP 4: Create Product Dimension
-- =============================================================================
-- Source Tables:
--     silver.crm_prd_info
--     silver.erp_px_cat_g1v2
--
-- Output:
--     gold.dim_products
-- =============================================================================

CREATE OR ALTER VIEW gold.dim_products
AS
SELECT
    ROW_NUMBER() OVER
    (
        ORDER BY
            pn.prd_start_dt,
            pn.prd_key
    ) AS product_key,

    pn.prd_id AS product_id,

    pn.prd_key AS product_number,

    pn.prd_nm AS product_name,

    pn.cat_id AS category_id,

    pc.cat AS category,

    pc.subcat AS subcategory,

    pc.maintenance AS maintenance,

    pn.prd_cost AS cost,

    pn.prd_line AS product_line,

    pn.prd_start_dt AS start_date

FROM silver.crm_prd_info AS pn

LEFT JOIN silver.erp_px_cat_g1v2 AS pc
    ON pn.cat_id = pc.id

WHERE pn.prd_end_dt IS NULL;
GO


-- =============================================================================
-- STEP 5: Create Sales Fact
-- =============================================================================
-- Source Tables:
--     silver.crm_sales_details
--     gold.dim_products
--     gold.dim_customers
--
-- Output:
--     gold.fact_sales
-- =============================================================================

CREATE OR ALTER VIEW gold.fact_sales
AS
SELECT
    sd.sls_ord_num AS order_number,

    dp.product_key AS product_key,

    dc.customer_key AS customer_key,

    sd.sls_order_dt AS order_date,

    sd.sls_ship_dt AS shipping_date,

    sd.sls_due_dt AS due_date,

    sd.sls_sales AS sales_amount,

    sd.sls_quantity AS quantity,

    sd.sls_price AS price

FROM silver.crm_sales_details AS sd

LEFT JOIN gold.dim_products AS dp
    ON sd.sls_prd_key = dp.product_number

LEFT JOIN gold.dim_customers AS dc
    ON sd.sls_cust_id = dc.customer_id;
GO


-- =============================================================================
-- STEP 6: Verify Gold Views Were Created
-- =============================================================================

SELECT
    TABLE_SCHEMA,
    TABLE_NAME
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = 'gold';
GO


-- =============================================================================
-- STEP 7: Test Customer Dimension
-- =============================================================================

SELECT *
FROM gold.dim_customers;
GO


-- =============================================================================
-- STEP 8: Test Product Dimension
-- =============================================================================

SELECT *
FROM gold.dim_products;
GO


-- =============================================================================
-- STEP 9: Test Sales Fact
-- =============================================================================

SELECT *
FROM gold.fact_sales;
GO
