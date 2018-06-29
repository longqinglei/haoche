//
//  HCDropSortListView.m
//  HCBuyerApp
//
//  Created by 张熙 on 16/9/19.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "HCDropSortListView.h"
#import "DataFilter.h"
#import "HCPriceCell.h"

#import "VehicleListViewController.h"

@interface HCDropSortListView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) UIView *gapView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) UIView *mSuperView;
@property (nonatomic) NSInteger selectedIdx;
@property (nonatomic, strong) SortCond *customSortCond;
@property (nonatomic, strong) UIView *navgation;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic) NSInteger type; //type =0 排序条件 =1 价格
@end




@implementation HCDropSortListView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame dataArray:(NSArray *)data superView:(UIView *)superView typeEnum:(NSInteger)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.navgation= [[UIView alloc]init];
        self.navgation.backgroundColor = [UIColor whiteColor];
        self.navgation.frame = CGRectMake(frame.origin.x, 0, self.width, 64);
        UILabel *titleLabel= [[UILabel alloc]init];
        titleLabel.text = @"排序";
        titleLabel.frame = CGRectMake(0, 20, self.width, 44);
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment =NSTextAlignmentCenter;
        [self.navgation addSubview:titleLabel];
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 64, self.width, 0.5)];
        line.backgroundColor = UIColorFromRGBValue(0xe0e0e0);
        [self.navgation addSubview:line];
        //计算tableview高度
        //CGFloat tableViewHeight = HCSCREEN_WIDTH*0.84;
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HomePriceCurDx:) name:@"HomePriceCurDx" object:nil];
        
        CGRect tableViewRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, HCSCREEN_HEIGHT);
        self.bgView = [[UIView alloc]init];
        self.bgView.frame = tableViewRect;
        self.bgView.backgroundColor = MTABLEBACK;
        //self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
        // self.bgView.layer.shadowOpacity = 0.0;
        self.gapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 ,HCSCREEN_WIDTH- tableViewRect.size.width, HCSCREEN_HEIGHT)];
        self.gapView.backgroundColor = UIColorFromRGBValue(0x000000);
        self.gapView.alpha = 0.6;
        UIPanGestureRecognizer *bgPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewPan:)];
        [self.bgView addGestureRecognizer:bgPan];
        UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
        [self.gapView addGestureRecognizer:bgTap];
        self.data = data;
        SortCond *selectcond = [self.data objectAtIndex:0];
        self.customSortCond = selectcond;
        self.mSuperView = superView;
        CGRect tableRect = CGRectMake(0, 64, frame.size.width, HCSCREEN_HEIGHT-66);
        [self createTableViewFrame:tableRect];
        self.type = type;
//        CGFloat lineX;
//        if (HCSCREEN_WIDTH>320) {
//            lineX =self.bgView.height/2;
//        }else{
//            lineX= self.bgView.height/1.8;
//        }
    }
    return self;
}
- (void)createTableViewFrame:(CGRect)frame{
    self.mTableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.mTableView   setSeparatorColor:UIColorFromRGBValue(0xe0e0e0)];  //设置分割线为蓝色
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    self.mTableView.backgroundColor = MTABLEBACK;
    self.mTableView.tableFooterView = [[UIView alloc]init];
    if ([self.mTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([self.mTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.mTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    [self.bgView addSubview:self.mTableView];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
        NSArray *array = [tableView visibleCells];
        SortCond *selectcond = [self.data objectAtIndex:indexPath.row];
        HCPriceCell *cell = (HCPriceCell*)[tableView cellForRowAtIndexPath:indexPath];
        self.customSortCond = selectcond;
        for (HCPriceCell *cell in array)
        {
            cell.textLabel.textColor = UIColorFromRGBValue(0x424242);
            cell.selectView.hidden = YES;
        }
        cell.textLabel.textColor = PRICE_STY_CORLOR;
        cell.selectView.hidden = NO;
        [self.delegate hcDropDownListViewDidSelectRowAtIndexPath:0 fromViewTag:self.tag conditon:selectcond];
//    }else {
//        
//        PriceCond *selectcond = [self.data objectAtIndex:indexPath.row+1];
//        self.customPriceCond = selectcond;
//        HCPriceCell *cell = (HCPriceCell*)[tableView cellForRowAtIndexPath:indexPath];
//        for (HCPriceCell *cell in array)
//        {
//            cell.textLabel.textColor = UIColorFromRGBValue(0x424242);
//            cell.selectView.hidden = YES;
//        }
//        cell.textLabel.textColor = PRICE_STY_CORLOR;
//        cell.selectView.hidden = NO;
//        
//        [self.delegate hcDropDownListViewDidSelectRowAtIndexPath:0 fromViewTag:self.tag conditon:selectcond];
//    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 44;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        HCPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pricecell"];
        
        SortCond *sort = [self.data objectAtIndex:indexPath.row];
        if (cell == nil) {
            cell = [[HCPriceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pricecell"];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.textColor = UIColorFromRGBValue(0x424242);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
        }
        if ([sort isEqual:self.customSortCond]) {
            cell.selectView.hidden = NO;
            cell.textLabel.textColor = PRICE_STY_CORLOR;
        }else{
            cell.selectView.hidden = YES;
            cell.textLabel.textColor =  UIColorFromRGBValue(0x424242);
        }
        cell.textLabel.text =  sort.sortDesc;
        return cell;
 
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

-(void)bgTappedAction:(UITapGestureRecognizer *)tap
{
    [self hide:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissDropdownView" object:nil];
}

- (void)bgViewPan:(UITapGestureRecognizer *)tap{
    if (tap.state ==UIGestureRecognizerStateBegan) {
        NSLog(@"开始滑动");
    }else if(tap.state == UIGestureRecognizerStateEnded){
        NSLog(@"结束滑动");
    }
}
////将选中状态设置为当前的idx
- (void)resetData:(NSInteger)idx
{
    [self hide:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissDropdownView" object:nil];
    self.selectedIdx = idx;
    self.customSortCond = [self.data objectAtIndex:idx];
    [self.mTableView reloadData];
    
}



- (void)show
{
    self.gapView.alpha = 0.5;
    [self.mSuperView addSubview:self.gapView];
    [self.mSuperView addSubview:self.bgView];
    [self.mSuperView addSubview:self.navgation];
}

- (void)hide:(BOOL)animate;
{
    CGRect rect = self.bgView.frame;
    CGRect oldRect = rect;
    rect.size.height = 0;
    if (!animate) {
        [self.bgView removeFromSuperview];
        [self.gapView removeFromSuperview];
        [self.navgation removeFromSuperview];
        return;
    }
    [UIView animateWithDuration:0.1 animations:^{
        self.gapView.alpha = 0.3f;
        self.bgView.frame = rect;
    }completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [self.gapView removeFromSuperview];
        [self.navgation removeFromSuperview];
        self.bgView.frame = oldRect;
    }];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
