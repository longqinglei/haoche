//
//  HCSubBtn.h
//  HCBuyerApp
//
//  Created by 张熙 on 16/9/9.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCSubBtn : UIButton
- (id)initWithSubCond:(id)cond;
- (void)setTitleWithCond:(id)cond;
@property (nonatomic,strong)id subCond;
@end
