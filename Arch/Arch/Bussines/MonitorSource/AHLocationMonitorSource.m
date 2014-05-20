//
//  AHLocationMonitorSource.m
//  ArchTracker
//
//  Created by LiuNian on 14-5-19.
//
//

#import "AHLocationMonitorSource.h"
#import "AHAssistant.h"
#import "AHConstant.h"

@implementation AHLocationMonitorSource
{
    CLLocationManager *  locationManager;
    CLLocationCoordinate2D   curLocation;
    BOOL hasLocated;
    NSMutableDictionary *locationResultDic;

}

-(id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(float)onceIntervalTime
{
    return 60;
}

-(NSDictionary *)startMonitorSourceAndGetResult
{
    if (locationManager==nil)
    {
        locationManager =[[CLLocationManager alloc] init];
    }
    
    if ([CLLocationManager locationServicesEnabled])
    {
        locationManager.delegate=self;
        locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        locationManager.distanceFilter=10.0f;
        [locationManager startUpdatingLocation];
    }
    hasLocated = NO;
    
    //判断是否得到数据
    while (!locationResultDic) {
        sleep(1);
    }
    
    NSDictionary *result = [locationResultDic copy];
    locationResultDic = nil;
    
    return result;
}

-(void)endLocationTask
{
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
    locationManager = nil;
}


#pragma mark -
#pragma mark CLLocationManagerDelegate


-(MonitorSourceCategory)getMonitorSourceCategory
{
    return locationCategory;
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (hasLocated) {
        return;
    }else{
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            if(placemarks && placemarks.count > 0)
            {
                curLocation = newLocation.coordinate;
                NSLog(@"经度:%.20f",curLocation.longitude);
                NSLog(@"纬度:%.20f",curLocation.latitude);
                //                //do something
                CLPlacemark *topResult = [placemarks objectAtIndex:0];
                NSLog(@"name:%@",topResult.name);
                NSLog(@"thoroughfare:%@",topResult.thoroughfare);
                NSLog(@"locality:%@",topResult.locality);
                NSLog(@"subLocality:%@",topResult.subLocality);
                NSLog(@"administrativeArea:%@",topResult.administrativeArea);
                NSLog(@"subAdministrativeArea:%@",topResult.subAdministrativeArea);
                NSLog(@"ISOcountryCode:%@",topResult.ISOcountryCode);
                NSLog(@"country:%@",topResult.country);
                NSLog(@"inlandWater:%@",topResult.inlandWater);
                NSLog(@"areasOfInterest:%@",topResult.areasOfInterest);
                
//                CLPlacemark *topResult = [placemarks objectAtIndex:0];
                locationResultDic = [NSMutableDictionary dictionary];
                [locationResultDic setObject:@"" forKey:@"province"];
                [locationResultDic setObject:topResult.administrativeArea == nil?@"":topResult.administrativeArea forKey:@"city"];
                [locationResultDic setObject:topResult.subLocality == nil ?@"":topResult.subLocality forKey:@"district"];
                [locationResultDic setObject:topResult.name forKey:@"addr"];
                [locationResultDic setObject:V_COUNTRY  forKey:K_COUNTRY];
                [locationResultDic setObject:V_UID forKey:K_UID];
                [locationResultDic setObject:[NSNumber numberWithFloat:curLocation.latitude] forKey:@"radius"];
                [locationResultDic setObject:[NSNumber numberWithFloat:curLocation.longitude] forKey:@"lng"];
                [locationResultDic setObject:V_TS forKey:@"standardtime"];
                
//                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//                [dic setObject:@"" forKey:@"province"];
//                [dic setObject:topResult.administrativeArea == nil?@"":topResult.administrativeArea forKey:@"city"];
//                [dic setObject:topResult.subLocality == nil ?@"":topResult.subLocality forKey:@"district"];
//                [dic setObject:topResult.name forKey:@"addr"];
//                [dic setObject:V_COUNTRY  forKey:K_COUNTRY];
////                [dic setObject:V_TS forKey:K_TS];
//                [dic setObject:V_UID forKey:K_UID];
//                [dic setObject:[NSNumber numberWithFloat:curLocation.latitude] forKey:@"radius"];
//                [dic setObject:[NSNumber numberWithFloat:curLocation.longitude] forKey:@"lng"];
//                [dic setObject:V_TS forKey:@"standardtime"];
                
//                self.logFilePath = [IRFileTool getFullPath:LOG_FILE_LOCATION];
//                NSLog(@"locationFilePath:%@",self.logFilePath);
                
                
//                if (![[NSFileManager defaultManager] fileExistsAtPath:self.logFilePath]) {
//                    [self.locationInfoArray addObject:dic];
//                }else{
//                    self.locationInfoArray = [NSMutableArray arrayWithContentsOfFile:self.logFilePath];
//                    [self.locationInfoArray addObject:dic];
//                }
//                DDLogInfo(@"[位置监测]:位置信息写入到记录文件!");
//                NSLog(@"self.locationInfoArray  : %@",[self.locationInfoArray description]);
//                [self.locationInfoArray writeToFile:self.logFilePath atomically:NO];
            }
        }];
        
        [self endLocationTask];
        hasLocated = YES;
    }
    
    
    
    //    [_search reverseGeocode:curLocation];
    
    //    IRCoreDataManager *cdmanager = [IRCoreDataManager shareInstance];
    //    [cdmanager saveNewLocationWithLatitude:curLocation.latitude andLongitude:curLocation.longitude];
}

@end
