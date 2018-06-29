//
//  HCRecommendCell.m
//  HCBuyerApp
//
//  Created by 张熙 on 16/1/20.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "HCRecommendCell.h"

@implementation HCRecommendCell



- (instancetype)initWithRecommed{
    self = [super init];
    if (self) {
        UILabel *label = [[UILabel alloc]init];
        label.text = @"抱歉,没有找到你想要的车";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColorFromRGBValue(0x9d9d9d);
        label.frame = CGRectMake(0, 5, HCSCREEN_WIDTH, HCSCREEN_WIDTH*0.33);
        UIView *slashLine = [[UIView alloc] initWithFrame:CGRectMake(0, label.bottom, HCSCREEN_WIDTH, 5)];
        slashLine.backgroundColor = [UIColor colorWithRed:0.98f green:0.96f blue:0.96f alpha:1.00f];;
        [self addSubview:slashLine];
        [self addSubview:label];
//        UILabel *gusselike = [[UILabel alloc]init];
//        gusselike.text = @"猜你喜欢";
//        gusselike.textAlignment = NSTextAlignmentLeft;
//        gusselike.textColor = UIColorFromRGBValue(0x9d9d9d);
//        gusselike.frame = CGRectMake(20, slashLine.bottom, HCSCREEN_WIDTH, HCSCREEN_WIDTH*0.14);
        //[self addSubview:gusselike];
//        UIView *redview = [[UIView alloc]init];
//        redview.backgroundColor = PRICE_STY_CORLOR;
//        redview.frame = CGRectMake(10,slashLine.bottom+(HCSCREEN_WIDTH*0.14-12)/2, 4, 12);
//        redview.layer.cornerRadius = 2.0;
//        [self addSubview:redview];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
