//
//  CSNetworking.h
//  ChiefSteward
//
//  Created by CoderXSLee on 16/5/3.
//  Copyright © 2016年 李雪松. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSResponseTool.h"
#import "CSAnalyzedResult.h"
#import "LSSingleton.h"

/// 网络请求的回调
typedef void (^NetworkBlock) (CSCommonResult *result, id responseObject);


@interface CSNetworking : NSObject

/// GET 请求 适用于奇葩传参方式 例如: www.baidu.com/getUserAddressList/1207 (1207为UID)
+ (void)GET:(NSString *)urlString isCache:(BOOL)isCache networkBlock:(NetworkBlock)networkBlock;

/// GET 请求 适用于 REST URI 例如: www.baidu.com/getUserAddressList/?userID=1207
+ (void)GET:(NSString *)urlString parameters:(NSDictionary *)parameters isCache:(BOOL)isCache
networkBlock:(NetworkBlock)networkBlock;

/// POST 请求
+ (void)POST:(NSString *)urlString parameters:(NSDictionary *)parameters isCache:(BOOL)isCache
networkBlock:(NetworkBlock)networkBlock;

/// 上传文件post请求
+ (void)POST:(NSString *)urlString parameters:(NSDictionary *)parameters data:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType networkBlock:(NetworkBlock)networkBlock;

/// PUT 请求
+ (void)PUT:(NSString *)urlString parameters:(NSDictionary *)parameters isCache:(BOOL)isCache
networkBlock:(NetworkBlock)networkBlock;

/// DELETE 请求
+ (void)DELETE:(NSString *)urlString parameters:(NSDictionary *)parameters
  networkBlock:(NetworkBlock)networkBlock;

- (void)setBaseURLString:(NSString *)urlString;
- (void)setTimeoutInterval:(NSInteger)TimeoutInterval;
- (void)setHeaderValue:(NSString *)value forKey:(NSString *)key;
- (void)AcceptableContentTypes:(NSSet *)acceptableContentTypes;
- (void)addParameterValue:(id)value forKey:(NSString *)key;

@end


/// 单例
@interface CSNetworking (Singleton)
sharedInstanceH
@end
