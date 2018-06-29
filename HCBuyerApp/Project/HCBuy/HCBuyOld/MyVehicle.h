//
//  MyVehicle.h
//  HCBuyer
//
//  Created by 张熙 on 15/8/22.
//  Copyright (c) 2015年 张熙. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface List : NSObject

@property (nonatomic,strong) NSString* uid;//用户id
@property (nonatomic,strong) NSString* phone;//手机号

@property (nonatomic,strong) NSString* price_high;//价格区间
@property (nonatomic,strong) NSString* price_low;

@property (nonatomic,strong) NSString* year_high;//年限区间
@property (nonatomic,strong) NSString* year_low;

@property (nonatomic,strong) NSString* miles_high;//公里区间
@property (nonatomic,strong) NSString* miles_low;

@property (nonatomic) NSString* class_id;//车系
@property (nonatomic,strong) NSString * structure;// 车身结构

@property (nonatomic,strong) NSString* emission_high;//排量区间
@property (nonatomic,strong) NSString* emission_low;

@property (nonatomic,strong) NSString* es_standard;//排放标准

@property (nonatomic,strong) NSString* brand_id;//品牌id
@property (nonatomic,strong) NSString* geerbox;//手动自动挡

@property (nonatomic,strong) NSString*_id;
@property (nonatomic,strong) NSString *cityid;
@end


@interface MyVehicle : NSObject
+ (void)createTable;
+ (void)addOrderVihicleList:(List *)vehicle;
+ (NSArray *)getMyVehicleList;
+(void)deleteOrderInfoFromOrderList:(int)brand_id;
+(void)delettable;
+(void)getDicDataFrom:(NSDictionary*)dict;
@end






/*"params" : {
 . uid  //用户id//必填
 . phone //手机->必填
 • brand_id // 品牌
 • class_id //车系
 • price_low // 价格区间
 • price_high
 • miles_low // 公里数区间
 • miles_high
 •year_low //年限区间
 • year_high
 • gearbox//变数箱
 • emission_low // 排量区间
 • emission_high
 • es_standard // 排放标准
 • structure， // 车身结构);
 }*/