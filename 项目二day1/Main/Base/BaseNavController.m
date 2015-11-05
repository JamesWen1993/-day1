//
//  BaseNavController.m
//  项目二day1
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "BaseNavController.h"

@interface BaseNavController ()

@end

@implementation BaseNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _loadImage];
}
- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:kThemeNameDidChangeNotification object:nil];
    }
    return self;
}
- (void)themeDidChange:(NSNotification *)notification{
    
    [self _loadImage];
}


- (void)_loadImage {
    
    ThemeManger *manger = [ThemeManger shareInstance];
    //修改导航栏 背景
    UIImage *image = [manger getThemeImage:@"mask_titlebar64.png"];
    [self.navigationBar setBackgroundImage:image  forBarMetrics:UIBarMetricsDefault];
    
    //修改字体
    UIColor *color = [manger getThemeColor:@"Mask_Title_color"];
    //设置标题颜色

    NSDictionary *attrDic = @{NSForegroundColorAttributeName:color};
    self.navigationBar.titleTextAttributes = attrDic;
    
    //修改背景
    UIImage *bgimage = [manger getThemeImage:@"bg_home.jpg"];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgimage];
    

}
@end
