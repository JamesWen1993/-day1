//
//  WeiboAnnotationView.m
//  项目二day1
//
//  Created by mac on 15/10/21.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "WeiboAnnotationView.h"
#import "WeiBoAnnotation.h"
#import "UIImageView+WebCache.h"
@implementation WeiboAnnotationView

//- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
//    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
//    if (self) {
//        self.bounds = CGRectMake(0, 0, 100, 40);
//        [self _createViews];
//    }
//    return self;
//}
//
//
//
//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        self.bounds = CGRectMake(0, 0, 100, 40);
//        [self _createViews];
//    }
//    return self;
//}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.bounds = CGRectMake(0, 0, 100, 40);
        [self _createViews];
    }
    return self;
}

- (void)_createViews {
    //头像视图
    _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self addSubview:_headImageView];
    
    _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 100, 40)];
    _textLabel.backgroundColor = [UIColor lightGrayColor];
    _textLabel.textColor = [UIColor blackColor];
    _textLabel.font = [UIFont systemFontOfSize:13];
    _textLabel.numberOfLines = 3;
    [self addSubview:_textLabel];

    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    WeiBoAnnotation *annotation = super.annotation;
    WeiboModel *model = annotation.model;
    
    _textLabel.text = model.text;
    
    NSString *url = model.userModal.profile_image_url;
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"004"]];
    
}
@end
