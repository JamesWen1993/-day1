//
//  UserView.m
//  项目二day1
//
//  Created by mac on 15/10/17.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "UserView.h"
#import "UIImageView+WebCache.h"
@implementation UserView
- (void)setWeiboModel:(WeiboModel *)weiboModel {
    if (_weiboModel != weiboModel) {
        _weiboModel = weiboModel;
        
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _userImage.layer.borderColor = [UIColor whiteColor].CGColor;
    _userImage.layer.borderWidth = 1;
    _userImage.layer.cornerRadius = _userImage.width/2;
    _userImage.layer.masksToBounds = YES;
    
    //1.用户头像
    NSString *imgURL = self.weiboModel.userModal.avatar_large;
    [_userImage sd_setImageWithURL:[NSURL URLWithString:imgURL]];
    
    //2.昵称
    _userName.text = self.weiboModel.userModal.screen_name;
    
    //3.发布时间
    //  _createLabel.text = [UIUtils fomateString:self.weiboModel.createDate];
    
    //4.来源
    _userSourse.text = self.weiboModel.source;
}

@end
