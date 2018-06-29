//
//  HCPriceCell.m
//  HCBuyerApp
//
//  Created by 张熙 on 16/9/12.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "HCPriceCell.h"

@implementation HCPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectView = [[UIImageView alloc]initWithFrame:CGRectMake(HCSCREEN_WIDTH*0.85-29, 15, 14, 14)];
        self.selectView.image = [UIImage imageNamed:@"priceselect"];
        [self addSubview:self.selectView];
        self.selectView.hidden = YES;
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins:UIEdgeInsetsZero];
        }

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
