//
//  LowerPriceVehicleBigCellTableViewCell.h
//  HCBuyerApp
//
//  Created by wj on 15/6/24.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vehicle.h"

@interface LowerPriceVehicleBigCellTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *leftBigImageView;
@property (strong, nonatomic) UIImageView *rightTopImageView;
@property (strong, nonatomic) UIImageView *rightBottomImageView;

- (id)initWithFrame:(CGRect)frame data:(Vehicle *)vehicle;

- (void)setVehicleData:(Vehicle *)vehicle;

-(void)setSeperator:(BOOL)isNeed;

- (Vehicle *)getVehicle;
@end
