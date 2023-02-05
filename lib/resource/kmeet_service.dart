import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

class KmeetService {
  static Future joinMeeting(
      {required String roomName, required String userName}) async {
    String serverUrl = "https://meet.qa.karkinos.in";

    // Enable or disable any feature flag here
    // If feature flag are not provided, default values will be used
    // Full list of feature flags (and defaults) available in the README
    Map<FeatureFlagEnum, bool> featureFlags = {
      FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
    };
    if (!kIsWeb) {
      // Here is an example, disabling features for each platform
      if (Platform.isAndroid) {
        // Disable ConnectionService usage on Android to avoid issues (see README)
        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      } else if (Platform.isIOS) {
        // Disable PIP on iOS as it looks weird
        featureFlags[FeatureFlagEnum.PIP_ENABLED] = true;
      }
    }
    // Define meetings options here
    var options = JitsiMeetingOptions(room: roomName)
      ..serverURL = serverUrl
      // ..subject = "Meeting with Gunschu"
      ..userDisplayName = userName
      //  ..userEmail = "myemail@email.com"
      ..userAvatarURL = "https://someimageurl.com/image.jpg"

      // ..iosAppBarRGBAColor = iosAppBarRGBAColor.text
      ..audioOnly = true
      ..audioMuted = true
      ..videoMuted = true
      ..featureFlags.addAll(featureFlags)
      ..webOptions = {
        "roomName": roomName,
        "width": "100%",
        "height": "100%",
        "enableWelcomePage": false,
        "chromeExtensionBanner": null,
        "userInfo": {"displayName": userName}
      };

    debugPrint("JitsiMeetingOptions: $options");
    await JitsiMeet.joinMeeting(
      options,
      listener: JitsiMeetingListener(
          onConferenceWillJoin: (message) {
            debugPrint("${options.room} will join with message: $message");
          },
          onConferenceJoined: (message) {
            debugPrint("${options.room} joined with message: $message");
          },
          onConferenceTerminated: (message) {
            debugPrint("${options.room} terminated with message: $message");
          },
          onPictureInPictureWillEnter: (message) {
            debugPrint("_onPictureInPictureEnter ${message}");
          },
          onPictureInPictureTerminated: (message) {
            debugPrint("_onPictureInPictureTerminated ${message}");
          },
          onError: (message) {
            debugPrint("_onPictureInPictureError ${message}");
          },
          genericListeners: [
            JitsiGenericListener(
                eventName: 'readyToClose',
                callback: (dynamic message) {
                  debugPrint("readyToClose callback");
                }),
          ]),
    );
  }
}
