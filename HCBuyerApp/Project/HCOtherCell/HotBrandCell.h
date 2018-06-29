//
//  HotBrandCell.h
//  HCBuyerApp
//
//  Created by wj on 15/5/8.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HCHotBrandCellTouchDelegate <NSObject>

@required
- (void)touchAtIndex:(NSInteger)index forIndexPath:(NSIndexPath *)cellIdx;

@end

@interface HotBrandCell : UITableViewCell

- (id)initWithFrame:(CGRect)frame data:(NSArray *)hotBrandInfo;

@property (nonatomic) NSInteger imgBtnXpos;
@property (nonatomic) NSInteger btnGap;

@property (assign, nonatomic) id<HCHotBrandCellTouchDelegate> delegate;

@end
