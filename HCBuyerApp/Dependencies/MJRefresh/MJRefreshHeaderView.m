//
//  MJRefreshHeaderView.m
//  MJRefresh
//
//  Created by mj on 13-2-26.
//  Copyright (c) 2013年 itcast. All rights reserved.
//  下拉刷新

#import "MJRefreshConst.h"
#import "MJRefreshHeaderView.h"
#import "UIView+MJExtension.h"
#import "UIScrollView+MJExtension.h"

@interface MJRefreshHeaderView()
@property (nonatomic, strong) NSDate *lastUpdateTime;
@property (nonatomic, weak) UILabel *lastUpdateTimeLabel;
@end

@implementation MJRefreshHeaderView
#pragma mark - 控件初始化

- (UILabel *)lastUpdateTimeLabel
{
    if (!_lastUpdateTimeLabel) {

        UILabel *lastUpdateTimeLabel = [[UILabel alloc] init];
        lastUpdateTimeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        lastUpdateTimeLabel.font = [UIFont boldSystemFontOfSize:12];
        lastUpdateTimeLabel.textColor = MJRefreshLabelTextColor;
        lastUpdateTimeLabel.backgroundColor = [UIColor clearColor];
        lastUpdateTimeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lastUpdateTimeLabel = lastUpdateTimeLabel];
        
        if(self.dateKey){
            self.lastUpdateTime = [[NSUserDefaults standardUserDefaults] objectForKey:self.dateKey];
        } else {
            self.lastUpdateTime = [[NSUserDefaults standardUserDefaults] objectForKey:MJRefreshHeaderTimeKey];
        }
    }
    return _lastUpdateTimeLabel;
}

+ (instancetype)header
{
    return [[MJRefreshHeaderView alloc] init];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.pullToRefreshText = MJRefreshHeaderPullToRefresh;
        self.releaseToRefreshText = MJRefreshHeaderReleaseToRefresh;
        self.refreshingText = MJRefreshHeaderRefreshing;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat statusX = 10;
    CGFloat statusY = 0;
    CGFloat statusHeight = self.mj_height * 0.5;
    CGFloat statusWidth = self.mj_width;
    self.statusLabel.frame = CGRectMake(statusX+10, statusY+10, statusWidth+20, statusHeight);
    

    CGFloat lastUpdateY = statusHeight;
   // CGFloat lastUpdateX = 10;
    CGFloat lastUpdateHeight = statusHeight;
    CGFloat lastUpdateWidth = statusWidth;
    self.lastUpdateTimeLabel.frame = CGRectMake(statusX+7, lastUpdateY-10+5, lastUpdateWidth+20, lastUpdateHeight);
  
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 设置自己的位置和尺寸
    self.mj_y = - self.mj_height;
}

#pragma mark - 状态相关
#pragma mark 设置最后的更新时间
- (void)setLastUpdateTime:(NSDate *)lastUpdateTime
{
    _lastUpdateTime = lastUpdateTime;
    
    // 1.归档
    if(self.dateKey){
        [[NSUserDefaults standardUserDefaults] setObject:lastUpdateTime forKey:self.dateKey];
    }   else{
        [[NSUserDefaults standardUserDefaults] setObject:lastUpdateTime forKey:MJRefreshHeaderTimeKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 2.更新时间
   [self updateTimeLabel];
}

#pragma mark 更新时间字符串
- (void)updateTimeLabel
{
    if (!self.lastUpdateTime) return;
    // 1.获得年月日
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
//    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:_lastUpdateTime];
//    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
//    
//    // 2.格式化日期
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    if ([cmp1 day] == [cmp2 day]) { // 今天
//        formatter.dateFormat = @"今天 HH:mm";
//    } else if ([cmp1 year] == [cmp2 year]) { // 今年
//        formatter.dateFormat = @"MM-dd HH:mm";
//    } else {
//        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
//    }
//    NSString *time = [formatter stringFromDate:self.lastUpdateTime];
//    
//    // 3.显示日期
//    self.lastUpdateTimeLabel.text = [NSString stringWithFormat:@"最后更新：%@", time];
      self.lastUpdateTimeLabel.text = @"购车更快捷";
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour |NSCalendarUnitMinute;
    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:_lastUpdateTime];
    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
    
    // 2.格式化日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([cmp1 day] == [cmp2 day]) { // 今天
        formatter.dateFormat = @"今天 HH:mm";
    } else if ([cmp1 year] == [cmp2 year]) { // 今年
        formatter.dateFormat = @"MM-dd HH:mm";
    } else {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    NSString *time = [formatter stringFromDate:self.lastUpdateTime];
    
    // 3.显示日期
    self.lastUpdateTimeLabel.text = [NSString stringWithFormat:@"最后更新：%@", time];
    self.lastUpdateTimeLabel.text = @"购车更快捷";
    self.lastUpdateTimeLabel.font = [UIFont boldSystemFontOfSize:11];
    
}

#pragma mark - 监听UIScrollView的contentOffset属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden) return;
    if (self.state == MJRefreshStateRefreshing) return;
    if ([MJRefreshContentOffset isEqualToString:keyPath]) {
        [self adjustStateWithContentOffset];
    }
}

/**
 *  调整状态
 */
- (void)adjustStateWithContentOffset
{
    CGFloat currentOffsetY = self.scrollView.mj_contentOffsetY;
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
    if (currentOffsetY >= happenOffsetY) return;
    if (self.scrollView.isDragging) {
        CGFloat normal2pullingOffsetY = happenOffsetY - self.mj_height;
        if (self.state == MJRefreshStateNormal && currentOffsetY < normal2pullingOffsetY) {
            self.state = MJRefreshStatePulling;
        } else if (self.state == MJRefreshStatePulling && currentOffsetY >= normal2pullingOffsetY) {
            self.state = MJRefreshStateNormal;
        }
    } else if (self.state == MJRefreshStatePulling) {

        self.state = MJRefreshStateRefreshing;
    }
}

#pragma mark 设置状态
- (void)setState:(MJRefreshState)state
{

    if (self.state == state) return;
    MJRefreshState oldState = self.state;
    [super setState:state];
	switch (state) {
		case MJRefreshStateNormal:
        {
            
            if (MJRefreshStateRefreshing == oldState) {
                self.arrowImage.transform = CGAffineTransformIdentity;
              
                self.lastUpdateTime = [NSDate date];
                
                [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{

                    self.scrollView.mj_contentInsetTop -= self.mj_height;
                }];
            } else {
               
                [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                    self.arrowImage.transform = CGAffineTransformIdentity;
                }];
            }
			break;
        }
            
		case MJRefreshStatePulling:
        {
            break;
        }
            
		case MJRefreshStateRefreshing:
        {
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                CGFloat top = self.scrollViewOriginalInset.top + self.mj_height;
                self.scrollView.mj_contentInsetTop = top;
                self.scrollView.mj_contentOffsetY = - top;
            }];
			break;
        }
            
        default:
            break;
	}
}
@end