-- This is auto-generated code
SELECT
     *
FROM
    OPENROWSET(
        BULK 'https://olistdatastoragetaf.dfs.core.windows.net/olistdata/silver/transformed_data/',
        FORMAT = 'PARQUET'
    ) AS result1

create schema gold

create view gold.final
AS
SELECT
     *
FROM
    OPENROWSET(
        BULK 'https://olistdatastoragetaf.dfs.core.windows.net/olistdata/silver/transformed_data/',
        FORMAT = 'PARQUET'
    ) AS result1

select * from gold.final


create view gold.order_status_deli
AS
SELECT
     *
FROM
    OPENROWSET(
        BULK 'https://olistdatastoragetaf.dfs.core.windows.net/olistdata/silver/transformed_data/',
        FORMAT = 'PARQUET'
    ) AS result1
where order_status like 'delivered'

SELECT * from gold.order_status_deli

Create master key encryption by password = 'Tafnaz@14'
CREATE DATABASE SCOPED CREDENTIAL tafnazadmin WITH IDENTITY = 'Managed Identity'
CREATE EXTERNAL FILE FORMAT extfileformat WITH (
    FORMAT_TYPE = PARQUET,
    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
)
CREATE EXTERNAL DATA SOURCE gold_layer WITH (
    LOCATION = 'https://olistdatastoragetaf.dfs.core.windows.net/olistdata/gold/',
    CREDENTIAL = tafnazadmin
)
CREATE EXTERNAL TABLE gold.finaltable WITH (
        LOCATION = 'Serving',
        DATA_SOURCE = gold_layer,
        FILE_FORMAT = extfileformat
) AS
SELECT * FROM gold.order_status_deli;
select * from gold.finaltable