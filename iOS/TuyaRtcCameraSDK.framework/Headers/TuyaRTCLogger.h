//
//  TuyaRTCLogger.h
//  AppRtciOSMobile
//
//  Created by 黄敬佩 on 2021/6/24.
//

#ifndef TuyaRTCLogger_h
#define TuyaRTCLogger_h

#import "TuyaRTCEngine.h"
@interface TuyaRTCLogger : NSObject

+(instancetype _Nonnull ) getInstance;

-(void)setLogConfigure:(NSString* _Nonnull) filePath
         loggerHandler:(nullable TuyaRTCLoggerHandler)handler
              logLevel:(int) level;
@end


#endif /* TuyaRTCLogger_h */
