//
//  BizMySaleVehicle.h
//  HCBuyerApp
//
//  Created by 张熙 on 15/11/10.
//  Copyright © 2015年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vehicle.h"
@interface BizMySaleVehicle : NSObject
+ (void)getMySaleVehicleDataWithPhoneNum:(NSString*)phoneNum Finish:(void (^)(NSArray *, NSInteger))finish;
+ (void)getVehicleDetailWithVehicleid:(NSInteger)vehicleid finish:(void (^)(Vehicle *, NSInteger))finish;
@end
