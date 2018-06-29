//
//  LoginViewController.m
//  HCBuyerApp
//
//  Created by wj on 15/7/29.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "LoginViewController.h"
#import "UIImage+RTTint.h"
#import "MBProgressHUD.h"
#import "BizCity.h"
#import "User.h"
#import "BizVerifyCode.h"
#import "BizLogin.h"
#import "NavView.h"
#import "UITextField+ITTAdditions.h"
#import "BizCoupon.h"
#import "UIView+ITTAdditions.h"
#import "UIAlertView+ITTAdditions.h"
#define Login_TextField_Height 45
#define Loginview_Width_Padding 10
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "SensorsAnalyticsSDK.h"
static LoginViewController *_myViewcontroller = nil;

@interface LoginViewController ()

@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UITextField *phoneTextField;
@property (strong, nonatomic) UIImageView *phoneIcon;
@property (strong, nonatomic) UIImageView *passwdIcon;
@property (strong, nonatomic) UIImageView *pitureImgaeView;
@property (strong, nonatomic) UIButton *verifyCodeSendBtn;
@property (strong, nonatomic) UIButton *clearbutton;
@property (strong, nonatomic) UIButton *loginBtn;
@property (strong, nonatomic) UIButton *mButtonVoice;
@property (strong, nonatomic) UIButton *mButtonVoiceLeft;
@property (strong, nonatomic) NavView *navView;
@property (strong, nonatomic) NSTimer *validCodeTimer;
@property (nonatomic) NSInteger secondCountdownNumber;



@end


@implementation LoginViewController


#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
     _navView = [[NavView alloc]initWithFrame:CGRectMake(0, -64, HCSCREEN_WIDTH, 64)];
     _navView.labelText.text = @"登 录";
    
    [self.view addSubview:self.navView];
    [self creatBackButton];
     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    NSString *isShow;
    if (_type == 1) {
        isShow = @"登录后，才可以使用收藏功能";
    }else if(_type==2){
        isShow = @"登录后，才可以使用上新提醒功能";
    }else{
        isShow = @"免注册，输入手机号即可登录";
    }
    UILabel *titleLabel = [UILabel labelWithFrame:CGRectMake(Loginview_Width_Padding * 2, 0, HCSCREEN_WIDTH - Loginview_Width_Padding * 4, Login_TextField_Height) text:isShow textColor:ColorWithRGB(146, 146, 146) font:[UIFont systemFontOfSize:12] tag:0 hasShadow:NO isCenter:NO];
    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.top + titleLabel.height, HCSCREEN_WIDTH, Login_TextField_Height * 2)];
    [inputView setBackgroundColor:[UIColor whiteColor]];
    UIView *splitLine = [[UIView alloc] initWithFrame:CGRectMake(Loginview_Width_Padding, Login_TextField_Height - 0.5, HCSCREEN_WIDTH - 2 * Loginview_Width_Padding, 0.5)];
    [splitLine setBackgroundColor:[UIColor colorWithRed:0.87f green:0.88f blue:0.88f alpha:1.00f]];
    [inputView addSubview:splitLine];
    
    CGFloat iconWidth = 13;
    CGFloat iconHieght = 18;
    self.phoneIcon = [[UIImageView alloc] initWithFrame:CGRectMake(Loginview_Width_Padding + 5, (Login_TextField_Height - iconHieght) / 2,  iconWidth, iconHieght)];
    [self.phoneIcon setImage:[UIImage imageNamed:@"phone_icon"]];
    self.passwdIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.phoneIcon.left, self.phoneIcon.top + Login_TextField_Height, iconWidth, iconHieght)];
    [self.passwdIcon setImage:[UIImage imageNamed:@"passwd_icon"]];
    [inputView addSubview:self.phoneIcon];
    [inputView addSubview:self.passwdIcon];
    
    self.phoneTextField = [UITextField textFieldWithFrame:CGRectMake(self.phoneIcon.left + self.phoneIcon.width + 10, 2, inputView.width - self.phoneIcon.left - self.phoneIcon.width - 125, Login_TextField_Height - 4) borderStyle:0 textColor:nil backgroundColor:nil font:[UIFont systemFontOfSize:13.f] keyboardType:UIKeyboardTypeNumberPad tag:0 nsstring:@"手机号"];
    [self.phoneTextField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    self.phoneTextField.clearButtonMode = UITextFieldViewModeNever;
    self.passwordTextField = [UITextField textFieldWithFrame:CGRectMake(self.phoneTextField.left, self.phoneTextField.top + Login_TextField_Height, inputView.width - self.phoneIcon.left - self.phoneIcon.width - 10, self.phoneTextField.height) borderStyle:0 textColor:nil backgroundColor:nil font:[UIFont systemFontOfSize:13.0f] keyboardType:UIKeyboardTypeNumberPad tag:0 nsstring:@"验证码"];
    self.passwordTextField.returnKeyType = UIReturnKeyDefault;
    self.passwordTextField.delegate = self;
    self.clearbutton = [UIButton buttonWithFrame:CGRectMake(self.phoneTextField.left + self.phoneTextField.width, (Login_TextField_Height - 15) / 2, 15, 15) title:nil titleColor:nil titleHighlightColor:nil titleFont:nil image:[UIImage imageNamed:@"textfield_clear_icon"] tappedImage:nil target:self action:@selector(clearPhoneText:) tag:0];
    [self.clearbutton setHidden:YES];
    self.verifyCodeSendBtn = [UIButton buttonWithFrame: CGRectMake(self.clearbutton.left + self.clearbutton.width + 15, (Login_TextField_Height - 25) / 2, 100 - 15 - Loginview_Width_Padding, 25) title:@"获取验证码" titleColor:PRICE_STY_CORLOR titleHighlightColor:nil titleFont:[UIFont boldSystemFontOfSize:12.0f] image:nil tappedImage:nil target:self action:@selector(requestVerifyCode:) tag:0];
    [self.verifyCodeSendBtn.layer setCornerRadius:2.0f];
    [self.verifyCodeSendBtn.layer setBorderWidth:1.0f];
    [self.verifyCodeSendBtn.layer setBorderColor:ColorWithRGB(224, 224, 224).CGColor];
    
    [inputView addSubview:self.verifyCodeSendBtn];
    [inputView addSubview:self.phoneTextField];
    [inputView addSubview:self.passwordTextField];
    [inputView addSubview:self.clearbutton];
    
    self.loginBtn = [UIButton buttonWithFrame:CGRectMake(Loginview_Width_Padding, inputView.top + inputView.height + 20, HCSCREEN_WIDTH - 2 * Loginview_Width_Padding, Login_TextField_Height) title:@"登录" titleColor:[UIColor colorWithRed:1.00f green:0.98f blue:0.98f alpha:1.00f] titleHighlightColor:nil titleFont:[UIFont boldSystemFontOfSize:19.0f] image:nil tappedImage:nil target:self action:@selector(login:) tag:0];
    [self.loginBtn setBackgroundColor:PRICE_STY_CORLOR];
    [self.loginBtn.layer setCornerRadius:3.0f];
    

    [self.view addSubview:titleLabel];
    [self.view addSubview:inputView];
    [self.view addSubview:self.loginBtn];
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
    [self.view addGestureRecognizer:bgTap];
    [self.view setBackgroundColor:ColorWithRGB(238, 238, 238)];
     self.secondCountdownNumber = 60;
    [self.phoneTextField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    self.passwordTextField.secureTextEntry = YES;
    [self showPiture];
    [self loginpiture];
    
    _mButtonVoice = [UIButton buttonWithFrame:CGRectMake(0, self.loginBtn.bottom+20, HCSCREEN_WIDTH/2, 30) title:@"收不到验证码?" titleColor:[UIColor grayColor] bgColor:nil titleFont:[UIFont boldSystemFontOfSize:13.0f] image:nil selectImage:nil target:self action:@selector(btnlick:) tag:101];
    [_mButtonVoice setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
      [self.view addSubview:_mButtonVoice];
    _mButtonVoiceLeft = [UIButton buttonWithFrame:CGRectMake(HCSCREEN_WIDTH/2, self.loginBtn.bottom+20, HCSCREEN_WIDTH/2, 30) title:@"收听语音验证码" titleColor:[UIColor redColor] bgColor:nil titleFont:[UIFont boldSystemFontOfSize:13.0f] image:nil selectImage:nil target:self action:@selector(btnlick:) tag:101];
        [_mButtonVoiceLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
     [_mButtonVoiceLeft setAttributedTitle:[NSString addBottomLine:@"收听语音验证码"] forState:UIControlStateNormal];
    [self.view addSubview:_mButtonVoiceLeft];
    _mButtonVoice.hidden = YES;
    _mButtonVoiceLeft.hidden = YES;
}

- (void)showPiture
{
    _pitureImgaeView = [[UIImageView alloc]initWithFrame:CGRectMake((HCSCREEN_WIDTH-HCSCREEN_WIDTH/1.9)/2, self.loginBtn.bottom+50, HCSCREEN_WIDTH/1.9, HCSCREEN_HEIGHT/4.5)];
    [self.view addSubview:_pitureImgaeView];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"id"] intValue] != 0){
    [_pitureImgaeView sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"loginPitureImage"]]];
    }else{
        return;
    }
}


- (void)loginpiture
{
    NSDictionary *logiPic = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginPiture"];
    if ([[logiPic objectForKey:@"id"] intValue] == 0) {
        return;
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"id"] isEqualToString:[NSString stringWithFormat:@"%d",[[logiPic objectForKey:@"id"] intValue]]]){
        
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:[logiPic objectForKey:@"id"] forKey:@"id"];
        if ([logiPic objectForKey:@"image_url"] && ![[logiPic objectForKey:@"image_url"] isEqualToString:@""] && [[logiPic objectForKey:@"id"] intValue] != 0) {
             [[NSUserDefaults standardUserDefaults]setObject:[logiPic objectForKey:@"image_url"] forKey:@"loginPitureImage"];
            [_pitureImgaeView sd_setImageWithURL:[NSURL URLWithString:[logiPic objectForKey:@"image_url"]]];
        }
    }
}
//
//- (void)DownLoadImage:(NSString *)strImageView image:(NSString *)image_url
//{
//    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:strImageView] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//        if (error) {
//        }
//        if (image) {
//            [[NSUserDefaults standardUserDefaults]setObject:[NSString UIImageToBase64Str:image] forKey:image_url];
//        }
//    }];
//}
//

- (void)btnlick:(UIButton *)btn
{
   [HCAnalysis HCUserClick:@"mVoiceBtnclick"];
    NSString *phone = self.phoneTextField.text;
    NSString *regex = @"1[3-9][0-9]\\d{8}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES  %@", regex];
    BOOL isvalid = [predicate evaluateWithObject:phone];
    if (!isvalid) {
        [self showMsg:@"请输入正确的手机号!" type:FVAlertTypeWarning];
    }
    [BizVerifyCode verificationCode:self.phoneTextField.text finish:^(BOOL show) {
        if (show) {
             [self showMsg:@"成功，请注意接听来电" type:FVAlertTypeWarning];
            _mButtonVoiceLeft.titleLabel.textColor = [UIColor grayColor];
            _mButtonVoiceLeft.userInteractionEnabled = NO;
        }else{
            [self showMsg:@"发送语音失败" type:FVAlertTypeWarning];
        }
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    [super viewWillAppear:animated];
    [HCAnalysis controllerBegin:@"LoginPage"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [HCAnalysis controllerEnd:@"LoginPage"];
    
}

-(void)bgTappedAction:(UITapGestureRecognizer *)tap
{
    [self.phoneTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (void)clearPhoneText:(id)sender
{
    self.phoneTextField.text = @"";
    [self.clearbutton setHidden:YES];
    if (self.loginBtn.enabled){
        [self.loginBtn setEnabled:NO];
        [self.loginBtn setBackgroundColor:[UIColor colorWithRed:0.85f green:0.01f blue:0.01f alpha:1.00f]];
    }
}

#define mark - UITextFieldDelegate
-(void)textFieldEditChanged:(UITextField *)textField
{
    if (textField == self.phoneTextField){
        [self.clearbutton setHidden:([textField.text length] == 0)];
    }
    if ([self.phoneTextField.text length] >0 && [self.passwordTextField.text length] > 0){
        [self.loginBtn setEnabled:YES];
        [self.loginBtn setBackgroundColor:[UIColor colorWithRed:0.85f green:0.01f blue:0.01f alpha:1.00f]];
    }else{
    if (self.loginBtn.enabled){
        [self.loginBtn setEnabled:NO];
        [self.loginBtn setBackgroundColor:[UIColor colorWithRed:0.85f green:0.01f blue:0.01f alpha:1.00f]];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)requestVerifyCode:(id)sender
{
    NSString *phone = self.phoneTextField.text;
    NSString *regex = @"1[3-9][0-9]\\d{8}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES  %@", regex];
    BOOL isvalid = [predicate evaluateWithObject:phone];
    if (!isvalid) {
        [self shakeView:self.phoneIcon];
        return;
    }
    [self.verifyCodeSendBtn setEnabled:NO];
    [BizVerifyCode sendVerifyCode:phone finish:^(BOOL ret) {
    if (ret){
            self.secondCountdownNumber = 60;
            self.validCodeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown:)userInfo:nil repeats:YES];
    }else{
            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:hud];
            hud.mode = MBProgressHUDModeText;
            hud.labelFont = [UIFont systemFontOfSize:14.0f];
            hud.labelText = self.strNetworkTitle;
            [hud show:YES];
          // _oldPhoneNum = self.phoneTextField.text;
            [self.verifyCodeSendBtn setEnabled:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud hide:YES];
            });
        }
    }];
}

-(void)countDown:(NSTimer *)timer
{
    self.secondCountdownNumber -= 1;
    if (self.secondCountdownNumber > 0) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
             [self.verifyCodeSendBtn setTitleColor:ColorWithRGB(146, 146, 146) forState:UIControlStateNormal];
            [self.verifyCodeSendBtn setTitle:[NSString stringWithFormat:@"剩余%ld秒", (long)self.secondCountdownNumber] forState:UIControlStateNormal];
        }else{
            self.verifyCodeSendBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.verifyCodeSendBtn.titleLabel.text = [NSString stringWithFormat:@"剩余%ld秒", (long)self.secondCountdownNumber];
            self.verifyCodeSendBtn.titleLabel.textColor =ColorWithRGB(146, 146, 146);
        }
        
        if (self.secondCountdownNumber == 30) {
            _mButtonVoice.hidden = NO;
            _mButtonVoiceLeft.hidden = NO;
        }
    } else {
        [self.validCodeTimer invalidate];
        self.validCodeTimer = nil;
        [self.verifyCodeSendBtn setEnabled:YES];
        [self.verifyCodeSendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.verifyCodeSendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

#pragma mark - Private
-(void)login:(id)sender
{
   
    NSString *phone = self.phoneTextField.text;
    NSString *regex = @"1[3-9][0-9]\\d{8}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES  %@", regex];
    BOOL isvalid = [predicate evaluateWithObject:phone];
    if (!isvalid) {
        [self shakeView:self.phoneIcon];
        return;
    }
    if ([self.passwordTextField.text length] == 0) {
        [self shakeView:self.passwdIcon];
        return;
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    [hud showWhileExecuting:@selector(doLogin) onTarget:self withObject:nil animated:YES];
}

- (void)doLogin
{
    [BizLogin loginWithPhone:self.phoneTextField.text andVcode:self.passwordTextField.text finish:^(BOOL ret) {
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
        if (ret) {
            if (_type) {
                if (_guidanceFinishBlock) {
                    _guidanceFinishBlock();
                }
            }
            hud.mode = MBProgressHUDModeCustomView;
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]];
        } else {
            hud.mode = MBProgressHUDModeText;
            hud.labelFont = [UIFont systemFontOfSize:14.0f];
            hud.labelText = @"验证码错误!";
        } 
        [hud show:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud hide:YES];
            if (ret) {
                [User addUserPhone:self.phoneTextField.text];
                [[NSUserDefaults standardUserDefaults] setObject:self.phoneTextField.text forKey:@"hc_user_phone"];
                [self.navigationController popViewControllerAnimated:NO];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"loginSuccess" object:nil userInfo:nil];
                //[[[SensorsAnalyticsSDK sharedInstance] people] set:@"MobliePhone" to:self.phoneTextField.text];
                [[SensorsAnalyticsSDK sharedInstance] registerSuperProperties:@{@"IsLogin" :@"true"}];
                //[[[SensorsAnalyticsSDK sharedInstance] people] setOnce:@"FirstLoginCity" to:[BizCity getCurCity].cityName];
                
                [HCAnalysis HCclick:@"Login" WithProperties:@{}];
            }
        });
    }];
}

-(void)shakeView:(UIView*)viewToShake
{
    CGFloat t = 2.0;
    CGAffineTransform translateRight  =CGAffineTransformTranslate(CGAffineTransformIdentity, t,0.0);
    CGAffineTransform translateLeft =CGAffineTransformTranslate(CGAffineTransformIdentity,-t,0.0);
    viewToShake.transform = translateLeft;
    [UIView animateWithDuration:0.07 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:2.0];
        viewToShake.transform = translateRight;
    }completion:^(BOOL finished){
        if(finished){
            [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                viewToShake.transform =CGAffineTransformIdentity;
            } completion:NULL];
        }
    }];
}

@end
