//
//  AHMonitorSourceController.h
//  Arch
//
//  Created by LiuNian on 14-4-29.
//
//

#import <Foundation/Foundation.h>


/**
 *  监测源要遵循的协议
 */
@protocol MonitorSource <NSObject>

@required
/**
 *  运行一次的间隔时间
 *
 *  @return 秒数
 */
-(float)onceIntervalTime;
/**
 *  返回监测结果
 *
 *  @return dic形式
 */
-(NSDictionary *)startMonitorSourceAndGetResult;

@end

@interface AHMonitorSourceController : NSObject

@end
