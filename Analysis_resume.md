In this section I´m going to talk about some results in the different queries that i did in the [Query Analysis](sql/Analysis.sql) file, what was the purpose, steps to do it and business insight for this analysis

# 1. Inventory Turnover Ratio

📝 **Query Goal**
Measure how efficiently products move through the supply chain by calculating the **inventory turnover ratio** per SKU and region.

⚙️ **Steps / Logic**

1. Aggregate total units sold and average inventory levels from `fact_chain_supplies`.
2. Calculate turnover ratio = units sold ÷ average inventory.
3. Group results by SKU and supplier region.
4. Join with `products` to show product names.

📊 **Business Insights**

* High turnover ratio → product sells quickly relative to stock (good efficiency).
* Low turnover ratio → overstock or slow-moving inventory (possible waste).
* Useful to identify which products are tying up capital in storage.

Sample: [Turnover Ratio](images/1_turnover_ratio.png)

# 2. Days of Inventory on Hand (DOH)

📝 **Query Goal**
Estimate how long current inventory will last based on sales velocity.

⚙️ **Steps / Logic**

1. Aggregate daily sales (`units_sold`) and average inventory levels.
2. Calculate DOH = average inventory ÷ daily units sold.
3. Group by product, warehouse, and day.
4. Join with `products` for product names.

📊 **Business Insights**

* Lower DOH → leaner inventory, products move faster.
* Higher DOH → excess stock, risk of obsolescence.
* Key KPI for balancing customer service with cost control.

Sample: [DOH](images/2_doh.png)

# 3. Forecast Accuracy (MAPE) vs Sales Volume

### 📝 Query Goal
Measure how accurate demand forecasts are (MAPE) for each product and region, while also capturing the average sales volume to contextualize accuracy.

### ⚙️ Steps / Logic

- Compare units_sold against demand_forecast.
- Compute MAPE = Mean Absolute Percentage Error.
- Calculate average units sold per SKU & region.
- Join with product names for readability.

### 📊 Business Insights

- Helps identify forecasting weaknesses by product/region.
- Puts forecast accuracy into perspective by linking it with sales volume.
- High MAPE in high-volume SKUs is a bigger risk than in low-volume ones.

Sample: [Forecast](images/3_mape.png)

# 4. Service Level & Stockout Rate

📝 **Query Goal**

Evaluate product availability by measuring service levels and frequency of stockouts at warehouse level.

⚙️ **Steps / Logic**

1. Identify stockout days (`stockout_flag = 1`) and count them.
2. Calculate total operational days per warehouse.
3. Compute service level = units sold ÷ demand forecast.
4. Compute stockout rate = stockout days ÷ total days.
5. Group by warehouse and date, link to regions.

📊 **Business Insights**

* High service level = orders fulfilled effectively.
* High stockout rate = poor availability, potential lost sales.
* Helps balance customer satisfaction vs. supply efficiency.

Sample: [Service level](images/4_service_stockout.png)

# 5. Supplier Reliability & Orders

📝 **Query Goal**
Assess supplier performance based on order volume, lead times, and reliability.

⚙️ **Steps / Logic**

1. Aggregate order count and total units sold by supplier.
2. Capture supplier lead time and reliability score.
3. Group results by supplier and region.

📊 **Business Insights**

* High reliability + short lead time → best partners.
* Low reliability or long lead times → supply chain risk.
* Useful for supplier scorecards and vendor negotiations.

Sample: [Reliability](images/5_reliability.png)

# 6. Profitability (by SKU & Region)

📝 **Query Goal**
Measure profitability and profit margins across products and regions.

⚙️ **Steps / Logic**

1. Join sales fact table with product prices to get unit cost and price.
2. Compute revenue (units × price), cost (units × cost), and profit (revenue – cost).
3. Calculate profit margin %.
4. Group results by SKU and region.
5. Join with `products` for product names.

📊 **Business Insights**

* Identifies most profitable SKUs and regions.
* Low margins may highlight pricing or cost issues.
* Supports product portfolio optimization.

Sample: [Profitability](images/6_profitability.png)
