//
//  SubscriptionModelCar.h
//  HCBuyerApp
//
//  Created by haoche51 on 15/8/20.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubscriptionModelCar : NSObject

@property (nonatomic,strong)id price_low;
@property (nonatomic,strong)id price_high;
@property (nonatomic,strong)id ID;//车辆id
@property (nonatomic,strong)NSString *geerbox;
@property (nonatomic) NSInteger subID;
@property (nonatomic,strong)id miles_low;
@property (nonatomic,strong)id uid;
@property (nonatomic,strong)id class_id;
@property (nonatomic,strong)id es_standard;
@property (nonatomic,strong)id miles_high;
@property (nonatomic,strong) id city_id;
@property (nonatomic)int gearboxType;
@property (nonatomic,strong)NSString *country;
@property (nonatomic,strong)NSString *color;

@property (nonatomic,strong)id emission_low;
@property (nonatomic,strong)id emission_high;
@property (nonatomic,strong)id structure;

@property (nonatomic,strong)id year_low;
@property (nonatomic,strong)id year_high;


@property (nonatomic,strong)id brand_id;
//@property (nonatomic)id price_high;
//@property  (nonatomic)id price_low;



//主页
//











-(instancetype)initWithVehicleDataNew:(NSDictionary *)data;
//控制换行
//@property (nonatomic,strong)NSString *lineBreak;
@end
