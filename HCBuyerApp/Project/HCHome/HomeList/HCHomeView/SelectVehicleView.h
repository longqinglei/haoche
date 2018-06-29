//
//  SelectVehicleView.h
//  HCBuyerApp
//
//  Created by 张熙 on 16/5/27.
//  Copyright © 2016年 haoche51. All rights reserved.
//
#import "CondBtn.h"
@protocol SelectDelegate <NSObject>
- (void)pushToSellOrBuyVehicle:(UIButton*)btn;
- (void)priceBtnClick:(CondBtn*)btn;
- (void)activityBtnClick:(CondBtn*)btn;
- (void)brandBtnClick:(CondBtn*)btn;
- (void)jumpNewVehiclePage;
@end
#import <UIKit/UIKit.h>

@interface SelectVehicleView : UIView
@property (nonatomic,assign)id <SelectDelegate> delegate;
- (id)initWithFrame:(CGRect)frame;
- (void)createCityViewWithBrand:(NSArray *)brandArray;
- (void)createnoCityViewWithDataArray:(NSArray*)cityArray;
- (void)createBottomViewWith:(NSString*)vehicelCount;
@end
