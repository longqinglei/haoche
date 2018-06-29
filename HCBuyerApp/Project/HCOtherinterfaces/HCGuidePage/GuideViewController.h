//
//  GuideViewController.h
//  HCBuyerApp
//
//  Created by wj on 15/5/21.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GuideViewController;

@protocol GuideViewControllerDelegate <NSObject>
- (void)launchViewAction;  //代理跳转
-(void)pushActiviti:(NSString *)weburl;
- (void)pushViewController:(NSInteger)type;
@end

@interface GuideViewController : HCBaseViewController
@property (nonatomic, assign) id <GuideViewControllerDelegate> delegate;

@end
