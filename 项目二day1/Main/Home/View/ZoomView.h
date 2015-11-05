//
//  ZoomView.h
//  项目二day1
//
//  Created by mac on 15/10/17.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZoomView;
//定义协议，当图片放大或缩小的时候调用
@protocol ZoomImageViewDelegate <NSObject>

@optional
//图片将要放大

- (void)imageWillZoomIn:(ZoomView *)imageView;

//将要缩小
- (void)imageWillZoomOut:(ZoomView *)imageView;
//已经放大
//已经缩小
//....

@end




@interface ZoomView : UIImageView<NSURLConnectionDataDelegate,UIAlertViewDelegate>
{
    
    UIScrollView *_scrollView;
    
    UIImageView *_fullImageView;
}
@property (nonatomic, copy)NSString *fullImageString;
@property (nonatomic, weak)id<ZoomImageViewDelegate> delegate;
@property (nonatomic, assign)BOOL isGIF;
@property (nonatomic, strong)UIImageView *iconView;
@end