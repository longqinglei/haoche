//
//  HCMySegmentView.h
//  HCBuyerApp
//
//  Created by 张熙 on 15/9/18.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HCSegIndexDelegate <NSObject>
@optional
-(void)barSelectedIndexChanged:(int)newIndex;
-(void)contentSelectedIndexChanged:(int)newIndex;
-(void)scrollOffsetChanged:(CGPoint)offset;
- (void)pushToTheFirstaView;
//2.6版本添加的
- (void)UINavigationBarAndTabBarHidden;

@end

@interface HCMySegmentView : UIScrollView

@property ( nonatomic,retain)  NSMutableArray *buttonArray;
@property (nonatomic,retain) NSMutableArray *titleArray;
-(id)initWithFrame:(CGRect)frame andItems:(NSMutableArray*)titleArray;
-(void)setLineOffsetWithPage:(float)page andRatio:(float)ratio;
-(void)selectIndex:(int)index;
@property(nonatomic,assign)int selectedIndex;
@property (nonatomic,retain)UIButton *currentBtn;
@property (nonatomic,assign)NSInteger curentTag;
@property(nonatomic,unsafe_unretained)id<HCSegIndexDelegate>clickDelegate;
@end

