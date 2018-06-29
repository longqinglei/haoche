//
//  BizUser.h
//  HCBuyerApp
//
//  Created by wj on 15/3/12.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BizUser : NSObject

//用户注册
+(void)registerUser:(NSString *)_clientId userid:(NSString*)user_id byfinish:(void (^)(BOOL))finish;

//获取用户id
+(NSInteger)getUserId;

+(NSString*)getUserType;
//更新版本号
//+(void)updateNewVersion;
+ (NSString *)getUserPhone;
@end
