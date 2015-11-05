//
//  ThemeManger.m
//  项目二day1
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ThemeManger.h"

@implementation ThemeManger{
    NSDictionary *_themeConfig; // skins/cat
    NSDictionary *_colorConfig;//颜色字典
}


+ (ThemeManger *)shareInstance {
    
    static ThemeManger *instance = nil;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        instance = [[[self class]alloc]init];
    });
    
    return instance;
    
}


// 路径加1.jng
- (instancetype)init {
    self = [super init];
    if (self) {
        
        _themeName = [[NSUserDefaults standardUserDefaults] valueForKey:kThemeName];
        if (_themeName.length ==0) {
            _themeName = @"Cat";
        }
        //02 读取 主题名-》主题路径    配置文件，放到字典里面
        NSString *configPath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
        
        _themeConfig = [NSDictionary dictionaryWithContentsOfFile:configPath];
        
        
        //读取颜色配置
        NSString *themePath = [self themePath];
        NSString *filePath = [themePath stringByAppendingPathComponent:@"config.plist"];
        _colorConfig = [NSDictionary dictionaryWithContentsOfFile:filePath];
    }
    return self;
}

- (void)setThemeName:(NSString *)themeName {
    if (![_themeName isEqualToString:themeName]) {
        _themeName = [themeName copy];
        
        //把主题名数据记录保存持久化到本地
        [[NSUserDefaults standardUserDefaults] setObject:_themeName forKey:kThemeName];
        //读取数据
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        //重新读取颜色数据
        NSString *themePath = [self themePath];
        NSString *filePath = [themePath stringByAppendingPathComponent:@"config.plist"];
        _colorConfig = [NSDictionary dictionaryWithContentsOfFile:filePath];

        
        //当主题名字改变时，发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kThemeNameDidChangeNotification object:nil];
    }
}


- (UIColor *)getThemeColor:(NSString *)colorName {
    if (colorName.length == 0) {
        return nil;
    }
    //1.获取配置文件中的rgb值
    NSDictionary *rgbDic = [_colorConfig objectForKey:colorName];;
    float r = [rgbDic[@"R"] floatValue];
    float g = [rgbDic[@"G"] floatValue];
    float b = [rgbDic[@"B"] floatValue];
    float alpha = 1;
    if (rgbDic[@"alpha"] != nil) {
        alpha = [rgbDic[@"alpha"] floatValue];
    }
    //2.通过rgb创建color
    UIColor *color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alpha];
    
    return color;
}

- (UIImage *)getThemeImage:(NSString *)imageName {
    //获取 主题包路径
    NSString *themePath = [self themePath];
    //拼接 主题路径 +imageName
    NSString *filePath = [themePath stringByAppendingPathComponent:imageName];
    
    //03 读取图片
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    
    return image;
}

- (NSString *)themePath {
    
    //01 获取主题包根路径
    NSString *resPath = [[NSBundle mainBundle] resourcePath]; // 加上 /skins/cat
    //02 当前主题包的路径
    NSString *pathSufix = [_themeConfig objectForKey:self.themeName]; // skins/cat
    //03 完整路径
    NSString *path = [resPath stringByAppendingPathComponent:pathSufix];
    
    return path;
}
@end
