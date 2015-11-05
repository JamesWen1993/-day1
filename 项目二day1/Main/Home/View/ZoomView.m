//
//  ZoomView.m
//  项目二day1
//
//  Created by mac on 15/10/17.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ZoomView.h"
#import "MBProgressHUD.h"
#import "UIImage+GIF.h"

@implementation ZoomView{
    NSURLConnection *_connection;
    double _length;
    NSMutableData *_data;
    MBProgressHUD *_hud;
    
    
    
}
- (instancetype)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    if (self) {
        [self _initTap];
        [self _createGifIcon];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self _initTap];
        [self _createGifIcon];
    }
    return self;
    
}


- (void)_initTap {
    //01 打开交互
    self.userInteractionEnabled = YES;
    
    //02 创建单击手势
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomIn)];
    
    [self addGestureRecognizer:tap];
    //03 imageView 图片显示模式  保持比例
    self.contentMode = UIViewContentModeScaleAspectFit;
    
}

////创建gif Icon图片显示
- (void)_createGifIcon {
    //创建gif图标
    _iconView = [[UIImageView alloc]init];
    _iconView.image = [UIImage imageNamed:@"timeline_gif"];
    _iconView.hidden = YES;
    [self addSubview:_iconView];
    
}

- (void)zoomIn {
    //调用代理的方法 通知代理
    if ([self.delegate respondsToSelector:@selector(imageWillZoomIn:)]) {
        [self.delegate imageWillZoomIn:self];
    }

    //01 创建大图浏览的_scrollView
    [self _createView];
    //02 计算 _fullImageView的frame
    //把自己相对于父视图的frame 转换成相对于 window的frame
    CGRect frame = [self convertRect:self.bounds toView:self.window];
    _fullImageView.frame = frame;
    
    //03 添加动画，放大
    [UIView animateWithDuration:.3 animations:^{
        _fullImageView.frame = _scrollView.frame;
    } completion:^(BOOL finished) {
        _scrollView.backgroundColor = [UIColor blackColor];
        [self _downLoadImage];
    }];
    
}


//04 请求网络 下载原图片
- (void)_downLoadImage {
    if (self.fullImageString.length > 0) {
        if (_hud == nil) {
            _hud = [MBProgressHUD showHUDAddedTo:_scrollView animated:YES];
            
        }
        _hud.mode = MBProgressHUDModeDeterminate;
        _hud.progress = 0.0;
        
        NSURL *url = [NSURL URLWithString:self.fullImageString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
        
        _connection = [NSURLConnection connectionWithRequest:request delegate:self];
        
    }
    
}


- (void)_createView {
    
    if ( _scrollView == nil) {
        //01 创建scrollView 添加到window上
        _scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        
        
        [self.window addSubview:_scrollView];
        
        //02 创建大图 fullImageView;
        _fullImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _fullImageView.image = self.image;
        _fullImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [_scrollView addSubview:_fullImageView];
     
        
        //03 添加缩小手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomOut)];
        [_scrollView addGestureRecognizer:tap];
        
        //04 长按 保存
        UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(savePhoto:)];
        
        [_scrollView addGestureRecognizer:longTap];
    }
    
}


#pragma mark - 保存图片到相册
- (void)savePhoto:(UILongPressGestureRecognizer *)longPress {
    
    //长按会触发2次，所以要判断
    if (longPress.state == UIGestureRecognizerStateBegan) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否保存图片" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        
        [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        UIImage *img = _fullImageView.image;
        //  将大图图片保存到相册
        //  - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
        UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    
}

//保存成功调用
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    //提示保存成功
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    //显示模式改为：自定义视图模式
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"保存成功";
    
    //延迟隐藏
    [hud hide:YES afterDelay:1.5];
}

- (void)zoomOut {
    //调用代理的方法 通知代理
    if ([self.delegate respondsToSelector:@selector(imageWillZoomOut:)]) {
        [self.delegate imageWillZoomOut:self];
    }
    
    
    //取消网络下载
    [_connection cancel];
    
    _fullImageView.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:.3 animations:^{
        //02 计算 _fullImageView的frame
        //把自己相对于父视图的frame 转换成相对于 window的frame
        CGRect frame = [self convertRect:self.bounds toView:self.window];
        _fullImageView.frame = frame;
        
        //如果scroll内容已经偏移，则偏移量也得计算
        _fullImageView.top += _scrollView.contentOffset.y;
        
    } completion:^(BOOL finished) {
        [_scrollView removeFromSuperview];
        _scrollView = nil;
        _fullImageView = nil;
        _hud = nil;
    }];
}



#pragma mark - 网络下载

//服务器响应请求
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSHTTPURLResponse *httpresponse = (NSHTTPURLResponse *)response;
    //01 取得响应头
    NSDictionary *headersFields = [httpresponse allHeaderFields];
    
    //获取文件大小
    NSString *lenthStr = [headersFields objectForKey:@"Content-Length"];
    _length = [lenthStr doubleValue];
    
    _data = [[NSMutableData alloc]init];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [_data appendData:data];
    
    CGFloat progress = _data.length/_length;
    _hud.progress = progress;

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [_hud hide:YES];
    
    UIImage *image = [UIImage imageWithData:_data];
    
    _fullImageView.image = image;
    
    //长和宽的倍数 * 屏幕宽的倍数  =就是屏幕长。因为自适应image缩小了以后自身的高缩小而view的高没缩小
    
    CGFloat length = image.size.height/image.size.width * kScreenWidth;
    if (length > kScreenHeight) {
        
        [UIView animateWithDuration:0.3 animations:^{
            _fullImageView.height = length;
            _scrollView.contentSize = CGSizeMake(kScreenWidth, length);
            
        }];
    }
    if (_isGIF ) {
        [self gifImageShow];
    }
    
    
}


- (void)gifImageShow {
    
    
    //1. ----------------webview播放-------------------------
    //    UIWebView *webView = [[UIWebView alloc] initWithFrame:_scrollView.bounds];
    //
    //    webView.userInteractionEnabled = NO;
    //    webView.scalesPageToFit = YES;
    //
    //    [webView loadData:_data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    //    [_scrollView addSubview:webView];
    
    
    
    
    //2. ---------使用ImageIO 提取GIF中所有帧的图片进行播放---------------
    //#import <ImageIO/ImageIO.h>
    //>> 01创建图片源
    
    //    CGImageSourceRef source  =  CGImageSourceCreateWithData((__bridge CFDataRef)_data, NULL);
    //    //>> 02 获取图片源中的图片个数
    //    size_t  count =  CGImageSourceGetCount(source);
    //
    //    NSMutableArray *images = [[NSMutableArray alloc] init];
    //
    //
    //    for (size_t i = 0; i<count; i++) {
    //
    //        //03 获取每一张图片
    //        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
    //        UIImage *uiImage = [UIImage imageWithCGImage:image];
    //        [images addObject:uiImage];
    //        CGImageRelease(image);
    //
    //    }
    
    //04 imageView 播放图片数组
    
    //>>04-1 第一种方式播放图片
    //    _fullImageView.animationImages = images;
    //    _fullImageView.animationDuration = images.count*0.1;
    //    [_fullImageView startAnimating];
    //>>04-2 第二种播放方式
    //    UIImage *animatedImage = [UIImage animatedImageWithImages:images duration:images.count*0.1];
    //    _fullImageView.image = animatedImage;
    
    
    
    //3. ---------三方框架如 SDWebImage 封装的GIF播放------------------
    //#import "UIImage+GIF.h"
    //+ (UIImage *)sd_animatedGIFWithData:(NSData *)data;
    
    _fullImageView.image = [UIImage sd_animatedGIFWithData:_data];
}
@end
