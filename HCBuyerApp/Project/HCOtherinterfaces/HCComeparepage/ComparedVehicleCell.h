//
//  ComparedVehicleCell.h
//  HCBuyerApp
//
//  Created by wj on 15/7/14.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vehicle.h"
#import "ComparedVehicleCellContentView.h"

@interface ComparedVehicleCell : UITableViewCell


- (id)initWithFrame:(CGRect)frame data:(Vehicle *)vehicle;


- (void)setVehicleData:(Vehicle *)vehicle;

- (Vehicle *)getVehicle;

@property (nonatomic, strong) ComparedVehicleCellContentView *comparedContentView;

@end
