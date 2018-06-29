//
//  VersionView.h
//  HCBuyerApp
//
//  Created by haoche51 on 16/3/16.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol VersionViewDelegate <NSObject>

- (void)pushApptore;

@end


@interface VersionView : UIView

@property (nonatomic, assign)id<VersionViewDelegate>delegate;
@property (nonatomic, strong)NSString *webUrl;


- (id)initWithFrameRect:(CGRect)frame urlArray:(NSString *)content;

@end
