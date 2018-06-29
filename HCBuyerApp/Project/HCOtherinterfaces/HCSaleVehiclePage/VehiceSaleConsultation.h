//
//  VehiceSaleConsultation.h
//  HCBuyerApp
//
//  Created by haoche51 on 15/11/6.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MySaleVehicles.h"
@protocol VehiceSaleConsultationDelegate

//- (void)price;


- (void)updateHeight:(CGFloat)height;

@end


@interface VehiceSaleConsultation : UIView

@property (nonatomic,assign)id<VehiceSaleConsultationDelegate>delegate;

- (void)reloadViewDataWithMySaleVehicles:(MySaleVehicles*)vehicle;
- (id) initWithFrame:(CGRect)frame andSatus:(NSInteger)status MySaleVehicles:(MySaleVehicles*)mySaleVehicel;


@end
