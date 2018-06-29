//
//  EmptyDefaultView.h
//  WandaKTV
//
//  Created by Wei Mao on 4/17/13.
//  Copyright (c) 2013 Wanda Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmptyDefaultView : UIView

@property (strong, nonatomic) UILabel *lblDescription;
@property (strong, nonatomic) NSString *logoImageName;

@property(nonatomic,copy) void(^tapBlock)(void);
@end
