
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
