//
//  CommentCell.m
//  项目二day1
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "CommentCell.h"
#import "UIImageView+WebCache.h"
@implementation CommentCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _commentLabel = [[WXLabel alloc]initWithFrame:CGRectMake(_otherImageView.right +10, _otherLabel.bottom+5,0, 0)];
        _commentLabel.font = [UIFont systemFontOfSize:14];
        _commentLabel.linespace = 5;
        _commentLabel.wxLabelDelegate = self;
        [self.contentView addSubview:_commentLabel];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}



- (void)setModel:(CommentsModel *)model {
    if (_model != model) {
        _model = model;
        [self setNeedsLayout];
    }
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_otherImageView sd_setImageWithURL:[NSURL URLWithString:_model.user.profile_image_url]];
    
    _otherLabel.text = _model.user.screen_name;
    
    //评论内容
    _commentLabel.text = _model.text;

    CGFloat height = [WXLabel getTextHeight:14 width:240 text:_commentLabel.text linespace:5];
    _commentLabel.frame = CGRectMake(_otherImageView.right +10, _otherLabel.bottom+5, kScreenWidth-70, height);
    
}
//返回一个正则表达式，通过此正则表达式查找出需要添加超链接的文本
- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel {
    //需要添加连接的字符串的正则表达式：@用户、http://... 、 #话题#
    NSString *regex1 = @"@\\w+"; //@"@[_$]";
    NSString *regex2 = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";
    NSString *regex3 = @"#^#+#";  //\w 匹配字母或数字或下划线或汉字
    
    NSString *regex = [NSString stringWithFormat:@"(%@)|(%@)|(%@)",regex1,regex2,regex3];
    
    return regex;
}

//设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel {
    
    UIColor *linkColor = [[ThemeManger shareInstance] getThemeColor:@"Link_color"];
    return linkColor;
}

//设置当前文本手指经过的颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel {
    return [UIColor darkGrayColor];
}



//计算评论单元格的高度
+ (float)getCommentHeight:(CommentsModel *)model {
    CGFloat height = [WXLabel getTextHeight:14 width:kScreenWidth - 70 text:model.text linespace:5];
    
    return height;
    
}
@end
