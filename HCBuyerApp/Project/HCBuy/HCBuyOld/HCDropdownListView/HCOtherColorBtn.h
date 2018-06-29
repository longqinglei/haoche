//
//  HCOtherColorBtn.h
//  HCBuyerApp
//
//  Created by 张熙 on 16/9/14.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCOtherColorBtn : UIButton
@property (nonatomic)BOOL selectState;
@property (nonatomic,strong)id cond;
- (id)initWithFrame:(CGRect)frame withCond:(id)cond;
- (void)setStateSelect;
- (void)setStateUnSelect;
@end
