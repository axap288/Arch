//
//  IRAssistant.h
//  iRDataCollectorForAppStore
//
//  Created by LiuNian on 13-9-29.
//  Copyright (c) 2013年 LN. All rights reserved.
//

#define PROPERTY_FILE @"IRProperty"


@interface IRAssistant : NSObject

//指示器
+ (void)showProgressHUDMessage:(NSString *)message toVIew:(UIView *)view;

+ (id)getJsonValue:(NSString *)string ;

+ (NSString *)makeJsonString:(id)objects ;

+(NSString *)getPropertyWithKey:(NSString *)key;

//流量单位换算
+(NSString *)bytesToAvaiUnit:(int)bytes;
//自定义返回按钮
+(void)addCunstomBackButton:(UIViewController *)vc;

//取整点时间
+ (NSDate *)getNextIntegralHourDate;

+(NSString *)getDateFormateYYMMDD;

//网络请求
+(NSString *)serverRequest:(NSString *)url;
//发送文件到服务器
+(BOOL)sendFileToHTTPServer:(NSString *)postURLStr withFilePath:(NSString *)filepath;

@end
