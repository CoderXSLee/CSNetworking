//
//  ViewController.m
//  CSNetworkingExample
//
//  Created by CoderXSLee on 16/8/15.
//  Copyright © 2016年 CoderXSLee. All rights reserved.
//

#import "ViewController.h"
#import "CSNetworking.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     NSString *userToken = @"123123123"; //[CSManager sharedInstance].userToken;
    
//     [[CSNetworking sharedInstance] setValue:userToken forHTTPHeaderField:@"userToken"];
    
    [[CSNetworking sharedInstance] setHeaderValue:userToken forKey:@"userToken"];
    
    [CSNetworking GET:@"cache" isCache:NO networkBlock:^(CSCommonResult *result, id responseObject) {
        [CSResponseTool analyzeDataWithResult:result response:responseObject modelClass:nil analyzedBlock:^(CSAnalyzedResult *result, id data) {
            if (result.resultCode == CS_RESULT_SUCCESS) {
                NSLog(@"%@", data);
            }
            if (!data) {
                if (result.resultCode == CSNetworkError) {
                    NSLog(@"网络链接失败");
                }
            }
            // 判断结果码 结果详情 是否面向用户
            if ([result isExposedToUser]) {
                [result show];
            }
        }];
    }];
    
    /*
    
    [CSNetworking GET:@"cache" parameters:@{@"key":@"value"} networkBlock:^(CSCommonResult *result, id responseObject) {
        [CSResponseTool analyzeDataWithResult:result response:responseObject modelClass:nil analyzedBlock:^(CSAnalyzedResult *result, id data) {
            if (result.resultCode == CS_RESULT_SUCCESS) {
                NSLog(@"%@", data);
            }
        }];
    }];
    
    [CSNetworking POST:@"postUrl" parameters:@{@"":@""} networkBlock:^(CSCommonResult *result, id responseObject) {
        [CSResponseTool analyzeDataWithResult:result response:responseObject modelClass:nil analyzedBlock:^(CSAnalyzedResult *result, id data) {
            if (result.resultCode == CS_RESULT_SUCCESS) {
                NSLog(@"%@", data);
            }
        }];
    }];
     
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
