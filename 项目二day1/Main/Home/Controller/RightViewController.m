//
//  RightViewController.m
//  项目二day1
//
//  Created by mac on 15/10/10.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "RightViewController.h"
#import "SendViewController.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "BaseNavController.h"
#import "LocViewController.h"

@interface RightViewController ()

@end

@implementation RightViewController


- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:kThemeNameDidChangeNotification object:nil];
        
    }
    return self;
}

- (void)themeDidChange:(NSNotification *)notification{
    
    
    [self loadImage];
    [self creatButton];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatButton];

}

- (void)creatButton {
    
    NSArray *buttonArray = @[@"newbar_icon_1.png",@"newbar_icon_2.png",@"newbar_icon_3.png",@"newbar_icon_4.png",@"newbar_icon_5.png",];
    for (int i = 0;i<5 ; i++) {
        ThemeButton *button = [[ThemeButton alloc]initWithFrame:CGRectMake(10, 64 + i * (40 + 10), 40, 40)];
        ThemeImageView *buttonImage = [[ThemeImageView alloc]init];
        buttonImage.imageName = buttonArray[i];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 200 + i;
        [button setImage:buttonImage.image forState:(UIControlStateNormal)];
        
    
        [self.view addSubview:button];

    }
   
    
}

- (void)buttonAction:(UIButton *)btn {

    if (btn.tag == 200) {
        // 发送微博
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
            // 弹出发送微博控制器
            SendViewController *sendVc = [[SendViewController alloc]init];
            sendVc.title = @"发送微博";
            
            // 创建导航控制器
            BaseNavController *baseNV = [[BaseNavController alloc]initWithRootViewController:sendVc];
            [self.mm_drawerController presentViewController:baseNV animated:YES completion:nil];
            
        }];
        
        
    }else if (btn.tag == 202) {
        
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished) {
            
            LocViewController *locVc = [[LocViewController alloc]init];
            locVc.title = @"附近商圈";
            
            // 创建导航控制器
            BaseNavController *baseNV = [[BaseNavController alloc]initWithRootViewController:locVc];
            [self.mm_drawerController presentViewController:baseNV animated:YES completion:nil];
        }];
    }
    
}

@end
