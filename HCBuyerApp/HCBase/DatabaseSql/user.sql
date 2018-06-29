/* 
  user.sql
  HCBuyerApp

  Created by wj on 14-10-30.
  Copyright (c) 2014年 haoche51. All rights reserved.
*/
CREATE TABLE IF NOT EXISTS "user" (
"id" INTEGER PRIMARY KEY AutoIncrement,
"userid" INTEGER DEFAULT 0,
"clientid" TEXT,
"phone" TEXT
)