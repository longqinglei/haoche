//
//  HCLogin.m
//  HCBuyerApp
//
//  Created by 张熙 on 16/1/21.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "HCLogin.h"
static HCLogin * login = nil;
@implementation HCLogin


+(HCLogin*)standLog{
    if (login == nil) {
        login  =[[self alloc]init];
    }
    return login;

}



-(BOOL)isLog
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"hc_user_phone"]) {
        return YES;
    }else{
        return NO;
    }
}

@end
