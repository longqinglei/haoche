//
//  TDToastView.m
//  TDRealNameAuth-UI-Demo
//
//  Created by Robin on 7/18/16.
//  Copyright © 2016 TendCloud. All rights reserved.
//

#import "TDToastView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenCenter CGPointMake(kScreenWidth / 2, kScreenHeight / 2)

static CGFloat const kWidthExtra = 70;
static CGFloat const kHeightExtra = 30;
static CGFloat const kCornerRadius = 6;
static CGFloat const kDurationTime = 3;

typedef void (^TDToastViewFinishedBlock) (BOOL finished);
static TDToastView *_sharedToast;

@interface TDToastView ()

@property (nonatomic,weak) TDToastViewFinishedBlock finishedBlock;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) BOOL isToastStaying;

@end

@implementation TDToastView

#pragma mark - Life cycle

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

+ (instancetype)sharedInstance{
    if (!_sharedToast) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedToast = [[TDToastView alloc] init];
        });
    }
    return _sharedToast;
}


- (void)initialization{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.layer.cornerRadius = kCornerRadius;
    self.layer.masksToBounds = YES;
    
    [self creatLabel];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _label.frame = CGRectMake(0, 5, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 10);
}


#pragma mark - Set method

- (void)setText:(NSString *)text{
    CGRect textRect = [text boundingRectWithSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:nil context:nil];
    
    _label.text = text;
    
    if (textRect.size.width + kWidthExtra < kScreenWidth - 20) {
        _width = ceil(textRect.size.width + kWidthExtra );
    } else {
        _width = kScreenWidth - 20;
    }
    _height = ceil(textRect.size.height + kHeightExtra);
}


#pragma mark - Create UI

- (void)creatLabel{
    if (_label) {
        return;
    }
    _label = [[UILabel alloc] init];
    _label.backgroundColor = [UIColor clearColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor whiteColor];
    _label.numberOfLines = 0;
    
    [self addSubview:_label];
}

#pragma mark - Other method

- (void)appearToast{
    CABasicAnimation *appear = [CABasicAnimation animationWithKeyPath:@"opacity"];
    appear.fromValue = @(0);
    appear.toValue = @(1);
    appear.duration = 0.2;
    appear.removedOnCompletion = NO;
    appear.fillMode = kCAFillModeForwards;
    appear.delegate = self;
    
    [self.layer addAnimation:appear forKey:@"appear"];
}

#pragma mark - Target method

- (void)dismissToast{
    _isToastStaying = NO;
    
    CABasicAnimation *dismiss = [CABasicAnimation animationWithKeyPath:@"opacity"];
    dismiss.fromValue = @(1);
    dismiss.toValue = @(0);
    dismiss.duration = 0.3;
    dismiss.removedOnCompletion = NO;
    dismiss.fillMode = kCAFillModeForwards;
    dismiss.delegate = self;
    
    [self.layer addAnimation:dismiss forKey:@"dismiss"];
    
    if (self.finishedBlock) {
        self.finishedBlock(YES);
    }
}

#pragma mark - Animation delegate

- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag{
    if ([self.layer animationForKey:@"appear"] == anim) {
        [self.layer removeAnimationForKey:@"appear"];
        [self performSelector:@selector(dismissToast) withObject:nil afterDelay:kDurationTime inModes:@[NSRunLoopCommonModes]];
        _isToastStaying = YES;
    }else if ([self.layer animationForKey:@"dismiss"] == anim) {
        [self.layer removeAnimationForKey:@"dismiss"];
        [self removeFromSuperview];
        
        if (self.finishedBlock) {
            self.finishedBlock(YES);
        }
    }
}


+ (void)makeToastWithText:(NSString *)message completion:(void (^)(BOOL finished))completion{
    TDToastView *toast = [TDToastView sharedInstance];
    toast.text = message;
    toast.finishedBlock  = completion;
    toast.frame = CGRectMake(0, 0, toast.width, toast.height);
    CGPoint center = kScreenCenter;
    toast.center = center;
    [[UIApplication sharedApplication].keyWindow addSubview:toast];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:toast selector:@selector(dismissToast) object:nil];
    [toast.layer removeAnimationForKey:@"dismiss"];
    [toast.layer removeAnimationForKey:@"appear"];
    
    if (toast.isToastStaying) {
        [toast performSelector:@selector(dismissToast) withObject:nil afterDelay:kDurationTime inModes:@[NSRunLoopCommonModes]];
    } else {
        [toast appearToast];
    }
}

@end
