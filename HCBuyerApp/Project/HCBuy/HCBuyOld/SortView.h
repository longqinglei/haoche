//
//  SortView.h
//  HCBuyerApp
//
//  Created by 张熙 on 15/9/18.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCDropdowListViewDataDelegate.h"
#import "HCDropdownListView.h"
#import "DataFilter.h"

@protocol HCSortViewSelectedDelegate

@required

- (void)listPageUpdateByFilter;

@end
@interface SortView : UIView
@property (assign, nonatomic) id<HCSortViewSelectedDelegate> delegate;
@property (nonatomic,strong)UILabel*numberLabel;
@property (nonatomic,strong)UIButton*buttonPrice;
@property (strong, nonatomic) HCDropdownListView *orderFilterView;
@property (strong, nonatomic) NSArray *orderData;
@property (nonatomic, strong) UIView *superView;


@property (nonatomic,strong)UIImageView *sectionBtnIv;

- (BOOL)isHiddenYes;

- (id)initWithframeRec:(CGRect)frame;
@end
