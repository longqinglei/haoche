//
//  BorderBaseView.m
//  ECarWash
//
//  Created by HAOCHE on 14/10/22.
//  Copyright (c) 2014年 HAOCHE. All rights reserved.
//

#import "BorderBaseView.h"
#import <QuartzCore/QuartzCore.h>

@implementation BorderBaseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBorderLine];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setBorderLine];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setBorderLine];
}

- (void)setBorderLine
{
    self.layer.borderColor = [UIColor colorWithRed:0.209 green:0.213 blue:0.212 alpha:0.3].CGColor;
    self.layer.borderWidth = 0.7;
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
