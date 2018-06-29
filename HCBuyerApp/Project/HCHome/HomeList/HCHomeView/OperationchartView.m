//
//  OperationchartView.m
//  HCBuyerApp
//
//  Created by haoche51 on 15/11/26.
//  Copyright © 2015年 haoche51. All rights reserved.
//

#import "OperationchartView.h"
#import "UIImageView+WebCache.h"

@implementation OperationchartView

- (id)initWithframeRec:(CGRect)frame  urlImage:(NSString *)string
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createMainView:string];
    }
    return self;
}

- (void)createMainView:(NSString *)string
{
    self.backgroundColor =  [UIColor colorWithRed:0.15f green:0.15f blue:0.15f alpha:0.80f];
    UIButton *button = [UIButton buttonWithFrame:CGRectMake(HCSCREEN_WIDTH-75, HCSCREEN_HEIGHT/6-HCSCREEN_HEIGHT/7+5, 35, HCSCREEN_HEIGHT/7) title:@"" titleColor:nil bgColor:nil titleFont:nil image:[UIImage imageNamed:@"closeImge"] selectImage:nil target:self action:@selector(btnClose:) tag:0];
    if (iPhone4s) {
        _operationChartImage = [[UIImageView alloc]initWithFrame:CGRectMake(HCSCREEN_WIDTH/21, button.height, HCSCREEN_WIDTH-HCSCREEN_WIDTH/21*2, HCSCREEN_HEIGHT/1.3)];
    }else{
     _operationChartImage = [[UIImageView alloc]initWithFrame:CGRectMake(HCSCREEN_WIDTH/21, button.height, HCSCREEN_WIDTH-HCSCREEN_WIDTH/21*2, HCSCREEN_HEIGHT/1.46)];
    }
    _operationChartImage.layer.masksToBounds = YES;
    _operationChartImage.layer.cornerRadius = 6.0;
    _operationChartImage.userInteractionEnabled = YES;
    NSString *strImageView = [NSString getFixedSolutionImageAllurl:string w:_operationChartImage.width*2 h:_operationChartImage.width*2];
    [_operationChartImage sd_setImageWithURL:[NSURL URLWithString:strImageView] placeholderImage:nil];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [_operationChartImage addGestureRecognizer:tapRecognizer];
    [self addSubview:button];
    [self addSubview:_operationChartImage];
}

- (void)tap:(UIGestureRecognizer *)gesTure
{
      [self removeFromSuperview];
    if (self.webUrl) {
        if (self.delegate) {
            [self.delegate pushActivitiDetail:self.webUrl];
        }
    }

    [HCAnalysis HCUserClick:@"operation_click"];
}

- (void)btnClose:(UIButton*)btn
{
    [self removeFromSuperview];
    [HCAnalysis HCUserClick:@"operation_closeclick"];
}


@end
