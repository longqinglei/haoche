//
//  City.h
//  HCBuyerApp
//
//  Created by wj on 14/11/27.
//  Copyright (c) 2014年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityElem : NSObject

@property (nonatomic) NSInteger cityId;
@property (strong, nonatomic) NSString *cityName;
@property (strong, nonatomic) NSString *firstLetter;
@property (strong, nonatomic) NSString *domain;

@property (nonatomic)NSInteger createTime;

@end


@interface City : NSObject

+(void)delettable;

+ (void)createTable;

+ (NSArray *)getCityList;

+ (void)addCityInfo:(CityElem *)elem;

+ (NSString *)getCityNameById:(NSInteger)cityId;

+ (NSDictionary *)getCityListGroupbyDomain;
@end
