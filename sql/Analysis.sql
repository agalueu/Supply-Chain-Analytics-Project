--Operational Supply Chain Analysis on Raw Transactional Data

-- Top SKUs by Inventory Turnover 
SELECT  sku_id,
		SUM(units_sold) AS total_unit_sold,
		ROUND (AVG(inventory_level), 2) AS avg_inventory_level,
		ROUND (SUM(units_sold) / NULLIF(AVG(inventory_level), 0), 2) AS turnover_ratio
FROM chain_supplies
GROUP BY sku_id
ORDER BY turnover_ratio DESC
LIMIT 10;

-- Highest Stockout Rate
SELECT  sku_id,
    	COUNT(*) FILTER (WHERE stockout_flag = 1) * 1.0 / COUNT(*) AS stockout_rate
FROM chain_supplies
GROUP BY sku_id
ORDER BY stockout_rate DESC
LIMIT 10;

-- Price vs Demand (Elasticity proxy)
SELECT  sku_id,
    	ROUND(AVG(unit_price),2) AS avg_price,
    	ROUND(AVG(units_sold),2) AS avg_demand
FROM chain_supplies
GROUP BY sku_id;

--Inventory Risk (very strong business metric)
SELECT  sku_id,
    	ROUND(AVG(inventory_level), 2) AS avg_inventory,
    	ROUND(AVG(units_sold), 2) AS avg_sales,
    	ROUND(AVG(inventory_level) / NULLIF(AVG(units_sold),0), 2) AS days_of_inventory
FROM chain_supplies
GROUP BY sku_id
ORDER BY days_of_inventory DESC;

-- TRENDS
SELECT  DATE_TRUNC ('month', date)::DATE AS month,
		SUM(units_sold) AS total_unit_sold
FROM chain_supplies
GROUP BY DATE_TRUNC ('month', date);
