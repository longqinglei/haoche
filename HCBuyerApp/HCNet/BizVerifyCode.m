//
//  BizVerifyCode.m
//  HCBuyerApp
//
//  Created by wj on 15/8/4.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "BizVerifyCode.h"
#import "AppClient.h"

@implementation BizVerifyCode

+(void)sendVerifyCode:(NSString *)phone finish:(void (^)(BOOL))finish
{
    NSDictionary *requestParam = @{
                                   @"phone" : phone,
                                   };
    [AppClient action:@"get_vcode"
           withParams:requestParam
               finish:^(HttpResponse* response) {
                   if (response.code != 0) {
                       NSLog(@"Http response error: %@", response.errMsg);
                       finish(NO);
                   } else {
                       finish(YES);
                   }
               }
     ];

}

+(void)verificationCode:(NSString *)phone finish:(void (^)(BOOL))finish{
  
    NSDictionary *params = @{
                                   @"phone" : phone,
                                   };
    [AppClient action:@"get_voice_code"
           withParams:params
               finish:^(HttpResponse* response) {
                   if (response.code != 0) {
                       finish(NO);
                   } else {
                       finish(YES);
                   }
               }
     ];
}

@end
