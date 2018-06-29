//
//  MyRecordAndRecommendView.h
//  HCBuyerApp
//
//  Created by wj on 15/7/21.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>

#define My_RecordAndRecommendView_Cell_Height 44

@protocol MyRecordAndRecommendViewDelegate


@required
//我的历史记录
- (void)showAllRecord;

- (void)showSetting;

//优惠券
- (void)showMyCoupons;

//我的订阅
- (void)showSubscribe;

- (void)showColleciton;

//我看过的好车
- (void)showMyScan;

@end

@interface MyRecordAndRecommendView : UIView

@property (assign, nonatomic) id<MyRecordAndRecommendViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;
//
//- (void)setRecommendNew:(NSInteger)num;
//- (void)setRecommendReaded;

- (void)setCouponNew:(NSInteger)cnt;
- (void)setCouponReaded;
- (void)updateNum;
- (void)logout;
- (void)setSubscribe;
- (void)setSubscribeNew:(NSInteger)num;
- (void)requestNumData;
- (void)setHaveSeenNew;
- (void)setHaveSeen;
- (void)setCollectNew;
- (void)setCollectRead;

@end
