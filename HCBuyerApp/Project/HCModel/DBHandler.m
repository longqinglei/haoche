//
//  DBHandler.m
//  HCBuyerApp
//
//  Created by wj on 14-10-21.
//  Copyright (c) 2014年 haoche51. All rights reserved.
//

#import "DBHandler.h"

@implementation DBHandler

static NSString *dName = @"ddsdsdd1v1.sqlite";
static  NSString *dbName = @"haoche51v1.sqlite";
static  FMDatabase* db = nil;

+ (FMDatabase *)getDBHandle
{
    if (!db) {
        NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [filePath HCObjectAtIndex:0];
        NSLog(@"dbpath: %@", documentPath);
        NSString* dbpath = [documentPath stringByAppendingPathComponent:dbName];
        db = [FMDatabase databaseWithPath:dbpath];
    }
    return db;
}

+ (void)dropDB
{
    NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [filePath HCObjectAtIndex:0];
    NSString* dbpath = [documentPath stringByAppendingPathComponent:dbName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL ret = [fileManager removeItemAtPath:dbpath error:nil];
    if (ret) {
        NSLog(@"drop db : %@ success", dbpath);
    } else {
        NSLog(@"error for drop db");
    }
}

+ (FMDatabase *)getDBhhh
{
    if (!db) {
        NSArray *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [filePath HCObjectAtIndex:0];
        NSString* dbpath = [documentPath stringByAppendingPathComponent:dName];
        db = [FMDatabase databaseWithPath:dbpath];
    }
    return db;
}

@end
