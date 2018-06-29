//
//  PageView.m
//  HCBuyerApp
//
//  Created by haoche51 on 16/4/8.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "PageView.h"
#import "UILabel+ITTAdditions.h"

@interface PageView()

@property (nonatomic) NSInteger page;
@property (nonatomic) NSInteger count;
@property (nonatomic) NSTimer *time;
@end



@implementation PageView

- (id)initWithFrameRect:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.labelPageText.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.labelPageText];
    }
    return self;
}

- (UILabel *)labelPageText
{
    if (_labelPageText == nil) {
        _labelPageText = [UILabel labelWithPage];
    }
    return _labelPageText;
}

- (void)timeDuration:(NSInteger)duration superView:(UIView *)superView pageNumber:(NSInteger)number
{
    [self removeFromSuperview];
    [_labelPageText removeFromSuperview];
     _labelPageText = [UILabel labelWithPage];
    [self addSubview:_labelPageText];
    [superView addSubview:self];
    if (duration == 1) {
        _labelPageText.text = [NSString stringWithFormat:@"1/%ld",(long)number+1];
    }else{
        _labelPageText.text = [NSString stringWithFormat:@"%ld/%ld",(long)number,(long)number+1];
    }
    NSTimeInterval timeInterval = 1.5;
    _time = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(handleMax:)userInfo:nil repeats:NO];
}

- (void)handleMax:(NSTimer *)time
{
    [self removerPageView];
}

- (void)removerPageView
{
    [self removeFromSuperview];
}

@end
