/*

==============================================================================================
Create Tables
==============================================================================================


Script Purpose:
    This script creates the staging/bronze tables sourced from ERP and CRM systems.
    It ensures deterministic loading by dropping any existing table with the same name
    before attempting creation.

WARNING:
    ⚠️ This script will DROP existing tables in the [bronze] schema if they exist.
       Any current data stored in these tables will be lost.
       Use with caution in shared or production environments.

*/

-- Drop CRM Customer Info table if it already exists
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;
-- Create CRM Customer Info table
CREATE TABLE bronze.crm_cust_info (
    cst_id               INT,             
    cst_key              NVARCHAR(50),    
    cst_firstname        NVARCHAR(50),    
    cst_lastname         NVARCHAR(50),    
    cst_material_status  NVARCHAR(50),    
    cst_gndr             NVARCHAR(50),    
    cst_create_date      DATE             
);

-- Drop CRM Product master table if it already exists
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;
-- Create CRM Product master table
CREATE TABLE bronze.crm_prd_info (
    prd_id       INT,             
    prd_key      NVARCHAR(50),    
    prd_nm       NVARCHAR(50),    
    prd_cost     INT,             
    prd_line     NVARCHAR(50),    
    prd_start_dt DATETIME,        
    prd_end_dt   DATETIME         
);

-- Drop CRM Sales Details fact table if it already exists
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;
-- Create CRM Sales Details table
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num   NVARCHAR(50),   
    sls_prd_key   NVARCHAR(50),   
    sls_cust_id   INT,            
    sls_order_dt  INT,            
    sls_ship_dt   INT,         
    sls_due_dt    INT,         
    sls_sales     INT,           
    sls_quantity  INT,           
    sls_price     INT           
);

-- Drop ERP Country/Location mapping table if it already exists
IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a101;
-- Create ERP Country/Location mapping table
CREATE TABLE bronze.erp_loc_a101 (
    cid    NVARCHAR(50), 
    cntry  NVARCHAR(50)   
);

-- Drop ERP Customer Demographics table if it already exists
IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;
-- Create ERP Customer Demographics table
CREATE TABLE bronze.erp_cust_az12 (
    cid    NVARCHAR(50),  
    bdate  DATE,         
    gen    NVARCHAR(50)   
);

-- Drop ERP Pricing Category table if it already exists
IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;
-- Create ERP Pricing Category lookup table
CREATE TABLE bronze.erp_px_cat_g1v2 (
    id           NVARCHAR(50), 
    cat          NVARCHAR(50), 
    subcat       NVARCHAR(50), 
    maintenance  NVARCHAR(50)  
);
