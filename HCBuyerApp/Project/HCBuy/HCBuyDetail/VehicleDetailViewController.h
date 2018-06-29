//
//  VehicleDetailViewController.h
//  HCBuyerApp
//
//  Created by wj on 15/5/11.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vehicle.h"


@interface VehicleDetailViewController : HCBaseViewController


@property (nonatomic)int mysale;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) Vehicle *vehicle;
@property (nonatomic)NSInteger source_id;
@property (nonatomic) NSInteger mSharedType;
@property (nonatomic,strong)NSString *VehicleChannel;

#pragma mark - SharingFunction
- (void)setSharedBtnByContentTpye:(NSInteger)type sharedObj:(id)sharedObject;
- (void)setVehicleCompareBtn;
- (void)requestVehicleInfoBy:(NSInteger)vehicle_id;
@end
