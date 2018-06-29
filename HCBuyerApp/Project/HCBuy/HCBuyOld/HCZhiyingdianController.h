//
//  HCZhiyingdianController.h
//  HCBuyerApp
//
//  Created by 张熙 on 16/9/21.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "HCRequestAllPage.h"
#import "City.h"
#import "HCDropdownListView.h"
#import "ListPageDropdownView.h"
@interface HCZhiyingdianController : HCRequestAllPage
@property (nonatomic,strong)UITableView *vehcleTableView;
@property (strong, nonatomic) ListPageDropdownView *listPageDropdownView;
//- (void)prohibitionMovement:(BOOL)ishow;
- (void)headerRefreshing;
+(BOOL)isInit;
+ (void)setPredefinedDataFilter:(DataFilter *)dataFitler;
@end
