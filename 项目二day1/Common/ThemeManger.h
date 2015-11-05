//
//  ThemeManger.h
//  项目二day1
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeManger : NSObject

@property (nonatomic, copy)NSString *themeName;


+ (ThemeManger *)shareInstance;


- (UIImage *)getThemeImage:(NSString *)imageName;

- (UIColor *)getThemeColor:(NSString *)colorName;
@end
