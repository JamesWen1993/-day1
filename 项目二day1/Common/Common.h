//
//  Common.h
//  项目二day1
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#ifndef ___day1_Common_h
#define ___day1_Common_h



#define kVersion   [[UIDevice currentDevice].systemVersion doubleValue]
#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height

#define kAppKey             @"2367948591"
#define kAppSecret          @"a3edc240942514e6842e4bc2f99b491f"
#define kAppRedirectURI     @"http://www.baidu.com"

#define kThemeNameDidChangeNotification  @"kThemeNameDidChangeNotification"

#define kThemeName  @"kThemeName"

#define unread_count @"remind/unread_count.json"  //未读消息
#define home_timeline @"statuses/home_timeline.json"  //微博列表
#define comments  @"comments/show.json"   //评论列表
#define send_update @"statuses/update.json"  //发微博(不带图片)
#define send_upload @"statuses/upload.json"  //发微博(带图片)
#define geo_to_address @"location/geo/geo_to_address.json"  //查询坐标对应的位置
#define nearby_pois @"place/nearby/pois.json" // 附近商圈
#define nearby_timeline  @"place/nearby_timeline.json" //附近动态
#define user_timeline  @"statuses/user_timeline.json"  //个人

#define kLogin @"kLogin"

//微博字体
#define FontSize_weibo(isDetail) isDetail?16:15   //微博字体
#define FontSize_Reweibo(isDetail) isDetail?15:14 //转发字体

#endif



