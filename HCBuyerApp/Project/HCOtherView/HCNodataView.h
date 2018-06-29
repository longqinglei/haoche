//
//  HCNodataView.h
//  HCBuyerApp
//
//  Created by 张熙 on 15/9/6.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCNodataView : UIView
+ (UIView *)createNoVehicleView:(UIView*)nodData target:(id)target action1:(SEL)select1 action2:(SEL)select2 fram:(CGRect)rect text:(NSString *)text andText:(NSString *)strText ishow:(BOOL)ishow;
+ (UIView *)getNetwordErrorViewWith:(NSString *)text view:(UIView*)networkErrorView;
+(UIView *)getWebNetWorkErrorView:(UIView *)webNetError;
+ (UIView *)getNetword:(NSString *)text view:(UIView*)networkErrorView;
+ (UIView *)createEmptySubVehicelview:(UIView*)emptyView fram:(CGRect)rect;
@end
