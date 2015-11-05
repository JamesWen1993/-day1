//
//  NearByViewController.h
//  项目二day1
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface NearByViewController : BaseViewController<CLLocationManagerDelegate,MKMapViewDelegate>
{
    CLLocationManager *_locationManager;
    MKMapView *_mapView;
}
@end
