//
//  VehicleDetail.h
//  HCBuyerApp
//
//  Created by wj on 15/7/14.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VehicleDetail : NSObject

@property (nonatomic) NSInteger brandId;
@property (nonatomic) NSInteger cityId;
@property (nonatomic, strong) NSString *brandName;
@property (nonatomic, strong) NSString *checkerWords;
@property (nonatomic, strong) NSString *seriesName;
@property (nonatomic, strong) NSArray *coverImageUrls;
@property (nonatomic) float dealerPrice;
@property (nonatomic) NSInteger emissionStandard;
@property (nonatomic, strong) NSString *geerbox;
@property (nonatomic) NSInteger vehicleSourceId;
@property (nonatomic) float miles;

//model
@property (nonatomic, strong) NSString *airConditioningMode;
@property (nonatomic) NSInteger cylinderNum;
@property (nonatomic, strong) NSString *drivingMode;
@property (nonatomic) float emissionsL;
@property (nonatomic, strong) NSString *engine;
@property (nonatomic, strong) NSString *frontSuspension;
@property (nonatomic, strong) NSString *fuelLabel;
@property (nonatomic) float horsepower;
@property (nonatomic) NSInteger modelId;
@property (nonatomic, strong) NSString *intakeForm;
@property (nonatomic, strong) NSString *leatherSeat;
@property (nonatomic, strong) NSString *lwh;
@property (nonatomic) NSInteger maxTorque;
@property (nonatomic) float officalOilCost;
@property (nonatomic) float realOilCost;
@property (nonatomic, strong) NSString *structureAll;
@property (nonatomic) float wheelBase;

@property (nonatomic) float quotedPrice;
@property (nonatomic) NSInteger registerTime;

// report
@property (nonatomic, strong) NSString *skylight;
@property (nonatomic) NSInteger transferTimes;
@property (nonatomic) float vehicleAppearanceScore;
@property (nonatomic) float vehicleEquipmentScore;
@property (nonatomic) float vehicleInteriorScore;
@property (nonatomic) float vehicleMachineScore;


@property (nonatomic) float sellerPrice;
@property (nonatomic, strong) NSString *sellerWords;
@property (nonatomic, strong) NSString *vehicleName;
@property (nonatomic) NSInteger status;


-(instancetype)initWithVehicleData:(NSDictionary *)data;

//- (NSString *)getFixedSolutionImageUrl:(NSString *)imgUrl definedSolutionW:(NSInteger)solutionW solutionH:(NSInteger)solutionH;

- (NSString *)getEmissionStandarsToString;
- (BOOL)haveSkylight;

@end
