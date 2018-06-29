//
//  ForumModel.m
//  HCBuyerApp
//
//  Created by 张熙 on 16/5/30.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "ForumModel.h"

@implementation ForumModel
- (id)initWithForumData:(NSDictionary *)dict{
    self = [super init];
    if (self) {
         if ([dict isKindOfClass:[NSDictionary class]]) {
             @try {
                 self.link_url = [dict objectForKey:@"link_url"];
                 self.pic_url = [dict objectForKey:@"pic_url"];
                 self.title = [dict objectForKey:@"title"];
                 self.updated_at =  [dict objectForKey:@"updated_at"];
             } @catch (NSException *exception) {
                 
             } @finally {
                 
             }
        
         }
    }
    return self;
}
@end
