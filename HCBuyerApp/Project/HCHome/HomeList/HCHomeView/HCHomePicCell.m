//
//  HCHomePicCell.m
//  HCBuyerApp
//
//  Created by 龙青磊 on 2018/6/19.
//  Copyright © 2018年 haoche51. All rights reserved.
//

#import "HCHomePicCell.h"
#import "UIImageView+WebCache.h"

@interface HCHomePicCell ()

@property (nonatomic, strong) UIImageView *contentimg;

@end

@implementation HCHomePicCell

+ (instancetype)creatTableViewCellWithTableView:(UITableView *)tableView{
    HCHomePicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HCHomePicCell"];
    if (cell == nil) {
        cell = [[HCHomePicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HCHomePicCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews{
    
    self.contentimg = [[UIImageView alloc]init];
    self.contentimg.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:self.contentimg];
    [self.contentimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(Width(100));
    }];

}

- (void)setImgname:(NSString *)imgname{
    _imgname = imgname;
    if ([self.imgname containsString:@"http"]) {
        [self.contentimg sd_setImageWithURL:[NSURL URLWithString:self.imgname]];
    }else{
        self.contentimg.image = [UIImage imageNamed:self.imgname];
    }
    CGFloat height = [self getimageHeight];
    [self.contentimg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

- (CGFloat)getimageHeight{
    CGFloat height = 0;
    UIImage *image = [UIImage imageNamed:self.imgname];
    if ([self.imgname containsString:@"http"]) {
        [self.contentimg sd_setImageWithURL:[NSURL URLWithString:self.imgname]];
        image = self.contentimg.image;
    }else{
        image = [UIImage imageNamed:self.imgname];
    }
    CGFloat fixelW = CGImageGetWidth(image.CGImage);
    CGFloat fixelH = CGImageGetHeight(image.CGImage);
    height = fixelH * (kScreenWidth/fixelW);
    return height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
