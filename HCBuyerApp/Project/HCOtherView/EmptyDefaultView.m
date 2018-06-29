//
//  EmptyDefaultView.m
//  WandaKTV
//
//  Created by Wei Mao on 4/17/13.
//  Copyright (c) 2013 Wanda Inc. All rights reserved.
//

// Modify by Rush.D.Xzj 2013-12-06

#import "EmptyDefaultView.h"

@interface EmptyDefaultView ()
{
    CGFloat width;
    CGFloat height;
}
@property (strong, nonatomic) UIImageView *ivLogo;

@end

@implementation EmptyDefaultView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        width = frame.size.width;
        height = frame.size.height;
        self.ivLogo = [[UIImageView alloc] init];
        [self addSubview:self.ivLogo];
    
        self.lblDescription = [[UILabel alloc]init];
        self.lblDescription.textAlignment = NSTextAlignmentCenter;
        self.lblDescription.textColor = [UIColor grayColor];
        self.lblDescription.font = [UIFont systemFontOfSize:15];
        self.lblDescription.backgroundColor = [UIColor clearColor];
        self.lblDescription.numberOfLines = 2;
        [self addSubview:self.lblDescription];
        [self setUserInteractionEnabled:NO];

        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tapRecognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

- (void)layoutSubviews
{
    UIImage *image = [UIImage imageNamed:(self.logoImageName)];
    self.ivLogo.image = image;
    CGFloat ivWidth = image.size.width-10;
    CGFloat ivHeight = image.size.height-10;
    CGFloat sep = 5;
    CGFloat lblHeight = 40;
    CGFloat lblX = 0;
    CGFloat ivX = (width - ivWidth) / 2.0f;
    CGFloat remainHeight = height - ivHeight - lblHeight;
    CGFloat ivY ;
    if (remainHeight < 0) {
        ivY = 0;
    } else if (remainHeight > sep) {
        ivY = remainHeight / 2.0f;
    } else {
        ivY = sep;
    }
    self.ivLogo.frame = CGRectMake(ivX, ivY, ivWidth, ivHeight);
    CGFloat lblY = ivY + ivHeight + sep;
    self.lblDescription.frame = CGRectMake(lblX, lblY, width, lblHeight);
}

- (void)setLogoImageName:(NSString *)logoImageName
{
    if (logoImageName) {
        _logoImageName = logoImageName;
        [self layoutSubviews];
    }
}

- (void)tap:(UIGestureRecognizer *)gesture
{
    if (self.tapBlock) {
        self.tapBlock();
    }
}
@end
