//
//  SendViewController.h
//  项目二day1
//
//  Created by mac on 15/10/19.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "BaseViewController.h"
#import "ZoomView.h"
#import <CoreLocation/CoreLocation.h>

@interface SendViewController : BaseViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZoomImageViewDelegate,CLLocationManagerDelegate>

@end
