//
//  Arch.h
//  Arch
//
//  Created by LiuNian on 14-4-10.
//
//

#import <Foundation/Foundation.h>

@interface Arch : NSObject

+(Arch *)shareInstanceWithAppid:(NSString *)appid;

-(void)addEventPoint:(NSString *)label withUserInfo:(NSDictionary *)userinfo;

-(void)startMonitor;

-(void)stopMonitor;

@end
