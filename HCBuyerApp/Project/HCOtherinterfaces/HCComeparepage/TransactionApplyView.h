//
//  TransactionApplyView.h
//  HCBuyerApp
//
//  Created by wj on 15/7/17.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VehicleDetail.h"

@interface TransactionApplyView : UIView


-(id)initWithFrame:(CGRect)frame forVehicleDetail:(VehicleDetail *)detail inSuperView:(UIView *)superView;

-(void)show;

-(CGFloat)getYOffsetByKeyboardHeight:(CGFloat)height;

@end
