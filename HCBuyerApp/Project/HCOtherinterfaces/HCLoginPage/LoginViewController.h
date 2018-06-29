//
//  LoginViewController.h
//  HCBuyerApp
//
//  Created by wj on 15/7/29.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^LoginViewFinish)();

@interface LoginViewController :HCRequestAllPage
@property(nonatomic,copy)LoginViewFinish guidanceFinishBlock;//引导页完成时的回调
@property (nonatomic)int type;

@end
