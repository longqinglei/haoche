//
//  HCCouponShot.h
//  HCBuyerApp
//
//  Created by 张熙 on 15/10/8.
//  Copyright © 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HCCouponDelegate<NSObject>

@required

- (void)checkNewCoupon;

@end
@interface HCCouponShot : UIView

@property (assign,nonatomic) id <HCCouponDelegate> delegate;
-(id)initWithFrame:(CGRect)frame num:(NSInteger)num ;
- (void)reloadNum:(NSInteger)num;
@end
