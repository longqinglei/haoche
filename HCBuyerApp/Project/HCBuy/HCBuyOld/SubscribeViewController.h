//
//  SubscribeViewController.h
//  HCBuyerApp
//
//  Created by haoche51 on 15/8/13.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubSettViewController.h"
@interface SubscribeViewController : HCRequestAllPage
@property (nonatomic)BOOL isShowTab;
- (void)AllRequest;
- (void)updateVehicleSource;
@property (strong, nonatomic) UITableView *mSubTableView;
@property (nonatomic) SubSettViewController *detailVC;
@end
