//
//  UserView.h
//  项目二day1
//
//  Created by mac on 15/10/17.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
@interface UserView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *userSourse;

@property (nonatomic,strong) WeiboModel *weiboModel;
@end
