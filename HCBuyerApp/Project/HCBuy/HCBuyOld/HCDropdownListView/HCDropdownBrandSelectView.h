//
//  HCDropdownBrandSelectView.h
//  HCBuyerApp
//
//  Created by wj on 15/5/7.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCDropdowListViewDataDelegate.h"
#import "DataFilter.h"

@interface HCDropdownBrandSelectView : UIView <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) id<HCDropdowListViewDataDelegate> delegate;

- (id)initWithFrame:(CGRect)frame dataArray:(NSArray *)data city:(NSInteger)cityId superView:(UIView *)superView;

- (void)show;

- (void)hide:(BOOL)animate;

- (void)resetData:(BrandSeriesCond *)cond;

- (void)resetBrandSeriesData:(NSArray *)data forCity:(NSInteger)cityId;
@end
