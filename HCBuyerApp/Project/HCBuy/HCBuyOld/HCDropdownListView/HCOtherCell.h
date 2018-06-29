//
//  HCOtherCell.h
//  HCBuyerApp
//
//  Created by 张熙 on 16/9/14.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCOtherSelectBtn.h"
#import "HCOtherColorBtn.h"
@protocol HCOtherCellDelegate

@required
- (void)othercellBtnClick:(id)cond;
- (void)cellcolorClick:(id)cond;
@end

@interface HCOtherCell : UITableViewCell
@property (nonatomic,assign)id <HCOtherCellDelegate> delegate;
@property (nonatomic,strong)UIButton *rightBth;
@property (nonatomic,strong)UIView *mainView;
@property (nonatomic,strong)NSArray *condArray;
@property (nonatomic,strong)UIImageView *rightImage;
@property (nonatomic,strong)NSMutableArray *selectArray;
@property (nonatomic,strong)NSString* reuseid;
- (void)resetCondBtnState;
- (void)setSelectCond:(id)cond;
- (id)initWithCondArray:(NSArray*)condArray withTitle:(NSString*)title type:(int)type withReuseid:(NSString*)reuseid;
@end
