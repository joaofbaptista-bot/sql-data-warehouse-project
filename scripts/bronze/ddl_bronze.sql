/*

=============================================================================================================
Load Scripts + Stored Procedure
=============================================================================================================


PURPOSE:
    Executes a full refresh load of CRM and ERP source files into the Bronze staging layer.
    The process runs inside a stored procedure that:
        • Truncates all target tables to ensure a clean reload
        • Loads CSV source files using BULK INSERT for fast ingestion
        • Logs progress milestones using PRINT statements
        • Captures start/end times per table and overall batch duration
        • Implements TRY/CATCH error handling to surface load failures clearly

    TRUNCATE TABLE is used to remove existing data efficiently without logging overhead,
    enabling deterministic full loads for staging tables.
    BULK INSERT is leveraged to ingest flat files with minimal parsing cost, assuming a
    consistent file structure and delimiter.

WARNING:
    ⚠ Running this stored procedure will delete all existing data from the Bronze tables.
      Validate that downstream layers do not depend on previous staging data.
      Intended for controlled batch ETL processing environments.

*/

-------------------------------------------
-- CRM - Customer Information
-------------------------------------------



CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME,@batch_start_time DATETIME, @batch_end_time DATETIME;

    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '=====================================================';
        PRINT 'Loading Bronze Layer';
        PRINT '=====================================================';

        PRINT '-----------------------------------------------------';
        PRINT 'Loading CRM Tables';
        PRINT '-----------------------------------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;
    
        PRINT '>> Inserting Table: bronze.crm_cust_info';
        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\JAB\Desktop\Udemy\SQL\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
        PRINT '-----------------';


        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT '>> Inserting Table: bronze.crm_prd_info';
        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\JAB\Desktop\Udemy\SQL\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
        PRINT '-----------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT '>> Inserting Table: bronze.crm_sales_details';
        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\JAB\Desktop\Udemy\SQL\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
        PRINT '-----------------';

        PRINT '-----------------------------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '-----------------------------------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;

        PRINT '>> Inserting Table: bronze.erp_cust_az12';
        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\JAB\Desktop\Udemy\SQL\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
        PRINT '-----------------';

        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;

        PRINT '>> Inserting Table: bronze.erp_loc_a101';
        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\JAB\Desktop\Udemy\SQL\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
        PRINT '-----------------';


        SET @start_time = GETDATE();
        PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT '>> Inserting Table: bronze.erp_px_cat_g1v2';
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\JAB\Desktop\Udemy\SQL\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second,@start_time,@end_time) AS NVARCHAR) + ' seconds';
        PRINT '-----------------';


        SET @batch_end_time = GETDATE()

        PRINT'=======================================';
        PRINT'Loading Bronze Layer is Completed'
        PRINT'  - Total Load Duration: ' + CAST(DATEDIFF(SECOND,@batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT'=======================================';


    END TRY
    BEGIN CATCH
        PRINT '====================================================================';
        PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
        PRINT 'Error Message' + ERROR_MESSAGE();
        PRINT '=Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
        PRINT '=Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
        PRINT '====================================================================';
    END CATCH

END
