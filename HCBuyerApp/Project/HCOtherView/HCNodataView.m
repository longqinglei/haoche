//
//  HCNodataView.m
//  HCBuyerApp
//
//  Created by 张熙 on 15/9/6.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "HCNodataView.h"

@implementation HCNodataView

+ (UIView *)createNoVehicleView:(UIView*)nodData target:(id)target action1:(SEL)select1 action2:(SEL)select2 fram:(CGRect)rect text:(NSString *)text andText:(NSString *)strText ishow:(BOOL)ishow{
    
    if (!nodData) {
        if (rect.size.height) {
            nodData = [[UIView alloc]initWithFrame:rect];
        }else{
            nodData = [[UIView alloc] initWithFrame:CGRectMake(0, HC_VEHICLE_LIST_ROW_HEIGHT,HCSCREEN_WIDTH,HCSCREEN_HEIGHT - HC_VEHICLE_LIST_ROW_HEIGHT)];
        }
        nodData.backgroundColor = [UIColor clearColor];
        CGFloat imgWidth = 48;
        CGFloat imgHeith = 40;
        CGFloat imgXpos = (HCSCREEN_WIDTH- imgWidth) / 2;
        CGFloat imgYpos = 20;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imgXpos, imgYpos, imgWidth, imgHeith)];
        [imageView setImage:[UIImage imageNamed:@"error_data"]];
        [nodData addSubview:imageView];
        
        
        UILabel *label = [UILabel labelWithFrame:CGRectMake(0, imageView.top + imageView.height + 20,HCSCREEN_WIDTH, 15) text:@"抱歉！暂时没有找到您想要的车" textColor:ColorWithRGB(179, 179, 179) font:[UIFont systemFontOfSize:14] tag:0 hasShadow:NO isCenter:YES];
        if (ishow == YES) {
            label.height = YES;
        }else{
            label.hidden = NO;
        }
        UILabel *labeltext = [UILabel labelWithFrame:CGRectMake(0, imageView.top + imageView.height +20+25, HCSCREEN_WIDTH, 15) text:text textColor:ColorWithRGB(179, 179, 179) font:[UIFont systemFontOfSize:14] tag:0 hasShadow:NO isCenter:YES];
        UIButton *resetButton = [UIButton buttonWithFrame:CGRectMake(HCSCREEN_WIDTH / 4, label.top + label.height + 50, HCSCREEN_WIDTH / 2 , 40) title:strText titleColor:[UIColor whiteColor] bgColor:PRICE_STY_CORLOR titleFont:[UIFont systemFontOfSize:14] image:nil selectImage:nil target:target action:select1 tag:0];
        CALayer * buttonLayer = [resetButton layer];
        [buttonLayer setMasksToBounds:YES];
        [buttonLayer setCornerRadius:3.0];
        [buttonLayer setBorderWidth:1.0];
        [buttonLayer setBorderColor:[resetButton.backgroundColor CGColor]];
        
        UIButton *bangmaiButton = [UIButton buttonWithFrame:CGRectMake(HCSCREEN_WIDTH / 4, resetButton.top + resetButton.frame.size.height + 25, HCSCREEN_WIDTH / 2 , 40) title:@"试试帮买服务" titleColor:[UIColor whiteColor] bgColor:ColorWithRGB(255, 112, 51) titleFont:[UIFont systemFontOfSize:14] image:nil selectImage:nil target:target action:select2 tag:0];
        buttonLayer = [bangmaiButton layer];
        [buttonLayer setMasksToBounds:YES];
        [buttonLayer setCornerRadius:3.0];
        [buttonLayer setBorderWidth:1.0];
        [buttonLayer setBorderColor:[bangmaiButton.backgroundColor CGColor]];
        UILabel *bangmailabel = [UILabel labelWithFrame:CGRectMake(0, bangmaiButton.top + bangmaiButton.height + 10, HCSCREEN_WIDTH, 15) text:@"您提需求我们帮你找车" textColor:ColorWithRGB(166, 166, 166) font:[UIFont systemFontOfSize:13] tag:0 hasShadow:NO isCenter:YES];
        nodData.userInteractionEnabled = YES;
        [nodData addSubview:label];
        [nodData addSubview:labeltext];
        [nodData addSubview:resetButton];
        [nodData addSubview:bangmaiButton];
        [nodData addSubview:bangmailabel];
    }
    return nodData;
}

+ (UIView *)createEmptySubVehicelview:(UIView*)emptyView fram:(CGRect)rect{
    if (!emptyView) {
        emptyView = [[UIView alloc] initWithFrame:rect];
        emptyView.backgroundColor = [UIColor cyanColor];
        CGFloat imgWidth =48;
        CGFloat imgHeith = 40;
        CGFloat imhY ;
        if (HCSCREEN_HEIGHT==480) {
            imhY = HCSCREEN_WIDTH*0.58-44;
        }else{
            imhY = HCSCREEN_WIDTH*0.58;
        }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((HCSCREEN_WIDTH-48)/2, imhY, imgWidth, imgHeith)];
        [imageView setImage:[UIImage imageNamed:@"error_data"]];
        [emptyView addSubview:imageView];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom + 10, HCSCREEN_WIDTH, 15)];
        label.text  = @"还没有符合您要求的车";
        label.textColor = UIColorFromRGBValue(0x9f9f9f);
        label.font = [UIFont systemFontOfSize:12];
        [label setTextAlignment:NSTextAlignmentCenter];
        [emptyView addSubview:imageView];
        [emptyView addSubview:label];


    }

    return emptyView;
}

+ (UIView *)getNetwordErrorViewWith:(NSString *)text view:(UIView*)networkErrorView
{
    if (!networkErrorView) {
        networkErrorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, HCSCREEN_HEIGHT)];
        networkErrorView.backgroundColor = [UIColor whiteColor];
        CGFloat imgWidth = HCSCREEN_WIDTH/3.6;
        CGFloat imgHeith = imgWidth*0.7;
        CGFloat imgYpos;
        if (HCSCREEN_HEIGHT==480) {
            imgYpos=  HC_VEHICLE_LIST_ROW_HEIGHT * 1.5;
        }else{
            imgYpos=  HC_VEHICLE_LIST_ROW_HEIGHT * 1.5 + 60;
        }
        CGFloat imgXpos = (HCSCREEN_WIDTH - imgWidth) / 2;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imgXpos, imgYpos, imgWidth, imgHeith)];
        [imageView setImage:[UIImage imageNamed:@"networkAnomaly"]];
        [networkErrorView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.top + imageView.height + 20, HCSCREEN_WIDTH, 15)];
        [label setText:text];
         label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16];
        [label setTextAlignment:NSTextAlignmentCenter];
        [networkErrorView addSubview:imageView];
        [networkErrorView addSubview:label];
        
        UILabel *labeltext = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.top + imageView.height + 45, HCSCREEN_WIDTH, 15)];
        labeltext.font = [UIFont systemFontOfSize:16];
        labeltext.text = @"点击刷新";
        labeltext.textColor = ColorWithRGB(179, 179, 179);
        [labeltext setTextAlignment:NSTextAlignmentCenter];
        [networkErrorView addSubview:labeltext];
    }
    return networkErrorView;
}

+ (UIView *)getNetword:(NSString *)text view:(UIView*)networkErrorView
{
    if (!networkErrorView) {
        networkErrorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, HCSCREEN_HEIGHT)];
        networkErrorView.backgroundColor = [UIColor whiteColor];
        CGFloat imgWidth = HCSCREEN_WIDTH/5.3;
        CGFloat imgHeith = imgWidth*0.7;
        CGFloat imgYpos;
        if (HCSCREEN_HEIGHT==480) {
            imgYpos=  HC_VEHICLE_LIST_ROW_HEIGHT * 1.5;
        }else{
            imgYpos=  HC_VEHICLE_LIST_ROW_HEIGHT * 1.5 + 60;
        }
        CGFloat imgXpos = (HCSCREEN_WIDTH - imgWidth) / 2;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imgXpos, imgYpos, imgWidth, imgHeith)];
        [imageView setImage:[UIImage imageNamed:@"error_data"]];
        [networkErrorView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.top + imageView.height + 20, HCSCREEN_WIDTH, 15)];
        [label setText:text];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16];
        [label setTextAlignment:NSTextAlignmentCenter];
        [networkErrorView addSubview:imageView];
        [networkErrorView addSubview:label];
        
        UILabel *labeltext = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.top + imageView.height + 45, HCSCREEN_WIDTH, 15)];
        labeltext.font = [UIFont systemFontOfSize:16];
        labeltext.text = @"点击刷新";
        labeltext.textColor = ColorWithRGB(179, 179, 179);
        [labeltext setTextAlignment:NSTextAlignmentCenter];
        [networkErrorView addSubview:labeltext];
    
    }
    return networkErrorView;
}



+(UIView *)getWebNetWorkErrorView:(UIView *)webNetError{
    if (!webNetError) {
        
        webNetError = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, HCSCREEN_HEIGHT)];
        CGFloat imgWidth = HCSCREEN_WIDTH/3.6;
        CGFloat imgHeith = imgWidth*0.7;
        CGFloat imgXpos = (HCSCREEN_WIDTH - imgWidth) / 2;
        CGFloat imgYpos =  HCSCREEN_HEIGHT / 2 - imgHeith / 2;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imgXpos, imgYpos, imgWidth, imgHeith)];
        [imageView setImage:[UIImage imageNamed:@"networkAnomaly"]];
        [webNetError addSubview:imageView];
     
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.top + imageView.height + 20, HCSCREEN_WIDTH, 15)];
        [label setText:@"您的网络不太给力哦~"];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:16];
        [label setTextAlignment:NSTextAlignmentCenter];
        
        UILabel *labeltext = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.top + imageView.height + 47, HCSCREEN_WIDTH, 15)];
        labeltext.font = [UIFont systemFontOfSize:15];
        labeltext.text = @"点击刷新";
        labeltext.textColor = ColorWithRGB(179, 179, 179);
        [labeltext setTextAlignment:NSTextAlignmentCenter];
        [webNetError addSubview:labeltext];
        
        [webNetError addSubview:imageView];
        [webNetError addSubview:label];
    }
    return webNetError;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
