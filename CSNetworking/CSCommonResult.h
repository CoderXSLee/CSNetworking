//
//  CommonResult.h
//  ChiefSteward
//
//  Created by Apple on 16/4/6.
//  Copyright © 2016年 李雪松. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 通用结果码
typedef NS_ENUM(NSInteger, CSResultCode) {
    /// 成功为空
    CS_RESULT_EMPTY = 250,
    /// 请求成功
    CS_RESULT_SUCCESS = 200,
    /// 请求失败
    CS_RESULT_FAILURE = 400,
    /// 网络出现错误
    CSNetworkError = 100,
//    /// 网络连接超时
//    CSNetworkTimedOut = -1,
//    /// URL无效
//    CSNetworkUnsupportedURL = -2,
//    /// 请求失败 (bad request http code = 400)
//    CSNetworkBadServerResponse = -11,
//    /// 无网络连接
//    CSNetworkNotConnectedToInternet = -9,
};

@interface CSCommonResult : NSObject

/** 结果码 */
@property (nonatomic, assign) CSResultCode resultCode;

/** 结果描述 */
@property (nonatomic, strong) NSString *resultDesc;


/// 结果描述是否 面向用户
- (BOOL)isExposedToUser;
+ (BOOL)isExposedToUser:(int)resultCode;
+ (instancetype)resultWithResponse:(id)response;
+ (instancetype)resultWithCode:(int)resultCode description:(NSString *)description;

@end
