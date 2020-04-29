import 'dart:async';

import 'package:flutter/services.dart';

class ExternalStoragePath {
  static const MethodChannel _channel = const MethodChannel('ExternalStorage');

  static Future<String> get externalStoragePath async {
    final String sdPath = await _channel.invokeMethod('getExternalStoragePath');
    return sdPath;
  }

  static Future<Map> get externalSpaceInfo async {
    final Map spaceInfo =
        await _channel.invokeMapMethod("getExternalSpaceInfo");
    return spaceInfo;
  }
}
