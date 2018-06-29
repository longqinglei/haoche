//
//  VehiceSaleStatusView.h
//  HCBuyerApp
//
//  Created by haoche51 on 15/11/6.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MySaleVehicles.h"
@protocol VehiceSaleStatusViewDelegate

- (void)priceSaleStatus;

- (void)vehicleDetails;
- (void)updateViewHeight:(CGFloat)height and:(int)status;

@end


@interface VehiceSaleStatusView : UIView

@property (nonatomic,strong)UIView *mViewChoice;
@property (nonatomic,assign)id<VehiceSaleStatusViewDelegate>delegate;

@property (nonatomic)CGRect mFrame;
- (id) initWithFrame:(CGRect)frame MySaleVehicles:(MySaleVehicles *)mySaleVehicle andSatus:(NSInteger)status;

- (void)updateViewData:(MySaleVehicles*)vehicle;
@end
