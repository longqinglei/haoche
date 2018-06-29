//
//  ForumModel.h
//  HCBuyerApp
//
//  Created by 张熙 on 16/5/30.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ForumModel : NSObject
@property (nonatomic,strong)NSString *link_url;
@property (nonatomic,strong)NSString *pic_url;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *updated_at;
- (id)initWithForumData:(NSDictionary *)dict;
@end
