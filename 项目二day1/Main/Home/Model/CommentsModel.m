//
//  CommentsModel.m
//  项目二day1
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "CommentsModel.h"

@implementation CommentsModel



- (void)setAttributes:(NSDictionary *)dataDic {
    [super setAttributes:dataDic];
    
    NSDictionary *userDic = [dataDic objectForKey:@"user"];
    UserModal*user = [[UserModal alloc] initWithDataDic:userDic];
    self.user = user;
    
    NSDictionary *status = [dataDic objectForKey:@"status"];
    WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:status];
    self.weibo = weibo;
    
    NSDictionary *commentDic = [dataDic objectForKey:@"reply_comment"];
    if (commentDic != nil) {
        CommentsModel *sourceComment = [[CommentsModel alloc] initWithDataDic:commentDic];
        self.sourceComment = sourceComment;
    }
    
    
}
@end
