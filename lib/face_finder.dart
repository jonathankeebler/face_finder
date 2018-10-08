import 'dart:async';

import 'package:flutter/services.dart';

class FaceFinder {
  static const MethodChannel _channel =
      const MethodChannel('face_finder');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<int> get cameraViewer async {

    final Map<String, dynamic> params = <String, dynamic>{
      'position': [0, 0, 0, 0],
      'url': "https://requestbin.fullcontact.com/1f0qm7z1"
    };

    final int textureId = await _channel.invokeMethod('getCameraViewer', params);
    return textureId;
  }
}
