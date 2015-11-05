//
//  BaseViewController.h
//  项目二day1
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperation.h"
@interface BaseViewController : UIViewController


- (void)loadImage ;
- (void)setNavItem;
- (void)showHUD:(NSString *)title;
- (void)hideHUD;
- (void)completeHUD:(NSString *)title;
- (void)showStatusTip:(NSString *)title show:(BOOL)show operation:(AFHTTPRequestOperation *)operation;
@end
