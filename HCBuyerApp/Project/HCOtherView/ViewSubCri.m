//
//  ViewSubCri.m
//  HCBuyerApp
//
//  Created by haoche51 on 15/8/22.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "ViewSubCri.h"

@implementation ViewSubCri 

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)button:(CGRect)rect and:(UIView *)view
{
    UIButton *button = [[UIButton alloc]initWithFrame:rect];
    [button setTitle:@"立即找车" forState:UIControlStateNormal];
    button.backgroundColor = PRICE_STY_CORLOR;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnckcok:) forControlEvents:UIControlEventTouchUpInside];
    [button.layer setCornerRadius:3.0];
    if (HCSCREEN_WIDTH > 320) {
        button.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    }else{
        button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    [view addSubview:button];
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self view:@"NoImage" title: @""];
    }
    return self;
}


- (id) initWithFrameCollection:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self view:@"Collectionlanding" title:@""];
    }
    return self;
}

- (void)btnckcok:(UIButton *)btn
{
    if (self.delegate) {
        [self.delegate LoginControllerJump];
    }
    if (self.CollectionDelegate) {
        [self.CollectionDelegate ViewCollectionJmp];
    }
}

- (void)view:(NSString *)ImageName title:(NSString *)title
{
    UIView *scrollView = [[UIView alloc] init];
    scrollView.frame = CGRectMake(0, 1, HCSCREEN_WIDTH,HCSCREEN_HEIGHT);
    scrollView.backgroundColor = [UIColor whiteColor];
    [self addSubview:scrollView];
    CGFloat imageY;
    if (HCSCREEN_HEIGHT==480) {
        imageY = HCSCREEN_WIDTH*0.2-30;
    }else{
        imageY = HCSCREEN_WIDTH*0.2;
    }
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((HCSCREEN_WIDTH-HCSCREEN_WIDTH*0.74)/2,imageY, HCSCREEN_WIDTH*0.74, HCSCREEN_WIDTH*0.93)];
    
    
    imageView.image = [UIImage imageNamed:ImageName];
    [scrollView addSubview:imageView];
    
    if (HCSCREEN_WIDTH > 320) {
        [self button:CGRectMake(HCSCREEN_WIDTH/3, imageView.bottom+15, HCSCREEN_WIDTH/3, 40) and:scrollView];
    }else{
        [self button:CGRectMake(HCSCREEN_WIDTH/3, imageView.bottom+15, HCSCREEN_WIDTH/3, 35) and:scrollView];
    }
    
}

@end
