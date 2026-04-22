# 📊 Analysis Summary

This section explains the analytical logic, SQL approach, and business insights derived from the dataset.

The analysis is performed directly on raw transactional data, focusing on **SKU-level operational performance**.

---

# 1. Inventory Turnover

## 📝 Objective
Measure how efficiently inventory is utilized by each SKU.

## ⚙️ Logic
- Aggregate total units sold per SKU  
- Compute average inventory level  
- Calculate turnover ratio:

Turnover = Total Units Sold ÷ Average Inventory

## 📊 Insight

- High turnover → efficient, fast-moving products  
- Low turnover → slow-moving or overstocked items  

This metric helps identify where inventory is being used effectively versus where capital may be tied up unnecessarily.

---

# 2. Stockout Rate

## 📝 Objective
Evaluate how often products are unavailable.

## ⚠️ Note
The dataset does not contain stockout events (`stockout_flag = 1`), therefore this metric does not produce meaningful results.

## 📊 Insight

Since stockouts are not observed, the analysis shifts toward **inventory risk** to estimate potential availability issues.

---

# 3. Price vs Demand (Elasticity Proxy)

## 📝 Objective
Analyze the relationship between pricing and demand.

## ⚙️ Logic
- Compute average price per SKU  
- Compute average units sold  
- Compare both metrics

## 📊 Insight

- Lower price with higher demand → price-sensitive products  
- Higher price with stable demand → strong products  
- Mixed patterns indicate varying demand behavior  

This is a **proxy analysis**, not a causal elasticity model.

---

# 4. Inventory Risk (Days of Inventory)

## 📝 Objective
Estimate how long inventory will last based on demand.

## ⚙️ Logic

Days of Inventory = Average Inventory ÷ Average Units Sold

## 📊 Insight

- High values → overstock risk  
- Low values → potential stockout risk  

This metric is critical for balancing:
- service levels  
- inventory costs  

---

# 5. Demand Trends Over Time

## 📝 Objective
Analyze how demand evolves over time.

## ⚙️ Logic
- Aggregate total units sold by month  
- Identify patterns and trends

## 📊 Insight

- Highlights demand fluctuations  
- Helps detect trends or seasonality  
- Supports planning and forecasting decisions  

---

# 🧠 Overall Insights

- Inventory efficiency varies significantly across SKUs  
- Some products show strong demand but insufficient inventory coverage  
- Others indicate excess stock with low turnover  
- Pricing plays a role in demand behavior, though not uniformly  
- Time-based trends provide additional operational context  

---

# 📌 Final Note

The analysis demonstrates how to extract meaningful insights from **limited and unstructured data**, focusing on operational metrics rather than relying on predefined business dimensions.

This reflects a realistic data scenario where analysts must work with imperfect datasets and still produce valuable conclusions.
