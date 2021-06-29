
#import "TuyaRTCCamera.h"
#import <Foundation/Foundation.h>
//#import "WebRTC/RTCPeerConnection.h"
//#import "WebRTC/RTCPeerConnectionFactory.h"
#import "TuyaRTCClient.h"

@class TuyaRTCCamera;

/**
 * 提供给上层调用API初始化camera对象参数之一，用于通知App层一些关于camera（stream）的一些事件通知。
 */
@protocol TuyaRTCCameraDelegate <NSObject>
@required
- (void) rtcCamera:(TuyaRTCCamera*_Nonnull)camera
onTrackVideoDataWithWith:(NSInteger)width
         andHeight:(NSInteger)height
          andYData:(void*_Nonnull) yData
        andYOffset:(NSInteger)yOffset
          andUData:(void*_Nonnull) uData
        andUOffset:(NSInteger)uOffset
          andVData:(void*_Nonnull) vData
        andVOffset:(NSInteger)vOffset;


- (void) rtcCamera:(TuyaRTCCamera*_Nonnull)camera
onTrackAudioDataWithBuffer:(void*_Nonnull)audioData
        andSamples:(NSInteger)samples
 andBytesPerSample:(NSInteger)bytesPerSample
       andChannels:(NSInteger)channels
  andSamplesPerSec:(NSInteger)samplesPerSec
      andTimestamp:(long long)timestamp;


- (void) rtcCamera:(TuyaRTCCamera*_Nonnull)camera
onTrackVolumeIndicationWith:(NSInteger)volume;

- (void) rtcCamera:(TuyaRTCCamera*_Nonnull)camera
onFristVideoFrameWith:(NSInteger)width
         andHeight:(NSInteger)height;

- (void) rtcCamera:(TuyaRTCCamera*_Nonnull)camera
onResolutionChangedWithOldWidth:(NSInteger)oldWidth
      andOldHeight:(NSInteger)oldHeight
       andNewWidth:(NSInteger)newWidth
      andNewHeight:(NSInteger)newHeight;

- (void) rtcCamera:(TuyaRTCCamera*_Nonnull)camera
onFrameWithOpqaueFrame:(void*_Nonnull)opaqueFrame;


@end

/**
 * camera实现类，包含了camera的开始拉流、停止拉流、mute、unmute远端流信息，以及获取mute状态等功能。
 */
@interface TuyaRTCCamera : NSObject <TuyaRTCClientDelegate>
- (instancetype _Nonnull )init NS_UNAVAILABLE;

- (instancetype _Nonnull )initWithDid:(NSString *_Nonnull)did
                    factory:(RTC_OBJC_TYPE(RTCPeerConnectionFactory) *_Nonnull)factory NS_DESIGNATED_INITIALIZER;

- (int) startPreview:(id<RTC_OBJC_TYPE(RTCVideoRenderer)>_Nullable) renderer;
- (int) stopPreview;


- (int) startRecordWithPath:(NSString *_Nonnull) recordName;
- (int) stopRecord;

- (int) snapShot:(NSString *_Nonnull) fileName;


- (int) muteRemoteAudioWith:(BOOL) enable;

- (int) muteRemoteVideoWith:(BOOL) enable;

- (BOOL) getRemoteAudioMute;
- (BOOL) getRemoteVideoMute;


- (void) setRemoteDescription:(NSString*_Nonnull) sdp;
- (void) addRemoteIceCandidate:(NSString*_Nonnull) ice;


- (void) renderFrame:(nullable RTCVideoFrame *)frame;
- (void) setSize:(CGSize)size;

- (void)didRenderDataWithBuffer:(nonnull void *)audioData
                     andSamples:(NSInteger)samples
              andBytesPerSample:(NSInteger)bytesPerSample
                    andChannels:(NSInteger)channels
               andSamplesPerSec:(NSInteger)samplesPerSec;

@property(nonatomic, strong) NSMutableArray * _Nonnull iceServers;
@property(nonatomic, weak, nullable) id<TuyaRTCCameraDelegate> delegate;


@end

