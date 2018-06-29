//
//  TDVerificationController.m
//  TDRealNameAuth-UI-Demo
//
//  Created by 冯婷婷 on 16/7/12.
//  Copyright © 2016年 TendCloud. All rights reserved.
//

#import "TDVerificationController.h"
#import "TDAuthenticateButton.h"
#import "TDInputTelephoneNumberController.h"
#import "TDInputBoxView.h"
#import "TDAuthTools.h"
#import "TDToastView.h"


@interface TDVerificationController ()<UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

///请输入验证码
@property (weak, nonatomic) IBOutlet UILabel *verifyTipLabel;

///手机号
@property (weak, nonatomic) IBOutlet UILabel *telephoneNumberText;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

///验证码已超时
@property (weak, nonatomic) IBOutlet UILabel *exceptionTipLabel;

///提交按钮
@property (weak, nonatomic) IBOutlet TDAuthenticateButton *commitButton;

///验证码倒计时
@property (weak, nonatomic) IBOutlet UIButton *vertifyTimerButton;

@property (nonatomic,strong) TDInputBoxView *inputBoxView;

@property (nonatomic,strong) TDInputBoxView *authCodeTypeView;

@property (nonatomic,strong) UIPickerView *pickerView;

@property (nonatomic,strong) NSArray *pickerData;


@end

@implementation TDVerificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
    
    self.phoneNumberLabel.text = [self.countryCode stringByAppendingFormat:@"  %@",self.phoneNumber];
    
    self.commitButton.tdButtonStyle = AuthButtonStyleInfo;
    self.commitButton.enabled = false;
    
    [self.view addSubview:self.inputBoxView];
    [self.inputBoxView.rightTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self setupInputBoxView];
    
    self.authCodeTypeView.rightTextField.inputView = self.pickerView;
    self.authCodeTypeView.rightTextField.text = self.pickerData[_selectedRow];
    self.authCodeTypeView.rightTextField.enabled = false;
    [self setupAuthCodeTypeView];
    
    [self startTimer];
    [self colorSettings];
    
    
    UITapGestureRecognizer *hideKeyboardGesturer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [self.view addGestureRecognizer:hideKeyboardGesturer];
}

- (void)colorSettings { 
    self.verifyTipLabel.textColor = UIColorFromRGB(0x464c5b);
    self.telephoneNumberText.textColor = UIColorFromRGB(0x9da7b4);
    self.phoneNumberLabel.textColor = UIColorFromRGB(0x9da7b4);
    self.exceptionTipLabel.textColor = UIColorFromRGB(0xe14141);
}

- (void)hideKeyboard:(UIGestureRecognizer *)gesturer{
    [self.inputBoxView.rightTextField resignFirstResponder];
    [self.authCodeTypeView.rightTextField resignFirstResponder];
}

#pragma mark - setup
- (void) setupInputBoxView{
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.inputBoxView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:(self.telephoneNumberText) attribute:NSLayoutAttributeBottom multiplier:1 constant:5];
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
        [_pickerView selectRow:self.selectedRow inComponent:0 animated:NO];
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

- (void)startTimer{
    __block int timeout= 59;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.authCodeTypeView.rightTextField.enabled = true;
                self.vertifyTimerButton.enabled = true;
                [self.vertifyTimerButton setTitle:@"重新获取验证码" forState:UIControlStateNormal];
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.vertifyTimerButton.enabled = false;
                NSString *text = [NSString stringWithFormat:@"重新发送验证码（%@s）",strTime]; 
                [self.vertifyTimerButton setTitle:text forState:UIControlStateNormal];
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}


- (IBAction)getAuthCodeButtonClick:(id)sender{
    [self.inputBoxView.rightTextField resignFirstResponder];
    self.exceptionTipLabel.text = @"";
    self.authCodeTypeView.rightTextField.enabled = false;
    
    [TalkingDataEAuth applyAuthCode:kCountryCode mobile:self.phoneNumber authCodeType:TDAuthCodeTypeSMS accountName:self.accName delegate:self];
}

- (IBAction)bindButtonClick:(id)sender{
    [self.inputBoxView.rightTextField resignFirstResponder]; 
    self.exceptionTipLabel.text = @"";
    
    NSString *inputString = self.inputBoxView.rightTextField.text;
    
    if (![TDAuthTools isPureNumber:inputString]) {
        [self.inputBoxView.rightTextField becomeFirstResponder];
        self.exceptionTipLabel.text = @"验证码异常，请查证后重新输入";
        return;
    }
    [self.commitButton startAnimation];
    [TalkingDataEAuth bindEAuth:kCountryCode mobile:self.phoneNumber authCode:inputString accountName:self.accName delegate:self];
}

#pragma mark -- TDEAuth Delegate
- (void)onRequestSuccess:(TDEAuthType)type requestId:(NSString *)requestId phoneNumber:(NSString *)phoneNumber phoneNumSeg:(NSArray *)phoneNumSeg {
    [self.commitButton stopAnimation];
    if (type == TDEAuthTypeApplyCode) {
        [self startTimer];
    } else if (type == TDEAuthTypeBind) {
        if (SYSTEM_VERSION >= 8.0) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"恭喜您，已认证成功" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertController animated:YES completion:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [alertController dismissViewControllerAnimated:YES completion:NULL];
                [self dismissViewControllerAnimated:YES completion:NULL];
            });
        }else{
            UIAlertView *toastView = [[UIAlertView alloc] initWithTitle:nil message:@"恭喜您，已认证成功" delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
            [toastView show];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [toastView dismissWithClickedButtonIndex:0 animated:YES];
                [self dismissViewControllerAnimated:YES completion:NULL];
            });
        }
    }
}

- (void)onRequestFailed:(TDEAuthType)type errorCode:(NSInteger)errorCode errorMessage:(NSString *)errorMessage{
    [self.commitButton stopAnimation];
    self.commitButton.enabled = true;
    
    if (errorCode == 600) {
        self.exceptionTipLabel.text = errorMessage;
        return;
    }
    
    if (type == TDEAuthTypeApplyCode) {
        NSLog(@"认证码请求失败. errorCode: %ld， errorMessage: %@",(long)errorCode, errorMessage);
        self.exceptionTipLabel.text = errorMessage;
    } else if (type == TDEAuthTypeBind) {
        NSLog(@"绑定失败. errorCode: %ld， errorMessage: %@",(long)errorCode, errorMessage);
        self.exceptionTipLabel.text = errorMessage;
        [self.inputBoxView.rightTextField becomeFirstResponder];
    }
}

 
- (void)textFieldDidChange:(UITextField *)textField{
    if (textField.text.length > 0) { 
        self.commitButton.tdButtonStyle = AuthButtonStylePrimary;
        self.commitButton.enabled = true;
    }else{
        self.commitButton.tdButtonStyle = AuthButtonStyleInfo;
        self.commitButton.enabled = false;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
