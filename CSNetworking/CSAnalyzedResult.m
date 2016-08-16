//
//  CSAnalyzedResult.m
//  ChiefSteward
//
//  Created by CoderXSLee on 16/6/3.
//  Copyright © 2016年 李雪松. All rights reserved.
//

#import "CSAnalyzedResult.h"
#import "CSTip.h"

@implementation CSAnalyzedResult

#pragma mark - class method

+ (instancetype)resultWithResponse:(id)response
{
    CSAnalyzedResult *analyzedResult = [[self alloc] init];
    if (response != nil && response != [NSNull null] && [response isKindOfClass:[NSDictionary class]]) {
        NSInteger code = [[response valueForKey:@"code"] integerValue];
        NSString *msg = [response objectForKey:@"msg"];
        // 关键结果码手动映射
        if (code == 200) {
            analyzedResult.resultCode = CS_RESULT_SUCCESS;
            analyzedResult.resultDesc = [msg isEqualToString:@""] ? msg : @"请求成功";
        }
        else if (code == 250) {
            analyzedResult.resultCode = CS_RESULT_EMPTY;
            analyzedResult.resultDesc = [msg isEqualToString:@""] ? msg : @"请求成功,数据为空";
        }else {
            analyzedResult.resultCode = code ? code : 0;
            analyzedResult.resultDesc = @"未知的code";
            NSLog(@"这里应该处理什么东西？？？？？？？？？？？");
        }
    }
    return analyzedResult;
}

+ (BOOL)isExposedToUser:(int)resultCode
{
    BOOL bExposedToUser = NO;
    // -100 的结果码需要直接面向用户 后台真傻比 -100 代表所有情况了。 傻逼
    if (resultCode == -100 || resultCode == -1000 || resultCode == -1001) {
        bExposedToUser = YES;
    }
    return bExposedToUser;
}

+ (void)show:(NSString *)resultDesc
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // 统一显示结果信息的调用
        [CSTip showHint:resultDesc];
    });
}

- (void)show
{
    [[self class] show:self.resultDesc];
}

@end
