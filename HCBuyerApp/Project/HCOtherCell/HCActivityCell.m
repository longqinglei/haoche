//
//  HCActivityCell.m
//  HCBuyerApp
//
//  Created by 张熙 on 16/1/19.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "HCActivityCell.h"
#import "Vehicle.h"
#import "UIImageView+WebCache.h"
@interface HCActivityCell()
@property (nonatomic,strong)UIImageView *huodongImage;
@end


@implementation HCActivityCell

- (id)initWithFrame:(CGRect)frame data:(Vehicle *)vehicle{
    self = [super init];
    if (self) {
        self.huodongImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, HCSCREEN_WIDTH/vehicle.pic_rate)];
        [self.huodongImage sd_setImageWithURL:[NSURL URLWithString:vehicle.image_url]placeholderImage:[UIImage imageNamed:@"default_vehicle"]];
        [self addSubview:self.huodongImage];
        UILabel *space = [[UILabel alloc]initWithFrame:CGRectMake(0, HCSCREEN_WIDTH/vehicle.pic_rate,  HCSCREEN_WIDTH, 5)];
        space.backgroundColor = MTABLEBACK;
        [self addSubview:space];
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
