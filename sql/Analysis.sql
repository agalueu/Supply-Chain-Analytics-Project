--Inventory Turnover Ratio
-- SKU = product - SUP = supplier - WH = warehouse

WITH total AS (
	SELECT  f.sku_id,
			s.region,
			SUM(f.units_sold) AS total_units_sold,
			ROUND(AVG(f.inventory_level), 2) AS average_inventory_level,
			ROUND(SUM(f.units_sold) / NULLIF(AVG(f.inventory_level), 0), 2) AS turnover_ratio
	FROM fact_chain_supplies f
	JOIN suppliers s ON f.supplier_id = s.supplier_id
	GROUP BY f.sku_id, s.region
)

SELECT  p.product_name,
		t.region,
		t.total_units_sold,
		t.average_inventory_level,
		t.turnover_ratio
FROM total t
JOIN products p ON t.sku_id = p.sku_id;

--Days of Inventory on Hand (DOH)
WITH total AS (
	SELECT  TO_CHAR(date, 'MM-DD') AS month_day,
			sku_id,
			warehouse_id,
			SUM(units_sold) AS total_units_sold,
			ROUND(AVG(inventory_level), 2) AS average_inventory_level,
			ROUND(AVG(inventory_level) / NULLIF(SUM(units_sold), 0), 2) AS DOH
	FROM fact_chain_supplies
	GROUP BY TO_CHAR(date, 'MM-DD'), sku_id, warehouse_id
	ORDER BY month_day
)

SELECT  t.month_day,
		p.product_name,
		t.warehouse_id,
		t.total_units_sold,
		t.average_inventory_level,
		t.DOH
FROM total t
JOIN products p ON t.sku_id = p.sku_id;

--Forecast Accuracy (MAPE) vs Sales Volume (MAPE = Mean Absolute Percentage Error)
WITH total AS (
    SELECT  
        f.sku_id,
        s.region,
        ROUND(AVG(ABS(f.units_sold - f.demand_forecast) / NULLIF(f.units_sold, 0)) * 100, 2) AS MAPE,
        ROUND(AVG(f.units_sold), 2) AS avg_units_sold
    FROM fact_chain_supplies f
    JOIN suppliers s ON f.supplier_id = s.supplier_id
    GROUP BY f.sku_id, s.region
)
SELECT  
    p.product_name,
    t.region,
    t.mape,
    t.avg_units_sold
FROM total t
JOIN products p ON t.sku_id = p.sku_id;


--Service level & stockout rate
WITH stockout AS (
	SELECT 	warehouse_id, COUNT(date) AS stockout_days
	FROM fact_chain_supplies
	WHERE stockout_flag = 1
	GROUP BY warehouse_id
),

total_stockout AS (
	SELECT warehouse_id, COUNT(date) AS total_days
	FROM fact_chain_supplies
	GROUP BY warehouse_id
)

SELECT  TO_CHAR(f.date, 'MM-DD') AS month_day,
		f.warehouse_id,
		w.region,
		ROUND(SUM(f.units_sold) / SUM(demand_forecast), 2) AS service_level,
		COALESCE(ROUND(MAX(s.stockout_days) / NULLIF(MAX(t.total_days), 0) * 100, 2), 0) AS stockout_rate
FROM fact_chain_supplies f
JOIN warehouses w ON f.warehouse_id = f.warehouse_id
LEFT JOIN stockout s ON w.warehouse_id = s.warehouse_id
LEFT JOIN total_stockout t ON w.warehouse_id = t.warehouse_id
GROUP BY TO_CHAR(f.date, 'MM-DD'), f.warehouse_id, w.region;

--Supplier Reliability & Orders
SELECT  f.supplier_id,
		s.region,
		COUNT(f.sku_id) AS orders,
		SUM(f.units_sold) AS total_sold,
		MAX(s.supplier_lead_time_days) AS lead_time_days,
		MAX(s.reliability_score) AS reliability_score
FROM fact_chain_supplies f
JOIN suppliers s ON f.supplier_id = s.supplier_id
GROUP BY f.supplier_id, s.region;

--Profitability (by SKU & Region)
--REVENUE, COST, MARGING (revenue-cost)
WITH data AS (
	SELECT 	f.sku_id,
			s.region,
			f.units_sold,
			fp.unit_cost,
			fp.unit_price
	FROM fact_chain_supplies f
	JOIN fact_product_prices fp ON f.sku_id = fp.sku_id
								AND f.date = fp.date
	JOIN suppliers s ON f.supplier_id = s.supplier_id
),

total AS (
	SELECT  sku_id,
			region,
			SUM(units_sold * unit_price) AS revenue,
			SUM(units_sold * unit_cost) AS cost,
			SUM(units_sold * unit_price) - SUM(units_sold * unit_cost) AS profit
	FROM data
	GROUP BY sku_id, region
)

SELECT  p.product_name,
		t.region,
		t.revenue,
		t.cost,
		t.profit,
		ROUND(t.profit/NULLIF(t.revenue, 0) * 100, 2) AS profit_margin
FROM total t
JOIN products p ON t.sku_id = p.sku_id;

