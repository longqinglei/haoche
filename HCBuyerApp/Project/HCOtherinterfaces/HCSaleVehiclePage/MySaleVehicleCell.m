//
//  MySaleVehicleCell.m
//  HCBuyerApp
//
//  Created by 张熙 on 15/11/11.
//  Copyright © 2015年 haoche51. All rights reserved.
//

#import "MySaleVehicleCell.h"

@implementation MySaleVehicleCell


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.selectImage = [[UIImageView alloc]init];
        self.selectImage.frame = CGRectMake(HCSCREEN_WIDTH-30, 13, 18, 18);
        self.selectImage.image = [UIImage imageNamed:@"ImageAddSeber"];
        [self.contentView addSubview:self.selectImage];
        
        self.labelTtext = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, HCSCREEN_WIDTH-self.selectImage.frame.size.width-30, self.contentView.frame.size.height)];
        [self.contentView addSubview:self.labelTtext];
    }
    
    return self;
}
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
