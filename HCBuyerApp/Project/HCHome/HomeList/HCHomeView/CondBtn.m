//
//  CondBtn.m
//  HCBuyerApp
//
//  Created by 张熙 on 16/5/27.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "CondBtn.h"

@implementation CondBtn


- (id)initWithPriceCond:(PriceCond*)cond{
    self = [super init];
    if (self) {
        [self drawLayer];
        self.priceCond = cond;
        [self setTitle:self.priceCond.desc forState:UIControlStateNormal];
    }
    return self;
    
}


- (id)initWithBrandCond:(BrandSeriesCond *)cond WithTaget:(id)target WithSelector:(SEL)selector{
    
    self = [super init];
    if (self) {
        [self drawLayer];
        self.brandCond = cond;
        self.target = target;
        self.selector = selector;
        [self createCoverView:cond];
      //   [self addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
       // CGFloat right = ( HCSCREEN_WIDTH - 45)/4 - 25;
        //NSString *imageName = [NSString stringWithFormat:@"%ld.png",(long)cond.brandId]
        
    }
    return self;
    
}


- (void)createCoverView:(BrandSeriesCond*)cond{
    UIView *view = [[UIView alloc]init];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self.target action:self.selector];
    gesture.delegate = self.target;
    gesture.numberOfTapsRequired = 1;
    [view addGestureRecognizer:gesture];
    view.userInteractionEnabled  = YES;
    view.frame = CGRectMake(0, 0, (HCSCREEN_WIDTH - 43)/4, ((HCSCREEN_WIDTH - 43)/4)*0.48);
    NSString *imageName = [NSString stringWithFormat:@"%ld.png",(long)cond.brandId];
    UIImageView *brandImage =[[UIImageView alloc]init];
    brandImage.frame = CGRectMake(0, (((HCSCREEN_WIDTH - 43)/4)*0.48-15)/2, 15, 15);
    brandImage.image = [UIImage imageNamed:imageName];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake(brandImage.right+5, (((HCSCREEN_WIDTH - 43)/4)*0.48-15)/2, 20, 15);
    titleLabel.font =  [UIFont systemFontOfSize:12];
    titleLabel.textColor = UIColorFromRGBValue(0x424242);
    titleLabel.text = cond.brandName;
    [titleLabel sizeToFit];
    if (titleLabel.width+brandImage.width+5>=(HCSCREEN_WIDTH - 45)/4) {
        [titleLabel setWidth:titleLabel.width-10];
    }
    [view setWidth:titleLabel.width+brandImage.width+5];
    [view setLeft:((HCSCREEN_WIDTH - 45)/4-view.width)/2];
    [view addSubview:brandImage];
    [view addSubview:titleLabel];
    [self addSubview:view];
}
-(id)initWithActivity:(Activity *)activity{
    self = [super init];
    if (self) {
        [self drawLayer];
        self.activity = activity;
        [self setTitle:self.activity.title forState:UIControlStateNormal];
    }
    return self;
}

- (void)drawLayer{
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    [self setBackgroundImage:[UIImage imageWithColor:UIColorFromRGBValue(0xf5f5f5) andSize:CGSizeMake((HCSCREEN_WIDTH - 43)/4, ((HCSCREEN_WIDTH - 43)/4)*0.48)] forState:UIControlStateHighlighted];
    [self setTitleColor: UIColorFromRGBValue(0x424242) forState:UIControlStateNormal];
   // self.titleLabel.textColor = UIColorFromRGBValue(0x212121);
    self.backgroundColor = UIColorFromRGBValue(0xf9f9f9);
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
