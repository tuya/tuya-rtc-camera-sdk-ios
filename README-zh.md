
# TuyaRTCCameraSDK - RTCCamera 音视频开发套件

[English](README.md)|[中文版](README-zh.md)

## 功能概述
TuyaRTCCamera SDK是一套基于WebRTC技术的音视频综合解决方案，通过本SDK可以方便的接入Tuya IoT Colud，然后对Tuya IoT设备
进行一些列的交互操作，尤其是对音视频处理和控制是本SDK的核心功能。
通过该sdk可以完成以下核心功能
- 预览Camera的内容
- 录制Camera的内容
- JPEG 抓屏
- 支持与摄像头进行交互操作

## 集成SDK的步骤
### 第一步
修改ARDVideoCallView.m文件中的方法- (instancetype)initWithFrame:(CGRect)frame几个变量
``` c
    ...
    _clientId = @"input your client id";
    _secret = @"input your client id";
    _deviceId = @"input your client id";
    _authCode = @"input your client id";
    ...
``` 

### 第二步
copy 库文件
- 把Libraries的某一个版本下的framework文件copy到当前的工程中放入合适的位置，确保可以被正确链接

## 能力概述

**接口说明**

**TuyaRTCEngine接口说明**

| 参数 | 说明 |
| :------------ | :------------------------------------------------------------------- |
| initRtcEngineWithClientId:secretId:authCodeId:regionCode:delegate: | 引擎初始化 |
| destoryRtcEngine | 销毁引擎 |
| createTuyaCameraWithDid: | 创建一个TuyaRTCCamera对象，每个对象对应一个Camera或者Stream |
| destoryTuyaCameraWithDid: | 销毁一个TuyaRTCCamera对象 |
| setLogConfigureWith:loggerHandler:level | 设置SDK的log输出. |
| getSdkVersion | 获取SDK版本信息 |
| getBuildTime | 获取SDK编译时间 |


**TuyaRTCCamera接口说明**
| 参数 | 说明 |
| :------------ | :------------------------------------------------------------------- |
| startPreview:delegate: | 开始预览Camera的内容 |
| stopPreview | 停止预览Camera的内容 |
| startRecordWithPath: | 开始录制Camera的内容 |
| stopRecord | 停止录制Camera的内容 |
| snapShot: | 抓拍Camera的画面 |
| genMp4Thumbnail | 生成MP4文件的封面 |
| muteRemoteAudioWith: | 对Camera声音进行静音操作 |
| muteRemoteVideoWith: | 对Camera画面进行开关操作 |
| getRemoteAudioMute     | 获取Camera声音的静状态 |
| getRemoteVideoMute | 获取Camera视频的开关状态 |


**TuyaRTCEngineDelegate接口说明**
| 参数 | 说明 |
| :------------ | :------------------------------------------------------------------- |
| didLogMessageWith: | SDK中的log输出回调函数 |
| didInitalized | SDK初始化成功时候的回调函数 |
| didDestoryed | SDK销毁成功时候的回调函数 |

**TuyaRTCCameraDelegate接口说明**
| 参数 | 说明 |
| :------------ | :------------------------------------------------------------------- |
| rtcCamera:didVideoFrame | 当前Camera的的视频数据回调函数 |
| rtcCamera:didFristVideoFrameWith:andHeight | 当前Camera的第一帧视频数据回调函数 |
| rtcCamera:didResolutionChangedWithOldWidth:andOldHeight:andNewWidth:andNewHeight: | 当前Camera的视频分辨率变化时候的回调函数 |

## RegionCode 对照表
| 区域缩写 | 范围 |
| :------------ | :------------------------------------------------------------------- |
| cn | China |
| us | America |
| eu | Europe |
| in | India |
| ue | EasternAmerica |
| we | WesternEurope |

## Docs
请参阅[API Reference](doc/index/index.html)，在阅读之前请把代码下载到本地，然后在用浏览器打开

## 用例代码

- 头文件
``` c

#ifndef P2PEngine_h
#define P2PEngine_h
#import <Foundation/Foundation.h>
#import <WebRTC/RTCVideoRenderer.h>
#import "TuyaRtcCameraSDK/TuyaRtcCameraSDK.h"


@interface P2PEngine : NSObject

-(void)initialize:clientId secret:(NSString*) secret authCode:(NSString*) authCode delegate:(id<TuyaRTCEngineDelegate>) delegate;
-(void)destory;

-(int)startPreview:did  renderer:(id<RTC_OBJC_TYPE(RTCVideoRenderer)>) renderer;
-(int)stopPreview:did;

-(int)startRecord:did mp4File:(NSString*) mp4File;
-(int)stopRecord:did;


-(int)snapshot:did jpgFile:(NSString*) jpgFile;

-(int) muteAudio:did mute:(BOOL) mute;
-(int) muteVideo:did mute:(BOOL) mute;

-(BOOL) getAudioMute:did;

-(BOOL) getVideoMute:did;
@end


#endif /* P2PEngine_h */


``` 

源文件

``` c

#import <Foundation/Foundation.h>
#import "P2PEngine.h"

#pragma mark -- P2PCamera interface

@interface P2PCamera : NSObject<TuyaRTCCameraDelegate>
@property(nonatomic, weak) TuyaRTCEngine* engine;
@end


#pragma mark -- P2PCamera imp

@implementation P2PCamera {
    NSString* _did;
    TuyaRTCCamera* _camera;
}
@synthesize engine = _engine;

-(instancetype)initP2PCamera:(NSString*) deviceId
                               engineRef:(TuyaRTCEngine*)engine {
    if (self = [super init]) {
        _did = deviceId;
        _engine = engine;
        _camera = [_engine createTuyaCameraWithDid:deviceId];
    }
    return self;
}

-(int)startPreview:(id<RTC_OBJC_TYPE(RTCVideoRenderer)>) renderer {
    [_camera startPreview:renderer delegate:self];
    return 0;
}

-(int)stopPreview {
    [_camera stopPreview];
    return 0;
}

-(int)startRecord:(NSString*) mp4File {
    [_camera startRecordWithPath:mp4File];
    return 0;
}

-(int)stopRecord {
    [_camera stopRecord];
    return 0;
}

-(int)snapshot:(NSString*) jpgFile {
    [_camera snapShot:jpgFile];
    return 0;
}

-(int) muteAudio:(BOOL) mute {
    [_camera muteRemoteAudioWith:mute];
    return 0;
}

-(int) muteVideo:(BOOL) mute {
    [_camera muteRemoteVideoWith:mute];
    return 0;
}

-(BOOL) getAudioMute {
    return [_camera getRemoteAudioMute];
}


-(BOOL) getVideoMute {
    return [_camera getRemoteVideoMute];
}


- (void)rtcCamera:(TuyaRTCCamera * _Nonnull)camera onFristVideoFrameWith:(NSInteger)width
        andHeight:(NSInteger)height {
    
}

- (void)rtcCamera:(TuyaRTCCamera * _Nonnull)camera onResolutionChangedWithOldWidth:(NSInteger)oldWidth
     andOldHeight:(NSInteger)oldHeight
      andNewWidth:(NSInteger)newWidth
     andNewHeight:(NSInteger)newHeight {
    
}

- (void)rtcCamera:(TuyaRTCCamera * _Nonnull)camera onVideoFrame:(void * _Nonnull)frame { 

}

@end


#pragma mark -- P2PEngine
@class P2PCamera;
@implementation P2PEngine {
    TuyaRTCEngine *_tuyaRTCEngine;
    NSMutableDictionary *_p2pCameras;
}

-(void)initialize:clientId secret:(NSString*) secret authCode:(NSString*) authCode delegate:(id<TuyaRTCEngineDelegate>) delegate {
    [TuyaRTCEngine setLogConfigureWith:nil loggerHandler:^(NSString * _Nonnull message) {
        NSLog(@"======>%s", message.UTF8String);
    } level:3];
    _tuyaRTCEngine = [[TuyaRTCEngine alloc] initRtcEngineWithClientId:clientId secretId:secret authCodeId:authCode regionCode:@"cn" delegate:delegate];
    
}

-(void)destory {
    [_tuyaRTCEngine destoryRtcEngine];
    
}

-(int)startPreview:did  renderer:(id<RTC_OBJC_TYPE(RTCVideoRenderer)>) renderer  {
    P2PCamera *camera = [[P2PCamera alloc] initP2PCamera:did engineRef:_tuyaRTCEngine];
    [camera startPreview:renderer];
    [_p2pCameras setObject:camera forKey:did];
    return 0;
}
-(int)stopPreview:did {
    P2PCamera* camera = [_p2pCameras objectForKey:did];
    if (camera != nil) {
        [camera stopPreview];
    }

    return 0;
}

-(int)startRecord:did mp4File:(NSString*) mp4File {
    P2PCamera* camera = [_p2pCameras objectForKey:did];
    if (camera != nil) {
        [camera startRecord:mp4File];
    }
    return 0;
}
-(int)stopRecord:did {
    P2PCamera* camera = [_p2pCameras objectForKey:did];
    if (camera != nil) {
        [camera stopPreview];
    }
    return 0;
}


-(int)snapshot:did jpgFile:(NSString*) jpgFile {
    P2PCamera* camera = [_p2pCameras objectForKey:did];
    if (camera != nil) {
        [camera snapshot:jpgFile];
    }
    return 0;
}

-(int) muteAudio:did mute:(BOOL) mute {
    P2PCamera* camera = [_p2pCameras objectForKey:did];
    if (camera != nil) {
        [camera muteAudio:mute];
    }
    return 0;
}
-(int) muteVideo:did mute:(BOOL) mute {
    P2PCamera* camera = [_p2pCameras objectForKey:did];
    if (camera != nil) {
        [camera muteVideo:mute];
    }
    return 0;
}

-(BOOL) getAudioMute:did {
    P2PCamera* camera = [_p2pCameras objectForKey:did];
    if (camera != nil) {
        [camera getAudioMute];
    }
    return YES;
}

-(BOOL) getVideoMute:did {
    P2PCamera* camera = [_p2pCameras objectForKey:did];
    if (camera != nil) {
        [camera getVideoMute];
    }
    return YES;
}
@end


``` 