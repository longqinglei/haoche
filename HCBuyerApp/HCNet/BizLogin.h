//
//  BizLogin.h
//  HCBuyerApp
//
//  Created by wj on 15/8/4.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BizLogin : NSObject

+(void)loginWithPhone:(NSString *)phone andVcode:(NSString *)vcode finish:(void(^)(BOOL))finish;
@end
