//
//  CSAnalyzedResult.h
//  ChiefSteward
//
//  Created by CoderXSLee on 16/6/3.
//  Copyright © 2016年 李雪松. All rights reserved.
//

#import "CSCommonResult.h"

/// 业务层结果类
@interface CSAnalyzedResult : CSCommonResult

/**
 *  通过返回的报文数据生成结果对象
 *
 *  @param data 报文数据
 *
 *  @return 结果对象
 */
+ (instancetype)resultWithResponse:(id)response;

/**
 *  判断指定结果码是否面向用户
 *
 *  @param resultCode 结果码
 *
 *  @return YES-面向用户 NO-内部消化
 */
+ (BOOL)isExposedToUser:(int)resultCode;

/**
 *  显示当前的结果描述
 */
- (void)show;

/**
 *  显示指定的结果描述
 *
 *  @param resultDesc 结果描述信息
 */
+ (void)show:(NSString *)resultDesc;

@end