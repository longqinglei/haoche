//
//  HCHomeButtonCell.m
//  HCBuyerApp
//
//  Created by 龙青磊 on 2018/6/19.
//  Copyright © 2018年 haoche51. All rights reserved.
//

#import "HCHomeButtonCell.h"

@implementation HCHomeButtonCell

+ (instancetype)creatTableViewCellWithTableView:(UITableView *)tableView{
    HCHomeButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HCHomeButtonCell"];
    if (cell == nil) {
        cell = [[HCHomeButtonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HCHomeButtonCell"];
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
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyBtn setTitle:@"全 国 买 车" forState:UIControlStateNormal];
    buyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:27];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyBtn.backgroundColor = RGB(252, 42, 49);
    [buyBtn addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
    buyBtn.layer.cornerRadius = Width(2);
//    buyBtn.layer.masksToBounds = YES;
    buyBtn.layer.shadowOffset = CGSizeMake(0.2, 1);
    buyBtn.layer.shadowOpacity = 0.6;
    buyBtn.layer.shadowColor = RGB(252, 42, 49).CGColor;
    [self.contentView addSubview:buyBtn];
    [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(Width(10));
        make.left.equalTo(self.contentView).offset(Width(20));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-Width(25));
        make.right.equalTo(self.contentView.mas_right).offset(-Width(20));
        make.height.mas_equalTo(Width(55));
    }];
    
    UIImageView *img = [[UIImageView alloc]init];
    img.image= [UIImage imageNamed:@"home_buy"];
    img.userInteractionEnabled = YES;
    [self.contentView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(buyBtn.mas_bottom).offset(-Width(2));
        make.right.equalTo(buyBtn.mas_right).offset(-Width(2));
        make.width.height.mas_equalTo(Width(38));
    }];
}

- (void)buyAction{
    [HCAnalysis HCclick:@"HomeBuyBtn" WithProperties:@{@"BtnName":@"买车"}];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HomeBuyClick" object:nil];
    [self setObject:@"0" Forkey:@"select"];
    [self selectTabarTwo];
}

#pragma mark - 记录点击tabbar以及Delegate
- (void)setObject:(id)object Forkey:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults]setObject:object forKey:key];
}

//跳到买车界面
- (void)selectTabarTwo
{
    [self.viewController.tabBarController setSelectedIndex:1];
    [self setObject:@1 Forkey:@"selctcontroller"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
