//
//  NewVehicleController.h
//  HCBuyerApp
//
//  Created by 张熙 on 16/5/25.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "HCBaseViewController.h"
#import "City.h"
#import "HCDropdownListView.h"
#import "ListPageDropdownView.h"
@interface NewVehicleController : HCRequestAllPage
@property (nonatomic,strong)UITableView *vehcleTableView;
@property (strong, nonatomic) ListPageDropdownView *listPageDropdownView;
//- (void)prohibitionMovement:(BOOL)ishow;
//- (void)headerRefreshing;
+(BOOL)isInit;
+ (void)setPredefinedDataFilter:(DataFilter *)dataFitler;
@end
