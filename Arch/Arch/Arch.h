//
//  Arch.h
//  Arch
//
//  Created by LiuNian on 14-4-10.
//
//

#import <Foundation/Foundation.h>

@interface Arch : NSObject

@property (nonatomic,strong) NSString *appId;

+(Arch *)shareInstanceWithAppid:(NSString *)appid;

//启动监测
-(void)startMonitor;
//停止监测
-(void)stopMonitor;

-(void)addEventPoint:(NSString *)label withUserInfo:(NSDictionary *)userinfo;

@end
