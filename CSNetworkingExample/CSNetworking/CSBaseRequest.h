//
//  CSBaseRequest.h
//  ChiefSteward
//
//  Created by CoderXSLee on 16/5/12.
//  Copyright © 2016年 李雪松. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSNetworking.h"

/** 请求结果的回调 */
typedef void (^RequestResponse)(CSAnalyzedResult *result, id object);

@interface CSBaseRequest : NSObject

@end
