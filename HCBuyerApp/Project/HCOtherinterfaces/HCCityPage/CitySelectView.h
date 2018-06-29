//
//  CitySelectView.h
//  HCBuyerApp
//
//  Created by wj on 15/6/12.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"

@interface CitySelectView : UIView

- (id)initWithFrame:(CGRect)frame forSuperView:(UIView *)superView;

- (void)toggle;

- (void)show:(BOOL)isShow;


@end
