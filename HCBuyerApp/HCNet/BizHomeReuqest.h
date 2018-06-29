//
//  BIzHomeReuqest.h
//  HCBuyerApp
//
//  Created by haoche51 on 15/12/29.
//  Copyright © 2015年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"
#import "StoreModel.h"
@interface BizHomeReuqest : NSObject


//首页的banner图片
//+ (void)getHome_city_dataByLat:(NSInteger )city byfinish:(void(^)(Promotion *,NSArray *,StoreModel *,NSArray*,NSString*,NSMutableArray*,NSString*,NSInteger code))finish;

+(void)getHomeCityData:(NSInteger )cityid byfinish:(void(^)(NSInteger,NSArray*,NSArray*,NSString*,NSString*,NSString*,NSArray*,NSArray*,NSArray*,Promotion *,NSDictionary *,int))finish;
+ (void)gethome_other_databyfinish:(void(^)(NSArray*,NSDictionary *,NSDictionary *,NSArray *,NSArray *,NSArray *,NSMutableArray*,NSInteger))finish;

//+ (void)getHome_todayNew_vehiclepage:(NSInteger )page back:(void (^)(NSInteger, NSArray*,NSString *,NSString *))finish;

+ (void)getHomeForumDataWithPageNum:(int)pageNum byfinish:(void(^)(NSArray *,NSInteger))finish;


+(void)getHomeCityData:(CGFloat )lat lng:(CGFloat)lng finish:(RequestFinish)finish;

@end
