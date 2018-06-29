//
//  HCRequestAllPage.h
//  HCBuyerApp
//
//  Created by 张熙 on 15/8/26.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BizVisitRecord.h"
#import "UIScrollView+MJRefresh.h"
#import "EmptyDefaultView.h"


@interface HCRequestAllPage : HCBaseViewController<UIGestureRecognizerDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property(nonatomic,assign)BOOL isShowing;
@property (nonatomic,strong)UIView *mView;
@property (strong, nonatomic)NSString *strName;
@property (nonatomic,strong)NSString *strNetwork;
@property (nonatomic,strong)NSString *mExchangeTitle;
@property (nonatomic,strong)NSString *strNetworkTitle;
@property (strong, nonatomic) EmptyDefaultView *emptyView;

- (void)setupRefresh:(UITableView*)tableView;
- (void)reloadEmptyView;
- (void)UIviewcontroller:(UIViewController*)controller;

- (BOOL)nav:(BOOL)hidden;



@end
