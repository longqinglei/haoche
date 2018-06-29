CREATE TABLE IF NOT EXISTS "story" (
"id" INTEGER PRIMARY KEY AutoIncrement,
"title" TEXT,
"desc" TEXT,
"img_url" TEXT,
"publish_time" INTEGER NOT NULL DEFAULT 0
)