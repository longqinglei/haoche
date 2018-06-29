//
//  Submit SaleInterfaceView.m
//  HCBuyerApp
//
//  Created by haoche51 on 15/11/10.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "Submit SaleInterfaceView.h"

@implementation Submit_SaleInterfaceView

- (id) initWithFrame:(CGRect)frame and:(NSString*)title and:(NSString *)description
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initView:title and:description];
    }
    return self;
}

- (void)initView:(NSString *)titile and:(NSString *)description
{
    NSString *numstr =titile;
    NSString *buttonTitle = description;
    UIView *mainView = [[UIView alloc]init];
  
    mainView.backgroundColor = [UIColor whiteColor];
    if (iPhone4s) {
        mainView.frame = CGRectMake((HCSCREEN_WIDTH-HCSCREEN_WIDTH*3/4)/2, HCSCREEN_HEIGHT/4, HCSCREEN_WIDTH*3/4, HCSCREEN_HEIGHT/2.6);
    }else{
        mainView.frame = CGRectMake((HCSCREEN_WIDTH-HCSCREEN_WIDTH*3/4)/2, HCSCREEN_HEIGHT/4, HCSCREEN_WIDTH*3/4, HCSCREEN_HEIGHT/2.8);
    }
    
    UIImageView *mImageView = [[UIImageView alloc]initWithFrame:CGRectMake(mainView.width/2.3, mainView.height/10, mainView.width/7.5, mainView.width/7.5)];
    mImageView.image = [UIImage imageNamed:@"ditch"];
    [mainView addSubview:mImageView];
    
    UILabel *mLabelText = [UILabel labelWithFrame:CGRectMake(0, mainView.height/3, mainView.width, 20) text:numstr textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:16] tag:0 hasShadow:NO isCenter:YES];
    UILabel *infoLabel = [UILabel labelWithFrame:CGRectMake(15, mLabelText.bottom, mainView.width-30, 70) text:buttonTitle textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:14] tag:0 hasShadow:NO isCenter:NO];
    infoLabel.numberOfLines = 0;
    UIButton *close = [UIButton buttonWithFrame:CGRectMake(mainView.right-mainView.width/8-10, mainView.top-15, mainView.width/8, mainView.width/8) title:nil titleColor:nil bgColor:nil titleFont:nil image:[UIImage imageNamed:@"close"] selectImage:nil target:self action:@selector(closeClick) tag:0];
    UIButton *button = [UIButton buttonWithFrame:CGRectMake(mainView.width/3.3, infoLabel.bottom, mainView.width/2.6, mainView.height/6.5) title:@"立即去查看" titleColor:[UIColor whiteColor] bgColor:PRICE_STY_CORLOR titleFont:[UIFont boldSystemFontOfSize:14] image:nil selectImage:nil target:self action:@selector(checkCoupon) tag:0];
    [button.layer setCornerRadius:3.0];
    [button.layer setMasksToBounds:YES];
    [button.layer setBorderWidth:1.0];
    [button.layer setBorderColor:(__bridge CGColorRef)(PRICE_STY_CORLOR)];
    [mainView addSubview:mLabelText];
    [mainView addSubview:button];
    [mainView addSubview:infoLabel];
    [self addSubview:mainView];
    [self addSubview:close];
}

- (void)closeClick{
    [self removeFromSuperview];
    if (self.delegate) {
        [self.delegate removeFromSuperView];
    }
    
}
- (void)checkCoupon{
    [self closeClick];
    if (self.delegate) {
        [self.delegate subMit];
    }
}

@end
