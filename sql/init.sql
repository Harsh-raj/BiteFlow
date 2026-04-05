-- 1. STAGING LAYER (Raw Data Ingestion)
CREATE TABLE IF NOT EXISTS staging_orders (
    raw_data JSONB,
    ingested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. DIMENSION LAYER (Contextual Data)
CREATE TABLE IF NOT EXISTS dim_restaurants (
    restaurant_id INT PRIMARY KEY,
    name VARCHAR(255),
    cuisine VARCHAR(100),
    city VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS dim_users (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(255),
    membership_level VARCHAR(50) -- e.g., 'Free', 'Premium'
);

-- Essential for Time-Series analysis in Warehousing
CREATE TABLE IF NOT EXISTS dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE,
    day_of_week VARCHAR(15),
    is_weekend BOOLEAN
);

-- 3. FACT LAYER (Metrics/Actions)
CREATE TABLE IF NOT EXISTS fact_orders (
    order_id UUID PRIMARY KEY,
    user_id INT REFERENCES dim_users(user_id),
    restaurant_id INT REFERENCES dim_restaurants(restaurant_id),
    date_key INT REFERENCES dim_date(date_key),
    order_amount DECIMAL(10, 2),
    status VARCHAR(50),
    order_timestamp TIMESTAMP
);

-- 4. PERFORMANCE LAYER (Aggregated Reporting)
-- This table mimics a "Production" aggregate table for fast dashboards
CREATE TABLE IF NOT EXISTS perf_daily_restaurant_revenue (
    restaurant_id INT,
    date_key INT,
    total_revenue DECIMAL(15, 2),
    total_orders INT,
    PRIMARY KEY (restaurant_id, date_key)
);

-- 5. SEED DATA (Master Data for Dimensions)

-- Populate Restaurants
INSERT INTO dim_restaurants (restaurant_id, name, cuisine, city) VALUES
(1, 'Pizza Palace', 'Italian', 'New York'),
(2, 'Sushi Samurai', 'Japanese', 'San Francisco'),
(3, 'Burger Baron', 'American', 'Chicago'),
(4, 'Taco Temple', 'Mexican', 'Austin'),
(5, 'Curry Kingdom', 'Indian', 'Seattle')
ON CONFLICT (restaurant_id) DO NOTHING;

-- Populate Users
INSERT INTO dim_users (user_id, user_name, membership_level) VALUES
(101, 'Alice Johnson', 'Premium'),
(102, 'Bob Smith', 'Free'),
(103, 'Charlie Brown', 'Free'),
(104, 'Diana Prince', 'Premium')
ON CONFLICT (user_id) DO NOTHING;

-- Populate Date Dimension (Small sample for testing)
INSERT INTO dim_date (date_key, full_date, day_of_week, is_weekend) VALUES
(20260401, '2026-04-01', 'Wednesday', FALSE),
(20260402, '2026-04-02', 'Thursday', FALSE),
(20260403, '2026-04-03', 'Friday', FALSE),
(20260404, '2026-04-04', 'Saturday', TRUE),
(20260405, '2026-04-05', 'Sunday', TRUE),
(20260406, '2026-04-06', 'Monday', FALSE)
ON CONFLICT (date_key) DO NOTHING;