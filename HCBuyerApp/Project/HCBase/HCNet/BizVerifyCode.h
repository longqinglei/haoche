//
//  BizVerifyCode.h
//  HCBuyerApp
//
//  Created by wj on 15/8/4.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BizVerifyCode : NSObject


+(void)sendVerifyCode:(NSString *)phone finish:(void (^)(BOOL))finish;


+(void)verificationCode:(NSString *)phone finish:(void (^)(BOOL))finish;
@end
