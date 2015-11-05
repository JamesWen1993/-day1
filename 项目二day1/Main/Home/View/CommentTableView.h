//
//  CommentTableView.h
//  项目二day1
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboModel.h"


@interface CommentTableView : UITableView <UITableViewDataSource,UITableViewDelegate>


@property (nonatomic, strong)NSArray *commentDataArray;
@property (nonatomic, strong)WeiboModel *weiboModel;
@property(nonatomic,strong)NSDictionary *commentDic;
@end
