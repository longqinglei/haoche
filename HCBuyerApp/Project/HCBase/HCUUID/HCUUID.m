//
//  HCUUID.m
//  HCBuyerApp
//
//  Created by 张熙 on 15/12/28.
//  Copyright © 2015年 haoche51. All rights reserved.
//

#import "HCUUID.h"

#import "SSKeychain.h"
@implementation HCUUID
+(NSString *)getHCUUID{
    NSString *retrieveuuid = [SSKeychain passwordForService:@"com.haoche51.HCBuyerApp" account:@"uuid"];
    //第一次下载程序的时候存储
    if (retrieveuuid == nil || [retrieveuuid isEqualToString:@""]) {
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        assert(uuid!=NULL);
        CFStringRef(uuidStr) = CFUUIDCreateString(NULL, uuid);
        retrieveuuid = [NSString stringWithFormat:@"%@",uuidStr];
        [SSKeychain setPassword:retrieveuuid forService:@"com.haoche51.HCBuyerApp" account:@"uuid"];
        CFRelease(uuid);
        CFRelease(uuidStr);
        }
    return [retrieveuuid md5];
}
@end
