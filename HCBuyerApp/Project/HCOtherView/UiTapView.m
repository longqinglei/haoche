//
//  UiTapView.m
//  HCBuyerApp
//
//  Created by haoche51 on 16/4/7.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "UiTapView.h"

@interface UiTapView  ()<UIGestureRecognizerDelegate>

@end

@implementation UiTapView

- (id)initWithFrame:(UIView *)view{
    self = [super init];
    if (self) {
        UITapGestureRecognizer* _gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBlock:)];
        _gest.delegate = self;
        _gest.numberOfTapsRequired = 1;
        [view addGestureRecognizer:_gest];
    }
    return self;
}

- (void)tapBlock:(UIGestureRecognizer *)gest
{
    if (self.tapdelegate) {
        [self.tapdelegate tapGestureView];
    }
}

@end
