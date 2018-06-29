//
//  MyCouponVehicle.h
//  HCBuyerApp
//
//  Created by haoche51 on 15/9/7.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Coupon.h"
#import "DBHandler.h"
@interface MyCouponVehicle : NSObject
+ (void)createTable;
+(Coupon *)buildVehicleByFMResult:(FMResultSet *)s;
+(NSArray *)getVehicleSourceList;
+ (void)insertVehicle:(Coupon *)vehicle;
+(void)delettable;
+(void)getOrderFrom:(NSDictionary *)s;
@end
