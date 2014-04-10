//
//  IRFileTool.h
//  iRDataCollectorForAppStore
//
//  Created by LN on 13-9-17.
//  Copyright (c) 2013年 LN. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LOG_FILE_LOCATION     @"IRlocation.log"
#define  LOG_FILE_FLOWRATE  @"iRDeviceflow.log"
#define  LOG_MYSELF @"LocalLOG"

@interface IRFileTool : NSObject

+(void)wirteContent:(NSString *)content toFIle:(NSString *)fileName;

+(NSString *)getFullPath:(NSString *)filename ;

+(BOOL)removeFile:(NSString *)filename;

+(BOOL)removeFileWithFilePath:(NSString *)filepath;

+(NSString *)readContentFromFile:(NSString *)filePath;
//移动文件到指定的文件夹
+(void)movieFile:(NSString *)sourcefileName toDir:(NSString *)dirName;

@end
