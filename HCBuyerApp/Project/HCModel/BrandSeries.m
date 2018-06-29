//
//  Brand.m
//  HCBuyerApp
//
//  Created by wj on 14-10-23.
//  Copyright (c) 2014年 haoche51. All rights reserved.
//

#import "BrandSeries.h"
#import "AutoSeries.h"
#import "DBHandler.h"
//#import "pinyin.h"

@implementation BrandSeries

static  NSString *tableName = @"brand_series";

+(NSArray *)getBrandSeriesList:(NSInteger)cityId
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *sql = [NSString stringWithFormat:@"select * from %@  where city_id = %ld order by first_letter asc", tableName, (long)cityId];
    FMDatabase *db = [DBHandler getDBHandle];
    [db open];
    FMResultSet *rs = [db executeQuery:sql];
    while ([rs next]) {
        BrandSeries *brandSeries = [[BrandSeries alloc] init];
        brandSeries.cityId = [rs intForColumn:@"city_id"];
        brandSeries.brandId = [rs intForColumn:@"brand_id"];
        brandSeries.brandName = [rs stringForColumn:@"brand_name"];
        brandSeries.brandFirstLetter = [rs stringForColumn:@"first_letter"];
        brandSeries.seriesGroup = [rs stringForColumn:@"series_group"];
        brandSeries.isHot = [rs intForColumn:@"is_hot"];
        [array addObject:brandSeries];
    }
    [rs close];
    [db close];
    
    for (BrandSeries *brandSeries in array) {
        //获取车系信息
        NSArray *seriesInfo = [AutoSeries getSeriesNamesByIdGroup:brandSeries.seriesGroup];
        brandSeries.seriesInfo = seriesInfo;
    }
    return array;
}

//获取热门的品牌车系
+(NSArray *)getHotBrandSeriesList:(NSInteger)cityId
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *sql = [NSString stringWithFormat:@"select * from %@  where city_id = %ld and is_hot > 0 order by is_hot asc limit 24", tableName, (long)cityId];
    FMDatabase *db = [DBHandler getDBHandle];
    [db open];
    FMResultSet *rs = [db executeQuery:sql];
    while ([rs next]) {
        BrandSeries *brandSeries = [[BrandSeries alloc] init];
        brandSeries.cityId = [rs intForColumn:@"city_id"];
        brandSeries.brandId = [rs intForColumn:@"brand_id"];
        brandSeries.brandName = [rs stringForColumn:@"brand_name"];
        brandSeries.brandFirstLetter = [rs stringForColumn:@"first_letter"];
        brandSeries.seriesGroup = [rs stringForColumn:@"series_group"];
        brandSeries.isHot = [rs intForColumn:@"is_hot"];
        [array addObject:brandSeries];
    }
    [rs close];
    [db close];
    
    for (BrandSeries *brandSeries in array) {
        //获取车系信息
        NSArray *seriesInfo = [AutoSeries getSeriesNamesByIdGroup:brandSeries.seriesGroup];
        brandSeries.seriesInfo = seriesInfo;
    }
    return array;
}

+(void)batchInsertBrandSereisInfos:(NSArray *)list cityId:(NSInteger)cityId
{
    NSMutableArray *incrementList = [[NSMutableArray alloc] init];
    NSArray *oldBrandSeriesList = [BrandSeries getBrandSeriesList:cityId];
    for (BrandSeries *brandSeries in list) {
        BOOL exist = NO;
        for (BrandSeries *oldBrandSeries in oldBrandSeriesList) {
            if ((oldBrandSeries.brandId == brandSeries.brandId) && [oldBrandSeries.seriesGroup isEqualToString:brandSeries.seriesGroup] && (oldBrandSeries.isHot == brandSeries.isHot)) {
                exist = YES;
                break;
            }
        }
        if (!exist) {
            [incrementList addObject:brandSeries];
        }
    }
    //写入数据库
    for (BrandSeries *brandSeries in incrementList) {
        [BrandSeries insertBrandSeriesInfo:brandSeries];
    }
}
+ (NSString*)getBrandNameByBrandId:(NSInteger)brandid{
    NSString *seriesName;
    NSString *sql = [NSString stringWithFormat:@"select brand_name from %@ where brand_id in (%ld)", tableName, (long)brandid];
    FMDatabase *db = [DBHandler getDBHandle];
    [db open];
    FMResultSet *s = [db executeQuery:sql];
    while ([s next]) {
        //retrieve values for each record
        seriesName =  [s stringForColumn:@"brand_name"];
        
    }
    [s close];
    [db close];
    return seriesName;
    
    
}
+ (void)insertBrandSeriesInfo:(BrandSeries *)brandSeries
{
    FMDatabase *db = [DBHandler getDBHandle];
    [db open];
    NSString *querySql = [NSString stringWithFormat:@"select id from %@ where brand_id=%ld and city_id=%ld", tableName, (long)brandSeries.brandId, (long)brandSeries.cityId];
    
     NSString *excuseSql = [NSString stringWithFormat:@"insert into %@(brand_id, brand_name, first_letter, city_id, series_group, is_hot) values (%ld, '%@', '%@', %ld, '%@', %ld)", tableName, (long)brandSeries.brandId, brandSeries.brandName, brandSeries.brandFirstLetter, (long)brandSeries.cityId, brandSeries.seriesGroup, (long)brandSeries.isHot];
    
    FMResultSet *s = [db executeQuery:querySql];
    
    if ([s next]) {
        //如果存在，则执行update 操作
        excuseSql = [NSString stringWithFormat:@"update %@ set series_group = '%@', is_hot = %ld where brand_id = %ld and city_id = %ld", tableName, brandSeries.seriesGroup, (long)brandSeries.isHot , (long)brandSeries.brandId, (long)brandSeries.cityId];
        [s close];
    }
    //insert
    [db executeUpdate:excuseSql];
    [db close];
}

+ (void)createTable
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:tableName ofType:@"sql"];
    NSError *error;
    NSString *sql = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    FMDatabase *db = [DBHandler getDBHandle];
    [db open];
    BOOL ret = [db executeUpdate:sql];
    if (ret) {
        NSLog(@"create table %@ success", tableName);
    } else {
        NSLog(@"create table failed : %@", db.lastErrorMessage);
    }
    [db close];
}

@end
