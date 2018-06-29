//
//  BizUser.m
//  HCBuyerApp
//
//  Created by wj on 15/3/12.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "BizUser.h"
#import "User.h"
#import "AppClient.h"
#import <AdSupport/ASIdentifierManager.h>
#import "HCUUID.h"
#import "SensorsAnalyticsSDK.h"
@implementation BizUser

static NSString *clientId = nil;
static NSString *bd_userid = nil;


+(void)registerUser:(NSString *)_clientId userid:(NSString*)user_id byfinish:(void (^)(BOOL))finish
{
    clientId = _clientId;
    bd_userid = user_id;
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"HCUSER_ID"]||[[[NSUserDefaults standardUserDefaults]objectForKey:@"HCUSER_ID"]intValue]==0) {
        [BizUser registerUserToServer:nil];
    }
    finish(YES);
}


+(NSString*)getUserType{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"StatUser"]isEqualToString:@"hasclose"]) {
        return @"hasclose";
    }else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"StatUser"]isEqualToString:@"noclose"]){
        return @"noclose";
    }else{
        return @""; 
    }
   
}
+(NSInteger)getUserId
{
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"HCUSER_ID"]) {
       return  0;
    } else {
        return [[[NSUserDefaults standardUserDefaults]objectForKey:@"HCUSER_ID"] integerValue];
    }
    return 0;
}
+ (NSString *)getUserPhone{
    if ([User getUserInfo].userPhone) {
        return [User getUserInfo].userPhone;
    }else{
        if (![[NSUserDefaults standardUserDefaults]objectForKey:@"hc_user_phone"]) {
            return  nil;
        } else {
            return [[NSUserDefaults standardUserDefaults]objectForKey:@"hc_user_phone"];
        }
    }
    return nil;
}
//+(void)updateNewVersion
//{
//    //获取当前用户id
//    NSInteger userId = [self getUserId];
//    NSString *curClientId = clientId;
//    if (userId != 0) {
//        if (curClientId == nil) {
//            User *user = [User getUserInfoById:userId];
//            curClientId = user.clientId;
//        }
//        //提交新版本
//        NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//        NSDictionary *requestParam = @{
//                                       @"user_id" : [NSNumber numberWithInteger: userId],
//                                       @"client_id":curClientId,
//                                       @"platform":@2,
//                                       @"type" : @1,
//                                       @"version_code":version,
//                                       @"idfa" : idfa,
//                                       };
//        [AppClient action:@"update_user_info"
//               withParams:requestParam
//                   finish:^(HttpResponse* response) {
//                       if (response.code != 0) {
//                           NSLog(@"Http response error: %@", response.errMsg);
//                           //如果网络错误，则记录在当前配置里。下次启动的时候再尝试
//                           if (![[NSUserDefaults standardUserDefaults] boolForKey:NewVersionUnSync]) {
//                               [[NSUserDefaults standardUserDefaults] setBool:YES forKey:NewVersionUnSync];
//                           }
//                       } else {
//                           NSLog(@"update user app version success!");
//                           if ([[NSUserDefaults standardUserDefaults] boolForKey:NewVersionUnSync]) {
//                               [[NSUserDefaults standardUserDefaults] removeObjectForKey:NewVersionUnSync];
//                           }
//                       }
//                   }
//         ];
//    }
//}

+( void)registerUserToServer:(void (^)(BOOL))finish
{
    if (clientId == nil) {
        if (finish != nil) {
            finish(NO);
        }
        return ;
    }
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    if (!idfa) {
        idfa = @"";
    }
    
    
    NSDictionary *requestParam = @{
                                   @"bd_client_id":clientId,
                                   @"platform":@2,
                                   @"type" : @1,
                                   @"version_code" :[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                                   @"idfa" : idfa,
                                   @"bd_user_id":bd_userid,
                                   @"uuid":[HCUUID getHCUUID]
                                   };
    [AppClient action:@"user_insert"
           withParams:requestParam
               finish:^(HttpResponse* response) {
                   if (response.code != 0) {
                       NSLog(@"Http response error: %@", response.errMsg);
                       if (finish != nil) {
                           finish(NO);
                       }
                   } else {
                       @try {
                           if ([response.data isKindOfClass:[NSDictionary class]]) {
                               NSDictionary* userInfo = response.data;
                               if ([[userInfo objectForKey:@"user_id"]integerValue] != 0) {
                                   [User updateUserId:[[userInfo objectForKey:@"user_id"]integerValue] clientId:clientId];
                                   [[NSUserDefaults standardUserDefaults] setObject:[userInfo objectForKey:@"user_id"] forKey:@"HCUSER_ID"];
                               }
                           }

                       } @catch (NSException *exception) {
                           if (finish != nil) {
                               finish(NO);
                           }
                       } @finally {
                           
                       }
                       [[SensorsAnalyticsSDK sharedInstance] identify:[[NSUserDefaults standardUserDefaults]objectForKey:@"HCUSER_ID"]];
                   //  [[SensorsAnalyticsSDK sharedInstance] registerSuperProperties:@{@"UserId" : (NSNumber *)[NSNumber numberWithInteger:[BizUser getUserId]]}];
//                     [User updateUserId:[[userInfo objectForKey:@"userid"]integerValue] clientId:clientId];
//                     [[NSUserDefaults standardUserDefaults] setObject:[userInfo objectForKey:@"userid"] forKey:@"hc_user_id"];
                   }
               }
     ];
   
}

@end
