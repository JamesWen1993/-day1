//
//  CommentTableView.m
//  项目二day1
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "CommentTableView.h"
#import "CommentCell.h"
#import "UserView.h"
#import "WeiboLayoutFrame.h"
#import "WeiboView.h"

@implementation CommentTableView
{
    //用户视图
    UserView *_userView;
    //微博视图
    WeiboView *_weiboView;
    
    //头视图
    UIView *_theTableHeaderView;
}



- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self _creatHeaderView];
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
        UINib *nib = [UINib nibWithNibName:@"CommentCell" bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:@"CommentCell"];
        
    }
    return self;
    
}

- (void)_creatHeaderView {
    
    //创建父视图
    _theTableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    _theTableHeaderView.backgroundColor = [UIColor clearColor];
    
    //创建用户视图
    _userView = [[[NSBundle mainBundle] loadNibNamed:@"UserView" owner:self options:nil]lastObject];
    _userView.backgroundColor = [UIColor clearColor];
    _userView.width = kScreenWidth;
    _theTableHeaderView.backgroundColor = [UIColor clearColor];
    [_theTableHeaderView addSubview:_userView];
    
    //3.创建微博视图
    _weiboView = [[WeiboView alloc]init];
    _weiboView.imgView.contentMode = UIViewContentModeScaleAspectFit;
    [_theTableHeaderView addSubview:_weiboView];
    
    

    
}

- (void)setWeiboModel:(WeiboModel *)weiboModel {
    if (_weiboModel != weiboModel) {
        _weiboModel = weiboModel;
        
        //1.创建微博视图的布局对象
        WeiboLayoutFrame *layout = [[WeiboLayoutFrame alloc]init];
        //isDeatail
        layout.isDetail = YES;
        layout.weiboModel = weiboModel;
        
        _weiboView.layoutFrame = layout;
        _weiboView.frame = layout.frame;
        _weiboView.top = _userView.bottom +5;
        
        //2.用户视图
        _userView.weiboModel = weiboModel;
        
        //3.设置头视图
        _theTableHeaderView.height = _weiboView.bottom;

        self.tableHeaderView = _theTableHeaderView;
        
    }
    
}
#pragma mark -  TabelView 代理


//获取组的头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    //1.创建组视图
    UIView *sectionHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 40)];
    //2.评论Label
    UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
    countLabel.backgroundColor = [UIColor clearColor];
    countLabel.font = [UIFont systemFontOfSize:16];
    countLabel.textColor = [UIColor blackColor];
    //3.评论数量
    NSNumber *total = [self.commentDic objectForKey:@"total_number"];
    int value = [total intValue];
    countLabel.text = [NSString stringWithFormat:@"评论:%d",value];
    [sectionHeaderView addSubview:countLabel];
    
    sectionHeaderView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.1];
    
    
    return sectionHeaderView;
}

//设置组的头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _commentDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    cell.model = self.commentDataArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
    
    
}

//设置单元格的高度
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentsModel *model = _commentDataArray[indexPath.row];
    //计算单元格的高度
    CGFloat height = [CommentCell getCommentHeight:model];
    return height+40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

@end
