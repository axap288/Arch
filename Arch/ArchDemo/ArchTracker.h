//
//  Arch.h
//  Arch
//
//  Created by LiuNian on 14-4-10.
//
//

#import <Foundation/Foundation.h>

@interface ArchTracker : NSObject

@property (nonatomic,strong) NSString *appId;


+(ArchTracker *)shareInstance;

/**
 *  启动系统检测
 */
-(void)startMonitor;
/**
 *  停止系统监测
 */
-(void)stopMonitor;
/**
 *  启动用户行为跟踪
 *
 *  @param appid
 */
-(void)startTrackerWithAppId:(NSString *)appid;
/**
 *  跟踪一个用户行为
 *
 *  @param label    event名称
 *  @param action   动作描述
 *  @param userinfo 附加信息
 */
-(BOOL)trackEvent:(NSString *)label action:(NSString *)action withUserInfo:(NSDictionary *)userinfo;

@end
