//
//  HCMyHaveSeenVehicle.h
//  HCBuyerApp
//
//  Created by 张熙 on 15/9/7.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyHaveSeenVehicle.h"
@interface HCMyHaveSeenVehicleList : NSObject

@property (nonatomic,strong) NSString*comment;
@property (nonatomic,strong) NSString*coupon_amount;

@property (nonatomic,strong) NSString*coupon_type;
@property (nonatomic,strong) NSString*desc;

@property (nonatomic,strong) NSString*geerbox;
@property (nonatomic) NSInteger i_d;

@property (nonatomic,strong) NSString*image;
@property (nonatomic,strong) NSString*mile;

@property (nonatomic,strong) NSString*name;
@property (nonatomic,strong) NSString*phone;

@property (nonatomic,strong) NSString*place;
@property (nonatomic,strong) NSString*price;

@property (nonatomic,strong) NSString*register_time;
@property (nonatomic) NSInteger status;

@property (nonatomic,strong) NSString*time;
@property (nonatomic,strong) NSString*trans_status;

@property (nonatomic,strong) NSString*type;
@property (nonatomic,strong) NSString*vehicle_name;

@property (nonatomic,strong) NSString*vehicle_online;
@property (nonatomic,strong) NSString*vehicle_source_id;
@end


@interface HCMyHaveSeenVehicle : NSObject

+(void)createTable;
+(NSArray *)getVehicleSourceList;
+ (void)insertVehicle:(MyHaveSeenVehicle *)vehicle;
+(void)delettable;
+(void)getOrderFrom:(NSDictionary *)data;
//+(void)deleteOrderInfoFromOrderList:(int)brand_id;

@end
