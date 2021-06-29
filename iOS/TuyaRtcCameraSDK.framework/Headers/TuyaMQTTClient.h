#import <Foundation/Foundation.h>
#import <WebRTC/RTCIceCandidate.h>
#import <WebRTC/RTCSessionDescription.h>

@protocol TuyaMQTTClientDelegate <NSObject>
-(void)didReceiveCandidate:(NSString*)deviceId
                 sessionId:(NSString*)sessionId
                 candidate:(NSString*)candidate;

-(void)didReceiveAnswer:(NSString*)deviceId
              sessionId:(NSString*)sessionId
                    sdp:(NSString*)sdp;

-(void)didReceiveDisconnect:(NSString*)deviceId
                  sessionId:(NSString*)sessionId;

@end


@interface TuyaMQTTClient : NSObject

+(instancetype) getInstance;

-(void)initWithClientID:(NSString*)clientId
               secretId:(NSString*)secretId
             authCodeId:(NSString*)authCodeId
             regionCode:(NSString*)regionCode
               delegate:(id<TuyaMQTTClientDelegate>)delegate;

-(BOOL) connectToHost;

-(void) disconnectFromHost;


-(BOOL) getToken;

-(BOOL) getMqttConfig;



-(NSDictionary*) getWebRTCConfigWithDid:(NSString*)deviceId;

-(BOOL) prepare;

- (void)sendCandidateWithDeviceId:(NSString*)deviceId
                        candidate:(RTC_OBJC_TYPE(RTCIceCandidate) *)candidate
                     webrtcConfig:(NSDictionary*)webrtcConfig;

- (void)sendOfferSdpWithDeviceId:(NSString*)deviceId
                             sdp:(RTC_OBJC_TYPE(RTCSessionDescription) *)sdp
                    webrtcConfig:(NSDictionary*)webrtcConfig;



@property(nonatomic, strong) id<TuyaMQTTClientDelegate> delegate;


@end

