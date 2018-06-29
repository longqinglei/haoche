//
//  HCInfoView.h
//  HCBuyerApp
//
//  Created by 张熙 on 15/8/31.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HCInfoViewDelegate

@required

- (void)showInfoView;



@end
@interface HCInfoView : UIView
@property (assign, nonatomic) id<HCInfoViewDelegate> delegate;

- (id) initWithFrame:(CGRect)frame type:(NSInteger)type;
@end
