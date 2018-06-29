//
//  Coupon.h
//  HCBuyerApp
//
//  Created by wj on 15/7/27.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Coupon : NSObject

@property (nonatomic) NSString *cashValue;
@property (nonatomic) NSInteger type;

@property (strong, nonatomic) NSString *couponTitle;
@property (nonatomic) NSInteger startTime;
@property (nonatomic) NSInteger endTime;
@property (nonatomic) NSInteger enumId;
@property (strong, nonatomic) NSString *couponId;
@property (strong, nonatomic) NSString *couponCode;
@property (nonatomic) NSInteger status;
@property (strong, nonatomic) NSString *desc;
@property (nonatomic)NSInteger phoneNumber;
@property (nonatomic,strong)NSString *url;

- (BOOL)isValid;
- (NSString *)convertTimestamp2String:(NSInteger)ts;

-(instancetype)initWithCouponData:(NSDictionary *)data;
@end
