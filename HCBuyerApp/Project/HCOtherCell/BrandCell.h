//
//  BrandCell.h
//  HCBuyerApp
//
//  Created by wj on 15/5/8.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandCell : UITableViewCell

- (id)initWithFrame:(CGRect)frame image:(NSInteger)imageId text:(NSString *)name needBottomLine:(BOOL)needBottomLine;

- (void)setDataWithImageId:(NSInteger)imageId text:(NSString *)name needBottomLine:(BOOL)needBottomLine;

@property (nonatomic) CGFloat arrowXPos;

- (void)setCellSelected:(BOOL)select;

@end
