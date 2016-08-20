# CSNetworking
基于 AFNetworking 的网络封装, 数据解析, 模型转换, 以及业务处理等集于一身。
    
    
## 依赖项
1. AFNetworking  
2. MJExtension   (可删除可替换)
   

## CocoaPods 安装
pod 'CSNetworking', '~> 1.0.0'
  
    
    
## MVC 的使用方法 
Request
```
#pragma mark - 获取城市列表
+ (void)getUserAddressListWithUserID:(NSInteger)userID resultBlock:(RequestResponse)resultBlock {
    NSDictionary *parame = @{@"uid" : [NSString stringWithFormat:@"%ld", userID]};
    [CSNetworking GET:@"get" parameters:parame networkBlock:^(CSCommonResult * result, id responseObject) {
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
    [CSMineRequest getUserAddressListWithUserID:1228 resultBlock:^(CSAnalyzedResult * result, id object) {
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
Controller.m
```
- (void)viewDidLoad {
    // 初始化试图
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = self.view.bounds;
    tableView.dataSource = self.viewModel;
    tableView.delegate = self;
    self.viewModel.tableView = tableView;
    [self.view addsubView:tableView];

    // 执行试图命令
    [self.viewModel.addressRequest execute:nil];
}
```
     
     
ViewModel.h
```
@interface HomeViewModel : NSObject<UITableViewDataSource>
/// 地址列表的请求
@property (nonatomic, strong, redonly) RACCommand *addressRequest;
/// 地址的模型数组
@property (nonatomic, strong, redonly) NSMutableArray<AddressModel *> *addressArr;
/// 控制器中的 tableView
@property (nonatomic, strong) UITableView *tableView; 
@end
```

ViewModel.m
```
- (instancetype)init {
    if (self = [super init]) {
        [self setupCommand];
    }
    return self;
}

- (void)setupCommand {
    _addressRequest = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [CSNetworking GET:@"app/city/cityList" parameters:nil networkBlock:^(CSCommonResult *result, id responseObject) {
                [CSResponseTool analyzeDataWithResult:result response:responseObject modelClass:[AddressModel class]  analyzedBlock:^(CSAnalyzedResult *result, id data) {
                    if (result.resultCode == CS_RESULT_SUCCESS) {
                            [subscriber sendNext:data];
                            [subscriber sendCompleted];
                    }
                    if (!data) {
                        // [self.tableView showNoData];
                    }else if (networkError) {
                        // [self.tableView showNetworkError];
                    }
                }];
            }];
            return nil;
        }];
        return signal;
    }];
    
    [_addressRequest.executionSignals.switchToLatest subscribeNext:^(id x) {
        _addressArr = x;
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.addressArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    AddressModel *model = self.addressArr[indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}
```

## 详情请查看 Demo

