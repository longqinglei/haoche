//
//  TDAuthenticateButton.m
//  TDRealNameAuth-UI-Demo
//
//  Created by Robin on 16/7/12.
//  Copyright © 2016年 TendCloud. All rights reserved.
//

#import "TDAuthenticateButton.h"
#import <QuartzCore/QuartzCore.h>

@interface TDAuthenticateButton(){
    NSString *titleForButton;
    CGRect frameBtn;
}

@property (nonatomic, strong)  UIActivityIndicatorView *loadingView;

@end

@implementation TDAuthenticateButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    frameBtn = frame;
    if (self) {
        // Initialization code
        _tdButtonStyle = AuthButtonStylePrimary;
        [self setupButton];
        [self addSubview:self.loadingView];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame style:(AuthButtonStyle)buttonStyle{
    self = [super initWithFrame:frame];
    frameBtn = frame;
    if (self) {
        // Initialization code
        _tdButtonStyle = buttonStyle;
        [self setupButton];
        [self addSubview:self.loadingView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _tdButtonStyle = AuthButtonStylePrimary;
        [self setupButton];
        [self addSubview:self.loadingView];
    }
    return self;
}

- (void)startAnimation{
    [self.loadingView startAnimating];
}

- (void)stopAnimation{
    [self.loadingView stopAnimating];
}

- (void)setTdButtonStyle:(AuthButtonStyle)buttonStyle{
    _tdButtonStyle = buttonStyle;
    [self setupButton];
}


-(UIImage *)imageWithColorToButton:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)setupButton
{
    switch (self.tdButtonStyle) {
        case AuthButtonStyleDefault:
            [self setBackgroundImage:[self imageWithColorToButton:[UIColor whiteColor]] forState:UIControlStateNormal];
            [self setBackgroundImage:[self imageWithColorToButton:[UIColor colorWithRed:230.0f/255 green:230.0f/255 blue:230.0f/255 alpha:1]] forState:UIControlStateHighlighted];
            [self setTitleColor:[UIColor colorWithRed:51.0f/255 green:51.0f/255 blue:51.0f/255 alpha:1] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor colorWithRed:77.0f/255 green:51.0f/255 blue:51.0f/255 alpha:1] forState:UIControlStateNormal];
            break;
        case AuthButtonStylePrimary:
            [self setBackgroundImage:[self imageWithColorToButton:[UIColor colorWithRed:70.0f/255 green:138.0f/255 blue:207.0f/255 alpha:1]] forState:UIControlStateNormal];
            [self setBackgroundImage:[self imageWithColorToButton:[UIColor colorWithRed:51.0f/255 green:112.0f/255 blue:173.0f/255 alpha:1]] forState:UIControlStateHighlighted];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        case AuthButtonStyleSuccess:
            [self setBackgroundImage:[self imageWithColorToButton:[UIColor colorWithRed:30.0f/255 green:215.0f/255 blue:95.0f/255 alpha:1]] forState:UIControlStateNormal];
            [self setBackgroundImage:[self imageWithColorToButton:[UIColor colorWithRed:29.0f/255 green:177.0f/255 blue:81.0f/255 alpha:1]] forState:UIControlStateHighlighted];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        case AuthButtonStyleInfo:
            [self setBackgroundImage:[self imageWithColorToButton:[UIColor colorWithRed:121.0f/255 green:173.0f/255 blue:253.0f/255 alpha:1]] forState:UIControlStateNormal];
            [self setBackgroundImage:[self imageWithColorToButton:[UIColor colorWithRed:51.0f/255 green:112.0f/255 blue:173.0f/255 alpha:1]] forState:UIControlStateHighlighted];
            [self setTitleColor:[UIColor colorWithRed:221.0f/255 green:236.0f/255 blue:255.0f/255 alpha:1] forState:UIControlStateNormal];
            break;
        case AuthButtonStyleWarning:
            [self setBackgroundImage:[self imageWithColorToButton:[UIColor colorWithRed:238.0f/255 green:174.0f/255 blue:56.0f/255 alpha:1]] forState:UIControlStateNormal];
            [self setBackgroundImage:[self imageWithColorToButton:[UIColor colorWithRed:233.0f/255 green:152.0f/255 blue:0.0f/255 alpha:1]] forState:UIControlStateHighlighted];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        case AuthButtonStyleDanger:
            [self setBackgroundImage:[self imageWithColorToButton:[UIColor colorWithRed:212.0f/255 green:84.0f/255 blue:76.0f/255 alpha:1]] forState:UIControlStateNormal];
            [self setBackgroundImage:[self imageWithColorToButton:[UIColor colorWithRed:193.0f/255 green:49.0f/255 blue:38.0f/255 alpha:1]] forState:UIControlStateHighlighted];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            break;
        default:
            [self setBackgroundImage:[self imageWithColorToButton:[UIColor whiteColor]] forState:UIControlStateNormal];
            [self setBackgroundImage:[self imageWithColorToButton:[UIColor colorWithRed:230.0f/255 green:230.0f/255 blue:230.0f/255 alpha:1]] forState:UIControlStateHighlighted];
            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal]; 
            break;
    }
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
}

- (UIActivityIndicatorView*)loadingView{
    if(!_loadingView){
        self.loadingView = [[UIActivityIndicatorView alloc] initWithFrame:self.frame];
        [self.loadingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        [self.loadingView setCenter:CGPointMake(CGRectGetMinX(self.bounds) + 30, CGRectGetMidY(self.bounds))];
        [self.loadingView setHidesWhenStopped:YES];
    }
    return _loadingView;
}


@end
