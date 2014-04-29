//
//  AHMonitorSourceController.h
//  Arch
//
//  Created by LiuNian on 14-4-29.
//
//

#import <Foundation/Foundation.h>

typedef enum
{
    apprunCategory,
    networkflowCategory
    
}MonitorSourceCategory;

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
/**
 *  获取监测源类别
 *
 *  @return id
 */
-(MonitorSourceCategory)getMonitorSourceCategory;

@end

@interface AHMonitorSourceController : NSObject

@property (nonatomic,strong) NSMutableArray *monitorSources;//监测源集合

+(AHMonitorSourceController *)shareInstance;

-(void)runMonitors;

-(void)stopMonitors;

-(void)addMonitorWithtMonitorSourceId:(NSString *)monitorSourceId;

-(void)removeMonitorWithMonitorSourceId:(MonitorSourceCategory)monitorSourceCategory;




@end
