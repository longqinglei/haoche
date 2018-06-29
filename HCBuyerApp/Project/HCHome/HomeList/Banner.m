//
//  Banner.m
//  HCBuyerApp
//
//  Created by wj on 15/5/9.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "Banner.h"
#import "DBHandler.h"

@implementation Banner

static  NSString *tableName = @"banner";

//try catch 添加
-(instancetype)initWithBannerData:(NSDictionary *)data{
    self = [super init];
    if (self) {
          if ([data isKindOfClass:[NSDictionary class]]) {
              @try {
                  self.pic_url = [NSString cutPicture:[data objectForKey:@"pic_url"] W:HCSCREEN_WIDTH*2 H:HCSCREEN_WIDTH/[[data objectForKey:@"pic_rate"] floatValue]*2];
                  self.link_url = (NSString *)[data objectForKey:@"link_url"];
                  self.title = (NSString *)[data objectForKey:@"title"];
                  self.share_image = (NSString *)[data objectForKey:@"share_image"];
                  if (!self.title) {
                      self.title = @"";
                  }
              } @catch (NSException *exception) {
                  
              } @finally {
                  
              }
        
        }
    }
    return self;
}

-(instancetype)initWithTopSliderData:(NSDictionary *)data{
    self = [super init];
    if (self) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            @try {
                self.pic_url = [NSString cutPicture:[data objectForKey:@"pic_url"] W:HCSCREEN_WIDTH*2 H:HCSCREEN_WIDTH/[[data objectForKey:@"pic_rate"] floatValue]*2];
                self.link_url = (NSString *)[data objectForKey:@"link_url"];
                self.title = (NSString *)[data objectForKey:@"title"];
                if (!self.title) {
                    self.title = @"";
                }
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
            
        }
    }
    return self;
    
    
}
//+ (NSArray *)getBannerList:(NSInteger)cityId
//{
//    NSMutableArray *ret = [[NSMutableArray alloc] init];
//    NSString *sql = [NSString stringWithFormat:@"select * from %@ where city_id = %ld", tableName, (long)cityId];
//    FMDatabase *db = [DBHandler getDBHandle];
//    [db open];
//    FMResultSet *rs = [db executeQuery:sql];
//    while ([rs next]) {
//        Banner *banner = [[Banner alloc] init];
//        banner.bannerImgaeUrl = [rs stringForColumn:@"banner_img_url"];
//        banner.redirect_url = [rs stringForColumn:@"banner_url"];
//        banner.cityId = [rs intForColumn:@"city_id"];
//        [ret addObject:banner];
//    }
//    [rs close];
//    [db close];
//    return ret;
//}

//+ (void)batchUpdateBannerList:(NSArray *)bannerData forCity:(NSInteger)cityId;
//{
//    //删除历史数据
//    NSString *delSql = [NSString stringWithFormat:@"delete from %@ where city_id = %ld", tableName, (long)cityId];
//    FMDatabase *db = [DBHandler getDBHandle];
//    [db open];
//    [db executeUpdate:delSql];
//    //批量插入
//    for (Banner *banner in bannerData) {
//        NSString *insertSql = [NSString stringWithFormat:@"insert into %@(banner_img_url, banner_url, city_id) values ('%@', '%@', %ld)", tableName, banner.bannerImgaeUrl, banner.redirect_url, (long)cityId];
//        [db executeUpdate:insertSql];
//    }
//    [db close];
//}

//+ (void)createTable
//{
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:tableName ofType:@"sql"];
//    NSError *error;
//    NSString *sql = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
//    FMDatabase *db = [DBHandler getDBHandle];
//    [db open];
//    BOOL ret = [db executeUpdate:sql];
//    if (ret) {
//        NSLog(@"create table %@ success", tableName);
//    } else {
//        NSLog(@"create table failed : %@", db.lastErrorMessage);
//    }
//    [db close];
//}

@end
