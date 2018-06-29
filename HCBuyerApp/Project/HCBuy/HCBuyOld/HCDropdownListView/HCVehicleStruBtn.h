//
//  HCVehicleStruBtn.h
//  HCBuyerApp
//
//  Created by 张熙 on 16/9/13.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCVehicleStruBtn : UIButton
@property (nonatomic)BOOL selectState;
@property (nonatomic,strong)id cond;
- (id)initWithFrame:(CGRect)frame withCond:(id)cond;
- (void)setStateSelect;
- (void)setStateUnSelect;
@end
