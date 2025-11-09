# End-to-End Data Engineering Project (Azure + Databricks + Synapse)

This is a complete **Modern Data Engineering Pipeline** that moves data from multiple sources (Filess.io SQL DB and MongoDB) into Azure Data Lake, performs transformations using Databricks, and exposes cleaned data through Synapse Serverless SQL.

---

## Project Overview

| Layer         | Purpose                                       | Service Used                 |
| ------------- | --------------------------------------------- | ---------------------------- |
|  **Bronze** | Raw data ingestion (MongoDB, SQL DB)          | Azure Data Lake Gen2         |
|  **Silver**  | Data cleaning, transformations, deduplication | Azure Databricks (PySpark)   |
|  **Gold**   | Final curated dataset for analytics           | Azure Synapse Serverless SQL |

---

## Architecture Diagram

```
MongoDB / Filess.io SQL DB → Azure Data Lake (Bronze) → Databricks (Silver) → Synapse Serverless SQL (Gold)
                                               ↓
                                          GitHub Version Control
```

---

## Repository Structure

```
Data-Engineering-Project/
│
├── data/                               # raw data files
├── Data.json                           # example JSON data used in ingestion
├── DataIngestion.ipynb                 # Bronze ingestion pipeline (Databricks)
├── databircks code transformation.ipynb # Silver transformation pipeline
├── mongodbdataingestion.ipynb          # MongoDB to ADLS ingestion
├── SQL on olistdata.sql                # Synapse Gold Layer SQL
└── README.md
```

---

## Technologies Used

| Category         | Tool / Service                    |
| ---------------- | --------------------------------- |
| Cloud Storage    | **Azure Data Lake Gen2 (ADLS)**   |
| Data Processing  | **Azure Databricks (PySpark)**    |
| Query Engine     | **Azure Synapse Serverless SQL**  |
| Source Databases | **MongoDB**, **Filess.io SQL DB** |
| Version Control  | **GitHub**                        |

---

## Pipeline Steps

### **1. MongoDB / Filess.io → Bronze Layer (Raw Ingestion)**

Notebook: `mongodbdataingestion.ipynb` and `DataIngestion.ipynb`

* Pull data from MongoDB collection using PySpark + MongoDB connector
* Pull data from Filess.io SQL DB
* Store raw data on **Azure Data Lake (Bronze Layer)**

> Data stored exactly as-is, no transformation.

---

### **2. Bronze → Silver (Transformations in Databricks)**

Notebook: `databircks code transformation.ipynb`

Applied transformations:

* Drop null rows
* Remove duplicates
* Standardize schemas (data types, renaming columns)
* Join datasets where necessary

> Output saved as **Parquet files** to the Silver layer.

---

### **3. Silver → Gold (Synapse Analytics)**

File: `SQL on olistdata.sql`

Steps performed in Synapse:

1. Configured external data source (ADLS Gold folder)
2. Created External Tables by pointing to Silver Parquet files

Example:

```sql
CREATE EXTERNAL TABLE gold.cleaned_orders
WITH (
    LOCATION = 'gold/orders/',
    DATA_SOURCE = OlistGoldStorage
)
AS SELECT * FROM silver.orders;
```

> Final dataset is now queryable using **T-SQL** from Synapse Studio.
