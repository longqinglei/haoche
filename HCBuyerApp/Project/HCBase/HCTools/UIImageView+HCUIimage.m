//
//  UIImageView+HCUIimage.m
//  HCBuyerApp
//
//  Created by haoche51 on 16/4/14.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "UIImageView+HCUIimage.h"

@implementation UIImageView (HCUIimage)


+(UIImageView *)initWith:(CGRect)frame str:(NSString *)str bcakGroud:(UIColor *)color view:(UIView *)view{
    UIImageView *imageVIew = [[UIImageView alloc]initWithFrame:frame];
    imageVIew.image = [UIImage imageNamed:str];
    imageVIew.backgroundColor = color;
    [view addSubview:imageVIew];
    return imageVIew;
}



@end
