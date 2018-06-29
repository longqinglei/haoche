//
//  Brand.h
//  HCBuyerApp
//
//  Created by wj on 14-10-23.
//  Copyright (c) 2014年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrandSeries : NSObject
@property (strong, nonatomic) NSString *brandName;
@property (nonatomic) NSInteger brandId;
@property (nonatomic) NSInteger cityId;
@property (strong, nonatomic) NSString *brandFirstLetter;
@property (strong, nonatomic) NSString *seriesGroup;
@property (nonatomic) NSInteger isHot;
@property (nonatomic, strong) NSArray *seriesInfo;

+ (NSString*)getBrandNameByBrandId:(NSInteger)brandid;

+(NSArray *)getBrandSeriesList:(NSInteger)cityId;

+(NSArray *)getHotBrandSeriesList:(NSInteger)cityId;

+(void)batchInsertBrandSereisInfos:(NSArray *)list cityId:(NSInteger)cityId;

+(void)createTable;

@end
