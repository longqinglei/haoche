//
//  MyVehicle.m
//  HCBuyer
//
//  Created by 张熙 on 15/8/22.
//  Copyright (c) 2015年 张熙. All rights reserved.
//

#import "MyVehicle.h"
#import "DBHandler.h"
#import "SubscriptionModelCar.h"
@implementation List
@end
static  NSString *tableName1 = @"myOrderList";

static NSString *userKey = @"HC_USER";
@implementation MyVehicle
//创建表
+ (void)createTable
{
    // NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/myOrderList.db"];
    FMDatabase *db = [DBHandler getDBHandle];
    [db open];
    //打开成功
    NSString *createSql = @"create table if not exists myOrderList (uid text,class_id text , price_high text ,price_low text , year_high text ,year_low text ,miles_high text  , miles_low text , brand_id text , geerbox text ,emission_high text , emission_low text, es_standard text ,structure text,id text,cityid text)";;
    BOOL isSuccessed = [db executeUpdate:createSql];
    if (isSuccessed) {

       // NSLog(@"create table %@ success", tableName1);

    } else {
        NSLog(@"create table failed : %@", db.lastErrorMessage);
    }
    [db close];
}/*
 "params" : {
 . uid  //用户id//必填
 . phone //手机->必填
 • brand_id // 品牌
 • class_id //车系
 • price_low // 价格区间
 • price_high
 • miles_low // 公里数区间
 • miles_high
 •year_low //年限区间
 • year_high
 • gearbox//变数箱
 • emission_low // 排量区间
 • emission_high
 • es_standard // 排放标准
 • structure， // 车身结构;
 }
 */
+ (void)addOrderVihicleList:(List *)vehicle
{
    NSString *sql = [NSString stringWithFormat:@"insert into %@ (uid, class_id,  price_high, price_low, year_high, year_low, miles_high, miles_low, brand_id, geerbox, emission_high,emission_low,es_standard,structure,id,cityid) values (%@, %@, %@, %@, %@, %@, %@, %@, %@, %@,%@,%@,%@ ,%@,%@,%@)", tableName1,vehicle.uid, vehicle.class_id, vehicle.price_high, vehicle.price_low, vehicle.year_high, vehicle.year_low, vehicle.miles_high, vehicle.miles_low, vehicle.brand_id, vehicle.geerbox,vehicle.emission_high,vehicle.emission_low,vehicle.es_standard,vehicle.structure,vehicle._id,vehicle.cityid];
    FMDatabase *db = [DBHandler getDBHandle];
    [db open];
    [db executeUpdate:sql];
    if ([db executeQuery:sql]) {
        //NSLog(@"　插入成功");
    
    
    }else{
        NSLog(@"error %@",db.lastErrorMessage);
    }
    [db close];
}

+(void)deleteOrderInfoFromOrderList:(int)_id
{
    //删除当前数据
    
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where barnd_id=?", tableName1];
    FMDatabase *db = [DBHandler getDBHandle];
    
    BOOL isSuceeed = [db executeUpdate:sql,_id];
    if (!isSuceeed) {
        NSLog(@"deleteError:%@",db.lastErrorMessage);
    }
    [db open];
    [db executeUpdate:sql];
    [db close];
    
}
//删除表
+(void)delettable{
    
   NSString *sql = [NSString stringWithFormat:@"DELETE FROM  %@", tableName1];
     FMDatabase *db = [DBHandler getDBHandle];
     [db open];
    BOOL res = [db executeUpdate:sql];;
    if (!res) {
        NSLog(@"error when delete db table");
    } else {
        //NSLog(@"success to delete db table");
    }
    [db close];
    
    
   
   
    
//    if ([db executeQuery:sql]) {
//        NSLog(@"删除成功");
//    }else{
//        NSLog(@"error:%@",db.lastErrorMessage);
//    }
   // [db close];
    
}

//获取所有订阅列表
+ (NSArray *)getMyVehicleList
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *sql1 = [NSString stringWithFormat:@"select * from %@", tableName1];
    FMDatabase *db = [DBHandler getDBHandle];
    [db open];
    FMResultSet *rs = [db executeQuery:sql1];
    
    while ([rs next]) {
        SubscriptionModelCar *subModel  = [[SubscriptionModelCar alloc]init];
        subModel.uid = [rs stringForColumn:@"uid"];
        subModel.price_high = [rs stringForColumn:@"price_high"] ;
        subModel.price_low = [rs stringForColumn:@"price_low"];
        subModel.year_low = [rs stringForColumn:@"year_low"];
        subModel.year_high = [rs stringForColumn:@"year_high"];
        subModel.brand_id = [rs stringForColumn:@"brand_id"];
        subModel.class_id = [rs stringForColumn:@"class_id"];
        subModel.geerbox = [rs stringForColumn:@"geerbox"];
        subModel.es_standard = [rs stringForColumn:@"es_standard"];
        subModel.emission_high = [rs stringForColumn:@"emission_high"];
        subModel.emission_low = [rs stringForColumn:@"emission_low"];
        subModel.miles_high = [rs stringForColumn:@"miles_high"];
        subModel.miles_low = [rs stringForColumn:@"miles_low"];
        subModel.ID = [rs stringForColumn:@"id"];
        subModel.city_id = [rs stringForColumn:@"cityid"];
        [array addObject:subModel];
    }
    
    [db close];
    return array;
}
+(void)getDicDataFrom:(NSDictionary*)dict{
    [MyVehicle createTable];
    List *model = [[List alloc]init];
    model.uid = [dict objectForKey:@"uid"];
    //model.phone = [dict objectForKey:@"phone"];
    model.brand_id = [dict objectForKey:@"brand_id"];
    model.price_high = [dict objectForKey:@"price_high"];
    model.price_low = [dict objectForKey:@"price_low"];
    model.miles_low = [dict objectForKey:@"miles_low"];
    model.miles_high = [dict objectForKey:@"miles_high"];
    model.year_low = [dict objectForKey:@"year_low"];
    model._id = [dict objectForKey:@"id"];
    model.class_id = [dict objectForKey:@"class_id"];
    model.year_high = [dict objectForKey:@"year_high"];
    model.emission_low = [dict objectForKey:@"emission_low"];
    model.emission_high = [dict objectForKey:@"emission_high"];
    model.structure = [dict objectForKey:@"structure"];
    model.es_standard = [dict objectForKey:@"es_standard"];
    model.geerbox = [dict objectForKey:@"geerbox"];
    model.cityid = [dict objectForKey:@"city_id"];

    [MyVehicle  addOrderVihicleList:model];
}

@end
