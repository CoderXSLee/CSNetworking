//
//  CommonResult.m
//  ChiefSteward
//
//  Created by CoderXSLee on 16/4/6.
//  Copyright © 2016年 李雪松. All rights reserved.
//

#import "CSCommonResult.h"

@implementation CSCommonResult

- (instancetype)init
{
    if (self = [super init])
    {
        self.resultCode = CS_RESULT_SUCCESS;
        self.resultDesc = @"";
    }
    
    return self;
}

- (instancetype)initWithData:(int)resultCode resultDesc:(NSString *)resultDesc
{
    if (self = [self init]) {
        self.resultCode = resultCode;
        self.resultDesc = resultDesc;
    }
    return self;
}

- (BOOL)isExposedToUser
{
    return [[self class] isExposedToUser:self.resultCode];
}

#pragma mark - class method
+ (BOOL)isExposedToUser:(int)resultCode
{
    return NO;
}

+ (instancetype)resultWithResponse:(id)response
{
    // TODO
    CSCommonResult *commonResult = [[self alloc] init];
    if (response != nil && response != [NSNull null] && [response isKindOfClass:[NSDictionary class]]) {
        commonResult.resultCode = [response[@"code"] integerValue];
        commonResult.resultDesc = response[@"msg"];
    }
    return commonResult;
}

+ (instancetype)resultWithCode:(int)resultCode description:(NSString *)description;
{
    return [[self alloc] initWithData:resultCode resultDesc:description];
}



@end