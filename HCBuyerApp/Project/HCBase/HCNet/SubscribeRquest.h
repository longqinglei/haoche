//
//  SubscribeRquest.h
//  HCBuyerApp
//
//  Created by haoche51 on 15/8/20.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubscribeRquest : NSObject

//订阅列表
+(void)getSubscriber:(NSInteger)type tpye:(NSDictionary*)dict sub:(NSInteger)subId city:(NSInteger)cityId SourceInformation:(void (^)(NSArray *, NSInteger,NSInteger))finish;


+(void)append:(NSArray *)list tpye:(NSDictionary*)dict sub:(NSInteger)subId city:(NSInteger)cityId byfinish:(void (^)(NSArray *, NSInteger,NSInteger))finish;

//删除列表
+(void)deleteSub:(NSInteger)integer  scription:(void(^)(NSMutableArray *,NSInteger))finsh;

+(void)getTimeCar:(NSInteger)refresh_time city:(NSInteger)cityId subid:(NSInteger)subid SourceInformation:(void (^)(int, NSInteger))finish;
@end
