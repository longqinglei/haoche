//
//  AutoSeries.m
//  HCBuyerApp
//
//  Created by wj on 15/5/13.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "AutoSeries.h"
#import "DBHandler.h"

static  NSString *tableName = @"auto_series";

@implementation AutoSeries


+ (void)addSeriesInfo:(AutoSeries *)series
{
    NSString *sql = [NSString stringWithFormat:@"select id from %@ where series_id = %ld", tableName, (long)series.seriesId];
    FMDatabase *db = [DBHandler getDBHandle];
    [db open];
    FMResultSet *s = [db executeQuery:sql];
    if ([s next]) {
        NSLog(@"the series is already exist! id:%ld", (long)series.seriesId);
        [s close];
        [db close];
        return;
    }
    [s close];
    NSString *insertSql = [NSString stringWithFormat:@"insert into %@(series_id, series_name) values(%ld, '%@')", tableName, (long)series.seriesId, series.seriesName];
    [db executeUpdate:insertSql];
    [db close];
}

+ (NSString *)getSeriesNamesByseries_id:(NSInteger)series_id
{
    NSString *seriesName;
    NSString *sql = [NSString stringWithFormat:@"select series_id, series_name from %@ where series_id in (%ld)", tableName, (long)series_id];
    FMDatabase *db = [DBHandler getDBHandle];
    [db open];
    FMResultSet *s = [db executeQuery:sql];
    while ([s next]) {
        //retrieve values for each record
        seriesName =  [s stringForColumn:@"series_name"];
        
    }
    [s close];
    [db close];
    return seriesName;
}

//按照车系id列表获取所有的车系名称。 id列表以逗号分隔
+ (NSArray *)getSeriesNamesByIdGroup:(NSString *)seriesIdGroup
{
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    NSString *sql = [NSString stringWithFormat:@"select series_id, series_name from %@ where series_id in (%@)", tableName, seriesIdGroup];
    FMDatabase *db = [DBHandler getDBHandle];
    [db open];
    FMResultSet *s = [db executeQuery:sql];
    while ([s next]) {
        //retrieve values for each record
        AutoSeries *series = [[AutoSeries alloc] init];
        series.seriesId = [s intForColumn:@"series_id"];
        series.seriesName = [s stringForColumn:@"series_name"];
        [resultList addObject:series];
    }
    [s close];
    [db close];
    return resultList;
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
        //如果添加成功。判断是否完整数据已经添加。如果没有，导入完整数据到本地
        NSString *selectSql =  [NSString stringWithFormat:@"select count(*) as c from %@", tableName];
        FMResultSet *s = [db executeQuery:selectSql];
        if ([s next]) {
            NSInteger cnt = [s intForColumn:@"c"];
            if (cnt == 0) {
                //执行导入
                //NSNumber *startTime = [NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970] * 1000];
                NSString *dataFilePath = [[NSBundle mainBundle] pathForResource:tableName ofType:@"data"];
                NSError *error;
                NSString *fileContents = [NSString stringWithContentsOfFile:dataFilePath encoding:NSUTF8StringEncoding error:&error];
                NSArray *sqls = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                
                //事务操作
                NSInteger total = [sqls count];
                //一次事务写入500条
                NSInteger loop = ceil(total / 500.0f);
                for (NSInteger i = 0 ; i < loop;  ++i) {
                    NSInteger jmax = MIN((i + 1) * 500, total);
                    [db beginTransaction];
                    for (NSInteger j = i * 500; j < jmax; ++j) {
                        [db executeUpdate:[sqls HCObjectAtIndex:j]];
                    }
                    [db commit];
                }
                //NSNumber *endTime = [NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970] * 1000];
                //NSLog(@"dump the sereis data success! execuse time cost: %ld ms", (long)([endTime integerValue] - [startTime integerValue]));
            } else {
                @try {
                    NSString *seriesName=  [AutoSeries getSeriesNamesByseries_id:3693];
                    if (seriesName==nil) {
                        AutoSeries *series = [[AutoSeries alloc]init];
                        series.seriesName = @"金牛座";
                        series.seriesId = 3693;
                        [AutoSeries addSeriesInfo:series];
                    }
                } @catch (NSException *exception) {
                    
                } @finally {
                    NSLog(@"the init data for auto_series is already exist;");
                }
            }
        } else {
            NSLog(@"error where insert series data");
        }
        [s close];
    } else {
        NSLog(@"create table failed : %@", db.lastErrorMessage);
    }
    [db close];
}

@end
