//
//  HCDropSortListView.h
//  HCBuyerApp
//
//  Created by 张熙 on 16/9/19.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCDropdowListViewDataDelegate.h"

@interface HCDropSortListView : UIView
@property (assign, nonatomic) id<HCDropdowListViewDataDelegate> delegate;
@property (nonatomic,strong)UIButton *button;
- (id)initWithFrame:(CGRect)frame dataArray:(NSArray *)data superView:(UIView *)superView typeEnum:(NSInteger)type;

- (void)show;

- (void)hide:(BOOL)animate;
- (void)resetData:(NSInteger)idx;
@property (nonatomic)NSInteger mType;
@property (nonatomic)NSIndexPath *selectIndex;





@end
