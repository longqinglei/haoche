//
//  BizLogin.m
//  HCBuyerApp
//
//  Created by wj on 15/8/4.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "BizLogin.h"
#import "AppClient.h"
#import "BizUser.h"

@implementation BizLogin

+(void)loginWithPhone:(NSString *)phone andVcode:(NSString *)vcode finish:(void(^)(BOOL))finish
{
    NSDictionary *requestParam = @{
                                   @"phone" : phone,
                                   @"vcode" : vcode,
                                   @"user_id" : [NSNumber numberWithInteger:[BizUser getUserId]],
                                   };
    [AppClient action:@"login"
           withParams:requestParam
               finish:^(HttpResponse* response) {
                   if (response.code != 0) {
                       NSLog(@"Http response error: %@", response.errMsg);
                       finish(NO);
                   } else {
                       NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
                       if ([response.data isKindOfClass:[NSDictionary class]]) {
                           [accountDefaults setObject:[response.data objectForKey:@"uid"] forKey:@"userDefaultsUid"];
                       }
                       finish(YES);
                   }
               }
     ];
}

@end
