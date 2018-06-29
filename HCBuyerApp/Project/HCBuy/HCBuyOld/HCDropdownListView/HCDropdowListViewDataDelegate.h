//
//  HCDropdowListViewDataDelegate.h
//  HCBuyerApp
//
//  Created by wj on 15/5/7.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#ifndef HCBuyerApp_HCDropdowListViewDataDelegate_h
#define HCBuyerApp_HCDropdowListViewDataDelegate_h

#import <UIKit/UIKit.h>

@protocol HCDropdowListViewDataDelegate

@required

- (void)hcDropDownListViewDidSelectRowAtIndexPath:(NSInteger)idx fromViewTag:(NSInteger)tagId conditon:(id)cond;

@end

#endif
