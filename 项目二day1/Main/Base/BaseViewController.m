//
//  BaseViewController.m
//  项目二day1
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "BaseViewController.h"
#import "MMDrawerController.h"
#import "MBProgressHUD.h"
#import "UIViewController+MMDrawerController.h"
#import "AFHTTPRequestOperation.h"
#import "UIProgressView+AFNetworking.h"

@interface BaseViewController (){
    MBProgressHUD *_hud;
    UIWindow *_tipWindow;

}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadImage];
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
    

    [self loadImage];

}


- (void)loadImage {
    
    ThemeManger *manger = [ThemeManger shareInstance];

    //修改背景
    UIImage *bgimage = [manger getThemeImage:@"bg_home.jpg"];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgimage];
    
    
}

//显示加载
- (void)showHUD:(NSString *)title {
    if (_hud == nil) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    _hud.labelText = title;
    [_hud show:YES];
    //灰色背景视图覆盖掉其他视图
    _hud.dimBackground = YES;
    
}
//隐藏
- (void)hideHUD{
    
    [_hud hide:YES];
}

- (void)completeHUD:(NSString *)title {
    
    _hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    
    _hud.mode = MBProgressHUDModeCustomView;
    
    _hud.labelText = title;
    
    //持续1.5隐藏
    [_hud hide:YES afterDelay:1.5];
}


//设置导航栏左右按钮
- (void)setNavItem {
    
    
    
    ThemeButton *left = [[ThemeButton alloc]initWithFrame:CGRectMake(10, 0, 80, 40)];

    [left addTarget:self action:@selector(setAction) forControlEvents:UIControlEventTouchUpInside];
    ThemeImageView *leftBgImage = [[ThemeImageView alloc]init];
    left.normalImageName = @"group_btn_all_on_title.png";
    leftBgImage.imageName = @"button_title.png";
    [left setBackgroundImage:leftBgImage.image forState:(UIControlStateNormal)];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:left];
    self.navigationItem.leftBarButtonItem =leftItem;
    
    ThemeButton *right = [[ThemeButton alloc]initWithFrame:CGRectMake(200, 0, 50, 40)];
    
    [right addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    right.normalImageName = @"button_icon_plus.png";
    ThemeImageView *rightBGImage = [[ThemeImageView alloc]init];
    rightBGImage.imageName = @"button_m.png";
    [right setBackgroundImage:rightBGImage.image forState:(UIControlStateNormal)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem =rightItem;
    
    //80 50 ....40 50
    
}

- (void)setAction {
    
    MMDrawerController *mmDrawer = self.mm_drawerController;
    [mmDrawer openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
    
}

- (void)editAction {
    
    MMDrawerController *mmDrawer = self.mm_drawerController;
    [mmDrawer openDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}


- (void)showStatusTip:(NSString *)title show:(BOOL)show operation:(AFHTTPRequestOperation *)operation{
    //01 创建window
    if (_tipWindow == nil) {
        _tipWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        _tipWindow.windowLevel = UIWindowLevelStatusBar;
        _tipWindow.backgroundColor = [UIColor blackColor];
        
        UILabel *label = [[UILabel alloc]initWithFrame:_tipWindow.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.text = title;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 100;
        [_tipWindow addSubview:label];
        
        UIProgressView *progress = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        progress.frame = CGRectMake(0, 20-3, kScreenWidth, 5);
        progress.tag = 101;
        progress.progress = 0.0;
        [_tipWindow addSubview:progress];
    }
    
    UIProgressView *progress = (UIProgressView *)[_tipWindow viewWithTag:101];
    
    
    UILabel *label= (UILabel *)[_tipWindow viewWithTag:100];
    label.text = title;
    if (show) {
        [_tipWindow setHidden:NO];
        if (operation != nil) {
            progress.hidden = NO;
            [progress setProgressWithDownloadProgressOfOperation:operation animated:YES];
        } else {
            progress.hidden = YES;
        }
        
    }else {
        [self performSelector:@selector(removeTipWindow) withObject:nil afterDelay:1];
    }
}

- (void)removeTipWindow {
    _tipWindow.hidden = YES;
    _tipWindow = nil;
}


@end
