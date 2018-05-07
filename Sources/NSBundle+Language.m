//
//  NSBundle+Language.m
//  Localize
//
//  Created by Mario Villamizar on 04/07/2018.
//  Copyright © 2018 Mario Villamizar. All rights reserved.
//

#import "NSBundle+Language.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static const char kBundleKey = 0;

@interface BundleEx : NSBundle

@end

@implementation BundleEx

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName
{
    NSBundle *bundle = objc_getAssociatedObject(self, &kBundleKey);
    if (bundle) {
        return [bundle localizedStringForKey:key value:value table:tableName];
    }
    else {
        return [super localizedStringForKey:key value:value table:tableName];
    }
}

@end

@implementation NSBundle (Language)

+ (void)setLanguage:(NSString *)language forcingRTL:(BOOL) flag
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object_setClass([NSBundle mainBundle], [BundleEx class]);
    });
    
    
    if (@available(iOS 9.0, *)) {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    } else {
        // Fallback on earlier versions
    }
    
    id value = language ? [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:language ofType:@"lproj"]] : nil;
    objc_setAssociatedObject([NSBundle mainBundle], &kBundleKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
