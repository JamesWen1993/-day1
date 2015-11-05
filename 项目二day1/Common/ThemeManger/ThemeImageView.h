//
//  ThemeImageView.h
//  项目二day1
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeImageView : UIImageView


@property (nonatomic, copy)NSString *imageName;

@property (nonatomic, assign)CGFloat leftCap;//向左拉伸图片

@property (nonatomic, assign)CGFloat topCap;
@end
