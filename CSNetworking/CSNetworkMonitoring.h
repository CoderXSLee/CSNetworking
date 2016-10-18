//
//  CSNetworkMonitoring.h
//  ChiefSteward
//
//  Created by CoderXSLee on 16/5/7.
//  Copyright © 2016年 李雪松. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSSingleton.h"

typedef NS_ENUM(NSInteger, CSNetworkStatus) {
    /// 无网络
    CS_NETWORK_STATUS_NONE = 0,
    /// WiFi 网络
    CS_NETWORK_STATUS_WiFi = 1,
    /// 手机网
    CS_NETWORK_STATUS_WWAN = 2,
    
};

@interface CSNetworkMonitoring : NSObject

/**
 *  启动网络监听
 */
- (void)startMonitoring;

/**
 *  获取网络的状态
 *
 *  @return 返回网络的状态
 */
- (CSNetworkStatus)getNetworkStatus;

/**
 *  获取网络的状态描述
 *
 *  @return 返回网络的状态描述
 */
- (NSString *)getNetworkStatusDescription;

/**
 *  获取网络的状态描述 为崩溃上报
 *
 *  @return 返回网络的状态描述 为崩溃上报
 */
//- (NSString *)getNetworkStatusDescriptionForExceptionCache;

@end



/**
 *  单利方法的实现
 */
@interface CSNetworkMonitoring ()

sharedInstanceH

@end
