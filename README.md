
## Tuya RTC Camera SDK — RTC Camera Audio and Video Development Kit



[English](README.md) | [中文版](README-zh.md)

## Overview
Tuya RTC Camera SDK is a comprehensive solution for audio and video development based on the WebRTC technology. With this SDK, you can easily access the Tuya IoT Cloud and implement interactions with `Powered by Tuya` devices. The core feature of this SDK is audio and video processing and control. Specifically, this SDK allows users to:
- Preview content from cameras.
- Record content from cameras.
- Capture and save images in the JPEG format.
- Interact with cameras.

## Integrate with the SDK
###  Step 1
Modify the following parameters of the method `- (instancetype)initWithFrame:(CGRect)frame` in the file `ARDVideoCallView.m`.
``` c
    ...
    _clientId = @"input your client id";
    _secret = @"input your secret";
    _authCode = @"input the auth code";
    _deviceId = @"input the device id";
    ...
``` 

### Step 2
Set `regionCode` to the value that matches your region. For more information, see *RegionCode Comparison Table*.
In the following example, `regionCode` is set to `cn` for the region (Hangzhou, Zhejiang Province, China).
```c
[[TuyaRTCEngine alloc] initRtcEngineWithClientId:clientId 
                                        secretId:secret 
                                        authCodeId:authCode 
                                        regionCode:@"cn" 
                                        delegate:delegate];
```

### Step 3
Copy the library files: Copy the framework files from one of the library versions and paste them to a directory of the current project to make sure that the library can be linked as expected.


## Capabilities

**API description**

**TuyaRTCEngine**

| Parameter | Description |
| :------------ | :------------------------------------------------------------------- |
| initRtcEngineWithClientId:secretId:authCodeId:regionCode:delegate: | Initializes the engine. |
| destroyRtcEngine | Destroys the engine. |
| createTuyaCameraWithDid:  | Creates an object of `TuyaRTCCamera`. The object corresponds to a camera or a stream. |
| destroyTuyaCameraWithDid:  | Destroys an object of `TuyaRTCCamera`. |
| setLogConfigureWith:loggerHandler:level | Sets the log output of the SDK. |
| getSdkVersion | Returns information about the SDK version. |
| getBuildTime | Returns the build time of the SDK. |


**TuyaRTCCamera**
| Parameter | Description |
| :------------ | :------------------------------------------------------------------- |
| startPreview | Starts previewing content from a camera. |
| stopPreview | Stops previewing content from a camera.
| startRecord | Starts recording content from a camera. |
| stopRecord | Stops recording content from a camera. |
| snapShot | Captures an image from a camera. |
| muteAudio | Disables camera sound. |
| muteVideo | Switches a camera video screen on or off. |
| getRemoteAudioMute | Returns the mute status of a camera. |
| getRemoteVideoMute | Returns the video screen status of a camera. |


**TuyaRTCEngineHandler**
| Parameter | Description |
| :------------ | :------------------------------------------------------------------- |
| didInitalized | The callback function of successful SDK initialization. |
| diDestroyed | The callback function of successful destruction with the SDK. |

**TuyaRTCCameraHandler**
| Parameter | Description |
| :------------ | :------------------------------------------------------------------- |
| rtcCamera:didVideoFrame | The video data callback function for the current camera. |
| rtcCamera:didFristVideoFrameWith:andHeight  | The callback function for the first video frame from the current camera. |
| rtcCamera:didResolutionChangedWithOldWidth:andOldHeight:andNewWidth:andNewHeight: | The callback function that is executed when the video resolution of the current camera changes. |

## RegionCode Comparison Table
| Region abbreviation | Region |
| :------------ | :------------------------------------------------------------------- |
| cn | China |
| us | America |
| eu | Europe |
| in | India |
| ue | America Azure |
| we | Europe MS |


## References
For more information, see the API documentation located in the `doc/html` directory. Before you read these documents, download the sample code to your local directory and open `index.html` in your browser.

## Constraints
- Only one `TuyaRTCEngine` engine can be used for an application.
- Multiple objects of `TuyaRTCCamera` can be created with different values of `device id`.
- The application must be in the preview state during the recording, snapshot, or mute operations. Otherwise, the application might not run as expected.


## Our mission
This SDK applies to redevelopment based on the WebRTC technology, and currently only supports simple audio and video features and smart scenes. If you have found more interesting ways to play with the current or subsequent WebRTC releases from Google, please contact us. Let's build a more robust and meaningful Tuya IoT ecosystem that provides the ultimate audio and video experience with WebRTC.


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
Version 1.0.0.0


