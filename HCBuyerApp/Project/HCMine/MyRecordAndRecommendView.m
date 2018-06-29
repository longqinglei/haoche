//
//  MyRecordAndRecommendView.m
//  HCBuyerApp
//
//  Created by wj on 15/7/21.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "MyRecordAndRecommendView.h"
#import "BizCity.h"
#import "HCSettingCell.h"
#import "BizUserRecommendVehicle.h"
CGFloat labelHeight = 15;
CGFloat labelWidth = 20;


#import "VehicleDetailViewController.h"


@interface MyRecordAndRecommendView()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *mTableView;
@property (strong, nonatomic) NSMutableArray *cellContents;
@property (nonatomic,strong)CityElem *city;
@property (strong, nonatomic) UIButton *myNewLabelBtn;
@property (strong, nonatomic) UIButton *myCountLabelBtn;
@property (strong,nonatomic)UILabel *mySubscribe;
@property (strong,nonatomic)UILabel *myCollectPoint;
@property (strong,nonatomic)UILabel *myOrderPoint;
@property (nonatomic)NSInteger strCity;
@property (nonatomic)NSInteger number;
@property (nonatomic)NSInteger lowPn;
@property (nonatomic)NSInteger couponNum;
@property (nonatomic,strong)NSArray *plistArr;
@property (nonatomic,strong)NSArray *picArr;
@property (nonatomic,strong)NSArray *btnPicArr;
@property (nonatomic,strong)UIImageView *myNew;
@property (nonatomic,strong)UILabel *orderLabel;
@property (nonatomic,strong)UILabel *collectLabel;
@property (nonatomic,strong)UILabel *subLabel;
@property (nonatomic,strong)NSArray *numArr;
@end

@implementation MyRecordAndRecommendView

- (UIButton *)button:(UIButton *)btn
{
    btn = [[UIButton alloc]initWithFrame:CGRectMake(HCSCREEN_WIDTH - 60, (My_RecordAndRecommendView_Cell_Height - labelHeight) / 2, labelWidth+5, labelHeight)];
    btn.backgroundColor= PRICE_STY_CORLOR;
    btn.titleLabel.font = [UIFont systemFontOfSize: 10.0];
    [btn addTarget:self action:@selector(setSubscribe:) forControlEvents:UIControlEventTouchUpInside];
    [btn.layer setCornerRadius:7.5];
    [btn.layer setMasksToBounds:YES];
    return btn;
}

- (UILabel *)redpoint:(UILabel *)label type:(NSInteger)type
{
    label = [[UILabel alloc]init];
    label.backgroundColor = PRICE_STY_CORLOR;
    if (type == 0) {
        label.frame = CGRectMake(HCSCREEN_WIDTH/3-20, 10, 10, 10);
        [label.layer setCornerRadius:5];
        [label.layer setMasksToBounds:YES];
    }else{
        label.frame = CGRectMake(HCSCREEN_WIDTH/3-35, 7.5, labelWidth+5, labelHeight);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:10];
        [label.layer setCornerRadius:7.5];
        [label.layer setMasksToBounds:YES];
    }
    return label;
}

#pragma mark - BTN
- (void)setSubscribe:(UIButton*)selcnt
{
    NSLog(@"111");
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = MTABLEBACK;
        self.orderLabel = [UILabel labelWithFrame:CGRectMake(0, HCSCREEN_WIDTH*13/128-25, HCSCREEN_WIDTH/3, 23) text:@"0" textColor:PRICE_STY_CORLOR font:[UIFont systemFontOfSize:20] tag:0 hasShadow:NO isCenter:YES];
        self.collectLabel = [UILabel labelWithFrame:CGRectMake(0, HCSCREEN_WIDTH*13/128-25, HCSCREEN_WIDTH/3, 23) text:@"0" textColor:PRICE_STY_CORLOR font:[UIFont systemFontOfSize:20] tag:0 hasShadow:NO isCenter:YES];
        self.subLabel = [UILabel labelWithFrame:CGRectMake(0, HCSCREEN_WIDTH*13/128-25, HCSCREEN_WIDTH/3, 23) text:@"0" textColor:PRICE_STY_CORLOR font:[UIFont systemFontOfSize:20] tag:0 hasShadow:NO isCenter:YES];
        _numArr = [NSArray arrayWithObjects:self.orderLabel,self.collectLabel,self.subLabel, nil];
        _btnPicArr = [NSArray arrayWithObjects:@"orderpic",@"collectpic",@"subscribe", nil];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"MyControllerCellPlist" ofType:@"plist"];
        _plistArr = [NSArray arrayWithContentsOfFile:path];
        self.cellContents = [[NSMutableArray alloc] initWithArray:@[ @[[_plistArr HCObjectAtIndex:0], @-1],@[[_plistArr HCObjectAtIndex:1], @-1],@[[_plistArr HCObjectAtIndex:2], @-1]]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mSubcri:) name:@"subscri" object:nil];
        NSArray *titleArr =[NSArray arrayWithObjects:@"预定",@"收藏",@"上新提醒", nil];
        for (int i = 0 ; i<3; i++) {
            UILabel *linelabel = [[UILabel alloc]init];
            UILabel *wlinelabel = [[UILabel alloc]init];
            UIButton * button = [UIButton buttonWithFrame:CGRectMake(i*(HCSCREEN_WIDTH/3), 0, HCSCREEN_WIDTH/3, HCSCREEN_WIDTH*13/64) title:nil titleColor:UIColorFromRGBValue(0x424242)                                                                                          bgColor:[UIColor whiteColor] titleFont:[UIFont systemFontOfSize:12.0f] image:nil selectImage:nil target:self action:@selector(buttonClick:) tag:200+i];
            [button addSubview:[self createbuttonLabel:[titleArr HCObjectAtIndex:i]]];
            if ([[HCLogin standLog]isLog]) {
                 [button addSubview:[self.numArr HCObjectAtIndex:i]];
            }else{
                 [button addSubview:[self createbuttonimage:i]];
            }
            
//            if (i==1) {
//                if (![[NSUserDefaults standardUserDefaults]objectForKey:@"new"]) {
//                    _myNew = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
//                    _myNew.image = [UIImage imageNamed:@"newimage"];
//                    [button addSubview:_myNew];
//                }
//            }
            wlinelabel.frame = CGRectMake(0, button.height, button.width, 0.5);
            wlinelabel.backgroundColor = [UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
            linelabel.frame = CGRectMake(0, 0, 0.5, button.height);
            linelabel.backgroundColor = [UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
            [button addSubview:linelabel];
            [button addSubview:wlinelabel];
            [self addSubview:button];
        }
        
       
        self.picArr = [NSArray arrayWithObjects:@"coupons",@"Browshistory",@"setting", nil];
        self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, HCSCREEN_WIDTH*13/64+10, frame.size.width, [self.cellContents count] * My_RecordAndRecommendView_Cell_Height) style:UITableViewStylePlain];
        self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.mTableView.delegate = self;
        self.mTableView.dataSource = self;
        [self.mTableView setScrollEnabled:NO];
        [self addSubview:self.mTableView];
        self.myCollectPoint = [self redpoint:self.myCollectPoint type:0];
        self.myOrderPoint = [self redpoint:self.myOrderPoint type:0];
        self.myCountLabelBtn = [self button:self.myCountLabelBtn];
        self.mySubscribe = [self redpoint:self.mySubscribe type:1];
    }
    return self;
}
- (void)logout
{
    [self setSubscribe];
    [self setCollectRead];
    for (int i=0; i<3; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:200+i];
        [button addSubview:[self createbuttonimage:i]];
        [[self.numArr HCObjectAtIndex:i]removeFromSuperview];
    }
}

- (void)requestNumData
{
    [BizUserRecommendVehicle requestnumdata:^(NSDictionary * dic, NSInteger code) {
        if (code!=0) {
            
        }else{
            self.orderLabel.text = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"buyer_order_count"]intValue]];
            self.collectLabel.text =[NSString stringWithFormat:@"%d",[[dic objectForKey:@"collection_count"]intValue]] ;
            self.subLabel.text = [NSString stringWithFormat:@"%d",[[dic objectForKey:@"subscribe_count"]intValue]] ;
            if ([[dic objectForKey:@"subscribe_new_count"]integerValue]>0) {
                [self setSubscribeNew:[[dic objectForKey:@"subscribe_new_count"]integerValue]];
            }
            [self updateNum];
        }
    }];
    
    
}

- (void)updateNum
{
    for (int i=0; i<3; i++) {
        UIImageView *Bimage = (UIImageView*)[self viewWithTag:90+i];
        UIButton *button = (UIButton *)[self viewWithTag:200+i];
        if (Bimage) {
            [Bimage removeFromSuperview];
        }
        [button addSubview:[self.numArr HCObjectAtIndex:i]];
    }
}

- (UIImageView*)createbuttonimage:(int)tag
{
    UIImageView *Bimage = [[UIImageView alloc]init];
    Bimage.frame = CGRectMake((HCSCREEN_WIDTH/3 - 15)/2, HCSCREEN_WIDTH*13/128-17, 15, 15);
    Bimage.image = [UIImage imageNamed:[self.btnPicArr HCObjectAtIndex:tag]];
    Bimage.tag =90+tag;
    return Bimage;
}

- (UILabel *)createbuttonLabel:(NSString*)title
{
    UILabel *titlelabel = [[UILabel alloc]init];
    titlelabel.frame  =CGRectMake(0, HCSCREEN_WIDTH*13/128+5, HCSCREEN_WIDTH/3, 15);
    titlelabel.font = [UIFont systemFontOfSize:12];
    titlelabel.textColor = UIColorFromRGBValue(0x424242);
    titlelabel.text = title;
    titlelabel.textAlignment = NSTextAlignmentCenter;
    return titlelabel;
}

- (void)buttonClick:(UIButton *)btn
{
    if(btn.tag == 200){
        [self.delegate showMyScan];
    }else if(btn.tag == 201){
        [self setCollectRead];
        [self.delegate showColleciton];
        [[NSUserDefaults standardUserDefaults]setObject:@1 forKey:@"new"];
        //[_myNew removeFromSuperview];
    }else if (btn.tag == 202){
        
        [self.delegate showSubscribe];
        [self setSubscribe];
    }
}

- (void)mSubcri:(NSNotification *)notFity
{
    [self.mySubscribe removeFromSuperview];
}

- (void)setCollectNew
{
    UIButton *btn = (UIButton *)[self viewWithTag:201];
    [btn addSubview:self.myCollectPoint];
}

- (void)setCollectRead
{
    [self.myCollectPoint removeFromSuperview];
    
}

- (void)setSubscribeNew:(NSInteger)num
{
    if (num<=99) {
        self.mySubscribe.text = [NSString stringWithFormat:@"%ld",(long)num];
    }else{
        self.mySubscribe.text= @"...";
    }
   
    UIButton *btn = (UIButton *)[self viewWithTag:202];
    [btn addSubview:self.mySubscribe];
}

- (void)setSubscribe
{
    [self.mySubscribe removeFromSuperview];
}

- (void)setHaveSeenNew
{
    UIButton *btn = (UIButton *)[self viewWithTag:200];
    [btn addSubview:self.myOrderPoint];
}

- (void)setHaveSeen
{
    [self.myOrderPoint removeFromSuperview];
}
- (void)setCouponNew:(NSInteger)cnt
{
    if (cnt > 0) {
        _couponNum =cnt;
        [self.cellContents replaceObjectAtIndex:0 withObject:@[[_plistArr HCObjectAtIndex:0], @0]];
        [self.mTableView reloadData];
    }
}

- (void)setCouponReaded
{
    [self.cellContents replaceObjectAtIndex:0 withObject:@[[_plistArr HCObjectAtIndex:0], @-1]];
    [self.mTableView reloadData];
}

#pragma mark -- UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return My_RecordAndRecommendView_Cell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            if (self.delegate) {
                [self.delegate showMyCoupons];
            }
            break;
        case 1:
            if (self.delegate) {
                [self.delegate showAllRecord];
              
            }
            break;
        case 2:
            if (self.delegate) {
                  [self.delegate showSetting];
            }
             break;
        default:
            break;
    }
}

#pragma mark -- UITableView DataSource
- (UILabel *)createlinelabel:(CGFloat)y
{
    UILabel *linelabel = [[UILabel alloc]init];
    linelabel.frame = CGRectMake(0, y, HCSCREEN_WIDTH, 0.5);
    linelabel.backgroundColor = [UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
    return linelabel;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cellContents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier = @"cellIdentifier";
    HCSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
       
        cell = [[HCSettingCell alloc] initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, 44)];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    if (indexPath.row ==0) {
        [cell.contentView addSubview:[self createlinelabel:0]];
    }
    [cell.contentView addSubview:[self createlinelabel:43.5]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentLabel.text = [[self.cellContents HCObjectAtIndex:indexPath.row] HCObjectAtIndex:0];
    cell.leftimage.image = [UIImage imageNamed:[self.picArr HCObjectAtIndex:indexPath.row]];
    NSInteger tag = [[[self.cellContents HCObjectAtIndex:indexPath.row] HCObjectAtIndex:1] integerValue];
    if (tag >= 0) {
        if (indexPath.row == 0) {
            [cell addSubview:self.myCountLabelBtn];
            if (_couponNum>99) {
                [self.myCountLabelBtn setTitle:@"..." forState:UIControlStateNormal];
            }else{
                [self.myCountLabelBtn setTitle:[NSString stringWithFormat:@"%ld",(long)_couponNum] forState:UIControlStateNormal];
            }
        }
    }
    if (tag == -1)  {
         if(indexPath.row == 0 && self.myCountLabelBtn.superview == cell){
        
            [self.myCountLabelBtn removeFromSuperview];
        }
    }
    return  cell;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
