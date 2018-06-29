//
//  BizLowPriceVehicleSource.h
//  HCBuyerApp
//
//  Created by wj on 15/6/24.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataFilter.h"
#import "VehicleSourceUpdateStatus.h"

@interface BizLowPriceVehicleSource : NSObject

//+(void)getNewVehicleSourceForHomePage:(BOOL)localEmpty cityId:(NSInteger)cityId byfinish:(void (^)(NSArray *, NSInteger))finish dataFilter:(DataFilter *)filter;

////获取最新的车源
//+(void)getNewVehicleSourceRemote:(NSInteger)cityId byfinish:(void (^)(NSArray *, NSInteger))finish dataFilter:(DataFilter *)filter;

////获取历史数据, 并和当前的list 合并
//+(void)appendHistoryVehicleSource:(NSArray *)list cityId:(NSInteger)cityId byfinish:(void (^)(NSArray *, NSInteger))finish dataFilter:(DataFilter *)filter;
//
+(void)getNewVehicleSourceRemote:(NSMutableDictionary*)query  sortDic:(NSMutableDictionary*)sort byfinish:(void (^)(NSArray *, NSInteger,NSInteger))finish ;

+(void)appendHistoryVehicleSource:(NSArray *)list query:(NSMutableDictionary*)query  sortDic:(NSMutableDictionary*)sort byfinish:(void (^)(NSArray *, NSInteger,NSInteger))finish;

@end
