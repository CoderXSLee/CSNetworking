//
//  NSString+Encrypt.h
//  ChiefSteward
//
//  Created by CoderXSLee on 16/4/5.
//  Copyright © 2016年 李雪松 All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encrypt)

- (NSString *)md5;
+ (NSString *)md5_stringForString:(NSString *)string;

@end
