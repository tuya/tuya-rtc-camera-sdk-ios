
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
