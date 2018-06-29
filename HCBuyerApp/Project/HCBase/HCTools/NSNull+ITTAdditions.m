//
//  NSNull+ITTAdditions.m
//  HCBuyerApp
//
//  Created by 张熙 on 16/6/14.
//  Copyright © 2016年 haoche51. All rights reserved.
//

#import "NSNull+ITTAdditions.h"
#import <objc/runtime.h>
#define NSNullObjects @[@"",@0,@{},@[]]
@implementation NSNull (ITTAdditions)
+ (void)load
{
    @autoreleasepool {
        [self wt_swizzleInstanceMethodWithClass:[NSNull class] originalSel:@selector(methodSignatureForSelector:) replacementSel:@selector(wt_methodSignatureForSelector:)];
        [self wt_swizzleInstanceMethodWithClass:[NSNull class] originalSel:@selector(forwardInvocation:) replacementSel:@selector(wt_forwardInvocation:)];
    }
}

- (NSMethodSignature *)wt_methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        for (NSObject *object in NSNullObjects) {
            signature = [object methodSignatureForSelector:aSelector];
            if (!signature) {
                continue;
            }
            if (strcmp(signature.methodReturnType, "@") == 0) {
                signature = [[NSNull null] methodSignatureForSelector:@selector(wt_nil)];
            }
            return signature;
        }
        return [self wt_methodSignatureForSelector:aSelector];
    }
    return signature;
}

- (void)wt_forwardInvocation:(NSInvocation *)anInvocation
{
    if (strcmp(anInvocation.methodSignature.methodReturnType, "@") == 0)
    {
        anInvocation.selector = @selector(wt_nil);
        [anInvocation invokeWithTarget:self];
        return;
    }
    
    for (NSObject *object in NSNullObjects)
    {
        if ([object respondsToSelector:anInvocation.selector])
        {
            [anInvocation invokeWithTarget:object];
            return;
        }
    }
    
    [self wt_forwardInvocation:anInvocation];
    //  [self doesNotRecognizeSelector:aSelector];
}

- (id)wt_nil
{
    return nil;
}

+ (void)wt_swizzleInstanceMethodWithClass:(Class)clazz originalSel:(SEL)original replacementSel:(SEL)replacement
{
    Method originMethod = class_getInstanceMethod(clazz, original);
    Method replaceMethod = class_getInstanceMethod(clazz, replacement);
    if (class_addMethod(clazz, original, method_getImplementation(replaceMethod), method_getTypeEncoding(replaceMethod)))
        {
            class_replaceMethod(clazz, replacement, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
        }
        else
        {
            method_exchangeImplementations(originMethod, replaceMethod);
        }
        }

@end
