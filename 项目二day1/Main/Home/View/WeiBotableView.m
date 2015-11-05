//
//  WeiBotableView.m
//  项目二day1
//
//  Created by mac on 15/10/12.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "WeiBotableView.h"
#import "WeiboModel.h"
#import "WeiboCell.h"
#import "WeiboLayoutFrame.h"
#import "WeiboDetailViewController.h"
#import "UIView+UIViewController.h"

@implementation WeiBotableView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
        
        UINib *nib = [UINib nibWithNibName:@"WeiboCell" bundle:nil];
        [self registerNib:nib forCellReuseIdentifier:@"WeiboCell"];

    }
    return self;
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _layoutArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeiboCell" forIndexPath:indexPath];
    
    WeiboLayoutFrame *layoutFrame = _layoutArray[indexPath.row];
    
    cell.layoutFrame = layoutFrame;
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    WeiboLayoutFrame *layoutFrame = _layoutArray[indexPath.row];
    
    
    return layoutFrame.frame.size.height + 60;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeiboDetailViewController *detailVc = [[WeiboDetailViewController alloc]init];
    
    WeiboLayoutFrame *layout = _layoutArray[indexPath.row];
    
    detailVc.model = layout.weiboModel;
    
    //通过 扩展view类目找viewController:原理，事件响应者链
    [self.viewController.navigationController pushViewController:detailVc animated:YES];
    
    
}
@end
