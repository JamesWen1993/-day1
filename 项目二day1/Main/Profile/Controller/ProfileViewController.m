//
//  ProfileViewController.m
//  项目二day1
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ProfileViewController.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"
#import "WeiBotableView.h"
#import "AppDelegate.h"
#import "WeiboLayoutFrame.h"
#import "MJRefresh.h"
#import "FansViewController.h"


@interface ProfileViewController ()<SinaWeiboRequestDelegate>
{
    WeiBotableView *_tableView;
    WeiboModel *model;
    NSMutableArray *_data;
    SinaWeiboRequest *_requset;
}


@property (strong, nonatomic) IBOutlet UIView *headerView;//头视图
@property (strong, nonatomic) IBOutlet UIImageView *userImage;//用户头像
@property (strong, nonatomic) IBOutlet UILabel *userNickName;//用户昵称
@property (strong, nonatomic) IBOutlet UILabel *userBase;//用户地址
@property (strong, nonatomic) IBOutlet UILabel *userMessage;//用户简介
@property (strong, nonatomic) IBOutlet UIButton *lookButton;//关注
@property (strong, nonatomic) IBOutlet UILabel *lookLabel;//关注
@property (strong, nonatomic) IBOutlet UIButton *fansButton;//粉丝
@property (strong, nonatomic) IBOutlet UILabel *fansLabel;//粉丝
@property (strong, nonatomic) IBOutlet UIButton *BaseMaeeageButton;//资料
@property (strong, nonatomic) IBOutlet UIButton *moreButton;//更多



@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人中心";
    [self _creatButton];
    [self _creatTable];
    [self _textGetWeibo];

}

- (void)_creatButton {
    
    _headerView.userInteractionEnabled = YES;
    NSArray *buttonArray = @[_lookButton,_fansButton,_BaseMaeeageButton,_moreButton];
    NSArray *buttonTitle = @[@"关注",@"粉丝",@"资料",@"更多"];
    
    for (int i = 0; i<4; i++) {
        UIButton *button = [[UIButton alloc]init];
        button = buttonArray[i];
        [button setTitle:buttonTitle[i] forState:UIControlStateNormal];
        button.tintColor = [UIColor blueColor];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
//        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        button.tag = i +200;
    }
    
    _lookButton.titleEdgeInsets = UIEdgeInsetsMake(15, 0, 0, 0);
    _lookLabel.text = @"0";
    _lookLabel.textAlignment = NSTextAlignmentCenter;
    _lookLabel.textColor = [UIColor orangeColor];
    
    _fansButton.titleEdgeInsets = UIEdgeInsetsMake(15, 0, 0, 0);
    _fansLabel.text = @"0";
    _fansLabel.textAlignment = NSTextAlignmentCenter;
    _fansLabel.textColor = [UIColor orangeColor];
}


- (void)buttonAction:(UIButton *)btn {

    NSLog(@"1");
    if (btn.tag == 201) {

        FansViewController *fans = [[FansViewController alloc]init];
        fans.title = @"粉丝列表";
        [self.navigationController pushViewController:fans animated:YES];
    }
}

- (void)_loadData {
    
    
    [_userImage sd_setImageWithURL:[NSURL URLWithString:model.userModal.profile_image_url]];
    
    _userNickName.text = model.userModal.screen_name;
    _userNickName.textColor = [UIColor blackColor];
    
    
    if (model.userModal.gender != nil) {
        if ([model.userModal.gender isEqualToString:@"m"]) {
            model.userModal.gender = [NSString  stringWithFormat:@"男"];
        } else if([model.userModal.gender isEqualToString:@"f"]){
            model.userModal.gender = [NSString  stringWithFormat:@"女"];
        }
        
    }
    
    _userBase.text = [NSString stringWithFormat:@"%@ %@",model.userModal.gender,model.userModal.location];
    
    _userMessage.text = @"简介";
    _userMessage.textColor = [UIColor blackColor];
    _userBase.textColor = [UIColor blackColor];
    
    _lookLabel.text = [model.userModal.friends_count stringValue];
    
    _fansLabel.text = [model.userModal.followers_count stringValue];
    
    
}






- (void)_creatTable {
    _tableView = [[WeiBotableView alloc]initWithFrame:self.view.self.bounds style:UITableViewStylePlain];
    
    _tableView.tableHeaderView = _headerView;
//    _tableView.tableHeaderView.layer.borderWidth = 10;
//    _tableView.tableHeaderView.layer.borderColor = [[UIColor grayColor] CGColor];
    [self.view addSubview:_tableView];
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadMore)];
    
}


#pragma mark UITableView + 下拉刷新 默认
- (void)_loadMore {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@"10" forKey:@"count"];
    
    //设置 maxID
    if (_data.count != 0) {
        WeiboLayoutFrame *layout = [_data lastObject];
        model = layout.weiboModel;
        [params setObject:model.weiboIdStr forKey:@"max_id"];
    }
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaWeibo = app.sinaWeibo;
    
    _requset = [sinaWeibo requestWithURL:user_timeline params:params httpMethod:@"GET" delegate:self];
    _requset.tag = 101;
    
}

- (void)_textGetWeibo {
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    SinaWeibo *sinaWeibo = app.sinaWeibo;
    
    if (sinaWeibo.isLoggedIn) {
        
       _requset = [sinaWeibo requestWithURL:user_timeline
                           params:[NSMutableDictionary dictionaryWithObject:sinaWeibo.userID forKey:@"uid"]
                       httpMethod:@"GET"
                         delegate:self];
        _requset.tag = 100;
    }else {
        
        [sinaWeibo logIn];
        
       _requset = [sinaWeibo requestWithURL:@"statuses/user_timeline.json"
                           params:[NSMutableDictionary dictionaryWithObject:sinaWeibo.userID forKey:@"uid"]
                       httpMethod:@"GET"
                         delegate:self];
        _requset.tag = 100;
    }
    
    
    
}

//获取微博失败时调用
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"getweiboFail  %@",error);
}

//获取微博时调用
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    
    
//    _tableView.hidden = NO;
    
    NSArray *dicArray = [result objectForKey:@"statuses"];
    
    NSMutableArray *layoutFrameArray = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dic in dicArray) {
        model = [[WeiboModel alloc]initWithDataDic:dic];
        WeiboLayoutFrame *layoutFrame = [[WeiboLayoutFrame alloc]init];
        layoutFrame.weiboModel = model;
        
        [layoutFrameArray addObject:layoutFrame];
    }
    
    if (request.tag == 100) {
        _data = layoutFrameArray;
    } else if (request.tag == 101) {
        if (layoutFrameArray.count > 1) {
            [layoutFrameArray removeObjectAtIndex:0];
            [_data addObjectsFromArray:layoutFrameArray];
        } else {
            return;
        }
        
    }
    
    _tableView.layoutArray = _data;
    [_tableView reloadData];
     [self _loadData];
    [_tableView.footer endRefreshing];
}


@end
