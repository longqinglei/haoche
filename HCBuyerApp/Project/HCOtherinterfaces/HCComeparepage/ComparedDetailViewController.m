//
//  ComparedDetailViewController.m
//  HCBuyerApp
//
//  Created by wj on 15/7/15.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "ComparedDetailViewController.h"
#import "UIImage+RTTint.h"
#import "UIImageView+AFNetworking.h"
#import "TransactionApplyView.h"

#define ComparedDetail_Line_Text_Height_Padding 8

#define ComparedDetail_DetailLine_Text_Height_Padding 12

#define ComparedDetail_DetailLine_Text_Width_Padding 8


@interface ComparedDetailViewController ()<UIGestureRecognizerDelegate>
@property (strong, nonatomic) TransactionApplyView *curApplyview;
@property (strong, nonatomic) UIScrollView *mainScrollView;
@property (strong, nonatomic) UIView *bottomSubmitView;
@property (strong, nonatomic) VehicleDetail *lhVehicle;
@property (strong, nonatomic) VehicleDetail *rhVehicle;
@property (strong, nonatomic) UIView *coverImageView;
@property (strong, nonatomic) UIView *mainParamsView;
@property (strong, nonatomic) UIView *appraisalView;
@property (strong, nonatomic) UIView *reportView;
@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) UIView *briefView;
@property (nonatomic) CGRect applyViewRect;
@end

@implementation ComparedDetailViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self creatConsultBtn];
    [self creatBackButton];
    [self createMainScroView];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.curApplyview = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [HCAnalysis controllerBegin:@"compareDetailPage"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [HCAnalysis controllerEnd:@"compareDetailPage"];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)keyboardWasShown:(NSNotification *)aNotification
{
    if (self.curApplyview) {
        self.applyViewRect = self.curApplyview.frame;
        CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat yOffset = [self.curApplyview getYOffsetByKeyboardHeight: keyboardRect.size.height];
        if (yOffset > 0) {
            NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
            [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
            [UIView setAnimationDuration:animationDuration];
            self.curApplyview.frame = CGRectMake(0, self.curApplyview.top - yOffset, self.curApplyview.width, self.curApplyview.height);
            [UIView commitAnimations];
        }
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    if (self.curApplyview) {
        NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.curApplyview.frame = self.applyViewRect;
        [UIView commitAnimations];
    }
}

- (void)createMainScroView
{
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, HCSCREEN_HEIGHT - 64)];
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.briefView];
    [self.mainScrollView addSubview:self.titleView];
    [self.mainScrollView addSubview:self.reportView];
    [self.mainScrollView addSubview:self.appraisalView];
    [self.mainScrollView addSubview:self.coverImageView];
    [self.mainScrollView addSubview:self.mainParamsView];
    CGRect bottomViewRect = self.bottomSubmitView.frame;
    bottomViewRect.origin.y = HCSCREEN_HEIGHT - 64 - bottomViewRect.size.height;
    self.bottomSubmitView.frame = bottomViewRect;
    [self.view addSubview:self.bottomSubmitView];
    CGFloat scrollHeight = self.titleView.height + self.coverImageView.height + self.briefView.height + self.reportView.height + self.mainParamsView.height + self.appraisalView.height + bottomViewRect.size.height;
    [self.mainScrollView setContentSize:CGSizeMake(HCSCREEN_WIDTH, scrollHeight)];
    [self.mainScrollView setScrollEnabled:YES];
}

-(void)setComparedDataBetween:(VehicleDetail *)lhv and:(VehicleDetail *)rhv
{
    self.lhVehicle = lhv;
    self.rhVehicle = rhv;
    [self initTitleView:lhv.vehicleName rightLabel:rhv.vehicleName];
    NSArray *lImageSet = lhv.coverImageUrls;
    NSArray *rImageSet = rhv.coverImageUrls;
    NSMutableArray *lFixedImageSet = [[NSMutableArray alloc] init];
    NSMutableArray *rFixedImageSet = [[NSMutableArray alloc] init];
    for (NSString *url in lImageSet) {//更改过
        [lFixedImageSet addObject:[NSString getFixedSolutionImageAllurl:url w:340 h:254]];
    }
    for (NSString *url in rImageSet) {
        [rFixedImageSet addObject:[NSString getFixedSolutionImageAllurl:url w:340 h:254]];
    }
    [self initCoverImageView:lFixedImageSet rightImageset:rFixedImageSet];
    [self initBriefView:lhv and:rhv];
    [self initReportView:lhv and:rhv];
    [self initMainParamsView:lhv and:rhv];
    [self initAppraisalView:lhv and:rhv];
    [self initBottomSubmitViewleft:lhv right:rhv];
}

-(void)initTitleView:(NSString *)lLabel rightLabel:(NSString *)rLabel
{
    self.titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, 2 * ComparedDetail_Line_Text_Height_Padding + 40)];
    CGFloat widthPadding = 10;
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(widthPadding, ComparedDetail_Line_Text_Height_Padding, self.titleView.width / 2 - 2 * widthPadding, self.titleView.height)];
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleView.width / 2 + widthPadding, ComparedDetail_Line_Text_Height_Padding, self.titleView.width / 2 - 2 *widthPadding, self.titleView.height)];
    [leftLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    [rightLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    [leftLabel setNumberOfLines:0];
    [rightLabel setNumberOfLines:0];
    [leftLabel setText:lLabel];
    [rightLabel setText:rLabel];
    
    CGFloat leftLabelHeight = [self boundingRectWithSize:leftLabel.bounds.size forFont:leftLabel.font  text:leftLabel.text].height;
    CGFloat rightLabelHeight = [self boundingRectWithSize:rightLabel.bounds.size forFont:rightLabel.font  text:rightLabel.text].height;
    
    CGFloat maxHeight = MAX(leftLabelHeight, rightLabelHeight);
    CGRect rect = leftLabel.frame;
    rect.size.height = maxHeight;
    leftLabel.frame = rect;
    rect = rightLabel.frame;
    rect.size.height = maxHeight;
    rightLabel.frame = rect;
    
    maxHeight += 2 * ComparedDetail_Line_Text_Height_Padding;
    
    CGRect titleRect = self.titleView.frame;
    titleRect.size.height = maxHeight;
    self.titleView.frame = titleRect;
    
    UIView *seperatorLine = [[UIView alloc] initWithFrame:CGRectMake(self.titleView.width / 2, 0, 0.5, self.titleView.height)];
    [seperatorLine setBackgroundColor:ColorWithRGB(189, 189, 189)];
    [self.titleView addSubview:leftLabel];
    [self.titleView addSubview:rightLabel];
    [self.titleView addSubview:seperatorLine];
}

- (void)initCoverImageView:(NSArray *)lImageSet rightImageset:(NSArray *)rImageSet
{
    CGFloat imageWidth = (HCSCREEN_WIDTH - 1) / 2.0f;
    CGFloat imageHeight = imageWidth * 0.75f;
    
    self.coverImageView = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleView.top + self.titleView.height, HCSCREEN_WIDTH, 2 * imageHeight + 1)];
    
    UIImageView *ltImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWidth, imageHeight)];
    [ltImageView setImageWithURL:[NSURL URLWithString:[lImageSet HCObjectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"default_vehicle"]];
    UIImageView *rtImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageWidth + 1, 0, imageWidth, imageHeight)];
    [rtImageView setImageWithURL:[NSURL URLWithString:[rImageSet HCObjectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"default_vehicle"]];
    
    UIImageView *lbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, ltImageView.height + 1, imageWidth, imageHeight)];
    
    [lbImageView setImageWithURL:[NSURL URLWithString:[lImageSet HCObjectAtIndex:1]] placeholderImage:[UIImage imageNamed:@"default_vehicle"]];
    
    UIImageView *rbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageWidth + 1, ltImageView.height + 1, imageWidth, imageHeight)];
    
    [rbImageView setImageWithURL:[NSURL URLWithString:[rImageSet HCObjectAtIndex:1]] placeholderImage:[UIImage imageNamed:@"default_vehicle"]];
    
    UIImageView *tvs = [[UIImageView alloc] initWithFrame:CGRectMake(imageWidth * 0.9f, imageHeight / 2.0f - self.coverImageView.width * 0.05f, self.coverImageView.width * 0.1f, self.coverImageView.width * 0.1f)];
    [tvs setImage:[UIImage imageNamed:@"vs"]];
    
    UIImageView *bvs = [[UIImageView alloc] initWithFrame:CGRectMake(imageWidth * 0.9f, imageHeight / 2.0f - self.coverImageView.width * 0.05f + imageHeight + 1, self.coverImageView.width * 0.1f, self.coverImageView.width * 0.1f)];
    [bvs setImage:[UIImage imageNamed:@"vs"]];
    
    [self.coverImageView addSubview:ltImageView];
    [self.coverImageView addSubview:rtImageView];
    [self.coverImageView addSubview:lbImageView];
    [self.coverImageView addSubview:rbImageView];
    
    [self.coverImageView addSubview:tvs];
    [self.coverImageView addSubview:bvs];
}

- (NSString *)timestampeToString:(NSInteger)ts
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY年MM月"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:ts];
    return [formatter stringFromDate:date];
}

-(void)initBriefView:(VehicleDetail *)lhv and:(VehicleDetail *)rhv
{
    UILabel *briefTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, 30)];
    [briefTitleLable setText:@"概况"];
    [briefTitleLable setFont:[UIFont systemFontOfSize:15]];
    [briefTitleLable setTextAlignment:NSTextAlignmentCenter];
    
    CGFloat titleHeight = [self boundingRectWithSize:briefTitleLable.bounds.size forFont:briefTitleLable.font  text:briefTitleLable.text].height;
    CGRect titleRect = briefTitleLable.frame;
    titleRect.size.height = titleHeight + 20;
    briefTitleLable.frame = titleRect;
    
    //获取售价的view
    NSString *leftSoldPrice = [NSString stringWithFormat:@"¥ %.2f万", lhv.sellerPrice];
    NSString *rightSoldPrice = [NSString stringWithFormat:@"¥ %.2f万", rhv.sellerPrice];
    
    UIView *soldView = [self getGroupCompareViewForPriceText:leftSoldPrice subject:@"售价 " rightText:rightSoldPrice withColor:PRICE_STY_CORLOR needBold:YES];//ColorWithRGB(255, 112, 51)
    CGRect rect = soldView.frame;
    rect.origin.y = briefTitleLable.frame.origin.y + briefTitleLable.frame.size.height;
    soldView.frame = rect;
    
    //[soldView setBackgroundColor:[UIColor blackColor]];
    
    //获取新车指导价
    NSString *leftQuotedPrice = [NSString stringWithFormat:@"¥ %.2f万", lhv.quotedPrice];
    NSString *rightQuotedPrice = [NSString stringWithFormat:@"¥ %.2f万", rhv.quotedPrice];
    
    UIView *quotedView = [self getGroupCompareViewForPriceText:leftQuotedPrice subject:@"新车指导价" rightText:rightQuotedPrice withColor:ColorWithRGB(51, 51, 51) needBold:NO];
    rect = quotedView.frame;
    rect.origin.y = soldView.frame.origin.y + soldView.frame.size.height;
    quotedView.frame = rect;
    
    //获取二手车商价
    NSString *leftDealerPrice = [NSString stringWithFormat:@"¥ %.2f万", lhv.dealerPrice];
    NSString *rightDealerPrice = [NSString stringWithFormat:@"¥ %.2f万", rhv.dealerPrice];
    
    UIView *dealerPriceView = [self getGroupCompareViewForPriceText:leftDealerPrice subject:@"二手车商价" rightText:rightDealerPrice withColor:ColorWithRGB(51, 51, 51) needBold:NO];
    rect = dealerPriceView.frame;
    rect.origin.y = quotedView.top + quotedView.height;
    dealerPriceView.frame = rect;
    
    
    //公里数
    UIView *milesView = [self getGroupCompareViewForText:[NSString stringWithFormat:@"%.1f万公里", lhv.miles] subject:@"公里数" rightText:[NSString stringWithFormat:@"%.1f万公里", rhv.miles]];
    rect = milesView.frame;
    rect.origin.y = dealerPriceView.frame.origin.y + dealerPriceView.frame.size.height;
    milesView.frame = rect;
    
    //上牌时间
    NSString *ltime = [self timestampeToString:lhv.registerTime];
    NSString *rtime = [self timestampeToString:rhv.registerTime];
    UIView *registerTimeView = [self getGroupCompareViewForText:ltime subject:@"上牌时间" rightText:rtime];
    rect = registerTimeView.frame;
    rect.origin.y = milesView.frame.origin.y + milesView.frame.size.height;
    registerTimeView.frame = rect;
    
    //过户次数
    NSString *ltransferTime = [NSString stringWithFormat:@"%ld次", (long)lhv.transferTimes];
    NSString *rtransferTime = [NSString stringWithFormat:@"%ld次", (long)rhv.transferTimes];
    UIView *transferTimeView = [self getGroupCompareViewForText:ltransferTime subject:@"过户次数" rightText:rtransferTime];
    rect = transferTimeView.frame;
    rect.origin.y = registerTimeView.frame.origin.y + registerTimeView.frame.size.height;
    transferTimeView.frame = rect;
    //标准油耗
    NSString *lOilCost = [NSString stringWithFormat:@"%.1f", lhv.officalOilCost];
    NSString *rOilCost = [NSString stringWithFormat:@"%.1f", rhv.officalOilCost];
    UIView *oilCostView = [self getGroupCompareViewForText:lOilCost subject:@"标准油耗\nL/100km" rightText:rOilCost];
    rect = oilCostView.frame;
    rect.origin.y = transferTimeView.frame.origin.y + transferTimeView.frame.size.height;
    oilCostView.frame = rect;
    //[oilCostView setBackgroundColor:[UIColor blackColor]];
    
    rect = CGRectMake(0, self.coverImageView.top + self.coverImageView.height, HCSCREEN_WIDTH, briefTitleLable.height + soldView.height + quotedView.height + dealerPriceView.height + milesView.height + registerTimeView.height + transferTimeView.height + oilCostView.height);
    
    self.briefView = [[UIView alloc] initWithFrame:rect];
    [self.briefView addSubview:briefTitleLable];
    [self.briefView addSubview:soldView];
    [self.briefView addSubview:quotedView];
    [self.briefView addSubview:dealerPriceView];
    [self.briefView addSubview:milesView];
    [self.briefView addSubview:registerTimeView];
    [self.briefView addSubview:transferTimeView];
    [self.briefView addSubview:oilCostView];
}

- (void)initReportView:(VehicleDetail *)lhv and:(VehicleDetail *)rhv
{
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, 30)];
    [titleLable setText:@"车检报告"];
    [titleLable setFont:[UIFont systemFontOfSize:15]];
    [titleLable setTextAlignment:NSTextAlignmentCenter];
    
    CGFloat titleHeight = [self boundingRectWithSize:titleLable.bounds.size forFont:titleLable.font  text:titleLable.text].height;
    CGRect titleRect = titleLable.frame;
    titleRect.size.height = titleHeight + 20;
    titleLable.frame = titleRect;
    
    UIView *appearanceView = [self getGroupCompareViewForText:[NSString stringWithFormat:@"%.1f分", lhv.vehicleAppearanceScore] subject:@"外观" rightText:[NSString stringWithFormat:@"%.1f分", rhv.vehicleAppearanceScore]];
    CGRect rect = appearanceView.frame;
    rect.origin.y = titleLable.frame.origin.y + titleLable.frame.size.height;
    appearanceView.frame = rect;
    
    UIView *innerView = [self getGroupCompareViewForText:[NSString stringWithFormat:@"%.1f分", lhv.vehicleInteriorScore] subject:@"内饰" rightText:[NSString stringWithFormat:@"%.1f分", rhv.vehicleInteriorScore]];
    rect = innerView.frame;
    rect.origin.y = appearanceView.frame.origin.y + appearanceView.frame.size.height;
    innerView.frame = rect;
    
    UIView *equipmentView = [self getGroupCompareViewForText:[NSString stringWithFormat:@"%.1f分", lhv.vehicleEquipmentScore] subject:@"设备" rightText:[NSString stringWithFormat:@"%.1f分", rhv.vehicleEquipmentScore]];
    rect = equipmentView.frame;
    rect.origin.y = innerView.top + innerView.height;
    equipmentView.frame = rect;
    
    UIView *machineView = [self getGroupCompareViewForText:[NSString stringWithFormat:@"%.1f分", lhv.vehicleMachineScore] subject:@"机械" rightText:[NSString stringWithFormat:@"%.1f分", rhv.vehicleMachineScore]];
    rect = machineView.frame;
    rect.origin.y = equipmentView.top+ equipmentView.height;
    machineView.frame = rect;
    
    rect = CGRectMake(0, self.briefView.top + self.briefView.height, HCSCREEN_WIDTH, titleLable.height + appearanceView.height + innerView.height + equipmentView.height + machineView.height);
    self.reportView = [[UIView alloc] initWithFrame:rect];
    [self.reportView addSubview:titleLable];
    [self.reportView addSubview:appearanceView];
    [self.reportView addSubview:innerView];
    [self.reportView addSubview:equipmentView];
    [self.reportView addSubview:machineView];
    
    //[self.reportView setBackgroundColor:[UIColor redColor]];
}

- (void)initAppraisalView:(VehicleDetail *)lhv and:(VehicleDetail *)rhv
{
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, 30)];
    [titleLable setText:@"评价"];
    [titleLable setFont:[UIFont systemFontOfSize:15]];
    [titleLable setTextAlignment:NSTextAlignmentCenter];
    
    CGFloat titleHeight = [self boundingRectWithSize:titleLable.bounds.size forFont:titleLable.font  text:titleLable.text].height;
    CGRect titleRect = titleLable.frame;
    titleRect.size.height = titleHeight + 20;
    titleLable.frame = titleRect;

    UIView *sellerWordsView = [self getGroupCompareViewForText:lhv.sellerWords subject:@"车主说" rightText:rhv.sellerWords];
    CGRect rect = sellerWordsView.frame;
    rect.origin.y = titleLable.top + titleLable.height;
    sellerWordsView.frame = rect;
    
    UIView *checkerWordsView = [self getGroupCompareViewForText:lhv.checkerWords subject:@"评估师\n购车建议" rightText:rhv.checkerWords];
    rect = checkerWordsView.frame;
    rect.origin.y = sellerWordsView.top + sellerWordsView.height;
    checkerWordsView.frame = rect;
    
    rect = CGRectMake(0, self.mainParamsView.top + self.mainParamsView.height, HCSCREEN_WIDTH, titleLable.height + sellerWordsView.height + checkerWordsView.height);
    self.appraisalView = [[UIView alloc] initWithFrame:rect];
    [self.appraisalView addSubview:titleLable];
    [self.appraisalView addSubview:sellerWordsView];
    [self.appraisalView addSubview:checkerWordsView];
}

- (void)initMainParamsView:(VehicleDetail *)lhv and:(VehicleDetail *)rhv
{
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, 30)];
    [titleLable setText:@"主要参数"];
    [titleLable setFont:[UIFont systemFontOfSize:15]];
    [titleLable setTextAlignment:NSTextAlignmentCenter];
    
    CGFloat titleHeight = [self boundingRectWithSize:titleLable.bounds.size forFont:titleLable.font  text:titleLable.text].height;
    CGRect titleRect = titleLable.frame;
    titleRect.size.height = titleHeight + 20;
    titleLable.frame = titleRect;
    
    //车身结构
    UIView *structureView = [self getGroupCompareViewForText:lhv.structureAll subject:@"车身结构" rightText:rhv.structureAll];
    CGRect rect = structureView.frame;
    rect.origin.y = titleLable.top+ titleLable.height;
    structureView.frame = rect;
    
    //变速箱
    UIView *gearboxView = [self getGroupCompareViewForText:lhv.geerbox subject:@"变速箱" rightText:rhv.geerbox];
    rect = gearboxView.frame;
    rect.origin.y = structureView.top + structureView.height;
    gearboxView.frame = rect;
    
    //排放
    UIView *standardView = [self getGroupCompareViewForText:[lhv getEmissionStandarsToString] subject:@"排放" rightText:[rhv getEmissionStandarsToString]];
    rect = standardView.frame;
    rect.origin.y = gearboxView.top + gearboxView.height;
    standardView.frame = rect;
    
    //天窗
    UIView *roofWindowView = [self getGroupCompareViewForText:([lhv haveSkylight] ? @"有" : @"无") subject:@"天窗" rightText:([rhv haveSkylight] ? @"有" : @"无")];
    rect = roofWindowView.frame;
    rect.origin.y = standardView.top + standardView.height;
    roofWindowView.frame = rect;
    
    //座椅
    UIView *seatView = [self getGroupCompareViewForText:[lhv.leatherSeat isEqualToString:@"●"] ? @"是" : @"否" subject:@"真皮座椅" rightText:[rhv.leatherSeat isEqualToString:@"●"] ? @"是" : @"否"];
    rect = seatView.frame;
    rect.origin.y = roofWindowView.top + roofWindowView.height;
    seatView.frame = rect;
    
    //空调
    UIView *airConditionView = [self getGroupCompareViewForText:lhv.airConditioningMode subject:@"空调" rightText:rhv.airConditioningMode];
    rect = airConditionView.frame;
    rect.origin.y = seatView.frame.origin.y + seatView.frame.size.height;
    airConditionView.frame = rect;
    
    //长宽高
    UIView *lwhView = [self getGroupCompareViewForText:[NSString stringWithFormat:@"%@（mm）", lhv.lwh] subject:@"长宽高" rightText:[NSString stringWithFormat:@"%@（mm）", rhv.lwh]];
    rect = lwhView.frame;
    rect.origin.y = airConditionView.top+ airConditionView.height;
    lwhView.frame = rect;
    
    //发动机
    UIView *engineView = [self getGroupCompareViewForText:lhv.engine subject:@"发动机" rightText:rhv.engine];
    rect = engineView.frame;
    rect.origin.y = lwhView.frame.origin.y + lwhView.frame.size.height;
    engineView.frame = rect;
    
    //燃油
    UIView *fuelView = [self getGroupCompareViewForText:lhv.fuelLabel subject:@"燃油" rightText:rhv.fuelLabel];
    rect = fuelView.frame;
    rect.origin.y = engineView.top + engineView.height;
    fuelView.frame = rect;
    
    //最大马力
    UIView *horseView = [self getGroupCompareViewForText:[NSString stringWithFormat:@"%d（Ps）", (int)lhv.horsepower] subject:@"最大马力" rightText:[NSString stringWithFormat:@"%d（Ps）", (int)rhv.horsepower]];
    rect = horseView.frame;
    rect.origin.y = fuelView.frame.origin.y + fuelView.frame.size.height;
    horseView.frame = rect;
    
    //最大扭矩
    UIView *toqueView = [self getGroupCompareViewForText:[NSString stringWithFormat:@"%d（N*m）", (int)lhv.maxTorque] subject:@"最大扭矩" rightText:[NSString stringWithFormat:@"%d（N*m）", (int)rhv.maxTorque]];
    rect = toqueView.frame;
    rect.origin.y = horseView.frame.origin.y + horseView.frame.size.height;
    toqueView.frame = rect;
    
    //进气形式
    UIView *intakeFormView = [self getGroupCompareViewForText:lhv.intakeForm subject:@"进气形式" rightText:rhv.intakeForm];
    rect = intakeFormView.frame;
    rect.origin.y = toqueView.top + toqueView.height;
    intakeFormView.frame = rect;
    
    //汽缸数
    UIView *cylinderView = [self getGroupCompareViewForText:[NSString stringWithFormat:@"%d缸", (int)lhv.cylinderNum] subject:@"汽缸数" rightText:[NSString stringWithFormat:@"%d缸", (int)rhv.cylinderNum]];
    rect = cylinderView.frame;
    rect.origin.y = intakeFormView.top + intakeFormView.height;
    cylinderView.frame = rect;
    
    //驱动方式
    UIView *drivingModeView = [self getGroupCompareViewForText:lhv.drivingMode subject:@"进气形式" rightText:rhv.drivingMode];
    rect = drivingModeView.frame;
    rect.origin.y = cylinderView.top + cylinderView.height;
    drivingModeView.frame = rect;

    //轴距
    UIView *wheelBaseView = [self getGroupCompareViewForText:[NSString stringWithFormat:@"%d（mm）", (int)lhv.wheelBase] subject:@"轴距" rightText:[NSString stringWithFormat:@"%d（mm）", (int)rhv.wheelBase]];
    rect = wheelBaseView.frame;
    rect.origin.y = drivingModeView.top + drivingModeView.height;
    wheelBaseView.frame = rect;
    
    //前景架
    UIView *frontSuspensionView = [self getGroupCompareViewForText:lhv.frontSuspension subject:@"前景架" rightText:rhv.frontSuspension];
    rect = frontSuspensionView.frame;
    rect.origin.y = wheelBaseView.top + wheelBaseView.height;
    frontSuspensionView.frame = rect;
    
    rect = CGRectMake(0, self.reportView.top + self.reportView.height, HCSCREEN_WIDTH, titleLable.height + structureView.height + gearboxView.height + standardView.height + roofWindowView.height + seatView.height + airConditionView.height + lwhView.height + engineView.height + fuelView.height + horseView.height + toqueView.height + intakeFormView.height + cylinderView.height + drivingModeView.height + wheelBaseView.height + frontSuspensionView.height);
    
    self.mainParamsView = [[UIView alloc] initWithFrame:rect];
    [self.mainParamsView addSubview:titleLable];
    [self.mainParamsView addSubview:structureView];
    [self.mainParamsView addSubview:gearboxView];
    [self.mainParamsView addSubview:standardView];
    [self.mainParamsView addSubview:roofWindowView];
    [self.mainParamsView addSubview:seatView];
    [self.mainParamsView addSubview:airConditionView];
    [self.mainParamsView addSubview:lwhView];
    [self.mainParamsView addSubview:engineView];
    [self.mainParamsView addSubview:fuelView];
    [self.mainParamsView addSubview:horseView];
    [self.mainParamsView addSubview:toqueView];
    [self.mainParamsView addSubview:intakeFormView];
    [self.mainParamsView addSubview:cylinderView];
    [self.mainParamsView addSubview:drivingModeView];
    [self.mainParamsView addSubview:wheelBaseView];
    [self.mainParamsView addSubview:frontSuspensionView];
}

- (CGSize)boundingRectWithSize:(CGSize)size forFont:(UIFont *)font text:(NSString *)text
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    CGSize retSize = [text boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    return retSize;
}

-(UIView *)getGroupCompareViewForPriceText:(NSString *)leftText subject:(NSString *)subject rightText:(NSString *)rightText withColor:(UIColor *)color needBold:(BOOL)needBold
{
    CGFloat defaultHeight = 50;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, defaultHeight)];
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH * 0.375, defaultHeight)];
    
    [leftLabel setFont:[UIFont systemFontOfSize:12]];
    UILabel *midSubject = [[UILabel alloc] initWithFrame:CGRectMake(leftLabel.frame.origin.x + leftLabel.frame.size.width, 0, HCSCREEN_WIDTH * 0.25, defaultHeight)];
    [midSubject setFont:[UIFont systemFontOfSize:12]];
    [midSubject setTextColor:ColorWithRGB(51, 51, 51)];
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(midSubject.frame.origin.x + midSubject.frame.size.width, 0, HCSCREEN_WIDTH * 0.375, defaultHeight)];
    [rightLabel setFont:[UIFont systemFontOfSize:12]];
    
    [leftLabel setNumberOfLines:0];
    [midSubject setNumberOfLines:0];
    [rightLabel setNumberOfLines:0];
    
    [leftLabel setText:leftText];
    NSInteger priceLength = [leftText length] - 1;
    if (leftLabel.text==nil) {
        leftLabel.text=@"";
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:leftLabel.text];

    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 1)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(1, 1)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(priceLength, 1)];
 
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, 1)];
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(2, priceLength - 1)];
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(priceLength, 1)];
    leftLabel.attributedText = str;
    
    [midSubject setText:subject];
    
    [rightLabel setText:rightText];
    priceLength = [rightText length] - 1;
    if (rightLabel.text==nil) {
        rightLabel.text=@"";
    }
    str = [[NSMutableAttributedString alloc] initWithString:rightLabel.text];

    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 1)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(1, 1)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(priceLength, 1)];

    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, 1)];
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(2, priceLength - 1)];
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(priceLength, 1)];
    rightLabel.attributedText = str;
    
    [leftLabel setTextAlignment:NSTextAlignmentCenter];
    [midSubject setTextAlignment:NSTextAlignmentCenter];
    [rightLabel setTextAlignment:NSTextAlignmentCenter];
    
    CGFloat leftLabelHeight = [self boundingRectWithSize:CGSizeMake(leftLabel.bounds.size.width, CGFLOAT_MAX) forFont:leftLabel.font  text:leftText].height;
    CGFloat midLabelHeight = [self boundingRectWithSize:CGSizeMake(midSubject.bounds.size.width, CGFLOAT_MAX) forFont:midSubject.font  text:midSubject.text].height;
    CGFloat rightLabelHeight = [self boundingRectWithSize:CGSizeMake(rightLabel.bounds.size.width, CGFLOAT_MAX) forFont:rightLabel.font  text:rightLabel.text].height;
    
    CGFloat maxHeight = leftLabelHeight;
    if (maxHeight < midLabelHeight) {
        maxHeight = midLabelHeight;
    }
    if (maxHeight < rightLabelHeight) {
        maxHeight = rightLabelHeight;
    }
    
    [leftLabel setBackgroundColor:ColorWithRGB(245, 245, 245)];
    [midSubject setBackgroundColor:ColorWithRGB(224, 224, 224)];
    [rightLabel setBackgroundColor:ColorWithRGB(245, 245, 245)];
    
    maxHeight += 2 * ComparedDetail_DetailLine_Text_Height_Padding;
    
    CGRect rect = leftLabel.frame;
    rect.size.height = maxHeight;
    leftLabel.frame = rect;
    
    rect = midSubject.frame;
    rect.size.height = maxHeight;
    midSubject.frame = rect;
    
    rect = rightLabel.frame;
    rect.size.height = maxHeight;
    rightLabel.frame = rect;

    CGRect viewRect = view.frame;
    viewRect.size.height = maxHeight + 1;
    view.frame = viewRect;
    
    [view addSubview:leftLabel];
    [view addSubview:midSubject];
    [view addSubview:rightLabel];
    return view;
}

- (void)initBottomSubmitViewleft:(VehicleDetail*)leftVehicle right:(VehicleDetail*)rightVehicle
{
    CGFloat viewHeight = 50;
    CGRect rect = CGRectMake(0, 0, HCSCREEN_WIDTH, viewHeight);
    self.bottomSubmitView = [[UIView alloc] initWithFrame:rect];
    CGRect leftSubmiBtnRect = CGRectMake(10, 5, HCSCREEN_WIDTH * 0.3, viewHeight - 2 * 5);
    UIButton * leftBtn;
    if (leftVehicle.status !=3) {
        leftBtn =[UIButton buttonWithFrame:leftSubmiBtnRect title:@"已售出" titleColor:ColorWithRGB(255, 255, 255) titleHighlightColor:nil titleFont:[UIFont fontWithName:@"Helvetica-Bold" size:18] image:nil tappedImage:nil target:self action:@selector(clickLeftVehicleAppointment:)  tag:0];
        
        [leftBtn setBackgroundColor:[UIColor colorWithRed:0.88f green:0.88f blue:0.88f alpha:1.00f]];
        leftBtn.userInteractionEnabled = NO;
    }else{
        leftBtn =[UIButton buttonWithFrame:leftSubmiBtnRect title:@"预约看车" titleColor:ColorWithRGB(255, 255, 255) titleHighlightColor:nil titleFont:[UIFont fontWithName:@"Helvetica-Bold" size:18] image:nil tappedImage:nil target:self action:@selector(clickLeftVehicleAppointment:)  tag:0];
         [leftBtn setBackgroundColor:PRICE_STY_CORLOR];
    }
    [leftBtn.layer setCornerRadius:2.0f];
    CGRect rightSubmitBtnRect = CGRectMake(HCSCREEN_WIDTH - 10 - HCSCREEN_WIDTH * 0.3, 5, HCSCREEN_WIDTH * 0.3, viewHeight - 2 * 5);
    UIButton * rightBtn;
    if (rightVehicle.status !=3) {
        rightBtn =[UIButton buttonWithFrame:rightSubmitBtnRect title:@"已售出" titleColor:ColorWithRGB(255, 255, 255) titleHighlightColor:nil titleFont:[UIFont fontWithName:@"Helvetica-Bold" size:18] image:nil tappedImage:nil target:self action:@selector(clickRightVehicleAppointment:) tag:0];
        rightBtn.userInteractionEnabled = NO;
         [rightBtn setBackgroundColor:[UIColor colorWithRed:0.88f green:0.88f blue:0.88f alpha:1.00f]];
    }else{
        rightBtn =[UIButton buttonWithFrame:rightSubmitBtnRect title:@"预约看车" titleColor:ColorWithRGB(255, 255, 255) titleHighlightColor:nil titleFont:[UIFont fontWithName:@"Helvetica-Bold" size:18] image:nil tappedImage:nil target:self action:@selector(clickRightVehicleAppointment:) tag:0];
         [rightBtn setBackgroundColor:PRICE_STY_CORLOR];
    }
    [rightBtn.layer setCornerRadius:2.0f];
    UIImageView *leftBrandImg = [[UIImageView alloc] initWithFrame:CGRectMake(HCSCREEN_WIDTH / 2 - 12 - HCSCREEN_WIDTH * 0.1, viewHeight / 2.0f - HCSCREEN_WIDTH * 0.1 * 0.75 / 2, HCSCREEN_WIDTH * 0.1, HCSCREEN_WIDTH * 0.1 )];
    NSString *imageName = [NSString stringWithFormat:@"%ld", (long)self.lhVehicle.brandId];
    UIImage *brandImage = [UIImage imageNamed:imageName];
    if (brandImage == nil) {
        brandImage = [UIImage imageNamed:@"no_brand"];
    }
    [leftBrandImg setImage:brandImage];
    
    UIImageView *rightBrandImg = [[UIImageView alloc] initWithFrame:CGRectMake(HCSCREEN_WIDTH / 2 + 15, leftBrandImg.top, leftBrandImg.width, leftBrandImg.height)];
    imageName = [NSString stringWithFormat:@"%ld", (long)self.rhVehicle.brandId];
    brandImage = [UIImage imageNamed:imageName];
    if (brandImage == nil) {
        brandImage = [UIImage imageNamed:@"no_brand"];
    }
    [rightBrandImg setImage:brandImage];
    
    UIView *midSeperatorLine = [[UIView alloc] initWithFrame:CGRectMake(HCSCREEN_WIDTH / 2 - 0.5, 0, 1, viewHeight)];
    [midSeperatorLine setBackgroundColor:ColorWithRGB(224, 224, 224)];
    
    [self.bottomSubmitView addSubview:leftBtn];
    [self.bottomSubmitView addSubview:rightBtn];
    [self.bottomSubmitView addSubview:leftBrandImg];
    [self.bottomSubmitView addSubview:rightBrandImg];
    [self.bottomSubmitView addSubview:midSeperatorLine];
    
    [self.bottomSubmitView setBackgroundColor:[UIColor whiteColor]];
}

-(void)clickLeftVehicleAppointment:(id)sender
{
    [HCAnalysis HCUserClick:@"compardetali_orderphone_click"];
//    [TalkingDataAppCpa onCustEvent4];
    TransactionApplyView *view = [[TransactionApplyView alloc] initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, HCSCREEN_HEIGHT) forVehicleDetail:self.lhVehicle inSuperView:self.view];
    self.curApplyview = view;
    [view show];
}

-(void)clickRightVehicleAppointment:(id)sender
{
    [HCAnalysis HCUserClick:@"compardetali_orderphone_click"];
//    [TalkingDataAppCpa onCustEvent4];
    TransactionApplyView *view = [[TransactionApplyView alloc] initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, HCSCREEN_HEIGHT) forVehicleDetail:self.rhVehicle inSuperView:self.view];
    self.curApplyview = view;
    [view show];
}

-(UIView *)getGroupCompareViewForText:(NSString *)leftText subject:(NSString *)subject rightText:(NSString *)rightText
{
    CGFloat defaultHeight = 60;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, defaultHeight)];
    [view setBackgroundColor:ColorWithRGB(245, 245, 245)];
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(ComparedDetail_DetailLine_Text_Width_Padding, 0, HCSCREEN_WIDTH * 0.375 - ComparedDetail_DetailLine_Text_Width_Padding * 2, defaultHeight)];
    [leftLabel setBackgroundColor:ColorWithRGB(245, 245, 245)];
    
    [leftLabel setFont:[UIFont systemFontOfSize:12]];

    UILabel *midSubject = [[UILabel alloc] initWithFrame:CGRectMake(HCSCREEN_WIDTH * 0.375, 0, HCSCREEN_WIDTH * 0.25, defaultHeight)];
    [midSubject setBackgroundColor:ColorWithRGB(224, 224, 224)];
    [midSubject setFont:[UIFont systemFontOfSize:12]];
    [midSubject setTextColor:ColorWithRGB(51, 51, 51)];
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(midSubject.left + midSubject.width + ComparedDetail_DetailLine_Text_Width_Padding, 0, HCSCREEN_WIDTH * 0.375 - 2 * ComparedDetail_DetailLine_Text_Width_Padding, defaultHeight)];
    [rightLabel setBackgroundColor:ColorWithRGB(245, 245, 245)];
    [rightLabel setFont:[UIFont systemFontOfSize:12]];
    
    [leftLabel setNumberOfLines:0];
    [midSubject setNumberOfLines:0];
    [rightLabel setNumberOfLines:0];
    
    CGFloat leftLabelHeight = [self boundingRectWithSize:CGSizeMake(leftLabel.bounds.size.width, CGFLOAT_MAX) forFont:leftLabel.font  text:leftText].height;
    CGFloat midLabelHeight = [self boundingRectWithSize:CGSizeMake(midSubject.bounds.size.width, CGFLOAT_MAX) forFont:midSubject.font  text:subject].height;
    CGFloat rightLabelHeight = [self boundingRectWithSize:CGSizeMake(rightLabel.bounds.size.width, CGFLOAT_MAX) forFont:rightLabel.font  text:rightText].height;
    CGFloat maxHeight = leftLabelHeight;
    if (maxHeight < midLabelHeight) {
        maxHeight = midLabelHeight;
    }
    if (maxHeight < rightLabelHeight) {
        maxHeight = rightLabelHeight;
    }
    
    maxHeight += 2 * ComparedDetail_DetailLine_Text_Height_Padding;
    
    CGRect rect = leftLabel.frame;
    rect.size.height = maxHeight;
    leftLabel.frame = rect;
    
    rect = midSubject.frame;
    rect.size.height = maxHeight;
    midSubject.frame = rect;
    
    rect = rightLabel.frame;
    rect.size.height = maxHeight;
    rightLabel.frame = rect;
    
    [view addSubview:leftLabel];
    [view addSubview:midSubject];
    [view addSubview:rightLabel];
    [leftLabel setText:leftText];
    
    [midSubject setText:subject];
    [rightLabel setText:rightText];
    [leftLabel setTextAlignment:NSTextAlignmentCenter];
    [midSubject setTextAlignment:NSTextAlignmentCenter];
    [rightLabel setTextAlignment:NSTextAlignmentCenter];

    CGRect viewRect = view.frame;
    viewRect.size.height = maxHeight + 1;
    view.frame = viewRect;
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, viewRect.size.height - 1, viewRect.size.width, 1)];
    [bottomLine setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:bottomLine];
    
    return view;
}

-(UIView *)getGroupCompareViewForView:(UIView *)leftView subject:(NSString *)subject rightView:(UIView *)rightView
{
    CGFloat defaultHeight = 50;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, defaultHeight)];
    UIView *mleftView = [[UIView alloc] initWithFrame:CGRectMake(0, ComparedDetail_Line_Text_Height_Padding, HCSCREEN_WIDTH * 0.375, defaultHeight)];
    [mleftView setBackgroundColor:ColorWithRGB(245, 245, 245)];
    [mleftView addSubview:leftView];
    
    UILabel *midSubject = [[UILabel alloc] initWithFrame:CGRectMake(mleftView.left + mleftView.width, ComparedDetail_Line_Text_Height_Padding, HCSCREEN_WIDTH * 0.25, defaultHeight)];
    [midSubject setBackgroundColor:ColorWithRGB(224, 224, 224)];
    
    UIView *mrightView = [[UIView alloc] initWithFrame:CGRectMake(midSubject.left + midSubject.width, ComparedDetail_Line_Text_Height_Padding, HCSCREEN_WIDTH * 0.375, defaultHeight)];
    [mrightView addSubview:rightView];
    [mrightView setBackgroundColor:ColorWithRGB(245, 245, 245)];
    
    [midSubject setNumberOfLines:0];
    [midSubject setText:subject];

    [midSubject sizeToFit];
    [midSubject setTextAlignment:NSTextAlignmentCenter];
    
    CGFloat maxHeight = mleftView.frame.size.height;
    if (midSubject.frame.size.height > maxHeight) {
        maxHeight = midSubject.frame.size.height;
    }
    if (mrightView.frame.size.height > maxHeight) {
        maxHeight = mrightView.frame.size.height;
    }
    
    CGRect viewRect = view.frame;
    viewRect.size.height = 2 * ComparedDetail_Line_Text_Height_Padding + maxHeight + 1;
    view.frame = viewRect;
    
    [view addSubview:mleftView];
    [view addSubview:midSubject];
    [view addSubview:mrightView];
    return view;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
