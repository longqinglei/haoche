//
//  BizVehicleSourceCompare.m
//  HCBuyerApp
//
//  Created by wj on 15/7/14.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "BizVehicleSourceCompare.h"

#import "AppClient.h"

@implementation BizVehicleSourceCompare

+(void)getComparedResultBetween:(NSInteger)id1 andId2:(NSInteger)id2 finish:(void (^)(NSArray *))finish
{
    NSDictionary *requestParam = @{
                                   @"origin_vehicle_source_id" : [NSNumber numberWithInteger:id1],
                                   @"compare_vehicle_source_id": [NSNumber numberWithInteger:id2],
                                   };
    [AppClient action:@"vehicle_source_compare"
           withParams:requestParam
               finish:^(HttpResponse* response) {
                   if (response.code != 0) {
                       NSLog(@"Http response error: %@", response.errMsg);
                       finish(nil);
                   } else {
                       if ([response.data isKindOfClass:[NSArray class]]) {
                           NSArray* vehicleDatas = response.data;
                           finish(vehicleDatas);
                       }
                   }
               }
     ];
}

@end
