//
//  TDBaseViewController.m
//  TDRealNameAuth-UI-Demo
//
//  Created by Robin on 7/18/16.
//  Copyright © 2016 TendCloud. All rights reserved.
//

#import "TDBaseViewController.h"



@implementation TDBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSFontAttributeName:[UIFont systemFontOfSize:20.f]
                                                                      }];
} 

- (void)onRequestSuccess:(TDEAuthType)type requestId:(NSString *)requestId phoneNumber:(NSString *)phoneNumber phoneNumSeg:(NSArray *)phoneNumSeg {
    NSLog(@"Need implementation in subclass, %s", __FUNCTION__);
}

- (void)onRequestFailed:(TDEAuthType)type errorCode:(NSInteger)errorCode errorMessage:(NSString *)errorMessage{
    NSLog(@"Need implementation in subclass, %s", __FUNCTION__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 

@end
