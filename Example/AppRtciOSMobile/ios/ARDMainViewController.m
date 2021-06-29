/*
 *  Copyright 2015 The WebRTC Project Authors. All rights reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree. An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import "ARDMainViewController.h"

#import <AVFoundation/AVFoundation.h>

#import "WebRTC/RTCLogging.h"

#import "WebRTC/RTCDispatcher.h"

#import "ARDMainView.h"
#import "ARDVideoCallViewController.h"

static NSString *const barButtonImageString = @"ic_settings_black_24dp.png";

// Launch argument to be passed to indicate that the app should start loopback immediatly
static NSString *const loopbackLaunchProcessArgument = @"loopback";

@interface ARDMainViewController () <ARDMainViewDelegate,
                                     ARDVideoCallViewControllerDelegate>
@property(nonatomic, strong) ARDMainView *mainView;
@end

@implementation ARDMainViewController {
  BOOL _useManualAudio;
}

@synthesize mainView = _mainView;

- (void)viewDidLoad {
  [super viewDidLoad];
  if ([[[NSProcessInfo processInfo] arguments] containsObject:loopbackLaunchProcessArgument]) {
    [self mainView:nil didInputRoom:@"" ];
  }
}

- (void)loadView {
  self.title = @"AppRTC Mobile";
  _mainView = [[ARDMainView alloc] initWithFrame:CGRectZero];
  _mainView.delegate = self;
  self.view = _mainView;

 

}


+ (NSString *)loopbackRoomString {
  NSString *loopbackRoomString =
      [[NSUUID UUID].UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""];
  return loopbackRoomString;
}

#pragma mark - ARDMainViewDelegate

- (void)mainView:(ARDMainView *)mainView didInputRoom:(NSString *)room {



  // Kick off the video call.
  ARDVideoCallViewController *videoCallViewController =
      [[ARDVideoCallViewController alloc] initForRoom:@"123345"
                                             delegate:self];
  videoCallViewController.modalTransitionStyle =
      UIModalTransitionStyleCrossDissolve;
  videoCallViewController.modalPresentationStyle = UIModalPresentationFullScreen;
  [self presentViewController:videoCallViewController
                     animated:YES
                   completion:nil];
}

- (void)mainViewDidToggleAudioLoop:(ARDMainView *)mainView { 

}



#pragma mark - ARDVideoCallViewControllerDelegate

- (void)viewControllerDidFinish:(ARDVideoCallViewController *)viewController {
    if (![viewController isBeingDismissed]) {
        RTCLog(@"Dismissing VC");
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
    
}

#pragma mark - Private
- (void)showSettings:(id)sender {
    
    
}

- (void)presentViewControllerAsModal:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
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
