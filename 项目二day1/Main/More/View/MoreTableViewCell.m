//
//  MoreTableViewCell.m
//  项目二day1
//
//  Created by mac on 15/10/10.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "MoreTableViewCell.h"

@implementation MoreTableViewCell

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self _creatSubView];
        [self layoutSubviews];
        
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChangeAction) name:kThemeNameDidChangeNotification object:nil];
    }
    return self;
}

- (void)_creatSubView {
    _themeImageView = [[ThemeImageView alloc]initWithFrame:CGRectMake(7, 7, 30, 30)];
    _themeLabel = [[ThemeLabel alloc]initWithFrame:CGRectMake(37+5, 11, 200, 20)];
    
    _themeDetailLabel = [[ThemeLabel alloc]initWithFrame:CGRectMake(kScreenWidth-95-30, 11, 95, 20)];
    
    _themeLabel.font = [UIFont boldSystemFontOfSize:16];
    _themeLabel.backgroundColor = [UIColor clearColor];
    _themeLabel.colorName = @"More_Item_Text_color";
    
    _themeDetailLabel.font = [UIFont boldSystemFontOfSize:15];
    _themeDetailLabel.backgroundColor = [UIColor clearColor];
    _themeDetailLabel.colorName = @"More_Item_Text_color";
    _themeDetailLabel.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:_themeLabel];
    [self.contentView addSubview:_themeDetailLabel];
    [self.contentView addSubview:_themeImageView];
}

- (void)themeChangeAction {
    //接受通知，改变字体颜色
    self.backgroundColor = [[ThemeManger shareInstance] getThemeColor:@"More_Item_color"];
}

- (void)layoutSubviews{
    _themeDetailLabel.frame = CGRectMake(kScreenWidth-95-30, 11, 95, 20);
    
}

@end
