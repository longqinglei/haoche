//
//  UiTapView.h
//  HCBuyerApp
//
//  Created by haoche51 on 16/4/7.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol UiTapViewDeleate <NSObject>

- (void)tapGestureView;

@end


@interface UiTapView : UITapGestureRecognizer

@property (nonatomic,assign)id<UiTapViewDeleate>tapdelegate;

- (id)initWithFrame:(UIView *)view;


@end
