//
//  WeiboDetailViewController.m
//  项目二day1
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "WeiboDetailViewController.h"
#import "CommentTableView.h"
#import "AppDelegate.h"
#import "MJRefresh.h"

@interface WeiboDetailViewController ()<SinaWeiboRequestDelegate>
{
    CommentTableView *_table;
    SinaWeiboRequest *_requset;
}

@end

@implementation WeiboDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.title = @"微博详情";
    }
    return self;
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    //当界面弹出的时候，断开网络链接
    [_requset disconnect];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self _loadData];
    [self _creatTable];
    self.title = @"微博正文";
}


- (void)_creatTable {
    
    _table = [[CommentTableView alloc]initWithFrame:self.view.bounds];
    
    _table.backgroundColor = [UIColor clearColor];
    
    _table.weiboModel = self.model;
    
    [self.view addSubview:_table];
    //上拉加载
    _table.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadMore)];
    //下拉刷新
    _table.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNew)];
    
}


- (void)_loadData {
    // 注意bug: 在 http://open.weibo.com/wiki/2/place/nearby_timeline 接口中返回的微博id 类型为string ,以前是NSNumber，会导致在 跳转微博详情的时候数据解析错误
    // 以下用self.weiboModel.weiboIdStr
    
    NSString *weiboID = self.model.weiboIdStr;
//    NSString *weiboID = [self.model.weiboId stringValue];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:weiboID forKey:@"id"];
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    SinaWeibo *sinaweibo = app.sinaWeibo;
    
    
    _requset = [sinaweibo requestWithURL:comments params:params httpMethod:@"GET" delegate:self];
    _requset.tag = 100;
}

//加载更多数据
- (void)_loadMore {
    
    NSString *weiboID = self.model.weiboIdStr;
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:weiboID forKey:@"id"];
    
    //设置max_id 分页加载
    CommentsModel *cm = [_data lastObject];
    if (cm == nil) {
        return;
    }
    NSString *lastID = cm.idstr;
    [params setObject:lastID forKey:@"max_id"];
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    SinaWeibo *sinaweibo = app.sinaWeibo;
    
    _requset = [sinaweibo requestWithURL:comments params:params httpMethod:@"GET" delegate:self];
    _requset.tag = 102;
    
}

//下拉加载最新
- (void)_loadNew {
    
    NSString *weiboID = self.model.weiboIdStr;
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:weiboID forKey:@"id"];
    CommentsModel *cm = _data[0];
    if (_data.count == 0) {
        return ;
    }
    NSString *sineID = cm.idstr;
    [params setObject:sineID forKey:@"since_id"];
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaweibo = app.sinaWeibo;
    
    _requset = [sinaweibo requestWithURL:comments params:params httpMethod:@"GET" delegate:self];
    _requset.tag = 101;
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    //获取评论数据
    NSArray *commentsArray = [result objectForKey:@"comments"];
    
    NSMutableArray *commentModelArray = [NSMutableArray arrayWithCapacity:commentsArray.count];
    
    for (NSDictionary *dic in commentsArray) {
        CommentsModel *model = [[CommentsModel alloc]initWithDataDic:dic];
        
        [commentModelArray addObject:model];
        
    }
    
    if (request.tag == 100) {
        _data = commentModelArray;
    }else if (request.tag == 102) {//上拉加载
        [_table.footer endRefreshing];
        if (commentModelArray.count > 1) {
            [commentModelArray removeObjectAtIndex:0];
            [_data addObjectsFromArray:commentModelArray];
        } else {
            return;
        }
    }else if (request.tag == 101){//下拉刷新
        if (commentModelArray.count > 0) {
            NSRange range = NSMakeRange(0, commentModelArray.count);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            [_data insertObjects:commentModelArray atIndexes:indexSet];
        }
    }
    
    _table.commentDataArray = _data;
    _table.commentDic = result;
    [_table reloadData];
    [_table.header endRefreshing];
    [_table.footer endRefreshing];
    
    
}



@end
