//
//  BizVehicleSourceCompare.h
//  HCBuyerApp
//
//  Created by wj on 15/7/14.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BizVehicleSourceCompare : NSObject

+(void)getComparedResultBetween:(NSInteger)id1 andId2:(NSInteger)id2 finish:(void (^)(NSArray *))finish;

@end
