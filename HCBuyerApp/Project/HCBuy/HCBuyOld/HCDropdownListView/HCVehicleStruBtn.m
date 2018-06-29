//
//  HCVehicleStruBtn.m
//  HCBuyerApp
//
//  Created by 张熙 on 16/9/13.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "HCVehicleStruBtn.h"
#import "DataFilter.h"
@interface HCVehicleStruBtn()
@property (nonatomic,strong)UIImageView * closeView;
@end

@implementation HCVehicleStruBtn


- (id)initWithFrame:(CGRect)frame withCond:(id)cond{
    self =[super initWithFrame:frame];
    if (self) {
        self.cond = cond;
        self.closeView = [[UIImageView alloc]init];
        self.closeView.frame = CGRectMake(frame.size.width-16, frame.size.height-16, 16, 16);
        self.closeView.image = [UIImage imageNamed:@"cancle"];
        UIImageView *vehicleimage = [[UIImageView alloc]init];
        vehicleimage.image = [UIImage imageNamed:((StructureCond *)cond).imageName];
        vehicleimage.frame = CGRectMake(10, 10, frame.size.width-20, frame.size.height/2);
        [self addSubview:vehicleimage];
        UILabel *lable = [[UILabel alloc]init];
        lable.frame = CGRectMake(0, vehicleimage.bottom+5, frame.size.width, 14);
        lable.text = ((StructureCond *)cond).desc;
        lable.textColor = UIColorFromRGBValue(0x424242);
        lable.font = [UIFont systemFontOfSize:12];
        lable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lable];
        [self addSubview:self.closeView];
        self.titleLabel.font  = [UIFont systemFontOfSize:12];
       // [self setTitle:[self getTitleFrom:cond] forState:UIControlStateNormal];
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


//- (NSString*)getTitleFrom:(id)cond{
//    if ([cond isKindOfClass:[StructureCond class]]) {
//        return ((StructureCond *)cond).desc;
//    }
//    return @"";
//}
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
