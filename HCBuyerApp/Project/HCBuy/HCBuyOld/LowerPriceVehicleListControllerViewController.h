//
//  LowerPriceVehicleListControllerViewController.h
//  HCBuyerApp
//
//  Created by wj on 15/6/25.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"
#import "HCDropdownListView.h"
#import "ListPageDropdownView.h"


@interface LowerPriceVehicleListControllerViewController : HCRequestAllPage

//@property (nonatomic,strong)HCDropdownListView * orderFilterView;
//@property (nonatomic,strong)UIPanGestureRecognizer* panGesture;
@property (nonatomic,strong)UITableView *mLowerTableView;
@property (nonatomic)BOOL isShowTab;
@property (strong, nonatomic) ListPageDropdownView *listPageDropdownView;
- (void)prohibitionMovement:(BOOL)ishow;
- (void)setdelegate;
- (void)headerRefreshing;
//- (void)hideSortbgandSortview;
+(BOOL)isInit;
+ (void)setPredefinedDataFilter:(DataFilter *)dataFitler;
@end

