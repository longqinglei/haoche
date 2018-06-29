//
//  SortView.m
//  HCBuyerApp
//
//  Created by 张熙 on 15/9/18.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "SortView.h"
#import "DataFilter.h"
#import "UIImage+RTTint.h"

//#define UICOLOC ColorWithRGB(117, 117, 117)
#define Min_Width_4_Button 75.0
#define HCSegmentedControl_Width_Padding 0
#define HCSegmentedBottomLine_Padding 15.0f
#define Define_Tag_add 1000
#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians)*(180.0/M_PI))
#define SECTION_IV_TAG_BEGIN    3000
#define HCSegmentedControl_Height 40.0
#define HCSegment_BtnText_LeftPadding 8

#define HCSegmentSelectedColor ColorWithRGB(0,0,0)
@implementation SortView
- (id)initWithframeRec:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createMainView];
    }
    return self;
}

- (BOOL)isHiddenYes
{
    return _buttonPrice.hidden = YES;

}

-(void)createMainView
{
    _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, HCSCREEN_WIDTH-120, 44)];
    _numberLabel.font = [UIFont systemFontOfSize:12];
    _numberLabel.textAlignment = NSTextAlignmentLeft;
    _numberLabel.textColor = UIColorFromRGBValue(0x424242);
    _buttonPrice = [[UIButton alloc]initWithFrame:CGRectMake(HCSCREEN_WIDTH-170, 0,170, 44)];
    [_buttonPrice setImage:[UIImage imageNamed:@"sortImage"] forState:UIControlStateNormal];
    [_buttonPrice setImageEdgeInsets:UIEdgeInsetsMake(0, 145, 0, 0)];
    _buttonPrice.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [_buttonPrice setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -40)];
    [_buttonPrice.titleLabel setWidth:_buttonPrice.titleLabel.width];
    _buttonPrice.titleLabel.textAlignment = NSTextAlignmentRight;

    _buttonPrice.tag = 10000;
    _sectionBtnIv = [[UIImageView alloc] initWithFrame:CGRectMake(_buttonPrice.frame.origin.x + _buttonPrice.frame.size.width - 16, _buttonPrice.frame.origin.y + _buttonPrice.frame.size.height / 2  - 1, 8, 4)];
    [_sectionBtnIv setImage:[[UIImage imageNamed:@"option"] rt_tintedImageWithColor:UICOLOC]];
    [_buttonPrice addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonPrice setTitleColor:[UIColor colorWithRed:0.87f green:0.01f blue:0.01f alpha:1.00f] forState:UIControlStateNormal];
    [_buttonPrice addSubview:_sectionBtnIv];
    UIView*   mBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5, HCSCREEN_WIDTH, 0.5)];
    mBottomView.alpha = 0.3;
    mBottomView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_numberLabel];
    [self addSubview:_buttonPrice];
    [self addSubview:mBottomView];
    self.backgroundColor = [UIColor whiteColor];
}

- (void)btnClick:(UIButton*)sender{
  
    if (self.delegate) {
        [self.delegate listPageUpdateByFilter];
    }
    
    
}
- (void)initDropdownView{
    
}
@end
