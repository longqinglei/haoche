//
//  HCDropdownListView.h
//  HCBuyerApp
//
//  Created by wj on 15/5/6.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCDropdowListViewDataDelegate.h"
#import "BJRangeSliderWithProgress.h"




@interface HCDropdownListView : UIView

@property (assign, nonatomic) id<HCDropdowListViewDataDelegate> delegate;
@property (strong, nonatomic)BJRangeSliderWithProgress *slider;
@property (nonatomic,strong)UIButton *button;
- (id)initWithFrame:(CGRect)frame dataArray:(NSArray *)data superView:(UIView *)superView typeEnum:(NSInteger)type;

- (void)show;

- (void)hide:(BOOL)animate;
//
- (void)resetData:(NSInteger)idx;
- (void)hidden;
- (void)emptyPr;

@property (nonatomic)NSInteger mType;
@property (nonatomic)NSIndexPath *selectIndex;


@property (nonatomic)int min;
@property (nonatomic)int max;

@end
