import 'dart:async';

import 'package:flutter/services.dart';

class FaceFinder {
  static const MethodChannel _channel =
      const MethodChannel('face_finder');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<int> cameraViewer(List position, String url) async {

    final Map<String, dynamic> params = <String, dynamic>{
      'position': position,
      'url': url
    };

    await _channel.invokeMethod('getCameraViewer', params);
  }
}
