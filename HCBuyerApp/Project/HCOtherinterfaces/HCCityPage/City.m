//
//  City.m
//  HCBuyerApp
//
//  Created by wj on 14/11/27.
//  Copyright (c) 2014年 haoche51. All rights reserved.
//

#import "City.h"
#import "DBHandler.h"
//#import "pinyin.h"

@implementation CityElem

@end

@implementation City

static  NSString *tableName = @"city_v15";

+ (NSArray *)getCityList
{
    NSMutableArray *array = [[NSMutableArray alloc] init];

    NSString *sql = [NSString stringWithFormat:@"select * from %@ order by createTime ", tableName];

    FMDatabase *db = [DBHandler getDBHandle];
    [db open];
    
    FMResultSet *rs = [db executeQuery:sql];
    while ([rs next]) {
        CityElem *cityElem = [[CityElem alloc] init];
        cityElem.cityId = [rs intForColumn:@"city_id"];
        cityElem.cityName = [rs stringForColumn:@"city_name"];
        cityElem.firstLetter = [rs stringForColumn:@"first_letter"];
        cityElem.domain = [rs stringForColumn:@"domain"];

        [array addObject:cityElem];
    }
    [rs close];
    [db close];
    return array;
}

+ (NSDictionary *)getCityListGroupbyDomain
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSString *sql = [NSString stringWithFormat:@"select * from %@", tableName];
    FMDatabase *db = [DBHandler getDBHandle];
    [db open];
    FMResultSet *rs = [db executeQuery:sql];
    while ([rs next]) {
        CityElem *cityElem = [[CityElem alloc] init];
        cityElem.cityId = [rs intForColumn:@"city_id"];
        cityElem.cityName = [rs stringForColumn:@"city_name"];
        cityElem.firstLetter = [rs stringForColumn:@"first_letter"];
        cityElem.domain = [rs stringForColumn:@"domain"];
        
        if ([dict objectForKey:cityElem.domain]) {
            [[dict objectForKey:cityElem.domain] addObject:cityElem];
        } else {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:cityElem];
            [dict setObject:array forKey:cityElem.domain];
        }
    }
    [rs close];
    [db close];
    return dict;
}

+ (NSString *)getCityNameById:(NSInteger)cityId
{
    NSString *cityName = @"未知";
    NSString *sql = [NSString stringWithFormat:@"select city_name from %@ where city_id=%ld", tableName, (long)cityId];
    FMDatabase *db = [DBHandler getDBHandle];
    [db open];
    FMResultSet *rs = [db executeQuery:sql];
    if ([rs next]) {
        cityName = [rs stringForColumn:@"city_name"];
    }
    [rs close];
    [db close];
    return cityName;
}

+(void)delettable{
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM  %@", tableName];
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

+ (void)addCityInfo:(CityElem *)elem
{
    FMDatabase *db = [DBHandler getDBHandle];
    [db open];
    NSString *insertSql = [NSString stringWithFormat:@"insert into %@(city_id, city_name, first_letter, domain ,createTime) values (%ld, '%@', '%@', '%@' ,%ld)", tableName, (long)elem.cityId, elem.cityName, elem.firstLetter, elem.domain ,(long)elem.createTime];
    [db executeUpdate:insertSql];
   // [rs close];
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
