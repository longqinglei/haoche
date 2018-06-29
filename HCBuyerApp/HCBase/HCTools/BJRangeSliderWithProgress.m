//
//  BJRangeSliderWithProgress.m
//  BJRangeSliderWithProgress
//

//

#import "BJRangeSliderWithProgress.h"

@implementation BJRangeSliderWithProgress
@dynamic minValue, maxValue, currentProgressValue,leftValue, rightValue;


- (void)setLeftValue:(CGFloat)newValue   //从左向右滑动  相反回调也是这个
{
    if (newValue < minValuee)
        newValue = minValuee;
    if (newValue + 1 >= rightValuee)
        newValue = rightValuee-1;
    leftValuee = newValue;
    NSString *stringFloat = [NSString stringWithFormat:@"%d",(int)leftValuee];
    [self setCustomText];
  // _customPriceInfo.text = [NSString stringWithFormat:@"%d~%d万",(int)leftValuee,(int)rightValuee];
    [self Va:stringFloat Label:_customPriceInfo is:NO and:leftValuee];
    [self setNeedsLayout];
}
- (void)setCustomText{
    if ((int)leftValuee==0&&(int)rightValuee==35) {
        _customPriceInfo.text = @"不限";
         self.customPriceInfo.textColor = UIColorFromRGBValue(0x424242);
    }else if ((int)leftValuee!=0&&(int)rightValuee==35){
         self.customPriceInfo.textColor = UIColorFromRGBValue(0xff2626);
        _customPriceInfo.text = [NSString stringWithFormat:@"%d万以上",(int)leftValuee];
    }else if ((int)leftValuee==0&&(int)rightValuee!=35){
         self.customPriceInfo.textColor = UIColorFromRGBValue(0xff2626);
        _customPriceInfo.text = [NSString stringWithFormat:@"%d万以下",(int)rightValuee];
    }else if ((int)leftValuee!=0&&(int)rightValuee!=35){
         self.customPriceInfo.textColor = UIColorFromRGBValue(0xff2626);
        _customPriceInfo.text = [NSString stringWithFormat:@"%d~%d万",(int)leftValuee,(int)rightValuee];
    }
    
    
}
- (void)setRightValue:(CGFloat)newValue { //从右向左滑动  回调也是这个
    if (newValue > maxValuee)
        newValue = maxValuee;
    if (newValue  <= leftValuee + 1)
        newValue = leftValuee+1;
   [self setCustomText];
  //  _customPriceInfo.text = [NSString stringWithFormat:@"%d~%d万",(int)leftValuee,(int)rightValuee];
    NSString *stringFloat = [NSString stringWithFormat:@"%f",newValue];
    [self Va:stringFloat Label:_customPriceInfo is:YES and:newValue];
    rightValuee = newValue;
    [self setNeedsLayout];
    
}

- (void)Va:(NSString *)stringFloat Label:(UILabel *)price is:(BOOL)is and:(CGFloat)value
{
    if (maxValuee == 35) {
        [self maxValueLeft:stringFloat max:35 and:price boolYes:is and:value];
    }
}

- (void)maxValueLeft:(NSString *)stringFloat max:(CGFloat)max and:(UILabel *)LablePrice boolYes:(BOOL)isMax and:(CGFloat)leftNewValue
{
    if ((int)leftNewValue > max-1 && leftNewValue <= max) {
        if (isMax == YES) {
//            _LablePriceMax.hidden = YES;
          //  LablePrice.text = @"不限";
            if (self.delegate) {
                [self.delegate maxString:@"不限"];
            }
//            else if (self.belegate){
//                [self.belegate NSStringMax:@"不限"];
//            }
        }
    }
    else{
        if (isMax == YES) {
            if (self.delegate) {
                [self status:_RightStatus boo:YES label:LablePrice str:stringFloat type:2];
            }
//            else if (self.belegate){
//                [self status:_RightStatus boo:NO label:LablePrice str:stringFloat type:1];
//            }
        }else{
            if (self.delegate) {
                [self status:_LeftStatus boo:NO label:LablePrice str:stringFloat type:2];
               
                
            }
//            else if (self.belegate){
//                [self status:_LeftStatus boo:YES label:LablePrice str:stringFloat type:1];
//            }
        }
    }
}

- (void)status:(int)status boo:(BOOL)boo label:(UILabel *)label str:(NSString *)stringFloat type:(int)type
{
  //  label.text = [NSString stringWithFormat:@"%d",[stringFloat intValue]];
    if (status == _SliderStatusFailed) {
        if (type == 1) {
//            if (boo) {
//                [self.belegate NSStringStr2:label.text];//下
//            }else{
//                [self.belegate  NSStringMax:label.text];//下
//            }
        }else{
            if (boo) {
                [self.delegate maxString:[NSString stringWithFormat:@"%d",[stringFloat intValue]]]; //上
            }else{
                [self.delegate Nsstring:[NSString stringWithFormat:@"%d",[stringFloat intValue]]]; //上
            }
        }
    }
}

- (void)setCurrentProgressValue:(CGFloat)newValue
{
    if (newValue > maxValuee)
        newValue = maxValuee;
    
    if (newValue < minValuee)
        newValue = minValuee;
    
    currentProgressValuee = newValue;
    [self setNeedsLayout];
}

- (void)setMinValue:(CGFloat)newValue {
    minValuee = newValue;
    [self setNeedsLayout];
}

- (void)setMaxValue:(CGFloat)newValue {
    maxValuee = newValue;
    [self setNeedsLayout];
}

- (CGFloat)minValue {
    return minValuee;
}

- (CGFloat)maxValue {
    return maxValuee;
}

- (CGFloat)currentProgressValue {
    return currentProgressValuee;
}

- (CGFloat)leftValue {
    return leftValuee;
}

- (CGFloat)rightValue {
    return rightValuee;
}

- (void)handleLeftPan:(UIPanGestureRecognizer *)gesture {
 
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
          _LeftStatus = _SliderStatusBegan;
    }else if (gesture.state ==UIGestureRecognizerStateEnded) { 
        _LeftStatus = _SliderStatusFailed;        
    }
    CGPoint translation = [gesture translationInView:self];
    CGFloat range = maxValuee - minValuee;
    CGFloat availableWidth = self.frame.size.width - BJRANGESLIDER_THUMB_SIZE;
    self.leftValue += translation.x / availableWidth * range;
    [gesture setTranslation:CGPointZero inView:self];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
}

- (void)handleRightPan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
         _RightStatus = _SliderStatusBegan;
    }else if (gesture.state ==UIGestureRecognizerStateEnded) {
        _RightStatus = _SliderStatusFailed; // _LablePriceMax.hidden= YES;
    }
    CGPoint translation = [gesture translationInView:self];
    CGFloat range = maxValuee - minValuee;
    CGFloat availableWidth = self.frame.size.width - BJRANGESLIDER_THUMB_SIZE;
    self.rightValue += translation.x / availableWidth * range;
    [gesture setTranslation:CGPointZero inView:self];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setup {    
    leftValuee = minValuee;
    rightValuee = maxValuee;
    slider = [[UIView alloc]init]; //颜色条

    slider.layer.cornerRadius = 2.5;
    slider.backgroundColor = UIColorFromRGBValue(0xe0e0e0);
    slider.layer.masksToBounds = YES;
    slider.userInteractionEnabled = YES;
    UITapGestureRecognizer *slidetap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(slidertap:)];
    [slider addGestureRecognizer:slidetap];
    
    [self addSubview:slider];
    
    rangeImage = [[UIView alloc]init];
    rangeImage.backgroundColor = PRICE_STY_CORLOR;
      rangeImage.layer.cornerRadius = 2.5;
    [self addSubview:rangeImage];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handelSingleTap:)];
    
    [rangeImage addGestureRecognizer:singleTap];
    leftThumb = [[UIImageView alloc] init];
    UIImageView *left = [[UIImageView alloc]init];
    left.frame = CGRectMake(2.5, 2.5, 35, 35);

    left.image = [UIImage imageNamed:@"slider"];
//    _lablePriceMin = [[UILabel alloc]initWithFrame:CGRectMake(5, -20, 30, 20)];
//    _lablePriceMin.hidden = YES;
//    _lablePriceMin.font = [UIFont systemFontOfSize:13];
//    _lablePriceMin.textAlignment = NSTextAlignmentCenter;
//    _lablePriceMin.textColor =UIColorFromRGBValue(0xff2626);
//    _lablePriceMin.userInteractionEnabled = YES;
    leftThumb.userInteractionEnabled = YES;
    [leftThumb addSubview:left];
  //  [leftThumb addSubview:_lablePriceMin];
    [self addSubview:leftThumb];
    
    UIPanGestureRecognizer *leftPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftPan:)];
    [leftThumb addGestureRecognizer:leftPan];
    rightThumb = [[UIImageView alloc] init];
    UIImageView *right = [[UIImageView alloc]init];
    right.frame =  CGRectMake(2.5, 2.5, 35, 35);
    right.image = [UIImage imageNamed:@"slider"];
    rightThumb.userInteractionEnabled = YES;
    self.customPriceInfo = [[UILabel alloc]initWithFrame:CGRectMake(HCSCREEN_WIDTH*0.85-85,0, 70, 15)];
    self.customPriceInfo.userInteractionEnabled = YES;
    self.customPriceInfo.font = [UIFont systemFontOfSize:14];
    self.customPriceInfo.textAlignment = NSTextAlignmentRight;
    self.customPriceInfo.text =@"不限";
    self.customPriceInfo.hidden = NO;
    self.customPriceInfo.textColor = UIColorFromRGBValue(0xff2626);
    [self addSubview:self.customPriceInfo];
    [rightThumb addSubview:right];
    [self addSubview:rightThumb];
    UIPanGestureRecognizer *rightPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightPan:)];
    [rightThumb addGestureRecognizer:rightPan];
    
    CGFloat rangeWidth = (HCSCREEN_WIDTH*0.85-80);
    [self createtitleLabelWithX:30 text:@"0"];
    [self createtitleLabelWithX:30+rangeWidth/35*15 text:@"15"];
    [self createtitleLabelWithX:30+rangeWidth/35*30 text:@"30"];
    [self createtitleLabelWithX:30+rangeWidth text:@"不限"];
}
#pragma  mark //点击手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)slidertap:(UITapGestureRecognizer *)sliderTap{
    CGPoint point = [sliderTap locationInView:slider];
    CGFloat range = maxValuee - minValuee;
    CGFloat availableWidth = self.frame.size.width - BJRANGESLIDER_THUMB_SIZE;
    CGFloat DpointX = point.x / availableWidth * range;
    if (leftValuee-DpointX >DpointX-rightValuee) {
        leftValuee = point.x / availableWidth * range;
        [self setLeftValue:leftValuee];
        //NSLog(@"离左边近");
    }else{
        rightValuee = point.x / availableWidth * range;
        [self setRightValue:rightValuee];
        //NSLog(@"离右边近");
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self layoutSubviews];
}
-(void)handelSingleTap:(UITapGestureRecognizer*)gestureRecognizer{
    CGPoint point = [gestureRecognizer locationInView:slider];
    CGFloat range = maxValuee - minValuee;
    CGFloat availableWidth = self.frame.size.width - BJRANGESLIDER_THUMB_SIZE;
    CGFloat DpointX = point.x / availableWidth * range;
    if (DpointX-leftValuee >rightValuee-DpointX) {
        rightValuee = point.x / availableWidth * range;
        [self setRightValue:rightValuee];
       // NSLog(@"离右边近");
    }else{
        leftValuee = point.x / availableWidth * range;
        [self setLeftValue:leftValuee];
       // NSLog(@"离左边近");
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self layoutSubviews];
   // [self performSelector:@selector(singleTap:) withObject:nil afterDelay:0.2];
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    CGFloat availableWidth = self.frame.size.width - BJRANGESLIDER_THUMB_SIZE;
    CGFloat inset = BJRANGESLIDER_THUMB_SIZE / 2;
    CGFloat range = maxValuee - minValuee;
    CGFloat left = floorf((leftValuee - minValuee) / range * availableWidth);
    CGFloat right = floorf((rightValuee - minValuee) / range * availableWidth);
    if (isnan(left)) {
        left = 0;
    }
    if (isnan(right)) {
        right = 0;
    }
    
    slider.frame = CGRectMake(inset, self.frame.size.height / 2 - 5, availableWidth-1, 5);
   
    CGFloat rangeWidth = right - left;

    rangeImage.frame = CGRectMake(inset + left, self.frame.size.height / 2 - 5, rangeWidth, 5);

    leftThumb.center = CGPointMake(inset + left, self.frame.size.height );
    rightThumb.center = CGPointMake(inset + right, self.frame.size.height);

    leftThumb.frame = CGRectMake(rangeImage.left-inset/2, (self.height-inset)/2, inset, inset);
    rightThumb.frame = CGRectMake(rangeImage.right-inset/2, (self.height-inset)/2, inset,inset);
    
}
- (void)createtitleLabelWithX:(CGFloat)x text:(NSString*)text{
    UILabel *label = [[UILabel alloc]init];
    label.text = text;
    label.frame = CGRectMake(x, self.height-25, 22, 20);
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment =NSTextAlignmentCenter;
    label.textColor = UIColorFromRGBValue(0x9f9f9f);
    [self addSubview:label];
}

- (void)setDisplayMode
{
    [self setNeedsLayout];
}

@end
