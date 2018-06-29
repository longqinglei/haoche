//
//  HChomeViewController.h
//  HCBuyerApp
//
//  Created by haoche51 on 15/12/29.
//  Copyright © 2015年 haoche51. All rights reserved.
//

#import "HCBaseViewController.h"
#import "HCTwoClassBaseViewController.h"
#import "CityViewController.h"


@interface HChomeViewController : HCRequestAllPage
@property (nonatomic,strong)CityViewController * mCityViewController;
@property (nonatomic)NSInteger mHeight;

@end
