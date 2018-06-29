//
//  HCZhibaoView.m
//  HCBuyerApp
//
//  Created by 龙青磊 on 2018/6/20.
//  Copyright © 2018年 haoche51. All rights reserved.
//

#import "HCZhibaoView.h"

@interface HCZhibaoView ()



@end

@implementation HCZhibaoView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor hex:@"000000"] colorWithAlphaComponent:0.5];
        self.frame = CGRectMake(0, kNavHegith, kScreenWidth, kScreenHeight - kNavHegith);
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews{
    UIImageView *topImg = [[UIImageView alloc]init];
    topImg.image = [UIImage imageNamed:@"zhibao_top"];
    [self addSubview:topImg];
    [topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(Width(50));
        make.left.equalTo(self).offset(Width(15));
        make.right.equalTo(self.mas_right).offset(-Width(15));
        make.height.mas_equalTo(Width(105));
    }];
    
    UIImageView *bottomimg = [[UIImageView alloc]init];
    bottomimg.image = [UIImage imageNamed:@"zhibao_bottom"];
    [self addSubview:bottomimg];
    [bottomimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImg.mas_bottom);
        make.left.equalTo(self).offset(Width(15));
        make.right.equalTo(self.mas_right).offset(-Width(15));
        make.height.mas_equalTo(Width(305));
    }];
    
    UIImageView *middleimg = [[UIImageView alloc]init];
    middleimg.image = [UIImage imageNamed:@"zhibao_middle"];
    [self addSubview:middleimg];
    [middleimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImg).offset(Width(60));
        make.left.equalTo(topImg).offset(Width(65));
        make.right.equalTo(topImg.mas_right).offset(-Width(65));
        make.height.mas_equalTo(Width(100));
    }];
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setBackgroundImage:[UIImage imageNamed:@"zhibao_cancle"] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancleBtn];
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomimg.mas_bottom);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(Width(31));
        make.height.mas_equalTo(Width(73));
    }];
}

- (void)show{
    [[UIApplication sharedApplication].delegate.window addSubview:self];
}


- (void)cancleAction{
    if (self.cancle) {
        self.cancle();
    }
    [self dismiss];
}

- (void)dismiss{
    [self removeFromSuperview];
}

@end
