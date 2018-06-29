//
//  PageView.h
//  HCBuyerApp
//
//  Created by haoche51 on 16/4/8.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageView : UIView

- (id)initWithFrameRect:(CGRect)frame;

@property (nonatomic,strong)UILabel *labelPageText;

- (void)timeDuration:(NSInteger)duration superView:(UIView *)superView pageNumber:(NSInteger)number;

- (void)removerPageView;

@end
