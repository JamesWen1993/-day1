//
//  BaseModal.h
//  项目二day1
//
//  Created by mac on 15/10/10.
//  Copyright (c) 2015年 huiwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModal : NSObject
/**
 建立映射字典
 { key =  propertyName：value = 字段name(数据字典的key)}
 userName ： user_name
 
 
 */

// 初始化方法
-(id)initWithDataDic:(NSDictionary*)dataDic;

// 属性映射
- (NSDictionary *)attributeMapDictionary;

//设置属性
- (void)setAttributes:(NSDictionary *)dataDic;
@end
