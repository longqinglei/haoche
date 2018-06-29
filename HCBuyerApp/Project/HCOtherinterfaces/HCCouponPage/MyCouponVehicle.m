//
//  MyCouponVehicle.m
//  HCBuyerApp
//
//  Created by haoche51 on 15/9/7.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "MyCouponVehicle.h"

@implementation MyCouponVehicle
static  NSString *tableName3 = @"MyCouponVehicle";
//插入新的数据
+ (void)insertVehicle:(Coupon *)vehicle
{
    NSString *sql = [NSString stringWithFormat:@"insert into %@ (cashValue, type, couponTitle, startTime, endTime, enumId , couponId, couponCode, status, desc, phoneNumber) values ('%@', %ld, '%@', %ld, %ld, %ld, '%@', '%@', %ld, '%@', %ld)", tableName3,vehicle.cashValue, (long)vehicle.type, vehicle.couponTitle, (long)vehicle.startTime, (long)vehicle.endTime, (long)vehicle.enumId, vehicle.couponId, vehicle.couponCode, (long)vehicle.status, vehicle.desc, (long)vehicle.phoneNumber];
    FMDatabase *db = [DBHandler getDBHandle];
    [db open];
    [db executeUpdate:sql];
    if ([db executeQuery:sql]) {
       // NSLog(@"dassdasd插入成功");
    }else{
        NSLog(@"error %@",db.lastErrorMessage);
    }
    [db close];
}

+(NSArray *)getVehicleSourceList
{
    
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    NSString *sql = [NSString stringWithFormat:@"select * from %@", tableName3];
    FMDatabase *db = [DBHandler getDBHandle];
    [db open];
    FMResultSet *s = [db executeQuery:sql];
    while ([s next]) {
        Coupon *vehicle = [MyCouponVehicle buildVehicleByFMResult:s];
        [resultList addObject:vehicle];
    }
    [db close];
    return resultList;
}



+ (void)createTable
{
    FMDatabase *db = [DBHandler getDBHandle];
    [db open];
    //打开成功
    NSString *createSql = @"create table if not exists MyCouponVehicle (cashValue, type, couponTitle, startTime, endTime, enumId integer primary key autoincrement, couponId, couponCode, status, desc, phoneNumber)";
    BOOL ret = [db executeUpdate:createSql];
    if (ret) {
        NSLog(@"create table %@ success", tableName3);
    } else {
        NSLog(@"create table failed : %@", db.lastErrorMessage);
    }
    [db close];
}

//删除表
+(void)delettable{
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM  %@", tableName3];
    FMDatabase *db = [DBHandler getDBHandle];
    [db open];
    BOOL res = [db executeUpdate:sql];;
    if (!res) {
        NSLog(@"error when delete db table");
    } else {
        NSLog(@"success to delete db table");
    }
    [db close];
    
    
}


+(Coupon *)buildVehicleByFMResult:(FMResultSet *)s
{
    Coupon *vehicle = [[Coupon alloc] init];
    
    vehicle.cashValue = [s stringForColumn:@"cashValue"];
    vehicle.type = [[s stringForColumn:@"type"] integerValue];
    
    vehicle.couponTitle = [s stringForColumn:@"couponTitle"];
    vehicle.startTime = [[s stringForColumn:@"startTime"]integerValue];
    
    vehicle.endTime = [[s stringForColumn:@"endTime"] integerValue];
    vehicle.enumId = [[s stringForColumn:@"enumId"] integerValue];
    vehicle.couponId = [s stringForColumn:@"couponId"];
    
    vehicle.couponCode = [s stringForColumn:@"couponCode"];
    vehicle.status = [[s stringForColumn:@"status"] integerValue];
    
    vehicle.desc = [s stringForColumn:@"desc"];
    vehicle.phoneNumber = [[s stringForColumn:@"phoneNumber"]integerValue];
    
    return vehicle;
}

+(void)getOrderFrom:(NSDictionary *)s
{
    [MyCouponVehicle createTable];
    Coupon *vehicle = [[Coupon alloc]init];
    vehicle.cashValue = [s objectForKey:@"amount"];
    vehicle.type = [[s objectForKey:@"type"] integerValue];
    
    vehicle.couponTitle = [s objectForKey:@"title"];
    vehicle.startTime = [[s objectForKey:@"from_time"]integerValue];
    
    vehicle.endTime = [[s objectForKey:@"expire_time"] integerValue];
    vehicle.enumId = [[s objectForKey:@"id"] integerValue];
    vehicle.couponId = [s objectForKey:@"coupon_id"];
    
    
    vehicle.couponCode = [s objectForKey:@"code"];
    vehicle.status = [[s objectForKey:@"status"] integerValue];
    
    vehicle.desc = [s objectForKey:@"category"];
    vehicle.phoneNumber = [[s objectForKey:@"phone"]integerValue];
    [MyCouponVehicle insertVehicle:vehicle];
}

@end
