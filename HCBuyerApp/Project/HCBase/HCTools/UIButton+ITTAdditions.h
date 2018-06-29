//
//  UIButton+ITTAdditions.h
//  iTotemFrame
//
//  Created by jack 廉洁 on 3/15/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ITTAdditions)

+ (UIButton *)buttonWithFrame:(CGRect)frame
                        title:(NSString *)title 
                   titleColor:(UIColor *)titleColor
          titleHighlightColor:(UIColor *)titleHighlightColor
                    titleFont:(UIFont *)titleFont
                        image:(UIImage *)imageName
                  tappedImage:(UIImage *)tappedImageName
                       target:(id)target 
                       action:(SEL)selector 
                          tag:(NSInteger)tag;
+ (UIButton *)buttonWithFrame:(CGRect)frame
                        title:(NSString *)title
                   titleColor:(UIColor *)titleColor
                      bgColor:(UIColor *)bgcolor
                    titleFont:(UIFont *)titleFont
                        image:(UIImage *)image
                  selectImage:(UIImage *)selectImage
                       target:(id)target
                       action:(SEL)selector
                          tag:(NSInteger)tag;


//上下居中，图片在上，文字在下
- (void)verticalCenterImageAndTitle:(CGFloat)spacing;
- (void)verticalCenterImageAndTitle; //默认6.0

//左右居中，文字在左，图片在右
- (void)horizontalCenterTitleAndImage:(CGFloat)spacing;
- (void)horizontalCenterTitleAndImage; //默认6.0

//左右居中，图片在左，文字在右
- (void)horizontalCenterImageAndTitle:(CGFloat)spacing;
- (void)horizontalCenterImageAndTitle; //默认6.0

//文字居中，图片在左边
- (void)horizontalCenterTitleAndImageLeft:(CGFloat)spacing;
- (void)horizontalCenterTitleAndImageLeft; //默认6.0

//文字居中，图片在右边
- (void)horizontalCenterTitleAndImageRight:(CGFloat)spacing;
- (void)horizontalCenterTitleAndImageRight; //默认6.0


+(UIButton *)TwoButtoFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor backColor:(UIColor *)backColor titleFont:(UIFont *)titleFont target:(id)target action:(SEL)selector tag:(NSInteger)tag;

+(UIButton *)initCreatSort:(UIView *)view target:(id)target action:(SEL)selector;
+ (UIButton *)listView:(UIView *)view target:(id)target action:(SEL)selector;
+ (UIButton *)listAddSub:(UIButton *)btn;
+(UIButton *)buttonsuccess:(UIButton *)btn and:(UIView *)mView;
+(UIButton *)consultation:(NSString *)_iphone target:(id)target action:(SEL)selector view:(UIView *)view;

@end
