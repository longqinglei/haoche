//
//  HCDropdownOtherSelectView.h
//  HCBuyerApp
//
//  Created by wj on 15/5/7.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCDropdowListViewDataDelegate.h"
#import "BJRangeSliderWithProgress.h"
#import "DataFilter.h"
@protocol HCDropdownOtherSelectView

@required

- (void)requestvehicleNum:(NSDictionary*)cond;

@end

@interface HCDropdownOtherSelectView : UIView

@property (assign, nonatomic) id<HCDropdowListViewDataDelegate> delegate;
@property (assign, nonatomic) id<HCDropdownOtherSelectView> numDelegate;


@property (nonatomic,strong)NSMutableDictionary *filterCondDic;

- (id)initWithFrame:(CGRect)frame dataArray:(NSArray *)data superView:(UIView *)superView suitable:(NSInteger)type;

- (void)show;

- (void)getCondValuesFromDatafilter:(DataFilter*)datafilter;
- (void)hide:(BOOL)animate;
- (void)resetData:(NSDictionary *)dict;
- (void)requestNum;
//+ (HCDropdownOtherSelectView *)sharGet;

- (void)resetVehicleNum:(NSInteger)num;

//-(void)clearFilterCond;


//
//- (void)mDischargeArray:(UIButton *)buttonSecle;
//
//- (void)mBodyStructure:(UIButton *)buttonSecle;

@end
