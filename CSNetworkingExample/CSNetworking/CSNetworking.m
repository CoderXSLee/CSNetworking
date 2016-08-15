//
//  CSNetworking.m
//  ChiefSteward
//
//  Created by CoderXSLee on 16/5/3.
//  Copyright © 2016年 李雪松. All rights reserved.
//

#import "CSNetworking.h"
#import "AFNetworking.h"
#import "CSResponseTool.h"
#import "CSNetworkMonitoring.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "YYCache.h"

// 1 == 线上环境  0 == 测试环境
#if 1   // 线上环境
#define baseURLString @"http://192.168.1.253:8084/v2/"
#else // 测试环境
#define baseURLString @"http://httpbin.org/"
#endif

@interface CSNetworking ()
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end

@implementation CSNetworking

static AFHTTPSessionManager *_sessionManager;

#pragma mark - Public Methods
/// 适用于奇葩传参方式 例如: www.baidu.com/getUserAddressList/1207 (1207为UID)
+ (void)GET:(NSString *)urlString networkBlock:(NetworkBlock)networkBlock {
    
    /// md5 url append parameters
    NSString *md5Key = [CSResponseTool getCacheKeyWithUrlString:urlString parameters:nil];
    
    /// 无网络显示缓存数据
    [CSNetworking getCacheDataWithCacheKey:md5Key networkBlock:networkBlock];
    
    /// 有网络才会来这里
    CSNetworking *networking = [CSNetworking sharedInstance];
    [networking.sessionManager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"接口: %@%@ 以【GET】方式->请求成功!", baseURLString, urlString);
        [CSNetworking cuccessWithBlock:networkBlock response:responseObject];
        
        // 请求成功缓存数据
        [CSNetworking cacheDataWithUrl:urlString response:responseObject];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"接口: %@%@ 以【GET】方式->请求失败!", baseURLString, urlString);
        NSLog(@"parameters 在 url后面");
        [CSNetworking failureWithBlock:networkBlock error:error];
    }];
}

/// 适用于 REST URI 例如: www.baidu.com/getUserAddressList/?userID=1207
+ (void)GET:(NSString *)urlString parameters:(NSDictionary *)parameters networkBlock:(NetworkBlock)networkBlock {
    
    /// md5 url append parameters
    NSString *md5Key = [CSResponseTool getCacheKeyWithUrlString:urlString parameters:parameters];
    
    /// 无网络显示缓存数据
    [CSNetworking getCacheDataWithCacheKey:md5Key networkBlock:networkBlock];
    
    /// 有网络才会来这里
    CSNetworking *networking = [CSNetworking sharedInstance];
    [networking.sessionManager GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"接口: %@%@ 以【GET URI】方式->请求成功!", baseURLString, urlString);
        [CSNetworking cuccessWithBlock:networkBlock response:responseObject];
        // 请求成功缓存数据
        [CSNetworking cacheDataWithUrl:urlString response:responseObject];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"接口: %@%@ 以【GET URI】方式->请求失败!", baseURLString, urlString);
        NSLog(@"parameters = %@", parameters);
        [CSNetworking failureWithBlock:networkBlock error:error];
    }];
}

/// POST 请求
+ (void)POST:(NSString *)urlString parameters:(NSDictionary *)parameters networkBlock:(NetworkBlock)networkBlock {
    
    /// md5 url append parameters
    NSString *md5Key = [CSResponseTool getCacheKeyWithUrlString:urlString parameters:parameters];
    
    /// 无网络显示缓存数据
    [CSNetworking getCacheDataWithCacheKey:md5Key networkBlock:networkBlock];
    
    CSNetworking *networking = [CSNetworking sharedInstance];
    [networking.sessionManager POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"接口: %@%@ 以【POST】方式->请求成功!", baseURLString, urlString);
        [CSNetworking cuccessWithBlock:networkBlock response:responseObject];
        
        // 请求成功缓存数据
        [CSNetworking cacheDataWithUrl:urlString response:responseObject];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"接口: %@%@ 以【POST】方式->请求失败!", baseURLString, urlString);
        NSLog(@"parameters = %@", parameters);
        [CSNetworking failureWithBlock:networkBlock error:error];
    }];
    
}

/// PUT 请求
+ (void)PUT:(NSString *)urlString parameters:(NSDictionary *)parameters networkBlock:(NetworkBlock)networkBlock {
    
    /// md5 url append parameters
    NSString *md5Key = [CSResponseTool getCacheKeyWithUrlString:urlString parameters:parameters];

    /// 无网络显示缓存数据
    [CSNetworking getCacheDataWithCacheKey:md5Key networkBlock:networkBlock];
    
    CSNetworking *networking = [CSNetworking sharedInstance];
    [networking.sessionManager PUT:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"接口: %@%@【PUT】方式->请求成功!", baseURLString, urlString);
        [CSNetworking cuccessWithBlock:networkBlock response:responseObject];
        
        // 请求成功缓存数据
        [CSNetworking cacheDataWithUrl:urlString response:responseObject];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"接口: %@%@ 以【PUT】方式->请求失败!", baseURLString, urlString);
        NSLog(@"parameters = %@", parameters);
        [CSNetworking failureWithBlock:networkBlock error:error];
    }];
}

/// DELETE 请求
+ (void)DELETE:(NSString *)urlString parameters:(NSDictionary *)parameters networkBlock:(NetworkBlock)networkBlock {
    
    CSNetworking *networking = [CSNetworking sharedInstance];
    [networking.sessionManager DELETE:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"接口: %@%@ 以【DELETE】方式->请求成功!", baseURLString, urlString);
        [CSNetworking cuccessWithBlock:networkBlock response:responseObject];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"接口: %@%@ 以【DELETE】方式->请求失败!", baseURLString, urlString);
        NSLog(@"parameters = %@", parameters);
        [CSNetworking failureWithBlock:networkBlock error:error];
    }];
}


#pragma mark - Private Methods 私有方法内部使用

/// 请求成功的处理
+ (void)cuccessWithBlock:(NetworkBlock)block response:(id)response {
    CSCommonResult *result = [CSCommonResult resultWithCode:CS_RESULT_SUCCESS description:nil];
    // NSLog(@"responseObject = %@", [CSResponseTool requestDispose:response]);
    if (block) { block(result, response); }
}

/// 请求失败的处理
+ (void)failureWithBlock:(NetworkBlock)block error:(NSError *)error {
    // NSLog(@"error = %@", error);
    CSCommonResult *result = [CSCommonResult resultWithCode:CS_RESULT_FAILURE description:@"请求失败"];
    if (block) { block(result, error); }
}


// 统一的获取缓存数据
+ (void)getCacheDataWithCacheKey:(NSString *)cacheKey networkBlock:(NetworkBlock)networkBlock {
    // 如果没有网络取缓存
    if ([[CSNetworkMonitoring sharedInstance] getNetworkStatus] == CS_NETWORK_STATUS_NONE) {
        // 设置 YYCache 属性
        YYCache *cache = [[YYCache alloc] initWithName:@"networkCache"];
        cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
        cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
        id cacheData = [cache objectForKey:cacheKey];
        if (cacheData) {
            CSCommonResult *result = [CSCommonResult resultWithCode:CSNetworkError description:nil];
            if (networkBlock) { networkBlock(result, cacheData); }
            return;
        }else {
            CSCommonResult *result = [CSCommonResult resultWithCode:CSNetworkError description:nil];
            NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:NSURLErrorUnknown userInfo:nil];
            if (networkBlock) { networkBlock(result, error); }
            return;
        }
    }
}

/// 统一的数据缓存处理
+ (void)cacheDataWithUrl:(NSString *)urlString response:(id)response {
    // 设置 YYCache 属性
    YYCache *cache = [[YYCache alloc] initWithName:@"networkCache"];
    cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    NSString *md5Key = [CSResponseTool getCacheKeyWithUrlString:urlString parameters:nil];
    [cache setObject:response forKey:md5Key];
}

#pragma mark - Getters And Setters 存取
- (AFHTTPSessionManager *)sessionManager {
    
    // 奇葩！为啥后台非要把token放在 header 心里骂了一万遍
    // 为了解决首次安装使用时获取到 userToken 后
    // 在app没有销毁掉时，之后的请求时 header 中 userToken依然为空的情况
    // 以及不想在每一种请求中都去判断、设置 header 中的 userToken
    // 也不想暴露 _sessionManager 所以将userToken放在这里处理
    // 顺便提一下、搞不懂，各种奇葩玩法 真奇葩！
    // 还有 get 请求传参还这样玩 http://www.xxx.com/getUserAddress/10023 其中 10023 是uid
    
    // NSString *userToken = [CSManager sharedInstance].userToken;
    // [_sessionManager.requestSerializer setValue:userToken forHTTPHeaderField:@"userToken"];
    
    if (_sessionManager == nil) {
        NSURL *baseURL = [NSURL URLWithString:baseURLString];
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        // 设定请求超时 (若不设置 则 默认 60 秒)
        _sessionManager.requestSerializer.timeoutInterval = 30;
        // 安全策略
        _sessionManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        // 申明请求的数据是json类型
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        // 设置请求头内容类型
        // NSString *userToken = [CSManager sharedInstance].userToken;
        // [_sessionManager.requestSerializer setValue:userToken forHTTPHeaderField:@"userToken"];
        // [_sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
        
        // 当使用AF发送网络请求时,只要有网络操作,那么在状态栏(电池条)wifi符号旁边显示  菊花提示
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        
        // 设置可接受的内容类型
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [_sessionManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/html", @"text/css", @"text/javascript", nil]];
    }
    return _sessionManager;
}

@end


/// 单例的实现
@implementation CSNetworking (Singleton)
sharedInstanceM
@end
