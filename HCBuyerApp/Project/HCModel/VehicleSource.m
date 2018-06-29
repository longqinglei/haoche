//
//  VehicleSource.m
//  HCBuyerApp
//
//  Created by wj on 14-10-20.
//  Copyright (c) 2014年 haoche51. All rights reserved.
//

#import "VehicleSource.h"
#import "DBHandler.h"
#import "pinyin.h"

@interface VehicleSource()

@end

@implementation VehicleSource

static  NSString *tableName = @"vehicle_source_v2";

/*
 CREATE TABLE IF NOT EXISTS "vehicle_source" (
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
 */

//插入新的数据
//+ (void)insertVehicle:(Vehicle *)vehicle
//{
//    NSString *sql = [NSString stringWithFormat:@"insert into %@ (vehicle_source_id, city_id, vehicle_name, register_date, geerbox_type, seller_price, miles, online_time, brand_name, brand_id, class_name, cut_price, cheap_price, cover_img_url, seller_name, seller_sex, seller_photo_url, seller_job_desc, seller_district, award_info, status, offline, fav_status, recommend_status, create_time, activity_time, activity_status, refresh_time, quoted_price, dealer_buy_price) values (%d, %d, '%@', %d, %d, %f, %f, %d,'%@',%d, '%@', %f, %f,'%@', '%@', %ld, '%@', '%@', '%@', '%@', %d, %d, %d, %d, %d, %d, %d, %d, %f, %f)", tableName,vehicle.vehicleSourceId, vehicle.cityId, vehicle.vehicleName, vehicle.registerDate, vehicle.gearboxType, vehicle.vehiclePrice, vehicle.vehicleMiles, vehicle.onlineTime, vehicle.brandName, vehicle.brandId, vehicle.className, vehicle.cutPrice, vehicle.cheapPrice, vehicle.vehicleImage, vehicle.sellerName, (long)vehicle.sellerSex, vehicle.sellerPhotoUrl, vehicle.sellerJobDesc, vehicle.sellerDistrict, vehicle.awardInfo, vehicle.status, vehicle.offline, vehicle.favStatus, vehicle.recommendStatus, vehicle.createTime, vehicle.activityTime, vehicle.activityStatus, vehicle.refresh_time, vehicle.quoted_price, vehicle.dealer_buy_price];
//    FMDatabase *db = [DBHandler getDBHandle];
//    [db open];
//    [db executeUpdate:sql];
//    [db close];
//}
//
//+(NSArray *)getVehicleSourceList
//{
//    NSMutableArray *resultList = [[NSMutableArray alloc] init];
//    NSString *sql = [NSString stringWithFormat:@"select * from %@", tableName];
//    FMDatabase *db = [DBHandler getDBHandle];
//    [db open];
//    FMResultSet *s = [db executeQuery:sql];
//    while ([s next]) {
//        //retrieve values for each record
//        Vehicle *vehicle = [VehicleSource buildVehicleByFMResult:s];
//        [resultList addObject:vehicle];
//    }
//    [s close];
//    [db close];
//    return resultList;
//}
//
//+(void)replaceVehicleSourceList:(NSArray *)list
//{
//    //删除当前数据
//    NSString *sql = [NSString stringWithFormat:@"delete from %@", tableName];
//    FMDatabase *db = [DBHandler getDBHandle];
//    [db open];
//    [db executeUpdate:sql];
//    [db close];
//    //插入新数据
//    for (Vehicle *vehicle in list) {
//        [VehicleSource insertVehicle:vehicle];
//    }
//}
//
//
//+ (void)createTable
//{
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:tableName ofType:@"sql"];
//    NSError *error;
//    NSString *sql = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
//    FMDatabase *db = [DBHandler getDBHandle];
//    [db open];
//    BOOL ret = [db executeUpdate:sql];
//    if (ret) {
//        NSLog(@"create table %@ success", tableName);
//    } else {
//        NSLog(@"create table failed : %@", db.lastErrorMessage);
//    }
//    [db close];
//}
//
//+ (Vehicle *)getVehicleById:(NSInteger)vehicleSourceId
//{
//    NSString *querySql = [NSString stringWithFormat:@"select * from %@ where vehicle_source_id=%ld and status = 3 and offline = 0", tableName, (long)vehicleSourceId];
//    FMDatabase *db = [DBHandler getDBHandle];
//    [db open];
//    FMResultSet *s = [db executeQuery:querySql];
//    if ([s next]) {
//        Vehicle *vehicle = [VehicleSource buildVehicleByFMResult:s];
//        [s close];
//        [db close];
//        return vehicle;
//    }
//    [s close];
//    [db close];
//    return  nil;
//}
//
//+(Vehicle *)buildVehicleByFMResult:(FMResultSet *)s
//{
//    Vehicle *vehicle = [[Vehicle alloc] init];
//    vehicle.brandId = [s intForColumn:@"brand_id"];
//    vehicle.brandName = [s stringForColumn:@"brand_name"];
//    vehicle.className = [s stringForColumn:@"class_name"];
//    vehicle.cityId = [s intForColumn:@"city_id"];
//    vehicle.favStatus = [s intForColumn:@"fav_status"];
//    vehicle.gearboxType = [s intForColumn:@"geerbox_type"];
//    vehicle.onlineTime = [s intForColumn:@"online_time"];
//    vehicle.status = [s intForColumn:@"status"];
//    vehicle.vehicleSourceId = [s intForColumn:@"vehicle_source_id"];
//    vehicle.vehicleImage = [s stringForColumn:@"cover_img_url"];
//    vehicle.vehicleMiles = [s doubleForColumn:@"miles"];
//    vehicle.vehicleName = [s stringForColumn:@"vehicle_name"];
//    vehicle.vehiclePrice = [s doubleForColumn:@"seller_price"];
//    vehicle.cutPrice = [s doubleForColumn:@"cut_price"];
//    vehicle.registerDate = [s intForColumn:@"register_date"];
//    vehicle.sellerJobDesc = [s stringForColumn:@"seller_job_desc"];
//    vehicle.sellerSex = [s intForColumn:@"seller_sex"];
//    vehicle.sellerDistrict = [s stringForColumn:@"seller_district"];
//    vehicle.sellerName = [s stringForColumn:@"seller_name"];
//    vehicle.sellerPhotoUrl = [s stringForColumn:@"seller_photo_url"];
//    vehicle.awardInfo = [s stringForColumn:@"award_info"];
//    vehicle.createTime = [s intForColumn:@"create_time"];
//    vehicle.activityTime = [s intForColumn:@"activity_time"];
//    vehicle.activityStatus = [s intForColumn:@"activity_status"];
//    vehicle.cheapPrice = [s doubleForColumn:@"cheap_price"];
//    vehicle.quoted_price = [s doubleForColumn:@"quoted_price"];
//    vehicle.dealer_buy_price = [s doubleForColumn:@"dealer_buy_price"];
//    return vehicle;
//}

@end
