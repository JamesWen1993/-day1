//
//  LocViewController.m
//  项目二day1
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "LocViewController.h"
#import "DataService.h"
#import "UIImageView+WebCache.h"

@interface LocViewController ()

@end

@implementation LocViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.初始化子视图
    [self _createTable];
    // 2.定位
    _locationManager = [[CLLocationManager alloc]init];
    
    if (kVersion > 8.0) {
        // 请求允许定位
        [_locationManager requestWhenInUseAuthorization];
    }
    // 设置请求的准确度
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    _locationManager.delegate = self;
     // 开始定位
    
    [_locationManager startUpdatingLocation];
}

- (void)_createTable {
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"locCell"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    [self.view addSubview:_tableView];
    
}

// 开始加载网络
- (void)loadNearByPoisWithlon:(NSString *)lon lat:(NSString *)lat{
    // 01配置参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:lon forKey:@"long"];//经度
    [params setObject:lat forKey:@"lat"];//纬度
    [params setObject:@30 forKey:@"count"];//加载数量
    
    //请求数据
    
    //获取附近商家
    __weak LocViewController *weakS = self;
    [DataService requestAFUrl:nearby_pois httpMethod:@"GET" params:params data:nil block:^(id result) {
        NSArray *pois = [result objectForKey:@"pois"];
        NSMutableArray *dataList = [NSMutableArray array];
        for (NSDictionary *dic in pois) {
            // 创建商圈模型对象
            LocModel *poi = [[LocModel alloc]initWithDataDic:dic];
            [dataList addObject:poi];
            
        }
        __strong LocViewController *strongS = weakS;
        
        strongS.dataList = dataList;
        [_tableView reloadData];
        
    }];
    
    
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //停止定位
    [manager stopUpdatingLocation];
    
    // 获取当前请求的位置
    CLLocation *location = [locations lastObject];
    
    NSString *lon = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    NSString *lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    // 开始加载网络
    [self loadNearByPoisWithlon:lon lat:lat];
}



#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"locCell" forIndexPath:indexPath];
    // 获取当前单元格对应的商圈对象
    LocModel *poi = self.dataList[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:poi.icon]placeholderImage:[UIImage imageNamed:@"004"]];
    cell.textLabel.text = poi.title;
    return cell;
}

- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
