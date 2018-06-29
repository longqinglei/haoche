//
//  UIResponder+tools.m
//  HCBuyerApp
//
//  Created by 龙青磊 on 2018/6/19.
//  Copyright © 2018年 haoche51. All rights reserved.
//

#import "UIResponder+tools.h"

@implementation UIResponder (tools)

#pragma mark - base
- (UIViewController *)viewController {
    
    id nextResponder = [self nextResponder];
    while (nextResponder != nil) {
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            UIViewController *vc = (UIViewController *)nextResponder;
            return vc;
        }
        nextResponder = [nextResponder nextResponder];
    }
    return nil;
}



@end
