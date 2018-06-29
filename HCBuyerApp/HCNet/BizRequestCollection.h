//
//  BizRequestCollection.h
//  HCBuyerApp
//
//  Created by haoche51 on 15/12/28.
//  Copyright © 2015年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BizRequestCollection : NSObject

//2.3版本接口

//点击收藏接口 否  //获取是否收藏  是
+(void)requestCollection:(NSInteger)vehicle_source_id byfinish:(void (^)(NSString *, NSInteger))finish reture:(BOOL)isReture;
+(void)requestObtainCollection:(NSInteger)vehicle_source_id byfinish:(void (^)(NSInteger, int))finish;

//收藏数据展示接口
+(void)requestCollection_list:(NSInteger )page back:(void (^)(NSInteger, NSArray*,NSString *))finish;

@end
