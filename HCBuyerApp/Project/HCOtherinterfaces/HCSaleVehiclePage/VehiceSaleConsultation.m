//
//  VehiceSaleConsultation.m
//  HCBuyerApp
//
//  Created by haoche51 on 15/11/6.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "VehiceSaleConsultation.h"
#import "UIButton+ITTAdditions.h"
#import "VehiceSaleConsultationCell.h"
#import "MySaleVehicles.h"
#import "UIAlertView+ITTAdditions.h"

@interface VehiceSaleConsultation()<UITableViewDataSource,UITableViewDelegate>
{
     UIView   * _lineView;
}
@property (strong, nonatomic) NSArray *arrayPriceData;
@property (strong,nonatomic)UITableView *mTableView;
@property (strong,nonatomic)UIView *mainView;
@property (nonatomic,strong)UILabel *offlineLabel ;
@property (nonatomic,strong) UIView *mViewfooter ;
@property (nonatomic,strong)UIView *noView;
@property (nonatomic,strong)NSString *strPhone;
@property (nonatomic,strong)UILabel *numlabel;
@end


@implementation VehiceSaleConsultation


- (id) initWithFrame:(CGRect)frame andSatus:(NSInteger)status MySaleVehicles:(MySaleVehicles*)mySaleVehicel
{
    self = [super initWithFrame:frame];
    if (self) {
        _arrayPriceData = mySaleVehicel.buyer_list;
        if (_arrayPriceData.count ==0) {
            [self initView:NO MySaleVehicles:mySaleVehicel];
        }else{
            [self initView:YES MySaleVehicles:mySaleVehicel];
        }
        
    }
    return self;
}

- (void)initView:(BOOL)show MySaleVehicles:(MySaleVehicles*)mySaleVehicel
{
    _mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, HCSCREEN_WIDTH)];
    /**
     ****************************
     */
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 30, 0.5, 3000)];
    _lineView.backgroundColor = PRICE_STY_CORLOR;
    _lineView.alpha = 0.5f;
  
    UIView *mViewPartition = [self viewLone:CGRectMake(0, 0, HCSCREEN_WIDTH, 10) andColor:[UIColor colorWithRed:0.96f green:0.95f blue:0.96f alpha:1.00f]];
    [_mainView addSubview:mViewPartition];
    
    UIView *mViewhear = [[UIView alloc]initWithFrame:CGRectMake(0, mViewPartition.bottom, HCSCREEN_WIDTH, HCSCREEN_WIDTH/8)];
    UILabel *mOwnerText = [UILabel labelWithFrame:CGRectMake(0, 5, HCSCREEN_WIDTH, 30) text:@"出售进度" textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:18] tag:101 hasShadow:NO isCenter:YES];
    
    [mViewhear addSubview:mOwnerText];
    [_mainView addSubview:mViewhear];
    
    UIView *mViewLone = [self viewLone:CGRectMake(10, mViewhear.height-0.5, HCSCREEN_WIDTH-20, 0.5) andColor:[UIColor lightGrayColor]];
    mViewLone.alpha = 0.5;
    [mViewhear addSubview:mViewLone];
    
    if (show == NO) {
        _mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, mViewhear.bottom, HCSCREEN_WIDTH, 130)];
        _mTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [self noImageView];
    }else{
        _mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, mViewhear.bottom, HCSCREEN_WIDTH, _arrayPriceData.count*65)];
    }
    _mTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    [_mainView addSubview:_mTableView];
    _numlabel = [UILabel labelWithFrame:CGRectMake(0, _mTableView.bottom, HCSCREEN_WIDTH, 40) text:@"只显示最新的20条记录" textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:14]  tag:0 hasShadow:NO isCenter:YES];
    [_mainView addSubview:_numlabel];
    UILabel *linelabel = [UILabel labelWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, 0.5) text:nil textColor:nil font:nil tag:0 hasShadow:NO isCenter:NO];
    linelabel.backgroundColor = [UIColor lightGrayColor];
    [self.numlabel addSubview:linelabel];
    [self addSubview:_mainView];
    [_mTableView insertSubview:_lineView atIndex:0];
    [_mTableView addSubview:_lineView];
    _strPhone = mySaleVehicel.offline_phone;
   
    self.mViewfooter = [[UIView alloc]initWithFrame:CGRectMake(0, _numlabel.bottom, HCSCREEN_WIDTH, HCSCREEN_WIDTH/6.5)];
    [self.mViewfooter .layer setCornerRadius:0.5];
    self.mViewfooter .alpha = 1;
    self.mViewfooter.userInteractionEnabled = YES;
    [self.mViewfooter .layer setBorderWidth:0.5];
    [self.mViewfooter .layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    
    self.offlineLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, HCSCREEN_WIDTH/2, HCSCREEN_WIDTH/6.5)];
    self.offlineLabel.textAlignment  = NSTextAlignmentLeft;
    self.offlineLabel.font = [UIFont systemFontOfSize:13];
    self.offlineLabel.text = mySaleVehicel.offline_text;
    self.offlineLabel.textColor = [UIColor lightGrayColor];
    [self.mViewfooter  addSubview:self.offlineLabel];
    
    UIButton *mApplicationOffline = [UIButton buttonWithFrame:CGRectMake(HCSCREEN_WIDTH-HCSCREEN_WIDTH/4-5, self.mViewfooter.height/6, HCSCREEN_WIDTH/4, self.mViewfooter.height*0.7) title:@"申请下线" titleColor:[UIColor blackColor] bgColor:nil titleFont:[UIFont systemFontOfSize:14] image:nil selectImage:nil target:self action:@selector(btnClik:) tag:0];
    _strPhone = mySaleVehicel.offline_phone;
    [mApplicationOffline.layer setCornerRadius:3.0];
    [mApplicationOffline.layer setMasksToBounds:YES];
    [mApplicationOffline.layer setBorderWidth:1.0];
    [mApplicationOffline.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    mApplicationOffline.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.mViewfooter  addSubview:mApplicationOffline];
    _mainView.userInteractionEnabled = YES;
    [_mainView addSubview:self.mViewfooter];
}

- (void)noImageView
{
    _lineView.hidden = YES;
    _noView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, 130)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(HCSCREEN_WIDTH/2.4, _mTableView.height/6, HCSCREEN_WIDTH/6, HCSCREEN_WIDTH/8)];
    imageView.image = [UIImage imageNamed:@"error_data"];
    [_noView addSubview:imageView];
    UILabel *mOwnerStatus = [UILabel labelWithFrame:CGRectMake(0, imageView.bottom+10, HCSCREEN_WIDTH, 25) text:@"还没有人咨询过您的爱车" textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:13] tag:101 hasShadow:NO isCenter:YES];
    [_noView addSubview:mOwnerStatus];
    UILabel *mOwnerWait = [UILabel labelWithFrame:CGRectMake(0, mOwnerStatus.bottom, HCSCREEN_WIDTH, 20) text:@"请再耐心等待一下..." textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:13] tag:101 hasShadow:NO isCenter:YES];
    [_noView addSubview:mOwnerWait];
    [_mTableView addSubview:_noView];
}

- (UIView *)viewLone:(CGRect)rect andColor:(UIColor*)color
{
    UIView * lineView = [[UIView alloc]initWithFrame:rect];
    lineView.backgroundColor = color;
    return lineView;
}

- (void)reloadViewDataWithMySaleVehicles:(MySaleVehicles*)vehicle{
    self.arrayPriceData = vehicle.buyer_list;
    self.offlineLabel.text = vehicle.offline_text;
    _strPhone = vehicle.offline_phone;
    [_noView removeFromSuperview];
    if (vehicle.status == -1 || vehicle.status == 1 || vehicle.status == 2) {
          [self.mTableView setHeight:0];
         [_noView removeFromSuperview];
            _mainView.hidden = YES;
    }else{
        if (self.arrayPriceData.count==0) {
            [self.mTableView setHeight:130];
            self.numlabel.hidden = YES ;
            [self.mViewfooter setTop:self.mTableView.bottom];
            [ _mainView setHeight:10+HCSCREEN_WIDTH/8+_mTableView.height+_mViewfooter.height];
            [self noImageView];
        }else{
             _lineView.hidden = NO;
            [self.mTableView setHeight:self.arrayPriceData.count*65];
            if (self.arrayPriceData.count<20) {
                [self.mViewfooter setTop:self.mTableView.bottom];
                self.numlabel.hidden = YES ;
                 [ _mainView setHeight:10+HCSCREEN_WIDTH/8+_mTableView.height+_mViewfooter.height];
            }else{
                self.numlabel.hidden = NO ;
                [self.mViewfooter setTop:self.numlabel.bottom];
                 [ _mainView setHeight:10+HCSCREEN_WIDTH/8+_mTableView.height+_mViewfooter.height+_numlabel.height];
            }
        }
         _mainView.hidden = NO;
        [_mTableView reloadData];
        [self updateViewheight:_mainView.height];
    }
}

- (void)updateViewheight:(CGFloat)height{
    if (self.delegate) {
        [self.delegate updateHeight:height];
    }
}

- (void)btnClik:(UIButton *)btn
{
      [UIAlertView popupAlertByDelegate:self title:_strPhone message:nil cancel:@"取消" others:@"确定"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [HCAnalysis HCUserClick:@"applyOffline"];
    if (buttonIndex == 1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_strPhone]]];
    }
}

#pragma mark  - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayPriceData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString * cellIdentifier = @"VehiceSaleConsultationCell";
    VehiceSaleConsultationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
          NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"VehiceSaleConsultationCell" owner:nil options:nil];
           cell = [nibs lastObject];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dic = [_arrayPriceData HCObjectAtIndex:indexPath.row];
        if (_arrayPriceData.count == 0) {
            cell.line.hidden = YES;
        }
        cell.phoneDetail.text = [dic objectForKey:@"text"];
        cell.timeDetail.text = [dic objectForKey:@"create_time"];
        return  cell;
    }
    return cell;
}

@end
