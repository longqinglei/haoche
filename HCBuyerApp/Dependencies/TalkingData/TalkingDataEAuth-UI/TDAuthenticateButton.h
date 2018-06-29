//
//  TDAuthenticateButton.h
//  TDRealNameAuth-UI-Demo
//
//  Created by Robin on 16/7/12.
//  Copyright © 2016年 TendCloud. All rights reserved.
//

#import <UIKit/UIKit.h> 

typedef NS_ENUM(NSInteger, AuthButtonStyle) {
    /* Style default button */
    AuthButtonStyleDefault = 0,
    /* Style primary button */
    AuthButtonStylePrimary,
    /* Style success button */
    AuthButtonStyleSuccess,
    /* Style info button */
    AuthButtonStyleInfo,
    /* Style warning button */
    AuthButtonStyleWarning,
    /* Style danger button */
    AuthButtonStyleDanger
};


@interface TDAuthenticateButton : UIButton

@property (nonatomic, readwrite) AuthButtonStyle tdButtonStyle;


//Return a new initialized `TDAuthenticateButton` instance , Button Style is `AuthButtonStyleDefault`
- (instancetype)initWithFrame:(CGRect)frame;

//Return a new initialized `TDAuthenticateButton` instance
- (instancetype)initWithFrame:(CGRect)frame style:(AuthButtonStyle)buttonStyle;

- (void)startAnimation;
- (void)stopAnimation;

@end
