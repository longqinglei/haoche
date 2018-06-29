//
//  HCSaleStatusView.m
//  HCBuyerApp
//
//  Created by haoche51 on 16/4/7.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "HCSaleStatusView.h"

@interface HCSaleStatusView  ()<UIGestureRecognizerDelegate>

@end


@implementation HCSaleStatusView

- (id)initWithFrame:(CGRect)frame and:(UIView *)view{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = CGRectMake(0, 0, HCSCREEN_WIDTH, HCSCREEN_HEIGHT);
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.5;
        self.hidden = YES;
        self.userInteractionEnabled = YES;
        [view addSubview:self];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        self.userInteractionEnabled = YES;
        tapRecognizer.delegate = self;
        tapRecognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (void)tap:(UIGestureRecognizer *)gest
{
    if (self.delegate) {
        [self.delegate tapRecognizer];
    }
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

@end
