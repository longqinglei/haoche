//
//  ManagementViewController.h
//  HCBuyerApp
//
//  Created by haoche51 on 15/8/15.
//  Copyright (c) 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol managerSubDelegate <NSObject>

- (void)deleteSuccess;

@end
@interface ManagementViewController : HCBaseViewController
@property (nonatomic,strong)id <managerSubDelegate> delegate;
@property (nonatomic,strong)NSArray *mArray;

@end
