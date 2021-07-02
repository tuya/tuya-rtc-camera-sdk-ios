
## Tuya RTC Camera SDK - RTCCamera Audio/Video Development Kit



[中文版](README-zh.md)|[English](README.md)

## Features Overview
TuyaRTCCamera SDK is a comprehensive solution for audio and video based on WebRTC technology,
through this SDK you can easily access Tuya IoT Colud and then perform a number of interactive
operations on Tuya IoT devices.
This SDK allows you to easily access the Tuya IoT Colud and perform a number of interactive
operations, especially for audio and video processing and control is the core function of this SDK.
- Preview Camera's content
- Recording Camera's content
- JPEG screen capture
- Support for interacting with the camera

## Steps to integrate the SDK
###  Step 1
Modify some parameters in MainActivity.java to the appropriate ones
``` c
    ...
    _clientId = @"input your client id";
    _secret = @"input your secret";
    _authCode = @"input the auth code";
    _deviceId = @"input the device id";
    ...
``` 

### Step 2
- According to your region, fill in the appropriate regionCode, you can refer to the following content `RegionCode Comparison Table`.
- Here is the parameter that should be filled in with "cn" for my region (Hangzhou, Zhejiang Province, China)
```c
[[TuyaRTCEngine alloc] initRtcEngineWithClientId:clientId 
                                        secretId:secret 
                                        authCodeId:authCode 
                                        regionCode:@"cn" 
                                        delegate:delegate];
```

### Step 3
Copy the library files
- Copy the framework files from one of the Libraries versions to the current project and put it in the right place to make sure it can be linked correctly


## Capabilities Overview

**Interface Description**

**TuyaRTCEngine Interface Description**

| Parameters | Description |
| :------------ | :------------------------------------------------------------------- |
| initRtcEngineWithClientId:secretId:authCodeId:regionCode:delegate: | Engine initialization |
| destroyRtcEngine | Destroy the engine
| createTuyaCameraWithDid:  | Creates a TuyaRTCCamera object, each object corresponds to a Camera or Stream.
| destroyTuyaCameraWithDid:  | Destroy a TuyaRTCCamera object |
| setLogConfigureWith:loggerHandler:level | Set the log output of the SDK. | getSdkVersion
| getSdkVersion | Get the SDK version information.
| getBuildTime | Get the SDK build time |


**TuyaRTCCamera interface description**
| parameters | description |
| :------------ | :------------------------------------------------------------------- |
| startPreview | Start previewing the contents of the Camera |
| stopPreview | Stop previewing the content of the camera.
| startRecord | Start recording the contents of the camera |
| stopRecord | stop recording the content of the Camera
| snapShot | Snap a picture of the camera
| muteAudio | Mute the camera's sound
| muteVideo | Switch the camera screen on/off
| getRemoteAudioMute | Get the mute state of the camera sound.
| getRemoteVideoMute | Get the on/off state of the Camera video


**TuyaRTCEngineHandler interface description**
| parameters | description |
| :------------ | :------------------------------------------------------------------- |
| didInitalized | Callback function for successful SDK initialization |
| diDestroyed | Callback function for successful destruction of the SDK

**TuyaRTCCameraHandler interface description**
| parameters | description |
| :------------ | :------------------------------------------------------------------- |
| rtcCamera:didVideoFrame | The video data callback function for the current camera.
| rtcCamera:didFristVideoFrameWith:andHeight  | The callback function for the first video frame of the current Camera.
| rtcCamera:didResolutionChangedWithOldWidth:andOldHeight:andNewWidth:andNewHeight: | The callback function when the video resolution of the current Camera changes.

## RegionCode Comparison Table
| region abbreviation | range |
| :------------ | :------------------------------------------------------------------- |
| cn | China |
| us | America |
| eu | Europe |
| in | India |
| ue | EasternAmerica |
| we | WesternEurope |


## Docs
Please refer to [API Reference](doc/index/index.html). Before reading, please download the code locally and open it in your browser


## Sample code 


- Header file
``` c

#ifndef P2PEngine_h
#define P2PEngine_h
#import <Foundation/Foundation.h>
#import <WebRTC/RTCVideoRenderer.h>
#import "TuyaRtcCameraSDK/TuyaRtcCameraSDK.h"


@interface P2PEngine : NSObject

-(instancetype)initRtcEngine:clientId
                      secret:(NSString*) secret
                    authCode:(NSString*) authCode
                  regionCode:(NSString*)regionCode
                    delegate:(id<TuyaRTCEngineDelegate>) delegate;
-(void)destroy;

-(int)startPreview:did
          renderer:(id<RTC_OBJC_TYPE(RTCVideoRenderer)>) renderer;
-(int)stopPreview:did;

-(int)startRecord:did
          mp4File:(NSString*) mp4File;
-(int)stopRecord:did;


-(int)snapshot:did
       jpgFile:(NSString*) jpgFile;

-(int)muteAudio:did mute:(BOOL) mute;
-(int)muteVideo:did mute:(BOOL) mute;

-(BOOL)getAudioMute:did;
-(BOOL)getVideoMute:did;
@end


#endif /* P2PEngine_h */



``` 
- Source file

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


- (void)rtcCamera:(TuyaRTCCamera * _Nonnull)camera
didFristVideoFrameWith:(NSInteger)width
        andHeight:(NSInteger)height {
    
}

- (void)rtcCamera:(TuyaRTCCamera * _Nonnull)camera
didResolutionChangedWithOldWidth:(NSInteger)oldWidth
     andOldHeight:(NSInteger)oldHeight
      andNewWidth:(NSInteger)newWidth
     andNewHeight:(NSInteger)newHeight {
    
}

- (void)rtcCamera:(TuyaRTCCamera * _Nonnull)camera
    didVideoFrame:(void * _Nonnull)frame {
    
}

@end


#pragma mark -- P2PEngine
@class P2PCamera;
@implementation P2PEngine {
    TuyaRTCEngine *_tuyaRTCEngine;
    NSMutableDictionary *_p2pCameras;
}

-(instancetype)initRtcEngine:clientId
                   secret:(NSString*) secret
                 authCode:(NSString*) authCode
               regionCode:(NSString*) regionCode
                 delegate:(id<TuyaRTCEngineDelegate>) delegate {
    if (self = [super init]) {
        _p2pCameras = [[NSMutableDictionary alloc] init];
        [TuyaRTCEngine setLogConfigureWith:nil loggerHandler:^(NSString * _Nonnull message) {
            NSLog(@"======>%s", message.UTF8String);
        } level:3];
        _tuyaRTCEngine = [[TuyaRTCEngine alloc] initRtcEngineWithClientId:clientId
                                                                 secretId:secret
                                                               authCodeId:authCode
                                                               regionCode:@"cn"
                                                                 delegate:delegate];
    }
    return self;
    
}

-(void)destroy {
    [_tuyaRTCEngine destroyRtcEngine];
    
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


## Latest version
1.0.0.0


