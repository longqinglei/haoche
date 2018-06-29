//
//  HCCouponShot.m
//  HCBuyerApp
//
//  Created by 张熙 on 15/10/8.
//  Copyright © 2015年 haoche51. All rights reserved.
//

#import "HCCouponShot.h"

@implementation HCCouponShot

-(id)initWithFrame:(CGRect)frame num:(NSInteger)num{
    
    self = [super initWithFrame:frame];
    if (self) {
    self.backgroundColor =  [UIColor colorWithRed:0.15f green:0.15f blue:0.15f alpha:0.50f];
    self.frame = frame;
    }
    return self;
}

- (void)createBasicView:(NSInteger)num
{
    NSString *numstr =[NSString stringWithFormat:@"%ld",(long)num];
    NSString *buttonTitle = [NSString stringWithFormat:@"您有 %ld 张新的优惠劵",(long)num];
    UIView *mainView = [[UIView alloc]init];
    mainView.frame = CGRectMake(20, HCSCREEN_HEIGHT*0.4, HCSCREEN_WIDTH-40, 140);
    mainView.backgroundColor = [UIColor whiteColor];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:buttonTitle];
    [str addAttribute:NSForegroundColorAttributeName value:PRICE_STY_CORLOR range:NSMakeRange(3,numstr.length)];
    
    UILabel *infoLabel = [UILabel labelWithFrame:CGRectMake(10, 25, mainView.width-20, 20) text:@"" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:17] tag:0 hasShadow:NO isCenter:YES];
    infoLabel.attributedText = str;
    UIButton *close = [UIButton buttonWithFrame:CGRectMake(mainView.right-40, mainView.top-15, 30, 30) title:nil titleColor:nil bgColor:nil titleFont:nil image:[UIImage imageNamed:@"close"] selectImage:nil target:self action:@selector(closeClick) tag:0];
    UIButton *button = [UIButton buttonWithFrame:CGRectMake(20, infoLabel.bottom +30, mainView.width-40, 40) title:@"立即查看" titleColor:[UIColor whiteColor] bgColor:PRICE_STY_CORLOR titleFont:[UIFont boldSystemFontOfSize:17] image:nil selectImage:nil target:self action:@selector(checkCoupon) tag:0];
    [mainView addSubview:button];
    [mainView addSubview:infoLabel];
    [self addSubview:mainView];
     [self addSubview:close];
}

- (void)reloadNum:(NSInteger)num
{
    [self createBasicView:num];
}

- (void)closeClick
{
    [self removeFromSuperview];
}

- (void)checkCoupon
{
    [HCAnalysis HCUserClick:@"coupons_Click"];
    if ([self.delegate respondsToSelector:@selector(checkNewCoupon)]) {
        [self.delegate checkNewCoupon];
        [self closeClick];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
