//
//  BizNewViehicle.h
//  HCBuyerApp
//
//  Created by 张熙 on 16/5/31.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataFilter.h"
#import "VehicleSourceUpdateStatus.h"
@interface BizNewViehicle : NSObject
+(void)getTodayNewVehicleSourceRemote:(NSMutableDictionary*)query  sortDic:(NSMutableDictionary*)sort byfinish:(void (^)(NSArray *, NSInteger,NSInteger))finish ;

+(void)appendTodayHistoryVehicleSource:(NSArray *)list query:(NSMutableDictionary*)query  sortDic:(NSMutableDictionary*)sort byfinish:(void (^)(NSArray *, NSInteger,NSInteger))finish;
@end
