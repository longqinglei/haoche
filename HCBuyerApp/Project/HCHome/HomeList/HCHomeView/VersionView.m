//
//  VersionView.m
//  HCBuyerApp
//
//  Created by haoche51 on 16/3/16.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "VersionView.h"
#import "UIImageView+WebCache.h"

@interface VersionView()

@property (nonatomic, strong)UITextView *updateContent;
@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)UILabel *labelTitile;
@property (nonatomic, strong)UIButton *cancelBtn;
@property (nonatomic, strong)UIImageView *mVersionChartImage;
@property (nonatomic, strong)UIImageView *mImageView;
@end

@implementation VersionView 

- (id)initWithFrameRect:(CGRect)frame  urlArray:(NSString *)content
{
    self = [super initWithFrame:frame];
    if (self) {
        self.content = content;
        [self createMainView];
    }
    return self;
}

#define HE HCSCREEN_HEIGHT/6-HCSCREEN_HEIGHT/7+5 + HCSCREEN_HEIGHT/7

- (void)createMainView
{
    //_arrayIndex = array;
    self.backgroundColor =  [UIColor colorWithRed:0.15f green:0.15f blue:0.15f alpha:0.50f];
    if (iPhone4s) {
       _mVersionChartImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.width/15, HE, self.width-self.width/15*2, HCSCREEN_HEIGHT/1.4)];
    }else{
       _mVersionChartImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.width/15, HE, self.width-self.width/15*2, HCSCREEN_HEIGHT/1.7)];
    }
   
    _mVersionChartImage.backgroundColor = [UIColor whiteColor];
    [_mVersionChartImage addSubview:[self addLabelprompt]];
    [self createTextView];
    [self cancelAndupdate];
    _mVersionChartImage.layer.masksToBounds = YES;
    _mVersionChartImage.layer.cornerRadius = 6.0;
    _mVersionChartImage.userInteractionEnabled = YES;
    [self addSubview:_mVersionChartImage];
}

- (UIImageView *)addLabelprompt
{
    _mImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_mVersionChartImage.width/3, 20, _mVersionChartImage.width/3, _mVersionChartImage.width/2.8)];
    _mImageView.image = [UIImage imageNamed:@"vehicleSource"];
    [_mVersionChartImage addSubview:_mImageView];
    return _mImageView;
}

- (void)cancelAndupdate
{
    NSArray *array = [[NSArray alloc]initWithObjects:@"取消",@"下载更新", nil];
    for (int i = 0; i<array.count; i++) {
        UIButton *  button = [[UIButton alloc]initWithFrame:CGRectMake(20+(i*((_mVersionChartImage.width-60)/2+20)), _updateContent.bottom+30, (_mVersionChartImage.width-60)/2, (_mVersionChartImage.width-60)/2/3)];
       [button setTitle:[array HCObjectAtIndex:i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        button.tag = 100+i;
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 6.0;
        [button.layer setBorderWidth:0.5];
        button.layer.borderColor = [UIColor colorWithRed:0.47f green:0.47f blue:0.47f alpha:1.0f].CGColor;
        button.userInteractionEnabled = YES;
        if (i == 0) {
            button.backgroundColor = [UIColor whiteColor];
            [button setTitleColor:PRICE_STY_CORLOR forState:UIControlStateNormal];
        }else{
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.backgroundColor = PRICE_STY_CORLOR;
        }
        [button addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_mVersionChartImage addSubview:button];
    }
}

- (void)BtnClick:(UIButton *)btn
{
    [self removeFromSuperview];
    if (btn.tag == 100) {
        [HCAnalysis HCUserClick:@"version_closeclick"];
    }else{
        [HCAnalysis HCUserClick:@"version_click"];
        if (self.delegate) {
            [self.delegate pushApptore];
        }
    }
}

#pragma mark - TableView


- (void)createTextView{
    
    self.updateContent=[[UITextView alloc] initWithFrame:CGRectMake(_mVersionChartImage.width/10, _mImageView.bottom+10, _mVersionChartImage.width-_mVersionChartImage.width/10*2, (_mVersionChartImage.height*0.38))]; //初始化大小并自动释放
    
    self.updateContent.textColor = UIColorFromRGBValue(0x929292);//设置textview里面的字体颜色
    
    self.updateContent.font = GetFontWithSize(17);
    
    self.updateContent.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
   
    self.updateContent.text = self.content;
    
    self.updateContent.scrollEnabled = YES;//是否可以拖动
    
    self.updateContent.editable = NO;//禁止编辑
    
    self.updateContent.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    
    [_mVersionChartImage addSubview: self.updateContent];//加入到整个页面中
}
//- (UITableView *)TableView
//{
//    self.mTableView = [[UITableView alloc]initWithFrame:CGRectMake(_mVersionChartImage.width/10, _mImageView.bottom+10, _mVersionChartImage.width-_mVersionChartImage.width/10*2, (_mVersionChartImage.height*0.38))];
//    self.mTableView.separatorStyle = UITableViewCellSelectionStyleNone;
//    self.mTableView.delegate = self;
//    self.mTableView.dataSource = self;
//    return self.mTableView;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//   return _arrayIndex.count;
//}
//
//
//+ (CGFloat)heightForText:(NSString *)text
//{
//    NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
//    return [text boundingRectWithSize:CGSizeMake(290, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrbute context:nil].size.height+10;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [VersionView heightForText:[_arrayIndex objectAtIndex:indexPath.row]];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//   static NSString *str = @"strCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
//    }
//    cell.textLabel.text = [_arrayIndex objectAtIndex:indexPath.row];
//    cell.textLabel.numberOfLines = 0;
//    cell.textLabel.textColor = UIColorFromRGBValue(0x929292);
//    cell.textLabel.font = [UIFont systemFontOfSize:17];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
//}


@end
