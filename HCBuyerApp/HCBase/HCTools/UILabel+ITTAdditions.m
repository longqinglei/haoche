//
//  UILabel+ITTAdditions.m
//  iTotemFrame
//
//  Created by jack 廉洁 on 3/15/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "UILabel+ITTAdditions.h"

@implementation UILabel (ITTAdditions)



+ (UILabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                  textColor:(UIColor *)textColor
                       font:(UIFont *)font
                        tag:(NSInteger)tag
                  hasShadow:(BOOL)hasShadow
                   isCenter:(BOOL)isCenter{
	UILabel *label = [[UILabel alloc] initWithFrame:frame];
	label.text = text;
	label.textColor = textColor;
	label.backgroundColor = [UIColor clearColor];
	if( hasShadow ){
		label.shadowColor = [UIColor blackColor];
		label.shadowOffset = CGSizeMake(1,1);
	}
    if (isCenter == YES) {
        label.textAlignment = NSTextAlignmentCenter;
    }else{
        label.textAlignment = NSTextAlignmentLeft;
    }
	label.font = font;
	label.tag = tag;
	
	return label;
}

+ (UILabel *)labelFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font background:(UIColor*)color isCenter:(BOOL)isCenter{
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = textColor;
    label.backgroundColor = color;
    if (isCenter == YES) {
        label.textAlignment = NSTextAlignmentCenter;
    }else{
        label.textAlignment = NSTextAlignmentLeft;
    }
    label.font = font;
    return label;
}




+ (UILabel *)labelForNavigationBarWithTitle:(NSString*)title
                                  textColor:(UIColor *)textColor
                                       font:(UIFont *)font
                                  hasShadow:(BOOL)hasShadow{
	UILabel *titleLabel = [UILabel labelWithFrame:CGRectMake(0,0,320,44)
                                           text:title
                                      textColor:textColor
                                           font:font
                                            tag:0
                                      hasShadow:hasShadow
                                       isCenter:YES];
	return titleLabel;
}

+ (UILabel *)labelWithPage
{
     UILabel * _pageLabel  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH-(HCSCREEN_WIDTH/2.34*2), 20)];
    _pageLabel.backgroundColor = [UIColor colorWithRed:0.35f green:0.35f blue:0.35f alpha:0.80f];
    _pageLabel.textColor = [UIColor whiteColor];
    _pageLabel.font = [UIFont systemFontOfSize:11];
    _pageLabel.textAlignment = NSTextAlignmentCenter;
    _pageLabel.layer.cornerRadius = 10.0f;
    _pageLabel.layer.masksToBounds = YES;
    return _pageLabel;
}

- (void)timePage:(NSInteger)number label:(UILabel *)label  int:(int)page add:(UIView*)view
{
    [label removeFromSuperview];
    label = [UILabel labelWithPage];
    if (number == 1) {
        label.text = [NSString stringWithFormat:@"1/%d",page];
    }else{
        label.text = [NSString stringWithFormat:@"%ld/%d",(long)number,page];
    }
    [view addSubview:label];

}

+ (UILabel*)creat:(UIView *)view title:(NSString *)title
{
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(30, 20, 80, 16);
    label.font = [UIFont systemFontOfSize:16];
    label.text = title;
    label.textColor = UIColorFromRGBValue(0x424242);
    UILabel *viewTile = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 4, 16)];
    viewTile.tag = 101;
    viewTile.layer.cornerRadius = 1.0f;
    viewTile.layer.masksToBounds = YES;
    viewTile.backgroundColor = [UIColor colorWithRed:1.00f green:0.15f blue:0.15f alpha:1.00f];
    [view addSubview:viewTile];
    label.textColor = UIColorFromRGBValue(0x212121);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:16];
    [view addSubview:label];
    return label;
}




@end
