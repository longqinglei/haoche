//
//  HCHomeForumCell.h
//  HCBuyerApp
//
//  Created by 张熙 on 16/5/30.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForumModel.h"
@interface HCHomeForumCell : UITableViewCell

@property (nonatomic,strong)UIImageView *forumImage;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *updateTime;
@property (nonatomic,strong)UIView *backView;
- (id)initWithFrame:(CGRect)frame WithForumData:(ForumModel*)forum;
- (void)setdataWithForumData:(ForumModel*)forum;
- (void)createBottom;
- (void)hideBottom;
- (void)showBottom;
@end
