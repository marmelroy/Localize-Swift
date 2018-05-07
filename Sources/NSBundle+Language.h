//
//  NSBundle+Language.h
//  Localize
//
//  Created by Mario Villamizar on 04/07/2018.
//  Copyright © 2018 Mario Villamizar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (Language)

+ (void)setLanguage:(NSString *)language forcingRTL:(BOOL) flag;
    
@end
