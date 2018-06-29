//
//  NSNull+length.m
//  KVNProgress
//
//  Created by 龙青磊 on 2018/5/29.
//

#import "NSNull+length.h"
#import <objc/runtime.h>

@implementation NSNull (length)

+ (void)load{
    [self setlength:0];
}

+ (void)setlength:(NSInteger)length
{
    objc_setAssociatedObject(self, @"lenght", [NSNumber numberWithInteger:0], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)length{
    return [objc_getAssociatedObject(self, @"lenght") integerValue];
}

@end
