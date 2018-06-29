//
//  HCSelectVehicleViewController.h
//  HCBuyerApp
//
//  Created by 张熙 on 15/9/18.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "HCBaseViewController.h"
#import "City.h"
#import "CitySelectView.h"
@interface HCSelectVehicleViewController : HCBaseViewController
{
    int _newIndex;
}
@property (nonatomic,retain)NSMutableArray *titleArray;
@property (nonatomic,strong)UIScrollView *mainView;
@property (nonatomic,assign) BOOL isShow;
@property (nonatomic,retain) UIButton *finishBt;
@property (nonatomic,retain) UIButton *personalBtn;
@property (nonatomic,retain) UILabel  *titleLabel;
@property (nonatomic) CityElem *selectedCity;
@property (strong, nonatomic) UIButton *navigatorBarRightButton;
@property (strong, nonatomic) CitySelectView *citySelectView;
- (void)createMainScrollSeg;
@end
