//
//  SubSettViewController.h
//  HCBuyerApp
//
//  Created by haoche51 on 15/8/13.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SubSettViewControllerDelegate <NSObject>

- (void)pushViewController:(id)ID;
- (void)SelectCell:(NSMutableArray *)array;

@end

@interface SubSettViewController : HCBaseViewController

- (IBAction)removerView:(id)sender ;
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (assign,nonatomic)id<SubSettViewControllerDelegate>delegate;
@property (nonatomic,strong)NSArray *arrayData;

@end
