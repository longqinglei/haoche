//
//  HCBuyListCell.m
//  HCBuyerApp
//
//  Created by 龙青磊 on 2018/6/22.
//  Copyright © 2018年 haoche51. All rights reserved.
//

#import "HCBuyListCell.h"

@interface HCBuyListCell ()

@property (nonatomic, strong) UIImageView *carimg;//车图片
@property (nonatomic, strong) UIImageView *newimg;//新标签
@property (nonatomic, strong) UIImageView *dropimg;//降价图片
@property (nonatomic, strong) UILabel *dropLab;//降价视图
@property (nonatomic, strong) UILabel *titleLab;//标题视图
@property (nonatomic, strong) UILabel *brandLab;//上牌
@property (nonatomic, strong) UILabel *mileLab;//里程
@property (nonatomic, strong) UILabel *priceLab;//价格
@property (nonatomic, strong) UILabel *eventLab;//价格后面不确定的活动视图(原价 / 首付)
@property (nonatomic, strong) UILabel *storeLab;//店名
@property (nonatomic, strong) UIImageView *hotimg;//hot图片
@end

@implementation HCBuyListCell

+ (instancetype)creatTableViewCellWithTableView:(UITableView *)tableView{
    HCBuyListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HCBuyListCell"];
    if (cell == nil) {
        cell = [[HCBuyListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HCBuyListCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = RGB(240, 240, 240);
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
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-Width(5));
    }];
    
    self.carimg = [[UIImageView alloc]init];
    self.carimg.image = [UIImage imageNamed:@""];
    [self.contentView addSubview:self.carimg];
    [self.carimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(backView).offset(Width(15));
        make.width.mas_equalTo(kScreenWidth * 0.36);
        make.height.mas_equalTo(kScreenWidth * 0.27);
        make.bottom.equalTo(backView.mas_bottom).offset(-Width(15));
    }];
    
    self.newimg = [[UIImageView alloc]init];
    [self.contentView addSubview:self.newimg];
    [self.newimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.carimg);
        make.width.mas_equalTo(Width(22));
        make.height.mas_equalTo(Width(22));
    }];
    
    self.titleLab = [HCUI_L creatLabeWithText:@"" textColor:[UIColor darkGrayColor] backColor:nil textAlignment:0 textFont:14 numberOfLines:0];
    [self.contentView addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.carimg);
        make.left.equalTo(self.carimg.mas_right).offset(Width(10));
        make.right.equalTo(backView.mas_right).offset(-Width(15));
    }];
    
    self.brandLab = [HCUI_L creatLabeWithText:@"" textColor:[UIColor darkGrayColor] backColor:RGB(229, 229, 229) textAlignment:0 textFont:10 numberOfLines:1];
    self.brandLab.layer.cornerRadius = Width(7);
    self.brandLab.layer.masksToBounds = YES;
    [self.contentView addSubview:self.brandLab];
    [self.brandLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab);
        make.top.equalTo(self.titleLab.mas_bottom).offset(Width(10));
    }];
    
    self.mileLab = [HCUI_L creatLabeWithText:@"" textColor:[UIColor darkGrayColor] backColor:RGB(229, 229, 229) textAlignment:0 textFont:10 numberOfLines:1];
    self.mileLab.layer.cornerRadius = Width(7);
    self.mileLab.layer.masksToBounds = YES;
    [self.contentView addSubview:self.mileLab];
    [self.mileLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.brandLab.mas_right).offset(Width(5));
        make.centerY.equalTo(self.brandLab);
        make.height.mas_equalTo(Width(14));
    }];
    
    self.hotimg = [[UIImageView alloc]init];
    self.hotimg.image = [UIImage imageNamed:@"buy_hot"];
    [self addSubview:self.hotimg];
    [self.hotimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backView.mas_right).offset(-Width(15));
        make.centerY.equalTo(self.brandLab);
        make.width.height.mas_equalTo(Width(17));
    }];
    
    self.priceLab = [HCUI_L creatLabeWithText:@"" textColor:[UIColor redColor] backColor:nil textAlignment:0 textFont:15 numberOfLines:1];
    [self.contentView addSubview:self.priceLab];
    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLab);
        make.bottom.equalTo(self.carimg.mas_bottom);
    }];
    
    self.eventLab = [HCUI_L creatLabeWithText:@"" textColor:[UIColor redColor] backColor:nil textAlignment:0 textFont:13 numberOfLines:1];
    [self.contentView addSubview:self.eventLab];
    [self.eventLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLab.mas_right).offset(Width(10));
        make.bottom.equalTo(self.carimg.mas_bottom);
    }];
    
    self.storeLab = [HCUI_L creatLabeWithText:@"" textColor:[UIColor hex:@"666666"] backColor:nil textAlignment:0 textFont:12 numberOfLines:1];
    [self.contentView addSubview:self.storeLab];
    [self.storeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLab);
        make.bottom.equalTo(self.carimg.mas_bottom);
    }];
}

- (void)setVehicle:(Vehicle *)vehicle{
    _vehicle = vehicle;
    [self.carimg sd_setImageWithURL:[NSURL URLWithString:self.vehicle.cover_pic] placeholderImage:[UIImage imageNamed:@"default_vehicle"]];
    self.titleLab.text = vehicle.vehicle_name;
    if ([self.vehicle.vehicle_name hasPrefix:@"["]) {
        self.titleLab.text = [self getTitleName:self.vehicle.vehicle_name];
    }else{
        self.titleLab.text = self.vehicle.vehicle_name;
    }
    self.brandLab.text = [NSString stringWithFormat:@" %@上牌 ",self.vehicle.register_time];
    self.mileLab.text = [NSString stringWithFormat:@" %@万公里 ",self.vehicle.miles];
    self.priceLab.text = [NSString stringWithFormat:@"%@万",self.vehicle.seller_price];
    self.eventLab.text = [NSString stringWithFormat:@"首付%@",self.vehicle.shoufu_price];
    self.storeLab.text = self.vehicle.store_addr;
    if (vehicle.suitable==1) {
        self.hotimg.hidden = NO;
    }else{
        self.hotimg.hidden = YES;
    }
    [self.newimg sd_setImageWithURL:[NSURL URLWithString:self.vehicle.left_top]];
    
}

- (NSString *)getTitleName:(NSString *)name{
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@",name];
    NSRange range = [name rangeOfString:@"["];
    NSRange range2 = [name rangeOfString:@"]"];
    NSRange range3 = NSMakeRange(range.location, range2.location + range2.length);
    [str deleteCharactersInRange:range3];
    return [NSString stringWithFormat:@"%@",str];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
