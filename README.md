# CSNetworking
基于 AFNetworking 的网络封装, 数据解析, 模型转换, 以及业务处理等集于一身。
  
## 依赖项
1. AFNetworking  
2. MJExtension   (可删除可替换)

## MVC 的使用方法 
#### 详情请看Demo

Request
```
#pragma mark - 获取城市列表
+ (void)getUserAddressListWithUserID:(NSInteger)userID resultBlock:(RequestResponse)resultBlock {
    NSDictionary *parame = @{@"uid" : [NSString stringWithFormat:@"%ld", userID]};
    [CSNetworking GET:@"get" parameters:parame networkBlock:^(CSCommonResult * _Nullable result, id  _Nullable responseObject) {
        // 返回的 data 是一个数组，里面是 CSAddressModel
        [CSResponseTool analyzeDataWithResult:result response:responseObject modelClass:[CSAddressModel class] analyzedBlock:^(CSAnalyzedResult * _Nullable result, id  _Nullable data) {
            if (resultBlock) { resultBlock(result, data); }
        }];
    }];
}

@end
```

ViewController
```
- (void)requestUserAddressList {
    [CSMineRequest getUserAddressListWithUserID:1228 resultBlock:^(CSAnalyzedResult * _Nullable result, id  _Nullable object) {
        if (result.resultCode == CS_RESULT_SUCCESS) {
            NSLog(@"%@", object);
            if (_page == 1) {
                [_addressAry removeAllObjects];
            }
            [_addressAry addObjectsFromArray:object];
        }
        if (_addressAry.count < 1) {
            if (result.resultCode == networkError) {
                // 显示无网络界面
                [_tableView showNoDataNetworkError];
            }else {
                // 显示无数据界面
                [_tableView showNoDataWithTitle:@"暂时数据"];
            }
        }
        [_tableView reloadData];
        
        // 判断结果码以及结果描述是否面向用户
        if ([result isExposedToUser]) {
            [result show];
        }
    }];
}
```
## RAC + MVVM 中的使用方法

