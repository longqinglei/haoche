//
//  Coupon.m
//  HCBuyerApp
//
//  Created by wj on 15/7/27.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "Coupon.h"

@implementation Coupon

-(NSString *)convertTimestamp2String:(NSInteger)ts
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:ts];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY.MM.dd"];
    NSString *timeStr = [formatter stringFromDate:date];
    return timeStr;
}

-(BOOL)isValid
{
    NSDate *now = [NSDate date];
    NSInteger nowTS = [now timeIntervalSince1970];
    return self.endTime > nowTS;
}

-(instancetype)initWithCouponData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            @try {
                self.enumId = [[data objectForKey:@"id"] integerValue];//
                self.couponId = [data objectForKey:@"coupon_id"];//
                self.startTime = [[data objectForKey:@"from_time"] integerValue];//
                self.endTime = [[data objectForKey:@"expire_time"] integerValue];//
                self.couponTitle = [data objectForKey:@"title"];//
                self.cashValue = [data objectForKey:@"amount"];//
                self.phoneNumber = [[data objectForKey:@"phone"] integerValue];//
                self.url = [data objectForKey:@"url"];
                if ([data objectForKey:@"status"]) {//
                    self.status = [[data objectForKey:@"status"]integerValue];
                }
                if ([data objectForKey:@"type"]) {//
                    self.type = [[data objectForKey:@"type"] integerValue];
                    if (self.type == 0) self.type = 1;//for test
                }
                if ([data objectForKey:@"category"]) {
                    self.desc = [data objectForKey:@"category"];//
                }
                if ([data objectForKey:@"code"]) {
                    self.couponCode = [data objectForKey:@"code"];//
                }

            } @catch (NSException *exception) {
                
            } @finally {
                
            }
        }
    }
    return self;
}

@end
