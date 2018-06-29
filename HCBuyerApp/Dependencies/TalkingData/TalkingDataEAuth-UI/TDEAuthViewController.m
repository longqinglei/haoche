//
//  TDEAuthViewController.m
//  TDRealNameAuth-UI-Demo
//
//  Created by Robin on 7/19/16.
//  Copyright © 2016 TendCloud. All rights reserved.
//

#import "TDEAuthViewController.h"
#import "TDAuthenticateButton.h"
#import "TDInputTelephoneNumberController.h"

@interface TDEAuthViewController ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet TDAuthenticateButton *authButton;

@property (nonatomic, assign) BOOL isVerify;

@property (nonnull, strong) NSString *accountName;

@end

@implementation TDEAuthViewController

- (id)initWithAccountName:(NSString *)accountName{
    self = [super init];
    if (self) {
        
        if (!accountName || accountName.length <= 0) {
            NSLog(@"账号不能为空或空的字符串！");
            return nil;
        }
        
        self.accountName = accountName;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.authButton.tdButtonStyle = AuthButtonStyleInfo;
    self.authButton.enabled = true;
    
    [self.authButton startAnimation];
    
    [self.authButton setTitle:@"检查中..." forState:UIControlStateNormal];
    self.authButton.imageEdgeInsets = UIEdgeInsetsZero;
    
    [self checkCurrentAuthStatus];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"实名认证";
}

- (void)checkCurrentAuthStatus { 
    [TalkingDataEAuth isVerifyAccount:self.accountName delegate:self];
}


#pragma mark -- TDEAuth Delegate
- (void)onRequestSuccess:(TDEAuthType)type requestId:(NSString *)requestId phoneNumber:(NSString *)phoneNumber phoneNumSeg:(NSArray *)phoneNumSeg {
    [self.authButton stopAnimation];
    
    self.authButton.tdButtonStyle = AuthButtonStylePrimary;
    self.authButton.enabled = true;
    
    if (type == TDEAuthTypeChecker) { 
        [self EAuthSuccess:nil];
    }
}

- (void)onRequestFailed:(TDEAuthType)type errorCode:(NSInteger)errorCode errorMessage:(NSString *)errorMessage{
     [self.authButton stopAnimation];
    
    self.authButton.tdButtonStyle = AuthButtonStylePrimary;
    self.authButton.enabled = true;
    
    if (type == TDEAuthTypeChecker) {
        [self.authButton setTitle:@"未认证" forState:UIControlStateNormal];
        [self.authButton setImage:nil forState:UIControlStateNormal];
        NSLog(@"此账号未认证. errorCode: %ld， errorMessage: %@",(long)errorCode, errorMessage);
    }
}
- (IBAction)authButtonAction:(id)sender {  
    if (self.isVerify) {
        if (SYSTEM_VERSION >= 8.0) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"已认证" message:@"此账号已认证，是否需要重新认证？" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *reAuthAction = [UIAlertAction actionWithTitle:@"重新认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self gotoInputViewController];
            }];
            
            [alertController addAction:reAuthAction];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"已认证" message:@"此账号已认证，是否需要重新认证？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新认证", nil];
            [alertView show];
        }
    }else{
        [self gotoInputViewController];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self gotoInputViewController];
    }
}

- (void)gotoInputViewController{
    TDInputTelephoneNumberController *inputViewController = [[TDInputTelephoneNumberController alloc]initWithNibName:@"TDInputTelephoneNumberController" bundle:nil];
    inputViewController.accName = self.accountName;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:inputViewController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)EAuthSuccess:(NSNotification *)notification{
    self.isVerify = YES;
    self.authButton.tdButtonStyle = AuthButtonStyleSuccess;
    [self.authButton setTitle:@"已认证" forState:UIControlStateNormal];
    [self.authButton setImage:[UIImage imageNamed:@"success"] forState:UIControlStateNormal];
    self.authButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
}
 

@end
