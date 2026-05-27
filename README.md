# 🚴 SQL Bike Sales Analytics

End-to-end sales analysis on a 60,000+ record bicycle dataset using **PostgreSQL** — from schema setup through advanced business intelligence queries.

---

## 📁 Files

| File | Description |
|---|---|
| `00_creating_and_populating_tables.sql` | Schema creation & data loading |
| `01_eda.sql` | Exploratory data analysis |
| `02_advanced_analytics.sql` | Advanced business analysis |

---

## 🔍 What's Inside

**EDA** — database exploration, date boundaries, customer demographics, revenue by category, top/bottom product rankings using `ROW_NUMBER()`

**Advanced Analytics** — yearly & monthly sales trends, running totals, moving average price, year-over-year product performance with `LAG()`, category contribution %, and product cost segmentation

---

## 💡 Key Findings

- **Bikes dominate revenue** — the Bikes category alone accounts for **96.46% of total revenue ($28.3M)**, with Accessories and Clothing making up the remainder
- **Road Bikes lead subcategories** at **$14.5M**, followed by Mountain Bikes ($9.9M) and Touring Bikes ($3.8M) — Road Bikes alone represent over half of all sales
- **Top product:** Mountain-200 Black, 46 is the single highest-selling product across the entire catalog
- **Strong seasonality** — sales peak in **December** and hit their lowest point in **February**, suggesting clear holiday-driven demand and a post-holiday slump
- **Accessories underperform** — Tires & Tubes ($244K) and Helmets ($225K) show significant revenue gaps compared to bike subcategories, indicating potential upsell opportunity

---

## 🧠 Key SQL Concepts

`CTEs` · `Window Functions` · `LAG()` · `ROW_NUMBER()` · `DATE_TRUNC()` · `CASE WHEN` · `Aggregations` · `JOINs`

---

## 🛠️ Tools

PostgreSQL · pgAdmin

---
