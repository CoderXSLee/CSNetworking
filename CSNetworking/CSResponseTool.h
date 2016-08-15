//
//  CSResponseTool.h
//  ChiefSteward
//
//  Created by CoderXSLee on 16/6/3.
//  Copyright © 2016年 李雪松. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CSCommonResult, CSAnalyzedResult;

/// 解析结果的回调
typedef void (^AnalyzedBlock)(CSAnalyzedResult *result, id data);

@interface CSResponseTool : NSObject


// 根据 url 跟 parameter 获取 缓存的 key
+ (NSString *)getCacheKeyWithUrlString:(NSString *)url
                            parameters:(NSDictionary *)parameters;

/**
 *  将请求数据解析为业务数据
 *
 *  @param result            请求结果
 *  @param responseData      请求数据
 *  @param modelClass        业务数据模型
 *  @param analyzeResultBack 解析完成后的回调通知
 */
+ (void)analyzeDataWithResult:(CSCommonResult *)result
                     response:(id)response
                   modelClass:(Class)modelClass
                analyzedBlock:(AnalyzedBlock)analyzedBlock;


@end
