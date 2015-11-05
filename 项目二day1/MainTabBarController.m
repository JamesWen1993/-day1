//
//  MainTabBarController.m
//  项目二day1
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "MainTabBarController.h"
#import "BaseNavController.h"
#import "Common.h"
#import "AppDelegate.h"
@interface MainTabBarController ()<SinaWeiboRequestDelegate>
{
     ThemeImageView*_selectedImageView;
    ThemeLabel *_badgeLabel;
    ThemeImageView *_badgeImageView;
}
@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建子视图控制器
    [self _creatSubController];
    //设置 tabbar
    [self _creatTabBar];
    
    //开启定时器,请求unread_count接口 获取未读微博、新粉丝数量、新评论。。。
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)_creatTabBar {
    //移除uitabbarbutton
    for (UIView *view in self.tabBar.subviews) {
        Class cls = NSClassFromString(@"UITabBarButton");
        if ([view isKindOfClass:cls]) {
            [view removeFromSuperview];
        }
    }
    
    //2.背景图片
    
    ThemeImageView *bgImageView = [[ThemeImageView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth , 49)];
    
//    bgImageView.image = [UIImage imageNamed:@"SKins/cat/mask_navbar.png"];
    bgImageView.imageName = @"mask_navbar.png";
    
    [self.tabBar addSubview:bgImageView];
    
    //选中图片
    
    float Width = kScreenWidth /5;
    
    _selectedImageView = [[ThemeImageView alloc]initWithFrame:CGRectMake(0, 0, Width, 49)];
    
    _selectedImageView.imageName = @"home_bottom_tab_arrow.png";
    
    [self.tabBar addSubview:_selectedImageView];
    
    //设置按钮
    
    NSArray * buttonImageNames = @[@"home_tab_icon_1.png",
                                   @"home_tab_icon_2.png",
                                   @"home_tab_icon_3.png",
                                   @"home_tab_icon_4.png",
                                   @"home_tab_icon_5.png"];
    
    for (int i = 0; i<5; i++) {
        
        ThemeButton *button = [[ThemeButton alloc]initWithFrame:CGRectMake(i * Width , 0, Width, 49)];
        
        [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i +100;

        [button setNormalImageName:buttonImageNames[i]];
        
        [self.tabBar addSubview:button];
        
    }
    
    
}

#pragma mark - 未读系消息个数获取
- (void)timeAction {
    AppDelegate *app = (AppDelegate *) [UIApplication sharedApplication].delegate;
    
    SinaWeibo *sinaWeibo = app.sinaWeibo;
    
    [sinaWeibo requestWithURL:unread_count params:nil httpMethod:@"GET" delegate:self];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    
    //number_notify_9.png
    //Timeline_Notice_color
    //未读微博
    NSNumber *status = [result objectForKey:@"status"];
    NSInteger count = [status integerValue];
    
    CGFloat tabBarButtonWith = kScreenWidth/5;
    if (_badgeImageView == nil) {
        _badgeImageView = [[ThemeImageView alloc]initWithFrame:CGRectMake(tabBarButtonWith-32, 0, 32, 32)];
        _badgeImageView.imageName = @"number_notify_9.png";
        [self.tabBar addSubview:_badgeImageView];
        
        _badgeLabel = [[ThemeLabel alloc]initWithFrame:_badgeImageView.bounds];
        _badgeLabel.backgroundColor = [UIColor clearColor];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        _badgeLabel.colorName = @"Timeline_Notice_color";
        _badgeLabel.font = [UIFont systemFontOfSize:13];
        [_badgeImageView addSubview:_badgeLabel];
    }
    if (count == 0) {
        _badgeImageView.hidden = YES;
    }else if (count < 99) {
        _badgeImageView.hidden = NO;
        _badgeLabel.text = [NSString stringWithFormat:@"%li",count];
    }else {
        
        _badgeLabel.text = @"99";
    }
    
    
    
}

- (void)selectAction:(UIButton *)button {
    
    [UIView animateWithDuration:.3 animations:^{
        
        _selectedImageView.center = button.center;
    }];
    
    self.selectedIndex = button.tag -100;
}



- (void)_creatSubController {
    
    NSArray * names = @[@"Home",@"Discover",@"Message",@"Profile",@"More"];
    
    NSMutableArray *navs = [[NSMutableArray alloc]initWithCapacity:5];
    
    for (int i = 0; i<5; i++) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:names[i] bundle:nil];
        
        BaseNavController *nav = [sb instantiateInitialViewController];
        
        [navs addObject:nav];
    }
    
    self.viewControllers = navs;
}

@end
