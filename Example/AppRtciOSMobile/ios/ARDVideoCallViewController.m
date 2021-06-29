/*
 *  Copyright 2015 The WebRTC Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import "ARDVideoCallViewController.h"

#import "WebRTC/RTCMediaConstraints.h"
#import "WebRTC/RTCLogging.h"
#import "WebRTC/RTCAudioSession.h"
#import "WebRTC/RTCCameraVideoCapturer.h"
#import "WebRTC/RTCDispatcher.h"
#import "WebRTC/RTCVideoTrack.h"
#import "WebRTC/RTCPeerConnection.h"

#import "ARDVideoCallView.h"

@interface ARDVideoCallViewController () <ARDVideoCallViewDelegate,
                                          RTC_OBJC_TYPE (RTCAudioSessionDelegate)>
@property(nonatomic, readonly) ARDVideoCallView *videoCallView;
@end

@implementation ARDVideoCallViewController {
    
}

@synthesize videoCallView = _videoCallView;

@synthesize delegate = _delegate;

- (instancetype)initForRoom:(NSString *)room
                   delegate:(id<ARDVideoCallViewControllerDelegate>)delegate {
  if (self = [super init]) {
    _delegate = delegate;

  }
  return self;
}

- (void)loadView {
  _videoCallView = [[ARDVideoCallView alloc] initWithFrame:CGRectZero];
  _videoCallView.delegate = self;
  _videoCallView.statusLabel.text =
      [self statusTextForState:RTCIceConnectionStateNew];
  self.view = _videoCallView;
    
    

}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskAll;
}

#pragma mark - ARDAppClientDelegate


#pragma mark - ARDVideoCallViewDelegate

- (void)videoCallViewDidHangup:(ARDVideoCallView *)view {
  [self hangup];
}

- (void)videoCallView:(ARDVideoCallView *)view
    shouldSwitchCameraWithCompletion:(void (^)(NSError *))completion {
}

- (void)videoCallView:(ARDVideoCallView *)view
    shouldChangeRouteWithCompletion:(void (^)(void))completion {
  NSParameterAssert(completion);


}

- (void)videoCallViewDidEnableStats:(ARDVideoCallView *)view {
}

#pragma mark - RTC_OBJC_TYPE(RTCAudioSessionDelegate)

- (void)audioSession:(RTC_OBJC_TYPE(RTCAudioSession) *)audioSession
    didDetectPlayoutGlitch:(int64_t)totalNumberOfGlitches {
  RTCLog(@"Audio session detected glitch, total: %lld", totalNumberOfGlitches);
}

#pragma mark - Private


- (void)hangup {
  _videoCallView.localVideoView.captureSession = nil;
 
  [_delegate viewControllerDidFinish:self];
}

- (NSString *)statusTextForState:(RTCIceConnectionState)state {
  switch (state) {
    case RTCIceConnectionStateNew:
    case RTCIceConnectionStateChecking:
      return @"Connecting...";
    case RTCIceConnectionStateConnected:
    case RTCIceConnectionStateCompleted:
    case RTCIceConnectionStateFailed:
    case RTCIceConnectionStateDisconnected:
    case RTCIceConnectionStateClosed:
    case RTCIceConnectionStateCount:
      return nil;
  }
}

- (void)showAlertWithMessage:(NSString*)message {
  UIAlertController *alert =
      [UIAlertController alertControllerWithTitle:nil
                                          message:message
                                   preferredStyle:UIAlertControllerStyleAlert];

  UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action){
                                                        }];

  [alert addAction:defaultAction];
  [self presentViewController:alert animated:YES completion:nil];
}

@end
