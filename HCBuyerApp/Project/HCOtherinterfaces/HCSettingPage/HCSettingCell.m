//
//  HCSettingCell.m
//  HCBuyerApp
//
//  Created by 张熙 on 15/11/25.
//  Copyright © 2015年 haoche51. All rights reserved.
//

#import "HCSettingCell.h"

@implementation HCSettingCell




- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _leftimage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 14.5, 15, 15)];
        [self.contentView addSubview:_leftimage];
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(_leftimage.right+10, 0, 100, self.height)];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textColor = UIColorFromRGBValue(0x424242);
        [self.contentView addSubview:_contentLabel];
//        _rightImage = [[UIImageView alloc]initWithFrame:CGRectMake(HCSCREEN_WIDTH-20, 10, 10, 24)];
//        
//        _rightImage.backgroundColor = [UIColor blueColor];
//        [self.contentView addSubview:_rightImage];
    }
    
    return self;
}
- (void)awakeFromNib {
    
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
