//
//  ThemeLabel.m
//  项目二day1
//
//  Created by mac on 15/10/10.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ThemeLabel.h"

@implementation ThemeLabel

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

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:kThemeNameDidChangeNotification object:nil];
}

- (void)themeDidChange:(NSNotification *)notification {
    
    
    [self _loadTextColor];
}

- (void)setColorName:(NSString *)colorName {
    
    if (![_colorName isEqualToString:colorName]) {
        _colorName = [colorName copy];
        [self _loadTextColor];
    }
    
}

- (void)_loadTextColor {
    ThemeManger *manger = [ThemeManger shareInstance];
    
    self.textColor = [manger getThemeColor:_colorName];
    
}
@end
