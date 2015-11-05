//
//  SendViewController.m
//  项目二day1
//
//  Created by mac on 15/10/19.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import "SendViewController.h"
#import "ZoomView.h"
#import "MMDrawerController.h"
#import "DataService.h"
#import <CoreLocation/CoreLocation.h>




@interface SendViewController ()
{
    UITextView *_textView;
    //2 工具栏
    UIView *_editorBar;
    //3 显示缩略图
    ZoomView *_zoomImageView;
    UIImage *_sendImage;
    //4 位置管理器
    CLLocationManager *_locationManager;
    UILabel *_locationLabel;
}

@end

@implementation SendViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nibBundleOrNil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _creatNavItems];
    [self _creatEditorView];
}
- (void)viewWillAppear:(BOOL)animated {
    //导航栏不透明，当导航栏不透明的时候 ，子视图的y的0位置在导航栏下面
    self.navigationController.navigationBar.translucent = NO;
    _textView.frame = CGRectMake(0, 0, kScreenWidth, 120);
}

//创建左右2边按钮
- (void)_creatNavItems {
    //关闭按钮
    ThemeButton *leftBtn = [[ThemeButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [leftBtn addTarget:self action:@selector(eitAction) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.normalImageName = @"button_icon_close.png";
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem =leftItem;
    
    //发送按钮
    ThemeButton *rightBtn = [[ThemeButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.normalImageName = @"button_icon_ok.png";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem =rightItem;
    
}
//创建文本
- (void)_creatEditorView {
    
    //1 文本输入视图
    if (_textView == nil) {
        
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
        _textView.font = [UIFont systemFontOfSize:16.0f];
        _textView.backgroundColor = [UIColor lightGrayColor];
        _textView.editable = YES;
        _textView.layer.cornerRadius = 10;
        _textView.layer.borderWidth = 2;
        _textView.layer.borderColor = [[UIColor blackColor] CGColor];
        [self.view addSubview:_textView];
        
        //创建工具栏
        _editorBar = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 55)];
        _editorBar.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_editorBar];
        //创建按钮
        NSArray *barImageArray = @[@"compose_toolbar_1.png",
                                   @"compose_toolbar_4.png",
                                   @"compose_toolbar_3.png",
                                   @"compose_toolbar_5.png",
                                   @"compose_toolbar_6.png"];
        CGFloat width = kScreenWidth /5 ;
        for (int i = 0; i < 5; i++) {
            ThemeButton *button = [[ThemeButton alloc]initWithFrame:CGRectMake(15+i * width , 30, 40, 30)];
            button.tag = i +10;
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.normalImageName = barImageArray[i];
            [_editorBar addSubview:button];
        }
        //3 创建label 显示位置信息
        _locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        _locationLabel.hidden = YES;
        _locationLabel.font = [UIFont systemFontOfSize:14];
        _locationLabel.backgroundColor = [UIColor grayColor];
        [_editorBar addSubview:_locationLabel];
        
        [_textView becomeFirstResponder];
    }
    
    
    
    
}

- (void)buttonAction:(UIButton *)btn {
    if (btn.tag == 10) {
        //选择照片
        [self _selectPhoto];
    }if (btn.tag == 13) {
        [self _location];
    }
}


//关闭按钮
- (void)eitAction {
    //通过UIWindow找到  MMDRawer
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if ([window isKindOfClass:[MMDrawerController class]]) {
        MMDrawerController *mmDrawer = (MMDrawerController *)window.rootViewController;
        [mmDrawer closeDrawerAnimated:YES completion:NULL];
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}
//发送按钮
- (void)sendAction {
    NSString *test = _textView.text;
    NSString *error = nil;
    if (test.length == 0) {
        error = @"内容为空";
    }else if (test.length > 140) {
        error = @"字符大于140";
    }
    if (error != nil){
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:error delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    //发送
    
    
    AFHTTPRequestOperation *operation = [DataService sendWeibo:_textView.text image:_sendImage block:^(id result) {
        NSLog(@"%@",result);
        [self showStatusTip:@"发送成功" show:NO operation:nil];
    }];
    [self showStatusTip:@"正在发送" show:YES operation:operation];
    [self eitAction];
}

#pragma mark - 选择照片
- (void)_selectPhoto {
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    [sheet showInView:self.view];
    
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //相册属性
    UIImagePickerControllerSourceType sourceType;
    //拍照
    if (buttonIndex == 0) {
        
        sourceType = UIImagePickerControllerSourceTypeCamera;
        //检测相册前置摄像头是否损坏
        BOOL iscamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!iscamera) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"摄像头无法使用" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            
            return;
        }
    }else if (buttonIndex == 1) { //选择相册
        
        sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
    } else {
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = sourceType;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}
//照片选择代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //弹出相册控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    //2 取出照片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //3 显示缩略图
    if (_zoomImageView == nil) {
        _zoomImageView = [[ZoomView alloc] initWithImage:image];
        _zoomImageView.frame = CGRectMake(10, _textView.bottom+10, 80, 80);
        [self.view addSubview:_zoomImageView];
        _zoomImageView.delegate = self;
    }
    _zoomImageView.image = image;
    
    _sendImage = image;
}

#pragma mark - 键盘弹出通知
- (void)keyBoardWillShow:(NSNotification *)notification {
    
    
    //1 取出键盘frame,这个frame 相对于window的
    NSValue *bounsValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect frame = [bounsValue CGRectValue];
    //2 键盘高度
    CGFloat height = frame.size.height;
    
    //3 调整视图的高度
    _editorBar.bottom = kScreenHeight - height - 64 - 10;
}


#pragma mark - 图片放大缩小通知 
- (void)imageWillZoomIn:(ZoomView *)imageView {
    [_textView resignFirstResponder];
}
- (void)imageWillZoomOut:(ZoomView *)imageView {
    [_textView becomeFirstResponder];
}

#pragma mark - 地理位置 
- (void)_location {
    
    /*
     修改 info.plist 增加以下两项
     NSLocationWhenInUseUsageDescription  BOOL YES
     NSLocationAlwaysUsageDescription         string “提示描述”
     */
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc]init];
        //判断系统版本信息 ，如果大于8.0 则调用以下方法获取授权
        if (kVersion > 8.0) {
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    //设置定位精度
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    _locationManager.delegate = self;
    //开始定位
    [_locationManager startUpdatingLocation];
    
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //停止定位
    [manager stopUpdatingLocation];
    //取得地理位置信息
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSLog(@"经度 ：%lf,纬度： %lf",coordinate.longitude,coordinate.latitude);
    //地理位置反编码
    //一 新浪位置反编码 接口说明  http://open.weibo.com/wiki/2/location/geo/geo_to_address
    NSString *coordinateStr = [NSString stringWithFormat:@"%f,%f",coordinate.longitude,coordinate.latitude];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    [params setObject:coordinateStr forKey:@"coordinate"];
    
    __weak SendViewController *weakSelf = self;
    
    [DataService requestAFUrl:geo_to_address httpMethod:@"GET" params:params data:nil block:^(id result) {
        NSArray *geos = [result objectForKey:@"geos"];
        if (geos.count > 0) {
            NSDictionary *geoDic = [geos lastObject];
            NSString *adress = [geoDic objectForKey:@"address"];
            NSLog(@"%@",adress);
            
            __strong SendViewController *strong = weakSelf;
            strong ->_locationLabel.hidden = NO;
            strong ->_locationLabel.text =adress;
        }
        
    }];
    
    
//    //二 iOS内置 反编码
//    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
//    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
//        
//        CLPlacemark *place = [placemarks lastObject];
//        NSLog(@"%@",place.name);
//        
//    }];
    
    
}
@end
