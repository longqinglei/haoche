//
//  BizUserRecommendVehicle.h
//  HCBuyerApp
//
//  Created by wj on 15/6/26.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BizUserRecommendVehicle : NSObject

//+(void)getNewRecommendRecord:(BOOL)forceUpdate finish:(void (^)(NSArray *, NSInteger))finish;


//获取最新的推荐车源
+(void)getNewVehicleSourceRemote:(void (^)(NSArray *, NSInteger))finish;

//获取历史数据, 并和当前的list 合并
//+(void)appendHistoryVehicleSource:(NSArray *)list byfinish:(void (^)(NSArray *, NSInteger))finish;


+(void)checkNewUserRecommend:(void(^)(BOOL,NSInteger))finish;


+(void)updateLastFetchTime;


+(void)requestnumdata:(void(^)(NSDictionary*,NSInteger))finish;
@end
