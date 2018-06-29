/* 
  vehicle_change.sql
  HCBuyerApp

  Created by wj on 14-10-27.
  Copyright (c) 2014年 haoche51. All rights reserved.
*/

CREATE TABLE IF NOT EXISTS "vehicle_change" (
    "last_change_id" INTEGER PRIMARY KEY NOT NULL,
    "city_id" INTEGER DEFAULT 0
)