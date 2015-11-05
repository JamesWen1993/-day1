//
//  WeiboView.h
//  项目二day1
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboLayoutFrame.h"
#import "WXLabel.h"
#import "ZoomView.h"

@interface WeiboView : UIView <WXLabelDelegate>



@property (nonatomic,strong)WXLabel *textLabel;//微博文字
@property (nonatomic,strong)WXLabel *sourceLabel;//如果转发则：原微博文字
@property (nonatomic,strong)ZoomView *imgView;// 微博图片
@property (nonatomic,strong)ThemeImageView *bgImageView;//原微博背景图片


@property (strong,nonatomic) WeiboLayoutFrame *layoutFrame;//布局对象

@end
