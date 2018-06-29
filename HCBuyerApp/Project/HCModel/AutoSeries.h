//
//  AutoSeries.h
//  HCBuyerApp
//
//  Created by wj on 15/5/13.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AutoSeries : NSObject

@property (nonatomic) NSInteger seriesId;
@property (nonatomic) NSString *seriesName;

+ (void)addSeriesInfo:(AutoSeries *)series;

+ (NSArray *)getSeriesNamesByIdGroup:(NSString *)seriesIdGroup;
+ (NSString *)getSeriesNamesByseries_id:(NSInteger)series_id;

+(void)createTable;

@end
