//
//  UIView+ITTAdditions.m
//  iTotemFrame
//
//  Created by jack 廉洁 on 3/15/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "UIView+ITTAdditions.h"
#import "UIImageView+WebCache.h"
UIInterfaceOrientation ITTInterfaceOrientation() {
    UIInterfaceOrientation orient = [UIApplication sharedApplication].statusBarOrientation;
    return orient;
}

CGRect ITTScreenBounds() {
    CGRect bounds = [UIScreen mainScreen].bounds;
    if (UIInterfaceOrientationIsLandscape(ITTInterfaceOrientation())) {
        CGFloat width = bounds.size.width;
        bounds.size.width = bounds.size.height;
        bounds.size.height = width;
    }
    return bounds;
}

@implementation UIView (ITTAdditions)
#define MVIEW(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:0.6]

+(UIView *)view:(BOOL)isCollection addView:(UIView *)view
{
   UIView * _mBalloonView = [[UIView alloc]initWithFrame:CGRectMake(HCSCREEN_WIDTH/3, HCSCREEN_HEIGHT/2.3, HCSCREEN_WIDTH/3, HCSCREEN_WIDTH/4.5)];
    _mBalloonView.backgroundColor = [UIColor colorWithRed:0.15f green:0.15f blue:0.15f alpha:0.60f];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(_mBalloonView.width/2.5, 10, 25, 25)];
    UILabel *labelText = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.bottom+7, _mBalloonView.width, 30)];
    labelText.textAlignment = NSTextAlignmentCenter;
    labelText.textColor = [UIColor whiteColor];
    labelText.font = [UIFont systemFontOfSize:15];
    if (isCollection == YES) {
        imageView.image = [UIImage imageNamed:@"collectionActivation"];
        labelText.text = @"已收藏";
    }else{
        imageView.image = [UIImage imageNamed:@"cancelImage"];
        labelText.text = @"已取消";
    }
    [_mBalloonView addSubview:labelText];
    [_mBalloonView addSubview:imageView];
    [view addSubview:_mBalloonView];
    return _mBalloonView;
}


+ (UILabel *)numberAddView:(UIView *)view and:(NSInteger)vehicleNum
{
        UILabel *mViewLanel =[[UILabel alloc]initWithFrame:CGRectMake(HCSCREEN_WIDTH/3.5, 5, HCSCREEN_WIDTH-HCSCREEN_WIDTH/3.5*2, 18)];
        mViewLanel.backgroundColor = [UIColor colorWithRed:0.35f green:0.35f blue:0.35f alpha:0.80f];
        mViewLanel.textAlignment = NSTextAlignmentCenter;
        mViewLanel.layer.cornerRadius = 9;
        mViewLanel.layer.masksToBounds = YES;
        mViewLanel.textColor = [UIColor whiteColor];
        mViewLanel.font = [UIFont boldSystemFontOfSize:10];
        mViewLanel.text = [NSString stringWithFormat:@"为您找到%ld辆超值好车",(long)vehicleNum];
        [view addSubview:mViewLanel];
        return mViewLanel;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)left {
    return self.frame.origin.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top {
    return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
    return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
    return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width {
    return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height {
    return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
    }
    return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
    }
    return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            x -= scrollView.contentOffset.x;
        }
    }
    
    return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)screenFrame {
    return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)origin {
    return self.frame.origin;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)size {
    return self.frame.size;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)orientationWidth {
    return UIInterfaceOrientationIsLandscape(ITTInterfaceOrientation())
    ? self.height : self.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)orientationHeight {
    return UIInterfaceOrientationIsLandscape(ITTInterfaceOrientation())
    ? self.width : self.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)descendantOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls])
        return self;
    
    for (UIView* child in self.subviews) {
        UIView* it = [child descendantOrSelfWithClass:cls];
        if (it)
            return it;
    }
    
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)ancestorOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls]) {
        return self;
        
    } else if (self.superview) {
        return [self.superview ancestorOrSelfWithClass:cls];
        
    } else {
        return nil;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)offsetFromView:(UIView*)otherView {
    CGFloat x = 0, y = 0;
    for (UIView* view = self; view && view != otherView; view = view.superview) {
        x += view.left;
        y += view.top;
    }
    return CGPointMake(x, y);
}

/**
 *  评价
 *
 *  @param frame   <#frame description#>
 *  @param strName <#strName description#>
 *  @param phone   <#phone description#>
 *  @param strTime <#strTime description#>
 *  @param title   <#title description#>
 *  @param score   <#score description#>
 *
 *  @return <#return value description#>
 */

+(UIView*)viewModel:(CGRect)frame imageUrl:(NSString *)imageUrl phone:(NSString *)phone time:(NSString *)strTime evaluateDetail:(NSString *)evaluateDetail and:(float)score
{
    UIView *mView = [[UIView alloc]initWithFrame:frame];
    mView.layer.cornerRadius = 5;
    
    mView.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *labelTextMa = [UIView frame:CGRectMake(mView.width*0.84, 10, mView.width*0.17, 17) font:11 name:@"买家评价" color:[UIColor whiteColor]];
    labelTextMa.textAlignment = NSTextAlignmentCenter;
    labelTextMa.clipsToBounds = YES;
    labelTextMa.layer.cornerRadius = 2;
    
    labelTextMa.font = [UIFont boldSystemFontOfSize:10];
    labelTextMa.backgroundColor = [UIColor colorWithRed:1.00f green:0.31f blue:0.31f alpha:0.80f];
    [mView addSubview:labelTextMa];
    
    
    UIImageView *imageView = [UIView image:imageUrl add:mView];
    UILabel *labelPhone = [UIView frame:CGRectMake(imageView.right+10, 25, HCSCREEN_WIDTH/3.7, 15) font:13 name:[phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"] color:[UIColor blackColor]];
    
    
    for (int i = 0; i<5; i++) {
        UIImageView *noxinxin = [[UIImageView alloc]initWithFrame:CGRectMake(labelPhone.right+i*12,labelPhone.top+2, 10, 10)];
        noxinxin.image = [UIImage imageNamed:@"noxx"];
        [mView addSubview:noxinxin];
    }
    
    
    UILabel *labelTextNumber = [[UILabel alloc]initWithFrame:CGRectMake(labelPhone.right+5*13, labelPhone.top+3, 40, 10)];
    NSString *str = [NSString stringWithFormat:@"%.1f",score];
    
    
    
    labelTextNumber.text = str;
    labelTextNumber.textAlignment = NSTextAlignmentLeft;
    labelTextNumber.font = [UIFont systemFontOfSize:11];
    labelTextNumber.textColor = UIColorFromRGBValue(0xffcc00);
    [mView addSubview:labelTextNumber];
    
    
    
    [self image:score l:labelPhone and:mView];
    UILabel *labelTime = [UIView frame:CGRectMake(imageView.right+10, 50, HCSCREEN_WIDTH-imageView.right-40, 10) font:12 name:strTime color:UIColorFromRGBValue(0x929292)];
    if (HCSCREEN_WIDTH>320) {
        labelTime.font = [UIFont systemFontOfSize:12];
    }else{
        labelTime.font = [UIFont systemFontOfSize:11];
    }
    UILabel *labelText = [UIView attributed:evaluateDetail m:imageView v:mView];
    [mView addSubview:labelTime];
    [mView addSubview:labelText];
    [mView addSubview:labelPhone];
    
    
    return mView;
}

+(void)image:(float)score l:(UILabel *)labelPhone and:(UIView *)mView{
    if (score==1||score==2||score==3||score==4||score==5) {
        for (int i = 0; i<score; i++) {
            UIImageView *noxinxin = [[UIImageView alloc]initWithFrame:CGRectMake(labelPhone.right+i*12,labelPhone.top+2, 10, 10)];

            noxinxin.image = [UIImage imageNamed:@"xxha"];
            [mView addSubview:noxinxin];
        }
    }
    
    if (score==0.5||score==1.5||score==2.5||score==3.5||score==4.5) {
        float num = score+0.5;
        for (int i = 0; i<num; i++) {
              UIImageView *noxinxin = [[UIImageView alloc]initWithFrame:CGRectMake(labelPhone.right+i*12,labelPhone.top+2, 10, 10)];
            if (i<num-1) {
                noxinxin.image = [UIImage imageNamed:@"xxha"];
            }else{
                noxinxin.image = [UIImage imageNamed:@"pJImage"];
            }
            [mView addSubview:noxinxin];
        }
    }
}

+ (UILabel *)attributed:(NSString *)title m:(UIImageView*)imageView v:(UIView*)mView
{
    UILabel *label = [UIView frame:CGRectMake(20, imageView.bottom+18, mView.width-40, mView.height/2.5) font:14 name:title color:UIColorFromRGBValue(0x212121)];
    if (HCSCREEN_WIDTH>320) {
        [label setTop:imageView.bottom+15];
        label.font = [UIFont systemFontOfSize:14];
    }else{
         [label setTop:imageView.bottom+12];
         label.font = [UIFont systemFontOfSize:13];
    }
    if (title==nil) {
        title=@"";
    }
    NSMutableAttributedString *attributede = [[NSMutableAttributedString alloc]initWithString:title];
    NSMutableParagraphStyle *paragra = [[NSMutableParagraphStyle alloc]init];
    [paragra setLineSpacing:7];
    label.numberOfLines = 2;
    [attributede addAttribute:NSParagraphStyleAttributeName value:paragra range:NSMakeRange(0, [title length])];
    label.attributedText = attributede;
    return label;
}

+(UILabel *)frame:(CGRect)fram font:(int)font name:(NSString*)name color:(UIColor*)color{
    UILabel *labelAll = [[UILabel alloc]initWithFrame:fram];
    labelAll.font = [UIFont systemFontOfSize:font];
    labelAll.text = name;
    labelAll.textColor = color;
    return labelAll;
}

+(UIImageView *)image:(NSString *)imageurl add:(UIView *)view
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, HCSCREEN_WIDTH/8, HCSCREEN_WIDTH/8)];
    imageView.layer.masksToBounds =YES;
    imageView.layer.cornerRadius = HCSCREEN_WIDTH/8/2;
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageurl]];
    [view addSubview:imageView];
    return imageView;
}

#pragma mark - homeView

+ (UIView *)viewbackAddSuperVIew:(CGRect)frame
{
    UIView *viewback = [[UIView alloc]initWithFrame:frame];
    viewback.backgroundColor =  [UIColor blackColor];
    viewback.hidden = YES;
    viewback.userInteractionEnabled = YES;
    viewback.alpha = 0.5;
    return viewback;
}

+ (UIImageView*)createImageViewWithImage:(NSString*)imagename frame:(CGRect)frame{
    UIImageView *imageview = [[UIImageView alloc]init];
    imageview.image = [UIImage imageNamed:imagename];
    imageview.frame = frame;
    return imageview;
}
+(UIView *)viewClen:(UIView *)view
{
    UIView *sortBg = [[UIView alloc]init];
    sortBg.frame = CGRectMake(0, 64, HCSCREEN_WIDTH, HCSCREEN_HEIGHT-64-49);
    sortBg.backgroundColor = [UIColor clearColor];
    sortBg.hidden = YES;
    [view addSubview:sortBg];
    sortBg.userInteractionEnabled = YES;
    return sortBg;
}
#define Button_Height 70    // 高
#define Button_Width HCSCREEN_WIDTH/2      // 宽

#define Butto_Height _mButtonbannerOne.height/4.1    // 高
#define Butto_Width _mButtonbannerOne.height/4.1      // 宽

//+(UIView *)viewbackHChomeFixed:(UIView *)view
//{
//    
//    UIView *mView = [[UIView alloc]initWithFrame:CGRectMake(0, view.bottom-210, HCSCREEN_WIDTH, 210)];
//    mView.backgroundColor = [UIColor redColor];
//    [view addSubview:mView];
//    
//     UILabel * _label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, 8)];
//    _label.backgroundColor = MTABLEBACK;
//    [mView addSubview:_label];
//    NSArray *arrayTitleView = @[@"100%个人二手车",@"218项专业检测",@"14天可退1年质保",@"检测失误随时赔付"];
//    NSArray *arrayImageView = @[@"ershouche",@"jiance",@"zhibao",@"peichang"];
//    for (int i = 0 ; i < 4; i++) {
//        NSInteger index = i % 2;
//        NSInteger page = i / 2;
//        UIButton *  _mButtonbannerOne = [UIButton buttonWithType:UIButtonTypeCustom];
//        _mButtonbannerOne.backgroundColor = [UIColor whiteColor];
//        _mButtonbannerOne.frame = CGRectMake(index * (Button_Width ), page  * (75)+ 8, Button_Width, Button_Height);
//        [UILabel text:_mButtonbannerOne w:Button_Width h:Button_Height a:arrayTitleView i:i];
////        if (i==0) {
////            [uila createlinelabelcrossLabelframe:CGRectMake(20, _mButtonbannerOne.height-0.5, _mButtonbannerOne.width-20, 0.5) verticallabelframe:CGRectMake(_mButtonbannerOne.width-0.5, 10, 0.5, _mButtonbannerOne.height-10) btn:_mButtonbannerOne];
////        }else if(i==3){
////            [self createlinelabelcrossLabelframe:CGRectMake(0, 0, _mButtonbannerOne.width-20, 0.5) verticallabelframe:CGRectMake(0, 0, 0.5, _mButtonbannerOne.height-10) btn:_mButtonbannerOne];
////        }
//        [_mButtonbannerOne addSubview:[UIView createImageViewWithImage:[arrayImageView HCObjectAtIndex:i] frame:CGRectMake((Button_Width-Butto_Width)/2, 15, Butto_Width, Butto_Height)]];
//        [mView addSubview:_mButtonbannerOne];
//    }
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((HCSCREEN_WIDTH-HCSCREEN_WIDTH/7.8)/2, (75*2-HCSCREEN_WIDTH/7.8)/2+8, HCSCREEN_WIDTH/7.8, HCSCREEN_WIDTH/7.8)];
//    imageView.userInteractionEnabled = YES;
//    imageView.image = [UIImage imageNamed:@"fuwubaozhuang"];
//    [mView addSubview:imageView];
//    return mView;
//}



@end
