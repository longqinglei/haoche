//
//  BizBrand.m
//  HCBuyerApp
//
//  Created by wj on 15/3/13.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "BizBrandSeries.h"
#import "BrandSeries.h"
#import "AppClient.h"
#import "pinyin.h"
#import "AutoSeries.h"



@implementation BizBrandSeries

//static NSInteger lastRefreshTime = 0;

static NSMutableDictionary* refreshTimeDic = nil;

+(NSArray *)getBrandSeriesListOrderedLocal:(NSInteger)cityId
{
    NSMutableArray *retArray = [[NSMutableArray alloc] init];
    [retArray addObject:[BrandSeries getHotBrandSeriesList:cityId]];
    [retArray addObject:[BrandSeries getBrandSeriesList:cityId]];
    return retArray;
}

+(void)getIncrementSeriesData:(void (^)(BOOL))finish;
{
    NSDictionary *requestParam = @{};
    [AppClient action:@"get_increment_series"
           withParams:requestParam
               finish:^(HttpResponse* response) {
                   if (response.code != 0) {
                       NSLog(@"Http response error: %@", response.errMsg);
                       //显示网络连接错误, 则选取数据库数据
                       finish(NO);
                   } else {
                       @try {
                           if ([response.data isKindOfClass:[NSArray class]]) {
                               NSArray* seriesDatas = response.data;
                               if ([seriesDatas count] == 0) {
                                   finish(NO);
                                   return;
                               }
                               for (NSDictionary *seriesInfo in seriesDatas) {
                                   AutoSeries *series = [[AutoSeries alloc] init];
                                   series.seriesId = [[seriesInfo objectForKey:@"id"] integerValue];
                                   series.seriesName = (NSString *)[seriesInfo objectForKey:@"name"];
                                   //写入数据库
                                   [AutoSeries addSeriesInfo:series];
                               }
                               finish(YES);
                           }

                       } @catch (NSException *exception) {
                            finish(NO);
                       } @finally {
                           
                       }
                    }
               }
     ];
}

+(void)getBrandSeriesListOrderedRemote:(NSInteger)cityId localEmpty:(BOOL)localEmpty byfinish:(void (^)(NSArray*))finish
{
    //获取当前时间戳
    NSDate *now = [NSDate date];
    NSInteger nowTS = [now timeIntervalSince1970];
    
    if (refreshTimeDic == nil) {
        refreshTimeDic = [[NSMutableDictionary alloc] init];
    }
    
    NSNumber *lastRefreshTime = [refreshTimeDic objectForKey:[NSNumber numberWithInteger:cityId]];
    if (lastRefreshTime == nil) {
        lastRefreshTime = 0;
    }
    //NSLog(@"try to update brand series info for city: %ld", (long)cityId);
    //如果上次更新时间在2小时以内，且本地数据不为空的话 则不从服务端更新
    if ([lastRefreshTime  integerValue] + 3600 * 2 > nowTS && !localEmpty) {
       // NSLog(@"the local data is not expired. no need update brand series info");
        finish(nil);
        return;
    }
    //从服务端获取
    NSDictionary *requestParam = @{@"city_id": [NSNumber numberWithInteger:cityId]};
    [AppClient action:@"get_support_brand"
            withParams:requestParam
                finish:^(HttpResponse* response) {
                if (response.code != 0) {
                        NSLog(@"Http response error: %@", response.errMsg);
                        //显示网络连接错误, 则选取数据库数据
                        finish(nil);
                    } else {
                        
                        NSArray* brandSeriesDatas = response.data;
                        NSMutableArray *brandSeriesList = [[NSMutableArray alloc] init];
                        NSMutableArray *hotBrandSeriesList = [[NSMutableArray alloc] init];
                        NSInteger hotBrandNum = 0;
                        //写入品牌
                        for (NSDictionary *brandSeriesInfo in brandSeriesDatas) {
                            BrandSeries *elem = [[BrandSeries alloc] init];     //在请求里面进行创建，增加延长
                            elem.brandId = [(NSNumber *)[brandSeriesInfo objectForKey:@"brand_id"] integerValue];
                            elem.brandName = (NSString *)[brandSeriesInfo objectForKey:@"brand_name"];
                            elem.cityId = cityId;
                            elem.brandFirstLetter = (NSString *)[brandSeriesInfo objectForKey:@"first_char"];
                            if ([[brandSeriesInfo objectForKey:@"series"] isKindOfClass:[NSArray class]]) {//首先要添加判断，是否是数组
                                NSArray *seriesArray = [brandSeriesInfo objectForKey:@"series"];
                                elem.seriesGroup = [seriesArray componentsJoinedByString:@","];
                                elem.seriesInfo = [AutoSeries getSeriesNamesByIdGroup:elem.seriesGroup];
                                elem.isHot = 0;
                            }
                            if (hotBrandNum < 24) {
                                elem.isHot = hotBrandNum + 1; //isHot 按照获取的顺序赋值    
                                [hotBrandSeriesList addObject:elem];
                                hotBrandNum++;
                            }
                            [brandSeriesList addObject:elem];
                        }
                        //品牌按照字符排序
                        NSArray *finalList = [brandSeriesList sortedArrayUsingComparator:^NSComparisonResult(BrandSeries *obj1, BrandSeries *obj2) {
                            NSComparisonResult result = [obj1.brandFirstLetter compare:obj2.brandFirstLetter];
                            return result;
                        }];
                        
                        NSArray *finalHotList = [hotBrandSeriesList sortedArrayUsingComparator:^NSComparisonResult(BrandSeries *obj1, BrandSeries *obj2) {
                            NSComparisonResult result = obj1.isHot > obj2.isHot;
                            return result;
                        }];
                        
                        [BrandSeries batchInsertBrandSereisInfos:brandSeriesList cityId:cityId];
                        
                        NSNumber *refreshTime = [NSNumber numberWithInteger:[now timeIntervalSince1970]];
                        [refreshTimeDic setObject:refreshTime forKey:[NSNumber numberWithInteger:cityId]];
                        
                        NSMutableArray *retList = [[NSMutableArray alloc] init];
                        [retList addObject:finalHotList];
                        [retList addObject:finalList];
                        finish(retList);
                    }
                }
     ];
}

@end
