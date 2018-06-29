//
//  VehicleDetail.m
//  HCBuyerApp
//
//  Created by wj on 15/7/14.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "VehicleDetail.h"

@implementation VehicleDetail

-(instancetype)initWithVehicleData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            @try {
                self.brandId = [(NSNumber *)[data objectForKey:@"brand_id"] integerValue];
                self.brandName = (NSString *)[data objectForKey:@"brand_name"];
                self.checkerWords = (NSString *)[data objectForKey:@"checker_words"];
                self.seriesName = (NSString *)[data objectForKey:@"class_name"];
                self.coverImageUrls = (NSArray *)[data objectForKey:@"cover_image_urls"];
                
                self.cityId = [(NSNumber *)[data objectForKey:@"city_id"] integerValue];
                
                self.dealerPrice = [(NSNumber *)[data objectForKey:@"dealer_price"] floatValue];
                self.emissionStandard = [(NSNumber *)[data objectForKey:@"emission_standard"] integerValue];
                self.geerbox = (NSString *)[data objectForKey:@"geerbox"];
                self.vehicleSourceId = [(NSNumber *)[data objectForKey:@"id"] integerValue];
                self.miles = [(NSNumber *)[data objectForKey:@"miles"] floatValue];
                
                self.airConditioningMode = (NSString *)[[data objectForKey:@"model"] objectForKey:@"air_conditioning_mode"];
                self.cylinderNum = [(NSNumber *)[[data objectForKey:@"model"] objectForKey:@"cylinder_num"] integerValue];
                self.drivingMode = (NSString *)[[data objectForKey:@"model"] objectForKey:@"driving_mode"];
                self.emissionsL = [(NSNumber *)[[data objectForKey:@"model"] objectForKey:@"emissions_l"] floatValue];
                self.engine = (NSString *)[[data objectForKey:@"model"] objectForKey:@"engine"];
                self.frontSuspension = (NSString *)[[data objectForKey:@"model"] objectForKey:@"front_suspension"];
                self.fuelLabel = (NSString *)[[data objectForKey:@"model"] objectForKey:@"fuel_label"];
                self.horsepower = [(NSNumber *)[[data objectForKey:@"model"] objectForKey:@"horsepower"] floatValue];
                self.modelId = [(NSNumber *)[[data objectForKey:@"model"] objectForKey:@"id"] integerValue];
                self.intakeForm = (NSString *)[[data objectForKey:@"model"] objectForKey:@"intake_form"];
                self.leatherSeat = (NSString *)[[data objectForKey:@"model"] objectForKey:@"leather_seat"];
                self.lwh = (NSString *)[[data objectForKey:@"model"] objectForKey:@"lwh"];
                self.maxTorque = [(NSNumber *)[[data objectForKey:@"model"] objectForKey:@"max_torque"] integerValue];
                self.officalOilCost = [(NSNumber *)[[data objectForKey:@"model"] objectForKey:@"offical_oil_cost"] floatValue];
                self.realOilCost = [(NSNumber *)[[data objectForKey:@"model"] objectForKey:@"real_oil_cost"] floatValue];
                self.structureAll = (NSString *)[[data objectForKey:@"model"] objectForKey:@"structure_all"];
                self.wheelBase = [(NSNumber *)[[data objectForKey:@"model"] objectForKey:@"wheel_base"] floatValue];
                
                self.quotedPrice = [(NSNumber *)[data objectForKey:@"quoted_price"] floatValue];
                self.registerTime = [(NSNumber *)[data objectForKey:@"register_time"] integerValue];
                
                self.skylight = (NSString *)[[data objectForKey:@"report"] objectForKey:@"skylight"];
                self.transferTimes = [(NSNumber *)[[data objectForKey:@"report"] objectForKey:@"transfer_times"] integerValue];
                
                self.vehicleAppearanceScore = [(NSNumber *)[[data objectForKey:@"report"] objectForKey:@"vehicle_appearance_score"] floatValue];
                self.vehicleEquipmentScore = [(NSNumber *)[[data objectForKey:@"report"] objectForKey:@"vehicle_equipment_score"] floatValue];
                self.vehicleInteriorScore = [(NSNumber *)[[data objectForKey:@"report"] objectForKey:@"vehicle_interior_score"] floatValue];
                self.vehicleMachineScore = [(NSNumber *)[[data objectForKey:@"report"] objectForKey:@"vehicle_machine_score"] floatValue];
                
                self.sellerPrice = [(NSNumber *)[data objectForKey:@"seller_price"] floatValue];
                self.sellerWords = (NSString *)[data objectForKey:@"seller_words"];
                self.status = [(NSNumber *)[data objectForKey:@"status"] integerValue];
                self.vehicleName = (NSString *)[data objectForKey:@"vehicle_name"];
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
        }
    }
    return self;
}

- (NSString *)getEmissionStandarsToString
{
    switch (self.emissionStandard) {
        case 0:
            return @"国二";
        case 1:
            return @"国三";
        case 2:
            return @"国四";
        case 3:
            return @"国五";
        default:
            return @"-";
    }
}

- (BOOL)haveSkylight
{
    NSRange range = [self.skylight rangeOfString:@"\"has\":1"];
    if (range.length > 0) {
        return YES;
    }
    return NO;
}

@end
