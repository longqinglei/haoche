//
//  UIButton+ITTAdditions.m
//  iTotemFrame
//
//  Created by jack 廉洁 on 3/15/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "UIButton+ITTAdditions.h"

@implementation UIButton (ITTAdditions)

+ (UIButton *)buttonWithFrame:(CGRect)frame
                        title:(NSString *)title 
                   titleColor:(UIColor *)titleColor
          titleHighlightColor:(UIColor *)titleHighlightColor
                    titleFont:(UIFont *)titleFont
                        image:(UIImage *)image
                  tappedImage:(UIImage *)tappedImage
                       target:(id)target 
                       action:(SEL)selector 
                          tag:(NSInteger)tag{
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = frame;
	if( title!=nil && title.length>0 ){
		[button setTitle:title forState:UIControlStateNormal];
		[button setTitleColor:titleColor forState:UIControlStateNormal];
		[button setTitleColor:titleHighlightColor forState:UIControlStateHighlighted];
		button.titleLabel.font = titleFont;
	}
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	button.tag = tag;
	if( image){
		[button setBackgroundImage:image forState:UIControlStateNormal];
	}
	if( tappedImage){
		[button setBackgroundImage:tappedImage forState:UIControlStateHighlighted];
	}
	
	return button;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame
                        title:(NSString *)title
                   titleColor:(UIColor *)titleColor
                      bgColor:(UIColor *)bgcolor
                    titleFont:(UIFont *)titleFont
                        image:(UIImage *)image
                  selectImage:(UIImage *)selectImage
                       target:(id)target
                       action:(SEL)selector
                          tag:(NSInteger)tag{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundColor:bgcolor];
    if( title!=nil && title.length>0 ){
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:titleColor forState:UIControlStateNormal];
        button.titleLabel.font = titleFont;
    }
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selectImage forState:UIControlStateSelected];
    return button;
}

- (void)verticalCenterImageAndTitle:(CGFloat)spacing
{
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
   // CGSize titleSize = self.titleLabel.frame.size;
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (imageSize.height + spacing/2), 0.0);
    
    // the text width might have changed (in case it was shortened before due to
    // lack of space and isn't anymore now), so we get the frame size again
  CGSize titleSize  = self.titleLabel.frame.size;
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + spacing/2), 0.0, 0.0, - titleSize.width);
}

- (void)verticalCenterImageAndTitle
{
    const int DEFAULT_SPACING = 6.0f;
    [self verticalCenterImageAndTitle:DEFAULT_SPACING];
}


- (void)horizontalCenterTitleAndImage:(CGFloat)spacing
{
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    //CGSize titleSize = self.titleLabel.frame.size;
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, 0.0, imageSize.width + spacing/2);
    
    // the text width might have changed (in case it was shortened before due to
    // lack of space and isn't anymore now), so we get the frame size again
    CGSize titleSize  = self.titleLabel.frame.size;
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, titleSize.width + spacing/2, 0.0, - titleSize.width);
}

- (void)horizontalCenterTitleAndImage
{
    const int DEFAULT_SPACING = 6.0f;
    [self horizontalCenterTitleAndImage:DEFAULT_SPACING];
}


- (void)horizontalCenterImageAndTitle:(CGFloat)spacing;
{
    // get the size of the elements here for readability
    //    CGSize imageSize = self.imageView.frame.size;
    //    CGSize titleSize = self.titleLabel.frame.size;
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0,  0.0, 0.0,  - spacing/2);
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, - spacing/2, 0.0, 0.0);
}

- (void)horizontalCenterImageAndTitle;
{
    const int DEFAULT_SPACING = 6.0f;
    [self horizontalCenterImageAndTitle:DEFAULT_SPACING];
}


- (void)horizontalCenterTitleAndImageLeft:(CGFloat)spacing
{
    // get the size of the elements here for readability
    //    CGSize imageSize = self.imageView.frame.size;
    //    CGSize titleSize = self.titleLabel.frame.size;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, - spacing, 0.0, 0.0);
}

- (void)horizontalCenterTitleAndImageLeft
{
    const int DEFAULT_SPACING = 6.0f;
    [self horizontalCenterTitleAndImageLeft:DEFAULT_SPACING];
}


- (void)horizontalCenterTitleAndImageRight:(CGFloat)spacing
{
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, 0.0, 0.0);
    
    // the text width might have changed (in case it was shortened before due to
    // lack of space and isn't anymore now), so we get the frame size again
 // CGSize titleSize  = self.titleLabel.frame.size;
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, titleSize.width + imageSize.width + spacing, 0.0, - titleSize.width);
}

- (void)horizontalCenterTitleAndImageRight
{
    const int DEFAULT_SPACING = 6.0f;
    [self horizontalCenterTitleAndImageRight:DEFAULT_SPACING];
}





+(UIButton *)TwoButtoFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor backColor:(UIColor *)backColor titleFont:(UIFont *)titleFont target:(id)target action:(SEL)selector tag:(NSInteger)tag{

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    if( title!=nil && title.length>0 ){
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:titleColor forState:UIControlStateNormal];
        button.titleLabel.font = titleFont;
    }
    button.backgroundColor = backColor;
    button.layer.borderColor =PRICE_STY_CORLOR.CGColor;
    button.layer.borderWidth =0.5;
    button.layer.cornerRadius = 0.5;
    button.layer.masksToBounds = YES;
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    button.selected = YES;
    return button;
}



+(UIButton *)initCreatSort:(UIView *)view target:(id)target action:(SEL)selector
{
    UIButton *sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sortBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    sortBtn.titleEdgeInsets = UIEdgeInsetsMake(15, -13, 0, 0);
    sortBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 15, -25);
    [sortBtn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [sortBtn setBackgroundImage:[UIImage imageNamed:@"sortBgBlack"] forState:UIControlStateNormal];
    [sortBtn setImage:[UIImage imageNamed:@"sortBlack"] forState:UIControlStateNormal];
    [sortBtn setTitle:@"排序" forState:UIControlStateNormal];
    [sortBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sortBtn.frame = CGRectMake(HCSCREEN_WIDTH-15-HCSCREEN_WIDTH*0.14, HCSCREEN_HEIGHT-HCSCREEN_WIDTH*0.14-70, HCSCREEN_WIDTH*0.14, HCSCREEN_WIDTH*0.14);
    sortBtn.layer.cornerRadius = HCSCREEN_WIDTH*0.1;
    [view addSubview:sortBtn];
    return sortBtn;
}

+ (UIButton *)listView:(UIView *)view target:(id)target action:(SEL)selector
{
    UIButton *version = [UIButton buttonWithType:UIButtonTypeCustom];
    version.backgroundColor = PRICE_STY_CORLOR;
    [version setTitle:@"上新提醒" forState:UIControlStateNormal];
    version.frame = CGRectMake(HCSCREEN_WIDTH-80, 8, 70, 34);
    version.userInteractionEnabled = YES;
    [version setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [version addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    version.titleLabel.font = [UIFont systemFontOfSize:13];
    [view addSubview:version];
    return version;
}

+ (UIButton *)listAddSub:(UIButton *)btn
{
    if (btn) {
        btn.frame = CGRectMake(HCSCREEN_WIDTH-80, 8, 70, 34);
        [btn setTitle:@"上新提醒" forState:UIControlStateNormal];
        btn.tag = 104;
        [btn.layer setMasksToBounds:YES];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return btn;
}

+(UIButton *)buttonsuccess:(UIButton *)btn and:(UIView *)mView
{
    if (btn) {
        btn.frame = CGRectMake(HCSCREEN_WIDTH-80, 8, 70, 34);
        [btn setTitle:@"成功提醒" forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = 102;
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [mView addSubview:btn];
    }
    return btn;
}

+(UIButton *)consultation:(NSString *)_iphone target:(id)target action:(SEL)selector view:(UIView *)view
{
    UIButton*button = [UIButton buttonWithFrame:CGRectMake(0, 160, HCSCREEN_WIDTH, 50) title:[NSString stringWithFormat:@"咨询电话:%@",_iphone] titleColor:UIColorFromRGBValue(0x999999) bgColor:MTABLEBACK titleFont:[UIFont systemFontOfSize:14] image:nil selectImage:nil target:target action:selector tag:0];
    [view addSubview:button];
    return button;
}







@end
