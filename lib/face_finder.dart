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
      'position': [0, 0, 300, 300],
      'url': "https://2l6putdvoi.execute-api.us-east-1.amazonaws.com/dev/upload/iosapp"
    };

    final int textureId = await _channel.invokeMethod('getCameraViewer', params);
    return textureId;
  }
}
