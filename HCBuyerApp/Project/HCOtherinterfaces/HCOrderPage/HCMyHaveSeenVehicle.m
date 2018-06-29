//
//  HCMyHaveSeenVehicle.m
//  HCBuyerApp
//
//  Created by 张熙 on 15/9/7.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "HCMyHaveSeenVehicle.h"
#import "DBHandler.h"
#import "MyHaveSeenVehicle.h"
@implementation HCMyHaveSeenVehicleList

@end
static  NSString *tableName4 = @"myHaveSeenVehicle";
@implementation HCMyHaveSeenVehicle


+ (void)createTable
{
    FMDatabase *db = [DBHandler getDBHandle];
    [db open];
    //打开成功
    NSString *createSql = @"create table if not exists myHaveSeenVehicle (id integer primary key autoincrement, comment varchar(1024), coupon_amount varchar(1024), coupon_type varchar(1024), desc varchar(1024),geerbox varchar(1024),image varchar(1024),mile varchar(1024) ,name varchar(1024),phone varchar(1024),place varchar(1024), price varchar(1024), register_time varchar(1024), time varchar(1024), trans_status varchar(1024),status integer default 0, type varchar(1024), vehicle_name varchar(1024), vehicle_online varchar(1024), vehicle_source_id varchar(1024))";
    BOOL ret = [db executeUpdate:createSql];
    if (ret) {
        NSLog(@"create table %@ success", tableName4);
    } else {
        NSLog(@"create table failed : %@", db.lastErrorMessage);
    }
    [db close];
}
+(void)insertVehicle:(MyHaveSeenVehicle *)vehicle{
    
    NSString *sql = [NSString stringWithFormat:@"insert into %@ (id, comment, coupon_amount, coupon_type, desc, geerbox, image, mile, name, phone, place, price, register_time, time, trans_status, status, type,vehicle_name,vehicle_online,vehicle_source_id) values (%ld,'%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', %@, %@, '%@', '%ld','%@','%@', '%@', '%@')", tableName4,(long)vehicle.mId, vehicle.mComment, vehicle.mCoupon_amount, vehicle.mCoupon_type, vehicle.mDesc,vehicle.mGeerbox,vehicle.mImage, vehicle.mMile, vehicle.mName, vehicle.mPhone, vehicle.mPlace, vehicle.mPrice, vehicle.mRegister_time, vehicle.mTime, vehicle.mTrans_status, (long)vehicle.mStatus, vehicle.mType, vehicle.mVehicle_name, vehicle.mVehicle_online,vehicle.mVehicle_source_id];
    FMDatabase *db = [DBHandler getDBHandle];
    [db open];
    [db executeUpdate:sql];
    if ([db executeQuery:sql]) {
      //  NSLog(@"dassdasd插入成功");
    }else{
        NSLog(@"error %@",db.lastErrorMessage);
    }
    [db close];

}
+(void)getOrderFrom:(NSDictionary *)data
{
    if ([data isKindOfClass:[NSDictionary class]]) {
    [HCMyHaveSeenVehicle createTable];
    MyHaveSeenVehicle *vehicle = [[MyHaveSeenVehicle alloc]init];
    if ([data objectForKey:@"place"]) {
        vehicle.mPlace = [data objectForKey:@"place"];
    }
    if ([data objectForKey:@"image"]) {
        vehicle.mImage =[data objectForKey:@"image"] ;
    }
    if ([data objectForKey:@"time"]) {
        vehicle.mTime = [data objectForKey:@"time"];
    }if ([data objectForKey:@"status"]) {
        vehicle.mStatus = [[data objectForKey:@"status"]integerValue];
    }
    if ([data objectForKey:@"geerbox"]) {
        vehicle.mGeerbox = [data objectForKey:@"geerbox"];
        // vehicle.mGeerbox = [self geerbox];
    }if ([data objectForKey:@"register_time"]) {
        vehicle.mRegister_time = [data objectForKey:@"register_time"];
    }if ([data objectForKey:@"vehicle_online"]) {
        vehicle.mVehicle_online = [data objectForKey:@"vehicle_online"];
    }if ([data objectForKey:@"vehicle_name"]) {
        vehicle.mVehicle_name = [data objectForKey:@"vehicle_name"];
    }if ([data objectForKey:@"mile"]) {
        vehicle.mMile = [data objectForKey:@"mile"];
    }if ([data objectForKey:@"name"]) {
        vehicle.mName = [data objectForKey:@"name"];
    }if ([data objectForKey:@"trans_status"]) {
        vehicle.mTrans_status = [data objectForKey:@"trans_status"];
    }if ([data objectForKey:@"vehicle_source_id"]) {
        vehicle.mVehicle_source_id = [data objectForKey:@"vehicle_source_id"];
    }if ([data objectForKey:@"type"]) {
        vehicle.mType = [data objectForKey:@"type"];
    }if ( [data objectForKey:@"id"]) {
        vehicle.mId = [[data objectForKey:@"id"]integerValue];
    }if ([data objectForKey:@"phone"]) {
        vehicle.mPhone = [data objectForKey:@"phone"];
    }if ( [data objectForKey:@"coupon_amount"]) {
        vehicle.mCoupon_amount = [data objectForKey:@"coupon_amount"];
    }if ([data objectForKey:@"coupon_type"]) {
        vehicle.mCoupon_type = [data objectForKey:@"coupon_type"];
    }if ([data objectForKey:@"desc"]) {
        vehicle.mDesc = [data objectForKey:@"desc"];
    }if ([data objectForKey:@"price"]) {
        vehicle.mPrice = [NSString stringWithFormat:@"%@",[data objectForKey:@"price"]];
    }
    if ( [data objectForKey:@"comment"]) {
        vehicle.mComment = [data objectForKey:@"comment"];
    }
    [HCMyHaveSeenVehicle insertVehicle:vehicle];
    }
}

+(NSArray *)getVehicleSourceList{
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    NSString *sql = [NSString stringWithFormat:@"select * from %@", tableName4];
    FMDatabase *db = [DBHandler getDBHandle];
    [db open];
    FMResultSet *s = [db executeQuery:sql];
    while ([s next]) {
        MyHaveSeenVehicle *vehicle = [HCMyHaveSeenVehicle buildVehicleByFMResult:s];
        [resultList addObject:vehicle];
    }
    [db close];
    return resultList;
}


+(MyHaveSeenVehicle *)buildVehicleByFMResult:(FMResultSet *)s
{
    MyHaveSeenVehicle *vehicle = [[MyHaveSeenVehicle alloc] init];
    
    vehicle.mId = [s intForColumn:@"id"];
    vehicle.mComment = [s stringForColumn:@"comment"];
    
    vehicle.mCoupon_amount = [s stringForColumn:@"coupon_amount"];
    vehicle.mCoupon_type = [s stringForColumn:@"coupon_type"];
    
    vehicle.mDesc = [s stringForColumn:@"desc"];
    vehicle.mGeerbox = [s stringForColumn:@"geerbox"];
    
    vehicle.mImage = [NSString getFixedSolutionImageUrl:[s stringForColumn:@"image"]];
    vehicle.mMile = [s stringForColumn:@"mile"];
    
    vehicle.mName = [s stringForColumn:@"name"];
    vehicle.mPhone = [s stringForColumn:@"phone"];
    
    vehicle.mPlace = [s stringForColumn:@"place"];
    vehicle.mPrice = [s stringForColumn:@"price"];
    
    vehicle.mRegister_time = [s stringForColumn:@"register_time"];
    vehicle.mTime = [s stringForColumn:@"time"];
    
    vehicle.mTrans_status = [s stringForColumn:@"trans_status"];
    vehicle.mStatus = [s intForColumn:@"status"];
    
    vehicle.mType = [s stringForColumn:@"type"];
    vehicle.mVehicle_name = [s stringForColumn:@"vehicle_name"];
    
    vehicle.mVehicle_online = [s stringForColumn:@"vehicle_online"];
    vehicle.mVehicle_source_id = [s stringForColumn:@"vehicle_source_id"];
    
    return vehicle;
}
+(void)delettable{
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM  %@", tableName4];
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

@end
