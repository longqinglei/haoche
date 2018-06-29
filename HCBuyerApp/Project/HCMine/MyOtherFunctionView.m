//
//  MyOtherFunctionView.m
//  HCBuyerApp
//
//  Created by wj on 15/6/15.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "MyOtherFunctionView.h"
#import "VehicleDetailViewController.h"
#import "User.h"
#import "HCVehicleCell.h"
#import "HCSettingCell.h"
#import "Vehicle.h"

@interface MyOtherFunctionView()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *mTableView;
@property (strong, nonatomic) NSArray *cellContents;
@property (nonatomic) BOOL isFeedbackNew;
@property (nonatomic)BOOL isNew;
@property (nonatomic, strong) UIButton *myNewLabelBtn;

@end

@implementation MyOtherFunctionView

- (UIButton *)button:(UIButton *)btn
{
    btn = [[UIButton alloc]initWithFrame:CGRectMake(HCSCREEN_WIDTH - 60, 29 / 2, 25, 15)];
    btn.backgroundColor= PRICE_STY_CORLOR;
    btn.titleLabel.font = [UIFont systemFontOfSize: 10.0];
    [btn.layer setCornerRadius:7.5];
    [btn.layer setMasksToBounds:YES];
    return btn;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isFeedbackNew = NO;
        self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0 + (HC_VEHICLE_LIST_ROW_HEIGHT+5)*self.dataArrry.count) style:UITableViewStylePlain];
        self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.mTableView.delegate = self;
        self.mTableView.dataSource = self;
        [self.mTableView setScrollEnabled:NO];
        [self addSubview:self.mTableView];
    }
    return self;
}

- (void)setRecommendNew:(NSInteger)num
{
    self.myNewLabelBtn = [self button:self.myNewLabelBtn];
    self.isNew = YES;
    [self.myNewLabelBtn setTitle:[NSString stringWithFormat:@"%ld",(long)num] forState:UIControlStateNormal];
    [self.mTableView reloadData];
}

- (void)setRecommendReaded
{
    self.isNew = NO;
    [self.mTableView reloadData];
}

#pragma mark -- UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0) {
        return 44;
    }else{
        return HC_VEHICLE_LIST_ROW_HEIGHT+5;
    }
}

- (void)reloaddata:(NSArray *)arr
{
    self.dataArrry= arr;
    NSInteger count ;
    if (arr.count>=5) {
        count = 5;
    }else{
        count =arr.count;
    }
    [self.mTableView setHeight:(HC_VEHICLE_LIST_ROW_HEIGHT+5)*count+My_OtherTableView_Cell_Height];
    [_mTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        if (self.delegate) {

            [HCAnalysis HCUserClick:@"myrecommendmore_click"];
            [self.delegate showRecommend];
        }
    }else{
        Vehicle *vehicle = [self.dataArrry HCObjectAtIndex:indexPath.row-1];
        if (self.delegate) {
            [self.delegate showVehicleDetail:vehicle];
        }

        [HCAnalysis HCUserClick:@"myrecommendlist_click"];
    }
}


#pragma mark -- UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count ;
    if (self.dataArrry.count>=5) {
        count = 6;
    }else{
        count =self.dataArrry.count+1;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (indexPath.row==0) {
        NSString * cellIdentifier = @"cellIdentifier";
         HCSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[HCSettingCell alloc]initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, 44)];
            [cell.contentView addSubview:[self createlinelabel:0]];
            [cell.contentView addSubview:[self createlinelabel:44]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentLabel.text = @"推荐";
        cell.leftimage.image = [UIImage imageNamed:@"recommended"];
            if (self.isNew == YES) {
                [cell.contentView addSubview:self.myNewLabelBtn];
            }else{
                [self.myNewLabelBtn removeFromSuperview];
            }
        return  cell;
    }else{
       static NSString * cellIdentifier = @"hc_vehicle_cell";
        HCVehicleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        Vehicle *Myvehicle = [self.dataArrry HCObjectAtIndex:indexPath.row-1];
        if (!cell) {
            cell = [[HCVehicleCell alloc]initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, HC_VEHICLE_LIST_ROW_HEIGHT+5)data:Myvehicle];
             [cell.contentView addSubview:[self createlinelabel:HC_VEHICLE_LIST_ROW_HEIGHT+5-0.5]];
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell setVehicleData:Myvehicle];
        return cell;
    }
}

- (UILabel *)createlinelabel:(CGFloat)y
{
    UILabel *linelabel = [[UILabel alloc]init];
    linelabel.frame = CGRectMake(0, y, HCSCREEN_WIDTH, 0.5);
    linelabel.backgroundColor = [UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
    return linelabel;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
