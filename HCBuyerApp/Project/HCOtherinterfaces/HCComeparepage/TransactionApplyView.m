//
//  TransactionApplyView.m
//  HCBuyerApp
//
//  Created by wj on 15/7/17.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "TransactionApplyView.h"
#import "MBProgressHUD.h"
#import "BizTransactionApply.h"
#import "NSDate+ITTAdditions.h"
#import "BizCity.h"
@interface TransactionApplyView()<UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *superView;
@property (nonatomic) NSInteger vehicleSourceId;
@property (strong, nonatomic) NSString *vehicleName;
@property (strong, nonatomic) UIView *submitView;
@property (strong, nonatomic) UITextField *phoneTextField;
@property (strong, nonatomic) UIImageView *phoneImageView;

@property (strong, nonatomic) VehicleDetail *vehicleDetail;

@property (strong, nonatomic) MBProgressHUD *hud;
@end

@implementation TransactionApplyView

-(id)initWithFrame:(CGRect)frame forVehicleDetail:(VehicleDetail *)detail inSuperView:(UIView *)superView
{
    self = [super initWithFrame:frame];
    if (self) {
        self.superView = superView;
        self.vehicleDetail = detail;
        self.vehicleSourceId = detail.vehicleSourceId;
        self.vehicleName = detail.vehicleName;
        
        [self initSubmitView];
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
        [self addSubview:self.submitView];
    }
    return self;
}

-(void)initSubmitView
{
    self.submitView = [[UIView alloc] initWithFrame:CGRectMake(20, 70, HCSCREEN_WIDTH - 20 * 2, 100)];
    [self.submitView.layer setCornerRadius:2.0f];
    UILabel *title = [UILabel labelWithFrame:CGRectMake(20, 0, self.submitView.width - 2 * 20, 60) text:@"预约看车" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:18] tag:0 hasShadow:NO isCenter:YES];
    
    UILabel *name = [UILabel labelWithFrame:CGRectMake(0, title.top+ title.height, self.submitView.width, title.height) text:self.vehicleName textColor:nil font:[UIFont fontWithName:@"Helvetica-Bold" size:15] tag:0 hasShadow:NO isCenter:YES];
    [name setBackgroundColor:ColorWithRGB(238, 238, 238)];
    
    UIView *phoneView = [[UIView alloc] initWithFrame:CGRectMake(0, name.top + name.height, name.width, name.height)];
    
    CGFloat heightPadding = 20;
    self.phoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, heightPadding, (phoneView.height - 2 * heightPadding) * 0.7, phoneView.height - 2 * heightPadding)];
    
    self.phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.phoneImageView.left + self.phoneImageView.width + 1, 2, phoneView.width - 2 * 30 - self.phoneImageView.width - 1 * 2, phoneView.height - 4)];
    
    [self.phoneTextField setTextAlignment:NSTextAlignmentCenter];
    self.phoneTextField.delegate = self;
    self.phoneTextField.returnKeyType = UIReturnKeyDefault;
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.phoneTextField setPlaceholder:@"输入您的手机号"];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(30, phoneView.height - 1, phoneView.width - 2 * 30, 1)];
    [line setBackgroundColor:ColorWithRGB(97, 97, 97)];
    [self.phoneImageView setImage:[UIImage imageNamed:@"phone_icon"]];
    UILabel *contanctInfo = [UILabel labelWithFrame:CGRectMake(0, phoneView.top + phoneView.height, phoneView.width, 50) text:@"您的购车顾问将马上与您联系" textColor:ColorWithRGB(226, 226, 226) font:[UIFont systemFontOfSize:12] tag:0 hasShadow:NO isCenter:YES];
   
    UIButton *submitBtn = [UIButton buttonWithFrame:CGRectMake(0, contanctInfo.top + contanctInfo.height, contanctInfo.width, contanctInfo.height) title:@"确定" titleColor:ColorWithRGB(255, 255, 255) bgColor:PRICE_STY_CORLOR titleFont:[UIFont fontWithName:@"Helvetica-Bold" size:18] image:nil selectImage:nil target:self action:@selector(applySubmit:) tag:0];

    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(self.submitView.width - 5 - 35, 10, 35, 35);
    [closeBtn setImage:[UIImage imageNamed:@"cancel_icon"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(dismissView:) forControlEvents:UIControlEventTouchUpInside];
    
    [phoneView addSubview:self.phoneImageView];
    [phoneView addSubview:self.phoneTextField];
    [phoneView addSubview:line];
    
    [self.submitView addSubview:title];
    [self.submitView addSubview:name];
    [self.submitView addSubview:phoneView];
    [self.submitView addSubview:contanctInfo];
    [self.submitView addSubview:submitBtn];
    [self.submitView addSubview:closeBtn];
    
    CGRect submitViewRect = self.submitView.frame;
    submitViewRect.size.height = title.height + name.height + phoneView.height + contanctInfo.height + submitBtn.height;
    
    self.submitView.frame = submitViewRect;
    
    [self.submitView setBackgroundColor:[UIColor whiteColor]];
    
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
    [self addGestureRecognizer:bgTap];
}

- (CGFloat)getYOffsetByKeyboardHeight:(CGFloat)height
{
    CGFloat submitViewHeight = self.submitView.top+ self.submitView.height;
    if (submitViewHeight + height <= self.height) {
        return 0;
    } else {
        return submitViewHeight + height - self.height;
    }
}

- (void)dismissView:(id)sender
{
    if (self.superview == self.superView) {
        [self removeFromSuperview];
    }
}

- (void)applySubmit:(id)sender
{
    //获取提交的电话
    NSString *phone = self.phoneTextField.text;
    NSString *regex = @"1[3-9][0-9]\\d{8}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES  %@", regex];
    BOOL isvalid = [predicate evaluateWithObject:phone];
    NSLog(@"phone %@ valid", isvalid ? @"is" : @"is not");
    if (!isvalid) {
        [self shakeView:self.phoneImageView];
        return;
    }
    NSLog(@"apply submit");
    self.hud = [[MBProgressHUD alloc] initWithView:self];
    [self addSubview:self.hud];
    NSString *vehicleid = [NSString stringWithFormat:@"%ld",(long)self.vehicleDetail.vehicleSourceId];
    [HCAnalysis HCclick:@"AppointmentSuccess" WithProperties:@{@"VehicleId"      :vehicleid,
                                                               @"city"           :[BizCity getCurCity].cityName,
                                                               @"VehicleBrand"   :self.vehicleDetail.brandName,
                                                               @"VehiclePrice"   :[NSString stringWithFormat:@"%.2f万",self.vehicleDetail.sellerPrice],
                                                               @"VehicleAge"     :[NSDate yearsago:[[self timestampeToString:self.vehicleDetail.registerTime]integerValue]],
                                                               @"VehicleMiles"   :[NSString stringWithFormat:@"%.2f万公里",self.vehicleDetail.miles],
                                                               @"VehicleGearBox" :self.vehicleDetail.geerbox,
                                                               @"PhoneNumber"    :self.phoneTextField.text,
                                                               //@"VehicleChannel" :self.VehicleChannel,
                                                               @"From"           :@"对比详情页"      }];
    [self.hud showWhileExecuting:@selector(applyTransaction) onTarget:self withObject:nil animated:YES];
}
- (NSString *)timestampeToString:(NSInteger)ts
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:ts];
    return [formatter stringFromDate:date];
}

- (void)applyTransaction
{
    [BizTransactionApply applyForUserPhone:self.phoneTextField.text andCityId:self.vehicleDetail.cityId andVehicleSourceId:self.vehicleDetail.vehicleSourceId finish:^(BOOL ret,NSString*errmsg) {
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
        [self addSubview:hud];
        if (ret) {
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]];
        } else {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"提交失败！请检查网络";
            hud.labelFont = [UIFont systemFontOfSize:14.0f];
        }
        [hud show:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud hide:YES];
            if (self.superview == self.superView) {
                [self removeFromSuperview];
            }
        });

    }];
}


-(void)bgTappedAction:(UITapGestureRecognizer *)tap
{
    [self.phoneTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.phoneTextField resignFirstResponder];
    return YES;
}

- (void)show
{
    if (self.superview != self.superView) {
        [self.superView addSubview:self];
    }
}


-(void)shakeView:(UIView*)viewToShake
{
    CGFloat t =2.0;
    CGAffineTransform translateRight  =CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    
    viewToShake.transform = translateLeft;
    
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        viewToShake.transform = translateRight;
    } completion:^(BOOL finished){
        if(finished){
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform =CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
