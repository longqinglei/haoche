//
//  HCOtherSelectCell.h
//  HCBuyerApp
//
//  Created by 张熙 on 16/9/13.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCOtherSelectBtn.h"
#import "HCOtherColorBtn.h"
@protocol HCSelectCondDelegate

@required

- (void)cellBtnClick:(id)cond;

@end
@interface HCOtherSelectCell : UITableViewCell
@property (nonatomic,strong)NSMutableArray *selectArray;
@property (nonatomic,strong)NSString *reuseid;
@property (nonatomic,strong)id coustomCond;
@property (nonatomic,strong)NSArray * condArray;
@property (nonatomic,assign) id <HCSelectCondDelegate> delegate;
- (id)initWithCondArray:(NSArray*)condArray withTitle:(NSString*)title withreuseid:(NSString*)reuseid;
- (id)initWithStruCond:(NSArray*)StruCondArray withTitle:(NSString*)title withreuseid:(NSString*)reuseid;
- (void)resetCondBtnColor;
- (void)setSelectCond:(id)cond;
- (void)setSelectStruCond:(id)cond;
@end
