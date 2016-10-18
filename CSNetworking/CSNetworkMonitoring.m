//
//  CSNetworkMonitoring.m
//  ChiefSteward
//
//  Created by CoderXSLee on 16/5/7.
//  Copyright © 2016年 李雪松. All rights reserved.
//

#import "CSNetworkMonitoring.h"
#import <AFNetworking/AFNetworking.h>
#import "Reachability.h"
#import "CSTip.h"


NSString * const _kCSNetworkStringWWAN                =       @"手机网络";
NSString * const _kCSNetworkStringWiFi                =       @"WiFi网络";
NSString * const _kCSNoneNetworkString                =       @"无网络连接";

@interface CSNetworkMonitoring ()
{
    int _count;
}
/** AFNetworking 网络监听的单例 */
@property (nonatomic, strong) Reachability *reachabilityManager;

@end

@implementation CSNetworkMonitoring

sharedInstanceM

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (Reachability *)reachabilityManager {
    if (_reachabilityManager == nil) {
        _reachabilityManager = [Reachability reachabilityWithHostName:@"www.baidu.com"];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
    }
    return _reachabilityManager;
}

// 开始监听网络状态
- (void)startMonitoring
{
    // 该方法不可以放在子线程中
    // 否则通知绑定的 @selector(reachabilityChanged:) 不会被调用
    [self.reachabilityManager startNotifier];
}

// 网络状态码
- (CSNetworkStatus)getNetworkStatus
{
    CSNetworkStatus networkStatu = CS_NETWORK_STATUS_NONE;
    NetworkStatus status = NotReachable;
    status = self.reachabilityManager.currentReachabilityStatus;
    
    if (status == NotReachable) {
        networkStatu = CS_NETWORK_STATUS_NONE;
    }else if (status == ReachableViaWWAN) {
        networkStatu = CS_NETWORK_STATUS_WWAN;
    }else if (status == ReachableViaWiFi){
        networkStatu = CS_NETWORK_STATUS_WiFi;
    }else {
        networkStatu = CS_NETWORK_STATUS_NONE;
    }
    return networkStatu;
}

// 网络状态描述
- (NSString *)getNetworkStatusDescription
{
    NSString *des = @"";
    NetworkStatus status = NotReachable;
    status = self.reachabilityManager.currentReachabilityStatus;
    if (status == NotReachable) {
        des = _kCSNoneNetworkString;
    }else if (status == ReachableViaWWAN) {
        des = _kCSNetworkStringWWAN;
    }else if (status == ReachableViaWiFi){
        des = _kCSNetworkStringWiFi;
    }else {
        des = _kCSNoneNetworkString;
    }
    return des;
}

/// 网络状态改变的回调
- (void)reachabilityChanged:(NSNotification *)notification
{
    Reachability *currentReeach = [notification object];
    NSParameterAssert([currentReeach isKindOfClass:[Reachability class]]);
    
    NetworkStatus status = currentReeach.currentReachabilityStatus;
    
    CSNetworkStatus networkStatus = CS_NETWORK_STATUS_NONE;
    NSString *statusString  = nil;
    
    
    if (status == NotReachable) {
        networkStatus = CS_NETWORK_STATUS_NONE;
        statusString = _kCSNoneNetworkString;
    }
    if (status == ReachableViaWWAN) {
        networkStatus = CS_NETWORK_STATUS_WWAN;
        statusString = _kCSNetworkStringWWAN;
    }
    if (status == ReachableViaWiFi){
        networkStatus = CS_NETWORK_STATUS_WiFi;
        statusString = _kCSNetworkStringWiFi;
    }
    
    if (_count > 1) {
        [self showNetworkStatus:status];
    }
    _count++;
    
}

// 网络改变的提示
- (void)showNetworkStatus:(NetworkStatus)status {
    if (status == NotReachable) {
        [CSTip showHint:@"无网络连接"];
    }else if (status == ReachableViaWWAN) {
        [CSTip showHint:@"已切换手机网络"];
    }else if (status == ReachableViaWiFi){
        [CSTip showHint:@"已切换WiFi网络"];
    }
}

@end
