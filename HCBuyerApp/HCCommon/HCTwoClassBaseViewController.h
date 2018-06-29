//
//  HCTwoClassBaseViewController.h
//  HCBuyerApp
//
//  Created by haoche51 on 15/11/23.
//  Copyright © 2015年 haoche51. All rights reserved.
//

#import "HCBaseViewController.h"
#import "HCBannerView.h"
#import "BizCoupon.h"
#import "VehicleDetailViewController.h"
#import "City.h"
#import "VehicleListViewController.h"
#import "UIImage+RTTint.h"
#import "CitySelectView.h"
#import "BizCity.h"
#import "UserVisitRecordViewController.h"
#import "VehicleDetailViewController.h"
#import "BizUser.h"
#import <CoreLocation/CoreLocation.h>
#import "SubscribeViewController.h"
#import "User.h"
#import "CouponListViewController.h"
#import "LoginViewController.h"
#import "HCCouponShot.h"
#import "SearchController.h"
#import "BizSearch.h"
#import "OperationchartView.h"
#import "BizVehicleSource.h"
#import "UIAlertView+ITTAdditions.h"
@interface HCTwoClassBaseViewController : HCBaseViewController
- (void)setupRefresh:(UITableView*)tableView;
@end
