//
//  TDInputTelephoneNumberController.m
//  TDRealNameAuth-UI-Demo
//
//  Created by 冯婷婷 on 16/7/12.
//  Copyright © 2016年 TendCloud. All rights reserved.
//

#import "TDInputTelephoneNumberController.h"
#import "TDVerificationController.h"
#import "TDLawDeclareViewController.h"
#import "TDAuthenticateButton.h"
#import "TDInputBoxView.h"
#import "TDAuthTools.h"


@interface TDInputTelephoneNumberController ()<UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate>

///请输入您的手机号
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
///国家/地区
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
///中国
@property (weak, nonatomic) IBOutlet UILabel *nationLabel;
///下一步
@property (weak, nonatomic) IBOutlet TDAuthenticateButton *nextStepsButton;
///实名认证提示
@property (weak, nonatomic) IBOutlet UILabel *lawTextLabel;
///国家和地区
@property (weak, nonatomic) IBOutlet UIView *countryView;
//异常提示
@property (weak, nonatomic) IBOutlet UILabel *exceptionTipLabel;

@property (nonatomic,strong) TDInputBoxView *inputBoxView;

@property (nonatomic,strong) TDInputBoxView *authCodeTypeView;

@property (nonatomic,strong) UIPickerView *pickerView;

@property (nonatomic,strong) NSArray *pickerData;

@end

@implementation TDInputTelephoneNumberController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消"  style:UIBarButtonItemStylePlain target:self action:@selector(dismissController:)];
    //Next VC's backItem title setting
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.nextStepsButton.tdButtonStyle = AuthButtonStyleInfo;
    self.nextStepsButton.enabled = false;
    
    [self.inputBoxView.rightTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    [self setupInputBoxView];
    
    self.authCodeTypeView.rightTextField.inputView = self.pickerView;
    self.authCodeTypeView.rightTextField.text = self.pickerData[0];

    [self setupAuthCodeTypeView];
    
    [self colorSettings];
    
    UITapGestureRecognizer *hideKeyboardGesturer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [self.view addGestureRecognizer:hideKeyboardGesturer];

}

//设置控件颜色
- (void)colorSettings {
    self.countryLabel.textColor = UIColorFromRGB(0x464c5b);
    self.tipLabel.textColor = UIColorFromRGB(0x464c5b);
    self.countryLabel.textColor = UIColorFromRGB(0x464c5b);
    self.nationLabel.textColor = UIColorFromRGB(0x464c5b);
    self.lawTextLabel.textColor = UIColorFromRGB(0x464c5b);
    
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:kLawTipMessage];
    NSRange subRange = [kLawTipMessage rangeOfString:kLawTipHightlight];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:UIColorFromRGB(0x4279c5)
                          range:subRange];
    
    self.lawTextLabel.attributedText = attributedStr;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lawTextLabelViewTapped)];
    tap.cancelsTouchesInView = NO;
    self.lawTextLabel.userInteractionEnabled  = YES;
    [self.lawTextLabel addGestureRecognizer:tap]; 
}

- (void)hideKeyboard:(UIGestureRecognizer *)gesturer{
    [self.inputBoxView.rightTextField resignFirstResponder];
    [self.authCodeTypeView.rightTextField resignFirstResponder];
}

#pragma mark -buttonClick
///取消按钮
- (void)dismissController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"dismiss inputViewController");
    }];
}


- (void)lawTextLabelViewTapped{
    TDLawDeclareViewController *lawVC = [[TDLawDeclareViewController alloc]initWithNibName:@"TDLawDeclareViewController" bundle:nil];
    UINavigationController *lawNav = [[UINavigationController alloc] initWithRootViewController:lawVC];
    [self presentViewController:lawNav animated:YES completion:nil];
}

///下一步按钮
- (IBAction)nextStepButtonClick:(id)sender {
    [self.inputBoxView.rightTextField resignFirstResponder];
    self.exceptionTipLabel.text = @"";
    
    NSString *inputString = self.inputBoxView.rightTextField.text;
    
    if (![TDAuthTools isPureNumber:inputString]) {
        [self.inputBoxView.rightTextField becomeFirstResponder];
        self.exceptionTipLabel.text = @"手机号码异常，请查证后重新输入";
        return;
    } 
    
    [self.nextStepsButton startAnimation];
    
    // check is verify
    [TalkingDataEAuth isMobileMatchAccount:self.accName countryCode:kCountryCode mobile:inputString delegate:self];
}

#pragma mark -- TDEAuth Delegate
- (void)onRequestSuccess:(TDEAuthType)type requestId:(NSString *)requestId phoneNumber:(NSString *)phoneNumber phoneNumSeg:(NSArray *)phoneNumSeg {
    self.nextStepsButton.enabled = true;
    [self.nextStepsButton stopAnimation];
    
    if (type == TDEAuthTypePhoneMatch) {
        [self showAlertView];
    } else if (type == TDEAuthTypeApplyCode) {
        NSLog(@"认证码请求成功.");
        TDVerificationController *verifyController = [[TDVerificationController alloc]initWithNibName:@"TDVerificationController" bundle:nil];
        verifyController.countryCode = [@"+" stringByAppendingString:kCountryCode];
        verifyController.phoneNumber = self.inputBoxView.rightTextField.text;
        verifyController.accName = self.accName;
        verifyController.selectedRow = [self.pickerView selectedRowInComponent:0];
        [self.navigationController pushViewController:verifyController animated:YES];
    }
}

- (void)onRequestFailed:(TDEAuthType)type errorCode:(NSInteger)errorCode errorMessage:(NSString *)errorMessage{
    [self.nextStepsButton stopAnimation];
    self.nextStepsButton.enabled = true;
    
    if (errorCode == 600) { 
        self.exceptionTipLabel.text = errorMessage;
        return;
    }
    
    if (type == TDEAuthTypePhoneMatch) {  
        NSLog(@"此账号未认证. errorCode: %ld， errorMessage: %@",(long)errorCode, errorMessage);
        [self.nextStepsButton startAnimation];
        // applyAuthCode
        NSString *inputString = self.inputBoxView.rightTextField.text;
        [TalkingDataEAuth applyAuthCode:kCountryCode mobile:inputString authCodeType:[self.pickerView selectedRowInComponent:0] accountName:self.accName delegate:self];
        
    } else if (type == TDEAuthTypeApplyCode) {
        [self.inputBoxView.rightTextField becomeFirstResponder];
        NSLog(@"认证码请求失败. errorCode: %ld， errorMessage: %@",(long)errorCode, errorMessage);
        self.exceptionTipLabel.text = errorMessage;
    }
}

- (void)showAlertView{
    if (SYSTEM_VERSION >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"已认证" message:@"您已经用此手机号码完成实名认证，是否需要重新认证？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *reAuthAction = [UIAlertAction actionWithTitle:@"重新认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self pushToNextViewController];
        }];
        
        [alertController addAction:reAuthAction];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"已认证" message:@"您已经用此手机号码完成实名认证，是否需要重新认证？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新认证", nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self pushToNextViewController];
    }
}

- (void)pushToNextViewController{
    self.nextStepsButton.enabled = false;
    [self.nextStepsButton startAnimation];
    // applyAuthCode
    NSString *inputString = self.inputBoxView.rightTextField.text;
    [TalkingDataEAuth applyAuthCode:kCountryCode mobile:inputString authCodeType:[self.pickerView selectedRowInComponent:0] accountName:self.accName delegate:self];
}

- (void)textFieldDidChange:(UITextField *)textField{
    if (textField.text.length > 0) {
        self.nextStepsButton.tdButtonStyle = AuthButtonStylePrimary;
        self.nextStepsButton.enabled = true;
    }else{
        self.nextStepsButton.tdButtonStyle = AuthButtonStyleInfo;
        self.nextStepsButton.enabled = false;
    }
}

#pragma mark - setup
-(void) setupInputBoxView{
    [self.view addSubview:self.inputBoxView];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.inputBoxView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:(self.countryView) attribute:NSLayoutAttributeBottom multiplier:1 constant:5];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.inputBoxView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:(self.view) attribute:NSLayoutAttributeLeft multiplier:1 constant:10];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.inputBoxView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:(self.view) attribute:NSLayoutAttributeRight multiplier:1 constant:-10];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.inputBoxView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:50];
    
    [self.view addConstraint:top];
    [self.view addConstraint:left];
    [self.view addConstraint:right];
    [self.view addConstraint:height];
}

- (void)setupAuthCodeTypeView {
    [self.view addSubview:self.authCodeTypeView];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.authCodeTypeView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:(self.inputBoxView) attribute:NSLayoutAttributeBottom multiplier:1 constant:-1];
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.authCodeTypeView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:(self.view) attribute:NSLayoutAttributeLeft multiplier:1 constant:10];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.authCodeTypeView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:(self.view) attribute:NSLayoutAttributeRight multiplier:1 constant:-10];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.authCodeTypeView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:50];
    
    [self.view addConstraint:top];
    [self.view addConstraint:left];
    [self.view addConstraint:right];
    [self.view addConstraint:height];
}

#pragma mark - getter and setter
- (TDInputBoxView *)inputBoxView {
    if (!_inputBoxView) {
        _inputBoxView = [[[NSBundle mainBundle] loadNibNamed:@"TDInputBoxView" owner:self options:nil]lastObject];
        _inputBoxView.translatesAutoresizingMaskIntoConstraints = NO;
        _inputBoxView.rightTextField.clearButtonMode = UITextFieldViewModeAlways;
        _inputBoxView.rightTextField.placeholder = @"请输入您的手机号";
        _inputBoxView.leftLabel.text = [@"+" stringByAppendingString:kCountryCode];
    }
    return _inputBoxView;
}

- (TDInputBoxView *)authCodeTypeView {
    if (!_authCodeTypeView) {
        _authCodeTypeView = [[[NSBundle mainBundle] loadNibNamed:@"TDInputBoxView" owner:self options:nil]lastObject];
        _authCodeTypeView.translatesAutoresizingMaskIntoConstraints = NO;
        _authCodeTypeView.rightTextField.clearButtonMode = UITextFieldViewModeAlways;
        _authCodeTypeView.rightTextField.placeholder = @"请选择认证方式";
        _authCodeTypeView.leftLabel.text = @"认证方式";
    }
    return _authCodeTypeView;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerData = @[@"短信认证",@"语音认证"];
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.showsSelectionIndicator = YES;
    }
    return _pickerView;
}

#pragma mark - Picker view data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 2;
}

#pragma mark Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _pickerData[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.authCodeTypeView.rightTextField.text = _pickerData[row];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
