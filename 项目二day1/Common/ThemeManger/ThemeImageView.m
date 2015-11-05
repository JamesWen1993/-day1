//
//  ThemeImageView.m
//  项目二day1
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ThemeImageView.h"

@implementation ThemeImageView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:kThemeNameDidChangeNotification object:nil];
    }
    return self;
}




- (void)themeDidChange:(NSNotification *)notification {
    
    [self loadImage];
}

- (void)setImageName:(NSString *)imageName {
    if (![_imageName isEqualToString:imageName]) {
        _imageName = [imageName copy];
        
        [self loadImage];
    }
}


- (void)loadImage {
    ThemeManger *mannger = [ThemeManger shareInstance];
    _leftCap = 30;
    _topCap = 30;
    
    UIImage *image = [mannger getThemeImage:_imageName];
    
    //如果图片被放大则拉伸图片
    UIImage *tempImage = [image stretchableImageWithLeftCapWidth:_leftCap topCapHeight:_topCap];
    if (image !=nil) {
        self.image = tempImage;
    }
    
}
@end
