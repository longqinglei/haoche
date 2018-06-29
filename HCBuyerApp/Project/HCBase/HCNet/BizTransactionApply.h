//
//  BizTransactionApply.h
//  HCBuyerApp
//
//  Created by wj on 15/8/3.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BizTransactionApply : NSObject

+(void)applyForUserPhone:(NSString *)phone andCityId:(NSInteger)cityId andVehicleSourceId:(NSInteger)vehicleSourceId finish:(void (^)(BOOL,NSString*))finish;

@end
