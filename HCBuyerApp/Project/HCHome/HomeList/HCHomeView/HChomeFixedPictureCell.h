//
//  HCBuyerApp
//
//  Created by haoche51 on 15/12/30.
//  Copyright © 2015年 haoche51. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HChomeFixedPictureCellDelegate <NSObject>

- (void)ServiceGuarantee;

@end

#import "BaseTableViewCell.h"
@interface HChomeFixedPictureCell : BaseTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@property (nonatomic,strong)id<HChomeFixedPictureCellDelegate>delegate;
@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UIButton *mButtonbannerTwo;
@property (nonatomic,strong)NSString *iphone;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *badVehicle;
- (void)resetBadVehicleNum:(NSString*)badVehicle;
@end
