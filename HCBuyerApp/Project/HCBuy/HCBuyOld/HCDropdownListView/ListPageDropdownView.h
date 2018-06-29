//
//  ListPageDropdownView.h
//  HCBuyerApp
//
//  Created by wj on 15/6/11.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

//列表页下拉框视图

#import <UIKit/UIKit.h>
#import "DataFilter.h"

@protocol HCListPageDropdownSelectedDelegate

@required

- (void)listPageUpdateByFilter:(DataFilter *)filter;

//- (void)cityShow:(BOOL)isHidden;

@end



@interface ListPageDropdownView : UIView
@property (nonatomic,strong)UIView *segmentBottomLineView ;
@property CGFloat segmentViewMaxYPos;
@property CGFloat segmentViewMinYPos;
@property CGFloat segmentViewHeight;
@property (strong, nonatomic) DataFilter *dataFilter;
@property (nonatomic) NSInteger selectedIdx;
@property (strong, nonatomic) NSArray *orderData;
@property (strong, nonatomic) NSArray *priceData;
@property (strong, nonatomic) NSArray *brandSeriesData;
@property (strong, nonatomic) NSArray *otherFilterData;
@property (nonatomic)BOOL  isTodayNew;
@property (assign, nonatomic) id<HCListPageDropdownSelectedDelegate> delegate;

//初始化函数
- (id)initWithframe:(CGRect)frame forData:(DataFilter *)filter forSuperView:(UIView *)superView delegate:(id)delegate coverTabbar:(BOOL)coverTabbar suitable:(NSInteger)type;
//- (void)getCurrentCity;
//根据datafilter 重置下拉框数据
- (void)reloadDataByDataFilter:(DataFilter *)filter;
- (void)setSegmentUnselected:(NSInteger)segIdx;
//显示品牌下拉视图
- (void)showBrandDropdownView;
- (void)showPriceDropdownView;


- (void)emptyPrice;
- (void)emptyBrand;
- (void)empMoreAll;

@end
