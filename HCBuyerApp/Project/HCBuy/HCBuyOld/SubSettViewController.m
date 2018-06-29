//
//  SubSettViewController.m
//  HCBuyerApp
//
//  Created by haoche51 on 15/8/13.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "SubSettViewController.h"
#import "ManagementViewController.h"
#import "SubscribeRquest.h"
#import "FVCustomAlertView.h"
#import "SubscriptionModelCar.h"
#import "subCellTableViewCell.h"

@interface SubSettViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *numberImageView;
@property (weak, nonatomic) IBOutlet UIButton *numberIntget;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (nonatomic, strong) NSMutableArray *arrayDataText;
@property (nonatomic, strong) UIButton* button;
@property (nonatomic) NSInteger index;

@end

@implementation SubSettViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_arrayData == nil) {
        _arrayData = [[NSMutableArray alloc]init];}
    if (_arrayDataText == nil) {
           _arrayDataText = [[NSMutableArray alloc]init];
    }
    _index = -1;
    [self data];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_arrayData.count == 0) {
        [self imageName:@"ImageZero" To:0];
    }else if (_arrayData.count == 1){
        [self imageName:@"ImageOne" To:1];
    }else if (_arrayData.count == 2){
        [self imageName:@"ImageTwo" To:2];
    }else if (_arrayData.count == 3){
        [self imageName:@"ImageThree" To:3];
    }else if (_arrayData.count == 4){
        [self imageName:@"ImageFore" To:4];
    }else if (_arrayData.count == 5){
        [self imageName:@"ImageFree" To:5];
    }
}


- (void)imageName:(NSString *)name To:(int)number
{
    [_numberIntget setTitleColor:UIColorFromRGBValue(0x424242) forState:UIControlStateNormal];
    [_numberIntget setTitle:[NSString stringWithFormat:@"全部%d个上新提醒",number] forState:UIControlStateNormal];
    _numberImageView.image = [UIImage imageNamed:name];
}


#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayData.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SubscriptionModelCar *vehicle = [self.arrayData HCObjectAtIndex:indexPath.row];
    NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"subCellTableViewCell" owner:nil options:nil];
    subCellTableViewCell * subscribeCell = [nibs lastObject];
    subscribeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [subscribeCell initCellWithRet:vehicle];
    if (indexPath.row == _index) {
        subscribeCell.selectBtn.hidden = NO;
    }
    return subscribeCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:_index inSection:0];
    subCellTableViewCell *lastCell =(subCellTableViewCell*)[tableView cellForRowAtIndexPath:lastIndex];
    lastCell.selectBtn.hidden =YES;
     subCellTableViewCell *cell = (subCellTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [_arrayDataText removeAllObjects];
    [_arrayDataText addObject:cell.carName.text];
       UIImageView *imagePrture = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"noState"]];
    if (cell.imageViewCar.image == nil) {
        [_arrayDataText addObject:imagePrture.image];
    }else{
        [_arrayDataText addObject:cell.imageViewCar.image];
    }
    NSArray *array = [tableView visibleCells];
    for (subCellTableViewCell *cell in array)
    {
        cell.selectBtn.hidden = YES;
    }
    cell.selectBtn.hidden = NO;
    self.selectBtn.hidden = YES;
    _index = indexPath.row;//1
    [_arrayDataText addObject:cell.priceLabel.text];
    [_arrayDataText addObject:cell.subid.text];
    if (self.delegate) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [self.delegate SelectCell:_arrayDataText];
    }
}

#pragma mark - UIButton
- (IBAction)removerView:(id)sender
{
    NSArray *cellarr = [ _mTableView visibleCells];
    
    if (cellarr.count>0&&_index<cellarr.count) {
        subCellTableViewCell *lastCell = [cellarr HCObjectAtIndex:_index];
        lastCell.selectBtn.hidden = YES;
    }
    _index = -1;
    self.selectBtn.hidden = NO;
    if (self.delegate) {
    [self.delegate SelectCell:nil];
    }
}

- (IBAction)Administration:(id)sender
{
    if (self.delegate) {
        [self.delegate pushViewController:nil];
    }
}

#pragma mark - PrivateVariable
- (void)data
{
    _mTableView.dataSource =self;
    _mTableView.delegate = self;
    _mTableView.scrollEnabled =NO;
}

@end
