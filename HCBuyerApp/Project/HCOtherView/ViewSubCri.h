//
//  ViewSubCri.h
//  HCBuyerApp
//
//  Created by haoche51 on 15/8/22.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewSubCriDelegate

- (void)LoginControllerJump;

@end

@protocol ViewCollectionDelegate

- (void)ViewCollectionJmp;

@end


@interface ViewSubCri : UIView<UIScrollViewDelegate>

@property (nonatomic,assign)id <ViewSubCriDelegate>delegate;

@property (nonatomic,assign)id <ViewCollectionDelegate>CollectionDelegate;
- (id) initWithFrame:(CGRect)frame;

- (id) initWithFrameCollection:(CGRect)frame;
@end
