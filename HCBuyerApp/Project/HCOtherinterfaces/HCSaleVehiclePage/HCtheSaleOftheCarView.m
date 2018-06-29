//
//  HCtheSaleOftheCarView.m
//  HCBuyerApp
//
//  Created by haoche51 on 15/11/10.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "HCtheSaleOftheCarView.h"
#import "OHAttributedLabel.h"
#import "UIAlertView+ITTAdditions.h"
#import "UIImageView+WebCache.h"
#import "BizSubmitTel.h"

@interface HCtheSaleOftheCarView()<OHAttributedLabelDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong)UIImageView *topImage;
@property (nonatomic,strong)UILabel *peopleNumLabel;
@property (nonatomic,strong)UILabel *representLabel;

@property (nonatomic,strong)UIButton *submitBtn;
@property (nonatomic,strong)OHAttributedLabel *bottomLabel;
@property (nonatomic,strong)UILabel *leftLabel;

@property (nonatomic,strong)UILabel *telLabel;
@property (nonatomic,strong)UILabel *mLabelstate;
@property (nonatomic,strong)UIView *mViewback;

@end

@implementation HCtheSaleOftheCarView


- (id)initWithFrame:(CGRect)frame peopleNum:(NSString *)sellNum coverImage:(NSString *)url phoneNum:(NSString *)phoneNum;
{
    self = [super initWithFrame:frame];
    if (self) {
       _mViewback = [[UIView alloc]initWithFrame:self.frame];
       _mViewback.backgroundColor =  [UIColor colorWithRed:0.15f green:0.15f blue:0.15f alpha:0.50f];
        [self addSubview:_mViewback];
        _mViewback.hidden = YES;
        [self createBottomLabel];
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}
- (void)reloadViewData:(NSString *)teleNum PeoNum:(NSString*)peoNum coverurl:(NSString*)cover{
    self.telephoneNum = teleNum;
    self.telLabel.text = self.telephoneNum;
    [self.topImage sd_setImageWithURL:[NSURL URLWithString:[NSString getFixedSolutionImageAllurl:cover w:HCSCREEN_WIDTH*2 h:self.topImage.height*2]] placeholderImage:[UIImage imageNamed:@"default_sale_vehicle"]];
    self.peopleNumLabel.text = peoNum;
}

- (void)createBottomLabel{
    
    self.topImage = [[UIImageView alloc]init];
    self.topImage.frame = CGRectMake(0, 0, HCSCREEN_WIDTH, self.height*0.36);
    [self addSubview:self.topImage];
    [self.topImage sd_setImageWithURL:[NSURL URLWithString:self.coverImageUrl] placeholderImage:[UIImage imageNamed:@"default_sale_vehicle"]];
    if (self.sellNum==nil) {
        self.sellNum =  @"19973";
    }
    self.peopleNumLabel = [UILabel labelWithFrame:CGRectMake(0, self.topImage.bottom, HCSCREEN_WIDTH, self.height*0.16) text:self.sellNum textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:34] tag:0 hasShadow:NO isCenter:YES];
    [self addSubview:self.peopleNumLabel];
    self.representLabel = [UILabel labelWithFrame:CGRectMake(0, self.peopleNumLabel.bottom-10, HCSCREEN_WIDTH, 13) text:@"位车主在好车无忧成功售出爱车" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:12] tag:0 hasShadow:NO isCenter:YES];
    if (iPhone4s) {
        [self.representLabel setTop:self.peopleNumLabel.bottom-5];
    }
    [self addSubview:self.representLabel];
    
    self.telTextFleld = [[UITextField alloc]init];
    self.telTextFleld.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.telTextFleld.layer setCornerRadius:3.0];
    [self.telTextFleld.layer setMasksToBounds:YES];
    [self.telTextFleld.layer setBorderWidth:0.5];
    self.telTextFleld.layer.borderColor =[[UIColor lightGrayColor] CGColor];
    self.telTextFleld.delegate = self;
    self.telTextFleld.keyboardType = UIKeyboardTypeNumberPad;
    self.telTextFleld.frame = CGRectMake(15, self.representLabel.bottom+self.height*0.06, HCSCREEN_WIDTH-30, self.height*0.11);
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.height*0.11)];
    self.telTextFleld.leftView = paddingView1;
    self.telTextFleld.leftViewMode = UITextFieldViewModeAlways;
    self.telTextFleld.placeholder = @" 请输入您的手机号码";
    [self addSubview:self.telTextFleld];
   
    _mLabelstate = [[UILabel alloc]initWithFrame:CGRectMake(15, self.telTextFleld.bottom, HCSCREEN_WIDTH-30, self.height*0.06)];
    _mLabelstate.font = [UIFont systemFontOfSize:13];
    _mLabelstate.textColor = [UIColor colorWithRed:0.86f green:0.00f blue:0.00f alpha:1.00f];
    [self addSubview:_mLabelstate];
    
    self.submitBtn = [UIButton buttonWithFrame:CGRectMake(15, self.telTextFleld.bottom+self.height*0.06, HCSCREEN_WIDTH-30, self.height*0.11) title:@"我要卖车" titleColor:[UIColor whiteColor] bgColor:PRICE_STY_CORLOR titleFont:[UIFont systemFontOfSize:17] image:nil selectImage:nil target:self action:@selector(submitClick) tag:0];
    self.submitBtn.layer.cornerRadius = 3;
    [self addSubview:self.submitBtn];
    self.bottomLabel = [[OHAttributedLabel alloc]init];
    self.bottomLabel.frame = CGRectMake(0, self.submitBtn.bottom+self.height*0.06, HCSCREEN_WIDTH, 30);
    self.leftLabel = [UILabel labelWithFrame:CGRectZero text:@"或直接咨询:" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:12] tag:0 hasShadow:0 isCenter:YES];
    
    [self.leftLabel sizeToFit];
     self.telLabel =  [UILabel labelWithFrame:CGRectZero text: @"000-000-0000" textColor:PRICE_STY_CORLOR font:[UIFont systemFontOfSize:12] tag:0 hasShadow:NO isCenter:YES];
    self.telLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *taptelLabel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(call:)];
    taptelLabel.delegate = self;
    [taptelLabel setNumberOfTapsRequired:1];
    [self.telLabel addGestureRecognizer:taptelLabel];
    [self.telLabel sizeToFit];
    self.telLabel.text = @"400-696-8390";
    
    self.leftLabel.frame = CGRectMake(0, 0, self.leftLabel.width, 22);
    self.telLabel.frame =CGRectMake(self.leftLabel.right, 0, self.telLabel.width, 22);
    if (iPhone4s) {
        [self.bottomLabel setTop:self.submitBtn.bottom];
    }
    [self.bottomLabel addSubview:self.leftLabel];
    [self.bottomLabel addSubview:self.telLabel];
    [self.leftLabel setLeft:(HCSCREEN_WIDTH-self.leftLabel.width-self.telLabel.width)/2];
    [self.telLabel setLeft:self.leftLabel.right];
 
   [self addSubview:self.bottomLabel];
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
     [self.telTextFleld resignFirstResponder];
}

- (void)call:(UITapGestureRecognizer*)tap{
    [HCAnalysis HCUserClick:@"VehicleSale_phone_click"];
    [UIAlertView popupAlertByDelegate:self title:self.telephoneNum  message:@"" cancel:@"取消" others:@"确定"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.telephoneNum ]]];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _mLabelstate.text = @"";
    if (iPhone4s) {
        [UIView animateWithDuration:0.25f animations:^{
            self.top -= 100;
        }];
    }else if (iPhone5){
        [UIView animateWithDuration:0.25f animations:^{
            self.top -= 70;
        }];
    }
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (iPhone4s) {
        [UIView animateWithDuration:0.25f animations:^{
            self.top += 100;
        }];
    }else if (iPhone5){
        [UIView animateWithDuration:0.25f animations:^{
            self.top += 70;
        }];
    }
    return YES;
}

- (void)submitClick{
     [HCAnalysis HCUserClick:@"vehicleSale_SubmitPhone_click"];
     [self.telTextFleld resignFirstResponder];
    if (self.telTextFleld.text ==nil||[self.telTextFleld.text isEqualToString:@""]) {
        _mLabelstate.text = @"请输入您的手机号！";
        return;
    }
    if ([self.telTextFleld.text length] != 11) {
        _mLabelstate.text = @"您输入的手机号格式有误！";
        return;
    }
   
    [BizSubmitTel submitTelWithphone:self.telTextFleld.text byFinish:^(NSDictionary *data, NSInteger code,NSString *errMsg) {
        if (code!=0) {
           _mLabelstate.text = errMsg;
        }else{
            if (self.delegate) {
            self.telTextFleld.text = @"";
                [self.delegate submitTelephoneNum:[data objectForKey:@"title"] and:[data objectForKey:@"description"]];
            }
        }
    }];
  
}


@end
