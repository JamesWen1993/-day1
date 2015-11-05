//
//  MoreViewController.m
//  项目二day1
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "MoreViewController.h"
#import "ThemeListViewController.h"
#import "AppDelegate.h"
#import "MoreTableViewCell.h"

static NSString *moreCellId = @"moreCellId";
@interface MoreViewController ()<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    UITableView *_table;

}



@end

@implementation MoreViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _login = [[NSUserDefaults standardUserDefaults] valueForKey:kLogin];
        if (_login.length ==0) {
            _login = @"登出当前账号";
        }
        
    }
    return self;
}

- (void)setLogin:(NSString *)login {
    if (![_login isEqualToString:login]) {
        _login = [login copy];
        //把主题名数据记录保存持久化到本地
        [[NSUserDefaults standardUserDefaults] setObject:_login forKey:kLogin];
        //读取数据
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"更多";
    
    [self _creatTable];

    
}

//每次出现的时候重新刷新数据
- (void)viewWillAppear:(BOOL)animated{
    
    [_table reloadData];
    
}

- (void)_creatTable {
    
    _table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _table.delegate = self;
    _table.dataSource = self;
    _table.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_table];
    
    [_table registerClass:[MoreTableViewCell class] forCellReuseIdentifier:moreCellId];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:moreCellId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.themeImageView.imageName = @"more_icon_theme.png";
            cell.themeLabel.text = @"主题选择";
            cell.themeDetailLabel.text = [ThemeManger shareInstance].themeName;
            
        }else if (indexPath.row == 1) {
            
            cell.themeImageView.imageName = @"more_icon_account.png";
            cell.themeLabel.text = @"账户管理";
            
        }
    }else if (indexPath.section == 1) {
        
        cell.themeImageView.imageName = @"more_icon_feedback.png";
        cell.themeLabel.text = @"意见反馈";
        
    }else if (indexPath.section == 2) {
        
        cell.themeLabel.text = _login;
        cell.themeLabel.textAlignment = NSTextAlignmentCenter;
        
        cell.themeLabel.center = cell.contentView.center;
    }
    
    //设置箭头
    if (indexPath.section !=2) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }else {
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if (section == 0) {
        return 2;
    }
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //进入主题选择页面
    if (indexPath.row == 0 && indexPath.section == 0) {
        ThemeListViewController *vc = [[ThemeListViewController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    //登出
    if (indexPath.section == 2 && indexPath.row == 0) {
        if ([_login isEqualToString:@"登出当前账号"]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认登出么?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            
            [alert show];
            
            _login = @"登陆微博";
            
            [_table reloadData];
        }else {
            
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [app.sinaWeibo logIn];
            
            _login = @"登出当前账号";
            [_table reloadData];
        }
        
        
        
    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex ==1 ) {
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.sinaWeibo logOut];
    }
}


@end
