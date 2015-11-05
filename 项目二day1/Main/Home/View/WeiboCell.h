//
//  WeiboCell.h
//  项目二day1
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"
#import "WeiboLayoutFrame.h"
#import "WeiboView.h"
@interface WeiboCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UILabel *userNickName;
@property (strong, nonatomic) IBOutlet UILabel *commentsCount;
@property (strong, nonatomic) IBOutlet UILabel *repostsCount;
@property (strong, nonatomic) IBOutlet UILabel *source;


//@property (strong, nonatomic) WeiboModel *modal;

@property (strong, nonatomic) WeiboView *weiboView;

@property (strong, nonatomic) WeiboLayoutFrame *layoutFrame;
@end
