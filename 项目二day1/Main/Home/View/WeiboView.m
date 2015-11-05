//
//  WeiboView.m
//  项目二day1
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "WeiboView.h"
#import "UIImageView+WebCache.h"

@implementation WeiboView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self _creatSubViews];
    }
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _creatSubViews];
    }
    return self;
}


- (void)setLayoutFrame:(WeiboLayoutFrame *)layoutFrame {
    if (_layoutFrame !=layoutFrame) {
        _layoutFrame = layoutFrame;
        
        [self setNeedsLayout];
    }
}


- (void)_creatSubViews {
    _textLabel.backgroundColor = [UIColor redColor];
    _sourceLabel.backgroundColor = [UIColor yellowColor];
    
    //1.微博内容
    _textLabel = [[WXLabel alloc]init];
    _textLabel.font = [UIFont systemFontOfSize:15];
    _textLabel.linespace = 5;
    _textLabel.wxLabelDelegate = self;
    _textLabel.textColor = [[ThemeManger shareInstance]getThemeColor:@"Timeline_Content_color"];
    
    //转发微博内容
    _sourceLabel = [[WXLabel alloc]init];
    _sourceLabel.font = [UIFont systemFontOfSize:14];
    _sourceLabel.wxLabelDelegate = self;
    _sourceLabel.linespace = 5;
    _sourceLabel.textColor = [[ThemeManger shareInstance] getThemeColor:@"Timeline_Content_color"];
    
    _imgView = [[ZoomView alloc]init];
    _bgImageView = [[ThemeImageView alloc]init];
    _bgImageView.imageName = @"timeline_rt_border_9.png";
    
    [self addSubview:_textLabel];
    [self addSubview:_sourceLabel];
    [self addSubview:_imgView];
    [self insertSubview:_bgImageView atIndex:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:kThemeNameDidChangeNotification object:nil];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _textLabel.font =   [UIFont systemFontOfSize: FontSize_weibo(_layoutFrame.isDetail)] ;
    _sourceLabel.font =  [UIFont systemFontOfSize: FontSize_Reweibo(_layoutFrame.isDetail)] ;
    WeiboModel *model = _layoutFrame.weiboModel;
#warning 微博详情 -- 整个frame的x ,y 可能需要在外面设置,这里注释掉
//    self.frame = _layoutFrame.frame;
    
    _textLabel.text = model.text;
    
    _textLabel.frame = _layoutFrame.textFrame;
     //是否转发
    if (model.reWeiboModel != nil) {
        
        _bgImageView.hidden = NO;
        _sourceLabel.hidden = NO;
        //背景图片frame
        _bgImageView.frame = _layoutFrame.bgImageFrame;
        //原微博内容以及frame
        _sourceLabel.frame = _layoutFrame.srTextFrame;
        _sourceLabel.text = model.reWeiboModel.text;
        
        //图片
        NSString *imgURL = model.reWeiboModel.thumbnailImage;
        
        if (imgURL != nil) {
            
            _imgView.hidden = NO;
            _imgView.frame = _layoutFrame.imgFrame;
            
            [_imgView sd_setImageWithURL:[NSURL URLWithString:imgURL]];
            //大图链接
            _imgView.fullImageString = model.reWeiboModel.originalImage;
            
        } else {
            _imgView.hidden = YES;
        }
    } else {
        //非转发
        //隐藏不用的 view
        _bgImageView.hidden =YES;
        _sourceLabel.hidden = YES;
        
        //图片
        NSString *imgURL = model.thumbnailImage;
        
        if (imgURL != nil) {
            
            _imgView.hidden = NO;
            _imgView.frame = _layoutFrame.imgFrame;
            
            [_imgView sd_setImageWithURL:[NSURL URLWithString:imgURL]];
            
            //大图链接
            _imgView.fullImageString = model.originalImage;
        } else {
            _imgView.hidden = YES;
        }
    }
    //判断是否是gif
    if (_imgView.hidden == NO) {
        NSString *extension;//后缀名
        
        UIImageView *iconView = _imgView.iconView;
        iconView.frame = CGRectMake(_imgView.width-24, _imgView.height-24, 24, 24);
        //获取url后缀 查看是否是gif
        if (model.reWeiboModel != nil) {
            extension = [model.reWeiboModel.thumbnailImage pathExtension];
            
        }else {
            extension = [model.thumbnailImage pathExtension];
        }
        
        if ([extension isEqualToString:@"gif"]) {
            _imgView.isGIF = YES;
            _imgView.iconView.hidden = NO;
        } else {
            _imgView.isGIF = NO;
            _imgView.iconView.hidden = YES;
        }
    }
   
    
}

#pragma mark - WXLabelDelegate

//检索文本的正则表达式的字符串
- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel
{
    //需要添加链接字符串的正则表达式：@用户、http://、#话题#
    // https://www.baidu.com/hello/jlasjdlf/1.json
    NSString *regex1 = @"@\\w+";
    NSString *regex2 = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";
    NSString *regex3 = @"#\\w+#";
    NSString *regex = [NSString stringWithFormat:@"(%@)|(%@)|(%@)",regex1,regex2,regex3];
    return regex;
}

//设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel{
    
    return [[ThemeManger shareInstance] getThemeColor:@"Link_color"];
}
//设置当前文本手指经过的颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel{
    return  [UIColor redColor];
}
//手指接触当前超链接文本响应的协议方法
- (void)toucheBenginWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context{
    NSLog(@"dianji");
}

#pragma mark - 主题切换通知
- (void)themeDidChange:(NSNotification *)notification{
    _textLabel.textColor = [[ThemeManger shareInstance] getThemeColor:@"Timeline_Content_color"];
    _sourceLabel.textColor = [[ThemeManger shareInstance] getThemeColor:@"Timeline_Content_color"];
    
}

@end
