//
//  LeftViewController.m
//  项目二day1
//
//  Created by mac on 15/10/10.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "LeftViewController.h"

@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_sectionTitles;
    NSArray *_rowTitles;
}
@end

@implementation LeftViewController

- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange:) name:kThemeNameDidChangeNotification object:nil];
        
    }
    return self;
}

- (void)themeDidChange:(NSNotification *)notification{
    
    
    [self loadImage];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    [self _loadData];
    [self _creatTable];



    
}

- (void)_creatTable {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(-5, 0, 150, kScreenHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.backgroundColor = nil;
    _tableView.backgroundView = nil;
    // 设置内填充
    _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    [self.view addSubview:_tableView];
    
}

- (void)_loadData {
    _sectionTitles = @[@"界面切换效果",@"图片浏览模式"];
    
    _rowTitles =  @[@[@"无",
                      @"偏移",
                      @"偏移&缩放",
                      @"旋转",
                      @"视差"],
                    @[@"小图",
                      @"大图"]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_rowTitles[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"leftCell";
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    cell.textLabel.text = _rowTitles[indexPath.section][indexPath.row];
    
    
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ThemeLabel *sectionLabel = [[ThemeLabel alloc]initWithFrame:CGRectMake(0, 0, 160, 50)];
    sectionLabel.colorName = @"More_Item_Text_color";
    sectionLabel.backgroundColor = [UIColor clearColor];
    sectionLabel.font = [UIFont systemFontOfSize:18];
    sectionLabel.text = [NSString stringWithFormat:@"  %@",_sectionTitles[section]];
    
    return sectionLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
@end
