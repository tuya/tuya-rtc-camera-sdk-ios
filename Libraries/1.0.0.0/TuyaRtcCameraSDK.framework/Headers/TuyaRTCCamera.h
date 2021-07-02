
#import <TuyaRtcCameraSDK/TuyaRTCCamera.h>
#import <Foundation/Foundation.h>
//#import "WebRTC/RTCPeerConnection.h"
//#import "WebRTC/RTCPeerConnectionFactory.h"
#import <TuyaRtcCameraSDK/TuyaRTCClient.h>

@class TuyaRTCCamera;

/**
 * A delegate of the Camera (stream) class,
 * through which some audio and video status of the device (stream) can be provided,
 * as well as some audio and video data callbacks
 */
@protocol TuyaRTCCameraDelegate <NSObject>
@required
/**
 * This method is called when the first frame is received from the device (Stream)
 * and decoded to get the width and height information of the video
 * @param camera The holder of the camera object
 * @param width Width of the picture
 * @param height Height of the picture
 */
- (void) rtcCamera:(TuyaRTCCamera*_Nonnull)camera
didFristVideoFrameWith:(NSInteger)width
         andHeight:(NSInteger)height;

/**
 * This method will be called when the width and height of the video screen obtained
 * from the device (Stream) changes
 * @param camera  The holder of the camera object
 * @param oldWidth The width of the picture before the change
 * @param oldHeight  The height of the picture before the change
 * @param newWidth Width of the current picture
 * @param newHeight Height of the current picture
 */
- (void) rtcCamera:(TuyaRTCCamera*_Nonnull)camera
didResolutionChangedWithOldWidth:(NSInteger)oldWidth
      andOldHeight:(NSInteger)oldHeight
       andNewWidth:(NSInteger)newWidth
      andNewHeight:(NSInteger)newHeight;

/**
 *
 * @param camera The holder of
 * @param frame Video data
 * @see org.webrtc.VideoFrame
 */
- (void) rtcCamera:(TuyaRTCCamera*_Nonnull)camera
     didVideoFrame:(void*_Nonnull)frame;


@end

/**
 * This class mainly wraps some operations of Camera (stream),
 * you can achieve the preview, recording, capture,
 * and other related functions through the interface provided by the class,
 * but also audio and video mute query and control,
 * as well as some advanced parameter control interface
 */
@interface TuyaRTCCamera : NSObject <TuyaRTCClientDelegate>
- (instancetype _Nonnull )init NS_UNAVAILABLE;


/**
 * Start previewing the video data of a Camera(stream)
 * @param renderer The class of rendering data, through this parameter you can get the real video data,using this data, you can complete the rendering of the video
 * @param delegate The delegate of the Camera(stream)
 * @return >0 Success, <0 Failure
 */
- (int) startPreview:(id<RTC_OBJC_TYPE(RTCVideoRenderer)>_Nullable) renderer
            delegate:(id<TuyaRTCCameraDelegate>_Nullable) delegate;
/**
 * Stop previewing the video data of a Camera (stream)
 * @return 0
 */
- (int) stopPreview;

/**
 * Turn on MP4 recording
 * @param recordName Name of the recording file
 * @return true
 */
- (int) startRecordWithPath:(NSString *_Nonnull) recordName;

/**
 * Turn off MP4 recording
 * @return true
 */
- (int) stopRecord;

/**
 * Image capture of the current Camera (stream)
 * @param fileName The path name of the jpg file
 * @return 0
 */
- (int) snapShot:(NSString *_Nonnull) fileName;

/**
 * mute the audio of a Camera (stream), after the mute succeeds,
 * we will not hear the sound from the remote Camera (stream)
 * @param enable Mute value
 * @return 0 Success, -1 Failure
 */
- (int) muteRemoteAudioWith:(BOOL) enable;

/**
 * After a successful mute operation on a Camera (stream) video,
 * we will not see the real content of the video Camera (stream) from the sound
 * * @param enable  Mute value
 * @return 0 Success, -1 Failure
 */
- (int) muteRemoteVideoWith:(BOOL) enable;

/**
 * Get the audio status of the remote Camera (stream)
 * @return true in mute state, false in non-mute state
 */
- (BOOL) getRemoteAudioMute;


/**
 * Get the video status of the remote Camera(stream)
 * @return true in mute state, false in non-mute state
 */
- (BOOL) getRemoteVideoMute;


@property(nonatomic, weak, nullable) id<TuyaRTCCameraDelegate> delegate;


@end

