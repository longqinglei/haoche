//
//  HCHomeForumCell.m
//  HCBuyerApp
//
//  Created by 张熙 on 16/5/30.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "HCHomeForumCell.h"
#import "UIImageView+WebCache.h"
#define ForumImageWidth  HCSCREEN_WIDTH*0.23
#define ForumImageHeight HCSCREEN_WIDTH*0.23
@implementation HCHomeForumCell

- (instancetype)initWithFrame:(CGRect)frame WithForumData:(ForumModel *)forum
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.titleLabel.text = forum.title;
        //[self setLableFontSpace:self.titleLabel];
        self.titleLabel.textColor = UIColorFromRGBValue(0x424242);
        self.titleLabel.font = GetFontWithSize(17);
        self.titleLabel.numberOfLines = 2;
        self.backView =[[ UIView alloc]init];
        self.backView.frame = CGRectMake(20, 0, HCSCREEN_WIDTH-40, ForumImageWidth);
        self.backView.backgroundColor = MTABLEBACK;
        [self addSubview:self.backView];
        self.updateTime = [[UILabel alloc]initWithFrame:CGRectMake(15, self.titleLabel.bottom+10, HCSCREEN_WIDTH- 50 - ForumImageWidth, 15)];
        self.updateTime.textColor = UIColorFromRGBValue(0x929292);
        self.updateTime.font = GetFontWithSize(10);
        self.updateTime.text = forum.updated_at;
        //[self.updateTime sizeToFit];
        if (forum.pic_url.length == 0) {
            self.titleLabel.frame = CGRectMake(15, 15, self.backView.width-30, 50);
            [self.titleLabel sizeToFit];
            [self.titleLabel setTop:(ForumCellHeight - self.titleLabel.height - self.updateTime.height -10)/2];
            [self.updateTime setTop:self.titleLabel.bottom+10];
        }else{
            self.forumImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.backView.width -ForumImageWidth , 0, ForumImageWidth, ForumImageHeight)];
            [self.backView addSubview:self.forumImage];
            self.titleLabel.frame = CGRectMake(15, 15, self.backView.width-30 - ForumImageWidth, 50);
            [self.titleLabel sizeToFit];
            [self.titleLabel setTop:(ForumCellHeight - self.titleLabel.height - self.updateTime.height -10)/2];
            [self.updateTime setTop:self.titleLabel.bottom+5];
            [self.forumImage sd_setImageWithURL:[NSURL URLWithString:forum.pic_url] placeholderImage:[UIImage imageNamed:@"default_vehicle"]];
            
        }
        [self createBottom];
        [self.updateTime setLeft:self.titleLabel.left];
        [self.backView addSubview:self.titleLabel];
        [self.backView addSubview:self.updateTime];
        [self setdataWithForumData:forum];
        
    }
    return self;
}

- (void)createBottom{
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, self.backView.bottom, HCSCREEN_WIDTH, 20);
    view.backgroundColor = [UIColor whiteColor];
    UIView *view1 = [[UIView alloc]init];
    view1.frame = CGRectMake(0, view.bottom, HCSCREEN_WIDTH, 10);
    view1.backgroundColor = MTABLEBACK;
    view.tag=1000;
    view1.tag=1001;
    [self addSubview:view];
    [self addSubview:view1];
}
- (void)showBottom{
    UIView *view = (UIView*)[self viewWithTag:1000];
    view.hidden = NO;
    UIView *view1 = (UIView*)[self viewWithTag:1001];
    view1.hidden = NO;
    
}
- (void)hideBottom{
    UIView *view = (UIView*)[self viewWithTag:1000];
    view.hidden = YES;
    UIView *view1 = (UIView*)[self viewWithTag:1001];
    view1.hidden = YES;
}
-(void)setdataWithForumData:(ForumModel *)forum{
    self.titleLabel.text = forum.title;
    self.updateTime.text = forum.updated_at;
    
    if (forum.pic_url.length == 0){
        self.forumImage.hidden = YES;
        self.titleLabel.frame = CGRectMake(15, 15, self.backView.width-30, 50);
        
    }else{
        if (!self.forumImage) {
            self.forumImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.backView.width -ForumImageWidth, 0, ForumImageWidth, ForumImageHeight)];
            [self.backView addSubview:self.forumImage];
            self.titleLabel.frame = CGRectMake(15, 15, self.backView.width-30 - ForumImageWidth, 50);
            [self.titleLabel sizeToFit];
            [self.titleLabel setTop:(ForumCellHeight - self.titleLabel.height - self.updateTime.height -10)/2];
            [self.updateTime setTop:self.titleLabel.bottom+5];
            
        }else{
            self.forumImage.hidden = NO;
            self.titleLabel.frame = CGRectMake(15, 15, self.backView.width-30 - ForumImageWidth, 50);
            //[self.forumImage sd_setImageWithURL:[NSURL URLWithString:forum.image_url] placeholderImage:[UIImage imageNamed:@"default_vehicle"]];
        }
       
        [self.forumImage sd_setImageWithURL:[NSURL URLWithString:forum.pic_url] placeholderImage:[UIImage imageNamed:@"default_vehicle"]];
       
        
    }
    [self setLableFontSpace:self.titleLabel];
    [self.titleLabel sizeToFit];

    [self.titleLabel setTop:(ForumCellHeight - self.titleLabel.height - self.updateTime.height -10)/2];
    [self.updateTime setTop:self.titleLabel.bottom+5];
    [self.updateTime setLeft:self.titleLabel.left];
}

- (void)setLableFontSpace:(UILabel*)label{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    paragraphStyle.lineSpacing = 5;
    
    NSDictionary *attributes = @{ NSFontAttributeName: GetFontWithSize(17), NSParagraphStyleAttributeName:paragraphStyle};
    if (label.text==nil) {
        label.text=@"";
    }
    label.attributedText = [[NSAttributedString alloc]initWithString:label.text attributes:attributes];
    
}


- (NSString *)reuseIdentifier{
    
    return @"forumCellReuse";
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
