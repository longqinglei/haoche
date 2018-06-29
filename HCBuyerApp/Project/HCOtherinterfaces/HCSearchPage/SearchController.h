//
//  MsemmViewController.h
//  segMent
//
//  Created by 张熙 on 15/9/15.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCBaseViewController.h"
#import "DataFilter.h"
@protocol SearchControllerDelegate <NSObject>
//- (void)searchController:(NSDictionary *)searchDic;
- (void)searchResult:(DataFilter*)datafilter;
@end

@interface SearchController : HCBaseViewController
@property (nonatomic)NSInteger type;
@property (nonatomic,strong)  DataFilter* datafilter;
@property (nonatomic,strong)id <SearchControllerDelegate> delegate;

@end
