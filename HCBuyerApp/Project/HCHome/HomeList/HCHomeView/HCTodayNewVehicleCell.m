//
//  HCTodayNewVehicleCell.m
//  HCBuyerApp
//
//  Created by 张熙 on 16/4/19.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "HCTodayNewVehicleCell.h"
@interface HCTodayNewVehicleCell()

@property (nonatomic,strong) UIView*topBackView;
@property (nonatomic,strong) UILabel*bottomBackLabel;
@property (nonatomic,strong) UILabel*updateTime;
@end
@implementation HCTodayNewVehicleCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.height =  HCSCREEN_WIDTH *0.13;
        [self createTopView];
    }
    return self;
}

- (id)initWithCellStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createBottomView];
        
    }
    return self;
}

- (UILabel *)createlinelabelWithY:(CGFloat)y
{
    UILabel *linelabel = [[UILabel alloc]init];
    linelabel.frame = CGRectMake(0, y, HCSCREEN_WIDTH,0.5);
    linelabel.backgroundColor = UIColorFromRGBValue(0xf5f5f5);
    return linelabel;
}

- (void)createTopView{
    self.topBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, HCSCREEN_WIDTH *0.13)];
    self.topBackView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.topBackView];
    [UILabel creat:self.topBackView title:@"买家分享"];
    UIButton *moreshare = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreshare setImage:[UIImage imageNamed:@"moreshare"] forState:UIControlStateNormal];
    [moreshare setTitle:@"更多分享" forState:UIControlStateNormal];
    moreshare.frame = CGRectMake(HCSCREEN_WIDTH-80, 20, 60, 16);
    [moreshare setTitleColor:UIColorFromRGBValue(0x9f9f9f) forState:UIControlStateNormal];
    moreshare.titleLabel.font = [UIFont systemFontOfSize:12];
    [moreshare horizontalCenterTitleAndImage:10];
    [moreshare addTarget: self action:@selector(moreshareClick) forControlEvents:UIControlEventTouchUpInside];
    [self.topBackView addSubview:moreshare];
    
}

- (void)moreshareClick{
    if (self.delegate) {
        [self.delegate clickMoreShare];
    }
}
- (void)reloadUpdateTime:(NSString*)time{
    
    _updateTime.text = time;
    
}

- (void)createBottomView{
    
    _bottomBackLabel = [UILabel labelWithFrame:CGRectMake(0,0, HCSCREEN_WIDTH, HCSCREEN_WIDTH *0.13) text:@"一 刷完了,一会再过来看看吧! 一" textColor:UIColorFromRGBValue(0x929292) font:[UIFont systemFontOfSize:12] tag:0 hasShadow:NO isCenter:YES];
    _bottomBackLabel.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_bottomBackLabel];
    if (self.isHaveLine == YES) {
        [_bottomBackLabel addSubview:[self createlinelabelWithY:3]];
    }
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
