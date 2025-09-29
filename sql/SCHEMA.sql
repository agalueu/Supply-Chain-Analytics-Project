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

CREATE TABLE IF NOT EXISTS products (
sku_id TEXT PRIMARY KEY,
product_name TEXT,
category TEXT,
brand TEXT,
cost DECIMAL,
price DECIMAL
);

CREATE TABLE IF NOT EXISTS suppliers (
supplier_id TEXT PRIMARY KEY,
supplier_name TEXT,
region TEXT,
supplier_lead_time_days INT,
reliability_score INT
);

CREATE TABLE IF NOT EXISTS warehouses (
warehouse_id TEXT PRIMARY KEY,
location TEXT,
region TEXT,
capacity INT
);

CREATE TABLE IF NOT EXISTS fact_chain_supplies (
date DATE,
sku_id TEXT REFERENCES products (sku_id),
warehouse_id TEXT REFERENCES warehouses (warehouse_id),
supplier_id TEXT REFERENCES suppliers (supplier_id),
units_sold INT,
inventory_level INT,
reorder_point INT,
order_quantity INT,
promotion_flag INT,
stockout_flag INT,
demand_forecast DECIMAL
);

CREATE TABLE IF NOT EXISTS fact_product_prices (
fact_id SERIAL PRIMARY KEY,
sku_id TEXT REFERENCES products (sku_id),
date DATE,
unit_cost DECIMAL,
unit_price DECIMAL
);

-- Insert all 50 SKUs with distinct brands
INSERT INTO products (sku_id, product_name, category, brand, cost, price)
SELECT 
    sku_id,
    'Product ' || sku_id AS product_name,
    CASE
        WHEN sku_id::text LIKE 'SKU_[1-10]' THEN 'Electronics'
        WHEN sku_id::text LIKE 'SKU_[11-20]' THEN 'Accessories'
        WHEN sku_id::text LIKE 'SKU_[21-30]' THEN 'Furniture'
        WHEN sku_id::text LIKE 'SKU_[31-40]' THEN 'Appliances'
        ELSE 'Misc'
    END AS category,
    CASE
        WHEN sku_id::text LIKE 'SKU_[1]' THEN 'TechPro'
        WHEN sku_id::text LIKE 'SKU_[2]' THEN 'MobileOne'
        WHEN sku_id::text LIKE 'SKU_[3]' THEN 'VisionTek'
        WHEN sku_id::text LIKE 'SKU_[4]' THEN 'PrintIt'
        WHEN sku_id::text LIKE 'SKU_[5]' THEN 'TechPro'
        WHEN sku_id::text LIKE 'SKU_[6]' THEN 'MobileOne'
        WHEN sku_id::text LIKE 'SKU_[7]' THEN 'VisionTek'
        WHEN sku_id::text LIKE 'SKU_[8]' THEN 'PrintIt'
        WHEN sku_id::text LIKE 'SKU_[9]' THEN 'TechPro'
        WHEN sku_id::text LIKE 'SKU_[10]' THEN 'MobileOne'
        WHEN sku_id::text LIKE 'SKU_[11-15]' THEN 'SoundMax'
        WHEN sku_id::text LIKE 'SKU_[16-20]' THEN 'GearMax'
        WHEN sku_id::text LIKE 'SKU_[21-25]' THEN 'ComfyCo'
        WHEN sku_id::text LIKE 'SKU_[26-30]' THEN 'WorkFlex'
        WHEN sku_id::text LIKE 'SKU_[31-35]' THEN 'BrewCo'
        WHEN sku_id::text LIKE 'SKU_[36-40]' THEN 'PureAir'
        ELSE 'GenericBrand'
    END AS brand,
    10 + (ABS(MOD(hashtext(sku_id), 1000)) / 10) AS cost,
    20 + (ABS(MOD(hashtext(sku_id), 1500)) / 10) AS price
FROM chain_supplies c
WHERE sku_id NOT IN (SELECT sku_id FROM products)
GROUP BY sku_id;



-- Insert missing suppliers into suppliers
INSERT INTO suppliers (supplier_id, supplier_name, region, supplier_lead_time_days, reliability_score)
SELECT 
    supplier_id,
    '%Supplier ' || supplier_id AS supplier_name,
    CASE
        WHEN supplier_id::text LIKE 'SUP_[1-3]' THEN 'East'
        WHEN supplier_id::text LIKE 'SUP_[4-6]' THEN 'West'
        WHEN supplier_id::text LIKE 'SUP_[7-8]' THEN 'North'
        ELSE 'South'
    END AS region,
    10 + (ABS(MOD(hashtext(supplier_id), 10))) AS supplier_lead_time_days,
    70 + (ABS(MOD(hashtext(supplier_id), 31))) AS reliability_score
FROM chain_supplies c
WHERE supplier_id NOT IN (SELECT supplier_id FROM suppliers)
GROUP BY supplier_id;


-- Insert missing warehouses into warehouses
INSERT INTO warehouses (warehouse_id, location, region, capacity)
SELECT 
    warehouse_id,
    'City ' || warehouse_id AS location,
    CASE
        WHEN warehouse_id::text LIKE 'WH_[1-2]' THEN 'East'
        WHEN warehouse_id::text LIKE 'WH_[3-4]' THEN 'West'
        ELSE 'North'
    END AS region,
    30000 + (ABS(MOD(hashtext(warehouse_id), 40000))) AS capacity
FROM chain_supplies c
WHERE warehouse_id NOT IN (SELECT warehouse_id FROM warehouses)
GROUP BY warehouse_id;


INSERT INTO fact_chain_supplies (
    date,
    sku_id,
    warehouse_id,
    supplier_id,
    units_sold,
    inventory_level,
    reorder_point,
    order_quantity,
    promotion_flag,
    stockout_flag,
    demand_forecast
)
SELECT
    date,
    sku_id,
    warehouse_id,
    supplier_id,
    units_sold,
    inventory_level,
    reorder_point,
    order_quantity,
    promotion_flag,
    stockout_flag,
    demand_forecast
FROM chain_supplies;

INSERT INTO fact_product_prices (sku_id, date, unit_cost, unit_price)
SELECT DISTINCT sku_id, date, unit_cost, unit_price
FROM chain_supplies;

UPDATE products
SET 
    category = CASE
        WHEN CAST(SUBSTRING(sku_id FROM 5) AS INT) BETWEEN 1 AND 10 THEN 'Electronics'
        WHEN CAST(SUBSTRING(sku_id FROM 5) AS INT) BETWEEN 11 AND 20 THEN 'Accessories'
        WHEN CAST(SUBSTRING(sku_id FROM 5) AS INT) BETWEEN 21 AND 30 THEN 'Furniture'
        WHEN CAST(SUBSTRING(sku_id FROM 5) AS INT) BETWEEN 31 AND 40 THEN 'Appliances'
        ELSE 'Misc'
    END,
    brand = CASE
        WHEN CAST(SUBSTRING(sku_id FROM 5) AS INT) BETWEEN 1 AND 10 THEN 'TechPro'
        WHEN CAST(SUBSTRING(sku_id FROM 5) AS INT) BETWEEN 11 AND 20 THEN 'GearMax'
        WHEN CAST(SUBSTRING(sku_id FROM 5) AS INT) BETWEEN 21 AND 30 THEN 'ComfyCo'
        WHEN CAST(SUBSTRING(sku_id FROM 5) AS INT) BETWEEN 31 AND 40 THEN 'BrewCo'
        ELSE 'GenericBrand'
    END
WHERE sku_id IN (SELECT DISTINCT sku_id FROM chain_supplies);

UPDATE suppliers
SET region = CASE 
    WHEN supplier_id IN ('SUP_1', 'SUP_2', 'SUP_3') THEN 'North'
    WHEN supplier_id IN ('SUP_4', 'SUP_5') THEN 'South'
    WHEN supplier_id IN ('SUP_6', 'SUP_7') THEN 'East'
    ELSE 'West'
END;

UPDATE warehouses
SET region = CASE 
    WHEN warehouse_id IN ('WH_1', 'WH_2') THEN 'North'
    WHEN warehouse_id IN ('WH_3', 'WH_4') THEN 'South'
    WHEN warehouse_id IN ('WH_5', 'WH_6') THEN 'East'
    ELSE 'West'
END;
