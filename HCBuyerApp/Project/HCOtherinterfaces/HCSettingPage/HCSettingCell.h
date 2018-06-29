//
//  HCSettingCell.h
//  HCBuyerApp
//
//  Created by 张熙 on 15/11/25.
//  Copyright © 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCSettingCell : UITableViewCell
@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)UIImageView *leftimage;
@property(nonatomic,strong)UIImageView *rightImage;
- (id)initWithFrame:(CGRect)frame;
@end
