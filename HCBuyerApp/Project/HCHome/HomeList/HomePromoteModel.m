//
//  HomePromoteModel.m
//  HCBuyerApp
//
//  Created by haoche51 on 15/12/30.
//  Copyright © 2015年 haoche51. All rights reserved.
//

#import "HomePromoteModel.h"

@implementation HomePromoteModel

-(instancetype)initWithData:(NSDictionary *)bannerData and:(BOOL)banner{
    
    self = [super init];
    if (self) {
        if ([bannerData isKindOfClass:[NSDictionary class]]) {
            @try {
                if (banner== YES) {
                    self.bannerImgaeUrl = [NSString cutPicture:[bannerData objectForKey:@"image_url"] W:2*(HCSCREEN_WIDTH-30) H:2*HCSCREEN_WIDTH*0.78];
                }else{
                    self.bannerImgaeUrl = [NSString getFixedSolutionImageAllurl:[bannerData objectForKey:@"image_url"] w:HCSCREEN_WIDTH*2 h:(int)2*HCSCREEN_WIDTH/[[bannerData objectForKey:@"pic_rate"] floatValue]];
                }
                self.redirect_url = (NSString *)[bannerData objectForKey:@"redirect_url"];
                self.title = (NSString *)[bannerData objectForKey:@"title"];
                self.share_des = (NSString *)[bannerData objectForKey:@"share_desc"];
                self.share_image = (NSString *)[bannerData objectForKey:@"share_image"];
                self.share_title = (NSString *)[bannerData objectForKey:@"share_title"];
                self.pic_rate = [bannerData objectForKey:@"pic_rate"];
                //
                self.mHead_url = (NSString *)[bannerData objectForKey:@"head_url"];
                self.mPhone = (NSString *)[bannerData objectForKey:@"phone"];
                self.mScore = [[bannerData objectForKey:@"score"] floatValue];
                self.mContent = (NSString *)[bannerData objectForKey:@"content"];
                self.mVehicle_info = (NSString *)[bannerData objectForKey:@"vehicle_info"];
                self.mFrom = [bannerData objectForKey:@"from"];
                if (!self.title) {
                    self.title = @"";
                }
            } @catch (NSException *exception) {
                
            } @finally {
            
            }
    }
    
    }
    return self;
}

@end
