# Infinite lambda - Analytics Engineering Project

This project was developed as part of the **Infinite Lambda Analytics Engineering Technical Progression Framework (AE - TPF) technical interview assessment**.

The goal of the project is to demonstrate an end-to-end analytics engineering solution, covering the full data lifecycle from raw data ingestion through transformation, governance, and business insights.

The objective of this project is to build an analytics solution that helps the business understand **sales performance in relation to available inventory levels**. The main business question being addressed is: **"Based on current sales velocity, how much stock runway do we have before inventory needs to be replenished?"**

The solution combines historical sales data with inventory information to calculate monthly sales trends, stock consumption rates, and estimated inventory runway. These insights enable better supply planning, reduce the risk of stockouts, and support data-driven inventory decisions.

The project demonstrates an end-to-end analytics engineering workflow, including data modeling, dbt transformations, incremental processing, data quality validation, and the creation of analytics-ready models consumed by BI dashboards.

The focus is not only on producing business metrics, but also on demonstrating the engineering decisions, trade-offs, and best practices required to build a scalable and maintainable data solution.

# Overview

This repository contains the dbt transformation layer for an end-to-end analytics solution designed to generate business metrics from raw source data.

The project demonstrates modern analytics engineering practices:

- Layered data modeling
- Modular dbt transformations
- Data quality testing
- Documentation and lineage
- CI/CD deployment workflow

# Architecture Overview

The solution follows a layered warehouse architecture:

```
Source Systems
    |
    v
Raw Data Layer
    |
    v
Staging Models
    |
    v
Intermediate Models
    |
    v
Mart Models
    |
    v
BI Dashboard
```

## Technology Stack

| Component | Technology |
|---|---|
| Transformation | dbt Core |
| Data Warehouse | BigQuery |
| BI Layer | Metabase |
| Version Control | Git |
| CI/CD | GitHub Actions |

# Repository Structure

```
.
├── models
│ ├── staging
│ │
│ ├── intermediate
│ │
│ └── mart
│
├── tests
├── macros
├── seeds
├── snapshots
├── analyses
├── dbt_project.yml
└── README.md
```

# Data Modeling Approach

The project uses a **dimensional modeling approach** with clear separation between technical transformation layers and business-facing models.

### Staging Layer

Purpose:

- Clean raw source data
- Standardize column names
- Cast data types
- Remove source inconsistencies

Example:


raw_orders
|
v
stg_orders

### Intermediate Layer

Purpose:

- Apply reusable business logic
- Perform complex joins
- Prepare datasets for final marts

Example:


stg_orders
+
stg_customers
|
v
int_customer_orders

### Mart Layer

Purpose:

Create analytics-ready models consumed by BI tools.

Examples:


dim_customer
dim_product
fct_sales
