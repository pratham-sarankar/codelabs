author: Pratham Sarankar
summary: Learn what Snowflake Virtual Warehouses are, how to create and configure them, how to import data into Snowflake, and how to run SQL queries
id: krct-snowflake-warehouses-and-queries
categories: Snowflake,Data Warehouse,SQL,Cloud Data
environments: Web
status: Draft
feedback link: https://github.com/pratham-sarankar/codelabs/issues

# Snowflake: Warehouses, Data Import & Queries

## Overview

**Snowflake** is a cloud-based data platform that separates storage from compute, allowing you to scale each independently. At the heart of Snowflake's compute layer is the **Virtual Warehouse** — the engine that powers all your queries and data loading.

In this codelab, you will learn how to:
- Understand what a Snowflake Virtual Warehouse is
- Create and configure a warehouse using the Snowsight UI
- Create a database, schema, and table
- Import data into Snowflake from a CSV file
- Run SQL queries against your data

---

## Prerequisites

Before starting, make sure you have:
- A Snowflake account (free 30-day trial at [trial.snowflake.com](https://trial.snowflake.com))
- A modern web browser (Chrome or Firefox recommended)
- Basic familiarity with SQL (SELECT, WHERE, GROUP BY)

---

## Step 1: Understanding Snowflake Architecture

Snowflake has three layers that work independently:

| Layer | What it does |
|---|---|
| **Storage** | Stores all your data (compressed, columnar format in cloud object storage) |
| **Compute** | Virtual Warehouses — process queries and load data |
| **Cloud Services** | Authentication, metadata, query optimization |

### What is a Virtual Warehouse?

A **Virtual Warehouse** is a cluster of compute nodes that executes SQL statements.

Key facts about Virtual Warehouses:
- They are **separate from storage** — data is not deleted when a warehouse is suspended
- They can be **suspended and resumed** on demand — you only pay when they are running
- Multiple warehouses can query the **same data** at the same time without contention
- They come in sizes from `X-SMALL` (1 credit/hour) up to `6X-LARGE` (512 credits/hour)

### Warehouse Sizes and Credits

| Size | Credits per Hour | Use Case |
|---|---|---|
| X-SMALL | 1 | Learning, dev, small queries |
| SMALL | 2 | Small teams, daily reports |
| MEDIUM | 4 | Mid-size datasets, concurrent users |
| LARGE | 8 | Large datasets, heavy ETL |
| X-LARGE | 16 | Very large workloads |

> **Cost tip:** Always start with `X-SMALL` and scale up only if queries are too slow.

---

## Step 2: Log In to Snowsight

1. Open your browser and go to your Snowflake account URL  
   (e.g., `https://app.snowflake.com`)
2. Enter your **username** and **password**
3. You will land on the **Snowsight** dashboard — the modern Snowflake web interface

You will see the left sidebar with:
- **Worksheets** — where you write and run SQL
- **Databases** — your data objects
- **Data** — marketplace and data sharing
- **Compute** — warehouses and resource monitors
- **Admin** — account settings

---

## Step 3: Create a Virtual Warehouse

Let's create a warehouse you will use for the rest of this codelab.

### Using the Snowsight UI

1. In the left sidebar, click **Admin → Warehouses**
2. Click the **+ Warehouse** button (top right)
3. Fill in the form:

| Field | Value |
|---|---|
| Name | `TRAINING_WH` |
| Size | `X-Small` |
| Auto Suspend | `5 minutes` |
| Auto Resume | `Enabled` |

4. Click **Create Warehouse**

Your warehouse is now created and **running**. You will see its status change to **Started**.

### Using SQL

You can also create a warehouse with SQL. Open a **Worksheet** and run:

```sql
CREATE WAREHOUSE IF NOT EXISTS TRAINING_WH
  WAREHOUSE_SIZE = 'X-SMALL'
  AUTO_SUSPEND = 300
  AUTO_RESUME = TRUE
  COMMENT = 'Warehouse for training exercises';
```

### Key Parameters Explained

- **AUTO_SUSPEND = 300** — suspends the warehouse after 300 seconds (5 min) of inactivity to save credits
- **AUTO_RESUME = TRUE** — automatically resumes the warehouse when a query is submitted
- **WAREHOUSE_SIZE** — determines the compute power (and cost per hour)

---

## Step 4: Create a Database and Schema

Data in Snowflake is organized in a three-level hierarchy:

```
Account
 └── Database
      └── Schema
           └── Table / View / Stage
```

### Create a Database

In a Worksheet, run:

```sql
CREATE DATABASE IF NOT EXISTS TRAINING_DB;
```

### Create a Schema

```sql
CREATE SCHEMA IF NOT EXISTS TRAINING_DB.SALES;
```

### Set the Context

Tell Snowflake which database and schema to use by default:

```sql
USE DATABASE TRAINING_DB;
USE SCHEMA SALES;
USE WAREHOUSE TRAINING_WH;
```

> Setting the context saves you from writing the full path (`TRAINING_DB.SALES.table_name`) in every query.

---

## Step 5: Create a Table

Let's create a table to hold sales order data.

```sql
CREATE TABLE IF NOT EXISTS ORDERS (
    ORDER_ID        INT,
    ORDER_DATE      DATE,
    CUSTOMER_NAME   VARCHAR(100),
    PRODUCT         VARCHAR(100),
    QUANTITY        INT,
    UNIT_PRICE      DECIMAL(10, 2),
    TOTAL_AMOUNT    DECIMAL(10, 2),
    REGION          VARCHAR(50)
);
```

Verify the table was created:

```sql
SHOW TABLES IN SCHEMA TRAINING_DB.SALES;
```

---

## Step 6: Prepare Sample Data

We will load data from a CSV file. Create a file named `orders.csv` on your local machine with the following content:

```
ORDER_ID,ORDER_DATE,CUSTOMER_NAME,PRODUCT,QUANTITY,UNIT_PRICE,TOTAL_AMOUNT,REGION
1001,2024-01-05,Alice Johnson,Laptop,2,999.99,1999.98,North
1002,2024-01-07,Bob Smith,Mouse,5,29.99,149.95,South
1003,2024-01-10,Carol White,Keyboard,3,79.99,239.97,East
1004,2024-01-12,David Brown,Monitor,1,349.99,349.99,West
1005,2024-01-15,Eve Davis,Laptop,1,999.99,999.99,North
1006,2024-01-18,Frank Miller,Headphones,4,59.99,239.96,South
1007,2024-01-20,Grace Wilson,Mouse,10,29.99,299.90,East
1008,2024-01-22,Henry Moore,Keyboard,2,79.99,159.98,West
1009,2024-01-25,Irene Taylor,Monitor,3,349.99,1049.97,North
1010,2024-01-28,James Anderson,Headphones,6,59.99,359.94,South
```

Save this file — you will upload it in the next step.

---

## Step 7: Import Data into Snowflake

Snowflake uses **Stages** as temporary storage locations for files before loading them into tables.

There are two types of stages:
- **Internal Stage** — managed by Snowflake (inside Snowflake)
- **External Stage** — points to cloud storage (S3, Azure Blob, GCS)

We will use an **internal stage** for simplicity.

### Step 7a: Create an Internal Stage

```sql
CREATE STAGE IF NOT EXISTS TRAINING_DB.SALES.MY_STAGE
  FILE_FORMAT = (TYPE = CSV FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1);
```

### Step 7b: Upload the CSV File

#### Using Snowsight UI

1. In the left sidebar, go to **Data → Databases**
2. Navigate to `TRAINING_DB → SALES → Stages → MY_STAGE`
3. Click the **+ Files** button
4. Upload your `orders.csv` file

#### Using SnowSQL (CLI)

If you have SnowSQL installed, run this in your terminal:

```bash
PUT file:///path/to/orders.csv @TRAINING_DB.SALES.MY_STAGE;
```

### Step 7c: Verify the File is in the Stage

```sql
LIST @TRAINING_DB.SALES.MY_STAGE;
```

You should see `orders.csv` listed with its size and last modified date.

### Step 7d: Load Data with COPY INTO

Now load the data from the stage into the `ORDERS` table:

```sql
COPY INTO TRAINING_DB.SALES.ORDERS
FROM @TRAINING_DB.SALES.MY_STAGE/orders.csv
FILE_FORMAT = (TYPE = CSV FIELD_OPTIONALLY_ENCLOSED_BY = '"' SKIP_HEADER = 1)
ON_ERROR = 'CONTINUE';
```

- **ON_ERROR = 'CONTINUE'** — skips bad rows instead of failing the entire load
- **SKIP_HEADER = 1** — skips the first row (the header row)

You should see output like:

```
file                         status    rows_loaded    errors_seen
orders.csv                   LOADED    10             0
```

---

## Step 8: Verify Loaded Data

Confirm all rows were loaded correctly:

```sql
SELECT * FROM ORDERS;
```

Check the row count:

```sql
SELECT COUNT(*) AS total_rows FROM ORDERS;
```

You should see **10 rows**.

---

## Step 9: Run Queries

Now let's explore the data using SQL queries.

### Basic SELECT

```sql
-- Get all orders from the North region
SELECT * FROM ORDERS
WHERE REGION = 'North';
```

### Filter and Sort

```sql
-- Orders with total amount greater than $500, sorted by date
SELECT ORDER_ID, ORDER_DATE, CUSTOMER_NAME, TOTAL_AMOUNT
FROM ORDERS
WHERE TOTAL_AMOUNT > 500
ORDER BY TOTAL_AMOUNT DESC;
```

### Aggregate: Total Sales by Region

```sql
SELECT
    REGION,
    COUNT(ORDER_ID)         AS total_orders,
    SUM(TOTAL_AMOUNT)       AS total_revenue,
    AVG(TOTAL_AMOUNT)       AS avg_order_value
FROM ORDERS
GROUP BY REGION
ORDER BY total_revenue DESC;
```

### Aggregate: Best-Selling Products

```sql
SELECT
    PRODUCT,
    SUM(QUANTITY)       AS total_units_sold,
    SUM(TOTAL_AMOUNT)   AS total_revenue
FROM ORDERS
GROUP BY PRODUCT
ORDER BY total_units_sold DESC;
```

### Date-Based Query

```sql
-- Orders placed in January 2024
SELECT *
FROM ORDERS
WHERE ORDER_DATE BETWEEN '2024-01-01' AND '2024-01-31'
ORDER BY ORDER_DATE;
```

### Top Customers

```sql
SELECT
    CUSTOMER_NAME,
    SUM(TOTAL_AMOUNT) AS lifetime_value
FROM ORDERS
GROUP BY CUSTOMER_NAME
ORDER BY lifetime_value DESC
LIMIT 5;
```

---

## Step 10: Manage Your Warehouse

### Check Warehouse Status

```sql
SHOW WAREHOUSES;
```

### Suspend the Warehouse Manually

To stop billing when you are done:

```sql
ALTER WAREHOUSE TRAINING_WH SUSPEND;
```

### Resume the Warehouse

```sql
ALTER WAREHOUSE TRAINING_WH RESUME;
```

### Resize the Warehouse

```sql
ALTER WAREHOUSE TRAINING_WH SET WAREHOUSE_SIZE = 'SMALL';
```

> **Important:** Resize takes effect immediately for the next query. Ongoing queries continue on the old size.

### Drop the Warehouse (Cleanup)

When you no longer need the warehouse:

```sql
DROP WAREHOUSE IF EXISTS TRAINING_WH;
```

---

## Summary

In this codelab, you learned:

| Topic | What you did |
|---|---|
| **Virtual Warehouse** | Created `TRAINING_WH` with auto-suspend and auto-resume |
| **Database & Schema** | Created `TRAINING_DB` and the `SALES` schema |
| **Table** | Defined the `ORDERS` table with typed columns |
| **Data Import** | Used an internal stage and `COPY INTO` to load a CSV |
| **SQL Queries** | Ran filtering, aggregation, and date-range queries |
| **Warehouse Management** | Suspended, resumed, and resized a warehouse |

### Key Takeaways

- Warehouses are **compute only** — stopping them does not affect your data
- Always enable **AUTO_SUSPEND** to avoid unnecessary charges
- Use **Stages** as the landing zone before loading data into tables
- `COPY INTO` is the fastest and most reliable way to bulk-load data in Snowflake

---