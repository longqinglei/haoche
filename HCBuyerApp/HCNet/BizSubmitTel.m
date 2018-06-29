//
//  BizSubmitTel.m
//  HCBuyerApp
//
//  Created by 张熙 on 15/11/10.
//  Copyright © 2015年 haoche51. All rights reserved.
//

#import "BizSubmitTel.h"
#import "AppClient.h"
#import "BizCity.h"
@implementation BizSubmitTel
+(void)getSaleDataByFinish:(void (^)(NSDictionary *, NSInteger))finish{
    NSDictionary *requestParam = @{
                                   @"city_id" : [NSNumber numberWithInteger:[BizCity getCurCity].cityId],
                                   
                                   };
    [AppClient action:@"sell_vehicle"
           withParams:requestParam
               finish:^(HttpResponse* response) {
                   if (response.code != 0) {
                       NSLog(@"Http response error: %@", response.errMsg);
                       finish(nil,response.code);
                   } else {
                       finish(response.data,response.code);
                   }
               }
     ];
}
+ (void)submitTelWithphone:(NSString*)telenum byFinish:(void (^)(NSDictionary *, NSInteger, NSString* ))finish{
    NSDictionary *requestParam = @{
                                   @"city_id" : [NSNumber numberWithInteger:[BizCity getCurCity].cityId],
                                   @"phone" :telenum,
                                   @"source":(NSNumber*)[NSNumber numberWithInt:21]
                                   };
    [AppClient action:@"apply_sell"
           withParams:requestParam
               finish:^(HttpResponse* response) {
                   if (response.code != 0) {
                       finish(nil,response.code,response.errMsg);
                   } else {
                       finish(response.data,response.code,response.errMsg);
                   }
               }
     ];
}
@end
