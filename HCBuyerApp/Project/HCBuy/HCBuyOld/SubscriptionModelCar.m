//
//  SubscriptionModelCar.m
//  HCBuyerApp
//
//  Created by haoche51 on 15/8/20.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "SubscriptionModelCar.h"
#import "City.h"

@implementation SubscriptionModelCar

- (NSString *)isEqualTo:(NSDictionary *)data key:(NSString *)key
{
    if ([data objectForKey:key]==nil){
        return @"";
    }else if([[data objectForKey:key] isEqual:[NSNull null]]){
        return @"";
    }else if([data objectForKey:key]){
        return [data objectForKey:key];
    }else {
        return @"";
    }
}


-(instancetype)initWithVehicleDataNew:(NSDictionary *)data {
    self = [super init];
    if (self) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            @try {
                self.brand_id = [self isEqualTo:data key:@"brand_id"];
                self.price_low = [self isEqualTo:data key:@"price_low"];
                self.price_high = [self isEqualTo:data key:@"price_high"];
                self.uid = [self isEqualTo:data key:@"uid"];
                self.class_id = [self isEqualTo:data key:@"class_id"];
                self.es_standard = [self isEqualTo:data key:@"es_standard"];
                self.country = [self isEqualTo:data key:@"country"];
                self.color = [self isEqualTo:data key:@"color"];
                self.ID = [self isEqualTo:data key:@"id"];
                self.city_id = [self isEqualTo:data key:@"city_id"];
                
                // self.id_d = [self isEqualTo:data key:@"id"];
                
                self.miles_low = [self isEqualTo:data key:@"miles_low"];
                self.miles_high = [self isEqualTo:data key:@"miles_high"];
                //self.geerbox = [self isEqualTo:data key:@"geerbox"];
                self.gearboxType = [(NSNumber*)[self isEqualTo:data key:@"geerbox"]intValue];
                // 新添加的
                self.emission_low = [self isEqualTo:data key:@"emission_low"];
                self.emission_high = [self isEqualTo:data key:@"emission_high"];
                
                self.structure = [self isEqualTo:data key:@"structure"];
                
                self.year_low = [self isEqualTo:data key:@"year_low"];
                self.year_high = [self isEqualTo:data key:@"year_high"];
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
        }   
 }
    return self;
}

- (NSString*)geerbox
{
    switch (self.gearboxType) {
        case 1: return @"手动";
        case 2: return @"自动";
        case 3: return @"双离合";
        case 4: return @"手自一体";
        case 5: return @"无级变速";
    }
    return @"不限";
}

- (NSInteger)convertTimestamp:(NSInteger)year andMonth:(NSInteger)month
{
    NSString *dateStr = [[NSString alloc] initWithFormat:@"%4ld-%2ld-01 00:00:00", (long)year, (long)month];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:dateStr];
    return [date timeIntervalSince1970];
}

- (NSString *)getFixedSolutionImageUrl:(NSString *)imgUrl definedSolutionW:(NSInteger)solutionW solutionH:(NSInteger)solutionH
{
    
    NSString *temp;
    if ([imgUrl rangeOfString:@"?"].location != NSNotFound) {
        temp = [NSString stringWithFormat:@"%@&imageView2/2/w/%ld/h/%ld",imgUrl,(long)solutionW, (long)solutionH];
    }else{
        temp = [NSString stringWithFormat:@"%@?imageView2/2/w/%ld/h/%ld",imgUrl,(long)solutionW, (long)solutionH];
    }
    return temp;
}




- (NSString *)getCityName:(NSInteger)cityId
{
    return [City getCityNameById:cityId];
}



@end
