CREATE TABLE IF NOT EXISTS "banner" (
"id" INTEGER PRIMARY KEY AutoIncrement,
"city_id" INTEGER DEFAULT 0,
"banner_img_url" TEXT,
"banner_url" TEXT
)