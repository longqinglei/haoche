//
//  BizVehicleSource.h
//  HCBuyerApp
//
//  Created by wj on 15/3/13.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataFilter.h"
#import "VehicleSourceUpdateStatus.h"



@interface BizVehicleSource : NSObject

//+(NSArray *)getNewVeicleSourceFromLocal:(NSInteger)cityId;

//订阅接口
+(void)getNeSubscribe:(NSInteger)cityId  Parame:(NSMutableDictionary *)dict  show:(void (^)(NSString *))strMessg  byfinish:(void (^)(NSArray *, NSInteger))finish dataFilter:(DataFilter *)filter;

//new
+(void)getVehicelSource:(NSMutableDictionary*)dic sortDic:(NSMutableDictionary*)sort byfinish:(void (^)(NSArray *,NSArray*, NSInteger,NSInteger,NSInteger))finish;

+(void)appendHistoryVehicleSource:(NSArray *)list query:(NSMutableDictionary*)dic sortDic:(NSMutableDictionary*)sort byfinish:(void (^)(NSArray *, NSInteger,NSInteger,NSInteger))finish;

+(void)getVehiclesNumQuery:(NSMutableDictionary*)dic suitable:(NSInteger)type byfinish:(void (^)(NSInteger,NSInteger))finish;


+(void)getZhiyingdianVehiclesNumQuery:(NSMutableDictionary*)dic byfinish:(void (^)(NSInteger,NSInteger))finish;

////首页推广位置
//+(void)HomePromotion:(NSString *)Promotion backRequestParam:(void(^)(NSInteger,NSString *,NSString *,int))finish;
//
//////配置文件
//+(void)mViewController:(NSString *)Promotion backRequestParam:(void(^)(NSInteger,NSDictionary *))finish;

////首页版本检测
//+(void)HomeVersionDetectionBackRequestParam:(void(^)(NSInteger,int,NSArray*))finish;
//
+(void)HomeInterlocutionRequestParam:(void(^)(NSInteger,int,NSArray*,NSString *))finish;

+(void)getNewVehicleNumQuery:(NSMutableDictionary*)dic byfinish:(void (^)(NSInteger,NSInteger))finish;

@end
