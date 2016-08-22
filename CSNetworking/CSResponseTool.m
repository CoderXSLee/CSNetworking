//
//  CSResponseTool.m
//  ChiefSteward
//
//  Created by CoderXSLee on 16/6/3.
//  Copyright © 2016年 李雪松. All rights reserved.
//

#import "CSResponseTool.h"
#import "CSAnalyzedResult.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "NSString+Encrypt.h"

@implementation CSResponseTool

// 统一的业务解析方法
+ (void)analyzeDataWithResult:(CSCommonResult *)result response:(id)response modelClass:(Class)modelClass analyzedBlock:(AnalyzedBlock)analyzedBlock {
    
    CSAnalyzedResult *analyzeResult = nil;
    id data = nil;
    
    // 请求成功的处理
    if (result.resultCode == CS_RESULT_SUCCESS) {
        
        // Json -> Dictionary
        data = [CSResponseTool requestDispose:response];
        
        // 处理业务层的结果码
        analyzeResult = [CSAnalyzedResult resultWithResponse:data];
        
        @try {
            if (data != nil && data != [NSNull null] && [data isKindOfClass:[NSDictionary class]]) {
                // 如果请求的数据 有 data 这个 key
                if ([[data allKeys] containsObject:@"data"]) {
                    data = [data objectForKey:@"data"];
                }
                // 如果 modelClass != nil 则进行 字典 -> 模型 解析
                if (data != nil && data != [NSNull null] && modelClass != nil) {
                    if ([data isKindOfClass:[NSDictionary class]]) {
                        data = [modelClass mj_objectWithKeyValues:data];
                    }else if ([data isKindOfClass:[NSArray class]] && modelClass != nil) {
                        data = [modelClass mj_objectArrayWithKeyValuesArray:data];
                    }
                }
            }
        } @catch (NSException *exception) {
            // 解析失败
            NSLog(@"CSResponseTool data 解析失败: %@", [exception description]);
        } @finally {
            
        }
        
    }
    
    // 请求失败
    if (result.resultCode == CS_RESULT_FAILURE) {
        // 判断 response 是否为 NSError 是否为网络异常等
        NSString *resultDesc;
        CSResultCode resultCode;
        if (response != nil && response != [NSNull null] && [response isKindOfClass:[NSError class]]) {
            NSError *error = response;
            if (error.code == NSURLErrorTimedOut) {
                resultDesc = @"请求超时";
                resultCode = CS_RESULT_FAILURE;
            }else if (error.code == NSURLErrorUnsupportedURL) {
                resultDesc = @"无效的URL";
                resultCode = CS_RESULT_FAILURE;
            }else if (error.code == NSURLErrorBadServerResponse) {
                CSCommonResult *commonResult = [CSResponseTool requestError:response];
                resultCode = commonResult.resultCode;
                resultDesc = commonResult.resultDesc;
            }else if (error.code == NSURLErrorNotConnectedToInternet) {
                resultDesc = @"无网络连接";
                resultCode = CSNetworkError;
            }else if (error.code == NSURLErrorUnknown){
                resultDesc = @"请求失败";
                resultCode = CSNetworkError;
            }else {
                resultDesc = @"请求失败";
                resultCode = CSNetworkError;
            }
        }
        // 统一处理结果码以及描述
        analyzeResult = [CSAnalyzedResult resultWithCode:resultCode description:resultDesc];
    }
    
    
    
    
    
    // 无网络显示缓存的处理 (这里代码并不完全通用，只用在本项目)
    // 有网络时获取最新数据，展示数据，然后磁盘缓存
    // 缓存的数据只在无网络时使用 ------ 开始
    if ((result.resultCode == CSNetworkError || result.resultCode == CS_RESULT_FAILURE) && [response isKindOfClass:[NSData class]]) {
        // Json -> Dictionary
        data = [CSResponseTool requestDispose:response];
        analyzeResult = [CSAnalyzedResult resultWithCode:CSNetworkError description:@"网络连接失败"];
        @try {
            if (data != nil && data != [NSNull null] && [data isKindOfClass:[NSDictionary class]]) {
                // 如果请求的数据 有 data 这个 key
                if ([[data allKeys] containsObject:@"data"]) {
                    data = [data objectForKey:@"data"];
                }
                // 如果 modelClass != nil 则进行 字典 -> 模型 解析
                if (data != nil && data != [NSNull null] && modelClass != nil) {
                    if ([data isKindOfClass:[NSDictionary class]]) {
                        data = [modelClass mj_objectWithKeyValues:data];
                    }else if ([data isKindOfClass:[NSArray class]] && modelClass != nil) {
                        data = [modelClass mj_objectArrayWithKeyValuesArray:data];
                    }
                }
            }
        } @catch (NSException *exception) {
            // 解析失败
            NSLog(@"CSResponseTool data 解析失败: %@", [exception description]);
        } @finally {
            
        }
    }
    // 无网络显示缓存的处理 (这里代码并不完全通用，只用在本项目)
    // 有网络时获取最新数据，展示数据，然后磁盘缓存
    // 缓存的数据只在无网络时使用  ----- 结束
    

    
    // 成功与失败的回调
    if (analyzedBlock) {
        analyzedBlock(analyzeResult, data);
    }
}


// 请求失败的错误结果码信息 http bad request code = 400 时
+ (CSCommonResult *)requestError:(NSError *)error {
    NSData *data = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
    NSDictionary *dict = [CSResponseTool requestDispose:data];
    CSCommonResult *result = [CSCommonResult resultWithResponse:dict];
    return result;
}

// 根据 url 跟 parameter 获取 缓存的 key
+ (NSString *)getCacheKeyWithUrlString:(NSString *)url parameters:(NSDictionary *)parameters {
    
    // 处理空格
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    if (!parameters) {
        return [url md5];
    }
    
    NSMutableArray *paramArray = [NSMutableArray array];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        // 接收key
        NSString *finalKey = [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        // 接收值
        NSString *finalValue = [obj stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *part =[NSString stringWithFormat:@"%@=%@",finalKey, finalValue];
        [paramArray addObject:part];
    }];
    
    NSString *parameterString = [paramArray componentsJoinedByString:@"&"];
    parameterString = parameterString ? parameterString : @"";
    NSString *cacheKey = [NSString stringWithFormat:@"%@?%@",url, parameterString];
    return [cacheKey md5];
}

#pragma mark Networking Data Dispose Method 网络请求的数据处理
/// 网络结果集处理 JSON -> NSDictionary
+ (NSDictionary *)requestDispose:(id)responseObject {
    // 转换成 字符串
    NSString *decodeJson = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    
    if (!decodeJson) {
        NSAssert(@" responseJSON ===> %@", decodeJson);
        return nil;
    }
    
    decodeJson = [self deleteSpecialCodeWithStr:decodeJson];
    // NSLog(@"\n====== responseJson =======\n%@ \n===========================\n", decodeJson);
    // 字符串转成流
    NSData *data = [decodeJson dataUsingEncoding:NSUTF8StringEncoding];
    // 转换字典
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return dictionary;
}

#pragma mark -- 处理json格式的字符串中的换行符、回车符
+ (NSString *)deleteSpecialCodeWithStr:(NSString *)string {
    NSString *str;
    str = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    str = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    str = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
    return str;
}

@end
