//
//  NSArray+ITTAdditions.m
//
//  Created by guo hua on 11-9-21.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "NSArray+ITTAdditions.h"

@implementation NSArray(ITTAdditions)

-(BOOL)contentString:(NSString *)string
{
    for (id object in self) {
        if ([object isKindOfClass:[NSString class]]&&[object isEqualToString:string]) {
            return YES;
        }
    }
    return NO;
}

-(NSInteger)indexOfString:(NSString *)string
{
    for (id object in self) {
        if ([object isKindOfClass:[NSString class]]&&[object isEqualToString:string]) {
            return [self indexOfObject:object];
        }
    }
    return NSNotFound;
}


- (id)HCObjectAtIndex:(NSUInteger)index{
    if (index<self.count) {
        return self[index];
    }else{
        return nil;
    }
}

- (id)objectForKey:(NSString*)key{
    return nil;
}
@end
