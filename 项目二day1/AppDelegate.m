//
//  AppDelegate.m
//  项目二day1
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "MMDrawerController.h"
#import "MMExampleDrawerVisualStateManager.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    //------------集成MMDrawer-----------------
    //01 左 中 右 控制器
     MainTabBarController *mainTabVc = [[MainTabBarController alloc]init];
    
    LeftViewController *leftVc = [[LeftViewController alloc]init];
    RightViewController *rightVc = [[RightViewController alloc]init];
    //02 创建 MMDrawerController
    MMDrawerController *mmDrawer = [[MMDrawerController alloc]initWithCenterViewController:mainTabVc leftDrawerViewController:leftVc rightDrawerViewController:rightVc];
    
    //设置 左边 右边 宽度
    [mmDrawer setMaximumRightDrawerWidth:60];
    [mmDrawer setMaximumLeftDrawerWidth:150];
    
    //设置手势有效区域
    [mmDrawer setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [mmDrawer setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    //设置动画类型
    [[MMExampleDrawerVisualStateManager sharedManager] setLeftDrawerAnimationType:MMDrawerAnimationTypeSwingingDoor];
    [[MMExampleDrawerVisualStateManager sharedManager] setRightDrawerAnimationType:MMDrawerAnimationTypeSwingingDoor];
    
    //设置动画效果,当左右侧边栏打开或者关闭的时候执行该block内的代码
    [mmDrawer setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        MMDrawerControllerDrawerVisualStateBlock block;
        block = [[MMExampleDrawerVisualStateManager sharedManager]
                 drawerVisualStateBlockForDrawerSide:drawerSide];
        if(block){
            block(drawerController, drawerSide, percentVisible);
        }
    }];
    
    self.window.rootViewController = mmDrawer;
    
    
    
    self.sinaWeibo = [[SinaWeibo alloc]initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:self];
    
    //本地创建个沙盒路径，存储账号信息
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
//    NSLog(NSHomeDirectory());
    
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"JamesWenWeiboAuthData"];
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
        _sinaWeibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        _sinaWeibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        _sinaWeibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//删除账号信息
- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"JamesWenWeiboAuthData"];
}

//存储账号信息到本地
- (void)storeAuthData
{
    SinaWeibo *sinaweibo = self.sinaWeibo;
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"JamesWenWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo {
    //登陆以后把令牌 ID等存储到本地
    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    
    [self storeAuthData];
}


//删除账号信息
- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");
    [self removeAuthData];

}


@end
