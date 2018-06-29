//
//  BizBrand.h
//  HCBuyerApp
//
//  Created by wj on 15/3/13.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BizBrandSeries : NSObject

//异步从服务端获取已经排序的品牌列表。按照首字符排序 (分组： 热门品牌列表 + 正常列表)
+(void)getBrandSeriesListOrderedRemote:(NSInteger)cityId localEmpty:(BOOL)localEmpty byfinish:(void (^)(NSArray*))finish;


//从本地获取
+(NSArray *)getBrandSeriesListOrderedLocal:(NSInteger)cityId;

//获取增量的车系数据
+(void)getIncrementSeriesData:(void (^)(BOOL))finish;
@end
