//
//  HCRegistVC.m
//  HCBuyerApp
//
//  Created by 龙青磊 on 2018/6/23.
//  Copyright © 2018年 haoche51. All rights reserved.
//

#import "HCRegistVC.h"

@interface HCRegistVC ()

@end

@implementation HCRegistVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

}

- (void)creatSubViews{
    UIImageView *logoView = [[UIImageView alloc]init];
    logoView.image = [UIImage imageNamed:@""];
    [self.view addSubview:logoView];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavHegith + Width(40));
        make.left.equalTo(self.view).offset(Width(25));
        make.width.mas_equalTo(Width(150));
        make.height.mas_equalTo(Width(35));
    }];
    
    UILabel *titleLab = [HCUI_L creatLabeWithText:@"" textColor:[UIColor whiteColor] backColor:[UIColor clearColor] textAlignment:NSTextAlignmentRight textFont:16 numberOfLines:1];
    [self.view addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-Width(25));
        make.centerY.equalTo(logoView);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
