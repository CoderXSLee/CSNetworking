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

@interface CSNetworking ()

@property (nonatomic, strong) NSMutableDictionary *parame;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation CSNetworking

static NSString *baseURLString;

+ (void)isCache:(BOOL)isCache url:(NSString *)url parame:(NSDictionary *)parame networkBlock:(NetworkBlock)networkBlock {
    if (isCache == NO) {
        return;
    }
    /// md5 url append parameters
    NSString *md5Key = [CSResponseTool getCacheKeyWithUrlString:url parameters:parame];
    
    /// 无网络显示缓存数据
    [self getCacheDataWithCacheKey:md5Key networkBlock:networkBlock];
}

#pragma mark - Public Methods
/// 适用于奇葩传参方式 例如: www.baidu.com/getUserAddressList/1207 (1207为UID)
+ (void)GET:(NSString *)urlString isCache:(BOOL)isCache networkBlock:(NetworkBlock)networkBlock {
    
    CSNetworking *networking = [CSNetworking sharedInstance];
    // 判断网络状态 ，无网络有缓存则取缓存数据。
    [CSNetworking isCache:isCache url:urlString parame:nil networkBlock:networkBlock];
    
    /// 不缓存，有网络才会来这里
    [networking.sessionManager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"接口: %@%@ 以【GET】方式->请求成功!", baseURLString, urlString);
        [CSNetworking cuccessWithBlock:networkBlock response:responseObject];
        
        // 请求成功判断是否进行缓存数据
        [CSNetworking isCache:isCache cacheDataWithUrl:urlString response:responseObject];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"接口: %@%@ 以【GET】方式->请求失败!", baseURLString, urlString);
        NSLog(@"parameters 在 url后面");
        [CSNetworking failureWithBlock:networkBlock error:error];
    }];
}

/// 适用于 REST URI 例如: www.baidu.com/getUserAddressList/?userID=1207
+ (void)GET:(NSString *)urlString parameters:(NSDictionary *)parameters isCache:(BOOL)isCache networkBlock:(NetworkBlock)networkBlock {
    
    CSNetworking *networking = [CSNetworking sharedInstance];
    NSMutableDictionary *parame = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [parame addEntriesFromDictionary:networking.parame];
    // 判断网络状态 ，无网络有缓存则取缓存数据。
    [CSNetworking isCache:isCache url:urlString parame:parame networkBlock:networkBlock];
    /// 不缓存，有网络才会来这里
    [networking.sessionManager GET:urlString parameters:parame progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"接口: %@%@ 以【GET URI】方式->请求成功!", baseURLString, urlString);
        [CSNetworking cuccessWithBlock:networkBlock response:responseObject];
        // 请求成功判断是否进行缓存数据
        [CSNetworking isCache:isCache cacheDataWithUrl:urlString response:responseObject];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"接口: %@%@ 以【GET URI】方式->请求失败!", baseURLString, urlString);
        NSLog(@"parameters = %@", parameters);
        [CSNetworking failureWithBlock:networkBlock error:error];
    }];
}

/// POST 请求
+ (void)POST:(NSString *)urlString parameters:(NSDictionary *)parameters isCache:(BOOL)isCache networkBlock:(NetworkBlock)networkBlock {
    
    CSNetworking *networking = [CSNetworking sharedInstance];
    NSMutableDictionary *parame = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [parame addEntriesFromDictionary:networking.parame];
    
    // 判断网络状态 ，无网络有缓存则取缓存数据。
    [CSNetworking isCache:isCache url:urlString parame:parame networkBlock:networkBlock];
    
    /// 不缓存，有网络才会来这里
    [networking.sessionManager POST:urlString parameters:parame progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"接口: %@%@ 以【POST】方式->请求成功!", baseURLString, urlString);
        [CSNetworking cuccessWithBlock:networkBlock response:responseObject];
        
        // 请求成功判断是否进行缓存数据
        [CSNetworking isCache:isCache cacheDataWithUrl:urlString response:responseObject];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"接口: %@%@ 以【POST】方式->请求失败!", baseURLString, urlString);
        NSLog(@"parameters = %@", parameters);
        [CSNetworking failureWithBlock:networkBlock error:error];
    }];
    
}

/// 上传文件 POST请求
+ (void)POST:(NSString *)urlString parameters:(NSDictionary *)parameters data:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType networkBlock:(NetworkBlock)networkBlock {
    
    CSNetworking *networking = [CSNetworking sharedInstance];
    NSMutableDictionary *parame = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [parame addEntriesFromDictionary:networking.parame];
    
    [networking.sessionManager POST:urlString parameters:parame constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"接口: %@%@ 以【POST】上传方式->请求成功!", baseURLString, urlString);
        [CSNetworking cuccessWithBlock:networkBlock response:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"接口: %@%@ 以【POST】上传方式->请求失败!", baseURLString, urlString);
        NSLog(@"parameters = %@", parameters);
        [CSNetworking failureWithBlock:networkBlock error:error];
        
    }];
}

/// PUT 请求
+ (void)PUT:(NSString *)urlString parameters:(NSDictionary *)parameters isCache:(BOOL)isCache networkBlock:(NetworkBlock)networkBlock {
    
    CSNetworking *networking = [CSNetworking sharedInstance];
    NSMutableDictionary *parame = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [parame addEntriesFromDictionary:networking.parame];
    
    // 判断网络状态 ，无网络有缓存则取缓存数据。
    [CSNetworking isCache:isCache url:urlString parame:parame networkBlock:networkBlock];
    
    /// 不缓存，有网络才会来这里
    [networking.sessionManager PUT:urlString parameters:parame success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"接口: %@%@【PUT】方式->请求成功!", baseURLString, urlString);
        [CSNetworking cuccessWithBlock:networkBlock response:responseObject];
        
        // 请求成功判断是否进行缓存数据
        [CSNetworking isCache:isCache cacheDataWithUrl:urlString response:responseObject];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"接口: %@%@ 以【PUT】方式->请求失败!", baseURLString, urlString);
        NSLog(@"parameters = %@", parameters);
        [CSNetworking failureWithBlock:networkBlock error:error];
    }];
}

/// DELETE 请求
+ (void)DELETE:(NSString *)urlString parameters:(NSDictionary *)parameters networkBlock:(NetworkBlock)networkBlock {
    
    CSNetworking *networking = [CSNetworking sharedInstance];
    NSMutableDictionary *parame = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [parame addEntriesFromDictionary:networking.parame];
    
    [networking.sessionManager DELETE:urlString parameters:parame success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
        }
    }
}

/// 统一的数据缓存处理
+ (void)isCache:(BOOL)isCache cacheDataWithUrl:(NSString *)urlString response:(id)response {
    
    if (isCache == NO) {
        return;
    }
    
    // 设置 YYCache 属性
    YYCache *cache = [[YYCache alloc] initWithName:@"networkCache"];
    cache.memoryCache.shouldRemoveAllObjectsOnMemoryWarning = YES;
    cache.memoryCache.shouldRemoveAllObjectsWhenEnteringBackground = YES;
    NSString *md5Key = [CSResponseTool getCacheKeyWithUrlString:urlString parameters:nil];
    [cache setObject:response forKey:md5Key];
}


#pragma mark - Getters And Setters 存取
- (AFHTTPSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        
        _sessionManager = [AFHTTPSessionManager manager];
        
        //        NSURL *baseURL = [NSURL URLWithString:baseURLString];
        //        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        
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

- (void)setBaseURLString:(NSString *)urlString {
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
}
- (void)setTimeoutInterval:(NSInteger)TimeoutInterval {
    self.sessionManager.requestSerializer.timeoutInterval = TimeoutInterval;
}
- (void)setHeaderValue:(NSString *)value forKey:(NSString *)key {
    [self.sessionManager.requestSerializer setValue:value forHTTPHeaderField:key];
}
- (void)AcceptableContentTypes:(NSSet *)acceptableContentTypes {
    [self.sessionManager.responseSerializer setAcceptableContentTypes:acceptableContentTypes];
}
- (void)addParameterValue:(id)value forKey:(NSString *)key {
    if (_parame == nil) { _parame = [NSMutableDictionary dictionary]; }
    [_parame setValue:value forKey:key];
}

@end

/// 单例的实现
@implementation CSNetworking (Singleton)
sharedInstanceM
@end

