//
//  AHLocationMonitorSource.h
//  ArchTracker
//
//  Created by LiuNian on 14-5-19.
//
//

#import <Foundation/Foundation.h>
#import "AHMonitorSourceController.h"
#import <CoreLocation/CoreLocation.h>


@interface AHLocationMonitorSource : NSObject<MonitorSource,CLLocationManagerDelegate>

@end
