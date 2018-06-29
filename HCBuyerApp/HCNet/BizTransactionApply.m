//
//  BizTransactionApply.m
//  HCBuyerApp
//
//  Created by wj on 15/8/3.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "BizTransactionApply.h"
#import "AppClient.h"

@implementation BizTransactionApply

+(void)applyForUserPhone:(NSString *)phone andCityId:(NSInteger)cityId andVehicleSourceId:(NSInteger)vehicleSourceId finish:(void (^)(BOOL,NSString* ))finish
{
    NSDictionary *requestParam = @{
                                   @"city_id" : [NSNumber numberWithInteger:cityId],
                                   @"buyer_phone" : phone,
                                   @"vehicle_source_id" : [NSNumber numberWithInteger:vehicleSourceId],
                                   @"type" : @1,
                                   };
    [AppClient action:@"add_buyer_lead"
           withParams:requestParam
               finish:^(HttpResponse* response) {
                   if (response.code != 0) {
                       NSLog(@"Http response error: %@", response.errMsg);
                       finish(NO,response.errMsg);
                   } else {
                       finish(YES,response.errMsg);
                   }
               }
     ];
}

@end
