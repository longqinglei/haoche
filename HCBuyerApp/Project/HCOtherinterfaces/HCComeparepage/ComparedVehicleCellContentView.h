//
//  ComparedVehicleCellContentView.h
//  HCBuyerApp
//
//  Created by wj on 15/7/13.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vehicle.h"

@protocol ComapredVehicleCellSelectedDelegate

@required
- (void)selectedVehicle:(Vehicle *)vehicle;

- (void)unselectVehicle:(Vehicle *)vehicle;

@end

@interface ComparedVehicleCellContentView : UIView

-(id)initWithFrame:(CGRect)frame data:(Vehicle *)vehicle;

- (void)setVehicleData:(Vehicle *)vehicle;

- (void)setSelectedBtnSelectedAndDisable;

- (Vehicle *)getVehicle;

@property (assign, nonatomic) id<ComapredVehicleCellSelectedDelegate> delegate;

@end
