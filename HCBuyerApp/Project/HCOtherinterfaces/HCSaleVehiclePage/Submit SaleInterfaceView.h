//
//  Submit SaleInterfaceView.h
//  HCBuyerApp
//
//  Created by haoche51 on 15/11/10.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  Submit_SaleInterfaceViewDelegate<NSObject>

- (void)subMit;

- (void)removeFromSuperView;

@end

@interface Submit_SaleInterfaceView : UIView

@property (nonatomic,assign)id<Submit_SaleInterfaceViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame and:(NSString*)title and:(NSString *)description;

@end
