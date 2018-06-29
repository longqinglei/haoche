//
//  User.h
//  HCBuyerApp
//
//  Created by wj on 14-10-30.
//  Copyright (c) 2014年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic) NSInteger userId;

@property (nonatomic ,strong) NSString *clientId;

@property (strong, nonatomic) NSString *userPhone;

+(User *)getUserInfo;

+ (void)createTable;

//+ (BOOL)insertUserClientId:(NSString *)clientId;

+ (void)updateUserId:(NSInteger)userId clientId:(NSString *)clientId;

+ (NSInteger)getUserId:(NSString *)clientId;

+ (User *)getUserInfoById:(NSInteger)userId;

+ (void)addUserPhone:(NSString *)userPhone;

+(void)setUserInfo:(User *)user;

@end
