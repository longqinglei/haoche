//
//  BJRangeSliderWithProgress.h
//  BJRangeSliderWithProgress
//
//

#import <UIKit/UIKit.h>

#define BJRANGESLIDER_THUMB_SIZE 80.0
//@protocol BJRangeSliderWithProgressDelegate <NSObject>
//
//- (void)NSStringStr2:(NSString *)str;
//- (void)NSStringMax:(NSString *)str;
//
//
//@end

@protocol BJRangeSliderWithProgressDemoViewControllerDelegate <NSObject>

- (void)Nsstring:(NSString *)str;
- (void)maxString:(NSString *)str;
//- (void)stopScrollView:(BOOL)isStop;
@end

@interface BJRangeSliderWithProgress : UIControl
{
//
    UIView *slider;
    UIImageView *progressImage;
    UIView *rangeImage;
//    
    UIImageView *leftThumb;
    UIImageView *rightThumb;
//
    CGFloat minValuee;
    CGFloat maxValuee;
    CGFloat currentProgressValuee;
    
    CGFloat leftValuee;
    CGFloat rightValuee;
}

@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) CGFloat maxValue;
@property (nonatomic, assign) CGFloat currentProgressValue;
@property (nonatomic, strong) UILabel *customPriceInfo;
@property (nonatomic, assign) CGFloat leftValue;
@property (nonatomic, assign) CGFloat rightValue;

@property (nonatomic,assign)id <BJRangeSliderWithProgressDemoViewControllerDelegate> delegate;
//@property (nonatomic,assign)id <BJRangeSliderWithProgressDelegate> belegate;
//@property (nonatomic,strong)UILabel *lablePriceMin;
//@property (nonatomic,strong)UILabel *LablePriceMax;

@property (nonatomic)SliderStatus *mSliderStatus;

@property (nonatomic)int LeftStatus;
@property (nonatomic)int RightStatus;

- (void)setDisplayMode;

@end
