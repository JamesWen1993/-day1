//
//  WeiboCell.m
//  项目二day1
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "WeiboCell.h"
#import "UIImageView+WebCache.h"


@implementation WeiboCell

- (void)awakeFromNib {
    
    //创建微博内容View
    _weiboView = [[WeiboView alloc]init];
    
    [self addSubview:_weiboView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLayoutFrame:(WeiboLayoutFrame *)layoutFrame {
    if (_layoutFrame !=layoutFrame) {
        _layoutFrame = layoutFrame;
        [self layoutIfNeeded];
    }
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    WeiboModel *_modal = _layoutFrame.weiboModel;
    //头像
    [_userImage sd_setImageWithURL:[NSURL URLWithString:_modal.userModal.profile_image_url]];
    
    //昵称
    
    _userNickName.text = _modal.userModal.screen_name;

    
    // 评论， 转发
    _commentsCount.text = [NSString stringWithFormat:@"评论:%@",_modal.commentsCount ];
    _repostsCount.text = [NSString stringWithFormat:@"转发:%@",_modal.repostsCount ];
    
    //来源
    _source.text = _modal.source;
    
    //内容
    _weiboView.layoutFrame = _layoutFrame;
    
    
#warning 微博详情：整个weiboView的 x y 在这里设置
    _weiboView.frame = _layoutFrame.frame;

}


@end
