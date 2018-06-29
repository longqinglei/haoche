//
//  HCSaleStatusView.h
//  HCBuyerApp
//
//  Created by haoche51 on 16/4/7.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HCSaleStatusViewDelegate <NSObject>

- (void)tapRecognizer;

@end



@interface HCSaleStatusView : UIView

@property (nonatomic,assign)id<HCSaleStatusViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame and:(UIView *)view;


- (id)initWithFrame:(CGRect)frame;

@end
