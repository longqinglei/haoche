//
//  HCDropdownSeriesView.h
//  HCBuyerApp
//
//  Created by wj on 15/6/13.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandSeries.h"
#import "DataFilter.h"

@protocol SeriesSelectedDelegate

@required

- (void)doNoneSelected;

- (void)selected:(BrandSeriesCond *)cond;

@end

@interface HCDropdownSeriesView : UIView

@property (assign, nonatomic) id<SeriesSelectedDelegate> delegate;

- (id)initWithFrame:(CGRect)frame superView:(UIView *)superView;

- (void)showWithBrandSeriesData:(BrandSeries *)data animate:(BOOL)animate isSelectedUnlimit:(BOOL)isSelectedUnlimit;

- (void)hide:(BOOL)animate;

@end
