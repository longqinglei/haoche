//
//  HCZhibaoView.h
//  HCBuyerApp
//
//  Created by 龙青磊 on 2018/6/20.
//  Copyright © 2018年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Cancle)(void);

@interface HCZhibaoView : UIView

@property (nonatomic, copy) Cancle cancle;

- (void)show;

@end
