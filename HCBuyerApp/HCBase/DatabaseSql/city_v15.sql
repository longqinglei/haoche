/*
city.sql
HCBuyerApp

Created by wj on 14-10-27.
Copyright (c) 2014年 haoche51. All rights reserved.
*/

CREATE TABLE IF NOT EXISTS "city_v15" (
"city_id" INTEGER PRIMARY KEY NOT NULL,
"city_name" TEXT,
"first_letter" TEXT,
"domain" TEXT,
"createTime" INTEGER
)