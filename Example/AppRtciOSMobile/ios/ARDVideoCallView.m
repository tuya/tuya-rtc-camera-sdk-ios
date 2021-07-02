/*
 *  Copyright 2015 The WebRTC Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import "ARDVideoCallView.h"

#import <AVFoundation/AVFoundation.h>

#import "WebRTC/RTCEAGLVideoView.h"
#if defined(RTC_SUPPORTS_METAL)
#import "WebRTC/RTCMTLVideoView.h"  // nogncheck
#endif

#import "UIImage+ARDUtilities.h"

#import "P2PEngine.h"

static CGFloat const kButtonPadding = 16;
static CGFloat const kButtonSize = 48;
static CGFloat const kLocalVideoViewSize = 120;
static CGFloat const kLocalVideoViewPadding = 8;
static CGFloat const kStatusBarHeight = 20;

@interface ARDVideoCallView () <RTC_OBJC_TYPE (RTCVideoViewDelegate)>
@end

@implementation ARDVideoCallView {
    UIButton *_routeChangeButton;
    UIButton *_cameraSwitchButton;
    UIButton *_hangupButton;
    CGSize _remoteVideoSize;
    
    NSString* _clientId;
    NSString* _secret;
    NSString* _deviceId;
    NSString* _authCode;

    P2PEngine* _p2pEngine;
    BOOL _isStartPreview;
    BOOL _isStartRecord;
}

@synthesize statusLabel = _statusLabel;
@synthesize localVideoView = _localVideoView;
@synthesize remoteVideoView = _remoteVideoView;
@synthesize delegate = _delegate;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
#if defined(RTC_SUPPORTS_METAL)
        _remoteVideoView = [[RTC_OBJC_TYPE(RTCMTLVideoView) alloc] initWithFrame:CGRectZero];
#else
        RTC_OBJC_TYPE(RTCEAGLVideoView) *remoteView =
        [[RTC_OBJC_TYPE(RTCEAGLVideoView) alloc] initWithFrame:CGRectZero];
        remoteView.delegate = self;
        _remoteVideoView = remoteView;
#endif
        
        [self addSubview:_remoteVideoView];
        
        _localVideoView = [[RTC_OBJC_TYPE(RTCCameraPreviewView) alloc] initWithFrame:CGRectZero];
        [self addSubview:_localVideoView];
        
        
        _routeChangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _routeChangeButton.backgroundColor = [UIColor grayColor];
        _routeChangeButton.layer.cornerRadius = kButtonSize / 2;
        _routeChangeButton.layer.masksToBounds = YES;
        UIImage *image = [UIImage imageForName:@"ic_surround_sound_black_24dp.png"
                                         color:[UIColor whiteColor]];
        [_routeChangeButton setImage:image forState:UIControlStateNormal];
        [_routeChangeButton addTarget:self
                               action:@selector(onRouteChange:)
                     forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_routeChangeButton];
        
        // TODO(tkchin): don't display this if we can't actually do camera switch.
        _cameraSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cameraSwitchButton.backgroundColor = [UIColor grayColor];
        _cameraSwitchButton.layer.cornerRadius = kButtonSize / 2;
        _cameraSwitchButton.layer.masksToBounds = YES;
        image = [UIImage imageForName:@"ic_switch_video_black_24dp.png" color:[UIColor whiteColor]];
        [_cameraSwitchButton setImage:image forState:UIControlStateNormal];
        [_cameraSwitchButton addTarget:self
                                action:@selector(onCameraSwitch:)
                      forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cameraSwitchButton];
        
        _hangupButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _hangupButton.backgroundColor = [UIColor redColor];
        _hangupButton.layer.cornerRadius = kButtonSize / 2;
        _hangupButton.layer.masksToBounds = YES;
        image = [UIImage imageForName:@"ic_call_end_black_24dp.png"
                                color:[UIColor whiteColor]];
        [_hangupButton setImage:image forState:UIControlStateNormal];
        [_hangupButton addTarget:self
                          action:@selector(onHangup:)
                forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_hangupButton];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLabel.font = [UIFont fontWithName:@"Roboto" size:16];
        _statusLabel.textColor = [UIColor whiteColor];
        [self addSubview:_statusLabel];
        
        UITapGestureRecognizer *tapRecognizer =
        [[UITapGestureRecognizer alloc]
         initWithTarget:self
         action:@selector(didTripleTap:)];
        tapRecognizer.numberOfTapsRequired = 3;
        [self addGestureRecognizer:tapRecognizer];
    }
    
    _clientId = @"jct4wjjgtppxth9vpjeq";
    _secret = @"ns45erx7y9ut8trygwwnfu549eghrmqg";
    _deviceId = @"6ceeb5b251fb016f2aamtp";
    _authCode = @"42601963ffedb3b5f2ca7df11a9fb1eb";

    
    _p2pEngine = [[P2PEngine alloc]initRtcEngine:_clientId secret:_secret authCode:_authCode regionCode:@"cn" delegate:self];
    _isStartRecord = false;
    _isStartPreview = false;
    return self;
}

- (void)layoutSubviews {
    CGRect bounds = self.bounds;
    if (_remoteVideoSize.width > 0 && _remoteVideoSize.height > 0) {
        // Aspect fill remote video into bounds.
        CGRect remoteVideoFrame =
        AVMakeRectWithAspectRatioInsideRect(_remoteVideoSize, bounds);
        CGFloat scale = 1;
        if (remoteVideoFrame.size.width > remoteVideoFrame.size.height) {
            scale = bounds.size.width / remoteVideoFrame.size.width;

            // Scale by height.
        } else {
            // Scale by width.
            scale = bounds.size.height / remoteVideoFrame.size.height;

        }
        remoteVideoFrame.size.height *= scale;
        remoteVideoFrame.size.width *= scale;
        _remoteVideoView.frame = remoteVideoFrame;
        _remoteVideoView.center =
        CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    } else {
        _remoteVideoView.frame = bounds;
    }
    
    // Aspect fit local video view into a square box.
    CGRect localVideoFrame =
    CGRectMake(0, 0, kLocalVideoViewSize, kLocalVideoViewSize);
    // Place the view in the bottom right.
    localVideoFrame.origin.x = CGRectGetMaxX(bounds)
    - localVideoFrame.size.width - kLocalVideoViewPadding;
    localVideoFrame.origin.y = CGRectGetMaxY(bounds)
    - localVideoFrame.size.height - kLocalVideoViewPadding;
    _localVideoView.frame = localVideoFrame;
    
    
    // Place hangup button in the bottom left.
    _hangupButton.frame =
    CGRectMake(CGRectGetMinX(bounds) + kButtonPadding,
               CGRectGetMaxY(bounds) - kButtonPadding -
               kButtonSize,
               kButtonSize,
               kButtonSize);
    
    // Place button to the right of hangup button.
    CGRect cameraSwitchFrame = _hangupButton.frame;
    cameraSwitchFrame.origin.x =
    CGRectGetMaxX(cameraSwitchFrame) + kButtonPadding;
    _cameraSwitchButton.frame = cameraSwitchFrame;
    
    // Place route button to the right of camera button.
    CGRect routeChangeFrame = _cameraSwitchButton.frame;
    routeChangeFrame.origin.x =
    CGRectGetMaxX(routeChangeFrame) + kButtonPadding;
    _routeChangeButton.frame = routeChangeFrame;
    
    [_statusLabel sizeToFit];
    _statusLabel.center =
    CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
}

#pragma mark - RTC_OBJC_TYPE(RTCVideoViewDelegate)

- (void)videoView:(id<RTC_OBJC_TYPE(RTCVideoRenderer)>)videoView didChangeVideoSize:(CGSize)size {
    if (videoView == _remoteVideoView) {
        _remoteVideoSize = size;
    }
    [self setNeedsLayout];

}

#pragma mark - Private

- (void)onCameraSwitch:(UIButton *)sender {
    if (!_isStartPreview) {
        [_p2pEngine startPreview:_deviceId renderer:_remoteVideoView];
    } else {
        [_p2pEngine stopPreview:_deviceId];
    }
    _isStartPreview = !_isStartPreview;
}

- (void)onRouteChange:(UIButton *)sender {
    NSString  *recordPth = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/test.mp4"];
    if (_isStartRecord) {
        [_p2pEngine startRecord:_deviceId mp4File:recordPth];
    } else {
        [_p2pEngine stopRecord:_deviceId];
    }
    _isStartRecord = !_isStartRecord;
//    sender.enabled = false;
//    __weak ARDVideoCallView *weakSelf = self;
//    [_delegate videoCallView:self
//shouldChangeRouteWithCompletion:^(void) {
//        ARDVideoCallView *strongSelf = weakSelf;
//        if (strongSelf) {
//            dispatch_async(dispatch_get_main_queue(), ^(void) {
//                sender.enabled = true;
//            });
//        }
//    }];
}

- (void)onHangup:(id)sender {
    [_p2pEngine destroy];
    [_delegate videoCallViewDidHangup:self];
}

- (void)didTripleTap:(UITapGestureRecognizer *)recognizer {
    [_delegate videoCallViewDidEnableStats:self];
}


-(void) didInitalized {
    NSLog(@"Engine has been initialized.");
}
-(void) didDestroyed {
    NSLog(@"Engine has been destroyed");

}
@end
