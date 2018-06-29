//
//  TDInputBoxView.h
//  TDRealNameAuth-UI-Demo
//
//  Created by 冯婷婷 on 16/7/13.
//  Copyright © 2016年 TendCloud. All rights reserved.
//

#import <UIKit/UIKit.h> 

@interface TDInputBoxView : UIView

///验证码
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

///验证码输入框
@property (weak, nonatomic) IBOutlet UITextField *rightTextField;


@property (weak, nonatomic) IBOutlet UIView *upLine;
@property (weak, nonatomic) IBOutlet UIView *downLine;
@property (weak, nonatomic) IBOutlet UIView *seperotorLine;


@end
