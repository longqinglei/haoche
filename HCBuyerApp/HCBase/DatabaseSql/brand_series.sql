CREATE TABLE IF NOT EXISTS "brand_series" (
"id" INTEGER PRIMARY KEY AutoIncrement,
"city_id" INTEGER DEFAULT 0,
"brand_id" INTEGER DEFAULT 0,
"brand_name" TEXT,
"first_letter" TEXT,
"series_group" TEXT,
"is_hot" INTEGER DEFAULT 0
)