/*
======================================================================================
Create Database and Schemas
======================================================================================

Script Purpose:
This script creates a new database named 'DataWarehouse'.
Sets up three schemas within the database: 'bronze', 'silver', and 'gold'.

*/



-- Create the 'DataWarehouse' database

CREATE DATABASE DataWarehouse;

USE DataWarehouse;


-- Create Schemas

CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
