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


#import "TuyaRTCCamera.h"
NS_ASSUME_NONNULL_BEGIN

typedef void (^TuyaRTCLoggerHandler)(NSString * message);

/**
 * 提供给上层调用API初始化引擎时候传递的参数之一，用于通知App层一些引擎处理事件。
 */
@protocol TuyaRTCEngineDelegate <NSObject>
@optional
-(void) didLogMessageWith:(NSString* ) msg;


@end

/**
 * 引擎实现类，包含了初始化引擎、销毁引擎、创建camera、销毁camera等功能。
 */
@interface TuyaRTCEngine : NSObject

@property(nonatomic, weak) id<TuyaRTCEngineDelegate> delegate;


-(instancetype)initRtcEngineWithClientId:(NSString*) clientId
                                secretId:(NSString*)secretId
                              authCodeId:(NSString*)authCodeId
                                delegate:(id<TuyaRTCEngineDelegate>)delegate;

-(void)destoryRtcEngine;

-(TuyaRTCCamera*)createTuyaCameraWithDid:(NSString*)deviceId;

-(void)destoryTuyaCameraWithDid:(NSString*)deviceId;

+(void)setLogConfigureWith:(nullable NSString*)filePath
             loggerHandler:(TuyaRTCLoggerHandler)handler
                     level:(int)level;


@end

NS_ASSUME_NONNULL_END

