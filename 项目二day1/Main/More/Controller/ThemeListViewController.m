//
//  ThemeListViewController.m
//  项目二day1
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "ThemeListViewController.h"
#import "MoreViewController.h"
#import "MoreTableViewCell.h"

static NSString *moreCellId = @"moreCellId";
@interface ThemeListViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_table;
    NSDictionary *_themeList;
    NSArray *_themeKeys;
}
@end

@implementation ThemeListViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return  self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self _creatTable];
}

- (void)_creatTable {
    
    _table = [[UITableView alloc]initWithFrame:self.view.bounds];
    _table.delegate = self;
    _table.dataSource = self;
    _table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_table];
    
    NSString *configPath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
    
    _themeList = [NSDictionary dictionaryWithContentsOfFile:configPath];
    [_table registerClass:[MoreTableViewCell class] forCellReuseIdentifier:moreCellId];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _themeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    MoreTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:moreCellId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
        _themeKeys = _themeList.allKeys;
        
        cell.themeLabel.text = _themeKeys[indexPath.row];
    
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ThemeManger *manger = [ThemeManger shareInstance];
    manger.themeName = _themeKeys[indexPath.row];
    
    [_table reloadInputViews];

}


@end
