//
//  User.m
//  HCBuyerApp
//
//  Created by wj on 14-10-30.
//  Copyright (c) 2014年 haoche51. All rights reserved.
//

#import "User.h"
#import "DBHandler.h"

@implementation User
static  NSString *tableName = @"user";

static NSString *userKey = @"HC_USER"; 
+ (void)updateUserId:(NSInteger)userId clientId:(NSString *)clientId
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:userKey]) {
        User * user = [[User alloc] init];
        user.userId = userId;
        user.clientId = clientId;
        [self setUserInfo:user];
    } else {
        User *user = [self getUserInfo];
        user.clientId = clientId;
        user.userId = userId;
        [self setUserInfo:user];
    }
}

+(void)addUserPhone:(NSString *)userPhone
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:userKey]) {
        User *user = [self getUserInfo];
        user.userPhone = userPhone;
        [self setUserInfo:user];
    }
}

+ (NSInteger)getUserId:(NSString *)clientId
{
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:userKey]) {
        //兼容原来数据库中存储
        NSInteger userId = 0;
        NSString *sql = [NSString stringWithFormat:@"select userid, clientid from %@ where clientid='%@'", tableName, clientId];
        if (clientId == nil) {
            //如果当前clientid不存在（因为异步获取的原因可能启动时无法及时拿到），则尝试从本地数据库中的userid
            sql = [NSString stringWithFormat:@"select userid, clientid from %@ order by id asc limit 1", tableName];
        }
        NSLog(@"%@", sql);
        FMDatabase *db = [DBHandler getDBHandle];
        [db open];
        FMResultSet *rs = [db executeQuery:sql];
        if ([rs next]) {
            User *user = [[User alloc] init];
            userId = [rs intForColumn:@"userid"];
            user.userId = userId;
            user.clientId = [rs stringForColumn:@"clientid"];
            [self setUserInfo:user];
        }
        [rs close];
        [db close];
        return userId;
    } else {
        User *user = [self getUserInfo];
        return user.userId;
    }
}

+(User *)getUserInfo
{
    if (![[NSUserDefaults standardUserDefaults]objectForKey:userKey]) {
        return nil;
    } else {
        NSArray *data = [[NSUserDefaults standardUserDefaults] objectForKey:userKey];
        User *user = [[User alloc] init];
        user.userId = [[data HCObjectAtIndex:0] integerValue];
        
        user.clientId = [data HCObjectAtIndex:1];
        if ([data count] == 3) {
            user.userPhone = [data HCObjectAtIndex:2];
        }
        return user;
    }
}

+(void)setUserInfo:(User *)user
{
    NSMutableArray *data = [[NSMutableArray alloc] initWithArray:@[[NSNumber numberWithInteger:user.userId], user.clientId]];
    if (user.userPhone && [user.userPhone length] > 0) {
        [data addObject:user.userPhone];
    }
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:userKey];
}

+ (User *)getUserInfoById:(NSInteger)userId
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:userKey]) {
        return nil;
    } else {
        NSArray *data = [[NSUserDefaults standardUserDefaults] objectForKey:userKey];
        User *user = [[User alloc] init];
        user.userId = [[data HCObjectAtIndex:0] integerValue];
        user.clientId = [data HCObjectAtIndex:1];
        if ([data count] == 3 && [data HCObjectAtIndex:2] != nil) {
            user.userPhone = [data HCObjectAtIndex:2];
        }
        return user;
    }
}


+ (void)createTable
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:tableName ofType:@"sql"];
    NSError *error;
    NSString *sql = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    FMDatabase *db = [DBHandler getDBHandle];
    [db open];
    BOOL ret = [db executeUpdate:sql];
    if (ret) {
        NSLog(@"create table %@ success", tableName);
    } else {
        NSLog(@"create table failed : %@", db.lastErrorMessage);
    }
    [db close];
}

@end
