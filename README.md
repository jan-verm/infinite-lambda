# Infinite lambda - Analytics Engineering Project

This project was developed as part of the **Infinite Lambda Analytics Engineering interview assessment**.

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
- Cast data types
- Remove source inconsistencies

Models:

| Model | Description |
|---|---|
| `stg__sales` | Latest monthly sales snapshot per pharmacy/product, wide-format (`v1`-`v30`) |
| `stg__product_info` | Deduplicated product reference data, latest record per pharmacy/product |
| `stg__stock_levels` | Deduplicated stock-on-hand data, latest record per pharmacy/product |

### Intermediate Layer

Purpose:

- Apply reusable business logic
- Perform complex joins
- Prepare datasets for final marts

Models:

| Model | Description |
|---|---|
| `int__sales_month_numbering` | Translation for bespoke month numbering |
| `int__sales_monthly` | Wide-to-long unpivot of `stg__sales` into one row per pharmacy/product/month, zero-filled for months with no sales |
| `int__sales_rolling_avg` | Trailing 6-month rolling average of sales per pharmacy/product/month |
| `int__stock_on_hand` | Current in-stock quantity per pharmacy/product, excluding zero/negative stock |

### Mart Layer

Purpose:

- Create analytics-ready models consumed by BI tools.

Models:

| Model | Description |
|---|---|
| `sales_monthly` | Monthly sales per product for each pharmacy |
| `stock_levels` | Current stock level per product |
| `product_info` | Product information and identifiers |
| `stock_rotation_monthly` | Monthly rotation per product, combining sales velocity and stock on hand to estimate runway |

`stock_rotation_monthly` is the table that answers the business question stated in the introduction — it joins trailing sales velocity (`int__sales_rolling_avg`) against current stock on hand (`int__stock_on_hand`) and exposes a `runway` column (stock / average monthly sales) per pharmacy/product.

# Documentation & Lineage

The dbt docs site (model descriptions, column tests, and the full lineage graph) is generated on demand, not committed:

```
dbt docs generate
dbt docs serve
```

This opens a local site with an interactive DAG showing how raw sources flow through staging → intermediate → mart into `stock_rotation_monthly`.
