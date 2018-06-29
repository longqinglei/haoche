//
//  ManagementViewController.m
//  HCBuyerApp
//
//  Created by haoche51 on 15/8/15.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "ManagementViewController.h"
#import "subCellTableViewCell.h"
#import "UIImage+RTTint.h"
#import "SubscribeRquest.h"
#import "FVCustomAlertView.h"
#import "SubscriptionModelCar.h"
#import "MyVehicle.h"

@interface ManagementViewController ()
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (nonatomic,strong) NSMutableArray *arrayData;


@end
@implementation ManagementViewController
#define TITLE @"最多可添加5条上新提醒,左滑删除提醒"

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [self DataView];
    [super viewDidLoad];
    [self creatBackButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    [HCAnalysis controllerBegin:@"manageSubPage"];
   // self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
    [HCAnalysis controllerEnd:@"manageSubPage"];
   // self.tabBarController.tabBar.hidden = NO;
}

#pragma mark - PrivateVariable
- (void)DataView
{
    if (_arrayData == nil)
    {_arrayData = [[NSMutableArray alloc]init];}
    _arrayData = [NSMutableArray arrayWithArray:_mArray];
    _mTableView.dataSource = self;
    _mTableView.delegate = self;
    _mTableView.tableFooterView = [[UIView alloc]init];
}

#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
   subCellTableViewCell *cell = (subCellTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [SubscribeRquest deleteSub:[cell.subid.text intValue] scription:^(NSMutableArray *ret, NSInteger code)
        {
            if (code == -1)
            {
              [self showMsg:@"网络不给力" type:FVAlertTypeError];
            } else if (code == 0) {
                [tableView beginUpdates];
                if (_arrayData.count !=0) {
                    [_arrayData removeObjectAtIndex:indexPath.row];
                    [_mTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                    [_mTableView reloadData];
                }
                [MyVehicle deleteOrderInfoFromOrderList:[cell.subid.text intValue]];
            }else if (code == -2)
            {[self showMsg:@"已全部加载" type:FVAlertTypeDone];}
            [_mTableView endUpdates];
            if (self.delegate) {
                [self.delegate deleteSuccess];
                self.tabBarController.tabBar.hidden = YES;
            }
        } ];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}


- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    UIView *lone = [[UIView alloc]initWithFrame:CGRectMake(0, 0, HCSCREEN_WIDTH, 0.5)];
    lone.backgroundColor = [UIColor lightGrayColor];
    lone.alpha = 0.5;
    [view addSubview:lone];
    UILabel *textLabel = [UILabel labelWithFrame:CGRectMake(0, 5, HCSCREEN_WIDTH, 40) text:TITLE textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:14] tag:0 hasShadow:NO isCenter:YES];
    [view addSubview:textLabel];
    return view;
}

#pragma mark - UITableViewDataSource And UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayData.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCell = @"subCellTableViewCell";
    SubscriptionModelCar *vehicle = [_arrayData HCObjectAtIndex:indexPath.row];
    subCellTableViewCell *subscribeCell = [tableView dequeueReusableCellWithIdentifier:strCell];
    if (!subscribeCell) {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"subCellTableViewCell" owner:nil options:nil];
        subscribeCell = [nibs lastObject];
        subscribeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [subscribeCell initCellWithRet:vehicle];
    }
    return subscribeCell;
}


@end
