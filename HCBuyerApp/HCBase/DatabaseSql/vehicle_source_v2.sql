/* 
  vehicle_source.sql
  HCBuyerApp

  Created by wj on 14-10-20.
  Copyright (c) 2014年 haoche51. All rights reserved.
*/


CREATE TABLE IF NOT EXISTS "vehicle_source_v2" (
    "id" INTEGER PRIMARY KEY AutoIncrement,
    "vehicle_source_id" INTEGER DEFAULT 0,
    "city_id" INTEGER DEFAULT 0,
    "vehicle_name" TEXT NOT NULL,
    "register_date" INTEGER NOT NULL ,
    "geerbox_type" INTEGER NOT NULL ,
    "seller_price" FLOAT NOT NULL ,
    "miles" FLOAT NOT NULL,
    "online_time" INTEGER NOT NULL ,
    "brand_name" TEXT NOT NULL,
    "brand_id" INTEGER NOT NULL,
    "class_name" TEXT NOT NULL,
    "cut_price" FLOAT NOT NULL,
    "cheap_price" FLOAT NOT NULL,
    "quoted_price" FLOAT NOT NULL,
    "dealer_buy_price" FLOAT NOT NULL,
    "cover_img_url" TEXT,
    "seller_name" TEXT,
    "seller_sex" INTEGER DEFAULT 0,
    "seller_photo_url" TEXT,
    "seller_job_desc" TEXT,
    "seller_district" TEXT,
    "award_info" TEXT NOT NULL DEFAULT '',
    "status" INTEGER NOT NULL,
    "offline" INTEGER NOT NULL,
    "fav_status" INTEGER NOT NULL DEFAULT 0,
    "recommend_status" INTEGER NOT NULL DEFAULT 0,
    "refresh_time" INTEGER NOT NULL DEFAULT 0,
    "create_time" INTEGER NOT NULL DEFAULT 0,
    "activity_time" INTEGER NOT NULL DEFAULT 0,
    "activity_status" INTEGER NOT NULL DEFAULT 0
)