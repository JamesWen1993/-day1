//
//  HomeViewController.m
//  项目二day1
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "SinaWeibo.h"
#import "WeiboModel.h"
#import "WeiBotableView.h"
#import "WeiboLayoutFrame.h"
#import "MoreViewController.h"
#import "MJRefresh.h"
#import "MainTabBarController.h"
#import <AudioToolbox/AudioToolbox.h>


@interface HomeViewController ()
{
    WeiBotableView *_tableView;
    NSMutableArray *_data;
    ThemeLabel *_barLabel;//提示文字
    ThemeImageView *_barImageView;//弹出微博条数提示
    
}
@end

@implementation HomeViewController

- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:kThemeNameDidChangeNotification object:nil];
    }
    return self;
}
- (void)themeDidChange:(NSNotification *)notification{
    
    
    [self setNavItem];
    [self loadImage];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self _creatTable];
    [self setNavItem];
    [self _textGetWeibo];
    self.title = @"主页";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView + 下拉刷新 默认

- (void)_loadNewData {
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    SinaWeibo *sinaWeibo = app.sinaWeibo;
    
    if (sinaWeibo.isLoggedIn) {
        
        //params处理
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"10" forKey:@"count"];
        //设置 sinceId
        if (_data.count != 0) {
            WeiboLayoutFrame *layout = _data[0];
            WeiboModel *model = layout.weiboModel;
            
            [params setObject:model.weiboIdStr forKey:@"since_id"];
        }
        
       SinaWeiboRequest *request =  [sinaWeibo requestWithURL:@"statuses/home_timeline.json"
                           params:params
                       httpMethod:@"GET"
                         delegate:self];
        request.tag = 101;
    }

}
//上拉加载更多
- (void)_loadMoreData {
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    SinaWeibo *sinaWeibo = app.sinaWeibo;
    
    if (sinaWeibo.isLoggedIn) {
        
        //params处理
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        [params setObject:@"10" forKey:@"count"];
        //设置 maxID
        if (_data.count != 0) {
            WeiboLayoutFrame *layout = [_data lastObject];
            WeiboModel *model = layout.weiboModel;
            
            [params setObject:model.weiboIdStr forKey:@"max_id"];
        }
        
        SinaWeiboRequest *request =  [sinaWeibo requestWithURL:@"statuses/home_timeline.json"
                                                        params:params
                                                    httpMethod:@"GET"
                                                      delegate:self];
        request.tag = 102;
    }
    
   
}




- (void)_creatTable {
    _tableView = [[WeiBotableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNewData)];
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_loadMoreData)];
    
    [self.view addSubview:_tableView];
    _tableView.hidden = YES;
    
}

- (void)_textGetWeibo {
    
    [self showHUD:@"正在加载..."];
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    SinaWeibo *sinaWeibo = app.sinaWeibo;
    
    if (sinaWeibo.isLoggedIn) {
        
       SinaWeiboRequest *request = [sinaWeibo requestWithURL:home_timeline
                           params:[NSMutableDictionary dictionaryWithObject:sinaWeibo.userID forKey:@"uid"]
                       httpMethod:@"GET"
                         delegate:self];
        request.tag = 100;
    }else {
        
        [sinaWeibo logIn];
        
         [sinaWeibo requestWithURL:home_timeline
                           params:[NSMutableDictionary dictionaryWithObject:sinaWeibo.userID forKey:@"uid"]
                       httpMethod:@"GET"
                         delegate:self];
        
    }
    
    
    
    
}

//获取微博失败时调用
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"getweiboFail  %@",error);
}

//获取微博时调用
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    
    
    _tableView.hidden = NO;
    
    NSArray *dicArray = [result objectForKey:@"statuses"];

    
    NSMutableArray *layoutFrameArray = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dic in dicArray) {
        WeiboModel *model = [[WeiboModel alloc]initWithDataDic:dic];
        WeiboLayoutFrame *layoutFrame = [[WeiboLayoutFrame alloc]init];
        layoutFrame.weiboModel = model;
        
        [layoutFrameArray addObject:layoutFrame];
    }
    
    
    //普通加载微博
    if (request.tag == 100) {
        
        [self completeHUD:@"加载完成"];
        
        _data = layoutFrameArray;
        
    }else if (request.tag == 102) {//更多微博
        
        if (_data.count > 1) {
            [layoutFrameArray removeObjectAtIndex:0];
            [_data addObjectsFromArray:layoutFrameArray];
        }
        
    }else if (request.tag == 101) {//最新微博
        
        if (_data.count > 1) {
            //方法1
//            [layoutFrameArray addObjectsFromArray:_data];
//            _data = layoutFrameArray;
            
            //方法2
            NSRange rang = NSMakeRange(0, layoutFrameArray.count);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:rang];
            
            [_data insertObjects:layoutFrameArray atIndexes:indexSet];
            [self showNewWeiboCount:layoutFrameArray.count];
            
            MainTabBarController *ta = (MainTabBarController *)self.tabBarController;
            
            [ta timeAction];
        }
        
    }
    
    
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
    
    
    if (_data.count != 0) {
        _tableView.layoutArray = _data;
        [_tableView reloadData];
    } else {
        _tableView.layoutArray = layoutFrameArray;
        [_tableView reloadData];
    }
    
}


//更新微博数目
//Timeline_Notice_color
//timeline_notify.png
//msgcome.wav

- (void)showNewWeiboCount:(NSInteger)count {
    
    if (_barImageView == nil) {
        _barImageView = [[ThemeImageView alloc]initWithFrame:CGRectMake(5, -40, kScreenWidth-10, 40)];
        _barImageView.imageName = @"timeline_notify.png";
        [self.view addSubview:_barImageView];
        
        _barLabel = [[ThemeLabel alloc]initWithFrame:_barImageView.bounds];
        _barLabel.backgroundColor = [UIColor clearColor];
        _barLabel.textAlignment = NSTextAlignmentCenter;
        _barLabel.colorName = @"Timeline_Notice_color";
        [_barImageView addSubview:_barLabel];
    }
    if (count > 0) {
        _barLabel.text = [NSString stringWithFormat:@"更新了%li条微博",count];
        [UIView animateWithDuration:.6 animations:^{
            _barImageView.transform = CGAffineTransformMakeTranslation(0, 64+40+5);
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:.6 animations:^{
               
                [UIView setAnimationDelay:1];
                _barImageView.transform = CGAffineTransformIdentity;
            }];
            
        }];
    }
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
    
    NSURL *url = [NSURL fileURLWithPath:path];
    
    //注册系统声音
    SystemSoundID soundID;//0
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
    AudioServicesPlaySystemSound(soundID);
}


@end
