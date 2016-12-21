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
        self.resultCode = CS_RESULT_FAILURE;
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

// 请求失败的错误结果码信息 http bad request code = 400 时 解析 error
+ (instancetype)resultWithResponse:(id)response
{
    // TODO
    CSCommonResult *commonResult = [[self alloc] init];
    if (response != nil && response != [NSNull null] && [response isKindOfClass:[NSDictionary class]]) {
        commonResult.resultCode = [response[@"code"] integerValue];
        // commonResult.resultDesc = response[@"msg"];
        commonResult.resultDesc = response[@"error"];
    }else {
        commonResult.resultCode = -100;
        commonResult.resultDesc = @"服务器异常, 请稍后再试";
    }
    return commonResult;
}

+ (instancetype)resultWithCode:(int)resultCode description:(NSString *)description;
{
    return [[self alloc] initWithData:resultCode resultDesc:description];
}



@end
