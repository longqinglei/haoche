//
//  HCbangmaiCell.m
//  HCBuyerApp
//
//  Created by 张熙 on 16/2/24.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "HCbangmaiCell.h"
@interface HCbangmaiCell ()<UITextFieldDelegate>

@property (strong, nonatomic) UILabel *vehicleInfo;
@property (strong, nonatomic) UILabel *peoplelabel;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UITextField *phoneFiled;
@property (nonatomic)int numberType;
@property (strong, nonatomic)  UILabel *gusselike;
@property (strong, nonatomic)  UIView *redview;
@end
@implementation HCbangmaiCell


- (instancetype)initWithbangmai{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mClose) name:@"close" object:nil];
       
        
        UIImageView *bangmaiball = [[UIImageView alloc]init];
        bangmaiball.frame = CGRectMake(10, 17, HCSCREEN_WIDTH*0.05, HCSCREEN_WIDTH*0.04);
        bangmaiball.image = [UIImage imageNamed:@"bangmaiball"];
        [self addSubview:bangmaiball];
        UILabel *titlelabel = [self createlabelframe:CGRectMake(bangmaiball.right+5, 10, HCSCREEN_WIDTH-bangmaiball.width-30, 30) text:@"试试我们的帮买服务" font:[UIFont boldSystemFontOfSize:15] textColor:[UIColor blackColor]];
        UILabel *infoalbel = [self createlabelframe:CGRectMake(bangmaiball.right+5, titlelabel.bottom, HCSCREEN_WIDTH-bangmaiball.width-30, 30) text:@"24小时快速反馈,一对一帮你全城找车" font:[UIFont systemFontOfSize:14] textColor:[UIColor grayColor]];
        
        self.vehicleInfo = [self createlabelframe:CGRectMake(bangmaiball.left, infoalbel.bottom+10, HCSCREEN_WIDTH-20, 35) text:@"" font:[UIFont systemFontOfSize:14] textColor:PRICE_STY_CORLOR];
        self.vehicleInfo.layer.cornerRadius = 0.5;
        self.vehicleInfo.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.vehicleInfo.layer.borderWidth = 0.5;
        
        
        UIView *mVIew = [[UIView alloc]initWithFrame:CGRectMake(bangmaiball.left, self.vehicleInfo.bottom+10, self.vehicleInfo.width-HCSCREEN_WIDTH*0.38, self.vehicleInfo.height+5)];
        mVIew.layer.cornerRadius = 0.5;
        mVIew.layer.borderColor = [UIColor lightGrayColor].CGColor;
        mVIew.layer.borderWidth = 0.5;
        mVIew.userInteractionEnabled = YES;
      
        [self.contentView addSubview:mVIew];

        _phoneFiled = [[UITextField alloc]init];
        _phoneFiled.delegate = self;
        _phoneFiled.frame = CGRectMake(10, 0, mVIew.width-10,mVIew.height);
        _phoneFiled.placeholder = @"请输入手机号码";
        _phoneFiled.clearButtonMode = UITextFieldViewModeNever;
        _phoneFiled.font = [UIFont systemFontOfSize:15];
        _phoneFiled.delegate = self;
        
       // _phoneFiled.keyboardType = UIKeyboardTypePhonePad;
//        self.findBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.findBtn setTitle:@"帮我找车" forState:UIControlStateNormal];
//        [self.findBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        self.findBtn.backgroundColor = PRICE_STY_CORLOR;
//        self.findBtn.frame = CGRectMake(mVIew.right, self.vehicleInfo.bottom+10, self.vehicleInfo.width-mVIew.width, mVIew.height);
//        self.findBtn.titleLabel.font = [UIFont systemFontOfSize:14];
       self.findBtn = [UIButton buttonWithFrame:CGRectMake(mVIew.right, self.vehicleInfo.bottom+10, self.vehicleInfo.width-mVIew.width, mVIew.height) title:@"帮我找车" titleColor:[UIColor whiteColor] bgColor:PRICE_STY_CORLOR titleFont:[UIFont systemFontOfSize:14] image:nil selectImage:nil target:self action:@selector(bangmaiClick:) tag:0];
        
        [self addSubview:self.findBtn];
        [mVIew addSubview:_phoneFiled];
        
        self.peoplelabel = [self createlabelframe:CGRectMake(self.vehicleInfo.left, mVIew.bottom+15, HCSCREEN_WIDTH-20, 30) text:@"" font:[UIFont systemFontOfSize:14] textColor:[UIColor darkGrayColor]];
        [self addSubview:self.peoplelabel];
        CGFloat top = self.peoplelabel.bottom+10;
        [self createbottomicontop:top text:@"省事高效, 为您节省95%的搜选时间"];

        [self createbottomicontop:top+HCSCREEN_WIDTH*0.04+20 text:@"218项专业检测, 拒绝事故车"];
        
        UILabel *bottomLabel = [self createbottomicontop:top+HCSCREEN_WIDTH*0.04+20+HCSCREEN_WIDTH*0.04+20 text:@"14天可退车, 1年/2万公里放心质保"];
        self.gusselike = [[UILabel alloc]init];
        self.gusselike.text = @"猜你喜欢";
        self.gusselike.textAlignment = NSTextAlignmentLeft;
        self.gusselike.textColor = UIColorFromRGBValue(0x9d9d9d);
        self.gusselike.frame = CGRectMake(29, bottomLabel.bottom-4, HCSCREEN_WIDTH, HCSCREEN_WIDTH*0.14);
        [self addSubview:self.gusselike];
        self.redview = [[UIView alloc]init];
        self.redview.backgroundColor = PRICE_STY_CORLOR;
        self.redview.frame = CGRectMake(15,bottomLabel.bottom-4+(HCSCREEN_WIDTH*0.14-12)/2, 4, 12);
        self.redview.layer.cornerRadius = 2.0;
        UIView *slashLine = [[UIView alloc] initWithFrame:CGRectMake(0, 345, HCSCREEN_WIDTH, 5)];
        slashLine.backgroundColor = [UIColor colorWithRed:0.98f green:0.96f blue:0.96f alpha:1.00f];;
        [self addSubview:slashLine];
        [self addSubview:self.redview];
    }
    return self;
}
- (void)hideGusselike{
    self.gusselike.hidden = YES;
    self.redview.hidden = YES;
}

- (void)mClose
{
    [_phoneFiled resignFirstResponder];
}

- (void)setVehicleInfoLabeltext:(NSString *)vehicleInfo{
    self.vehicleInfo.text =[NSString stringWithFormat:@"  %@",vehicleInfo];
}

- (void)resetPeopleNum:(Vehicle*)vehicle{
    self.peoplelabel.text = [NSString stringWithFormat:@"%ld位用户选择帮买服务的理由",(long)vehicle.bangmaiCount];
}

- (UILabel*)createbottomicontop:(CGFloat)top text:(NSString*)text{
    UIImageView *icon = [[UIImageView alloc]init];
    icon.frame = CGRectMake(self.vehicleInfo.left, top, HCSCREEN_WIDTH*0.04, HCSCREEN_WIDTH*0.04);
    icon.image = [UIImage imageNamed:@"bangmai"];
    [self addSubview:icon];
    UILabel *label =  [self createlabelframe:CGRectMake(icon.right+5, icon.top-7, HCSCREEN_WIDTH-icon.width-20, 30) text:text font:[UIFont systemFontOfSize:13] textColor:[UIColor darkGrayColor]];
    [self addSubview:label];
    return label;
}

- (void)bangmaiClick:(UIButton*)btn{
    [_phoneFiled resignFirstResponder];
    NSString *phone = self.phoneFiled.text;
    NSString *regex = @"1[3-9][0-9]\\d{8}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES  %@", regex];
    BOOL isvalid = [predicate evaluateWithObject:phone];
    if (self.phoneFiled.text.length!=0&&isvalid==YES) {
        if (self.delegate) {
            [HCAnalysis HCUserClick:@"bangmaiClick"];
            [self.delegate delegatePhone:self.phoneFiled.text];
        }
        NSLog(@"电话号码正确");
    }else{
        [self.delegate delegatePhone:@"-1"];
        NSLog(@"电话号码错误");
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25f animations:^{
        //self.top -= 100;
        _numberType = 1;
        if (self.delegate) {
            [self.delegate mEditing:NO];
        }
           }];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25f animations:^{
       // self.top += 100;
        _numberType = 2;
        if (self.delegate) {
            [self.delegate mEditing:YES];
        }
  
    }];
    return YES;
}

- (UILabel*)createlabelframe:(CGRect)frame text:(NSString*)text font:(UIFont*)font textColor:(UIColor*)color{
    UILabel *label = [[UILabel alloc]init];
    label.frame = frame;
    label.font = font;
    label.textAlignment = NSTextAlignmentLeft;
    label.text = text;
    label.textColor = color;
    [self addSubview:label];
    return label;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
