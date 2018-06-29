//
//  HCBuyerApp
//
//  Created by haoche51 on 15/12/30.
//  Copyright © 2015年 haoche51. All rights reserved.
//

#import "HChomeFixedPictureCell.h"
#import "UIAlertView+ITTAdditions.h"
#import "UIView+ITTAdditions.h"


@interface HChomeFixedPictureCell ()

@property (nonatomic,strong)UILabel *labelfixed;
@property (nonatomic,strong)UILabel *labelVertical;
@property (nonatomic,strong)UIView *centerView;
@end

@implementation HChomeFixedPictureCell

#define Button_Height HCSCREEN_WIDTH*0.267/2     // 高
#define Button_Width (HCSCREEN_WIDTH-HCSCREEN_WIDTH*0.16)/2      // 宽
#define FuWuWidth HCSCREEN_WIDTH*0.16
#define LeftImageHeight  (HCSCREEN_WIDTH-40)*0.11  // 高
#define LeftImageWidth  (HCSCREEN_WIDTH-40)*0.131     // 宽
#define RightImageHeight  (HCSCREEN_WIDTH-40)*0.075  // 高
#define RightImageWidth  (HCSCREEN_WIDTH-40)*0.09     // 宽
#define StopWidth 20
#pragma mark - UIAlertViewDelegate

- (void)fuWudianji:(UIButton *)btn
{
    if (self.delegate) {
        [self.delegate ServiceGuarantee];
    }
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //[self createImageView];
         self.backgroundColor = [UIColor whiteColor];
        [self createViews];
        UIButton *coverbtn = [UIButton buttonWithFrame:CGRectMake(0, 0, self.centerView.width, self.centerView.height) title:nil titleColor:nil bgColor:[UIColor clearColor] titleFont:nil image:nil selectImage:nil target:self action:@selector(fuWudianji:) tag:0];
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, (HCSCREEN_WIDTH-40)*0.49+66, HCSCREEN_WIDTH, 10)];
        _label.backgroundColor = MTABLEBACK;
        [self addSubview:_label];
        [self.centerView addSubview:coverbtn];
    }
    return self;
}
- (void)createViews{
    UILabel *wuyouLabel = [[UILabel alloc]init];
    wuyouLabel.frame = CGRectMake(30, 20, 80, 16);
    wuyouLabel.text = @"无忧质保";
    UILabel *viewTile = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 4, 16)];
    viewTile.tag = 101;
    viewTile.layer.cornerRadius = 1.0f;
    viewTile.layer.masksToBounds = YES;
    viewTile.backgroundColor = PRICE_STY_CORLOR;
    [self addSubview:viewTile];
    wuyouLabel.textColor = UIColorFromRGBValue(0x424242);
    wuyouLabel.textAlignment = NSTextAlignmentLeft;
    wuyouLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:wuyouLabel];
    self.centerView = [[UIView alloc]init];
    self.centerView.frame = CGRectMake(20, viewTile.bottom+10, HCSCREEN_WIDTH-40, (HCSCREEN_WIDTH-40)*0.49);
    self.centerView.layer.masksToBounds = YES;
    [self.centerView.layer setBorderWidth:0.5];
    self.centerView.layer.borderColor =[UIColorFromRGBValue(0xff2626) CGColor];
    [self createCenterView];
    [self.centerView addSubview:[self crossLabel]];
    [self.centerView addSubview:[self verticalLabel]];
    [self createFourHorn:CGRectMake(0,0, 6, 6) withImage:@"lefthorn"];
    [self createFourHorn:CGRectMake(0,self.centerView.height-6, 6, 6) withImage:@"leftBottomHorn"];
    [self createFourHorn:CGRectMake(self.centerView.width-6,0, 6, 6) withImage:@"righthorn"];
    [self createFourHorn:CGRectMake(self.centerView.width-6,self.centerView.height-6, 6, 6) withImage:@"rightBottomHorn"];
    self.centerView.backgroundColor = MTABLEBACK;
    [self addSubview:self.centerView];
}

- (void)createFourHorn:(CGRect)frame withImage:(NSString*)imageName{
    UIImageView *horn = [[UIImageView alloc]init];
    horn.frame = frame;
    horn.image = [UIImage imageNamed:imageName];
    [self.centerView addSubview:horn];
}

- (void)resetBadVehicleNum:(NSString*)badVehicle{
    if ([badVehicle isEqualToString:@"00"]) {
        badVehicle = @"4万4660辆";
    }else{
        self.badVehicle.text = badVehicle;
    }
    self.badVehicle.attributedText = [NSString setCheckedVehicle:badVehicle];
  // [self.badVehicle setHeight:StopWidth];

}
- (void)createCenterView{
    UIImageView *bottomView = [[UIImageView alloc]init];
    bottomView.frame = CGRectMake(0, (self.centerView.height/3)*2, self.centerView.width, self.centerView.height/3);
    UIImage *image = [UIImage imageNamed:@"lineBG"];
    UIColor *backgroundColor = [UIColor colorWithPatternImage:image];
    bottomView.backgroundColor = backgroundColor;
    [self.centerView addSubview:bottomView];
    
    self.badVehicle = [[UILabel alloc]init];
    self.badVehicle.frame = CGRectMake(0, (self.centerView.height/3-40)/2, self.centerView.width/2, StopWidth);
    self.badVehicle.text = @"";
    //self.badVehicle.attributedText = [NSString setCheckedVehicle:@"1万4121辆"];
    self.badVehicle.textColor = UIColorFromRGBValue(0xff2626);
    self.badVehicle.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:self.badVehicle];
    UILabel *leftBottomLabel = [self createTextLabelWithFrame:CGRectMake(0, self.badVehicle.bottom, self.centerView.width/2, 20) Text:@"累计检测出事故车"];
    leftBottomLabel.textColor = UIColorFromRGBValue(0x9f9f9f);
    [bottomView addSubview:leftBottomLabel];
    [self resetBadVehicleNum:nil];
    
    UILabel *priceLabel = [[UILabel alloc]init];
    priceLabel.frame = CGRectMake(self.centerView.width/2, self.badVehicle.top, self.centerView.width/2, StopWidth);
    priceLabel.text = @"1000万";
   
    priceLabel.textAlignment = NSTextAlignmentCenter;
     priceLabel.attributedText = [NSString setFund:@"1000万"];
    [bottomView addSubview:priceLabel];
    UILabel *RBottomLabel = [self createTextLabelWithFrame:CGRectMake(self.centerView.width/2, leftBottomLabel.top, self.centerView.width/2, 20) Text:@"诚信保障基金池"];
    RBottomLabel.textColor = UIColorFromRGBValue(0x9f9f9f);
    [bottomView addSubview:RBottomLabel];

    
    UIImageView *leftImage = [self createImageView:CGRectMake((self.centerView.width/2-LeftImageWidth)/2, (self.centerView.height*2/3-24-LeftImageHeight)/2, LeftImageWidth, LeftImageHeight) imageName:@"jiance"];
    [self.centerView addSubview:leftImage];
    UILabel *leftLabel = [self createTextLabelWithFrame:CGRectMake(0, leftImage.bottom, self.centerView.width/2, 24) Text:@"218项专业检测"];
    [self.centerView addSubview:leftLabel];
    
    UIImageView *rightTop = [self createImageView:CGRectMake(self.centerView.width/2+20, (self.centerView.height/3-RightImageHeight)/2, RightImageWidth, RightImageHeight) imageName:@"peichang"];
    [self.centerView addSubview:rightTop];
    UILabel *rightTopLabel = [self createTextLabelWithFrame:CGRectMake(rightTop.right+10, rightTop.top, self.centerView.width/2-RightImageWidth-30, RightImageHeight) Text:@"1年2万公里质保"];
    rightTopLabel.textAlignment = NSTextAlignmentLeft;
    [self.centerView addSubview:rightTopLabel];
    
    UIImageView *rightBottom = [self createImageView:CGRectMake(self.centerView.width/2+20, (self.centerView.height/3-RightImageHeight)/2+self.centerView.height/3, RightImageWidth, RightImageHeight) imageName:@"zhibao"];
    [self.centerView addSubview:rightBottom];
    UILabel *rightBottomLabel = [self createTextLabelWithFrame:CGRectMake(rightBottom.right+10, rightBottom.top, self.centerView.width/2-RightImageWidth-30, RightImageHeight) Text:@"14天可退车"];
    rightBottomLabel.textAlignment = NSTextAlignmentLeft;
    [self.centerView addSubview:rightBottomLabel];
}

- (UILabel*)createTextLabelWithFrame:(CGRect)frame Text:(NSString*)text{
    UILabel *textLabel = [[UILabel alloc]init];
    textLabel.text =text;
    textLabel.frame = frame;
    textLabel.font = GetFontWithSize(12);
    textLabel.textColor = UIColorFromRGBValue(0x424242);
    textLabel.textAlignment = NSTextAlignmentCenter;
    return textLabel;
}
- (UIImageView *)createImageView:(CGRect)frame imageName:(NSString*)imagename{
    UIImageView *imageview = [[UIImageView alloc]init];
    imageview.image = [UIImage imageNamed:imagename];
    imageview.frame = frame;
    return imageview;
}
- (UILabel *)crossLabel{
    UILabel *crosslable = [[UILabel alloc]init];
    crosslable.frame = CGRectMake((self.centerView.width-2)/2, 0, 2, self.centerView.height);
    crosslable.backgroundColor = UIColorFromRGBValue(0xffffff);
    return crosslable;
}
- (UILabel *)verticalLabel{
    UILabel *crosslable = [[UILabel alloc]init];
    crosslable.frame = CGRectMake(self.centerView.width/2+11, self.centerView.height/3-1, self.centerView.width/2-20, 1);
    crosslable.backgroundColor = UIColorFromRGBValue(0xffffff);
    return crosslable;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
