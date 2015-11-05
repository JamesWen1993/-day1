//
//  ThemeButton.m
//  项目二day1
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ThemeButton.h"

@implementation ThemeButton


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

- (void)setNormalImageName:(NSString *)normalImageName {
    
    if (![_normalImageName isEqualToString:normalImageName]) {
        _normalImageName = [normalImageName copy];
        if (normalImageName != nil) {
             [self loadImage];
        }
       
    }
}

- (void)setBgImageName:(NSString *)bgImageName {
    
    if (![_bgImageName isEqualToString:bgImageName]) {
        _bgImageName = [bgImageName copy];
        if (bgImageName != nil) {
            [self loadImage];
        }
        
        
    }
}


- (void)themeDidChange:(NSNotification *)notification {
    
    
    [self loadImage];
}

- (void)loadImage {
    ThemeManger *manger = [ThemeManger shareInstance];
    
    UIImage *normalImage = [manger getThemeImage:_normalImageName];
    
    UIImage *bgImage = [manger getThemeImage:_bgImageName];
    
    if (normalImage !=nil) {
        [self setImage:normalImage forState:UIControlStateNormal];
    }
    if (bgImage !=nil) {
        [self setBackgroundImage:bgImage forState:UIControlStateNormal];
    }
}

@end
