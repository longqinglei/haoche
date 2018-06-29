//
//  InterlocutionView.m
//  HCBuyerApp
//
//  Created by haoche51 on 16/3/29.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "InterlocutionView.h"
#import "UIImage+ITTAdditions.h"
#import "UIImageView+WebCache.h"
@interface InterlocutionView()

@property (nonatomic,strong)UIView *mViewLocation;
@property (nonatomic,strong)UILabel *labelText;
@property (nonatomic,strong)UIView *mViewOne;
@property (nonatomic,strong)NSArray *arrayData;
@property (nonatomic,strong)NSMutableArray *arrayTitle;
@property (nonatomic,strong)UIView *mViewQue;
@property (nonatomic)NSInteger correct;
@property (nonatomic)NSInteger whichQue;
@property (nonatomic,strong)UIImageView *pageNum;
@property (nonatomic) BOOL isAnswer;
@end


@implementation InterlocutionView

- (id)initInterframeRec:(CGRect)frame dataArray:(NSArray *)array title:(NSString *)title b:(BOOL)b;
{
    self = [super initWithFrame:frame];
    if (self) {
        _isAnswer = NO;
        [self createMainView:array title:title b:b];
        _arrayData = array;
    }
    return self;
}

- (void)createMainView:(NSArray *)array title:(NSString *)title b:(BOOL)b
{

    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    toolbar.alpha = 0.98;
    toolbar.barStyle = UIBarStyleBlack;
    [self addSubview:toolbar];
    if (HCSCREEN_WIDTH==320) {
        _mInterlocutionView = [[UIView alloc]initWithFrame:CGRectMake(HCSCREEN_WIDTH/21, HCSCREEN_HEIGHT/6, HCSCREEN_WIDTH-HCSCREEN_WIDTH/21*2, HCSCREEN_WIDTH*1.1)];
    }else{
        _mInterlocutionView = [[UIView alloc]initWithFrame:CGRectMake(HCSCREEN_WIDTH/21, HCSCREEN_HEIGHT/4, HCSCREEN_WIDTH-HCSCREEN_WIDTH/21*2, HCSCREEN_WIDTH*0.98)];
    }
    _mInterlocutionView.backgroundColor = [UIColor whiteColor];
    _operationChartImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _mInterlocutionView.width, HCSCREEN_WIDTH*0.33)];
    _mInterlocutionView.layer.masksToBounds = YES;
    _mInterlocutionView.layer.cornerRadius = 6.0;
    _mInterlocutionView.userInteractionEnabled = YES;
    _operationChartImage.image = [UIImage imageNamed:@"interloction"];
    _pageNum = [[UIImageView alloc]init];
    _pageNum.frame = CGRectMake((_operationChartImage.width-HCSCREEN_WIDTH*0.1)/2, _operationChartImage.height-HCSCREEN_WIDTH*0.1, HCSCREEN_WIDTH*0.1, HCSCREEN_WIDTH*0.1);

    _pageNum.image = [UIImage imageNamed:@"firstimage"];
    [_operationChartImage addSubview:_pageNum];
    [self interloctionOneView:array and:0];
    
    _labelText = [[UILabel alloc]initWithFrame:CGRectMake(35, _operationChartImage.bottom+10, _operationChartImage.width-70, 40)];
    _labelText.numberOfLines =0;
    _labelText.textColor = UIColorFromRGBValue(0x212121);
    _labelText.textAlignment = NSTextAlignmentLeft;
    _labelText.text = [[array HCObjectAtIndex:0] objectForKey:@"question"];
    _labelText.font = [UIFont boldSystemFontOfSize:16];
    [_mInterlocutionView addSubview:_labelText];
    if (b == YES) {
      UIButton *button = [UIButton buttonWithFrame:CGRectMake((HCSCREEN_WIDTH-35)/2, _mInterlocutionView.bottom-20, 35, HCSCREEN_HEIGHT/7) title:@"" titleColor:nil bgColor:nil titleFont:nil image:[UIImage image:[UIImage imageNamed:@"closeImge"]rotation:UIImageOrientationDown] selectImage:nil target:self action:@selector(btnClose:) tag:0];
         [self addSubview:button];
    }
    [self addSubview:_mInterlocutionView];
    [_mInterlocutionView addSubview:_operationChartImage];
}

-(void)interloctionOneView:(NSArray *)array and:(int)y
{
    [_mViewLocation removeFromSuperview];
    self.whichQue = y;
    int space ;
    if (HCSCREEN_WIDTH==320)
    {
        space = 40 ;
    }else{
        space = 50;
    }
    _labelText.text = [[_arrayData HCObjectAtIndex:y] objectForKey:@"question"];
    if (y==0) {
        _pageNum.image = [UIImage imageNamed:@"firstimage"];
    }else{
        _pageNum.image = [UIImage imageNamed:@"second"];
        
    }
    _mViewLocation = [[UIView alloc]initWithFrame:CGRectMake(0, _operationChartImage.bottom+50, _mInterlocutionView.width, _mInterlocutionView.height-_operationChartImage.height-50)];
    NSDictionary *questionDic = [array HCObjectAtIndex:y];
    NSArray *answerArray = [questionDic objectForKey:@"option"];
    self.correct = [[questionDic objectForKey:@"option_correct"]integerValue];
    for (int i = 0; i<answerArray.count; i++) {
        UIButton *option = [UIButton buttonWithFrame:CGRectMake(40, 20+i*space, _operationChartImage.width-60, 30) title:[[[array HCObjectAtIndex:y] objectForKey:@"option"] HCObjectAtIndex:i] titleColor:UIColorFromRGBValue(0x212121) titleHighlightColor:[UIColor blackColor] titleFont:[UIFont systemFontOfSize:14] image:nil tappedImage:nil target:self action:@selector(btnclclick:) tag:100+i];
        option.titleLabel.numberOfLines = 0;
        [option.titleLabel sizeToFit];
        [option setHeight:option.titleLabel.height+5];
        [option setImage:[UIImage imageNamed:@"clickthepicture"] forState:UIControlStateNormal];
        option.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        option.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [option setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
        [option setImage:[UIImage imageNamed:@"ImageAddSeber"] forState:UIControlStateHighlighted];
        option.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_mViewLocation addSubview:option];
    }
    [_mInterlocutionView addSubview:_mViewLocation];
}

- (void)creatView:(NSString *)answerInfo WithStateColor:(UIColor *)color
{
    _mViewQue = [[UIView alloc]initWithFrame:CGRectMake(0, _operationChartImage.bottom+50, _mInterlocutionView.width, _mInterlocutionView.height-_operationChartImage.height-50)];
    _mViewQue.backgroundColor = [UIColor whiteColor];
    
    _arrayTitle = [[NSMutableArray array]init];
    [_arrayTitle addObject:answerInfo];
    [_arrayTitle addObject:[[_arrayData HCObjectAtIndex:self.whichQue] objectForKey:@"answer"]];
    int space ;
    if (HCSCREEN_WIDTH==320) {
        space = 40 ;
    }else{
        space = 50;
    }

     for (int i = 0; i<_arrayTitle.count; i++) {
         UILabel *labelTexte = [UILabel labelWithFrame:CGRectMake(40, 15+i*space, _operationChartImage.width-70, 60) text:[_arrayTitle HCObjectAtIndex:i] textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14] tag:200+i hasShadow:NO isCenter:NO];
         labelTexte.numberOfLines = 0;
         [labelTexte sizeToFit];
         labelTexte.frame = CGRectMake(labelTexte.left, labelTexte.top, labelTexte.width, labelTexte.height);
         if (i == 0) {
             labelTexte.textColor = color;
             labelTexte.font = [UIFont boldSystemFontOfSize:14];
         }else{
              labelTexte.textColor = UIColorFromRGBValue(0x929292);
         }
         [_mViewQue addSubview:labelTexte];
    }
    
    [_mInterlocutionView addSubview:_mViewQue];
    
    UIButton *mButton = [UIButton buttonWithFrame:CGRectMake((_mViewQue.width-250)/2, _mViewQue.height-_mViewQue.height/5-20, 250, _mViewQue.height/5) title:@"知道了" titleColor:[UIColor whiteColor] bgColor:UIColorFromRGBValue(0xff2626) titleFont:[UIFont systemFontOfSize:18] image:nil selectImage:nil target:self action:@selector(btn:) tag:1000];
    mButton.layer.cornerRadius = 5;
    [_mViewQue addSubview:mButton];
}

- (void)btnclclick:(UIButton *)btn
{
    _isAnswer = YES;
    [HCAnalysis HCclick:@"QuestionsVsAnswers" WithProperties:@{@"IsAnswer":@"true"}];
    [_mViewLocation removeFromSuperview];
    if (btn.tag -100 == self.correct) {
        [self creatView:@"恭喜您！答对了。" WithStateColor:UIColorFromRGBValue(0x43a047)];
    }else{
        [self creatView:@"哎呀！看来您了解得还不够透彻。"  WithStateColor:[UIColor redColor]];
    }
}

- (void)btn:(UIButton *)btn
{
    if (self.whichQue == 0) {
        [_mViewQue removeFromSuperview];
        [self interloctionOneView:_arrayData and:1];
    }else{
        [self removeFromSuperview];
    }

}

- (void)btnClose:(UIButton*)btn
{
    if (_isAnswer==NO) {
         [HCAnalysis HCclick:@"QuestionsVsAnswers" WithProperties:@{@"IsAnswer":@"false"}];
    }
    [self removeFromSuperview];
    [HCAnalysis HCUserClick:@"InterlocutionView_closeclick"];
}


@end
