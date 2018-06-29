//
//  HCNearCityCell.m
//  HCBuyerApp
//
//  Created by 张熙 on 16/2/23.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "HCNearCityCell.h"
@interface HCNearCityCell ()

@property (strong, nonatomic) UILabel *titlelabel;

@end
@implementation HCNearCityCell

- (instancetype)initWithNearCity{
    self = [super init];
    if (self) {
        
        UIImageView *cityicon = [[UIImageView alloc]init];
        cityicon.frame = CGRectMake(10, 10, HCSCREEN_WIDTH*0.21-20, HCSCREEN_WIDTH*0.21-20);
        cityicon.image = [UIImage imageNamed:@"nearcity"];
        [self addSubview:cityicon];
        self.titlelabel = [[UILabel alloc]init];
        self.titlelabel.text = @"附近城市[]符合您要求的车";
        self.titlelabel.frame = CGRectMake(cityicon.right+15, 10, HCSCREEN_WIDTH-20-cityicon.width, 30);
        self.titlelabel.textAlignment = NSTextAlignmentLeft;
        self.titlelabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.titlelabel];
        UILabel *bottomlabel = [[UILabel alloc]init];
        bottomlabel.text = @"全程一对一服务,异地购车简单便捷";
        bottomlabel.frame = CGRectMake(cityicon.right +15, cityicon.bottom-20, HCSCREEN_WIDTH-20-cityicon.width, 20);
        bottomlabel.font = [UIFont systemFontOfSize:15];
        bottomlabel.textColor =[UIColor colorWithRed:0.61f green:0.60f blue:0.61f alpha:1.00f];
        UIView *slashLine = [[UIView alloc] initWithFrame:CGRectMake(0,HCSCREEN_WIDTH*0.21, HCSCREEN_WIDTH, 5)];
        slashLine.backgroundColor = MTABLEBACK;
        [self addSubview:slashLine];
        [self addSubview:bottomlabel];
    }
    return self;
}
- (void)setnearcity:(Vehicle*)vehicle{
  //  vehicle.nearCity =nil;
    NSString *titletext = [NSString stringWithFormat:@"附近城市[%@]符合您要求的车",vehicle.nearCity];
    
    if (vehicle.nearCity==nil||vehicle.nearCity.length==0) {
        self.titlelabel.text =titletext;
    }else{
        self.titlelabel.attributedText = [self setcityText:titletext];
    }
    
    
    
 //   self.titlelabel.text = [NSString stringWithFormat:@"附近城市[%@]符合您要求的车",vehicle.nearCity];
}
- (NSMutableAttributedString*)setcityText:(NSString*)mStr{
    
    NSInteger length = mStr.length ;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:mStr];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
    [str addAttribute:NSForegroundColorAttributeName value:PRICE_STY_CORLOR  range:NSMakeRange(5, 2)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(7, length-7)];
    return str;
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
