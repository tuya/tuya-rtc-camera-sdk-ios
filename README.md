
## Tuya RTC Camera SDK



[中文版](README-zh.md)|[English](README.md)|

## Features Overview
TuyaRTCCamera SDK is a comprehensive solution for audio and video based on WebRTC technology,
through this SDK you can easily access Tuya IoT Colud and then perform a number of interactive
operations on Tuya IoT devices.
This SDK allows you to easily access the Tuya IoT Colud and perform a number of interactive
operations, especially for audio and video processing and control is the core function of this SDK.
- Preview Camera's content
- Recording Camera's content
- JPEG screen capture
- Support for interacting with the camera

## Steps to integrate the SDK
### First step
Modify some parameters in MainActivity.java to the appropriate ones
``` c
    ...
    _clientId = @"input your client id";
    _secret = @"input your client id";
    _deviceId = @"input your client id";
    _authCode = @"input your client id";
    ...
``` 
### Step 2
Copy the library files
- In the current project directory, if there is no directory for the library files, execute `mkdir libs` to create a new directory
- Copy the aar file from one of the Libraries versions to the created libs directory

## Capabilities Overview

**Interface Description**

**TuyaRTCEngine Interface Description**

| Parameters | Description |
| :------------ | :------------------------------------------------------------------- |
| initRtcEngineWithClientId:secretId:authCodeId:regionCode:delegate: | Engine initialization |
| destoryRtcEngine | Destroy the engine
| createTuyaCameraWithDid:  | Creates a TuyaRTCCamera object, each object corresponds to a Camera or Stream.
| destoryTuyaCameraWithDid:  | Destroy a TuyaRTCCamera object |
| setLogConfigureWith:loggerHandler:level | Set the log output of the SDK. | getSdkVersion
| getSdkVersion | Get the SDK version information.
| getBuildTime | Get the SDK build time |


**TuyaRTCCamera interface description**
| parameters | description |
| :------------ | :------------------------------------------------------------------- |
| startPreview | Start previewing the contents of the Camera |
| stopPreview | Stop previewing the content of the camera.
| startRecord | Start recording the contents of the camera |
| stopRecord | stop recording the content of the Camera
| snapShot | Snap a picture of the camera
| genMp4Thumbnail | Generate the cover of an MP4 file |
| muteAudio | Mute the camera's sound
| muteVideo | Switch the camera screen on/off
| getRemoteAudioMute | Get the mute state of the camera sound.
| getRemoteVideoMute | Get the on/off state of the Camera video


**TuyaRTCEngineHandler interface description**
| parameters | description |
| :------------ | :------------------------------------------------------------------- |
| didLogMessageWith: | The log output callback function in the SDK |
| didInitalized | Callback function for successful SDK initialization |
| didDestoryed | Callback function for successful destruction of the SDK

**TuyaRTCCameraHandler interface description**
| parameters | description |
| :------------ | :------------------------------------------------------------------- |
| rtcCamera:didVideoFrame | The video data callback function for the current camera.
| rtcCamera:didFristVideoFrameWith:andHeight  | The callback function for the first video frame of the current Camera.
| rtcCamera:didResolutionChangedWithOldWidth:andOldHeight:andNewWidth:andNewHeight: | The callback function when the video resolution of the current Camera changes.

## RegionCode Comparison Table
| region abbreviation | range |
| :------------ | :------------------------------------------------------------------- |
| cn | China |
| us | America |
| eu | Europe |
| in | India |
| we | WesternEurope
| we | WesternEurope |



## Latest version
1.0.0.1


