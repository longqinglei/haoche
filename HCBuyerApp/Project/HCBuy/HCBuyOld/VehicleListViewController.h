//
//  VehicleListViewController.h
//  HCBuyerApp
//
//  Created by wj on 15/5/5.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCVehicleListView.h"
#import "DataFilter.h"
#import "ListPageDropdownView.h"

@protocol VehicleListDelegate <NSObject>

- (void)selectIndex:(int)index;

@end
@interface VehicleListViewController : HCBaseViewController
@property (assign,nonatomic)id <VehicleListDelegate>delegate;
@property (strong, nonatomic) HCVehicleListView     *mListTableView;
@property (strong, nonatomic) UIPanGestureRecognizer*mPanGesture;
@property (strong, nonatomic) ListPageDropdownView   *listPageDropdownView;

+(void)setPredefinedDataFilter:(DataFilter *)dataFitler;
+(void)setShowAllBrandSelectView;
+(void)setShowAllPriceSelectView;
+(BOOL)isInit;
//- (void)setlistDelegate;

@end
