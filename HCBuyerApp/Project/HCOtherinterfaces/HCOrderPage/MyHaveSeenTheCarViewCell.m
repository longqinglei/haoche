//
//  MyHaveSeenTheCarViewCell.m
//  HCBuyerApp
//
//  Created by haoche51 on 15/8/31.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "MyHaveSeenTheCarViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "UIAlertView+ITTAdditions.h"

@implementation MyHaveSeenTheCarViewCell

- (void)awakeFromNib {
    self.textLabelie.textAlignment = NSTextAlignmentRight;
    [self.servicePhone setAttributedTitle:[NSString addBottomLine:self.servicePhone.titleLabel.text] forState:UIControlStateNormal];
    [self.useCoupon.layer setCornerRadius:5.0];
    [self.useCoupon.layer setMasksToBounds:YES];
    [self.useCoupon.layer setBorderWidth:0.5];
    self.useCoupon.layer.borderColor =[PRICE_STY_CORLOR CGColor];
    self.vehicleImage.image = [UIImage imageNamed:@"ceshivehicle.jpg"];
    self.characterLabel.delegate = self;
    self.characterLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.characterLabel.numberOfLines = 0;
    self.telephoneNum.titleLabel.textColor =PRICE_STY_CORLOR;
    [super awakeFromNib];
}

- (NSString*)changeTimeTodate:(NSInteger)time{
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_teleNum]]];
    }
    
}

- (BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel shouldFollowLink:(NSTextCheckingResult *)linkInfo{
    
    if ([[UIApplication sharedApplication]canOpenURL:linkInfo.URL]) {
        [[UIApplication sharedApplication]openURL:linkInfo.URL];
    }else{
        
        [UIAlertView popupAlertByDelegate:self title:_teleNum message:@"" cancel:@"取消" others:@"确定"];
    }
    
    return NO;
}

- (NSString*)changeReTimeTodate:(NSInteger)time{
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY.MM"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

- (void)initCellWithRet :(MyHaveSeenVehicle *)coupon{
    
    _characterLabel.lineBreakMode = NSLineBreakByCharWrapping;
    _characterLabel.numberOfLines = 0;
    _mID = coupon.mId;
    if (coupon.mPlace) {
         self.addressStr.text = coupon.mPlace;
    }
    if (coupon.mCoupon_amount&&coupon.mCoupon_type) {
//        NSString *typestr;
//        if([coupon.mCoupon_type isEqualToString:@"1"]){
//            typestr = @"折现券";
//        }else if ([coupon.mCoupon_type isEqualToString:@"2"]){
//            typestr = @"打折券";
//        }else if ([coupon.mCoupon_type isEqualToString:@"3"]){
//            typestr = @"减免服务费";
//        }
        self.textLabelie.text = [NSString stringWithFormat:@"已使用%@元优惠劵",coupon.mCoupon_amount];
    }

    [self.commissionerView setTop:self.adressView.bottom];
    [self.commissionerView setTop:self.adressView.bottom];
    [self.infoView setTop:self.commissionerView.bottom];
    [self.bottomView setTop:self.infoView.bottom];
     [self.vehicleImage setImageWithURL:[NSURL URLWithString:coupon.mImage]placeholderImage:[UIImage imageNamed:@"default_vehicle"]];
    self.vehicleName.text = coupon.mVehicle_name;
    self.addressStr.text = coupon.mPlace;
    self.characterLabel.text = coupon.mComment;
    if ([coupon.mPhone length] != 0) {
        [self.telephoneNum setAttributedTitle:[NSString addBottomLine:coupon.mPhone] forState:UIControlStateNormal];
    }else{
        [self.telephoneNum setTitle:@"暂无..." forState:UIControlStateNormal];
    }
    if ([coupon.mName length] != 0) {
        self.commissioner.text = [NSString stringWithFormat:@"%@:%@",coupon.mDesc,coupon.mName];
    }else{
        self.commissioner.text = @"正在分配工作人员";
    }
   
    if (coupon.mPrice.length != 0) {
        NSString *priceText = [NSString stringWithFormat:@"￥%.2f万",[coupon.mPrice floatValue]];
        
        NSInteger priceLength = [priceText length] - 1;
        NSMutableAttributedString *str;
        if (priceText) {
            str = [[NSMutableAttributedString alloc] initWithString:priceText];
        }
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 1)];
        if ([UIFont respondsToSelector:@selector(systemFontOfSize:weight:)]) {
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20 weight:1.0f] range:NSMakeRange(1, priceLength - 1)];
        } else {
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:20] range:NSMakeRange(1, priceLength - 1)];
        }

        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(priceLength, 1)];
        [str addAttribute:NSForegroundColorAttributeName value:PRICE_STY_CORLOR range:NSMakeRange(0, 1)];
        [str addAttribute:NSForegroundColorAttributeName value:PRICE_STY_CORLOR range:NSMakeRange(1, priceLength - 1)];
        [str addAttribute:NSForegroundColorAttributeName value:PRICE_STY_CORLOR range:NSMakeRange(priceLength, 1)];
        self.vehiclePrice.attributedText = str;

    }
        NSString *str1;
        NSString *str2;
        NSString *urlStr;
        NSString *telephone;
        self.vehicleName.text = coupon.mVehicle_name;
        self.timeStr.text = [NSString stringWithFormat:@"%@ %@",[NSString changeTimeTodate:[coupon.mTime integerValue] formatter:@"YYYY-MM-dd HH:mm:ss"],coupon.mType];
        [self.vehiclePrice sizeToFit];
        self.characterLabel.text = coupon.mComment;
    
        self.characterLabel.underlineLinks = YES;
        if ([coupon.mComment rangeOfString:@"http"].location != NSNotFound) {
        NSArray *array = [coupon.mComment componentsSeparatedByString:@"http"];
        NSString *strUrl;
        strUrl = [array HCObjectAtIndex:1];
        str1 = [array HCObjectAtIndex:0];
        urlStr = [NSString stringWithFormat:@"http%@",strUrl];
            
       self.characterLabel.text = [NSString stringWithFormat:@"%@%@",str1,urlStr];
        }else if([coupon.mComment rangeOfString:@"400"].location != NSNotFound){
            NSInteger index;
            NSInteger length;
            NSArray *array = [coupon.mComment componentsSeparatedByString:@"400"];
            NSString *strUrl;
            strUrl = [array HCObjectAtIndex:1];
            str2 = [array HCObjectAtIndex:0];
            telephone = [NSString stringWithFormat:@"400%@",strUrl];
            _teleNum  = [telephone substringToIndex:[telephone length] - 1];
         
            index = str2.length;
            length = telephone.length-1;
            NSRange range = NSMakeRange(index, length);
            self.characterLabel.text = coupon.mComment;
            [self.characterLabel addCustomLink:[NSURL URLWithString:telephone] inRange:range];
        }else{
            self.characterLabel.text = coupon.mComment;
        }
    [self.characterLabel setHeight:[self returnFloat:coupon.mComment]];
    [self.infoView setHeight:_characterLabel.height+10];

    

    NSString *timeOn = [NSString changeTimeTodate:[coupon.mRegister_time integerValue] formatter:@"YYYY.MM"];
    NSString *miles = [NSString stringWithFormat:@"%@",coupon.mMile];
        self.vehicleInfo.text = [NSString stringWithFormat:@"%@上牌 · %@万公里 · %@",timeOn,miles,coupon.mGeerbox];
    
    if (coupon.mStatus == kMyOrderStatusOne) {
        [self getSring:@"已预约" WithColor:PRICE_STY_CORLOR label:self.statusStr];
    }else if(coupon.mStatus==kMyOrderStatusTwo){
        [self getSring:@"已看车,未预定" WithColor:[UIColor colorWithRed:0.53f green:0.53f blue:0.53f alpha:1.00f] label:self.statusStr];
    }
    else if(coupon.mStatus == kMyOrderStatusThree){
        self.useCoupon.hidden = YES;
        self.commissionerView.hidden = YES;
        self.adressView.hidden = YES;
        [self.infoView setTop:self.timeView.bottom];
        [self getSring:@"已看车,未预定" WithColor:[UIColor colorWithRed:0.53f green:0.53f blue:0.53f alpha:1.00f] label:self.statusStr];
        self.soldState.hidden = NO;
        [self.soldState.layer setCornerRadius:29.5];
        [self.soldState.layer setMasksToBounds:YES];
        [self.soldState.layer setBorderWidth:0.1];
        
    }else if(coupon.mStatus == kMyOrderStatusFour){
        [self getSring:@"已预定" WithColor:PAGE_STYLE_COLOR label:self.statusStr];
    }else if(coupon.mStatus == kMyOrderStatusFive){
        self.statusStr.hidden = YES;
        self.statusImage.hidden = NO;
        self.adressView.hidden = YES;
        [self.commissionerView setTop:self.timeView.bottom];
        [self.infoView setTop:self.commissionerView.bottom];
        self.useCoupon.hidden = YES;
        self.textLabelie.hidden = NO;
    }else if(coupon.mStatus == kMyOrderStatusSix){
        self.adressView.hidden = YES;
        [self.commissionerView setTop:self.timeView.bottom];
        [self.infoView setTop:self.commissionerView.bottom];
        self.statusStr.hidden = YES;
        self.statusImage.hidden = NO;
    }else if(coupon.mStatus == kMyOrderStatusSeven){
        self.adressView.hidden = YES;
        self.commissionerView.hidden =YES;
        [self.infoView setTop:self.timeView.bottom];
        self.statusStr.hidden = YES;
        self.statusImage.hidden = NO;
        self.useCoupon.hidden = YES;
        self.textLabelie.hidden = NO;
    }else if(coupon.mStatus == kMyOrderStatusEight){//
        self.adressView.hidden = YES;
        self.commissionerView.hidden =YES;
        [self.infoView setTop:self.timeView.bottom];
        self.statusStr.hidden = YES;
        self.statusImage.hidden = NO;
    }else if(coupon.mStatus == kMyOrderStatusNine){
        self.commissionerView.hidden = YES;
        self.adressView.hidden =YES;
        self.statusStr.hidden = YES;
        self.statusImage.hidden = NO;
        [self.infoView setTop:self.timeView.bottom];
    }
    [self.bottomView setTop:self.infoView.bottom];
}

- (BOOL)isPureInt:(NSString *)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
    
}

- (void)getSring:(NSString*)text WithColor:(UIColor*)color label:(UILabel*)label{
    label.text = text;
    [label sizeToFit];
    label.textColor = color;
}
- (CGFloat)returnFloat:(NSString *)str{
    CGSize size= CGSizeMake(HCSCREEN_WIDTH - 20, 10000);
    CGRect tmpRect = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] context:nil];
 // CGSize  size1 = [str sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    
    return tmpRect.size.height;
}

- (CGFloat)returnaddress:(NSString*)str{
    CGSize size= CGSizeMake(HCSCREEN_WIDTH - 50, 10000);
    CGRect tmpRect = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] context:nil];
 //   CGSize  size1 = [str sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    
    return tmpRect.size.height+28;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
