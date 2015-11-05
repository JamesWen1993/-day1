//
//  NearByViewController.m
//  项目二day1
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "NearByViewController.h"
#import "WeiBoAnnotation.h"
#import "WeiboAnnotationView.h"
#import "DataService.h"
#import "WeiboDetailViewController.h"
@interface NearByViewController ()

@end

@implementation NearByViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _createViews];
    
    [self _location];
    //往mapView中添加annotation
//    WeiBoAnnotation *annotation = [[WeiBoAnnotation alloc]init];
//    annotation.title = @"大撒比";
//    annotation.subtitle = @"去年买了个表";
//    CLLocationCoordinate2D coordinate = {30.1842,120.2019};
//    [annotation setCoordinate:coordinate];
//    [_mapView addAnnotation:annotation];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_createViews{
    
    _mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
    //显示用户位置
    _mapView.showsUserLocation = YES;
    //地图显示类型 ： 标准、卫星 、混合
    _mapView.mapType = MKMapTypeStandard;
    //设置代理
    _mapView.delegate = self;
    
    //用户跟踪模式 系统自带
//    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    [self.view addSubview:_mapView];
    
}
#pragma mark - mapView代理
/**
 *  mapView位置更新后被调用
 */
//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
//
//
//    CLLocation *location = [userLocation location];
//    CLLocationCoordinate2D    coordinate = [location coordinate];
//
//    NSLog(@"纬度  %lf,精度 %lf",coordinate.latitude,coordinate.longitude);
//    
//    NSString *lon = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
//    NSString *lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
//    
//    [self _loadNearByData:lon lat:lat];
//    
//}


//返回标注视图
//二 自定义标注视图
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
//    //如果是用户定位则用默认的标注视图
//    if ([annotation isKindOfClass:[MKUserLocation class]]) {
//        return nil;
//    }
//    
//    MKPinAnnotationView *pin = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"view"];
//    //复用池，获取标注视图
//    if (pin == nil) {
//        pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"view"];
//        //颜色
//        pin.pinColor = MKPinAnnotationColorRed ;
//        //从天而降
//        pin.animatesDrop = YES;
//        //设置显示标题
//        pin.canShowCallout = YES;
//        pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeContactAdd];
//    }
//    
//    
//    return pin;
//}
    
    //如果是用户定位则用默认的标注视图
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    //复用池，获取标注视图
    if ([annotation isKindOfClass:[WeiBoAnnotation class]]) {
        WeiboAnnotationView *view = (WeiboAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"view"];
        
        if (view == nil) {
            
            view = [[WeiboAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"view"];
        }
        view.annotation = annotation;
        return view;
        
    }

    
    return nil;
    
}







#pragma mark - 定位管理
- (void)_location {
    
    _locationManager = [[CLLocationManager alloc]init];
    if (kVersion > 8.0) {
        [_locationManager requestWhenInUseAuthorization];
        
    }
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    //停止定位
    [_locationManager stopUpdatingLocation];
    //请求数据
    NSString *lon = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    NSString *lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    
    [self _loadNearByData:lon lat:lat];
    //3 设置地图显示区域
    //    typedef struct {
    //        CLLocationDegrees latitudeDelta;
    //        CLLocationDegrees longitudeDelta;
    //    } MKCoordinateSpan;
    //
    //    typedef struct {
    //        CLLocationCoordinate2D center;
    //        MKCoordinateSpan span;
    //    } MKCoordinateRegion;
    
    
    //>>01 设置 center
    CLLocationCoordinate2D center = coordinate;
    //>>02 设置span ,数值越小,精度越高，范围越小
    MKCoordinateSpan span= {0.1,0.1};
    MKCoordinateRegion region = {center,span};
    
    [_mapView setRegion:region];
    
}

//获取附近微博
- (void)_loadNearByData:(NSString *)lon lat:(NSString *)lat {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:lon forKey:@"long"];
    [params setObject:lat forKey:@"lat"];
    
    [DataService requestUrl:nearby_timeline httpMethod:@"GET" params:params block:^(id result) {
       
        NSArray *statuses = [result objectForKey:@"statuses"];
        NSMutableArray *annotationArray = [[NSMutableArray alloc]initWithCapacity:statuses.count];
        
        for (NSDictionary *dataDic in statuses) {
            WeiboModel *model = [[WeiboModel alloc]initWithDataDic:dataDic];
            
            //创建annotation
            WeiBoAnnotation *annonation = [[WeiBoAnnotation alloc]init];
            annonation.model = model;
            [annotationArray addObject:annonation];
        }
        //把annotation 添加到mapView
        [_mapView addAnnotations:annotationArray];
        //[_mapView reloadInputViews];
    }];
}

//标注视图被选中
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if (![view.annotation isKindOfClass:[WeiBoAnnotation class]]) {
        return;
    }
    
    WeiBoAnnotation *annotation = (WeiBoAnnotation *)view.annotation;
    WeiboModel *model = annotation.model;
    
    WeiboDetailViewController *detailVc = [[WeiboDetailViewController alloc]init];
    detailVc.model = model;
    
    [self.navigationController pushViewController:detailVc animated:YES];
    
}

@end
