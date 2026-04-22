# 📦 Supply Chain Operational Analytics

## 📌 Overview

This project analyzes a **raw transactional supply chain dataset** to evaluate operational performance at the SKU level. 

Due to the absence of descriptive product attributes (e.g., category, brand), the analysis focuses on **behavioral and operational metrics**, including inventory efficiency, demand patterns, and inventory risk.

The goal is to extract **actionable insights** directly from transactional data without relying on artificially enriched dimensions.

---

## 📊 Dataset

- Source: Synthetic Supply Chain dataset
- Structure: Single transactional table (`chain_supplies`)
- Granularity: SKU × warehouse × date

### Key Fields:
- `sku_id` → product identifier  
- `units_sold` → demand  
- `inventory_level` → stock availability  
- `unit_price`, `unit_cost` → pricing  
- `warehouse_id`, `supplier_id` → operational context  
- `demand_forecast` → planning reference  

---

## 🛠️ Tools & Technologies

- **PostgreSQL** → data storage, SQL analysis  
- **Power BI** → dashboard and visualization  
- **SQL** → KPI development and aggregation logic  
- **GitHub** → documentation and version control  

---

## ❓ Key Business Questions

1. Which SKUs move efficiently through the supply chain?
2. How does pricing relate to demand behavior?
3. Which products present overstock or understock risk?
4. How does demand evolve over time?

---

## 📂 Repository Structure
sql/ → schema and analysis queries
images/ → Power BI dashboard screenshots
README.md → project overview
analysis_resume.md → detailed explanation of queries and insights


---

## 🗄 Database Schema

The project uses a **single transactional table**:

- `chain_supplies` → contains sales, inventory, pricing, and operational data

This design reflects a **raw data scenario**, where normalization is limited due to lack of reliable dimension attributes.

---

## 📊 Analytical Approach

Instead of relying on predefined product categories, the analysis is based on **SKU-level operational metrics**:

- Inventory Turnover → efficiency of stock usage  
- Price vs Demand → demand behavior relative to pricing  
- Inventory Risk → stock coverage and planning quality  
- Time Trends → demand evolution over time  

---

## 📈 Power BI Dashboard

The dashboard focuses on operational decision-making and includes:

### 🔹 KPIs
- Total Revenue  
- Total Units Sold  
- Average Turnover Ratio  

### 🔹 Visualizations

- **Bar Chart** → Top SKUs by Inventory Turnover  
- **Scatter Plot** → Price vs Demand (behavioral analysis)  
- **Bar Chart** → Inventory Risk (Days of Inventory)  
- **Line Chart** → Demand Trends over Time  

📷 Screenshots available in the `/images` folder.

---

## ⚠️ Data Limitations

- No descriptive product attributes (category, brand)
- No observed stockout events (`stockout_flag = 1`)
- Dataset represents a simplified operational scenario

As a result:
- Analysis is performed at **SKU level**
- Inventory risk is used as a **proxy for stockout risk**

---

## ✅ Key Takeaways

- High turnover SKUs indicate efficient inventory utilization  
- Low turnover + high inventory suggests overstock and tied capital  
- Price vs demand reveals varying levels of price sensitivity  
- Inventory risk highlights potential understock and overstock scenarios  
- Time trends provide visibility into demand patterns  

---

## 🚀 Conclusion

This project demonstrates how meaningful insights can be extracted from **raw transactional data**, focusing on operational performance rather than relying on enriched or curated datasets.

It reflects a realistic scenario where analysts must **adapt to data limitations** and still deliver actionable business insights.
