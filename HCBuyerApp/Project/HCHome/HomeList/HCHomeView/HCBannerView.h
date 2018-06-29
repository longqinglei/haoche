//
//  HCBannerView.h
//  HCBuyerApp
//
//  Created by wj on 15/6/8.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Banner.h"

@protocol HCBannerViewClickDelegate <NSObject>

@required
- (void)bannerClick:(Banner *)banner;
@end

@interface HCBannerView : UIView

@property (assign, nonatomic) id<HCBannerViewClickDelegate> delegate;
@property (nonatomic) NSInteger controlStyle;
- (id)initWithFrame:(CGRect)frame data:(NSArray *)bannerData controlStyle:(NSInteger)type;
- (void)networkerror;
- (void)setBannersData:(NSArray *)bannerData;
- (void)setTopBannerData:(NSArray*)bannerData;
@end
