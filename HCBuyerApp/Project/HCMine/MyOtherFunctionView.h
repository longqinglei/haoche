//
//  MyOtherFunctionView.h
//  HCBuyerApp
//
//  Created by wj on 15/6/15.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vehicle.h"
#define My_OtherTableView_Cell_Height 44

@protocol MyOtherFunctionViewDelegate
- (void)showRecommend;
- (void)showVehicleDetail:(Vehicle*)vehicle;
@required

@end

@interface MyOtherFunctionView : UIView

@property (assign, nonatomic) id<MyOtherFunctionViewDelegate> delegate;
@property (nonatomic,strong)NSArray *dataArrry;
- (id)initWithFrame:(CGRect)frame;
- (void)reloaddata:(NSArray *)arr;
- (void)setRecommendReaded;
- (void)setRecommendNew:(NSInteger)num;
@end
