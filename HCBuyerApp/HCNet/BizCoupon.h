//
//  BizCoupon.h
//  HCBuyerApp
//
//  Created by wj on 15/8/4.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Coupon.h"

@interface BizCoupon : NSObject

+(void)getNewCouponRecord:(NSInteger)type  get:(void (^)(NSArray *, NSInteger))finish;

+(void)appendHistoryRecordForlist:(NSInteger)type  get:(NSArray *)list byfinish:(void (^)(NSArray *, NSInteger))finish;


//+(void)getCouponDetail:(NSString *)couponId byfinish:(void (^)(Coupon *))finish;

+(void)checkNewCounpon:(void(^)(NSInteger))finish;


+(void)updateLastFetchTime;

+(void)postNew:(NSString *)couponNumber show:(void (^)(NSString *))strMessg CouponRequest:(void (^)(NSArray *, NSInteger))finishe;
+(void)postUserCoupon:(NSString *)coupon_id trabs_id:(NSString *)trans_id CouponRequest:(void(^)(NSString*,NSInteger))finish;


//获取卖家订单接口
+(void)postBuy:(NSString *)phone CouponRequest:(void (^)(NSArray *, NSInteger))finishe;

+ (void)postBuyList:(NSString *)phone append:(NSArray*)list CouponRequest:(void (^)(NSArray *, NSInteger))finishe;


@end
