//
//  HCAllVehicleView.m
//  HCBuyerApp
//
//  Created by haoche51 on 16/4/18.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "HCAllVehicleView.h"
#import "UIButton+ITTAdditions.h"
@implementation HCAllVehicleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setupRefresh:(UITableView*)tableView{
    
    [tableView addHeaderWithTarget:self action:@selector(headerRefreshing)];
    [tableView addFooterWithTarget:self action:@selector(footerRefreshing)];
    
    tableView.headerPullToRefreshText = @"下拉刷新";
    tableView.headerReleaseToRefreshText = @"松开马上刷新";
    tableView.headerRefreshingText = @"刷新中,请稍候";
    
    tableView.footerPullToRefreshText = @"上拉加载更多数据";
    tableView.footerReleaseToRefreshText = @"松开加载更多数据";
    tableView.footerRefreshingText = @"更新中....";
}

-(NSMutableDictionary*)setSortType:(DataFilter *)dataFilter{
    NSMutableDictionary *sortDic = [[NSMutableDictionary alloc]init];
    if (dataFilter.sortCond==nil|| dataFilter.sortCond.sortType==SortTypeDefault)
    {
        [sortDic setObject:@1 forKey:@"desc"];
        [sortDic setObject:@"time" forKey:@"order"];
    }
    if (dataFilter.sortCond&&[dataFilter.sortCond isValid]) {
        switch (dataFilter.sortCond.sortType) {
            case SortTypeAgeAsc:
                [sortDic setObject:@1 forKey:@"desc"];
                [sortDic setObject:@"register_time" forKey:@"order"];
                break;
            case SortTypeMilesAsc:
                [sortDic setObject:@0 forKey:@"desc"];
                
                [sortDic setObject:@"miles" forKey:@"order"];
                break;
            case SortTypePriceAsc:
                [sortDic setObject:@0 forKey:@"desc"];
                [sortDic setObject:@"price" forKey:@"order"];
                break;
            case SortTypePriceDsc:
                [sortDic setObject:@1 forKey:@"desc"];
                [sortDic setObject:@"price" forKey:@"order"];
                break;
                
            default:
                break;
        }
    }
    return sortDic;
}

//- (void)showButtonOption:(NSArray *)_arrayAll button:(UIButton *)filterBtn w:(int)W addTarget:(id)target action:(SEL)action view:(UIView *)view
//{
//    UIScrollView *mScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 0, HCSCREEN_WIDTH-100, 50)];
//    [mScrollView setShowsHorizontalScrollIndicator:NO];
//    mScrollView.backgroundColor = [UIColor colorWithRed:0.98f green:0.97f blue:0.96f alpha:1.00f];
//    for (int i = 0; i<_arrayAll.count; i++) {
//       filterBtn = [UIButton VehicelListButtonWithFrame:CGRectMake(0, 0, 0, 0) title:[NSString stringWithFormat:@"%@",[_arrayAll HCObjectAtIndex:i]] titleColor:UIColorFromRGBValue(0x656565) bgColor:[UIColor whiteColor] titleFont:[UIFont systemFontOfSize:13] image:[UIImage imageNamed:@"shanchu"] selectImage:nil target:target action:action tag:i borderColor:[UIColor colorWithRed:0.47f green:0.47f blue:0.47f alpha:0.60f].CGColor borderWidth:0.5 cornerRadius:0.5  array:_arrayAll int:i w:W];
//         W = filterBtn.right;
//        [mScrollView addSubview:filterBtn];
//    }
//    [view addSubview:mScrollView];
//    mScrollView.contentSize = CGSizeMake(W, view.height);
//}





- (void)headerRefreshing
{
    NSLog(@"header refreshing begin");
}

- (void)footerRefreshing
{
    NSLog(@"footer refreshing begin");
}

@end
