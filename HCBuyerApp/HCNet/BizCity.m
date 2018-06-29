//
//  BizCity.m
//  HCBuyerApp
//
//  Created by wj on 15/3/12.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "BizCity.h"
#import "City.h"
#import "AppClient.h"
#import "pinyin.h"

@implementation BizCity

static NSInteger lastRefreshTime = 0;
static NSString *cityKey = @"user_select_city";
static CityElem *recommendCity = nil;

//获取当前城市
+ (CityElem *)getCurCity
{
    NSArray *cityArray = [City getCityList];
//    BOOL empty ;
//    
//    if (cityArray.count==0) {
//        empty = YES;
//    }else{
//        empty = NO;
//    }
//    [BizCity getCityListOrderedRemote:empty finish:^(NSArray *ret) {
//    }];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:cityKey]) {
        NSArray *arr = (NSArray *)[[NSUserDefaults standardUserDefaults] objectForKey:cityKey];
        CityElem *city = [[CityElem alloc] init];
        city.cityName = [arr HCObjectAtIndex:0];
        city.cityId = [(NSNumber *)[arr HCObjectAtIndex:1] integerValue];
        return city;
    } else {
//        if (recommendCity != nil) {
//            return recommendCity;
//        }
        CityElem *city = [[CityElem alloc] init];
        
        if (cityArray.count!=0) {
            CityElem* city1 = [cityArray objectAtIndex:0];
            city = city1;
            [self saveSelectedCity:city];
            NSDictionary *dict= @{
                                  @"city":city
                                  };
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CityChanged" object:nil userInfo:dict];
        }else{
            city.cityId = -1;
            city.cityName = @"--";
        }
        
        
       
        
        //未确定选择的，不存储
        /*
        NSMutableArray *cityInfoArr = [[NSMutableArray alloc] init];
        [cityInfoArr addObject:city.cityName];
        [cityInfoArr addObject:[NSNumber numberWithInteger:city.cityId]];
        [[NSUserDefaults standardUserDefaults] setObject:cityInfoArr forKey:cityKey];
         */
        return city;
    }
}

+(BOOL)isCitySelected
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:cityKey] != nil;
}

+ (CityElem *)getRecommendCity
{
    return recommendCity;
}

+ (void)saveSelectedCity:(CityElem *)city
{
    NSMutableArray *cityInfoArr = [[NSMutableArray alloc] init];
    if (city.cityName == nil) {
        return;
    }else{
        [cityInfoArr addObject:city.cityName];
        [cityInfoArr addObject:[NSNumber numberWithInteger:city.cityId]];
        [[NSUserDefaults standardUserDefaults] setObject:cityInfoArr forKey:cityKey];
    }
}

+ (NSDictionary *)getCityListOrderedFromLocal
{
    return [City getCityListGroupbyDomain];
}

+ (void)getRecommendCityByLat:(float)lat andLng:(float)lng byfinish:(void(^)(CityElem *))finish
{
    NSDictionary *requestParam = @{@"longitude" : [NSNumber numberWithFloat:lng],
                                   @"latitude" : [NSNumber numberWithFloat:lat],
                                   };
    [AppClient action:@"get_nearest_city"
           withParams:requestParam
               finish:^(HttpResponse* response) {
                   if (response.code != 0) {
                       NSLog(@"Http response error: %@", response.errMsg);
                       //显示网络连接错误, 则选取数据库数据
                       finish(nil);
                   } else {
                       @try {
                           if ([response.data isKindOfClass:[NSDictionary class]]) {
                               NSDictionary *cityDatas = response.data;
                               CityElem *elem = [[CityElem alloc] init];
                               elem.cityId = [[cityDatas objectForKey:@"city_id"] integerValue];
                               elem.cityName = [cityDatas objectForKey:@"city_name"];
                               recommendCity = elem;
                               finish(elem);
                           }
                       } @catch (NSException *exception) {
                            finish(nil);
                       } @finally {
                           
                       }
                       
                }
          }
     ];
}

+(void)getCityListOrderedRemote:(BOOL)localEmpty finish:(void (^)(NSArray*))finish
{
    //获取当前时间戳
    NSDate *now = [NSDate date];
    NSInteger nowTS = [now timeIntervalSince1970];
    
    //如果上次更新时间在2小时以内，则不从服务端更新
    if (lastRefreshTime + 3600 * 2 > nowTS && !localEmpty) {
        finish(nil);
        return;
    }
    NSDictionary *requestParam = @{};
    [AppClient action:@"get_support_city"
            withParams:requestParam
                finish:^(HttpResponse* response) {
                    if (response.code != 0) {
                        NSLog(@"Http response error: %@", response.errMsg);
                        finish(nil);
                    } else {
                        @try {
                            [City delettable];
                            NSArray *cityDatas = response.data;
                            NSInteger sort = 0;
                            NSMutableArray *cityList = [[NSMutableArray alloc] init];
                            for (NSDictionary *cityInfo in cityDatas) {
                                CityElem *elem = [[CityElem alloc] init];
                                elem.cityId = [(NSNumber *)[cityInfo objectForKey:@"city_id"] integerValue];
                                elem.cityName = (NSString *)[cityInfo objectForKey:@"city_name"];
                                elem.firstLetter = (NSString *)[cityInfo objectForKey:@"first_char"];
                                elem.domain = (NSString *)[cityInfo objectForKey:@"domain"];
                                elem.createTime = sort;
                                [City addCityInfo:elem];
                                [cityList addObject:elem];
                                sort ++;
                            }
                            NSDictionary *dict= @{
                                                  @"city":[cityList objectAtIndex:0]
                                                  };
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"CityChanged" object:nil userInfo:dict];
                            lastRefreshTime = [now timeIntervalSince1970];
                            
                            finish(cityList);
                        } @catch (NSException *exception) {
                                finish(nil);
                        } @finally {
                            
                        }
                        
                    }
                }
        ];
    
}

@end
