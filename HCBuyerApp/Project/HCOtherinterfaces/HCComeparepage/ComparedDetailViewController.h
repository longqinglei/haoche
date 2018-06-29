//
//  ComparedDetailViewController.h
//  HCBuyerApp
//
//  Created by wj on 15/7/15.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VehicleDetail.h"

@interface ComparedDetailViewController : HCBasicViewController

-(void)setComparedDataBetween:(VehicleDetail *)lhv and:(VehicleDetail *)rhv;

@end
