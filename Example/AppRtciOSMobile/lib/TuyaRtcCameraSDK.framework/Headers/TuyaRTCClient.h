#import <Foundation/Foundation.h>

#import <WebRTC/RTCPeerConnection.h>
#import <WebRTC/RTCVideoRenderer.h>
#import <WebRTC/RTCVideoTrack.h>
#import <WebRTC/RTCFileVideoCapturer.h>
#import <WebRTC/RTCCameraVideoCapturer.h>
#import <WebRTC/RTCIceCandidate.h>
#import <WebRTC/RTCSessionDescription.h>


@class TuyaRTCClient;
typedef NS_ENUM(NSInteger, RTCClientState) {
    // Disconnected from servers.
    kTuyaRTCClientStateDisconnected,
    // Connecting to servers.
    kTuyaRTCClientStateConnecting,
    // Connected to servers.
    kTuyaRTCClientStateConnected,
};

@protocol TuyaRTCClientDelegate <NSObject>

- (void)rtcClient:(TuyaRTCClient *_Nonnull)client didChangeState:(RTCClientState)state;

- (void)rtcClient:(TuyaRTCClient *_Nonnull)client didChangeConnectionState:(RTCIceConnectionState)state;

- (void)rtcClient:(TuyaRTCClient *_Nonnull)client
didCreateLocalCapturer:(RTC_OBJC_TYPE(RTCCameraVideoCapturer) *_Nonnull)localCapturer;

- (void)rtcClient:(TuyaRTCClient *_Nonnull)client
didReceiveLocalVideoTrack:(RTC_OBJC_TYPE(RTCVideoTrack) *_Nonnull)localVideoTrack;

- (void)rtcClient:(TuyaRTCClient *_Nonnull)client
didReceiveRemoteVideoTrack:(RTC_OBJC_TYPE(RTCVideoTrack) *_Nonnull)remoteVideoTrack;

- (void)rtcClient:(TuyaRTCClient *_Nonnull)client didError:(NSError *_Nonnull)error;

- (void)rtcClient:(TuyaRTCClient *_Nonnull)client didGetStats:(NSArray *_Nullable)stats;


- (void)rtcClient:(TuyaRTCClient *_Nonnull)client didIceCandidateMessage:(RTC_OBJC_TYPE(RTCIceCandidate)*_Nonnull)candidate;

- (void)rtcClient:(TuyaRTCClient *_Nonnull)client didIceCandidateRemovedMessage:(NSArray<RTC_OBJC_TYPE(RTCIceCandidate) *> *_Nonnull)candidates;

- (void)rtcClient:(TuyaRTCClient *_Nonnull)client didLocalDescriptionStringMessage:(RTC_OBJC_TYPE(RTCSessionDescription) *_Nonnull)sdp;

- (void)rtcClient:(TuyaRTCClient *_Nonnull)clinet
didChangeIceGatheringState:(RTC_OBJC_TYPE(RTCIceGatheringState))newState;





@optional
//- (void)appClient:(TuyaRTCClient *)client
//    didCreateLocalFileCapturer:(RTC_OBJC_TYPE(RTCFileVideoCapturer) *)fileCapturer;

//- (void)rtcClient:(TuyaRTCClient *)client
//    didCreateLocalExternalSampleCapturer:(ARDExternalSampleCapturer *)externalSampleCapturer;

@end
@interface TuyaRTCClient : NSObject <RTC_OBJC_TYPE (RTCPeerConnectionDelegate)>


-(instancetype _Nonnull )initRtcClientWithFactory:(RTC_OBJC_TYPE(RTCPeerConnectionFactory) *_Nonnull)factory
                                         delegate:(id<TuyaRTCClientDelegate>_Nonnull)delegate;

-(void)createPeerConnection:(NSMutableArray *_Nonnull)iceServers;

-(void)disconnect;

-(void) setRemoteDescription:(NSString*_Nonnull) sdp;
-(void) setRemoteIceCandidate:(NSString*_Nonnull) ice;



-(void) setVideoEnabled:(BOOL) enable;
-(void) setAudioEnabled:(BOOL) enable;

-(BOOL) getVideoEnable;
-(BOOL) getAudioEnable;


@property(nonatomic, weak, nullable) id<TuyaRTCClientDelegate> delegate;
@property(nonatomic, strong) RTCPeerConnection * _Nonnull peerConnection;
@property(nonatomic, strong) RTCMediaConstraints * _Nonnull defaultPeerConnectionConstraints;


@end

