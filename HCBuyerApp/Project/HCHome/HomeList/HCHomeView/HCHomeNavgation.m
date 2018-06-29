//
//  HCHomeNavgation.m
//  HCBuyerApp
//
//  Created by 张熙 on 16/5/24.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "HCHomeNavgation.h"

#import "UIImage+RTTint.h"
@implementation HCHomeNavgation


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)  {
        self.frame = CGRectMake(0, 0, HCSCREEN_WIDTH, 64);
        self.backgroundColor = [UIColor whiteColor];
        [self layer].shadowPath =[UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        //shadowColor阴影颜色
        self.layer.shadowOffset = CGSizeMake(0,1);
        //shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        self.layer.shadowOpacity = 0.3;
        //阴影透明度，默认0
        self.layer.shadowRadius =1;
        //阴影半径，默认3
        [self createCityBtn];
        [self createline];
        [self createSearchBtn];
        
    }
    return self;
}
- (void)createCityBtn{
    
    UIImage *img = [UIImage imageNamed:@"location"];
    img = [img rt_tintedImageWithColor:[UIColor blackColor]];
    self.cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cityBtn.frame = CGRectMake(HCSCREEN_WIDTH*0.08, 27, HCSCREEN_WIDTH*0.173, 30);
    [self.cityBtn setTitleColor:UIColorFromRGBValue(0x212121) forState:UIControlStateNormal];
    self.cityBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 1, 0, 0);
    self.cityBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    self.cityBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.cityBtn setImage:img forState:UIControlStateNormal];
    [self addSubview:self.cityBtn];
}
- (void)createSearchBtn{
    self.searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.searchBtn.frame = CGRectMake(self.cityBtn.right+2, 27, HCSCREEN_WIDTH*0.69, 30);
    [self.searchBtn setTitleColor:UIColorFromRGBValue(0x929292) forState:UIControlStateNormal];
    self.searchBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.searchBtn setImage:[UIImage imageNamed:@"app_seach"] forState:UIControlStateNormal];
    [self.searchBtn setTitle:@"请输入品牌/车系" forState:UIControlStateNormal];
    self.searchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 1, 0, 0);
    self.searchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [self addSubview:self.searchBtn];
}
- (void)createline{
    UILabel *linelabel = [[UILabel alloc]init];
    linelabel.frame = CGRectMake(self.cityBtn.right+1, 35, 1, 14);
    linelabel.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:linelabel];
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
