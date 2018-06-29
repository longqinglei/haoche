//
//  HCOtherSelectBtn.m
//  HCBuyerApp
//
//  Created by 张熙 on 16/9/13.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "HCOtherSelectBtn.h"
#import "DataFilter.h"
@interface HCOtherSelectBtn()
@property (nonatomic,strong)UIImageView * closeView;
@end
@implementation HCOtherSelectBtn

- (id)initWithFrame:(CGRect)frame withCond:(id)cond{
    self =[super initWithFrame:frame];
    if (self) {
        self.cond = cond;
        self.closeView = [[UIImageView alloc]init];
        self.closeView.frame = CGRectMake(frame.size.width-16, frame.size.height-16, 16, 16);
        self.closeView.image = [UIImage imageNamed:@"cancle"];
        [self addSubview:self.closeView];
        self.titleLabel.font  = [UIFont systemFontOfSize:12];
        [self setTitle:[self getTitleFrom:cond] forState:UIControlStateNormal];
        [self setTitleColor:UIColorFromRGBValue(0x424242) forState:UIControlStateNormal];
        self.layer.borderWidth =0.5;
        self.layer.cornerRadius = 0.5;
        self.layer.borderColor = UIColorFromRGBValue(0xe0e0e0).CGColor;
        self.layer.masksToBounds = YES;
        self.closeView.hidden = YES;
        self.selectState = NO;
    }
    return self;
}
- (NSString*)getTitleFrom:(id)cond{
    if ([cond isKindOfClass:[AgeCond class]]) {
        return ((AgeCond *)cond).desc;
    }
    if ([cond isKindOfClass:[MilesCond class]]) {
        return ((MilesCond *)cond).desc;
    }
    if ([cond isKindOfClass:[GearboxCond class]]){
        return ((GearboxCond *)cond).desc;
    }
    if ([cond isKindOfClass:[EmissionStandarCond class]]) {
        return ((EmissionStandarCond *)cond).desc;
    }
    if ([cond isKindOfClass:[EmissionCond class]]) {
        return ((EmissionCond *)cond).desc;
    }
    return @"";
}
- (void)setStateSelect{
    self.selectState = YES;
    self.closeView.hidden = NO;
    self.layer.borderColor = PRICE_STY_CORLOR.CGColor;
    self.backgroundColor = UIColorFromRGBValue(0xfff0f0);
    [self setTitleColor:PRICE_STY_CORLOR forState:UIControlStateNormal];
    
}
- (void)setStateUnSelect{
    self.selectState = NO;
    self.closeView.hidden = YES;
    self.layer.borderColor = UIColorFromRGBValue(0xe0e0e0).CGColor;
    self.backgroundColor = [UIColor whiteColor];
    [self setTitleColor:UIColorFromRGBValue(0x424242) forState:UIControlStateNormal];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
