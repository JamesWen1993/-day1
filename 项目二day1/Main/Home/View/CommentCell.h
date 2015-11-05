//
//  CommentCell.h
//  项目二day1
//
//  Created by mac on 15/10/16.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentsModel.h"

#import "WXLabel.h"

@interface CommentCell : UITableViewCell<WXLabelDelegate>
{
    WXLabel *_commentLabel;
}

@property (strong, nonatomic) IBOutlet UIImageView *otherImageView;
@property (strong, nonatomic) IBOutlet UILabel *otherLabel;



@property (strong,nonatomic)CommentsModel *model;

+ (float)getCommentHeight:(CommentsModel *)model ;
@end
