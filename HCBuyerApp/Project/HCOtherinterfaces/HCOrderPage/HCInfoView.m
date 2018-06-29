//
//  HCInfoView.m
//  HCBuyerApp
//
//  Created by 张熙 on 15/8/31.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "HCInfoView.h"

@implementation HCInfoView


- (id) initWithFrame:(CGRect)frame type:(NSInteger)type{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =  [UIColor colorWithRed:0.15f green:0.15f blue:0.15f alpha:0.50f];
       
        if (type == kMyOrderStatusOne) {
        [self createType1];
        }else if(type == kMyOrderStatusTwo){
        [self createType2];
        }else if(type == kMyOrderStatusThree){
        [self createType3];
        }
    }
    return self;
}

- (void)creatInfoView:(NSString *)text
{
    
    UIView *mainView = [[UIView alloc]init];
    mainView.frame = CGRectMake(HCSCREEN_WIDTH+100, HCSCREEN_HEIGHT*0.3-100,HCSCREEN_WIDTH*3/4, HCSCREEN_HEIGHT*0.35);
    [UIView animateWithDuration:1 animations:^{
        mainView.frame = CGRectMake(HCSCREEN_WIDTH/8, HCSCREEN_HEIGHT*0.3, HCSCREEN_WIDTH*3/4, HCSCREEN_HEIGHT*0.35);
    }];
    [mainView.layer setCornerRadius:6.0];
    [mainView.layer setMasksToBounds:YES];
    [mainView.layer setBorderWidth:0.1];
    
    mainView.backgroundColor = [UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.00f];
    [self addSubview:mainView];
    UIImageView *infoImage = [[UIImageView alloc]init];
    infoImage.frame = CGRectMake((mainView.width-mainView.width*13/48)/2, mainView.height/10, mainView.width*13/48, mainView.height*9/40);
   
 
    infoImage.image = [UIImage imageNamed:@"infoVehicle.png"];
    [mainView addSubview:infoImage];
    UILabel *infoLabel  = [UILabel labelWithFrame:CGRectMake(15, infoImage.bottom+15, mainView.width-30, 50) text:text textColor:[UIColor blackColor] font: [UIFont systemFontOfSize:17] tag:0 hasShadow:NO isCenter:NO];
    infoLabel.numberOfLines = 0;
    if (HCSCREEN_HEIGHT==480) {
        [infoImage setHeight:mainView.height*9/40+5];
        [infoLabel setTop:infoImage.bottom+10];
    }else{
        
    }
    UIButton *button = [UIButton buttonWithFrame:CGRectMake((mainView.width-mainView.width*47/120)/2, mainView.height*9/10-mainView.height/6, mainView.width*47/120, mainView.height/6) title:@"我知道啦" titleColor:[UIColor whiteColor] titleHighlightColor:0 titleFont:[UIFont boldSystemFontOfSize:17] image:nil tappedImage:nil target:self action:@selector(removeFromSuper) tag:1];
    button.backgroundColor =  PRICE_STY_CORLOR;
   
    [button.layer setCornerRadius:4.0];
    [button.layer setMasksToBounds:YES];
    [mainView addSubview:infoLabel];
    [mainView addSubview:button];
}

- (void)createType1
{
    [self creatInfoView:@"已成交的订单才可以使用优惠券哦,赶快完成订单吧~"];
}

- (void)createType3
{
    [self creatInfoView:@"您的订单已过期，规则请参见优惠券使用说明~"];
}

- (void)createType2
{
    UIView *mainView = [[UIView alloc]init];
    
    [mainView.layer setCornerRadius:6.0];
    [mainView.layer setMasksToBounds:YES];
    
    [mainView.layer setBorderWidth:0.1];
     mainView.frame = CGRectMake(HCSCREEN_WIDTH+100, 0.27*HCSCREEN_HEIGHT-100, HCSCREEN_WIDTH*0.75, HCSCREEN_HEIGHT*0.5);
    [UIView animateWithDuration:1 animations:^{
        mainView.frame = CGRectMake(HCSCREEN_WIDTH/8, 0.27*HCSCREEN_HEIGHT, HCSCREEN_WIDTH*0.75, HCSCREEN_HEIGHT*0.5);}];
    if (HCSCREEN_HEIGHT==480) {
        [mainView setHeight:HCSCREEN_HEIGHT*0.5];
    }else{
        [mainView setHeight:HCSCREEN_HEIGHT*0.45];
    }
    mainView.backgroundColor = [UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1.00f];;
    [self addSubview:mainView];
    UILabel *titleLabel = [UILabel labelWithFrame:CGRectMake(mainView.width/8, 15, mainView.width*0.75, 30) text:@"优惠劵使用说明" textColor:[UIColor blackColor] font:[UIFont boldSystemFontOfSize:18] tag:0 hasShadow:NO isCenter:YES];
    [mainView addSubview:titleLabel];
    NSString *str1 = @"1.优惠券一次只可以使用一张,不可叠加使用或者与其他优惠劵一起使用";
    NSString *str2 = @"2.过期或不符合活动要求的优惠券不可使用";
 
    UILabel *lable1 = [UILabel labelWithFrame:CGRectMake(mainView.width/16, titleLabel.top +titleLabel.height, mainView.width*7/8, 80) text:@"  1.优惠券一次只可以使用一张,不可叠加使用或者与其他优惠劵一起使用" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] tag:0 hasShadow:NO isCenter:NO];
    lable1.numberOfLines = 0;
    lable1.attributedText = [self changeColor:str1];
  
    UILabel *lable2 = [UILabel labelWithFrame:CGRectMake(mainView.width/16, lable1.top + lable1.height, mainView.width*7/8, 60) text:@"2.过期或不符合活动要求的优惠券不可使用" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] tag:0 hasShadow:NO isCenter:NO];
    lable2.numberOfLines = 0;
   
    lable2.attributedText = [self changeColor:str2];
    UIButton *button = [UIButton buttonWithFrame:CGRectMake((mainView.width-mainView.width*19/48)/2, mainView.height-mainView.height*6/51-20,mainView.width*19/48, mainView.height*6/51) title:@"我知道啦" titleColor:[UIColor whiteColor] titleHighlightColor:0 titleFont:[UIFont systemFontOfSize:18] image:nil tappedImage:nil target:self action:@selector(removeFromSuper) tag:1];
    button.backgroundColor =  PRICE_STY_CORLOR;
    [button.layer setCornerRadius:4.0];
    [button.layer setMasksToBounds:YES];
    [mainView setHeight:button.bottom+15];
    [mainView addSubview:lable2];
    [mainView addSubview:lable1];
    [mainView addSubview:button];
    
    
}
- (void)removeFromSuper
{
    [self removeFromSuperview];
}

- (NSMutableAttributedString*)changeColor:(NSString*)string
{
    if (string==nil) {
        string=@"";
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    [str addAttribute:NSForegroundColorAttributeName value:PRICE_STY_CORLOR range:NSMakeRange(0,2)];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(2, string.length- 2)];
    return str;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {q
    // Drawing code
}
*/


@end
