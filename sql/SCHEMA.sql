CREATE TABLE IF NOT EXISTS chain_supplies (
date DATE,
sku_id TEXT,
warehouse_id TEXT,
supplier_id TEXT,
region TEXT,
units_sold INT,
inventory_level INT,
supplier_lead_time_days INT,
reorder_point INT,
order_quantity INT,
Unit_Cost DECIMAL,
Unit_Price DECIMAL,
Promotion_Flag INT,
Stockout_Flag INT,
Demand_Forecast DECIMAL
);
