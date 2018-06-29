//
//  NavView.m
//  HCBuyerApp
//
//  Created by haoche51 on 15/8/18.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "NavView.h"
#import "UIImage+RTTint.h"

@implementation NavView

- (id) initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initUiView];
    }
    return self;
}

- (void)initUiView
{
    self.backgroundColor = PAGE_STYLE_COLOR;
    _labelText = [UILabel labelWithFrame:CGRectMake(60, 27, HCSCREEN_WIDTH-120, 30) text:nil textColor:UIColorFromRGBValue(0x424242) font:[UIFont systemFontOfSize:18] tag:0 hasShadow:NO isCenter:YES];
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame =  CGRectMake(16, 22, 40, 40);
    _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    UIImage *img = [UIImage imageNamed:@"back"];
    img = [img rt_tintedImageWithColor:[UIColor blackColor]];
    [_button setImage:img forState:UIControlStateNormal];
    [self addSubview:_button];
    [self addSubview:_labelText];
    UILabel *lable = [[UILabel alloc]init];
    lable.backgroundColor = [UIColor lightGrayColor];
    lable.frame = CGRectMake(0, self.height-0.5, HCSCREEN_WIDTH, 0.5);
    [self addSubview:lable];
}


- (void)setLabelText:(UILabel *)labelText
{
    _labelText.text = labelText.text;
    _labelText.textAlignment = NSTextAlignmentCenter;
}

- (void)setButton:(UIButton *)button
{
    

}
    
@end
