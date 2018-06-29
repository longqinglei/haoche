//
//  UILabel+ITTAdditions.h
//  iTotemFrame
//
//  Created by jack 廉洁 on 3/15/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ITTAdditions)

+ (UILabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                  textColor:(UIColor *)textColor
                       font:(UIFont *)font
                        tag:(NSInteger)tag
                  hasShadow:(BOOL)hasShadow
                   isCenter:(BOOL)isCenter;
+ (UILabel *)labelForNavigationBarWithTitle:(NSString*)title
                                  textColor:(UIColor *)textColor
                                       font:(UIFont *)font
                                  hasShadow:(BOOL)hasShadow;

+ (UILabel *)labelWithPage;

- (void)timePage:(NSInteger)number label:(UILabel *)label  int:(int)page add:(UIView*)view;

+ (UILabel*)creat:(UIView *)view title:(NSString *)title;

//+ (UILabel* )text:(UIView *)view w:(CGFloat)w h:(CGFloat)h a:(NSArray*)a i:(int)i;


+ (UILabel *)labelFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font background:(UIColor*)color isCenter:(BOOL)isCenter;
//+(UILabel *)textFixed:(UIButton *)btn f:(CGRect)frame;
//+(UILabel *)textFixedVertical:(UIButton*)btn f:(CGRect)frame;
@end
