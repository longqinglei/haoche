//
//  HCVehicleListView.h
//  HCBuyerApp
//
//  Created by wj on 15/5/9.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vehicle.h"
#import "Banner.h"
#import "DataFilter.h"
#import "HCAllVehicleView.h"
#import "HCDropdownListView.h"
@protocol HCVehicleCellSelectedDelegate <NSObject>


- (void)listViewUpdateWithfilter:(DataFilter *)filter;
- (void)showMessage:(NSString*)message type:(FVAlertType)type;
- (void)showInfoMess:(NSString*)message type:(FVAlertType)type;
- (void)showSubSuccessInfo;

@required

- (void)hcVehicleCellSelected:(Vehicle *)vehicle;

- (void)hcBangmaiClick;

//- (void)emptyPrice;

- (void)resetFilter:(NSInteger)type;

//- (void)pushsubviewController;

- (void)JumpViewcontroller:(id)notFavt;
//- (void)isBtnClick:(BOOL)click;

//- (void)emptyPriceAndMore:(NSString *)strName;

//- (void)emptyAll;


@end

@interface HCVehicleListView : HCAllVehicleView <UITableViewDelegate,UITableViewDataSource>

//@property (assign, nonatomic) id<HCListDelegate> delegatee;
//

@property (assign, nonatomic) id<HCVehicleCellSelectedDelegate> delegate;
@property (strong, nonatomic) UITableView *mTableView;
@property (strong, nonatomic) DataFilter *dataFilter1;
@property (nonatomic, strong) DataFilter *mDataFilter;
@property (assign, nonatomic) HCDropdownListView *orderFilterView;
@property (nonatomic)BOOL isShowTab;

- (id)initWithFrame:(CGRect)frame filter:(DataFilter *)dataFilter;

- (void)refreshData:(DataFilter *)dataFilter;

- (void)headerRefreshing;

- (void)startTimer;

- (void)stopTimer;

@property (nonatomic)BOOL isShow;



@end
