//
//  IRCoreDataManager.h
//  iRDataCollectorForEnterprise
//
//  Created by LiuNian on 13-11-5.
//  Copyright (c) 2013年 LiuNian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AHCoreDataManager : NSObject

+(AHCoreDataManager *)shareInstance;

//获取已保存的APP信息
-(NSArray *)getAPPsInfo;
//获取某个APP的运行信息
-(NSArray *)getAPPRunTimesInfo:(NSString *)packageName;
//保存某个ＡＰＰ的开始和结束运行时间（初始时用）
-(void)saveRunTimeInfoUseCDWithPackageName:(NSString *)packageName startTime:(NSString *)starttime endTime:(NSString *)endTime duration:(NSNumber*)duration;
//保存一个完整的ＡＰＰ信息（包名、应用名、进程名）
-(void)saveAppInfoUseCDWithPackageName:(NSString *)packageName AppName:(NSString *)appName processName:(NSString *)processName;
// 更新某个APP的结束时间
-(void)updateEndTime:(NSString *)packageName endTime:(NSString *)endTime;

-(void)removeAllAppInfos;
-(void)removeAllAppRunTimes;

-(void)saveAppRunInfo:(NSString *)packageName AppName:(NSString *)appName processName:(NSString *)processName startTime:(NSString *)startTime  endTime:(NSString *)endTime;

//保存一个位置信息
-(void)saveNewLocationWithLatitude:(float)latitude andLongitude:(float)longitude;
//获取所有的地址信息
-(NSArray *)getAllLocationInfo;

-(void)removeAllLocationInfo;

//保存一个流量信息
-(void)saveNetFlowInfo:(NSDictionary *)netflowDic;
//获取全部的流量信息
-(NSArray *)getAllNetFlowInfo;
-(void)removeAllNetFlowInfo;

@end
