//
//  MsemmViewController.m
//  segMent
//
//  Created by 张熙 on 15/9/15.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import "SearchController.h"
#import "UIViewExt.h"
#import "BizSearch.h"
#import "UILabel+ITTAdditions.h"
#import "BizCity.h"
@interface SearchController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

#pragma mark - XIB textField and tableView
@property (weak, nonatomic) IBOutlet UITextField *mTextFiled;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;

#pragma mark - array
@property (nonatomic,strong)NSMutableArray *mButtonArray;
@property (nonatomic,strong)NSMutableArray *mLocationHis;
@property (nonatomic,strong)NSArray *mSearchAssociateArr;
@property (nonatomic,strong)NSArray *mDataArray;
@property (nonatomic,strong)NSArray *marry;

#pragma mark - UIButton
@property (nonatomic,strong)UIButton *mSearch;

@property (nonatomic,strong)UIView *mHotView;
@property (nonatomic)CGFloat mHotViewHeight;
@property (nonatomic)BOOL isSearch;

@property (nonatomic,strong)NSMutableDictionary *properties;
@end

@implementation SearchController

#pragma mark - PrivateVariable
- (void)getHotSearchArr
{
    [BizSearch getHotSearchByFinish:^(NSArray * ret, NSInteger code)
    {
        if (code!=0){}else{
            _marry = ret;
            [self createButtonArr];
            
        }
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_mTextFiled resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length==0) {
        _mDataArray = @[];
        _mDataArray = _mLocationHis;
        _mHotView.hidden = NO;
        _isSearch = NO;
        [_mTableView reloadData];
    
    }
}

- (void)textFieldChanged{
    if (_mTextFiled.text.length == 0) {
        _isSearch =NO;[_mTableView reloadData];
    }
     [self searchTipsWithKey:_mTextFiled.text];
}

#pragma mark - /* 输入提示 搜索.*/
- (void)searchTipsWithKey:(NSString *)key
{
    if (key.length == 0)
    {
        _mDataArray = @[];
        _mDataArray = _mLocationHis;
        _isSearch = NO;
        [_mTableView reloadData];
        return;
    }
    [self getAssociate:key];
}

-(void)getAssociate:(NSString*)searchText
{
    [BizSearch getAssociateDataWithText:searchText ByFinish:^(NSArray *ret , NSInteger code) {
        if (code!=0) {
            _isSearch = NO;
        }else{
            _isSearch = YES;
            _mSearchAssociateArr =ret;
            _mDataArray = @[];
            _mDataArray = _mSearchAssociateArr;
            [_mTableView reloadData];
        }
    }];
}

- (void)createButtonArr
{
    _mButtonArray = [[NSMutableArray alloc]init];
    for (int i= 0; i<_marry.count; i++) {
        UIButton* mButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [mButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        mButton.tag = 100+i;
        mButton.backgroundColor= [UIColor whiteColor];
        [mButton setTitle:[_marry HCObjectAtIndex:i] forState:UIControlStateNormal];
        [self setButtonTitle:mButton.titleLabel.text button:mButton];
        mButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [mButton.layer setMasksToBounds:YES];
        [mButton.layer setBorderWidth:0.1];
        mButton.selected = YES;
        [mButton.layer setCornerRadius:11.0];
        [mButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_mButtonArray addObject:mButton];
    }
    [self createHotSearchView];
}

-(void) setButtonTitle:(NSString *)title button:(UIButton*) button
{
    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    titleSize.height = 20;
    [button setFrame:CGRectMake(button.frame.origin.x, button.frame.origin.y, titleSize.width+16 , titleSize.height)];
}

- (void)createHotSearchView
{
    _mHotView = [[UIView alloc]init];
    _mHotView.frame =CGRectMake(5, 5, self.view.width, 190);
    
    UILabel *titleLabel = [UILabel labelWithFrame:CGRectMake(10, 0, 140, 30) text:@"大家都在找" textColor:[UIColor colorWithRed:0.47f green:0.47f blue:0.47f alpha:1.00f] font:[UIFont systemFontOfSize:15] tag:0 hasShadow:NO isCenter:NO];
    
    UILabel *line = [[UILabel alloc]init];
    line.frame = CGRectMake(10, 31, HCSCREEN_WIDTH-10, 0.7);
    line.backgroundColor =[UIColor colorWithRed:0.86f green:0.85f blue:0.86f alpha:1.00f];
    [_mHotView addSubview:titleLabel];
    [_mHotView addSubview:line];
   
    CGFloat wSpace = 10;
    int i = 1;
    CGFloat y = 40;
    UIButton *btnclock;
    if (_mButtonArray.count!=0) {
        btnclock = [_mButtonArray HCObjectAtIndex:0];
    }
    for (int j = 0; j< _mButtonArray.count; j++) {
        UIButton *btn = [_mButtonArray HCObjectAtIndex:j];
        if (j==0) {btn.frame = CGRectMake(wSpace,y, btn.width,btn.height);}else{
            UIButton *btn1 = [_mButtonArray HCObjectAtIndex:j-1];
            if (btn1.right+btn.width+wSpace<HCSCREEN_WIDTH-10) {
                btn.frame = CGRectMake(wSpace+btn1.right, btn1.top, btn.width, btn.height);}else{
                i++;
                btn.frame = CGRectMake(wSpace, btn1.bottom+10, btn.width, btn.height);
            }
        }
        [_mHotView addSubview:btn];
    }
    _mHotViewHeight = i*(btnclock.height+10)+45;
    [_mTableView reloadData];
}

- (void)insertDataToLocation:(NSMutableArray *)arr text:(NSString*)text
{
    __block BOOL ret = NO;
    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *str = (NSString *)obj;
        if ([text isEqualToString:str]) {
            *stop = YES;
            ret = YES;
        }
    }];
    if (!ret) {
        if (text) {
          [arr insertObject:text atIndex:0];
        }
    }
}

- (void)updateSearchResult:(NSString*)query
{
    if (query==nil) {
        return;
    }
    [_properties setObject:query forKey:@"SearchKeyWord"];
    [BizSearch getSearchResultWithText:query ByFinish:^(NSArray * ret, NSInteger code ,NSInteger num, NSDictionary* quer) {
        if (code!=0) {
        }else{
            if (quer==nil) {
                quer = [[NSDictionary alloc]init];
            }
            NSDictionary *dic = @{@"searchStr":query,
                                  @"query":quer,
                                  @"recommend":ret
                                  };
            if (_type == 1){
//                [self.tabBarController setSelectedIndex:1];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            if (num==0) {
                [_properties setObject:@"false" forKey:@"IsHaveResult"];
            }else{
                [_properties setObject:@"true" forKey:@"IsHaveResult"];
            }
             [HCAnalysis HCclick:@"Search" WithProperties:_properties];
             NSDictionary *datafileDict = [dic objectForKey:@"query"];
            if (datafileDict.count==0) {
                self.datafilter.searchString = [dic objectForKey:@"searchStr"];

            }else{
                [self.datafilter setCondValuesByData:datafileDict];
            }
            
            if (self.delegate) {
                [self.delegate searchResult:self.datafilter];
            }
            //2.7版本修改删除了调用父类的一个方法,初始化多写
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // NSInteger row = indexPath.row;
    [_mTextFiled resignFirstResponder];
    if(_isSearch == YES){
        if (self.mDataArray.count>indexPath.row) {
            NSString *text = [_mDataArray HCObjectAtIndex:indexPath.row];
            [self vehiclelistjump];
            [self updateSearchResult:text];
            [self saveDataLocation:text];
        }
       
    }else{

        if (indexPath.row>1) {
            [_properties setObject:@"true" forKey:@"IsHistory"];
            NSString *text = [_mDataArray HCObjectAtIndex:indexPath.row-2];
            [self vehiclelistjump];
            [self updateSearchResult:text];
        }
    }
}


- (void)saveDataLocation:(NSString*)text
{
    NSString * string = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) HCObjectAtIndex:0];
    NSString * filePath = [string stringByAppendingString:@"/searchHistory.swh"];
    [self insertDataToLocation:_mLocationHis text:text];
    if(_mLocationHis.count >20 ){[_mLocationHis removeLastObject];}
    NSData * locationData = [NSKeyedArchiver archivedDataWithRootObject:_mLocationHis];
    [locationData writeToFile:filePath atomically:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([textField.text isEqual:@""]) {
        UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"请输入你搜索的车辆信息" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [view show];
    }else{
        [self vehiclelistjump];
        [self updateSearchResult:_mTextFiled.text];
        [self saveDataLocation:_mTextFiled.text];
        _isSearch= YES;
    }
   return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

#pragma mark - LifeCycle
- (void)viewWillAppear:(BOOL)animated{
    [HCAnalysis controllerBegin:@"searchPage"];
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    NSString * string = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) HCObjectAtIndex:0];
    NSString * filePath = [string stringByAppendingString:@"/searchHistory.swh"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        _mLocationHis = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:filePath]];
        _mDataArray = _mLocationHis;
    }
    [_mTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_mLocationHis == nil) {
        _mLocationHis = [[NSMutableArray alloc]init];
    }
    if (_properties==nil) {
        _properties = [[NSMutableDictionary alloc]init];
    }
    if (self.type==1) {
        [_properties setObject:@"HomePage" forKey:@"FromPlace"];
    }else{
        [_properties setObject:@"BuyVehiclePage" forKey:@"FromPlace"];
    }
    self.datafilter = [[DataFilter alloc]init];
    [_properties setObject:@"false" forKey:@"IsRecommend"];
    [_properties setObject:@"false" forKey:@"IsHistory"];
    _isSearch = NO;
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    _mTextFiled.delegate = self;
    _mTableView.tableFooterView = [[UIView alloc]init];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [_mTextFiled addTarget:self action:@selector(textFieldChanged) forControlEvents:UIControlEventEditingChanged];
    [self getHotSearchArr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
    [HCAnalysis controllerEnd:@"searchPage"];
    self.navigationController.navigationBarHidden = NO;
    [_mTextFiled resignFirstResponder];
    [[NSUserDefaults standardUserDefaults]setObject:@"home_search" forKey:@"ConnectingBridge"];
}


#pragma mark - UITableViewDataSource And UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isSearch == YES) {
        return _mDataArray.count;
    }else{
        return 2 + _mDataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isSearch == YES)
    {
        return 40;
    }
    else
    {
        if (indexPath.row == 0) {
            return _mHotViewHeight;
        }else{
            return 40;
        }
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"cellIdentifier";
    static NSString *cellId = @"cellId";
    if (_isSearch == YES) {
       
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (indexPath.row == 0) {cell.textLabel.font = nil;}
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row<_mDataArray.count) {
            cell.textLabel.text = [_mDataArray HCObjectAtIndex:indexPath.row];
        }
        cell.textLabel.textColor = nil;
        cell.backgroundColor = [UIColor colorWithRed:0.94f green:0.93f blue:0.92f alpha:1.00f];
        _mHotView.hidden = YES;
        return cell;
    }else{
        if (indexPath.row == 0) {
           UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
           if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
                cell.selectionStyle =  UITableViewCellSelectionStyleNone;}
            cell.textLabel.text = @"";
            cell.backgroundColor =[UIColor colorWithRed:0.94f green:0.93f blue:0.92f alpha:1.00f];
            [cell.contentView addSubview:_mHotView];
            _mHotView.hidden  = NO;
            return cell;
         }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
                cell.selectionStyle =  UITableViewCellSelectionStyleNone;
            }
             if (indexPath.row == 1)
             {
                 cell.textLabel.text = @"历史搜索";
                 cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
                 cell.textLabel.textColor = [UIColor grayColor];
                 cell.backgroundColor =nil;
             }else {
                cell.backgroundColor = [UIColor whiteColor];
                cell.textLabel.text = [_mDataArray HCObjectAtIndex:indexPath.row-2];
                cell.textLabel.font = nil;
                cell.textLabel.textColor = nil;
             }
             return cell;
         }
    }
    return nil;
}
- (void)vehiclelistjump{
    [_properties setObject:[BizCity getCurCity].cityName forKey:@"city"];
   
    [self.tabBarController setSelectedIndex:1];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"selectUserVisit" object:@"0"];
}
- (void)btnClick:(UIButton*)button
{
    [_properties setObject:@"true" forKey:@"IsRecommend"];
    NSString *searchText = [_marry HCObjectAtIndex:button.tag-100];
    [self vehiclelistjump];
    [self updateSearchResult:searchText];
    [self saveDataLocation:searchText];
}

- (IBAction)Cancel:(id)sender
{
    [_mTextFiled resignFirstResponder];
    if (_type == 1) {
          [self.navigationController popToRootViewControllerAnimated:NO];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
