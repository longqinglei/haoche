//
//  TDLawDeclareViewController.m
//  TDRealNameAuth-UI-Demo
//
//  Created by Mr.Lee on 16/7/18.
//  Copyright © 2016年 TendCloud. All rights reserved.
//

#import "TDLawDeclareViewController.h"
#import "TDAuthTools.h"

@interface TDLawDeclareViewController ()


@end

@implementation TDLawDeclareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"实名认证声明";
    
    UIBarButtonItem *cancelBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭"  style:UIBarButtonItemStylePlain target:self action:@selector(dismissController:)];
    self.navigationItem.leftBarButtonItem = cancelBtnItem;
    
    [self.navigationController.navigationBar setBackgroundImage:[TDAuthTools imageWithColorToButton:UIColorFromRGB(0x464c5b)] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0xffffff);
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName:UIColorFromRGB(0xffffff),
                                                                      NSFontAttributeName:[UIFont systemFontOfSize:20.f]
                                                                      }];
} 


- (void)dismissController:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"dismiss LawDeclareViewController");
    }]; 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
