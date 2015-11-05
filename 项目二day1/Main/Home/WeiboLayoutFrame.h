//
//  WeiboLayoutFrame.h
//  项目二day1
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboModel.h"


@interface WeiboLayoutFrame : NSObject

@property (nonatomic,assign) CGRect textFrame;//微博文字
@property (nonatomic,assign) CGRect srTextFrame;//转发源微博文字
@property (nonatomic,assign) CGRect bgImageFrame;//微博背景
@property (nonatomic,assign) CGRect imgFrame;//微博文字

@property (nonatomic,assign) CGRect frame;//整个weiboView的frame
@property (nonatomic,assign) BOOL isDetail;//是否是详情页面布局

@property (nonatomic,strong) WeiboModel *weiboModel;//微博的model

@end
