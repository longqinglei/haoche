//
//  MJRefreshBaseView.m
//  MJRefresh
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MJRefreshBaseView.h"
#import "MJRefreshConst.h"
#import "UIView+MJExtension.h"
#import "UIScrollView+MJExtension.h"
#import <objc/message.h>

@interface  MJRefreshBaseView()
{
    __weak UILabel *_statusLabel;
    __weak UIImageView *_arrowImage;
    __weak UIImageView *_activityView;
}
@end

@implementation MJRefreshBaseView



- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        UILabel *statusLabel = [[UILabel alloc] init];
        statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        statusLabel.font = [UIFont boldSystemFontOfSize:13];
        statusLabel.textColor = MJRefreshLabelTextColor;
        statusLabel.backgroundColor = [UIColor clearColor];
        statusLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_statusLabel = statusLabel];
    }
    return _statusLabel;
}


- (UIImageView *)arrowImage
{
    if (!_arrowImage) {
        UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MJRefreshSrcName(@"arroww.gif")]];
        arrowImage.height = HCSCREEN_WIDTH/10;
        arrowImage.width = HCSCREEN_WIDTH/4.3;
        [self addSubview:_arrowImage = arrowImage];
    }
    return _arrowImage;
}



- (NSArray *)arrayImageView
{
    NSArray *array = [NSArray arrayWithObjects:arroww1,arroww2,arroww3,arroww4,arroww5,arroww6, nil];
    return array;
}

- (UIImageView *)activityView
{
    if (!_activityView) {
        
        UIImageView* animatedImageView = [[UIImageView alloc] init];
        animatedImageView.bounds = self.arrowImage.bounds;
        animatedImageView.animationImages = [self arrayImageView];
        animatedImageView.animationDuration = 0.3f;
        animatedImageView.animationRepeatCount = 0;
        [self addSubview: _activityView = animatedImageView];
    }
    return _activityView;
}

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    frame.size.height = MJRefreshViewHeight;
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        self.state = MJRefreshStateNormal;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat arrowX = self.mj_width * 0.5 - 65;
    self.arrowImage.center = CGPointMake(arrowX, self.mj_height * 0.5+3);
    self.activityView.center = self.arrowImage.center;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    

    [self.superview removeObserver:self forKeyPath:MJRefreshContentOffset context:nil];
    if (newSuperview) {
        [newSuperview addObserver:self forKeyPath:MJRefreshContentOffset options:NSKeyValueObservingOptionNew context:nil];
        
        self.mj_width = newSuperview.mj_width;
        self.mj_x = 0;
        
        _scrollView = (UIScrollView *)newSuperview;
        _scrollViewOriginalInset = _scrollView.contentInset;
    }
}

- (void)drawRect:(CGRect)rect
{
    if (self.state == MJRefreshStateWillRefreshing) {
        self.state = MJRefreshStateRefreshing;
    }
}

- (BOOL)isRefreshing
{
    return MJRefreshStateRefreshing == self.state;
}

#pragma mark 开始刷新
- (void)beginRefreshing
{
    
    if (self.state == MJRefreshStateRefreshing) {
        if ([self.beginRefreshingTaget respondsToSelector:self.beginRefreshingAction]) {
            msgSend(msgTarget(self.beginRefreshingTaget), self.beginRefreshingAction, self);
        }
        
        if (self.beginRefreshingCallback) {
            self.beginRefreshingCallback();
        }
    } else {
        if (self.window) {
            self.state = MJRefreshStateRefreshing;
        } else {
            _state = MJRefreshStateWillRefreshing;
            [self setNeedsDisplay];
        }
    }
}

#pragma mark 结束刷新
- (void)endRefreshing
{
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.state = MJRefreshStateNormal;
    });
}

#pragma mark - 设置状态
- (void)setPullToRefreshText:(NSString *)pullToRefreshText
{
    _pullToRefreshText = [pullToRefreshText copy];
    [self settingLabelText];
}
- (void)setReleaseToRefreshText:(NSString *)releaseToRefreshText
{
    _releaseToRefreshText = [releaseToRefreshText copy];
    [self settingLabelText];
}
- (void)setRefreshingText:(NSString *)refreshingText
{
    _refreshingText = [refreshingText copy];
    [self settingLabelText];
}
- (void)settingLabelText
{
	switch (self.state) {
		case MJRefreshStateNormal:
            self.statusLabel.text = self.pullToRefreshText;
			break;
		case MJRefreshStatePulling:
            self.statusLabel.text = self.releaseToRefreshText;
			break;
        case MJRefreshStateRefreshing:
            self.statusLabel.text = self.refreshingText;
			break;
        default:
            break;
	}
}

- (void)setState:(MJRefreshState)state
{
    if (self.state != MJRefreshStateRefreshing) {
        _scrollViewOriginalInset = self.scrollView.contentInset;
    }
    
    if (self.state == state) return;
    
    MJRefreshState oldState = self.state;
    
    _state = state;
    switch (state) {
		case MJRefreshStateNormal:
        {
            if (oldState == MJRefreshStateRefreshing) {
                [UIView animateWithDuration:1.0  animations:^{
                   // self.activityView.alpha = 0.0;
                } completion:^(BOOL finished) {
                    // 停止转圈圈
                   // [self.activityView stopAnimating];
                    // 恢复alpha
                    //self.activityView.alpha = 1.0;
                }];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJRefreshSlowAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ // 等头部回去
                    // 再次设置回normal
//                    _state = MJRefreshStatePulling;
//                    self.state = MJRefreshStateNormal;
                    // 显示箭头
                    //self.arrowImage.hidden = NO;
                    // 停止转圈圈
                   // [self.activityView stopAnimating];
                    // 设置文字
                    [self settingLabelText];
                });
                // 直接返回
                return;
            } else {
                // 显示箭头
               // self.arrowImage.hidden = NO;
                // 停止转圈圈
                //[self.activityView stopAnimating];
            }
			break;
        }
            
        case MJRefreshStatePulling:
            break;
            
		case MJRefreshStateRefreshing:
        {
           
			[self.activityView startAnimating];
         
			self.arrowImage.hidden = YES;
            
            
            if ([self.beginRefreshingTaget respondsToSelector:self.beginRefreshingAction]) {
                msgSend(msgTarget(self.beginRefreshingTaget), self.beginRefreshingAction, self);
            }
            
            if (self.beginRefreshingCallback) {
                self.beginRefreshingCallback();
            }
			break;
        }
        default:
            break;
	}
    

    [self settingLabelText];
}
@end