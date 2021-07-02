/*
 *  Copyright 2014 The WebRTC Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import <Foundation/Foundation.h>

//#import "WebRTC/RTCPeerConnection.h"
//#import "WebRTC/RTCVideoTrack.h"
//#import "WebRTC/RTCFileVideoCapturer.h"

@class TuyaRTCCamera;
NS_ASSUME_NONNULL_BEGIN

typedef void (^TuyaRTCLoggerHandler)(NSString * message);

/**
 * This class implements the basic functions of interacting with Camera, including Camera's start pulling/stopping streams, mute/unmute remote stream information, and getting mute status.
 */
@protocol TuyaRTCEngineDelegate <NSObject>
/**
 * This function is called when the engine has been successfully initialized
 */
-(void) didInitalized;
/**
 * This function will be called when the engine has been successfully destroyed
 */
-(void) didDestroyed;


@end

/**
 * This class defines the basic operation of the engine, including the initialization of the engine, destroy the engine, create camera, destroy camera and other functions.
 */
@interface TuyaRTCEngine : NSObject

@property(nonatomic, weak) id<TuyaRTCEngineDelegate> delegate;

/**
 *
 * @param clientId Client Identity
 * @param secretId Secret String
 * @param authCode Authentication Code
 * @param regionCode Regional abbreviation ，Regional abbreviation ，{"cn", "us", "eu", "in", "ue","we"},
 *                  Please refer to the documentation <a href="https://github.com/tuya/tuya-rtc-camera-sdk-android/blob/master/README-ZH.md">RegionCode Comparison Table</a>
 * @param delegate The delegate  of the Engine

 */
-(instancetype)initRtcEngineWithClientId:(NSString*)clientId
                                secretId:(NSString*)secretId
                              authCodeId:(NSString*)authCode
                              regionCode:(NSString*)regionCode
                                delegate:(id<TuyaRTCEngineDelegate>)delegate;
/**
 * Destroy the engine. After destroying the engine, all functions should not call any function.
 */
-(void)destroyRtcEngine;

/**
 * Create a Camera (stream) object based on the device id
 * @param deviceId Device Identity
 * @return return Camera(stream）
 */
-(TuyaRTCCamera*)createTuyaCameraWithDid:(NSString*)deviceId;

/**
 * Destroy the object of the corresponding Camera(stream) according to the device id
 * @param deviceId  Device Identity
 */
-(void)destroyTuyaCameraWithDid:(NSString*)deviceId;


/**
 * Set the log level and the name of the log file
 * @param filePath Save the name of the log file, can be nil, if not nil, you need to pass the absolute path of the file, otherwise, no file saving will be done for the log
 * @param handler Callback function for log processing
 * @param level Log level, logs larger than this level in the engine will be output from TuyaRTCEngineDelegate.didLogMessageWith method
 */
+(void)setLogConfigureWith:(nullable NSString*)filePath
             loggerHandler:(TuyaRTCLoggerHandler)handler
                     level:(int)level;


/**
 * Get the version number of the SDK, currently in Beta status
 * @return String for version number
 */

+(NSString*)getSdkVersion;

/**
 * Get the compile time of the SDK version,the returned time string is calculated with (Asia/Shanghai) as the current time zone.
 * @return String for the building time.
 */
+(NSString*)getBuildTime;


@end

NS_ASSUME_NONNULL_END

