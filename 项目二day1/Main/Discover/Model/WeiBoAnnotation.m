//
//  WeiBoAnnotation.m
//  项目二day1
//
//  Created by mac on 15/10/20.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "WeiBoAnnotation.h"

@implementation WeiBoAnnotation

- (void)setModel:(WeiboModel *)model {
    _model = model;
    
    NSDictionary *geos = model.geo;
    
    NSArray *coordinate = [geos objectForKey:@"coordinates"];
    
    if (coordinate.count >= 2) {
        NSString *lon = coordinate[0];
        NSString *lat = coordinate[1];
        //设置坐标
        _coordinate = CLLocationCoordinate2DMake([lon floatValue], [lat floatValue]);
    }
    
}


@end
